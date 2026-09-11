# WSL 故障排查指南

本文档汇总了在 Windows 上安装或使用 **WSL 2、Ubuntu 和 VS Code** 时常见的问题。

如果你的问题没有在本文档中覆盖，请尽量提供一张**包含完整报错信息的截图**，并发送到群聊，或直接私信 **技术部**。

提问时，请尽量同时提供：

- Windows 版本
- 你执行的命令
- 完整报错信息
- 问题发生时你进行到了哪一步
- `wsl --status` 的输出（如果可以执行）
- `wsl --list --verbose` 的输出（如果可以执行）

---

## 开始排查前：我现在是在 PowerShell 还是 Ubuntu 里？

本文档中的部分命令需要在 **Windows PowerShell / Windows Terminal** 中执行，另一些命令则需要在 **Ubuntu / WSL** 中执行。

Windows PowerShell 的提示符通常类似：

```text
PS C:\Users\username>
```

或者：

```text
C:\Users\username>
```

WSL / Ubuntu 的提示符通常类似：

```text
username@computer:~$
```

例如：

```powershell
wsl --list --verbose
```

必须在 **Windows PowerShell / Windows Terminal** 中执行。

而像下面这样的命令：

```bash
sudo apt update
```

则需要在 **Ubuntu / WSL** 中执行。

---

## Case 1：Ubuntu 启动后直接是 `root`，并且没有让我设置用户名和密码

正常情况下，第一次启动 Ubuntu 时，系统应该会要求你创建用户名和密码。

如果 Ubuntu 直接启动，并且终端提示符类似：

```text
root@computer:~#
```

说明你当前正在使用 `root` 用户。

> **警告**
>
> 不建议把 `root` 作为日常开发使用的默认用户。

先创建一个普通用户：

```bash
adduser <username>
```

将 `<username>` 替换成你想使用的用户名。

例如：

```bash
adduser sherry
```

然后把新用户加入 `sudo` 用户组：

```bash
usermod -aG sudo <username>
```

例如：

```bash
usermod -aG sudo sherry
```

退出 WSL：

```bash
exit
```

然后在 **Windows PowerShell / Windows Terminal** 中查看当前已经安装的 Linux 发行版名称：

```powershell
wsl --list --verbose
```

你可能会看到类似：

```text
NAME            STATE           VERSION
Ubuntu-24.04    Stopped         2
```

接下来把新用户设置为默认用户：

```powershell
wsl --manage Ubuntu-24.04 --set-default-user <username>
```

例如：

```powershell
wsl --manage Ubuntu-24.04 --set-default-user sherry
```

然后重新进入 WSL：

```powershell
wsl
```

如果终端提示符变成：

```text
sherry@computer:~$
```

说明默认用户已经成功修改。

如果你的系统不支持 `wsl --manage`，请先寻求帮助，不要继续随意修改其他设置。

---

## Case 2：输入密码时为什么终端没有任何反应？

这是 Linux 终端的正常行为。

输入密码时：

- 不会显示密码内容
- 不会显示 `*`
- 光标看起来可能完全没有移动

例如执行：

```bash
sudo apt update
```

可能会看到：

```text
[sudo] password for username:
```

此时正常输入密码并按 Enter 即可。

> **注意**
>
> 即使屏幕上没有显示任何字符，键盘输入仍然正在被接收。

如果你认为自己输错了密码，通常可以按：

```text
Ctrl + C
```

取消当前命令，然后重新输入。

---

## Case 3：出现错误代码 `0x800701bc`，或者报错里出现 `https://aka.ms/wsl2kernel`

你可能会看到类似：

```text
WslRegisterDistribution failed with error: 0x800701bc
```

或者报错信息中包含：

```text
https://aka.ms/wsl2kernel
```

这通常表示系统缺少 WSL 2 Linux Kernel Update Package。

下载并安装 WSL 内核更新包后，再重新启动 WSL。

也可以参考 Microsoft 官方的 WSL 2 内核更新说明：

```text
https://learn.microsoft.com/windows/wsl/install-manual
```

安装完成后，再尝试：

```powershell
wsl
```

---

## Case 4：Windows 提示虚拟化未启用，或找不到 / 无法启用 “Virtual Machine Platform”

在开始菜单中搜索：

```text
Turn Windows features on or off
```

中文系统中一般显示为：

```text
启用或关闭 Windows 功能
```

WSL 2 需要启用：

```text
Virtual Machine Platform
Windows Subsystem for Linux
```

其中 `Virtual Machine Platform` 在中文系统中通常显示为：

```text
虚拟机平台
```

如果可以正常找到这些选项，请勾选并重新启动电脑。

也可以使用管理员权限的 PowerShell 启用 `Virtual Machine Platform`：

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

如果你在 Windows 功能中**找不到 `Virtual Machine Platform`，或者该选项无法勾选**，请继续检查硬件虚拟化。

首先，在 Windows PowerShell 中运行：

```powershell
systeminfo
```

检查系统信息中是否显示硬件虚拟化已经开启。

如果硬件虚拟化未开启，可能需要进入 BIOS / UEFI 开启 Virtualization。

不同电脑中的选项名称可能不同，例如：

```text
Intel Virtualization Technology
VT-x
AMD-V
SVM Mode
```

将对应的虚拟化选项设置为：

```text
Enabled
```

保存设置并重新启动 Windows。

如果你不确定如何进入 BIOS / UEFI，可以参考 Microsoft 官方关于 Windows 虚拟化设置的说明，或者将电脑型号和问题截图发送到群聊寻求帮助。

---

## Case 5：出现 “Catastrophic Failure” / “灾难性故障”

这个问题可能是 WSL 安装过程中出现损坏导致的。

建议按下面的顺序尝试。

### Choice A：更新 WSL

打开 **Windows PowerShell**，执行：

```powershell
wsl --shutdown
wsl --update
```

然后重新尝试启动 WSL：

```powershell
wsl
```

### Choice B：关闭并重新启用 WSL 功能

使用管理员权限打开 **Windows PowerShell**。

关闭 WSL 和 Virtual Machine Platform：

```powershell
Disable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart
Disable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -NoRestart
```

重新启动电脑。

之后再次以管理员权限打开 PowerShell，并重新启用这两个功能：

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

再次重新启动电脑。

### Choice C：使用安装程序重新安装 WSL

重新下载并运行 WSL 安装程序。

如果你使用的是 Workshop 中的离线安装方式，请重新按照主安装文档中的 WSL Installer 步骤操作。

### Choice D：重新安装 WSL App Package

以管理员身份打开 PowerShell：

```powershell
Get-AppxPackage MicrosoftCorporationII.WindowsSubsystemforLinux -AllUsers | Remove-AppxPackage
```

然后重新安装 / 更新 WSL：

```powershell
wsl --update --web-download
```

安装完成后，如有需要，重新启动 Windows。

---

## Case 6：出现错误代码 `0x80370114`

如果遇到：

```text
WslRegisterDistribution failed with error: 0x80370114
```

可以尝试关闭 **Windows Hypervisor Platform**。

以管理员权限打开 PowerShell：

```powershell
Disable-WindowsOptionalFeature -Online -FeatureName "HypervisorPlatform" -NoRestart
```

然后重新启动电脑。

或者：

1. 打开 `Turn Windows features on or off`
2. 找到：

```text
Windows Hypervisor Platform
```

3. 取消勾选
4. 重新启动 Windows

---

## Case 7：出现错误代码 `0x8007019e`

如果看到：

```text
WslRegisterDistribution failed with error: 0x8007019e
```

可以依次尝试下面的方法。

### Choice A：把 WSL 2 设置为默认版本

在 Windows PowerShell 中执行：

```powershell
wsl --set-default-version 2
```

然后重新尝试启动 Ubuntu。

### Choice B：更新 WSL

```powershell
wsl --update
```

然后重启 WSL：

```powershell
wsl --shutdown
wsl
```

### Choice C：检查 WSL 和虚拟化功能

确认以下功能已经开启：

```text
Windows Subsystem for Linux
Virtual Machine Platform
```

修改后重新启动 Windows。

---

## Case 8：找不到 Ubuntu 文件，或 Ubuntu 打开后立刻闪退

如果 Ubuntu 报告找不到需要的文件，或者打开后立刻关闭，可能是 Ubuntu 安装或其文件路径出现问题。

即使 Ubuntu 无法正常打开，也可以直接使用 **Windows PowerShell / Windows Terminal** 进行排查。

先查看已经安装的发行版：

```powershell
wsl --list --verbose
```

例如：

```text
NAME            STATE           VERSION
Ubuntu-24.04    Stopped         2
```

如果 Ubuntu 仍然在列表中，先尝试：

```powershell
wsl --shutdown
```

然后显式启动 Ubuntu：

```powershell
wsl -d Ubuntu
```

或者根据你的发行版名称：

```powershell
wsl -d Ubuntu-24.04
```

如果 Ubuntu 仍然无法使用，并且你确定需要重新安装，可以注销这个发行版。

先再次确认准确的发行版名称：

```powershell
wsl --list --verbose
```

然后执行：

```powershell
wsl --unregister Ubuntu-24.04
```

> **警告**
>
> `wsl --unregister` 会永久删除该发行版中的 Linux 文件、已安装软件、用户账号和配置。
>
> 如果里面还有没有备份的重要文件，不要执行这个命令。

注销损坏的发行版后，再重新安装 Ubuntu。

---

## Case 9：Windows 提示无法识别 `wsl` 命令

如果 PowerShell 提示：

```text
wsl
```

不是可识别的命令，先确认你使用的是正常的 64 位 **Windows PowerShell**，而不是：

```text
Windows PowerShell (x86)
```

如果窗口标题中包含：

```text
(x86)
```

请关闭它，然后从开始菜单打开普通的 Windows PowerShell。

接着尝试：

```powershell
wsl --help
wsl --status
```

如果 WSL 没有安装，可以尝试：

```powershell
winget install Microsoft.WSL
```

如果仍然需要处理，使用管理员权限打开 PowerShell，并启用所需 Windows 功能：

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

然后重新启动 Windows。

重启后安装 Ubuntu：

```powershell
wsl --install -d Ubuntu
```

检查安装结果：

```powershell
wsl -l -v
```

正常情况下应该可以看到 Ubuntu。

---

## Case 10：Linux 命令提示 `command not found`

如果你在 Ubuntu 中看到：

```text
command not found
```

首先检查命令本身。

确认：

1. 命令是否拼写正确
2. 空格位置是否正确
3. `-` 是否为英文半角减号

例如：

```bash
ls -l
```

是正确的。

它的结构是：

```text
ls + 空格 + -l
```

下面这样是错误的：

```text
ls-l
```

如果命令拼写没有问题，那么可能是对应的软件包没有安装。

可以先更新软件包列表：

```bash
sudo apt update
```

然后安装需要的软件包：

```bash
sudo apt install <package>
```

---

## Case 11：Ubuntu、Debian 和 Arch 都需要安装吗？怎么查看和启动发行版？

不需要同时安装。

Ubuntu、Debian 和 Arch 都是不同的 Linux 发行版，你只需要安装**其中一个**。

对于本 Workshop 的新手用户，更推荐：

```text
Ubuntu 24.04 LTS
```

如果想查看当前已经安装了哪些 Linux 发行版，可以在 Windows PowerShell 中执行：

```powershell
wsl --list --verbose
```

或者：

```powershell
wsl -l -v
```

例如：

```text
NAME            STATE           VERSION
* Ubuntu-24.04  Running         2
```

其中：

- `*` 表示默认发行版
- `VERSION` 显示 `2` 表示当前使用 WSL 2

如果要进入默认 Linux 发行版：

```powershell
wsl
```

如果想启动指定发行版：

```powershell
wsl -d Ubuntu-24.04
```

把 `Ubuntu-24.04` 替换成 `wsl --list --verbose` 显示的实际名称。

如果要退出 WSL：

```bash
exit
```

之后会回到 PowerShell 或 CMD。

---

## Case 12：为什么进入 WSL 后目录是 `/mnt/c/Users/...`？Linux 中的 `~` 又在哪里？

如果你在 PowerShell 或 CMD 中执行：

```powershell
wsl
```

而当前 Windows 目录是：

```text
C:\Users\username
```

那么 WSL 可能会从对应的 Windows 挂载目录启动：

```text
/mnt/c/Users/username
```

这是正常现象。

如果想回到 Linux 用户自己的 home 目录，执行：

```bash
cd ~
```

检查当前目录：

```bash
pwd
```

应该会看到类似：

```text
/home/username
```

在 Linux 中，`~` 就表示当前用户的 home 目录。

例如，如果用户名是：

```text
sherry
```

那么：

```text
~
```

通常就是：

```text
/home/sherry
```

可以这样确认：

```bash
echo ~
```

或者：

```bash
cd ~
pwd
```

如果想在 Windows 文件资源管理器中打开当前 WSL 目录：

```bash
explorer.exe .
```

也可以在 Windows 文件资源管理器中输入：

```text
\\wsl$\
```

例如：

```text
\\wsl$\Ubuntu-24.04\home\sherry
```

不同电脑上的发行版名称可能不同，可以使用：

```powershell
wsl --list --verbose
```

确认实际名称。

对于 Linux 开发项目，建议把项目存放在 Linux home 目录下，例如：

```bash
mkdir -p ~/code
cd ~/code
```

---

## Case 13：无法从 WSL 打开 VS Code，或 VS Code 没有连接到 WSL

VS Code 应该安装在 **Windows** 上，而编译器和开发工具运行在 WSL 内。

先在 Windows PowerShell 中检查 VS Code 是否已经安装：

```powershell
code --version
```

如果刚安装完 VS Code 后提示找不到 `code`，请关闭所有 PowerShell 窗口，然后重新打开 PowerShell。

然后进入 WSL：

```powershell
wsl
```

在 WSL 中进入你的项目目录：

```bash
cd ~/code
```

运行：

```bash
code .
```

第一次执行时，VS Code 可能会自动在 WSL 中安装 **VS Code Server**。

等待安装完成即可。

之后查看 VS Code 左下角，应该能看到类似：

```text
WSL: Ubuntu
```

如果没有看到，安装 Microsoft 提供的 WSL 插件。

打开 Extensions 面板：

```text
Ctrl + Shift + X
```

搜索：

```text
WSL
```

并安装 Microsoft 提供的 WSL 插件。

也可以在 Windows PowerShell 中执行：

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

安装后重新进入 WSL，并运行：

```bash
code .
```

看到：

```text
WSL: Ubuntu
```

说明 VS Code 已经成功连接到 WSL 环境。

---

## Case 14：VS Code 能打开，但是 GCC / G++ 无法使用

确认 GCC 和 G++ 是安装在 **WSL 内部**，而不是只安装在 Windows 上。

先进入 WSL：

```powershell
wsl
```

然后执行：

```bash
sudo apt update
sudo apt install build-essential gdb
```

检查安装：

```bash
gcc --version
g++ --version
gdb --version
```

如果能够显示版本信息，说明工具已经安装成功。

> **重要**
>
> 本 Workshop 中，GCC、G++、Make 和 GDB 都应该运行在 WSL 中。

---

## Case 15：WSL 出现 `localhost` 代理警告

你可能会看到类似：

```text
wsl: Detected localhost proxy configuration, but it is not mirrored into WSL.
NAT mode WSL does not support localhost proxies.
```

这表示 Windows 当前配置了基于 `localhost` 的代理，而 WSL 正在使用 NAT 网络模式。

如果 WSL 仍然可以正常联网，并且下面这样的命令：

```bash
sudo apt update
```

可以正常执行，那么对于本 Workshop 来说，这个警告通常可以先忽略。

如果 WSL 无法联网，请在寻求帮助时把这条警告一起提供。

---

## Case 16：用于收集故障信息的基础命令

如果你不确定问题出在哪里，可以先打开 **Windows PowerShell**，执行：

```powershell
wsl --status
```

然后：

```powershell
wsl --list --verbose
```

也可以查看 Windows 系统信息：

```powershell
systeminfo
```
![WSL status example](wsl-status.png)

如果 WSL 可以正常启动，进入 Ubuntu：

```powershell
wsl
```

然后执行：

```bash
whoami
pwd
```

这些命令可以帮助确认：

- 当前 Windows / WSL 配置
- 已安装的 Linux 发行版
- 当前使用 WSL 1 还是 WSL 2
- 当前 Linux 用户
- WSL 启动时所在的目录

---

## 如果以上情况都不适用

如果上述方法都没有解决问题，请尽量提供：

```text
1. 完整报错截图
2. wsl --status 的输出
3. wsl --list --verbose 的输出
4. Windows 版本
5. 出现问题前执行的命令
6. 简单描述你当时想做什么
```

然后把这些信息发送到群聊，或者直接联系 **技术部**。

如果需要自己在网上搜索，建议优先参考可靠的技术资料，例如：

- Microsoft Learn
- Microsoft WSL 官方文档
- GitHub Issues
- Stack Overflow

> **注意**
>
> 在不清楚命令作用、或者没有备份重要文件的情况下，不要随意执行 `wsl --unregister` 等会删除 WSL 发行版数据的命令。