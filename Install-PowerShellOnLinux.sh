#!/bin/sh
# Install Windows PowerShell Core 6.0 on Linux
# https://github.com/PowerShell/PowerShell/blob/master/docs/installation/linux.md
# https://www.ostechnix.com/how-to-install-windows-powershell-in-linux/
# https://blogs.technet.microsoft.com/heyscriptingguy/2016/09/28/part-1-install-bash-on-windows-10-omi-cim-server-and-dsc-for-linux/
# https://blogs.technet.microsoft.com/heyscriptingguy/2016/10/05/part-2-install-net-core-and-powershell-on-linux-using-dsc/
# https://blogs.msdn.microsoft.com/linuxonazure/2017/02/12/extensions-custom-script-for-linux/
# https://azure.microsoft.com/en-us/blog/automate-linux-vm-customization-tasks-using-customscript-extension/
# https://docs.microsoft.com/en-us/windows-server/administration/Linux-Package-Repository-for-Microsoft-Software
# http://www.linuxcommand.org/man_pages/yum8.html
# https://blogs.technet.microsoft.com/stefan_stranger/2017/01/12/installing-linux-packages-on-an-azure-vm-using-powershell-dsc/
# https://msdn.microsoft.com/en-us/powershell/dsc/lnxfileresource
# https://github.com/PowerShell/PowerShell/blob/master/docs/installation/linux.md
# https://github.com/Azure/azure-linux-extensions/tree/master/CustomScript


powershellRepPubKeyUri="https://packages.microsoft.com/keys/microsoft.asc"

# To check Linux distro, use: 
linuxDistro=$(cat /etc/os-release | grep -i '^NAME=')

if echo "$linuxDistro" | grep -q -i "Ubuntu"; then 
    # Install PowerShell Core 6.0
    # Add PowerShell repository public key
    curl "$powershellRepPubKeyUri" | apt-key add -
    # Register the Microsoft Ubuntu repository   
    curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
    # Update software sources list
    apt-get update
    # Install PowerShell
    sudo apt-get install -y powershell
elif echo "$linuxDistro" | grep -q -i "CentOS"; then
    # Install PowerShell Core 6.0
    # Add PowerShell repository
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo  

    # Install PowerShell   
    sudo yum install -y powershell
elif echo "$linuxDistro" | grep -q -i "openSUSE Leap"; then
    # Install PowerShell Core 6.0
    # Register the Microsoft signature key  
    sudo rpm --import "$powershellRepPubKeyUri"
    # Add the Microsoft Product feed
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/zypp/repos.d/microsoft.repo
    # Update the list of products
    sudo zypper --non-interactive update
    # Install PowerShell
    sudo zypper --non-interactive install powershell
    # sudo zypper remove powershell
fi

# If installing using Linux custom script extensions to an Azure VM, check results using...
# sudo cat /var/log/azure/Microsoft.OSTCExtensions.CustomScriptForLinux/<version>/extension.log
# sudo cat /var/log/azure/Microsoft.OSTCExtensions.DSCForLinux/2.2.0.0/extension.log

<<COMMENT2
1. Show the contents of the /tmp/dir/file as "hello world" as configured by the AddLinuxFileConfig.localhost DSC Node Configuration from Azure Automation DSC
sudo cat /tmp/dir/file
COMMENT2
