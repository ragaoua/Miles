#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE ROLE scarlet_owner;
    CREATE DATABASE scarlet OWNER scarlet_owner;
    \c scarlet
    CREATE SCHEMA scarlet;
    CREATE TABLE scarlet.block(
        id BIGINT PRIMARY KEY,
        name TEXT NOT NULL
    );
    CREATE TABLE scarlet.day(
        id BIGINT PRIMARY KEY,
        block_id BIGINT REFERENCES scarlet.block(id),
        "order" INTEGER NOT NULL
    );
    CREATE TABLE scarlet.session(
        id BIGINT PRIMARY KEY,
        day_id BIGINT REFERENCES scarlet.day(id),
        date DATE NOT NULL
    );
    CREATE TABLE scarlet.movement(
        id BIGINT PRIMARY KEY,
        name TEXT NOT NULL
    );
    CREATE TYPE scarlet.ratingType AS ENUM ('RPE', 'RIR');
    CREATE TABLE scarlet.exercise(
        id BIGINT PRIMARY KEY,
        session_id BIGINT REFERENCES scarlet.session(id),
        movement_id BIGINT REFERENCES scarlet.movement(id),
        "order" INTEGER NOT NULL,
        superorder INTEGER NOT NULL,
        ratingType scarlet.ratingType NOT NULL
    );
    CREATE TABLE scarlet.set(
        id BIGINT PRIMARY KEY,
        exercise_id BIGINT REFERENCES scarlet.exercise(id),
        "order" INTEGER NOT NULL,
        reps INTEGER,
        load NUMERIC,
        rating NUMERIC
    );

    CREATE FUNCTION scarlet.insert_block_with_days(param json) RETURNS void AS \$\$
    DECLARE
        day json;
    BEGIN
        INSERT INTO scarlet.block(id, name)
        VALUES ((param->>'id')::int, param->>'name');

        FOR day IN SELECT * FROM json_array_elements(param->'days')
        LOOP
            INSERT INTO scarlet.day(id, block_id, "order")
            VALUES ((day->>'id')::int, (day->>'blockId')::int, (day->>'order')::int);
        END LOOP;
    END;
    \$\$ LANGUAGE PLPGSQL;

    CREATE ROLE anonymous NOLOGIN;
    GRANT usage ON SCHEMA scarlet TO anonymous;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA scarlet TO anonymous;
    GRANT USAGE ON ALL SEQUENCES IN SCHEMA scarlet TO anonymous;

    CREATE ROLE authenticator NOINHERIT LOGIN PASSWORD 'authpass';
    GRANT anonymous TO authenticator;
EOSQL