## DESCRIPTION
This script creates up to 6 VMs, including Windows and Linux, however the number of Windows VMs can be user specified with the -WindowsInstanceCount parameter and integer values from 0-3. 
This script will create a set of Azure VMs to demonstrate Windows PowerShell and Azure Automation DSC functionality on Linux VMs. The deployment of Windows VMs are not essential for a basic demonstration of PowerShell on Linux, 
but will be required if Azure based Windows Push or Pull servers will be used in the lab. This script will be enhaced to eventually include those features also. 
Initially, the focus will be to simply configure the Linux distros to support Azure Automation DSC and PowerShell.  

The following VM instances will be deployed.
1) 0-3x Windows Server 2016
2) 1x UbuntuServer LTS 16.04
3) 1x CentOS 7.3
4) 1x openSUSE-Leap 42.2

EXAMPLE 1
New-PowerShellOnLinuxLab.ps1 -WindowsInstanceCount 2

EXAMPLE 2
New-PowerShellOnLinuxLab.ps1 

REQUIREMENTS:

1. A Windows Azure subscription

2. Windows OS (Windows 7/Windows Server 2008 R2 or greater)

3. Windows Management Foundation (WMF 5.0 or greater installed to support PowerShell 5.0 or higher version)
   [link](https://docs.microsoft.com/en-us/powershell/wmf/readme)

4. SSH key pair to authenticate to the Linux VMs. When the script executes, a prompt will appear asking for the public key path.
   [link](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/ssh-from-windows)

**FEEDBACK**
Feel free to ask questions, provide feedback, contribute, file issues, etc. so we can make this even better!