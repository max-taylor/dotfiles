#!/usr/bin/env zsh

# Script to concatenate all files in a directory with clear separators
# Copies output to clipboard automatically
# Usage: concat-files <directory-path>

set -e

# Check if directory path is provided
if [ $# -eq 0 ]; then
    echo "Error: No directory path provided"
    echo "Usage: $0 <directory-path>"
    exit 1
fi

DIR_PATH="$1"

# Check if directory exists
if [ ! -d "$DIR_PATH" ]; then
    echo "Error: Directory '$DIR_PATH' does not exist"
    exit 1
fi

# Separator line for visual clarity
SEPARATOR="================================================================================"

# Build output
OUTPUT=""

find "$DIR_PATH" -type f | sort | while read -r file; do
    # Get relative filename
    filename=$(basename "$file")

    # Add separator and filename
    OUTPUT+="$SEPARATOR\n"
    OUTPUT+="FILE: $filename\n"
    OUTPUT+="PATH: $file\n"
    OUTPUT+="$SEPARATOR\n\n"

    # Add file contents
    OUTPUT+="$(cat "$file")\n\n\n"
done

OUTPUT+="$SEPARATOR\n"
OUTPUT+="END OF CONCATENATION\n"
OUTPUT+="$SEPARATOR"

# Copy to clipboard and show confirmation
echo -e "$OUTPUT" | pbcopy
echo "✓ Content copied to clipboard"
