#requires -version 5.0
#requires -RunAsAdministrator
<#
****************************************************************************************************************************************************************************************************************
PROGRAM		: New-PowerShellOnLinuxLab.ps1

DESCRIPTION	:
This script creates the following 6 VMs: 
1) 3 x Windows Server 2016
2) 1 x UbuntuServer LTS 16.04
3) 1 x CentOS 7.3
4) 1 x openSUSE-Leap 42.2
Tasks that can be practiced with both a Windows and Linux VMs for Linux deployments is provided here:

1. Install Chocolatey from https://chocloatey.org on the Windows Server to support automated installation of 3rd party tools such as puttygen and putty.
    a. Invoke-Expression ((new-object net.webclient).DownloadString('https://Chocolatey.org/Install.ps1')) 
    b. New-Item -Path c:\data, c:\data\certs, c:\data\scripts -ItemType Directory
    c. Set-Location c:\data\certs

2. Install the Windows Desktop for GitHub from https://desktop.github.com by doing the following:
    a. Download GitHubSetup.exe
    b. Install GitHubSetup.exe
    c. Open the Git Shell console
   *NOTE* This provides a console in a Windows environment to use openssl to create the required ssh key pairs for ssh login to the Linux VMs.

3. Prepare the Windows directory structure by adding the c:\data, c:\data\certs and c:\data\scripts directory
    a. New-Item -Path c:\data, c:\data\certs, c:\data\scripts -ItemType Directory
    b. Set-Location c:\data\certs
    *NOTE* In a production environment, an additional data drive should be added for certificates and scripts, and the scripts should be added to a source control repository.

4. The ssh key pair can now be created to support ssh login to the Linux VMs.

    *NOTE* Options 
    req: CSR
    -x509: certificate type
    -nodes: key is unencrypted
    -days: 365 is the validity period
    -keyout: output file for key
    -out: output file for certificate
    rsa: encryption algorithm
    2048 bit key length
    
    a. openssl.exe req -x509 -nodes -days 365 -newkey rsa:2048 -keyout SSHPrivateKey.key -out SSHCert.pem
    b. Country Name (2 letter code) [AU]:US
    c. State or Province Name (full name [some-state]:NY
    d. Locality name (eg, city) []:New York
    e. Organization Unit ame (eg, section) []:IT
    f. Common name (e.g. server FQDN or YOUR name) []:linux
    g. Email Address: []:admin@contoso.com
    
    h. ls -l

5. The ssh private key must then be converted to the Putty ssh intermediary rsa format for subsequent upgrade to the Putty SSH version.
    i. openssl.exe rsa -in ./SSHPrivateKey.key -out SSHPrivateKey_rsa

6. Install the various putty utlities, such as puttygen and putty using Chocoloatey. 
    a. choco install putty -y
    b. Puttygen will be used to convert the private ssh key to the Putty format with a pass-phrase and the Putty public key will aslo be saved.
    c. Putty can now be used from the Windows machine to access the Linux server using it's Dynamic (private, IP address)

7. After the Linux server is accessed, the Azure CLI 2.0 can be installed after first installing the appropriate pre-requisites:
    --------------------------------------------------------------------
    Platform              | Prerequisites
    ----------------------|---------------------------------------------
    Ubuntu 15.10 or 16.04 | sudo apt-get update && sudo apt-get install -y libssl-dev libffi-dev python-dev build-essential
    Ubuntu 12.04 or 14.04 | sudo apt-get update && sudo apt-get install -y libssl-dev libffi-dev python-dev
    Debian 8              | sudo apt-get update && sudo apt-get install -y libssl-dev libffi-dev python-dev build-essential
    Debian 7              | sudo apt-get update && sudo apt-get install -y libssl-dev libffi-dev python-dev
    CentOS 7.1 or 7.2     | sudo yum check-update; sudo yum install -y gcc libffi-devel python-devel openssl-devel
    RedHat 7.2            | sudo yum check-update; sudo yum install -y gcc libffi-devel python-devel openssl-devel
    SUSE OpenSUSE 13.2    | sudo zypper refresh && sudo zypper --non-interactive install gcc libffi-devel python-devel openssl-devel

8. 4.0 Now that the pre-requisites have been installed, we can proceed with the Azure CLI 2.0 installation using the command below:
    a. curl -L https://aka.ms/InstallAzureCli | bash

9. Finally, we must restart the shell to apply the installation in our shell
    a. exec -l $SHELL

10. After a Linux image has been created and prepared for Azure in Hyper-V or VMWare, it can be uploaded using the following PowerShell script:
$StorageAccountName = "<StorageAccountName>"
$ImageName = "<ImageName>"
$PathToLocalVhd = (Get-ChildItem -Path H:\vhdx).FullName | Where-Object { $_ -match 'JFKSVL04' } | Split-Path -Leaf
$AzureImageDestination = "https://" + $StorageAccountName + ".blob.core.windows.net/vhds/" + $ImageName + ".vhd"
Add-AzureRmVhd -ResourceGroupName rg00 -Destination "https://$StorageAccountName.blob.core.windows.net/vhds/$ImageName.vhd" -LocalFilePath $PathToLocalVhd

11. Next, you can deploy the image by using any of the following methods:
11a. Deploy from a quick start template at: https://azure.microsoft.com/en-us/resources/templates/201-vm-specialized-vhd/
     1. The parameters required are:
        DeployFromSpecializedVhd = @{
        osDiskVhdUri = "https://rg00diag00.blob.core.windows.net/vhds/jfksvl04-syst.vhd"
        osType = "Linux"
        vmSize = "Standard_D1_v2"
        vmName = AZREAUS2LNUX01
        } #end ht

# After the image has been uploaded, you will see:
PS C:\WINDOWS\system32> C:\Users\TEMP.US.003\Desktop\New-AzureRmLinuxVhdUpload.ps1
MD5 hash is being calculated for the file  H:\vhdx\JFKSVL04-SYST.vhd.
MD5 hash calculation is completed.
Elapsed time for the operation: 00:05:18
Creating new page blob of size 32212255232... # 6 GB / hr?
Detecting the empty data blocks in the local file.
Detecting the empty data blocks completed.
Elapsed time for upload: 03:40:40

LocalFilePath             DestinationUri                                                 
-------------             --------------                                                 
H:\vhdx\JFKSVL04-SYST.vhd https://rg00diag00.blob.core.windows.net/vhds/jfksvl04-syst.vhd


11b. Deploy using Azure CLI 2.0: az vm image create <ImageName> --blob-url <BlobStorageURL>/<Container>/<VHDName> --os Linux <PathToVHDFile>
11c. Using PowerShell and an ARM template: New-AzureRmResourceGroupDeployment -Name <deployment-name> -ResourceGroupName <resource-group-name> -TemplateUri https://raw.githubusercontent.com/azure/azure-quickstart-templates/master/201-vm-specialized-vhd/azuredeploy.json
***Please rate this script if it has been helpful and feel free to ask questions or provide feedback at the Q&A tab to let me know how we can make it even better!*** 

12. Deploy a Linux VM in Azure with Azure CLI 2.0.
    https://docs.microsoft.com/en-us/azure/virtual-machines/linux/deploy-linux-vm-into-existing-vnet-using-cli

12a. With managed disks
az vm create \
    --resource-group myResourceGroup \
    --name myVM \
    --image Debian \
    --admin-username azureuser \
    --ssh-key-value ~/.ssh/id_rsa.pub \
    --nics myNic

    mnemonic (azvmc-rniasn: az vm create –-resource-group <rg> --name <vmname> --image <family> --admin-username <username> --ssh-key-value ~/.ssh/id_rsa.pub –nics azreaus2lnux01-nic01 \
    example: 

az vm create --resource-group rg00 --name AZREAUS2LNUX03 --image CentOS --admin-username linuxadmin --generate-ssh-keys --nics lnux03-nic01 --public-ip-address-dns-name azreaus2lnux03-pip --location eastus2 --authentication-type ssh --vnet-address-prefix 10.1.1.0/26 --subnet-address-prefix 10.1.1.24/29 --public-ip-address-allocation static
12b. Without managed disks
        --use-unmanaged-disk \
        --storage-account mystorageaccount

13. Create a VM from your image resource with az vm create:
az vm create --resource-group myResourceGroup --name myVMDeployed --image myImage --admin-username azureuser --ssh-key-value ~/.ssh/id_rsa.pub

14. Create a vm from an available managed disk:
az disk create -g rg00 --name LINUX-CENTOS-SYST  --location eastus2 --size-gb 30 --sku Standard_LRS --source "https://rg00diag00.blob.core.windows.net/vhds/jfksvl04-syst.vhd" --verbose

az network nic create -g rg00 -n lnux03-nic-01 --subnet lnux --vnet vnet00 --verbose
az network public-ip create -g rg00 -n lnux03-pip --dns-name azreaus2lnux03-pip
a. az vm create -g rg00 -n azreaus2lnux03 --attach-os-disk linux-centos-syst --os-type linux --verbose
b. az vm create -g rg00 -n AZREAUS2LNUX03 --attach-os-disk LINUX-CENTOS-SYST --os-type linux--admin-username linuxadmin --generate-ssh-keys --nics lnux03-nic01 --public-ip lnux03-pip --dns-name azreaus2lnux03-pip --location eastus2 --authentication-type ssh --vnet-address-prefix 10.1.1.0/26 --subnet-address-prefix 10.1.1.24/29 --public-ip-address-allocation static

1. Build a machine in Azure and create a scale set.
2. 
3. Thursday. NSEC
3. bin/az vm create -g test-oms -n ansible-trusty --attach-os-disk trusty-system01 --os-type linux --admin-username ansible --ssh-key-value ~/.ssh/azuretrusty.pub --nics trusty-ansible-nic --location eastus2 --authentication-type ssh --public-ip-address-allocation static

1. az disk create -g rg00 --name LINUX-CENTOS-SYST  --location eastus2 --size-gb 30 --sku Standard_LRS --source "https://rg00diag00.blob.core.windows.net/vhds/jfksvl04-syst.vhd" --verbose
2. az network nic create -g <rg> -n <nic-name> --subnet <subnet-name> --vnet <vnet-name> --verbose
3. az network public-ip-address create -g <rg> -n <name-pip> --dns-name <dns-name-pip> --verbose 
3. az vm create -g <rg> -n <vm-name> --attach-os-disk <os-disk-name> --os-type linux --admin-username <linux-username> --ssh-key-value ~/.ssh/rsa_id.pub --nics <nic-name> --location eastus2 --authentication-type ssh --public-ip-address-allocation static --verbose

# DOCKER
1. Install docker on an existing VM and run a container
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/dockerextension
https://github.com/Azure/azure-docker-extension/blob/master/README.md#1-configuration-schema

$resourceGroup = "rg00"
$VMName = "AZREAUS2LNUX04"
$location = "eastus2"
$PublicSettings = '{"docker": {"port": "2375"},"compose": {"web": {"image": "nginx","ports": ["80:80"]}}}'

Set-AzureRmVMExtension -ExtensionName "Docker" -ResourceGroupName $resourceGroup -VMName $vmName `
-Publisher "Microsoft.Azure.Extensions" -ExtensionType "DockerExtension" -TypeHandlerVersion 1.0 `
-SettingString $PublicSettings -Location $location -Verbose

REQUIREMENTS: WriteToLogs module (https://www.powershellgallery.com/packages/WriteToLogs)
LIMITATIONS	: This script does not provision each VM as a domain controller. This normally requires the addition of Desired State Configuration scripts.
AUTHOR(S)	: Preston K. Parsard
EDITOR(S)	: Preston K. Parsard
KEYWORDS	: KEYWORDS: Mnemonic; [R]esilient<[R]esource Group> [N]eed<Virtual [N]etwork> [V]irtual Machines<[VMs] with [N]etworks<[N]etwork Security Groups> and [A]vailability Sets<[A]vailability Sets>
TAGS        : 0007, Microsoft Azure, Virtual Machines, Windows Server 2016, UbuntuServer 16.04 LTS

LICENSE:
The MIT License (MIT)
Copyright (c) 2016 Preston K. Parsard

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. 

LEGAL DISCLAIMER:
This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.  
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  
We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that You agree: 
(i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
(ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
(iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code.
This posting is provided "AS IS" with no warranties, and confers no rights.

REFERENCES: 
1. https://gallery.technet.microsoft.com/scriptcenter/Build-AD-Forest-in-Windows-3118c100
2. http://blogs.technet.com/b/heyscriptingguy/archive/2013/06/22/weekend-scripter-getting-started-with-windows-azure-and-powershell.aspx
3. http://michaelwasham.com/windows-azure-powershell-reference-guide/configuring-disks-endpoints-vms-powershell/
4. http://blog.powershell.no/2010/03/04/enable-and-configure-windows-powershell-remoting-using-group-policy/
5. http://azure.microsoft.com/blog/2014/05/13/deploying-antimalware-solutions-on-azure-virtual-machines/
6. http://blogs.msdn.com/b/powershell/archive/2014/08/07/introducing-the-azure-powershell-dsc-desired-state-configuration-extension.aspx
7. http://trevorsullivan.net/2014/08/21/use-powershell-dsc-to-install-dsc-resources/
8. http://blogs.msdn.com/b/powershell/archive/2014/07/21/creating-a-secure-environment-using-powershell-desired-state-configuration.aspx
9. http://blogs.technet.com/b/ashleymcglone/archive/2015/03/20/deploy-active-directory-with-powershell-dsc-a-k-a-dsc-promo.aspx
10.http://blogs.technet.com/b/heyscriptingguy/archive/2013/03/26/decrypt-powershell-secure-string-password.aspx
11.http://blogs.msdn.com/b/powershell/archive/2014/09/10/secure-credentials-in-the-azure-powershell-desired-state-configuration-dsc-extension.aspx
12.http://blogs.technet.com/b/keithmayer/archive/2014/10/24/end-to-end-iaas-workload-provisioning-in-the-cloud-with-azure-automation-and-powershell-dsc-part-1.aspx
13.http://blogs.technet.com/b/keithmayer/archive/2014/07/24/step-by-step-auto-provision-a-new-active-directory-domain-in-the-azure-cloud-using-the-vm-agent-custom-script-extension.aspx
14.https://blogs.msdn.microsoft.com/cloud_solution_architect/2015/05/05/creating-azure-vms-with-arm-powershell-cmdlets/
15.https://msdn.microsoft.com/en-us/powershell/gallery/psget/script/psget_new-scriptfileinfo
16.https://msdn.microsoft.com/en-us/powershell/gallery/psget/script/psget_publish-script
17.https://www.powershellgallery.com/packages/WriteToLogs
18.https://chocolatey.org
19.https://desktop.github.com
20.https://www.ostechnix.com/how-to-install-windows-powershell-in-linux/
21.https://blogs.technet.microsoft.com/heyscriptingguy/2016/10/05/part-2-install-net-core-and-powershell-on-linux-using-dsc/
22.https://blogs.technet.microsoft.com/heyscriptingguy/2016/09/28/part-1-install-bash-on-windows-10-omi-cim-server-and-dsc-for-linux/
23.https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-manage-vm
****************************************************************************************************************************************************************************************************************
#>

<# 
TASK ITEMS
#>

# Resets profiles in case you have multiple Azure Subscriptions and connects to your Azure Account [Uncomment if you haven't already authenticated to your Azure subscription]
# Clear-AzureProfile -Force
# Login-AzureRmAccount

# Construct custom path for log files 
$LogDir = "New-AzureRmAvSet"
$LogPath = $env:HOMEPATH + "\" + $LogDir
If (!(Test-Path $LogPath))
{
 New-Item -Path $LogPath -ItemType Directory
} #End If

# Create log file with a "u" formatted time-date stamp
$StartTime = (((get-date -format u).Substring(0,16)).Replace(" ", "-")).Replace(":","")
$24hrTime = $StartTime.Substring(11,4)

$LogFile = "New-AzureRmAvSet-LOG" + "-" + $StartTime + ".log"
$TranscriptFile = "New-AzureRmAvSet-TRANSCRIPT" + "-" + $StartTime + ".log"
$Log = Join-Path -Path $LogPath -ChildPath $LogFile
$Transcript = Join-Path $LogPath -ChildPath $TranscriptFile
# Create Log file
New-Item -Path $Log -ItemType File -Verbose
# Create Transcript file
New-Item -Path $Transcript -ItemType File -Verbose

Start-Transcript -Path $Transcript -IncludeInvocationHeader -Append -Verbose

# To avoid multiple versions installed on the same system, first uninstall any previously installed and loaded versions if they exist
Uninstall-Module -Name WriteToLogs -AllVersions -ErrorAction SilentlyContinue -Verbose

# If the WriteToLogs module isn't already loaded, install and import it for use later in the script for logging operations
If (!(Get-Module -Name WriteToLogs))
{
 # https://www.powershellgallery.com/packages/WriteToLogs
 Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
 Install-PackageProvider -Name Nuget -ForceBootstrap -Force 
 Install-Module -Name WriteToLogs -Repository PSGallery -Force -Verbose
 Import-Module -Name WriteToLogs -Verbose
} #end If

#region INITIALIZE VALUES	

$BeginTimer = Get-Date -Verbose

Do
{
 # Subscription name
 (Get-AzureRmSubscription).SubscriptionName
 [string] $Subscription = Read-Host "Please enter your subscription name, i.e. [MIAC | MSFT] "
 $Subscription = $Subscription.ToUpper()
} #end Do
Until (($Subscription) -ne $null)

# Selects subscription based on subscription name provided in response to the prompt above
Select-AzureRmSubscription -SubscriptionId (Get-AzureRmSubscription -SubscriptionName $Subscription).SubscriptionId

Do
{
 # Resource Group name
 [string] $rg = Read-Host "Please enter a new resource group name [rg##] "
} #end Do
Until (($rg) -match '^rg\d{2}$')


Do 
{
 # This is a uniquely assigned number for each course attendee so that the domain and Azure resources will also have unique names within the same course
 # For class-wide demo scripts, this number will be the last 4 digits of the request number
 [string]$AttendeeNum = Read-Host "Please enter the 4 digit number. You can for example, use the 24-hr clock time, i.e. [1417]"
}
Until ($AttendeeNum -match '^[0-9][0-9][0-9][0-9]$')

Do
{
 # The site code refers to a 3 letter airport code of the nearest major airport to the training site
 [string]$SiteCode = Read-Host "Please enter your 3 character site code, i.e. [ATL] "
 $SiteCode = $SiteCode.ToUpper()
} #end Do
Until ($SiteCode -match '^[A-Z]{3}$')

# todo: Remove instance count for Windows Machine
<#
Do
{
 # The site code refers to a 3 letter airport code of the nearest major airport to the training site
 [int]$InstanceCount = Read-Host "Please enter the total number of Windows instances required [1-5] "
} #end Do
Until ($InstanceCount -le 5 -AND $InstanceCount -ne $null)
#>

# Create and populate prompts object with property-value pairs
# PROMPTS (PromptsObj)
$PromptsObj = [PSCustomObject]@{
 pVerifySummary = "Is this information correct? [YES/NO]"
 pAskToOpenLogs = "Would you like to open the deployment log now ? [YES/NO]"
} #end $PromptsObj

# Create and populate responses object with property-value pairs
# RESPONSES (ResponsesObj): Initialize all response variables with null value
$ResponsesObj = [PSCustomObject]@{
 pProceed = $null
 pOpenLogsNow = $null
} #end $ResponsesObj

Do
{
 # The location refers to a geographic region of an Azure data center
 $Regions = Get-AzureRmLocation | Select-Object -ExpandProperty Location
 Write-ToConsoleAndLog -Output "The list of available regions are :" -Log $Log
 Write-ToConsoleAndLog -Output "" -Log $Log
 Write-ToConsoleAndLog -Output $Regions -Log $Log
 Write-ToConsoleAndLog -Output "" -Log $Log
 $EnterRegionMessage = "Please enter the geographic location (Azure Data Center Region) to which you would like to deploy these resources, i.e. [eastus2 | westus2]"
 Write-ToLogOnly -Output $EnterRegionMessage -Log $Log
 [string]$Region = Read-Host $EnterRegionMessage
 $Region = $Region.ToUpper()
 Write-ToConsoleAndLog -Output "`$Region selected: $Region " -Log $Log
 Write-ToConsoleAndLog -Output "" -Log $Log
} #end Do
Until ($Region -in $Regions)

New-AzureRmResourceGroup -Name $rg -Location $Region -Verbose

# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage

# Image version
$version = "latest"

$imageObj = [PSCustomObject]@{
publisherWindows = "MicrosoftWindowsServer"
publisherUbuntu = "Canonical"
publisherCentOS = "OpenLogic"
publisherOpenSUSE = "SUSE"
offerWindows = "WindowsServer"
offerUbuntu = "UbuntuServer"
offerCentOS = "CentOS"
offerOpenSUSE = "openSUSE-Leap"
skuWindows = "2016-Datacenter"
skuUbuntu = "16.04-LTS"
skuCentOS = "7.3"
skuOpenSUSE = "42.2"
urnUbuntu = "Canonical:UbuntuServer:16.04-LTS:latest"
urnCentOS = "OpenLogic:CentOS:7.3:latest"
urnOpenSUSE = "SUSE:openSUSE-Leap:42.2:latest"
versionWindows = $version
versionUbuntu = $version
versionCentOS = $version
versionOpenSUSE = $version
} #end ht

<#
imageNameWindows = Get-AzureRmVMImage –Location $Region –Offer $imageobj.offerWindows –PublisherName $imageObj.publisherWindows –SKUs $imageObj.skuWindows
imageNameUbuntu = Get-AzureRmVMImage –Location $Region –Offer $imageObj.offerUbuntu –PublisherName $imageObj.publisherUbuntu –SKUs $imageObj.skuUbuntu
imageNameCentOS = Get-AzureRmVMImage –Location $Region –Offer $imageObj.offerCentOS –PublisherName $imageObj.publisherCentOS –SKUs $imageObj.skuCentOS
imageNameOpenSUSE = Get-AzureRmVMImage –Location $Region –Offer $imageObj.offerOpenSUSE –PublisherName $imageObj.publisherOpenSUSE –SKUs $imageObj.skuOpenSUSE
#>

# User name is specified directly in script
$windowsAdminName = "ent.g001.s001"
# Make the Linux admin username the same as Windows
$linuxAdminName = "linuxuser"
# Virtual Machine size
$wsVmSize = "Standard_D1_v2"
$lsVmSize = $wsVmSize
# Availability sets
$AvSetLsName = "AvSetLinux"
$AvSetWsName = "AvSetWindows"
$SiteNamePrefix = "net"
$gtld = ".lab"

# Prompt for Windows credentials
$windowsCred = Get-Credential -UserName $windowsAdminName -Message "Enter password for user: $windowsAdminName"
# $wsPw = $windowsCred.GetNetworkCredential().password

# Define Linux credential object
Write-WithTime -Output "Creating Linux credential object..." -Log $Log
$lsSecurePassword = ConvertTo-SecureString ' ' -AsPlainText -Force
$linuxCred = New-Object System.Management.Automation.PSCredential ($linuxAdminName, $lsSecurePassword)

# An SSH public key must have first been created
Write-WithTime -Output "A public ssh rsa key is required for SSH authentication to the Linux VM. Please create an ssh key pair now if required..." -Log $Log
Do
{
 [string]$sshPublicKeyPath = Read-Host "Please enter the full path to the SSH Putty public key that will be used to authenticate to the Linux VM [ c:\<path>\<PublicKeyFile> ] "
 $keyContent = Get-Content -Path $sshPublicKeyPath
 If (Test-Path -Path $sshPublicKeyPath)
 {
  If ($keyContent -ne $null)
  {
   $sshPublicKey = $keyContent
  } #end if
  else
  {
   Write-WithTime -Output "The SSH key file is empty..." -Log $Log
  } #end else
 } #end if
 else
 {
  Write-WithTime -Output "The SSH key path was not found..." -Log $Log
 } #end else
} #end do
Until ((Test-Path -Path $sshPublicKeyPath) -AND ($keyContent))

# Construct the destination authorized key path for the Linux server
$sshAuthorizedKeysPath = "/home/" + $linuxAdminName + "/.ssh/authorized_keys"

$DelimDouble = ("=" * 100 )
$Header = "LINUX LAB DEPLOYMENT EXCERCISE: " + $StartTime

# Create and populate site, subnet and VM properties of the domain with property-value pairs
$ObjDomain = [PSCustomObject]@{
 pFQDN = "R" + $AttendeeNum + $gtld
 pDomainName = "R" + $AttendeeNum
 pSite = $SiteNamePrefix + $AttendeeNum
 # Subnet names matches the VM platforms (WS = Windows Server, LS = Linux Servers)
 pSubNetWS = "WS"
 pSubNetLS = "LS"
 pWs2016 = $SiteCode + "WS0" # Based on the latest image of Windows Server 2016
 pLsUbuntu = $SiteCode + "LS01" # Based on the latest image of Linux UbuntuServer 17.04-LTS
 pLsCentOs = $SiteCode + "LS02" # Based on the latest image of Linux CentOS 7.3
 pLsOpenSUSE = $SiteCode + "LS03" # Based on the latest image of Linux OpenSUSE-Leap 42.2
} #end $ObjDomain

# 3 Windows VMs will be created
$WindowsInstanceCount = 3
$LinuxSystems = @($ObjDomain.pLsUbuntu,$ObjDomain.pLsCentOs,$ObjDomain.pLsOpenSUSE)

# Subnet for domain controllers
$wsSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $ObjDomain.pSubNetWS -AddressPrefix 10.10.10.0/28 -Verbose
# Subnet for member servers (AP = Application servers)
$lsSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $ObjDomain.pSubNetLS -AddressPrefix 10.10.10.16/28 -Verbose

$Vnet = New-AzureRmVirtualNetwork -Name $ObjDomain.pSite -ResourceGroupName $rg -Location $Region -AddressPrefix 10.10.10.0/26 -Subnet $wsSubnet,$lsSubnet -Verbose

# NSG Configuration
# https://www.petri.com/create-azure-network-security-group-using-arm-powershell

# Create the NSG names using 'NSG-' as a prefix
$nsgWsSubnetName = "NSG-$($ObjDomain.pSubNetWS)"
$nsgLsSubnetName = "NSG-$($ObjDomain.pSubNetLS)"

# Create the AllowRdpInbound rule for the WS (Windows) subnet
$nsgRuleAllowRdpIn = New-AzureRmNetworkSecurityRuleConfig -Name "AllowRdpInbound" -Direction Inbound -Priority 100 -Access Allow -SourceAddressPrefix "Internet" -SourcePortRange "*" `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange 3389 -Protocol Tcp -Verbose
# Create the AllowSshInbound rule for the LS (Linux) subnet
$nsgRuleAllowSshIn = New-AzureRmNetworkSecurityRuleConfig -Name "AllowSshInbound" -Direction Inbound -Priority 110 -Access Allow -SourceAddressPrefix "Internet" -SourcePortRange "*" `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange 22 -Protocol Tcp -Verbose

# Apply the rules to the subnets
$nsgWsSubnetObj = New-AzureRmNetworkSecurityGroup -Name $nsgWsSubnetName -ResourceGroupName $rg -Location $Region -SecurityRules $nsgRuleAllowRdpIn -Verbose
$nsgLsSubnetObj = New-AzureRmNetworkSecurityGroup -Name $nsgLsSubnetName -ResourceGroupName $rg -Location $Region -SecurityRules $nsgRuleAllowRdpIn, $nsgRuleAllowSshIn -Verbose

# Associate NSGs with VNET subnets
Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Vnet -Name $ObjDomain.pSubNetWS -AddressPrefix $wsSubnet.AddressPrefix -NetworkSecurityGroup $nsgWsSubnetObj | Set-AzureRmVirtualNetwork -Verbose
Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Vnet -Name $ObjDomain.pSubNetLS -AddressPrefix $lsSubnet.AddressPrefix -NetworkSecurityGroup $nsgLsSubnetObj | Set-AzureRmVirtualNetwork -Verbose

# Specify disk size as 10 GiB
[int]$wsDataDiskSize = 10
[int]$lsDataDiskSize = $wsDataDiskSize

Write-ToConsoleAndLog -Output "Since only 1 instance of a Windows and 1 instance of each Linux virtual machine distros will be provisioned [Ubuntu, CentOS, openSUSE], an avalailability set will NOT be created" -Log $Log

# Populate Summary Display Object
# Add properties and values
# Make all values upper-case
 $SummObj = [PSCustomObject]@{
 SUBSCRIPTION = $Subscription.ToUpper()
 RESOURCEGROUP = $rg
 SITECODE = $SiteCode.ToUpper()
 ATTENDEENUM = $AttendeeNum.ToUpper()
 DOMAINFQDN = $ObjDomain.pFQDN.ToUpper()
 DOMAINNETBIOS = $ObjDomain.pDomainName.ToUpper()
 SITENAME = $ObjDomain.pSite.ToUpper()
 WSSUBNET = $ObjDomain.pSubNetWS.ToUpper()
 LSSUBNET = $ObjDomain.pSubNetLS.ToUpper()
 NSGLS = $nsgLsSubnetName.ToUpper()
 NSGWS = $nsgWsSubnetName.ToUpper()
 WS01 = $ObjDomain.pWs2016.ToUpper() + 1
 WS02 = $ObjDomain.pWs2016.ToUpper() + 2
 WS03 = $ObjDomain.pWs2016.ToUpper() + 3
 LSUB = $ObjDomain.pLsUbuntu.ToUpper()
 LSCO = $ObjDomain.pLsCentOS.ToUpper()
 LSOS = $ObjDomain.pLsOpenSUSE.ToUpper()
 REGION = $Region.ToUpper()
 LOGPATH = $Log
 } #end $SummObj
 
#endregion INITIALIZE VALUES

#region FUNCTIONS	

Function New-RandomString
{
 $CombinedCharArray = @()
 $ComplexityRuleSets = @()
 $PasswordArray = @()
 # PCR here means [P]assword [C]omplexity [R]equirement, so the $PCRSampleCount value represents the number of characters that will be generated for each password complexity requirement (alpha upper, lower, and numeric)
 $PCRSampleCount = 4
 $PCR1AlphaUpper = ([char[]]([char]65..[char]90))
 $PCR3AlphaLower = ([char[]]([char]97..[char]122))
 $PCR4Numeric = ([char[]]([char]48..[char]57))

 # Add all of the PCR... arrays into a single consolidated array
 $CombinedCharArray = $PCR1AlphaUpper + $PCR3AlphaLower + $PCR4Numeric
 # This is the set of complexity rules, so it's an array of arrays
 $ComplexityRuleSets = ($PCR1AlphaUpper, $PCR3AlphaLower, $PCR4Numeric)

 # Sample 4 characters from each of the 3 complexity rule sets to generate a complete 12 character random string
 ForEach ($ComplexityRuleSet in $ComplexityRuleSets)
 {
  Get-Random -InputObject $ComplexityRuleSet -Count $PCRSampleCount | ForEach-Object { $PasswordArray += $_ }
 } #end ForEach

 [string]$RandomStringWithSpaces = $PasswordArray
 [string]$Script:RandomString = $RandomStringWithSpaces.Replace(" ","") 
} #end Function

# Create Windows VM 
Function Add-WindowsVm2016
{
 # Create the public ip (PIP) and NIC names
 Write-WithTime -Output "Creating public IP name..." -Log $Log
 # Append index to VM name
 $ObjDomain.pWs2016 = $ObjDomain.pWs2016 + $w 
 $wsPipName = "$($ObjDomain.pWs2016)" + "-pip"
 $wsPipName = $wsPipName.ToLower()
 Write-WithTime -Output "Creating NIC name..." -Log $Log
 $wsNicName = "$($ObjDomain.pWs2016)" + "-nic" 
 $wsNicName = $wsNicName.ToLower()

 # Construct the drive names for the SYSTEM and DATA drives
 Write-WithTime -Output "Constructing SYSTEM drive name page blob..." -Log $Log
 $wsDriveNameSystem = "$($ObjDomain.pWs2016)-SYST"
 $wsDriveNameData = "$($ObjDomain.pWs2016)-DATA"

 # $x represents the value of the last octect of the private IP address. We skip the first 3 addresses in the network address because they are always reserved in Azure
 $x = 3 + $w

 # NOTE: Domain labels have to be lower case
 Write-WithTime -Output "Creating DNS domain label..." -Log $Log
 # Add a random infix (4 numeric digits) inside the Dnslabel name to avoid conflicts with existing deployments generated from this script. The -pip suffix indicates this is a public IP
 New-RandomString
 $DnsLabelInfix = $RandomString.SubString(8,4)
 $DomainLabel = $objDomain.pWs2016.ToLower() + $DnsLabelInfix + "-pip"
 $DomainLabel = $DomainLabel.ToLower()

 Write-WithTime -Output "Creating public IP..." -Log $Log
 # Now we can string all the pre-requisites together to construct both the VIP and NIC
 $wsPip = New-AzureRmPublicIpAddress -ResourceGroupName $rg -Name $wsPipName -Location $Region -AllocationMethod Static -DomainNameLabel $DomainLabel -Verbose
 Write-WithTime -Output "Creating NIC..." -Log $Log
 $wsNic = New-AzureRmNetworkInterface -ResourceGroupName $rg -Name $wsNicName -Location $Region -PrivateIpAddress "10.10.10.$x" -SubnetId $Vnet.Subnets[0].Id -PublicIpAddressId $wsPip.Id -Verbose
 
 # If the VM doesn't aready exist, configure and create it
 If (!((Get-AzureRmVM -ResourceGroupName $rg).Name -match $ObjDomain.pWs2016))
 {
  Write-WithTime -Output "VM $($ObjDomain.pWs2016) doesn't already exist. Configuring..." -Log $Log
  # Setup new vm configuration
   $wsVmConfig = New-AzureRmVMConfig –VMName $ObjDomain.pWs2016 -VMSize $wsVmSize | 
   Set-AzureRmVMOperatingSystem -Windows -ComputerName $ObjDomain.pWs2016 -Credential $windowsCred -ProvisionVMAgent -EnableAutoUpdate | 
   Set-AzureRmVMSourceImage -PublisherName $imageObj.publisherWindows -Offer $imageObj.offerWindows -Skus $imageObj.skuWindows -Version $imageObj.versionWindows | 
   Set-AzureRmVMOSDisk -Name $wsDriveNameSystem -StorageAccountType StandardLRS -DiskSizeInGB 128 -CreateOption FromImage -Caching ReadWrite -Verbose

  # Add NIC
  Add-AzureRmVMNetworkInterface -VM $wsVmConfig -Id $wsNic.Id -Verbose

  # Create new VM
  Write-WithTime -Output "Creating VM from configuration..." -Log $Log
  New-AzureRmVM -ResourceGroupName $rg -Location $Region -VM $wsVmConfig -Verbose

  # Get current VM configuration
  $vmWs = Get-AzureRmVM -ResourceGroupName $rg -Name $ObjDomain.pWs2016

  # Set NIC
  Write-WithTime -Output "Adding NIC..." -Log $Log
  Set-AzureRmNetworkInterface -NetworkInterface $wsNic -Verbose

  # Add data disks
  Write-WithTime -Output "Adding data disk for NTDS, SYSV and LOGS directories..." -Log $Log
  Add-AzureRmVMDataDisk -VM $vmWs -Name $wsDriveNameData -StorageAccountType StandardLRS -Lun 0 -DiskSizeInGB 10 -CreateOption Empty -Caching None -Verbose
 
  # Update disk configuration
  Write-WithTime -Output "Applying new disk configurations..." -Log $Log
  Update-AzureRmVM -ResourceGroupName $rg -VM $vmWs -Verbose
 } #end If
 else
 {
  Write-ToConsoleAndLog -Output "$($ObjDomain.pWs2016) already exists..." -Log $Log
 } #end else
} #End function

# Create Linux VM 
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-powershell
Function Add-LinuxVm
{
 # Create the public ip (PIP) and NIC names
 Write-WithTime -Output "Creating public IP name..." -Log $Log
 $lsPipName = $LinuxSystem + "-pip"
 $lsPipName = $lsPipName.ToLower()
 Write-WithTime -Output "Creating NIC name..." -Log $Log
 $lsNicName = $LinuxSystem + "-nic"
 $lsNicName = $lsNicName.ToLower() 

 # Construct the drive names for the SYSTEM and DATA drives
 Write-WithTime -Output "Constructing SYSTEM drive name page blob..." -Log $Log
 $lsDriveNameSystem = "$LinuxSystem-SYST"
 $lsDriveNameData = "$LinuxSystem-DATA"

 # $y represents the value of the last octect of the private IP address. We skip the first 3 addresses in the network address because they are always reserved in Azure
 $y = 19 + $i

 # NOTE: Domain labels have to be lower case
 Write-WithTime -Output "Creating DNS domain label..." -Log $Log
 # Add a random infix (4 numeric digits) inside the Dnslabel name to avoid conflicts with existing deployments generated from this script. The -pip suffix indicates this is a public IP
 New-RandomString
 $DnsLabelInfix = $RandomString.SubString(8,4)
 $DomainLabel = $LinuxSystem + $DnsLabelInfix + "-pip"
 $DomainLabel = $DomainLabel.ToLower()

 Write-WithTime -Output "Creating public IP..." -Log $Log
 # Now we can string all the pre-requisites together to construct both the VIP and NIC
 $lsPip = New-AzureRmPublicIpAddress -ResourceGroupName $rg -Name $lsPipName -Location $Region -AllocationMethod Static -IdleTimeoutInMinutes 4 -DomainNameLabel $DomainLabel -Verbose
 Write-WithTime -Output "Creating NIC..." -Log $Log
 $lsNic = New-AzureRmNetworkInterface -ResourceGroupName $rg -Name $lsNicName -Location $Region -PrivateIpAddress "10.10.10.$y" -SubnetId $Vnet.Subnets[1].Id -PublicIpAddressId $lsPip.Id -Verbose
 
 Switch ($i)
 {
  1 { 
        $publisher = $imageObj.publisherUbuntu 
        $offer = $imageObj.offerUbuntu
        $sku = $imageObj.skuUbuntu
        $version = $imageObj.versionUbuntu
    } #end 1

  2 {
        $publisher = $imageObj.publisherCentOS 
        $offer = $imageObj.offerCentOS
        $sku = $imageObj.skuCentOS
        $version = $imageObj.versionCentOS
    } #end 2 

  3 {
        $publisher = $imageObj.publisherOpenSUSE 
        $offer = $imageObj.offerOpenSUSE
        $sku = $imageObj.skuOpenSUSE
        $version = $imageObj.versionOpenSUSE
    } #end 3
 } #end Switch

 # If the VM doesn't aready exist, configure and create it
 If (!((Get-AzureRmVM -ResourceGroupName $rg).Name -match $LinuxSystem))
 {
  Write-WithTime -Output "VM $LinuxSystem doesn't already exist. Configuring..." -Log $Log
  
  # Setup new vm configuration
   $lsVmConfig = New-AzureRmVMConfig –VMName $LinuxSystem -VMSize $lsVmSize | 
   Set-AzureRmVMOperatingSystem -Linux -ComputerName $LinuxSystem -Credential $linuxCred -DisablePasswordAuthentication | 
   Set-AzureRmVMSourceImage -PublisherName $publisher -Offer $offer -Skus $sku -Version $version | 
   Set-AzureRmVMOSDisk -Name $lsDriveNameSystem -StorageAccountType StandardLRS -DiskSizeInGB 128 -CreateOption FromImage -Caching ReadWrite -Verbose

  # Add NIC
  Add-AzureRmVMNetworkInterface -VM $lsVmConfig -Id $lsNic.Id -Verbose

  # Configure SSH Keys
  # http://technodrone.blogspot.com/2010/04/those-annoying-thing-in-powershell.html
  Add-AzureRmVMSshPublicKey -VM $lsVmConfig -KeyData ($sshPublicKey | Out-String) -Path $sshAuthorizedKeysPath

  # Create new VM
  Write-WithTime -Output "Creating VM from configuration..." -Log $Log
  New-AzureRmVM -ResourceGroupName $rg -Location $Region -VM $lsVmConfig -Verbose
  
  # Get current VM configuration
  $vmLs = Get-AzureRmVM -ResourceGroupName $rg -Name $LinuxSystem

  # Set NIC
  Write-WithTime -Output "Adding NIC..." -Log $Log
  Set-AzureRmNetworkInterface -NetworkInterface $lsNic -Verbose

  # Add data disks
  Write-WithTime -Output "Adding data disk..." -Log $Log
  Add-AzureRmVMDataDisk -VM $vmLs -Name $lsDriveNameData -StorageAccountType StandardLRS -Lun 1 -DiskSizeInGB 10 -CreateOption Empty -Caching None -Verbose
 
  # Update disk configuration
  Write-WithTime -Output "Applying new disk configurations..." -Log $Log
  Update-AzureRmVM -ResourceGroupName $rg -VM $vmLs -Verbose
 } #end If
 else
 {
  Write-ToConsoleAndLog -Output "$LinuxSystem already exists..." -Log $Log
 }

} #End function

#endregion FUNCTIONS

#region MAIN	

# Display header
Write-ToConsoleAndLog -Output $DelimDouble -Log $Log
Write-ToConsoleAndLog -Output $Header -Log $Log
Write-ToConsoleAndLog -Output $DelimDouble -Log $Log

# Display Summary
Write-ToConsoleAndLog -Output $SummObj -Log $Log
Write-ToConsoleAndLog -Output $DelimDouble -Log $Log

# Verify parameter values
Do {
$ResponsesObj.pProceed = read-host $PromptsObj.pVerifySummary
$ResponsesObj.pProceed = $ResponsesObj.pProceed.ToUpper()
}
Until ($ResponsesObj.pProceed -eq "Y" -OR $ResponsesObj.pProceed -eq "YES" -OR $ResponsesObj.pProceed -eq "N" -OR $ResponsesObj.pProceed -eq "NO")

# Record prompt and response in log
Write-ToLogOnly -Output $PromptsObj.pVerifySummary -Log $Log
Write-ToLogOnly -Output $ResponsesObj.pProceed -Log $Log

# Exit if user does not want to continue

if ($ResponsesObj.pProceed -eq "N" -OR $ResponsesObj.pProceed -eq "NO")
{
  Write-ToConsoleAndLog -Output "Deployment terminated by user..." -Log $Log
  PAUSE
  EXIT
 } #end if ne Y
else 
{
 # Proceed with deployment
 Write-ToConsoleAndLog -Output "Deploying environment..." -Log $Log
 Write-WithTime -Output "Building $($ObjDomain.pWs2016)..." -Log $Log
 For ($w = 1; $w++; $w -le $WindowsInstanceCount)
 {
    Add-WindowsVm2016
 } #end ForEach
 # Initialize index for each linux system
 $i = 0
 # Build each linux system in collection
 ForEach ($LinuxSystem in $LinuxSystems)
 {
  $i++
  Add-LinuxVM
 } #end foreach

} #end else

#endregion MAIN

#region FOOTER		

# Calculate elapsed time
Write-WithTime -Output "Calculating script execution time..." -Log $Log
Write-WithTime -Output "Getting current date/time..." -Log $Log
$StopTimer = Get-Date
Write-WithTime -Output "Formating date/time to replace commas(,) with dashes(-)..." -Log $Log
$EndTime = (((Get-Date -format u).Substring(0,16)).Replace(" ", "-")).Replace(":","")
Write-WithTime -Output "Calculating elapsed time..." -Log $Log
$ExecutionTime = New-TimeSpan -Start $BeginTimer -End $StopTimer

$Footer = "SCRIPT COMPLETED AT: "

Write-ToConsoleAndLog -Output $DelimDouble -Log $Log
Write-ToConsoleAndLog -Output "$Footer $EndTime" -Log $Log
Write-ToConsoleAndLog -Output "TOTAL SCRIPT EXECUTION TIME: $ExecutionTime" -Log $Log
Write-ToConsoleAndLog -Output $DelimDouble -Log $Log

# Prompt to open logs
Do 
{
 $ResponsesObj.pOpenLogsNow = read-host $PromptsObj.pAskToOpenLogs
 $ResponsesObj.pOpenLogsNow = $ResponsesObj.pOpenLogsNow.ToUpper()
}
Until ($ResponsesObj.pOpenLogsNow -eq "Y" -OR $ResponsesObj.pOpenLogsNow -eq "YES" -OR $ResponsesObj.pOpenLogsNow -eq "N" -OR $ResponsesObj.pOpenLogsNow -eq "NO")

# Exit if user does not want to continue
if ($ResponsesObj.pOpenLogsNow -eq "Y" -OR $ResponsesObj.pOpenLogsNow -eq "YES") 
{
 Start-Process notepad.exe $Log
 Start-Process notepad.exe $Transcript
} #end if

# End of script
Write-WithTime -Output "END OF SCRIPT!" -Log $Log

# Close transcript file
Stop-Transcript -Verbose

#endregion FOOTER

<#
To gracefully remove deployed resources, execute the following commands
Get-AzureRmVm -ResourceGroupName $rg | Stop-AzureRmVm -Force
Remove-AzureRmResourceGroup -Name $rg -Force
#>

Pause