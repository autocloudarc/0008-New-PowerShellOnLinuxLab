# DESCRIPTION
This script creates the following 6 VMs, however the number of Windows VMs can be user specified with the -WindowsInstanceCount parameter with integer values from 0-3. 
This script will create a set of Azure VMs to demonstrate Windows PowerShell and Azure Automation DSC functionality on Linux VMs. The set of VMs that will be created are listed below in the .OUTPUTS help tag. 
however the number of Windows VMs is user specified from 0-3, since the deployment of Windows VMs are not essential for a basic demonstration of PowerShell on Linux, but will be required if Windows Push or Pull 
servers will be used in the lab. This project will be enhaced to eventually include those features also, but initially, the focus will be on configuring the Linux distros to support Azure Automation DSC and PowerShell.  
1) 3 x Windows Server 2016
2) 1 x UbuntuServer LTS 16.04
3) 1 x CentOS 7.3
4) 1 x openSUSE-Leap 42.2

EXAMPLE
.\New-PowerShellOnLinuxLab -WindowsInstanceCount 2

CURRENT STATUS: In development
REQUIREMENTS: SSH key pair to authenticate to the Linux VMs. When the scrit executes, a prompt will appear asking for the public key path. 
              WriteToLogs module [link](https://www.powershellgallery.com/packages/WriteToLogs). This will be downloaded and installed automatically.

LIMITATIONS	: Windows VM configurations and integration as Push/Pull servers.
AUTHOR(S)  	: Preston K. Parsard; [link](https://github.com/autocloudarc)
EDITOR(S)  	: Preston K. Parsard; [link](https://github.com/autocloudarc)
KEYWORDS   	: Linux, Azure, PowerShell, DSC 

After the script has been executed and all resources deployed, the following operations can be performed to test that PowerShell and DSC has been installed and functional.

**AZURE AUTOMATION DSC LINUX DEMO - TESTED ON: UbuntuServer LTS 16.04, CentOS 7.3 & openSUSE-Leap 42.2**
====================================================================================================
$linuxuser@AZREAUS2LNX01~$ `sudo cat /tmp/dir/file`
hello world
 
$linuxuser@AZREAUS2LNX01~$ powershell
PS /home/linuxuser> `Get-Content -Path /tmp/dir/file`
hello world
 
# **POWERSHELL ON LINUX DEMO - TESTED ON: UbuntuServer LTS 16.04, CentOS 7.3 & openSUSE-Leap 42.2**
# ====================================================================================================
[link](https://www.ostechnix.com/how-to-install-windows-powershell-in-linux/)

 0. Open powershell
 $linuxuser@AZREAUS2LNX01~$ `powershell`

 1. View the PowerShell version
 PS /home/linuxuser> `$PSVersionTable`

 2. Create a new file.
 PS /home/linuxuser> `New-Item -Path ./File.txt -ItemType File`

 3. Append content to a file.
 PS /home/linuxuser> `Set-Content -Path ./File.txt -Value "Hello PowerShell!"`

 4. Get contents of a file.
 `PS /home/linuxuser> `Get-Content -Path ./File.txt`

 5. Remove a file
 PS /home/linuxuser> `Remove-Item -Path ./File.txt`

 6. Test file removal
 PS /home/linuxuser> `Get-Content -Path ./File.txt`

 7. Get running processes
 PS /home/linuxuser> `Get-Process`

 8. Get a specific process
 PS /home/linuxuser> `Get-Process -Name powershell`

 9. Get aliases
 PS /home/linuxuser> `Get-Alias`

 10.Get a specific alias
 PS /home/linuxuser> `Get-Alias -Name cls`

 11.List all commands
 PS /home/linuxuser> `Get-Command`

 12.Count all commands available on system
 PS /home/linuxuser> `(Get-Command).Count`

 13. Get help for a cmdlet
 PS /home/linuxuser> `Get-Help -Name Clear-Host`

 14. Exit the PowerShell console
 PS /home/linuxuser> `exit`