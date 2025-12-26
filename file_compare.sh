#!/bin/bash

# Script: file_compare.sh
# Usage: ./file_compare.sh <file1> <file2> [options]
# Options:
#   --side     Side-by-side comparison
#   --visual   Open in vimdiff (visual mode, if vim is installed)
#   --brief    Only report if files differ (no detailed output)

MODE="normal"  # Default: unified diff with color

# Parse options
while [[ "$1" == --* ]]; do
    case "$1" in
        --side)    MODE="side" ;;
        --visual)  MODE="visual" ;;
        --brief)   MODE="brief" ;;
        --help|-h) 
            echo "Usage: $0 <file1> <file2> [--side] [--visual] [--brief] [--help]"
            echo "Examples:"
            echo "  $0 old.txt new.txt          # Default colored unified diff"
            echo "  $0 config1.conf config2.conf --side  # Side-by-side view"
            echo "  $0 script1.sh script2.sh --visual    # Visual diff in vim"
            exit 0
            ;;
        *) echo "Unknown option: $1. Use --help for usage."; exit 1 ;;
    esac
    shift
done

# Require two files
if [ $# -lt 2 ]; then
    echo "Error: Provide two files to compare."
    echo "Usage: $0 <file1> <file2> [options]"
    exit 1
fi

file1="$1"
file2="$2"

# Check if files exist and are readable
for file in "$file1" "$file2"; do
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' does not exist."
        exit 1
    fi
    if [ ! -r "$file" ]; then
        echo "Error: File '$file' is not readable."
        exit 1
    fi
done

echo "Comparing '$file1' and '$file2'..."
echo "-------------------------------------------------"

if [ "$MODE" = "visual" ]; then
    if command -v vimdiff >/dev/null 2>&1; then
        vimdiff "$file1" "$file2"
    else
        echo "Error: vimdiff not found. Install vim or use other options."
        exit 1
    fi
elif [ "$MODE" = "brief" ]; then
    diff -q "$file1" "$file2"
elif [ "$MODE" = "side" ]; then
    diff --color=always -y "$file1" "$file2" | less -R
else
    # Default: unified diff with color, paged for long output
    if command -v colordiff >/dev/null 2>&1; then
        colordiff -u "$file1" "$file2" | less -R
    else
        diff --color=always -u "$file1" "$file2" | less -R
    fi
fi

if [ $? -eq 0 ]; then
    echo "No differences found."
else
    echo "Differences displayed above."
fi