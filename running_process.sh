#!/bin/bash

# Script: process_details.sh
# Usage: ./process_details.sh [option] [keyword]
# Options:
#   --list     Detailed static list of all processes (default)
#   --top      Interactive real-time monitoring
#   --filter   Search for processes containing a keyword
#   --help     Show this help

MODE="list"  # Default mode

# Parse options
if [ $# -ge 1 ]; then
    case "$1" in
        --list) MODE="list"; shift ;;
        --top)  MODE="top"; shift ;;
        --filter) MODE="filter"; shift ;;
        --help|-h) 
            echo "Usage: $0 [option] [keyword]"
            echo "Options:"
            echo "  --list     Detailed static list (default, uses ps aux)"
            echo "  --top      Interactive monitoring (uses top)"
            echo "  --filter   Filter by keyword (e.g., $0 --filter chrome)"
            echo "  --help     Show this help"
            exit 0
            ;;
        *) echo "Unknown option: $1. Use --help for usage."; exit 1 ;;
    esac
fi

echo "Displaying running process details..."
echo "---------------------------------------------"

if [ "$MODE" = "top" ]; then
    echo "Launching interactive 'top' (press 'q' to quit)..."
    top
elif [ "$MODE" = "filter" ]; then
    if [ -z "$1" ]; then
        echo "Error: Provide a keyword for filtering (e.g., ./process_details.sh --filter ssh)"
        exit 1
    fi
    keyword="$1"
    echo "Processes matching '$keyword':"
    ps aux | grep -i --color=always "$keyword" | grep -v "grep"
elif [ "$MODE" = "list" ]; then
    echo "Full process list (PID, User, CPU%, Mem%, Command):"
    ps aux --sort=-%cpu | head -n 20  # Top 20 by CPU usage for readability
    echo ""
    echo "For full list, run 'ps aux | less'. For interactive view, use --top."
fi

echo "---------------------------------------------"
echo "Done."