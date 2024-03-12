#!/bin/bash

# This script is used to setup a local sonarqube environment and analyze a flutter project
# PREREQUISITES :
#   - The script is in the root flutter project directory
#   - The sonar-project.properties file is present in the same directory as this script

# Check if the sonar_flutter_plugin variable is set
if [ -z "$SONAR_FLUTTER_PLUGIN" ]; then
    echo "Error: SONAR_FLUTTER_PLUGIN is not set. Please set the SONAR_FLUTTER_PLUGIN environment variable."
    exit 1
fi
readonly project_dir="$(dirname "$0")"

readonly sonar_image="sonarqube:10.1.0-community"
readonly sonar_data_volume="sonarqube_data"
readonly sonar_logs_volume="sonarqube_logs"
readonly sonar_extensions_volume="sonarqube_extensions"
readonly sonar_data_dir="/opt/sonarqube/data"
readonly sonar_logs_dir="/opt/sonarqube/logs"
readonly sonar_extensions_dir="/opt/sonarqube/extensions"
readonly sonar_container="sonar"
readonly sonar_port=9000

readonly db_image="postgres"
readonly db_data_volume="sonarpg"
readonly db_data_dir="/var/lib/postgresql/data"
readonly db_container="sonar_db"
readonly db_port=5432
readonly db_user="sonaruser"
readonly db_name="sonarqube"

readonly sonar_admin_user="admin"
readonly sonar_admin_password="admin"
readonly sonar_token_name="sonar_script_token"

# Create the necessary volumes for sonarqube and postgres
for volume in "$sonar_data_volume" "$sonar_logs_volume" "$sonar_extensions_volume" "$db_data_volume"
do
    docker volume create --name "$volume"
done

# Run the postgres container
# Note : no authentication is required because this is a local development environment
docker run -d --name "$db_container" \
	-v "$db_data_volume":"$db_data_dir" \
	-p "$db_port":"$db_port" \
	-e POSTGRES_HOST_AUTH_METHOD=trust \
	"$db_image"

timeout=10
echo "Waiting for the database to start (timeout set to $timeout seconds)..."
counter=0
while [ $counter -lt $timeout ] && \
    ! docker exec "$db_container" pg_isready -h localhost -p "$db_port" >/dev/null 2>&1
do
    sleep 1
done
if [ $counter -eq $timeout ]; then
    echo "Database did not start within the expected time. Exiting..."
    exit 1
fi


# Create the sonar user and database and grant privileges
docker exec -i "$db_container" psql -h localhost -p "$db_port" -U postgres <<EOF
CREATE ROLE "$db_user" LOGIN;
CREATE DATABASE "$db_name" WITH ENCODING 'UTF8' OWNER "$db_user";
EOF

# Run the sonarqube engine container
docker run -d --name "$sonar_container" \
	-p "$sonar_port":"$sonar_port" \
	-e SONAR_JDBC_URL=jdbc:postgresql://host.docker.internal:$db_port/$db_name \
	-e SONAR_JDBC_USERNAME="$db_user" \
	-v "$sonar_data_volume":"$sonar_data_dir" \
	-v "$sonar_logs_volume":"$sonar_logs_dir" \
	-v "$sonar_extensions_volume":"$sonar_extensions_dir" \
	"$sonar_image"

# Copy the flutter plugin into the plugin repo of the sonar container
docker cp "$SONAR_FLUTTER_PLUGIN" "$sonar_container":"${sonar_extensions_dir}/plugins"
docker restart "$sonar_container"

# Install the sonar scanner CLI
brew install sonar-scanner
echo >>/opt/homebrew/etc/sonar-scanner.properties << EOF
sonar.host.url=http://localhost:$sonar_port
EOF

# Generate the sonarqube token and run the sonar scanner
readonly response=$(curl -u "$sonar_admin_user":"$sonar_admin_password" -X POST "http://localhost:$sonar_port/api/user_tokens/generate?name=$sonar_token_name")
readonly token=$(echo "$response" | awk -F'"' '{ for(i=1;i<=NF;i++){ if($i=="token"){ print $(i+2) } } }')
cd "$project_dir"
flutter test --machine --coverage
sonar-scanner -D sonar.token="$token"