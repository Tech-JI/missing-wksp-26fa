# WSL Install Guide

<style>
    div.figure {
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        margin: 2em;
        gap: 1em;
    }

    div.figure > img {
        width: 50%;
    }
</style>

> This document is adapted from the original version by the 20th TechGC department.
>
> This document largely referred to [the official WSL installation documentation](https://learn.microsoft.com/en-us/windows/wsl/install) and [the manual installation documentation](https://learn.microsoft.com/en-us/windows/wsl/install-manual) provided by Microsoft.

In this document, we're gonna go through the steps for installing Windows Subsystem for Linux, version 2, i.e. WSL 2.

> If you have any difficulty in reading this document in plain English, translate it using AI.

## Preliminary Explanations

### What is WSL

WSL is a feature in Windows that lets you run a virtual machine for Linux directly on your Windows, as if you were on an Ubuntu, Debian, or other Linux computer. The greatest advantage is that it allows you to run Linux and Windows simultaneously.

### Why Linux is a better OS for development

For developers, its powerful commandline interface, package managers (like `apt`), customizable environment are primary draws. It streamlines software installation, scripting, and automation.

What's more, in ENGR1010J/1510J _Introduction to Computers & Programming_, JOJ (i.e. JOJ Online Judge) is used to test and grade your code, which is run within a Linux environment. So if you use Windows, you may encounter situations like: "It works on my computer! Why can't it work in JOJ?"

### Linux Distro

WSL is only an environment. You have to install a Linux distro (e.g. Ubuntu, Debian, Arch) as well. Linux is just a kernel, which serves as a base for operating systems. A Linux distro is an actual operating system based on the Linux kernel with the necessities you need for a working system.

### CPU Architecture

Your computer definitely contains a CPU. Every CPU speaks a certain language called CPU architecture. The main architectures used in computers nowadays are **x64 (aka. amd64), arm64 (aka. aarch64), and RISC-V**. Every software you use needs to be translated to one of the CPU architectures to make your CPU understand what the software wants it to do, and these architectures are **not compatible with each other**. So before you download any software, make sure to check the CPU architecture or else the software won't work. Generally, there is a correspondence between the CPU designer and its architecture:

- **Intel** and **AMD**: x64
- **Apple**, **Snapdragon**, and **Huawei**: arm64

## Installation

### Requirements (for WSL 2)

- For Windows 10: (Check "Settings" > "System" > "About")
  - For x64 systems: Version 1903 or later, with Build 18362.1049 or later.
  - For arm64 systems: Version 2004 or later, with Build 19041 or later.
- All versions of Windows 11 support WSL 2.

### Online Install

If you have some kind of way to access Microsoft Store or GitHub fast, then choose this method.

**TL;DR:** Install WSL 2 from Microsoft Store with Ubuntu is as simple as one command in your PowerShell (can be opened by searching "Windows PowerShell" in the Start Menu):

```pwsh
wsl --install
```

<div class="figure">
    <img src="./powershell.jpg" alt="Searching PowerShell in Windows Start Menu" />
    <p>How to open PowerShell with administrative permission</p>
</div>

Alternatively, install from GitHub:

```pwsh
wsl --install --web-download
```

**If you would like more flexibility:**

Run this to see all available distros:

```pwsh
wsl --list --online
```

And install your favourite distro from Microsoft Store (replace `<distro>` with your preference, add `--web-download` if you prefer GitHub download):

```pwsh
wsl --install -d <distro> [--web-download]
```

### Offline Install

If you don't have a steady connection to Microsoft Store or GitHub, then choose this method.

#### Step 1: Run WSL installer

Download from [this mirror on SJTU Pan](https://pan.sjtu.edu.cn/web/share/a873a19ff4cb5903469942925769f286), and run this installer.

**Note:** Only x64 versions are provided. If you have an arm-based Windows, go to [the official WSL release on GitHub](https://github.com/microsoft/WSL/releases/latest) to download an arm64 version.

#### Step 2: Open PowerShell

Search in your Start Menu for "Windows PowerShell", and select "Run as administrator".

#### Step 3: Enable virtualization feature

Paste this line into PowerShell and run it.

```pwsh
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

<div class="figure">
    <img src="./dism-complete.png" alt="DISM complete status" />
    <p>The successful result of DISM</p>
</div>

#### Step 4: Restart your computer

Restart the system to apply the changes.

#### Step 5: Install a distro

Choose a distro from [this mirror folder on SJTU Pan](https://pan.sjtu.edu.cn/web/share/f0afe5d2cdc9c0a573c76f3ec3efe108), and run it by double clicking on the downloaded file.

**Note:** You don't need to download all three files. Choosing one is enough.

**Note:** Only x64 versions of Ubuntu, Debian, and Arch Linux are provided. If you want other distros, or you have an arm-based Windows, go to [this file on GitHub](https://github.com/microsoft/WSL/blob/master/distributions/DistributionInfo.json) to download the version of the distro you prefer.

### Post-install Setup

After you complete your installation, WSL should automatically run. If it doesn't, open PowerShell and type `wsl`.

After booting into WSL, based on the distro you installed, you should perform different steps.

**Note:** Steps for only Ubuntu/Debian and Arch are shown here. If you installed a distro other than these three, refer to the documentation of your distro on your own. The number one principle is: **don't use `root` as your default user.**

#### Ubuntu and Debian

After you boot into WSL for the first time, the system would prompt you for a username and a password. Follow these steps:

1. Choose a username with **only lowercase letters and numbers**. The username does not need to be the same as your Windows username. Note that you can't use `root` as your username since it's reserved.
2. Type in any password with at least 6 characters of your choice. The password does not need to be the same as your Windows login password. Note that the password you entered **will not be shown on screen**. Don't panic and type normally if you see nothing appears. **Make sure to keep this password in mind as it will be used many times afterwards.**

<div class="figure">
    <img src="./setup-unix-user.png" alt="Linux user setup" />
    <p>The setup of a Linux user</p>
</div>

After setting up the username and password, you are good to go. Type `exit` to exit WSL.

#### Arch

For Arch, when you boot into WSL for the first time, you should be straight in a window with `root@xxx` as a prefix. In this case, we will create an account other than `root` for login. **After you boot into WSL**, follow these steps:

1. Set a password for `root`. Note that the password you entered **will not be shown on screen**. Don't panic and type normally if you see nothing appears. **Make sure to keep this password in mind.**

```bash
passwd
```

<div class="figure"><img src="./passwd-success.png" alt="Successful passwd command" /><p>The successful result of <code>passwd</code></p></div>

2. Create a new user with admin privileges. Replace `<username>` with your preferred username. The username should **only contain lowercase letters and numbers**.

```bash
useradd -m -G wheel <username>
```

3. Set a password for your newly created user. Note that the password you entered **will not be shown on screen**. Don't panic and type normally if you see nothing appears. **Make sure to keep this password in mind as it will be used many times afterwards.**

```bash
passwd <username>
```

<div class="figure"><img src="./useradd-success.png" alt="Successful useradd command" /><p>The successful result of <code>useradd</code></p></div>

4. Exit WSL.

```bash
exit
```

5. Shutdown WSL.

```bash
wsl --shutdown
```

6. Change the default login user.

```bash
wsl --manage archlinux --set-default-user <username>
```

After these steps, you are good to go.

## Troubleshooting

If you have any problem during the above installation steps, firstly refer to this section for help. If none of these cases apply, reach to any one of our team for in-person assistance.

### Case 1: Error with code 0x800701bc or Error with link "https://aka.ms/wsl2kernel" attatched

Go to [this mirror on SJTU Pan](https://pan.sjtu.edu.cn/web/share/6c95fbcb03dda858863ff7a64814844f) to download a patch and install it. Then start WSL again.

Alternatively, go to the provided https://aka.ms/wsl2kernel link to download.

### Case 2: Error telling you Hyper-V is not enabled

Search for "Turn Windows features on or off" (启⽤或关闭Windows功能) in Start Menu and open it. Find "Hyper-V" and tick all boxes. Then restart your PC and start WSL again.

<div class="figure">
    <img src="./turn-windows-feature-on-or-off.png" alt="Find Turn Windows features on and off in Start Menu" />
    <p>How to find "Turn Windows feature on or off"</p>
</div>

Alternatively, if you failed to find "Turn Windows features on or off" in the Start Menu, go to "Control Panel" > "Programs" > "Turn Windows features on or off", and continue as stated above.

#### Case 2.1 - No Hyper-V Settings

You should check whether your PC supports WSL 2. See the above section [Requirements (for WSL 2)](#requirements-for-wsl-2).

#### Case 2.2 - Some of the settings can't be ticked

This might be an issue with your hardware. Please refer to section "How to Enable Hardware Virtualization in BIOS" in [this blog post](https://www.makeuseof.com/windows-11-enable-hyper-v/) and try to enable hardware virtualization.

### Case 3: Error telling you "Catastrophic failure" (灾难性故障)

This error may be due to corruptions during wsl installation. A reinstall may work.

You can try one of the following fixes:

- **Choice A:** Directly fix through `wsl` command.

```bash
wsl --update
```

- **Choice B:** Disable and re-enable WSL.

1. Disable WSL and Virtualization in PowerShell:

```bash
Disable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart
Disable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -NoRestart
```

1. Restart your computer.

2. Re-enable these two features:

```bash
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

- **Choice C:** Fix through WSL installer.

Perform [the offline install "Step 1"](#step-1-run-wsl-installer) stated before.

- **Choice D:** Use Appx system to reinstall.

1. Remove the WSL AppxPackage:

```bash
Get-AppxPackage MicrosoftCorporationII.WindowsSubsystemforLinux -AllUsers | Remove-AppxPackage
```

1. Reinstall WSL as AppxPackage through the `wsl` command:

```bash
wsl --update --web-download
```

### Case 4: Error with code 0x80370114

Run this command in PowerShell to disable "Windows Hypervisor Platform":

```bash
Disable-WindowsOptionalFeature -Online -FeatureName "HypervisorPlatform" -NoRestart
```

Then restart your computer.

Alternatively, go to "Turn Windows features on or off" (启⽤或关闭 Windows 功能) and unselect "Windows Hypervisor Platform" (Windows 虚拟机监控程序平台). Then restart your computer.

<div class="figure">
    <img src="./windows-features.png" alt="The Windows features to turn on and off" />
    <p>Diagram of what to turn on and off</p>
</div>

### Case 5: Error with code 0x8007019e

You could try one of the following fixes:

- **Choice A:** Explicitly set the default version of WSL.

```bash
wsl --set-default-version 2
```

- **Choice B:** Fix through `wsl` directly.

```bash
wsl --update
```

- **Choice C:** Try [the solution to Case 2.1](#case-21-no-hyper-v-settings).

### Case 6: Ubuntu files not found

<div class="figure">
    <img src="./ubuntu-file-not-found.png" alt="Ubuntu file not found" />
    <p>Symptom of the Ubuntu files not found problem</p>
</div>

This may be due to changes of the path of Ubuntu files. Try uninstall Ubuntu by:

```bash
wsl --unregister Ubuntu
```

And reinstall a distro by following the install instructions.

### Case 7: `wsl` command not found

Install `wsl` with `winget`:

```bash
winget install Microsoft.WSL
```

### None of these cases apply

Search on Google or ask AI with the error message on your screen for help.

If you are checking web resources, it is highly recommended to go to professional websites and forums like StackOverflow, Microsoft Doc, or GitHub issues.
