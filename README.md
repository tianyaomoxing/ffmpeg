## Mac OS 安装ffmpeg

背景：由于电脑系统版本过旧，许多插件和软件无法兼容安装。经过长时间的使用困扰后，我最终决定彻底清理空间：卸载了Homebrew、Office、微信等大型软件，成功完成系统升级。但代价是需要重新配置开发环境（如FFmpeg等工具）。

想起许久之前在CSDN上更新过一版FFmpeg在macOS上批处理操作脚本，但是没有说明怎么安装ffmpeg，此篇所述为补充，皆为实践所得，然技术日新月异，仅供参考。

*备注: 转载可以， 不过请加版权来源，谢谢～*

## **FFmpeg官网：[https://ffmpeg.org/](https://ffmpeg.org/)**

## 操作方式一: 通过homebrew安装ffmpeg【有难度】

没有安装homebrew或者homebrew安装失败的可以使用这个脚本：
该脚本网上找的，亲测有效

**2025年推荐安装命令（自动适配芯片架构）**

```bash
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
```

安装过程会：
		1. 自动选择清华/中科大镜像源
	2. 安装必要的命令行工具（如git）
3. 配置环境变量

FFmpeg官方网站教程：[https://trac.ffmpeg.org/wiki/CompilationGuide/macOS](https://trac.ffmpeg.org/wiki/CompilationGuide/macOS)
大家按照教程在终端执行即可

页面片段截取：
![ffmpeg官方安装教程](https://i-blog.csdnimg.cn/direct/2d58346aade04d5b85d41c695283abf8.png)
缺点：操作复杂，遇到问题需要查询资料，网络环境和系统要求，或者因为国内网络访问可能不稳定，且不支持断点续传造成失败，构建耗时较久

## 操作方式二：下载静态构建安装包，配置环境变量【推荐】

下载地址：[https://ffmpeg.org/download.html](https://ffmpeg.org/download.html)
1. 鼠标移动到macOS苹果图标上，在弹出的界面中，点击“
                Static builds for macOS 64-bit”
![Macos下载ffmpeg](https://i-blog.csdnimg.cn/direct/2dfca571f92240f8bb70a1b407a4e04f.png)
2. 根据需要下载静态编译的 FFmpeg 二进制文件
如果看文章的 *帅哥美女* 的磁盘空间充裕，或计划系统性地学习FFmpeg，推荐安装完整组件包（含 ffmpeg、ffplay、ffprobe 和 ffserver），以便后续灵活调用所有功能模块
![ffmpeg静态编译文件](https://i-blog.csdnimg.cn/direct/29d5522aebfe4b12b6abeed769541a85.png)
3. 创建文件夹，例如文件名ffmpeg，放置ffmpeg等文件
此次我安装的位置是/usr/local/ffmpeg/bin，

终端里执行的`open /usr/local`，打开local目录后创建对应的文件夹ffmpeg和bin，并放置对应下载好的静态编译文件
![ffmpeg文件目录](https://i-blog.csdnimg.cn/direct/8ad24da80d71430c9ac1401eaa84d91d.png)4. 配置变量
检查当前默认的shell是bash还是别的

```bash
echo $SHELL 
```
例如我的苹果系统输出的是`/bin/bash，`说明默认的 shell 是 bash 而不是 zsh
​

从 macOS Catalina (10.15)开始，zsh (Z shell) 是所有新建用户帐户的默认 Shell。 
bash 是 macOS Mojave(10.14) 及更早版本中的默认 Shell，或者低版本系统升级后的shell默认可能也是bash

关于此处的区别，详细了解可以跳转苹果官方介绍：[在 Mac 上将zsh用作默认shell](https://support.apple.com/zh-cn/102360) 

> 这里引入下如何更改默认 Shell，没特殊需求可以跳过该模块介绍
> 
> 切换到 zsh：
> 
> chsh -s /bin/zsh
> 
> 切换到bash：
> 
> chsh -s /bin/bash 在终端输入命令切换后，输入密码（输入用户开机密码的时候密码不可见），输入完毕回车
> 
> 打开新的终端echo $SHELL进行测试
## ​针对Bash环境
针对 bash 的环境，需要检查 .bashrc 或 .bash_profile 文件以确保 ffmpeg 的路径已正确添加到 PATH 变量中。以下是解决问题的步骤

我配置的过程中ffmpeg等静态文件放置的位置是/usr/local/ffmpeg/bin，
如果大家的放置位置在别的位置，可以在ffmpeg上点击右键，选择显示简介，复制位置

大家在操作的时候替换/usr/local/ffmpeg/bin为自己存放ffmpeg的文件夹地址
![ffmpeg位置](https://i-blog.csdnimg.cn/direct/c93cad3c55d848fda81ec92002dafdd0.png)
1). 检查 .bashrc 文件
首先，打开 .bashrc 文件：

```bash
nano ~/.bashrc
```

确保有以下行以添加 /usr/local/ffmpeg/bin 到 PATH：

```bash
export PATH="/usr/local/ffmpeg/bin:$PATH"
```

如果没有，请添加该行。
2). 检查 .bash_profile 文件
.bash_profile 通常用于在登录时设置环境变量。开启编辑器：

```bash
nano ~/.bash_profile
```

确保有如下内容：

```bash
# Add ~/bin to the PATH if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi
# Ensure .bashrc is sourced
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
export PATH="/usr/local/ffmpeg/bin:$PATH"
```

如果没有类似的设置，请添加。
3). 应用配置
保存并退出编辑器（使用 CTRL + O 保存，CTRL + X 退出）。
应用 .bashrc 和 .bash_profile 的配置：

```bash
source ~/.bashrc
source ~/.bash_profile
```

4). 打开新的终端窗口，测试配置是否生效

```bash
ffmpeg -version
```

看到这里配置就算结束了！
​

## 针对zsh环境

针对 zsh 的环境，需要检查 ~/.zshrc 文件以确保 ffmpeg 的路径已正确添加到 PATH 变量中（无需操作 .bashrc 或 .bash_profile）。以下是解决问题的步骤

我配置的过程中ffmpeg等静态文件放置的位置是/usr/local/ffmpeg/bin，
如果大家的放置位置在别的位置，可以在ffmpeg上点击右键，选择显示简介，复制位置

大家在操作的时候替换/usr/local/ffmpeg/bin为自己存放ffmpeg的文件夹地址
1). 检查 .zshrc  文件
首先，打开 .zshrc  文件：

```bash
nano ~/.zshrc
```

确保有以下行以添加 /usr/local/ffmpeg/bin 到 PATH：

```bash
export PATH="/usr/local/ffmpeg/bin:$PATH"
```

如果没有类似的设置，请添加。
2). 应用配置
保存并退出编辑器（使用 CTRL + O 保存，CTRL + X 退出）。
应用 .zshrc 的配置：

```bash
source ~/.zshrc
```

3). 打开新的终端窗口，测试配置是否生效

```bash
ffmpeg -version
```

看到这里配置就算结束了！

​

## 一键脚本配置

针对zsh环境和bash环境，如果担心更改配置文件出现问题，可以通过脚本一键配置ffmpeg环境变量
已提供中文提示语（configure_ffmpeg_cn.sh）和英文提示语（configure_ffmpeg_en.sh）脚本

**使用方法**
将脚本保存为 configure_ffmpeg_cn.sh
赋予执行权限：


```bash
chmod +x configure_ffmpeg_cn.sh
```

运行脚本：

```bash
./configure_ffmpeg_cn.sh
```

根据提示输入 ffmpeg 的路径（如 /usr/local/ffmpeg/bin）。


