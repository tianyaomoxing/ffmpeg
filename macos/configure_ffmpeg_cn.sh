#!/bin/bash
# 一键配置或卸载ffmpeg脚本
# tianyaomoxing@outlook.com
# 检测当前默认 Shell
current_shell=$(echo $SHELL)

# 提示用户选择操作
echo "请选择操作："
echo "1. 安装 FFmpeg"
echo "2. 卸载 FFmpeg"
read -p "请输入选项 (1 或 2): " choice

if [ "$choice" -eq 1 ]; then
    # 提示用户输入 ffmpeg 路径
    echo "请输入 ffmpeg 的安装目录（例如：/usr/local/ffmpeg/bin）："
    read ffmpeg_path

    # 检查路径是否存在
    if [ ! -d "$ffmpeg_path" ]; then
        echo "错误：目录 $ffmpeg_path 不存在，请检查路径！"
        exit 1
    fi
fi

# 根据选择执行相应操作
case $choice in
    1)
        # 根据 Shell 类型配置环境变量
        if [[ "$current_shell" == *"bash"* ]]; then
            echo "检测到当前 Shell 是 bash，将配置 .bashrc 和 .bash_profile..."
            
            if ! grep -q "export PATH=\"$ffmpeg_path:\$PATH\"" ~/.bashrc; then
                echo "export PATH=\"$ffmpeg_path:\$PATH\"" >> ~/.bashrc
                echo "已添加到 ~/.bashrc"
            else
                echo "~/.bashrc 中已存在该配置，跳过添加。"
            fi

            if [ -f ~/.bash_profile ]; then
                if ! grep -q "export PATH=\"$ffmpeg_path:\$PATH\"" ~/.bash_profile; then
                    if ! grep -q "source ~/.bashrc" ~/.bash_profile; then
                        echo -e "\n# Ensure .bashrc is sourced\nif [ -f ~/.bashrc ]; then\n    source ~/.bashrc\nfi" >> ~/.bash_profile
                    fi
                    echo "export PATH=\"$ffmpeg_path:\$PATH\"" >> ~/.bash_profile
                    echo "已添加到 ~/.bash_profile"
                else
                    echo "~/.bash_profile 中已存在该配置，跳过添加。"
                fi
            else
                echo "~/.bash_profile 不存在，跳过。"
            fi

            source ~/.bashrc
            if [ -f ~/.bash_profile ]; then
                source ~/.bash_profile
            fi

        elif [[ "$current_shell" == *"zsh"* ]]; then
            echo "检测到当前 Shell 是 zsh，将配置 .zshrc..."
            
            if ! grep -q "export PATH=\"$ffmpeg_path:\$PATH\"" ~/.zshrc; then
                echo "export PATH=\"$ffmpeg_path:\$PATH\"" >> ~/.zshrc
                echo "已添加到 ~/.zshrc"
            else
                echo "~/.zshrc 中已存在该配置，跳过添加。"
            fi

            source ~/.zshrc
        else
            echo "未知的 Shell: $current_shell，请手动配置环境变量。"
            exit 1
        fi

        echo -e "\nFFmpeg 全局配置完毕！请打开新的终端窗口测试。"
        echo "当前 PATH 中的 ffmpeg 路径："
        which ffmpeg || echo "ffmpeg 未找到，请检查路径是否正确。"
        ;;

    2)
        # 获取 FFmpeg 的安装目录
        ffmpeg_path=$(dirname "$(which ffmpeg)")

        if [ -z "$ffmpeg_path" ]; then
            echo "FFmpeg 未安装或未在 PATH 中找到。"
            exit 1
        fi

        # 卸载 FFmpeg 路径配置
        if [[ "$current_shell" == *"bash"* ]]; then
            echo "检测到当前 Shell 是 bash，将从 .bashrc 和 .bash_profile 中移除 FFmpeg 的路径..."

            sed -i '' "\|export PATH=\"$ffmpeg_path:\$PATH\"|d" ~/.bashrc
            
            if [ -f ~/.bash_profile ]; then
                sed -i '' "\|export PATH=\"$ffmpeg_path:\$PATH\"|d" ~/.bash_profile
            fi

            source ~/.bashrc
            if [ -f ~/.bash_profile ]; then
                source ~/.bash_profile
            fi

        elif [[ "$current_shell" == *"zsh"* ]]; then
            echo "检测到当前 Shell 是 zsh，将从 .zshrc 中移除 FFmpeg 的路径..."

            sed -i '' "\|export PATH=\"$ffmpeg_path:\$PATH\"|d" ~/.zshrc

            source ~/.zshrc
        else
            echo "未知的 Shell: $current_shell，请手动配置环境变量。"
            exit 1
        fi

        echo "FFmpeg 已从环境变量中移除。"
        ;;
    
    *)
        echo "无效的选项，请重新运行脚本并选择有效的操作。"
        exit 1
        ;;
esac
