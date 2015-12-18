DROP DATABASE IF EXISTS oci_db;
DROP USER IF EXISTS oci_user;
CREATE USER oci_user PASSWORD 'welcome';
CREATE DATABASE oci_db owner oci_user ENCODING = 'UTF-8';

-- Jeremy 2015-08-10: the "create extension hstore" needs to be called one per database, and with a superuser database user (here as this script is run as postgres user by the python script, it will connect to oci_db as postgres, and so, it will work)
\c oci_db
CREATE EXTENSION hstore;
CREATE EXTENSION pgcrypto;