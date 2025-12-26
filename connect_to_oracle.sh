#!/bin/bash

# Script: oracle_connect.sh
# Usage: ./oracle_connect.sh [host] [port] [service_name_or_sid]
# Example: ./oracle_connect.sh mydb.example.com 1521 ORCL

# Default values (common for Oracle)
HOST="${1:-localhost}"
PORT="${2:-1521}"
SERVICE="${3:-XE}"  # Common default service name; change to your SID or service

echo "Connecting to Oracle Database..."
echo "Host: $HOST"
echo "Port: $PORT"
echo "Service/SID: $SERVICE"
echo "-------------------------------------------------"

# Prompt for username and password securely (no echo for password)
read -p "Enter Oracle username: " USERNAME
read -s -p "Enter Oracle password: " PASSWORD
echo  # New line after password input

# Check if sqlplus is available
if ! command -v sqlplus &> /dev/null; then
    echo "Error: sqlplus not found. Install Oracle Instant Client or full client."
    exit 1
fi

# Connection string (Easy Connect format: host:port/service)
CONNECT_STRING="${USERNAME}/${PASSWORD}@${HOST}:${PORT}/${SERVICE}"

# Run sqlplus in silent mode, execute a test query, and capture output
RESULT=$(sqlplus -S -L "$CONNECT_STRING" << EOF
SET PAGESIZE 0
SET FEEDBACK OFF
SET HEADING OFF
SELECT 'Connection successful! Current date: ' || SYSDATE FROM DUAL;
EXIT;
EOF
)

# Check exit status of sqlplus
if [ $? -eq 0 ]; then
    echo "-------------------------------------------------"
    echo "Success:"
    echo "$RESULT"
else
    echo "-------------------------------------------------"
    echo "Connection failed. Check credentials, host, port, service name, or network."
    echo "Error output:"
    echo "$RESULT"
fi