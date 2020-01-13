#!/bin/bash

PGPASSWORD=postgres psql -h localhost -p 5432 -U postgres -f Init.sql
PGPASSWORD=postgres psql -h localhost -p 5432 -U postgres -d scout -f Tables.sql