# ffmpeg
install/uninstall FFmpeg
​
背景：
由于电脑系统版本过旧，许多插件和软件无法兼容安装。经过长时间的使用困扰后，我最终决定彻底清理空间：卸载了Homebrew、Office、微信等大型软件，成功完成系统升级。但代价是需要重新配置开发环境（如FFmpeg等工具）。

想起许久之前在CSDN上更新过一版FFmpeg在macOS上批处理操作脚本，但是没有说明怎么安装ffmpeg，此篇所述为补充，皆为实践所得，然技术日新月异，仅供参考。

备注: 转载可以， 请加版权来源，谢谢～

FFmpeg官网：https://ffmpeg.org/

方式一:
通过homebrew安装ffmpeg【有难度】
没有安装homebrew或者homebrew安装失败的可以使用这个脚本：
该脚本网上找的，亲测有效
推荐安装homebrew命令（自动适配芯片架构）

/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
安装过程会：
1. 自动选择清华/中科大镜像源
2. 安装必要的命令行工具（如git）
3. 配置环境变量

FFmpeg官方网站教程：https://trac.ffmpeg.org/wiki/CompilationGuide/macOS
大家按照教程在终端执行即可
页面片段截取：

缺点：操作复杂，遇到问题需要查询资料，网络环境和系统要求，或者因为国内网络访问可能不稳定，且不支持断点续传造成失败，构建耗时较久

方式二：
下载静态构建安装包，配置环境变量【推荐】

下载地址：https://ffmpeg.org/download.html
1. 鼠标移动到macOS苹果图标上，在弹出的界面中，点击“Static builds for macOS 64-bit”

2. 根据需要下载静态编译的 FFmpeg 二进制文件
如果看文章的 帅哥美女 的磁盘空间充裕，或计划系统性地学习FFmpeg，推荐安装完整组件包（含 ffmpeg、ffplay、ffprobe 和 ffserver），以便后续灵活调用所有功能模块

3. 创建文件夹，例如文件名ffmpeg，放置ffmpeg等文件

此次我安装的位置是/usr/local/ffmpeg/bin，

终端里执行的

open /usr/local
打开local目录后创建对应的文件夹ffmpeg和bin，并放置对应下载好的静态编译文件


4. 配置变量
终端中输入echo $SHELL 查看当前默认的shell是bash还是别的

echo $SHELL 

针对Bash环境
针对 bash 的环境，需要检查 .bashrc 或 .bash_profile 文件以确保 ffmpeg 的路径已正确添加到 PATH 变量中。以下是解决问题的步骤

我配置的过程中ffmpeg等静态文件放置的位置是/usr/local/ffmpeg/bin，
如果大家的放置位置在别的位置，可以在ffmpeg上点击右键，选择显示简介，复制位置

大家在操作的时候替换/usr/local/ffmpeg/bin为自己存放ffmpeg的文件夹地址

1). 检查 .bashrc 文件
首先，打开 .bashrc 文件：

nano ~/.bashrc
确保有以下行以添加 /usr/local/ffmpeg/bin 到 PATH：

export PATH="/usr/local/ffmpeg/bin:$PATH"
如果没有，请添加该行。
2). 检查 .bash_profile 文件
.bash_profile 通常用于在登录时设置环境变量。开启编辑器：

nano ~/.bash_profile
确保有如下内容：

# Add ~/bin to the PATH if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi
# Ensure .bashrc is sourced
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
export PATH="/usr/local/ffmpeg/bin:$PATH"

如果没有类似的设置，请添加。
3). 应用配置
保存并退出编辑器（使用 CTRL + O 保存，CTRL + X 退出）。
应用 .bashrc 和 .bash_profile 的配置：

source ~/.bashrc
source ~/.bash_profile
4). 打开新的终端窗口，测试配置是否生效

ffmpeg -version
看到这里配置就算结束了！

针对zsh环境
针对 zsh 的环境，需要检查 ~/.zshrc 文件以确保 ffmpeg 的路径已正确添加到 PATH 变量中（无需操作 .bashrc 或 .bash_profile）。以下是解决问题的步骤

我配置的过程中ffmpeg等静态文件放置的位置是/usr/local/ffmpeg/bin，
如果大家的放置位置在别的位置，可以在ffmpeg上点击右键，选择显示简介，复制位置

大家在操作的时候替换/usr/local/ffmpeg/bin为自己存放ffmpeg的文件夹地址

1). 检查 .zshrc  文件
首先，打开 .zshrc  文件：

nano ~/.zshrc
确保有以下行以添加 /usr/local/ffmpeg/bin 到 PATH：

export PATH="/usr/local/ffmpeg/bin:$PATH"
如果没有类似的设置，请添加。
2). 应用配置
保存并退出编辑器（使用 CTRL + O 保存，CTRL + X 退出）。
应用 .zshrc 的配置：
source ~/.zshrc
3). 打开新的终端窗口，测试配置是否生效

ffmpeg -version
看到这里配置就算结束了！

一键脚本配置
针对zsh环境和bash环境，如果担心更改配置文件出现问题，可以通过脚本一键配置ffmpeg环境变量
脚本已提供中（configure_ffmpeg_cn.sh）英（configure_ffmpeg_en.sh）两个版本

使用方法
将脚本保存为 configure_ffmpeg_cn.sh

赋予执行权限：
chmod +x configure_ffmpeg_cn.sh

运行脚本：
./configure_ffmpeg_cn.sh

根据提示输入 ffmpeg 的路径（如 /usr/local/ffmpeg/bin）。

​
