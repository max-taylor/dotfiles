# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# My additions
export ZSH=~/.oh-my-zsh

export DEFAULT_USER=$USER

# disable oh-my-zsh themes for pure prompt
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug load
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

alias p=pnpm

source ~/.nvm/nvm.sh

# The prompt used in the theme file 
# PROMPT+=' %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)'

PATH=~/.console-ninja/.bin:$PATH
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

eval "$(zoxide init zsh)"

PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

# bun completions
[ -s "/Users/maxtaylor/.bun/_bun" ] && source "/Users/maxtaylor/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
alias claude="/Users/maxtaylor/.claude/local/claude"

# Claude Code Feature Branch Support
# ==================================

# Configuration
export CLAUDE_CMD="claude"  # Update this to match your actual command
export DEFAULT_BASE_BRANCH="main"

# Ensure ~/bin is in PATH (or wherever you put the script)
export PATH="$HOME/bin:$PATH"

# Main function
cf() {
    claude-feature "$@"
}

# Quick feature branch with Claude
cff() {
    # Even quicker - just type: cff implement new feature
    claude-feature "$*"
}

# List all Claude worktrees
cfl() {
    echo "📁 Active Claude worktrees:"
    echo ""
    
    # Find all directories in parent that match pattern repo-name-*
    local current_repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    local parent_dir=$(dirname "$(git rev-parse --show-toplevel 2>/dev/null)")
    
    if [[ -z "$current_repo" ]]; then
        echo "Not in a git repository"
        return 1
    fi
    
    # Look for worktree directories matching any repo pattern
    find "$parent_dir" -maxdepth 1 -type d -name "*-*" | while read -r dir; do
        if [[ -f "$dir/.git" ]] && [[ -f "$dir/.claude-task" ]]; then
            local dirname=$(basename "$dir")
            local repo_part="${dirname%%-*}"
            local branch_part="${dirname#*-}"
            local task=$(cat "$dir/.claude-task" 2>/dev/null)
            
            # Check if there are uncommitted changes
            cd "$dir" 2>/dev/null && {
                if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
                    status="🔴"  # Has changes
                else
                    status="🟢"  # Clean
                fi
                cd - > /dev/null
            }
            
            printf "%s %-20s %-30s %s\n" "$status" "$repo_part" "$branch_part" "$task"
        fi
    done
}

# Go to a Claude worktree
cfg() {
    if [[ -z "$1" ]]; then
        echo "Usage: cfg <branch-name-part>"
        echo "Available worktrees:"
        cfl
        return 1
    fi
    
    local parent_dir=$(dirname "$(git rev-parse --show-toplevel 2>/dev/null)")
    
    # Find matching worktree
    local matches=$(find "$parent_dir" -maxdepth 1 -type d -name "*-*$1*" 2>/dev/null | grep -E "\-[^/]*$1")
    local count=$(echo "$matches" | grep -c . || echo 0)
    
    if [[ $count -eq 0 ]]; then
        echo "No worktree found matching: $1"
        return 1
    elif [[ $count -eq 1 ]]; then
        cd "$matches"
        echo "Changed to: $matches"
        echo "Task: $(cat .claude-task 2>/dev/null || echo 'No task description')"
    else
        echo "Multiple matches found:"
        echo "$matches" | while read -r match; do
            echo "  - $(basename "$match"): $(cat "$match/.claude-task" 2>/dev/null)"
        done
        return 1
    fi
}

# Clean up a Claude worktree
cfc() {
    if [[ -z "$1" ]]; then
        echo "Usage: cfc <branch-name-part>"
        echo "This will remove the worktree after checking for uncommitted changes"
        return 1
    fi
    
    local parent_dir=$(dirname "$(git rev-parse --show-toplevel 2>/dev/null)")
    
    # Find matching worktree
    local worktree=$(find "$parent_dir" -maxdepth 1 -type d -name "*-*$1*" 2>/dev/null | grep -E "\-[^/]*$1" | head -1)
    
    if [[ -z "$worktree" ]]; then
        echo "No worktree found matching: $1"
        return 1
    fi
    
    echo "Found worktree: $worktree"
    
    # Check for uncommitted changes
    if [[ -n $(cd "$worktree" && git status --porcelain 2>/dev/null) ]]; then
        echo "⚠️  Warning: Uncommitted changes detected!"
        echo "Continue anyway? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    # Get the main repo path
    local main_repo=$(cat "$worktree/.claude-main-repo" 2>/dev/null)
    
    if [[ -z "$main_repo" ]]; then
        # Fallback: try to find main repo from worktree list
        main_repo=$(cd "$worktree" && git worktree list | grep -v "$worktree" | head -1 | awk '{print $1}')
    fi
    
    # Remove worktree
    echo "Removing worktree..."
    (cd "$main_repo" && git worktree remove "$worktree" --force)
    
    echo "✅ Worktree removed"
}

# Go back to main repository from any worktree
cfm() {
    if [[ -f ".claude-main-repo" ]]; then
        local main_repo=$(cat .claude-main-repo)
        cd "$main_repo"
        echo "Changed to main repository: $main_repo"
    else
        echo "Not in a Claude worktree (no .claude-main-repo file found)"
        return 1
    fi
}

# Aliases for common workflows
alias cfa='claude-feature'                    # Full command
alias cfn='claude-feature --no-claude'        # Create worktree without starting Claude
alias cfb='claude-feature --base'             # Specify base branch
alias cfd='claude-feature --base develop'     # Quick develop branch

# Auto-completion for cfg and cfc
_claude_worktree_complete() {
    local parent_dir=$(dirname "$(git rev-parse --show-toplevel 2>/dev/null)")
    local branches=$(find "$parent_dir" -maxdepth 1 -type d -name "*-*" -exec basename {} \; 2>/dev/null | sed 's/^[^-]*-//')
    _arguments "1:branch:($branches)"
}

compdef _claude_worktree_complete cfg
compdef _claude_worktree_complete cfc
