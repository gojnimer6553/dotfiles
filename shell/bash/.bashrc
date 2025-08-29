
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=10000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups:erasedups
# append to the history file instead of overwriting it when shell closed
shopt -s histappend


# colors
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'

# https://ss64.com/bash/syntax-prompt.html
# https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html
unset PROMPT_COMMAND
export PS1="🦈  \W \$ "

# Package manager detection and script shortcuts
detect_package_manager() {
    if [ -f "bun.lockb" ]; then
        echo "bun"
    elif [ -f "pnpm-lock.yaml" ]; then
        echo "pnpm"
    elif [ -f "yarn.lock" ]; then
        echo "yarn"
    elif [ -f "package-lock.json" ]; then
        echo "npm"
    elif [ -f "package.json" ]; then
        echo "npm"  # default to npm if package.json exists but no lock file
    else
        return 1
    fi
}

# Package.json script shortcuts
run_package_script() {
    local script_name="$1"
    
    if [ ! -f "package.json" ]; then
        echo "❌ No package.json found in current directory"
        return 1
    fi
    
    local package_manager
    package_manager=$(detect_package_manager)
    
    if [ $? -ne 0 ]; then
        echo "❌ Could not detect package manager"
        return 1
    fi
    
    echo "🚀 Running $package_manager run $script_name"
    $package_manager run "$script_name"
}

# Convenient aliases for common package.json scripts
alias start='run_package_script start'
alias dev='run_package_script dev'
alias build='run_package_script build'
alias lint='run_package_script lint'
alias format='run_package_script format'
