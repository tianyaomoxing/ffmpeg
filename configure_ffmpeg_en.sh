#!/bin/bash
# Script to install/uninstall FFmpeg 
# tianyaomoxing@outlook.com
# Detect current default shell
current_shell=$(echo $SHELL)

# Prompt user to select operation
echo "Please select an operation:"
echo "1. Install FFmpeg"
echo "2. Uninstall FFmpeg"
read -p "Enter your choice (1 or 2): " choice

if [ "$choice" -eq 1 ]; then
    # Prompt user to enter FFmpeg installation path
    echo "Please enter the FFmpeg installation directory (e.g., /usr/local/ffmpeg/bin):"
    read ffmpeg_path

    # Check if the path exists
    if [ ! -d "$ffmpeg_path" ]; then
        echo "Error: Directory $ffmpeg_path does not exist. Please check the path!"
        exit 1
    fi
fi

# Execute corresponding action based on user choice
case $choice in
    1)
        # Configure environment variables based on shell type
        if [[ "$current_shell" == *"bash"* ]]; then
            echo "Detected current shell is bash. Configuring .bashrc and .bash_profile..."
            
            if ! grep -q "export PATH=\"$ffmpeg_path:\$PATH\"" ~/.bashrc; then
                echo "export PATH=\"$ffmpeg_path:\$PATH\"" >> ~/.bashrc
                echo "Added to ~/.bashrc"
            else
                echo "Configuration already exists in ~/.bashrc, skipping."
            fi

            if [ -f ~/.bash_profile ]; then
                if ! grep -q "export PATH=\"$ffmpeg_path:\$PATH\"" ~/.bash_profile; then
                    if ! grep -q "source ~/.bashrc" ~/.bash_profile; then
                        echo -e "\n# Ensure .bashrc is sourced\nif [ -f ~/.bashrc ]; then\n    source ~/.bashrc\nfi" >> ~/.bash_profile
                    fi
                    echo "export PATH=\"$ffmpeg_path:\$PATH\"" >> ~/.bash_profile
                    echo "Added to ~/.bash_profile"
                else
                    echo "Configuration already exists in ~/.bash_profile, skipping."
                fi
            else
                echo "~/.bash_profile does not exist, skipping."
            fi

            source ~/.bashrc
            if [ -f ~/.bash_profile ]; then
                source ~/.bash_profile
            fi

        elif [[ "$current_shell" == *"zsh"* ]]; then
            echo "Detected current shell is zsh. Configuring .zshrc..."
            
            if ! grep -q "export PATH=\"$ffmpeg_path:\$PATH\"" ~/.zshrc; then
                echo "export PATH=\"$ffmpeg_path:\$PATH\"" >> ~/.zshrc
                echo "Added to ~/.zshrc"
            else
                echo "Configuration already exists in ~/.zshrc, skipping."
            fi

            source ~/.zshrc
        else
            echo "Unknown shell: $current_shell. Please configure the environment variable manually."
            exit 1
        fi

        echo -e "\nFFmpeg global configuration completed! Please open a new terminal window to test."
        echo "Current PATH for FFmpeg: "
        which ffmpeg || echo "FFmpeg not found. Please check if the path is correct."
        ;;

    2)
        # Get FFmpeg installation directory
        ffmpeg_path=$(dirname "$(which ffmpeg)")

        if [ -z "$ffmpeg_path" ]; then
            echo "FFmpeg is not installed or not found in PATH."
            exit 1
        fi

        # Uninstall FFmpeg path configuration
        if [[ "$current_shell" == *"bash"* ]]; then
            echo "Detected current shell is bash. Removing FFmpeg path from .bashrc and .bash_profile..."

            sed -i '' "\|export PATH=\"$ffmpeg_path:\$PATH\"|d" ~/.bashrc
            
            if [ -f ~/.bash_profile ]; then
                sed -i '' "\|export PATH=\"$ffmpeg_path:\$PATH\"|d" ~/.bash_profile
            fi

            source ~/.bashrc
            if [ -f ~/.bash_profile ]; then
                source ~/.bash_profile
            fi

        elif [[ "$current_shell" == *"zsh"* ]]; then
            echo "Detected current shell is zsh. Removing FFmpeg path from .zshrc..."

            sed -i '' "\|export PATH=\"$ffmpeg_path:\$PATH\"|d" ~/.zshrc

            source ~/.zshrc
        else
            echo "Unknown shell: $current_shell. Please configure the environment variable manually."
            exit 1
        fi

        echo "FFmpeg has been removed from the environment variable."
        ;;
    
    *)
        echo "Invalid option. Please rerun the script and select a valid operation."
        exit 1
        ;;
esac
