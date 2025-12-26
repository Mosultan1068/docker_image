#!/bin/bash

# Script to search for a word in a file

echo "Enter the filename (including path if needed):"
read filename

# Check if file exists
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist or is not a regular file."
    exit 1
fi

echo "Enter the word to search for:"
read word

# Search for the word (case-insensitive, show line numbers)
echo "Searching for '$word' in '$filename'..."
grep -i -n "$word" "$filename"

# Check if any matches were found
if [ $? -eq 0 ]; then
    echo "Search complete: Matches found above."
else
    echo "No matches found for '$word'."
fi

