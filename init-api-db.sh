#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE ROLE scarlet_owner;
    CREATE DATABASE scarlet OWNER scarlet_owner;
    \c scarlet
    CREATE SCHEMA scarlet;
    CREATE TABLE scarlet.block(
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL
    );
    CREATE TABLE scarlet.day(
        id SERIAL PRIMARY KEY,
        block_id BIGINT REFERENCES scarlet.block(id),
        "order" INTEGER NOT NULL
    );
    CREATE TABLE scarlet.session(
        id SERIAL PRIMARY KEY,
        day_id BIGINT REFERENCES scarlet.day(id),
        date DATE NOT NULL
    );
    CREATE TABLE scarlet.movement(
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL
    );
    CREATE TYPE scarlet.ratingType AS ENUM ('RPE', 'RIR');
    CREATE TABLE scarlet.exercise(
        id SERIAL PRIMARY KEY,
        session_id BIGINT REFERENCES scarlet.session(id),
        movement_id BIGINT REFERENCES scarlet.movement(id),
        "order" INTEGER NOT NULL,
        superorder INTEGER NOT NULL,
        ratingType scarlet.ratingType NOT NULL
    );
    CREATE TABLE scarlet.set(
        id SERIAL PRIMARY KEY,
        exercise_id BIGINT REFERENCES scarlet.exercise(id),
        "order" INTEGER NOT NULL,
        reps INTEGER,
        load NUMERIC,
        rating NUMERIC
    );

    CREATE SCHEMA api;
    CREATE VIEW api.all_blocks AS
        SELECT
            block.id AS "id",
            block.name AS "name",
            session.id AS "session_id",
            session.day_id AS "session_day_id",
            session.date AS "session_date"
        FROM scarlet.block
        LEFT JOIN scarlet.day ON block.id = day.block_id
        LEFT JOIN scarlet.session ON day.id = session.day_id
        ORDER BY
            max(session.date) OVER(PARTITION BY block.id) DESC,
            block.id DESC,
            session.date,
            session.id;

    CREATE ROLE anonymous NOLOGIN;
    GRANT usage ON SCHEMA api TO anonymous;
    GRANT SELECT ON ALL TABLES IN SCHEMA api TO anonymous;

    CREATE ROLE authenticator NOINHERIT LOGIN PASSWORD 'authpass';
    GRANT anonymous TO authenticator;
EOSQL