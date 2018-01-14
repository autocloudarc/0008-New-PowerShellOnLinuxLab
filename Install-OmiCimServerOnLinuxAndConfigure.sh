#!/bin/sh
# Install Windows PowerShell Core 6.0 on Linux
# https://github.com/PowerShell/PowerShell/blob/master/docs/installation/linux.md
# https://www.ostechnix.com/how-to-install-windows-powershell-in-linux/
# https://blogs.technet.microsoft.com/heyscriptingguy/2016/09/28/part-1-install-bash-on-windows-10-omi-cim-server-and-dsc-for-linux/
# https://blogs.technet.microsoft.com/heyscriptingguy/2016/10/05/part-2-install-net-core-and-powershell-on-linux-using-dsc/
# https://blogs.msdn.microsoft.com/linuxonazure/2017/02/12/extensions-custom-script-for-linux/
# https://azure.microsoft.com/en-us/blog/automate-linux-vm-customization-tasks-using-customscript-extension/
# http://www.powershellmagazine.com/2014/05/21/installing-and-configuring-dsc-for-linux/
# https://docs.microsoft.com/en-us/windows-server/administration/Linux-Package-Repository-for-Microsoft-Software
# https://serverfault.com/questions/616435/centos-7-firewall-configuration
# https://help.ubuntu.com/16.04/ubuntu-help/net-firewall-on-off.html
# https://www.cyberciti.biz/faq/howto-configure-setup-firewall-with-ufw-on-ubuntu-linux/
# https://doc.opensuse.org/documentation/leap/security/html/book.security/cha.security.firewall.html#sec.security.firewall.fw
# https://docs.saltstack.com/en/latest/topics/tutorials/firewall.html
# http://www.linuxcommand.org/man_pages/yum8.html
# https://help.ubuntu.com/lts/serverguide/firewall.html
# https://blogs.technet.microsoft.com/stefan_stranger/2017/01/12/installing-linux-packages-on-an-azure-vm-using-powershell-dsc/
# https://docs.microsoft.com/en-us/azure/automation/automation-dsc-onboarding
# https://msdn.microsoft.com/en-us/powershell/dsc/lnxfileresource
# Get prerequisites for OMI CIM server and DSC

targetDir="/root/downloads"
DevTools="Development Tools"
omiRpmUri="https://github.com/Microsoft/omi/releases/download/v1.1.0-0/omi-1.1.0.ssl_100.x64.rpm"
dscRpmUri="https://github.com/Microsoft/PowerShell-DSC-for-Linux/releases/download/v1.1.1-294/dsc-1.1.1-294.ssl_100.x64.rpm"
omiDebUri="https://github.com/Microsoft/omi/releases/download/v1.1.0-0/omi-1.1.0.ssl_100.x64.deb"
dscDebUri="https://github.com/Microsoft/PowerShell-DSC-for-Linux/releases/download/v1.1.1-294/dsc-1.1.1-294.ssl_100.x64.deb"
omiRpmPackage="omi-1.1.0.ssl_100.x64.rpm"
dscRpmPackage="dsc-1.1.1-294.ssl_100.x64.rpm"
omiDebPackage="omi-1.1.0.ssl_100.x64.deb"
dscDebPackage="dsc-1.1.1-294.ssl_100.x64.deb"
powershellRepPubKeyUri="https://packages.microsoft.com/keys/microsoft.asc"
powershellForOpenSuSEUri="https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-beta.1/powershell-6.0.0_beta.1-1.suse.42.1.x86_64.rpm"
# Create download and installation for OMI Server
if [ ! -d "$targetDir" ]; then
    mkdir "$targetDir"
fi

# To check Linux distro, use: 
linuxDistro=$(cat /etc/os-release | grep -i '^NAME=')
if echo "$linuxDistro" | grep -q -i "Ubuntu"; then
    # Install repository configuration
    # curl https://packages.microsoft.com/config/rhel/7/prod.repo > ./microsoft-prod.repo
    # sudo cp ./microsoft-prod.repo /etc/yum.repos.d/
    # Install Microsoft's GPG public key
    # curl https://packages.microsoft.com/keys/microsoft.asc > ./microsoft.asc
    # sudo rpm --import ./microsoft.asc
    
    # Install OMI and DSC pre-requisites
    # apt-get -y install build-essential
    # apt-get -y install pkg-config
    # apt-get -y install python
    # apt-get -y install python-dev
    # apt-get -y install libpam-dev
    # apt-get -y install libssl-dev
    # Change to install directory
    # cd "$targetDir"
    # Get OMI and DSC packages
    # wget "$omiDebUri"
    # wget "$dscDebUri"
    # Intall OMI and DSC packages
    # dpkg -i "$omiDebPackage"
    # dpkg -i "$dscDebPackage"
    # Enable, configure and reload firewall to support PowerShell remoting
    # ufw enable
    # ufw allow 5986/tcp
    # ufw allow 22/tcp
    # ufw reload
    # To check firwall, use: ufw status verbose

    # Install PowerShell Core 6.0
    # Add PowerShell repository public key
    
    # Uncomment after testing [22 DEC 2017]
    # curl "$powershellRepPubKeyUri" | apt-key add -
    
    # Add PowerShell repository
    
    # Uncomment after testing [22 DEC 2017]
    # curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list
    
    # Update software sources list
    
    # Uncomment after testing [22 DEC 2017]
    # apt-get update

    # Install PowerShell
    # Uncomment after testing [22 DEC 2017]
    # apt-get install -y powershell

    # Enable DSC
    /opt/microsoft/dsc/Scripts/dsc.py -enable

elif echo "$linuxDistro" | grep -q -i "CentOS"; then
    # Install repository configuration
    # curl https://packages.microsoft.com/config/rhel/7/prod.repo > ./microsoft-prod.repo
    # sudo cp ./microsoft-prod.repo /etc/yum.repos.d/
    # Install Microsoft's GPG public key
    # curl https://packages.microsoft.com/keys/microsoft.asc > ./microsoft.asc
    # sudo rpm --import ./microsoft.asc

    # Install OMI and DSC pre-requisites
    # yum -y groupinstall $DevTools
    # yum -y install python
    # yum -y install python-devel
    # yum -y install pam-devel
    # yum -y install openssl-devel
    # Change to the Downloads directory and download the OMI CIM and DSC packages
    # cd "$targetDir"
    # wget "$omiRpmUri"
    # wget "$dscRpmUri"
    # rpm -Uvh "$omiRpmPackage"
    # rpm -Uvh "$dscRpmPackage"
    # After the OMI CIM server is installed, start firewall, configure for PowerShell remoting and reload to apply configuration
    # systemctl start firewalld.service
    # firewall-cmd --zone=public --add-port=5986/tcp --permanent
    # firewall-cmd --zone=public --add-port=22/tcp --permanent
    # firewall-cmd --reload
    # To check this configuration after logging in, use:
    # sudo firewall-cmd --zone=public --list-all

    # Install PowerShell Core 6.0
    # Add PowerShell repository
    
    # Uncomment after testing [22 DEC 2017]
    # curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/microsoft.repo
    
    # Update software sources list
    
    # Uncomment after testing [22 DEC 2017]
    # yum update -y
    
    # Install PowerShell
    
    # Uncomment after testing [22 DEC 2017]
    # yum install -y powershell

    # Enable DSC
    /opt/microsoft/dsc/Scripts/dsc.py -enable

elif echo "$linuxDistro" | grep -q -i "openSUSE Leap"; then
    # rpm -Uvh http://packages.microsoft.com/config/sles/12/packages-microsoft-prod.rpm

    # Install OMI and DSC pre-requisites
    # zypper --non-interactive install python
    # zypper --non-interactive install python-devel
    # zypper --non-interactive install pam-devel
    # zypper --non-interactive install openssl-devel
    # Change to the Downloads directory and download the OMI CIM and DSC packages
    # cd "$targetDir"
    # wget "$omiRpmUri"
    # wget "$dscRpmUri"
    # rpm -Uvh "$omiRpmPackage"
    # rpm -Uvh "$dscRpmPackage"
    # After the OMI CIM server is installed, start firewall, configure for PowerShell remoting and restart firewall to apply configurtion
    # systemctl enable SuSEfirewall2
    # SuSEfirewall2 open EXT TCP 5986
    # SuSEfirewall2 open EXT TCP 22
    # systemctl restart SuSEfirewall2.service
    # SuSEfirewall2 on
    # To check, use: sudo SuSEfirewall2 status | grep 5986
    # Install PowerShell Core 6.0
    # Add PowerShell repository
    
    # Uncomment after testing [22 DEC 2017]
    # rpm --import "$powershellRepPubKeyUri"
    
    # Install PowerShell
    
    # Uncomment after testing [22 DEC 2017]
    # zypper --non-interactive install "$powershellForOpenSuSEUri"
    
    # sudo zypper remove powershell
    
    # Enable DSC
    /opt/microsoft/dsc/Scripts/dsc.py -enable
fi

# If installing using Linux custom script extensions to an Azure VM, check results using...
# sudo cat /var/log/azure/Microsoft.OSTCExtensions.CustomScriptForLinux/1.5.2.1/extension.log
# sudo cat /var/log/azure/Microsoft.OSTCExtensions.DSCForLinux/2.2.0.0/extension.log

<<COMMENT2
TESTING INSTALLATION AND CONFIGURATION OF PRE-REQUISITES

1. OMI Server
Show OMI server version:
/opt/omi/bin/omiserver -v
Show OMI server help:
/opt/omi/bin/omiserver -h
Shows the OMI server configuration file
vi /etc/opt/omi/conf/omiserver.conf
Shows the OMI server log file
vi /var/opt/omi/log/omiserver.log
Restart OMI: sudo /opt/omi/bin/service_control restart
Test OMI: sudo /opt/omi/bin/omicli ei root/omi OMI_Identify

2. DSC
Get DSC configuration
sudo /opt/microsoft/dsc/Scripts/GetDscConfiguration.py
Get LCM configuration
sudo /opt/microsoft/dsc/Scripts/GetDscLocalConfigurationManager.py
Install a DSC custom module
sudo /opt/microsoft/dsc/Scripts/InstallModule.py /tmp/cnx_Resource.zip
Remove a DSC custom module
sudo /opt/microsoft/dsc/Scripts/RemoveModule.py cnx_Resource
Applies a configuration MOF file to the computer
sudo /opt/microsoft/dsc/Scripts/StartDscLocalConfigurationManager.py –configurationmof /tmp/localhost.mof
Applies a Meta Configuration MOF file to the compute
sudo /opt/microsoft/dsc/Scripts/SetDscLocalConfigurationManager.py –configurationmof /tmp/localhost.meta.mof
Shows the DSC log file
sudo cat /var/opt/omi/log/dsc.log

3. Show the contents of the /tmp/dir/file as "hello world" as configured by the AddLinuxFileConfig.localhost DSC Node Configuration from Azure Automation DSC
sudo cat /tmp/dir/file
COMMENT2
