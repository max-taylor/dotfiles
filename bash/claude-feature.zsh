#!/usr/bin/env zsh
#
## Manually add directories where claude might be installed, adjust as needed:
export PATH="$HOME/.local/bin:$PATH"

# claude-feature - Create feature branch with worktree and run Claude Code
# Usage: claude-feature "implement user authentication"

set -euo pipefail

# Configuration
CLAUDE_CMD="${CLAUDE_CMD:-claude}"
DEFAULT_BASE_BRANCH="${DEFAULT_BASE_BRANCH:-main}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Colo
# Functions
print_error() {
    echo -e "${RED}❌ $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_step() {
    echo -e "${YELLOW}▶️  $1${NC}"
}

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] "task description"

Create a feature branch with git worktree and optionally run Claude Code.

OPTIONS:
    -b, --base BRANCH      Base branch (default: $DEFAULT_BASE_BRANCH)
    -n, --no-claude        Don't start Claude Code after creating worktree
    -c, --claude-args ARGS Additional arguments for Claude Code
    -p, --prefix PREFIX    Branch prefix (default: feature/)
    -h, --help            Show this help

EXAMPLES:
    $(basename "$0") "add user authentication"
    $(basename "$0") -b develop "fix navigation bug"
    $(basename "$0") -n "prepare refactoring branch"
    $(basename "$0") -c "--no-context" "implement new feature"

ENVIRONMENT VARIABLES:
    CLAUDE_CMD              Command to run Claude Code
    DEFAULT_BASE_BRANCH     Default base branch
EOF
}

# Parse arguments
TASK_DESCRIPTION=""
BASE_BRANCH="$DEFAULT_BASE_BRANCH"
RUN_CLAUDE=true
CLAUDE_ARGS=""
BRANCH_PREFIX="feature/"

while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--base)
            BASE_BRANCH="$2"
            shift 2
            ;;
        -n|--no-claude)
            RUN_CLAUDE=false
            shift
            ;;
        -c|--claude-args)
            CLAUDE_ARGS="$2"
            shift 2
            ;;
        -p|--prefix)
            BRANCH_PREFIX="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            TASK_DESCRIPTION="$1"
            shift
            ;;
    esac
done

# Validate arguments
if [[ -z "$TASK_DESCRIPTION" ]]; then
    print_error "Task description is required"
    usage
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

# Get repository info
REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$REPO_ROOT")
PARENT_DIR=$(dirname "$REPO_ROOT")

# Create branch name from task description
BRANCH_NAME=$(echo "$TASK_DESCRIPTION" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-z0-9]/-/g' | \
    sed 's/--*/-/g' | \
    sed 's/^-\|-$//g' | \
    cut -c1-50)
FULL_BRANCH_NAME="${BRANCH_PREFIX}${BRANCH_NAME}"

# Create worktree directory name (repo-name-branch-name)
WORKTREE_DIR_NAME="${REPO_NAME}-${BRANCH_NAME}"
WORKTREE_PATH="${PARENT_DIR}/${WORKTREE_DIR_NAME}"

print_step "Creating feature branch: $FULL_BRANCH_NAME"
print_info "Task: $TASK_DESCRIPTION"
print_info "Base branch: $BASE_BRANCH"
print_info "Worktree path: $WORKTREE_PATH"

# Check if worktree already exists
if [[ -d "$WORKTREE_PATH" ]]; then
    print_error "Worktree already exists at: $WORKTREE_PATH"
    echo "Would you like to remove it and create a new one? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git worktree remove "$WORKTREE_PATH" --force
        print_info "Removed existing worktree"
    else
        exit 1
    fi
fi

# Fetch latest changes
print_step "Fetching latest changes..."
git fetch origin "$BASE_BRANCH" --quiet

# Create worktree
print_step "Creating or reusing git worktree..."

# Check if branch already exists (local or remote)
if git show-ref --verify --quiet "refs/heads/$FULL_BRANCH_NAME"; then
    print_info "Branch $FULL_BRANCH_NAME already exists locally"
elif git ls-remote --exit-code --heads origin "$FULL_BRANCH_NAME" > /dev/null 2>&1; then
    print_info "Branch $FULL_BRANCH_NAME exists on remote"
    git fetch origin "$FULL_BRANCH_NAME:$FULL_BRANCH_NAME"
else
    print_info "Creating new branch $FULL_BRANCH_NAME from $BASE_BRANCH"
    git fetch origin "$BASE_BRANCH"
    git branch "$FULL_BRANCH_NAME" "origin/$BASE_BRANCH"
fi

# Add or reuse worktree
if [[ -d "$WORKTREE_PATH" ]]; then
    print_info "Reusing existing worktree at: $WORKTREE_PATH"
else
    git worktree add "$WORKTREE_PATH" "$FULL_BRANCH_NAME"
    print_success "Worktree created at: $WORKTREE_PATH"
fi


# Save task description for later reference
echo "$TASK_DESCRIPTION" > "$WORKTREE_PATH/.claude-task"

# Save original repo path for easy navigation
echo "$REPO_ROOT" > "$WORKTREE_PATH/.claude-main-repo"

# Run Claude Code if requested
if [[ "$RUN_CLAUDE" == true ]]; then
    print_step "Starting Claude Code..."
    cd "$WORKTREE_PATH"
    
    # Create initial prompt file
    cat > .claude-prompt.md << EOF
# Task: $TASK_DESCRIPTION

I need help implementing this feature. Please:

1. First, analyze the codebase structure to understand the project
2. Create a detailed implementation plan
3. Implement the changes following the project's patterns and conventions
4. Ensure all tests pass and linting is clean
5. Create appropriate commits with conventional commit messages
6. When the feature is complete, push the changes to the remote branch and create a pull request

The task description is: $TASK_DESCRIPTION

This is a new feature branch created from $BASE_BRANCH.
EOF
    print_success "Worktree created and Claude Code starting..."
    print_info "Opening Claude Code with task: $TASK_DESCRIPTION"

    # # Find the full path to claude command
    CLAUDE_FULL_PATH="/Users/maxtaylor/.claude/local/claude"

    print_info "Starting Claude Code in worktree: $WORKTREE_PATH"

    cd "$WORKTREE_PATH" || exit 1

    print_info "Start Claude with the following context: $CLAUDE_ARGS" \
        "Implement feature: $TASK_DESCRIPTION. Read .claude-prompt.md for details."

    $CLAUDE_FULL_PATH $CLAUDE_ARGS \
        "Implement feature: $TASK_DESCRIPTION. Read .claude-prompt.md for details."

    # Stay in the shell after Claude finishes
    exec "$SHELL"

else
    print_success "Worktree created successfully!"
    print_info "To start working:"
    echo "  cd $WORKTREE_PATH"
    echo "  $CLAUDE_CMD --task \"Implement: $TASK_DESCRIPTION\""
fi
