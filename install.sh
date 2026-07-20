#!/usr/bin/env bash

echo "RUNNING dotfiles repo install.sh"

echo "STEP 1: 💾 copying .gitconfig and .gitignore_global"
cp -r ./git/.gitconfig ./git/.gitignore_global ~



export PATH_CS_=1"$HOME/.local/share/code-server"
PATH_CS_2="$HOME/.local/share/code-server/User"
export PATH_VS_1="$HOME/Library/Application Support/Code/User"
PATH_VSCS_1="$HOME/.vscode-server/cli/serve-web"
PATH_VSCS_2="$HOME/.vscode-server/data/User"
COMMAND_S="cp ./Code/User/settings.json"
COMMAND_K="cp ./Code/User/keybindings.json"
COMMAND_T="cp ./Code/User/tasks.json"

echo "🐚 Shell is $SHELL"
echo "STEP 2: 💾 copying shell configuration files e.g., bash, fish, zsh"

if [ "$SHELL" == "/bin/bash" ]; then 
  cp ./shell/bash/.bashrc $HOME/.bashrc
  cp ./shell/bash/.bash_profile $HOME/.bash_profile  
elif [ "$SHELL" == "/bin/zsh" ]; then
  cp ./shell/zsh/.zshrc $HOME/.zshrc
elif [ "$SHELL" == "/usr/local/fish" ]; then
  cp ./shell/fish/config.fish $HOME/.config/fish/config.fish
else
  echo "no unix shell dotfiles copied"
fi

echo "STEP 3: 💾 copying VS Code-related config files e.g., settings, keybindings, tasks"

if [ -d "$PATH_VSCS_1" ]; then
    echo 'Microsoft VS Code Server CLI serve-web found'

    VSCS_DIR=$(ls -td $HOME/.vscode/cli/serve-web/*/ | head -1)
    export EXT_BINARY="$VSCS_DIR bin/code-server"
    $COMMAND_S "$PATH_VSCS_2"
    $COMMAND_K "$PATH_VSCS_2"
    $COMMAND_T "$PATH_VSCS_2"  
fi

if [ -d $PATH_CS_1 ]; then

    echo 'code-server config directory found'
    if [ -d $PATH_CS_2 ]; then        
        echo "$PATH_CS_2 found"  
    else
        echo "$PATH_CS_2 not found, make directory"
        mkdir "$PATH_CS_1"/User    
    fi

    # vs code extension installation
    # Check if VS Code is installed by looking for the 'code-server' command
    export EXT_BINARY="/tmp/code-server/bin/code-server"
    if ! command -v $EXT_BINARY &> /dev/null
    then
        echo "code-server is not installed. Please install it before running this script. https://github.com/coder/code-server"
    else
        ./install_vs_code_extensions.sh
    fi

    $COMMAND_S $PATH_CS_2
    $COMMAND_K $PATH_CS_2
    $COMMAND_T $PATH_CS_2

fi

if [ -d "$PATH_VS_1" ]; then

    echo 'Locally-installed VS Code config directory found'
    # vs code extension installation
    # Check if VS Code is installed by looking for the 'code' command
    export EXT_BINARY="code"
    if ! command -v $EXT_BINARY &> /dev/null
    then
        echo "VS Code is not installed. Please install it before running this script. https://github.com/microsoft/vscode"
    else
        ./install_vs_code_extensions.sh
    fi

    $COMMAND_S "$PATH_VS_1"
    $COMMAND_K "$PATH_VS_1"
    $COMMAND_T "$PATH_VS_1"
fi

echo "STEP 4: 💾 installing herdr and youtube-music-cli"

if command -v apt-get &> /dev/null; then
    MUSIC_DEPS=""
    command -v mpv &> /dev/null || MUSIC_DEPS="$MUSIC_DEPS mpv"
    command -v yt-dlp &> /dev/null || MUSIC_DEPS="$MUSIC_DEPS yt-dlp"
    if [ -n "$MUSIC_DEPS" ]; then
        sudo apt-get update -qq && sudo apt-get install -y$MUSIC_DEPS
    fi
else
    echo "apt-get not found, skipping mpv/yt-dlp install (required by youtube-music-cli)"
fi

if command -v herdr &> /dev/null; then
    echo "herdr already installed"
else
    curl -fsSL https://herdr.dev/install.sh | sh
fi

if command -v npm &> /dev/null; then
    if command -v youtube-music-cli &> /dev/null; then
        echo "youtube-music-cli already installed"
    else
        npm config set prefix "$HOME/.local"
        npm install -g @involvex/youtube-music-cli
    fi
else
    echo "npm not found, skipping youtube-music-cli install"
fi

