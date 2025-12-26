#!/bin/bash

# Script: search_and_replace.sh
# Usage: ./search_and_replace.sh <filename> <search_word> <replace_word> [options]
# Options: --no-backup (skip creating backup), --preview (dry-run only)

# Default: create backup
BACKUP=true
PREVIEW=false

# Parse optional flags
while [[ "$1" == --* ]]; do
    case "$1" in
        --no-backup) BACKUP=false ;;
        --preview) PREVIEW=true ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

# Required arguments
if [ $# -lt 3 ]; then
    echo "Usage: $0 <filename> <search_text> <replace_text> [--no-backup] [--preview]"
    echo "Example: $0 config.txt old_setting new_setting"
    exit 1
fi

filename="$1"
search="$2"
replace="$3"

# Check if file exists and is writable
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist."
    exit 1
fi

if [ ! -w "$filename" ]; then
    echo "Error: File '$filename' is not writable."
    exit 1
fi

# Create backup if requested
if [ "$BACKUP" = true ]; then
    backup_file="${filename}.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$filename" "$backup_file"
    echo "Backup created: $backup_file"
fi

# Preview mode: show what would be changed
if [ "$PREVIEW" = true ]; then
    echo "Preview of changes in '$filename':"
    grep -n --color=always "$search" "$filename" || echo "No matches found."
    echo "Would replace '$search' with '$replace'."
    exit 0
fi

# Perform replacement using sed (in-place with backup if needed)
if [ "$BACKUP" = true ]; then
    sed -i.bak "s/$search/$replace/g" "$filename"
    echo "Replacement complete (with .bak backup by sed)."
else
    sed -i "s/$search/$replace/g" "$filename"
    echo "Replacement complete (no backup)."
fi

echo "All occurrences of '$search' replaced with '$replace' in '$filename'."