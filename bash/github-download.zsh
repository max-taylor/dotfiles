#!/usr/bin/env zsh

# GitHub Folder Downloader Script
# Downloads a specific folder from a GitHub repository while preserving folder structure

download_github_folder() {
    local github_url="$1"
    local output_dir="$2"
    
    # Validate input
    if [[ -z "$github_url" ]]; then
        echo "Error: GitHub URL is required"
        echo "Usage: download_github_folder <github_url> [output_directory]"
        return 1
    fi
    
    # Set default output directory if not provided
    if [[ -z "$output_dir" ]]; then
        output_dir="."
    fi
    
    # Extract components from GitHub URL
    # Expected format: https://github.com/owner/repo/tree/branch/path/to/folder
    if [[ ! "$github_url" =~ "^https://github\.com/([^/]+)/([^/]+)/tree/([^/]+)/(.+)$" ]]; then
        echo "Error: Invalid GitHub URL format"
        echo "Expected format: https://github.com/owner/repo/tree/branch/path/to/folder"
        return 1
    fi
    
    # Parse URL components using zsh parameter expansion
    local url_without_protocol="${github_url#https://github.com/}"
    local owner="${url_without_protocol%%/*}"
    url_without_protocol="${url_without_protocol#*/}"
    local repo="${url_without_protocol%%/*}"
    url_without_protocol="${url_without_protocol#*/}"
    url_without_protocol="${url_without_protocol#tree/}"
    local branch="${url_without_protocol%%/*}"
    local folder_path="${url_without_protocol#*/}"
    
    echo "Repository: $owner/$repo"
    echo "Branch: $branch"
    echo "Folder path: $folder_path"
    echo "Output directory: $output_dir"
    echo ""
    
    # Create temporary directory
    local temp_dir=$(mktemp -d)
    trap "rm -rf $temp_dir" EXIT
    
    echo "Downloading repository archive..."
    
    # Download the repository as a zip file
    local zip_url="https://github.com/$owner/$repo/archive/$branch.zip"
    local zip_file="$temp_dir/repo.zip"
    
    if ! curl -L -o "$zip_file" "$zip_url"; then
        echo "Error: Failed to download repository archive"
        return 1
    fi
    
    echo "Extracting archive..."
    
    # Extract the zip file
    if ! unzip -q "$zip_file" -d "$temp_dir"; then
        echo "Error: Failed to extract archive"
        return 1
    fi
    
    # Find the extracted folder (it will be named repo-branch)
    local extracted_folder="$temp_dir/$repo-$branch"
    
    if [[ ! -d "$extracted_folder" ]]; then
        echo "Error: Extracted folder not found"
        return 1
    fi
    
    # Path to the specific folder we want
    local source_folder="$extracted_folder/$folder_path"
    
    if [[ ! -d "$source_folder" ]]; then
        echo "Error: Specified folder path '$folder_path' not found in repository"
        return 1
    fi
    
    echo "Copying files to output directory..."
    
    # Create output directory if it doesn't exist
    mkdir -p "$output_dir"
    
    # Copy the folder contents preserving structure
    cp -r "$source_folder"/* "$output_dir/" 2>/dev/null || {
        # If the above fails, try copying the folder itself
        cp -r "$source_folder" "$output_dir/"
    }
    
    echo "Download completed successfully!"
    echo "Files saved to: $output_dir"
    
    # Show what was downloaded
    echo ""
    echo "Downloaded files:"
    local file_count=0
    for file in $(find "$output_dir" -type f); do
        if (( file_count < 10 )); then
            echo "$file"
        fi
        (( file_count++ ))
    done
    
    if (( file_count > 10 )); then
        echo "... and $(( file_count - 10 )) more files"
    fi
}

# Alternative method using git sparse-checkout (more efficient for large repos)
download_github_folder_git() {
    local github_url="$1"
    local output_dir="$2"
    
    # Validate input
    if [[ -z "$github_url" ]]; then
        echo "Error: GitHub URL is required"
        echo "Usage: download_github_folder_git <github_url> [output_directory]"
        return 1
    fi
    
    # Set default output directory if not provided
    if [[ -z "$output_dir" ]]; then
        output_dir="."
    fi
    
    # Extract components from GitHub URL
    if [[ ! "$github_url" =~ ^https://github\.com/([^/]+)/([^/]+)/tree/([^/]+)/(.+)$ ]]; then
        echo "Error: Invalid GitHub URL format"
        echo "Expected format: https://github.com/owner/repo/tree/branch/path/to/folder"
        return 1
    fi
    
    local owner="${BASH_REMATCH[1]}"
    local repo="${BASH_REMATCH[2]}"
    local branch="${BASH_REMATCH[3]}"
    local folder_path="${BASH_REMATCH[4]}"
    
    echo "Using git sparse-checkout method..."
    echo "Repository: $owner/$repo"
    echo "Branch: $branch"
    echo "Folder path: $folder_path"
    echo ""
    
    # Create temporary directory
    local temp_dir=$(mktemp -d)
    trap "rm -rf $temp_dir" EXIT
    
    # Clone with sparse-checkout
    local repo_url="https://github.com/$owner/$repo.git"
    local clone_dir="$temp_dir/repo"
    
    echo "Cloning repository with sparse-checkout..."
    
    git clone --filter=blob:none --sparse "$repo_url" "$clone_dir" || {
        echo "Error: Failed to clone repository"
        return 1
    }
    
    cd "$clone_dir"
    
    # Checkout the specific branch
    git checkout "$branch" || {
        echo "Error: Failed to checkout branch '$branch'"
        return 1
    }
    
    # Set up sparse-checkout
    git sparse-checkout set "$folder_path" || {
        echo "Error: Failed to set sparse-checkout for '$folder_path'"
        return 1
    }
    
    # Copy the files to output directory
    mkdir -p "$output_dir"
    
    if [[ -d "$folder_path" ]]; then
        cp -r "$folder_path"/* "$output_dir/" 2>/dev/null || {
            cp -r "$folder_path" "$output_dir/"
        }
        echo "Download completed successfully using git sparse-checkout!"
    else
        echo "Error: Folder '$folder_path' not found"
        return 1
    fi
    
    echo "Files saved to: $output_dir"
}

# Main function - tries git method first, falls back to zip method
download_folder() {
    local github_url="$1"
    local output_dir="$2"
    
    if command -v git >/dev/null 2>&1; then
        echo "Git is available, using git sparse-checkout method..."
        download_github_folder_git "$github_url" "$output_dir"
    else
        echo "Git not found, using zip download method..."
        download_github_folder "$github_url" "$output_dir"
    fi
}

# If script is run directly (not sourced), execute the main function
if [[ "${ZSH_EVAL_CONTEXT}" == "toplevel" ]] || [[ "${0}" == "${(%):-%x}" ]]; then
    if [[ $# -eq 0 ]]; then
        echo "GitHub Folder Downloader"
        echo "Usage: $0 <github_url> [output_directory]"
        echo ""
        echo "If no output directory is specified, files will be downloaded to the current directory."
        echo ""
        echo "Example:"
        echo "$0 'https://github.com/solana-developers/program-examples/tree/main/tokens/token-2022/transfer-fee/anchor/programs/transfer-fee'"
        echo "$0 'https://github.com/solana-developers/program-examples/tree/main/tokens/token-2022/transfer-fee/anchor/programs/transfer-fee' './transfer-fee'"
        exit 1
    fi
    
    download_folder "$1" "$2"
fi
