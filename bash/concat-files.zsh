#!/usr/bin/env zsh

# Script to recursively concatenate all files in a directory with clear separators
# Copies output to clipboard automatically
# Usage: concat-files <directory-path>

set -e

# Configuration
SEPARATOR="================================================================================"

# Function to validate directory
validate_directory() {
    local dir_path="$1"

    if [ -z "$dir_path" ]; then
        echo "Error: No directory path provided"
        echo "Usage: $0 <directory-path>"
        return 1
    fi

    if [ ! -d "$dir_path" ]; then
        echo "Error: Directory '$dir_path' does not exist"
        return 1
    fi

    return 0
}

# Function to get relative path
get_relative_path() {
    local file="$1"
    local base_dir="$2"
    echo "${file#$base_dir/}"
}

# Function to format file entry
format_file_entry() {
    local file="$1"
    local relative_path="$2"

    echo "$SEPARATOR"
    echo "FILE: $relative_path"
    echo "PATH: $file"
    echo "$SEPARATOR"
    echo ""
    cat "$file"
    echo ""
    echo ""
}

# Function to build concatenated output
build_output() {
    local dir_path="$1"
    local output=""

    # Normalize directory path (remove trailing slash)
    dir_path="${dir_path%/}"

    # Find all files recursively, sort by path
    while IFS= read -r file; do
        local relative_path=$(get_relative_path "$file" "$dir_path")
        output+="$(format_file_entry "$file" "$relative_path")"
    done < <(find "$dir_path" -type f | sort)

    # Add footer
    output+="$SEPARATOR\n"
    output+="END OF CONCATENATION\n"
    output+="$SEPARATOR"

    echo -e "$output"
}

# Function to copy to clipboard
copy_to_clipboard() {
    local content="$1"
    echo -e "$content" | pbcopy
    echo "✓ Content copied to clipboard"
}

# Main execution
main() {
    local dir_path="$1"

    # Validate input
    validate_directory "$dir_path" || exit 1

    # Build output
    local output=$(build_output "$dir_path")

    # Copy to clipboard
    copy_to_clipboard "$output"
}

# Run main function
main "$@"
