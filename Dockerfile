FROM mcr.microsoft.com/mssql/server:2022-latest

# Set environment variables for SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=YourStrong@Passw0rd
ENV MSSQL_PID=Developer

# Copy startup script
COPY start-sqlserver.sh /opt/mssql/bin/start-sqlserver.sh

# Copy SQL initialization script
COPY create-database.sql /opt/mssql/scripts/create-database.sql

# Expose SQL Server port
EXPOSE 1433

# Switch to root to install additional tools if needed
USER root

# Create directories for custom scripts
RUN mkdir -p /opt/mssql/scripts

# Make startup script executable
RUN chmod +x /opt/mssql/bin/start-sqlserver.sh

# Convert Windows line endings to Unix line endings
RUN sed -i 's/\r$//' /opt/mssql/bin/start-sqlserver.sh

# Switch back to mssql user
USER mssql

# Start SQL Server using custom script
CMD ["/opt/mssql/bin/start-sqlserver.sh"]
