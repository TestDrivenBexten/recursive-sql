@echo off
echo Building Docker image...
docker build -t recursive-sql-server .

if %ERRORLEVEL% NEQ 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo Stopping existing container if running...
docker stop sql-server 2>nul
docker rm sql-server 2>nul

echo Starting SQL Server container...
docker run -d -p 1433:1433 --name sql-server recursive-sql-server

if %ERRORLEVEL% NEQ 0 (
    echo Failed to start container!
    pause
    exit /b 1
)

echo SQL Server is starting up...
echo Connect to: localhost:1433
echo Username: sa
echo Password: passwor
echo Database: Genealogy
pause
