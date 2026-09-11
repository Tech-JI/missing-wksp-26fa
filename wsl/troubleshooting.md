# WSL Troubleshooting Guide

This document collects common problems that may occur while installing or using **WSL 2, Ubuntu, and VS Code on Windows**.

If your problem is not covered here, please provide a **complete screenshot of the error message** in the group chat or contact **Zhou Zhaojiacheng** directly.

When asking for help, please include:

- Your Windows version

- The command you ran

- The full error message

- Which step you were on when the problem occurred

- The output of `wsl --status`, if available

- The output of `wsl --list --verbose`, if available

---

## Before Troubleshooting: PowerShell or Ubuntu?

Some commands in this document must be executed in **Windows PowerShell / Windows Terminal**, while others must be executed inside **Ubuntu / WSL**.

A Windows PowerShell prompt usually looks like:

```text

PS C:\Users\username>

```

or:

```text

C:\Users\username>

```

A WSL / Ubuntu prompt usually looks like:

```text

username@computer:~$

```

For example:

```powershell

wsl --list --verbose

```

must be executed in **Windows PowerShell / Windows Terminal**.

Commands such as:

```bash

sudo apt update

```

must be executed **inside Ubuntu / WSL**.

---

## Case 1: Ubuntu Starts as `root` and Did Not Ask for a Username or Password

Normally, Ubuntu should ask you to create a username and password when it is started for the first time.

If Ubuntu starts directly and your terminal prompt looks similar to:

```text

root@computer:~#

```

then you are currently using the `root` user.

WARNING

Do not use `root` as your default user for normal development work.
Create a normal user:

```bash

adduser <username>

```

Replace `<username>` with the username you want to use.

For example:

```bash

adduser sherry

```

Then add the new user to the `sudo` group:

```bash

usermod -aG sudo <username>

```

For example:

```bash

usermod -aG sudo sherry

```

Exit WSL:

```bash

exit

```

Now, in **Windows PowerShell / Windows Terminal**, check the exact name of your installed Linux distribution:

```powershell

wsl --list

```

or:

```powershell

wsl --list --verbose

```

You may see something similar to:

```text

NAME            STATE           VERSION

Ubuntu-24.04    Stopped         2

```

Set your new user as the default user:

```powershell

wsl --manage Ubuntu-24.04 --set-default-user <username>

```

For example:

```powershell

wsl --manage Ubuntu-24.04 --set-default-user sherry

```

Then enter WSL again:

```powershell

wsl

```

If the prompt now looks like:

```text

sherry@computer:~$

```

the default user has been changed successfully.

If `wsl --manage` does not work on your system, ask for assistance before making further changes.

---

## Case 2: Nothing Appears When I Type My Password

This is normal behavior in Linux terminals.

When entering a password:

- The password is not displayed

- No `*` characters are displayed

- The cursor may appear not to move

For example:

```bash

sudo apt update

```

may display:

```text

[sudo] password for username:

```

Simply type your password normally and press Enter.

NOTE

Even though nothing appears on the screen, your keyboard input is still being received.
If you think you entered the wrong password while setting up a command, you can usually press:

```text

Ctrl + C

```

to cancel the current command and try again.

---

## Case 3: Error Code `0x800701bc` or a Link to `https://aka.ms/wsl2kernel`

You may see an error similar to:

```text

WslRegisterDistribution failed with error: 0x800701bc

```

or a message containing:

```text

https://aka.ms/wsl2kernel

```

This usually means that the WSL 2 Linux kernel update package is required.

Download and install the WSL kernel update package, then start WSL again.

You can also refer to Microsoft's WSL 2 kernel update instructions:

```text

https://learn.microsoft.com/windows/wsl/install-manual

```

After installation, try:

```powershell

wsl

```

again.

---

## Case 4: Windows Says Virtualization or Hyper-V Is Not Enabled

Search for:

```text

Turn Windows features on or off

```

or, on a Chinese Windows installation:

```text

启用或关闭 Windows 功能

```

Check the relevant virtualization-related Windows features.

In particular, WSL 2 requires:

```text

Virtual Machine Platform

```

and:

```text

Windows Subsystem for Linux

```

If you are following the Workshop installation guide, enable the required features and restart your computer.

You can also enable Virtual Machine Platform from an administrator PowerShell:

```powershell

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

```

After enabling the feature, restart Windows.

---

## Case 5: "Virtual Machine Platform" Cannot Be Found

The feature is usually named:

```text

Virtual Machine Platform

```

On Chinese Windows, it is usually displayed as:

```text

虚拟机平台

```

If you cannot find it, check your Windows version:

```powershell

systeminfo

```

Also check whether hardware virtualization is enabled in BIOS / UEFI.

Your computer must support WSL 2 and hardware virtualization.

Refer to the `Requirements (for WSL 2)` section in the main installation document.

---

## Case 6: Some Virtualization Settings Cannot Be Enabled

If some virtualization-related Windows features cannot be enabled, hardware virtualization may be disabled.

You may need to enable virtualization in BIOS / UEFI.

Depending on your CPU and motherboard, the setting may have names such as:

```text

Intel Virtualization Technology

```

or:

```text

AMD-V

SVM Mode

```

After enabling hardware virtualization, save the BIOS / UEFI settings, restart Windows, and try again.

---

## Case 7: Error "Catastrophic Failure" / 灾难性故障

This problem may be caused by a corrupted WSL installation.

Try the following solutions in order.

### Choice A: Update WSL

Open **Windows PowerShell** and run:

```powershell

wsl --shutdown

wsl --update

```

Then try starting WSL again:

```powershell

wsl

```

---

### Choice B: Disable and Re-enable WSL Features

Open **Windows PowerShell as Administrator**.

Disable WSL and Virtual Machine Platform:

```powershell

Disable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart

Disable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -NoRestart

```

Restart your computer.

Then open PowerShell as Administrator again and re-enable them:

```powershell

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

```

Restart your computer again.

---

### Choice C: Reinstall WSL Using the Installer

Download and run the WSL installer again.

If you are using the Workshop offline installation method, follow the WSL installer step in the main installation guide.

---

### Choice D: Reinstall the WSL App Package

Open PowerShell as Administrator:

```powershell

Get-AppxPackage MicrosoftCorporationII.WindowsSubsystemforLinux -AllUsers | Remove-AppxPackage

```

Then reinstall/update WSL:

```powershell

wsl --update --web-download

```

After installation, restart Windows if necessary.

---

## Case 8: Error Code `0x80370114`

If you encounter:

```text

WslRegisterDistribution failed with error: 0x80370114

```

try disabling **Windows Hypervisor Platform**.

Open PowerShell as Administrator:

```powershell

Disable-WindowsOptionalFeature -Online -FeatureName "HypervisorPlatform" -NoRestart

```

Then restart your computer.

Alternatively:

1. Open `Turn Windows features on or off`

2. Find:

```text

Windows Hypervisor Platform

```

3. Uncheck it

4. Restart Windows

---

## Case 9: Error Code `0x8007019e`

If you see:

```text

WslRegisterDistribution failed with error: 0x8007019e

```

try the following solutions.

### Choice A: Set WSL 2 as the Default Version

Run in Windows PowerShell:

```powershell

wsl --set-default-version 2

```

Then try starting Ubuntu again.

---

### Choice B: Update WSL

```powershell

wsl --update

```

Then restart WSL:

```powershell

wsl --shutdown

wsl

```

---

### Choice C: Check WSL and Virtualization Features

Make sure that:

```text

Windows Subsystem for Linux

```

and:

```text

Virtual Machine Platform

```

are enabled.

Restart Windows after changing these features.

---

## Case 10: Ubuntu Files Cannot Be Found

If Ubuntu reports that required files cannot be found, the Ubuntu installation or its file path may have been damaged.

First check the installed distributions:

```powershell

wsl --list --verbose

```

If Ubuntu is listed, try:

```powershell

wsl --shutdown

```

and then:

```powershell

wsl -d Ubuntu

```

or, depending on the distribution name:

```powershell

wsl -d Ubuntu-24.04

```

If Ubuntu is still broken and you are sure you want to reinstall it, you may unregister the distribution.

First check the exact distribution name:

```powershell

wsl --list --verbose

```

Then run:

```powershell

wsl --unregister Ubuntu

```

or:

```powershell

wsl --unregister Ubuntu-24.04

```

depending on the actual name.

WARNING

`wsl --unregister` permanently deletes the Linux files, installed software, user accounts, and configuration stored inside that distribution.

Do not run this command if you have important files that have not been backed up.
After unregistering the broken distribution, reinstall Ubuntu.

---

## Case 11: Ubuntu Opens and Immediately Closes

Even if the Ubuntu application closes immediately, you do **not** need to enter Ubuntu to troubleshoot it.

Open **Windows PowerShell / Windows Terminal**.

Check the installed distributions:

```powershell

wsl --list --verbose

```

For example:

```text

NAME            STATE           VERSION

Ubuntu-24.04    Stopped         2

```

Try shutting down WSL:

```powershell

wsl --shutdown

```

Then start Ubuntu explicitly:

```powershell

wsl -d Ubuntu-24.04

```

Replace `Ubuntu-24.04` with the exact distribution name shown by:

```powershell

wsl --list --verbose

```

If the distribution is corrupted and you decide to reinstall it, you can run:

```powershell

wsl --unregister Ubuntu-24.04

```

WARNING

This command permanently deletes all data stored inside that WSL distribution.

Back up important files before using it.
---

## Case 12: Windows Says `wsl` Is Not a Recognized Command

If PowerShell reports that:

```text

wsl

```

is not recognized as a command, first make sure that you are using the normal 64-bit **Windows PowerShell**, not:

```text

Windows PowerShell (x86)

```

If the title contains:

```text

(x86)

```

close it and open the normal Windows PowerShell from the Start Menu.

Then try:

```powershell

wsl --help

```

and:

```powershell

wsl --status

```

If WSL is not installed, try:

```powershell

winget install Microsoft.WSL

```

If necessary, open PowerShell as Administrator and enable the required Windows features:

```powershell

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

```

Then restart Windows.

After restarting, install Ubuntu:

```powershell

wsl --install -d Ubuntu

```

Check the installation:

```powershell

wsl -l -v

```

You should see Ubuntu listed.

---

## Case 13: A Linux Command Says `command not found`

If you see:

```text

command not found

```

inside Ubuntu, first check the command carefully.

Check:

1. Whether the command is spelled correctly

2. Whether spaces are in the correct places

3. Whether `-` is a normal English hyphen

For example:

```bash

ls -l

```

is correct.

This means:

```text

ls + space + -l

```

This is incorrect:

```text

ls-l

```

If the command is spelled correctly, the corresponding package may not be installed.

You can update the package list with:

```bash

sudo apt update

```

and install the required package using:

```bash

sudo apt install <package>

```

---

## Case 14: Do I Need Ubuntu, Debian, and Arch at the Same Time?

No.

Ubuntu, Debian, and Arch are different Linux distributions.

You only need **one** distribution.

For beginners in this Workshop, Ubuntu is recommended.

For example:

```text

Ubuntu 24.04 LTS

```

You do not need to install all available distributions.

---

## Case 15: How Do I Check Which Linux Distributions Are Installed?

Run this command in Windows PowerShell:

```powershell

wsl --list --verbose

```

or:

```powershell

wsl -l -v

```

For example:

```text

NAME            STATE           VERSION

* Ubuntu-24.04  Running         2

```

The `*` indicates the default distribution.

The `VERSION` column should normally show:

```text

2

```

when using WSL 2.

---

## Case 16: How Do I Enter Ubuntu from Windows?

Open PowerShell, CMD, or Windows Terminal and run:

```powershell

wsl

```

This starts your default Linux distribution.

To start a specific distribution:

```powershell

wsl -d Ubuntu-24.04

```

Replace `Ubuntu-24.04` with the name shown by:

```powershell

wsl --list --verbose

```

To exit WSL:

```bash

exit

```

You will return to PowerShell or CMD.

---

## Case 17: Why Does WSL Start in `/mnt/c/Users/...` Instead of `~`?

If you run:

```powershell

wsl

```

while PowerShell or CMD is currently in:

```text

C:\Users\username

```

WSL may start in the corresponding mounted Windows directory:

```text

/mnt/c/Users/username

```

This is normal.

To return to your Linux home directory, run:

```bash

cd ~

```

Check your current directory:

```bash

pwd

```

You should see something similar to:

```text

/home/username

```

For Linux development projects, we recommend storing files inside your Linux home directory, for example:

```bash

mkdir -p ~/code

cd ~/code

```

---

## Case 18: Where Is `~` Stored?

In Linux, `~` represents the current user's home directory.

For example, if your username is:

```text

sherry

```

then:

```text

~

```

usually means:

```text

/home/sherry

```

You can check it with:

```bash

echo ~

```

or:

```bash

cd ~

pwd

```

To open the current WSL directory in Windows File Explorer:

```bash

explorer.exe .

```

You can also access WSL files from Windows Explorer through:

```text

\\wsl$\

```

For example:

```text

\\wsl$\Ubuntu-24.04\home\sherry

```

The exact distribution name may be different on your computer.

Check it with:

```powershell

wsl --list --verbose

```

---

## Case 19: How Do I Copy a Windows File into WSL?

Windows drives are mounted under `/mnt` inside WSL.

For example:

```text

C:\Users\username\Documents

```

corresponds to:

```text

/mnt/c/Users/username/Documents

```

To copy a file from Windows into your Linux home directory:

```bash

cp /mnt/c/Users/username/Documents/example.txt ~/

```

To copy an entire directory:

```bash

cp -r /mnt/c/Users/username/Documents/project ~/

```

You can also open the current WSL folder in Windows File Explorer:

```bash

explorer.exe .

```

and drag files between Windows and WSL.

---

## Case 20: VS Code Cannot Open from WSL

VS Code should be installed on **Windows**, while compilers and development tools run inside WSL.

First check whether VS Code is installed on Windows.

In Windows PowerShell:

```powershell

code --version

```

If `code` is not found immediately after installation, close all PowerShell windows and open PowerShell again.

Then enter WSL:

```powershell

wsl

```

Inside WSL, go to your project directory:

```bash

cd ~/code

```

and run:

```bash

code .

```

The first time you run this command, VS Code may install **VS Code Server** inside WSL.

Wait for it to finish.

In VS Code, the bottom-left corner should show something similar to:

```text

WSL: Ubuntu

```

This means VS Code is connected to the WSL environment.

---

## Case 21: VS Code Opens, but GCC / G++ Does Not Work

Make sure GCC and G++ are installed **inside WSL**, not only on Windows.

Enter WSL:

```powershell

wsl

```

Then run:

```bash

sudo apt update

sudo apt install build-essential gdb

```

Check the installation:

```bash

gcc --version

g++ --version

gdb --version

```

If version information is displayed, the tools are installed correctly.

IMPORTANT

For this Workshop, GCC, G++, Make, and GDB should run inside WSL.
---

## Case 22: VS Code Is Not Connected to WSL

Open your project from inside WSL:

```bash

cd ~/code

code .

```

Then check the bottom-left corner of VS Code.

You should see:

```text

WSL: Ubuntu

```

If you do not see it, install the Microsoft WSL extension.

Open the Extensions panel:

```text

Ctrl + Shift + X

```

Search for:

```text

WSL

```

and install the extension provided by Microsoft.

You can also install it from Windows PowerShell:

```powershell

code --install-extension ms-vscode-remote.remote-wsl

```

Then reopen the project from WSL:

```bash

code .

```

---

## Case 23: WSL Shows a `localhost` Proxy Warning

You may see a message similar to:

```text

wsl: Detected localhost proxy configuration, but it is not mirrored into WSL.

NAT mode WSL does not support localhost proxies.

```

This means Windows has a proxy configured using a `localhost` address, while WSL is currently using NAT networking.

If WSL can still access the Internet and commands such as:

```bash

sudo apt update

```

work normally, this warning can usually be ignored for the Workshop.

If WSL cannot access the Internet, include this warning when asking for help.

---

## Case 24: Basic Commands to Collect Diagnostic Information

If you are unsure what is wrong, open **Windows PowerShell** and run:

```powershell

wsl --status

```

Then:

```powershell

wsl --list --verbose

```

You can also check your Windows system information:

```powershell

systeminfo

```

If WSL can start, enter Ubuntu:

```powershell

wsl

```

and run:

```bash

whoami

pwd

```

These commands help identify:

- Which Windows / WSL configuration you are using

- Which Linux distribution is installed

- Whether WSL 1 or WSL 2 is being used

- Which Linux user is active

- Which directory WSL started in

---

## None of These Cases Apply

If none of the above solutions solve your problem, please provide:

```text

1. A complete screenshot of the error

2. Output of: wsl --status

3. Output of: wsl --list --verbose

4. Your Windows version

5. The command you ran before the problem occurred

6. A short description of what you were trying to do

```

Send this information in the group chat or contact **Zhou Zhaojiacheng** directly.

When searching online, prefer reliable technical sources such as:

- Microsoft Learn

- Microsoft WSL documentation

- GitHub Issues

- Stack Overflow

Do not run commands that delete or unregister your WSL distribution unless you understand what they do and have backed up important files.
