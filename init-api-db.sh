#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE ROLE scarlet_owner;
    CREATE DATABASE scarlet OWNER scarlet_owner;
    \c scarlet
    CREATE SCHEMA scarlet;
    CREATE TABLE scarlet.person(
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL
    );
    INSERT INTO scarlet.person(name)
    VALUES('John Doe'), ('Jane Doe'), ('John Smit');

    CREATE ROLE anonymous NOLOGIN;
    GRANT usage ON SCHEMA scarlet TO anonymous;
    GRANT SELECT ON ALL TABLES IN SCHEMA scarlet TO anonymous;

    CREATE ROLE authenticator NOINHERIT LOGIN PASSWORD 'authpass';
    GRANT anonymous TO authenticator;
EOSQL