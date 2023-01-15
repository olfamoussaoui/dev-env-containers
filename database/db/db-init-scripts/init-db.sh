#!/bin/bash

set -e
set -u

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';
  CREATE DATABASE $APP_DB_NAME;
  ALTER DATABASE $APP_DB_NAME OWNER TO $APP_DB_USER;
  GRANT ALL PRIVILEGES ON DATABASE $APP_DB_NAME TO $APP_DB_USER;
  \connect $APP_DB_NAME $APP_DB_USER
  BEGIN;
    CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	username character varying(45) NOT NULL UNIQUE,
	password character varying(45) NOT NULL
	);
  COMMIT;
EOSQL