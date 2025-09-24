#!/bin/bash

# Set default password if SA_PASSWORD is not set or empty
if [ -z "$SA_PASSWORD" ]; then
    export SA_PASSWORD="password"
fi

# Start SQL Server in background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to start
sleep 30

# Run database creation script
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i /opt/mssql/scripts/create-database.sql

# Keep SQL Server running in foreground
wait
