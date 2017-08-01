#requires -version 5.0
#requires -RunAsAdministrator
<#
DESCRIPTION	:
This script creates the following 6 VMs, however the number of Windows VMs is user specified from 0-3. 
1) 3 x Windows Server 2016
2) 1 x UbuntuServer LTS 16.04
3) 1 x CentOS 7.3
4) 1 x openSUSE-Leap 42.2

.SYNOPSIS
   	Creates up to 6 VMs for an Azure Linux Windows PowerShell Lab consisting of 0-3 Windows VMs, and 3 Linux VMs (Ubuntu, CentOS and openSUSE). 
.DESCRIPTION
	This script will create a set of Azure VMs to demonstrate Windows PowerShell and Azure Automation DSC functionality on Linux VMs. The set of VMs that will be created are listed below in the .OUTPUTS help tag. 
    however the number of Windows VMs is user specified from 0-3, since the deployment of Windows VMs are not essential for a basic demonstration of PowerShell on Linux, but will be required if Windows Push or Pull 
    servers will be used in the lab. This project will be enhaced to eventually include those features also, but initially, the focus will be on configuring the Linux distros to support Azure Automation DSC and
    PowerShell.    
.EXAMPLE
   	New-PowerShellOnLinuxLab
.PARAMETERS
    NA
.OUTPUTS
    1) 3 x Windows Server 2016
    2) 1 x UbuntuServer LTS 16.04
    3) 1 x CentOS 7.3
    4) 1 x openSUSE-Leap 42.2
.NOTES
   	CURRENT STATUS: In development
    REQUIREMENTS: SSH key pair to authenticate to the Linux VMs. When the scrit executes, a prompt will appear asking for the public key path. 
                  WriteToLogs module (https://www.powershellgallery.com/packages/WriteToLogs). This will be downloaded and installed automatically.

   	LIMITATIONS	: Windows VM configurations and integration as Push/Pull servers.
   	AUTHOR(S)  	: Preston K. Parsard
   	EDITOR(S)  	: Preston K. Parsard
   	KEYWORDS   	: Linux, Azure, PowerShell, DSC
   
	REFERENCES : 
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
    24.https://github.com/PowerShell/PowerShell/blob/master/docs/installation/linux.md
    25.https://www.ostechnix.com/how-to-install-windows-powershell-in-linux/
    26.https://blogs.technet.microsoft.com/heyscriptingguy/2016/09/28/part-1-install-bash-on-windows-10-omi-cim-server-and-dsc-for-linux/
    27.https://blogs.technet.microsoft.com/heyscriptingguy/2016/10/05/part-2-install-net-core-and-powershell-on-linux-using-dsc/
    28.https://blogs.msdn.microsoft.com/linuxonazure/2017/02/12/extensions-custom-script-for-linux/
    29.https://azure.microsoft.com/en-us/blog/automate-linux-vm-customization-tasks-using-customscript-extension/

    The MIT License (MIT)
    Copyright (c) 2017 Preston K. Parsard

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
    (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys' fees, that arise or result from the use or distribution of the Sample Code.
    This posting is provided "AS IS" with no warranties, and confers no rights.

.COMPONENT
    Azure IaaS
.ROLE
    Azure IaaS Windows/Linux Administrators/Engineers
.FUNCTIONALITY
    Deploys Azure Linux VMs with PowerShell and DSC functionality.
.LINK
    https://www.powershellgallery.com/packages/WriteToLogs
.LINK
    https://www.powershellgallery.com/packages/nx
.LINK 
    https://www.powershellgallery.com/packages/Posh-SSH
#>


<# 
TASK ITEMS
0001. Remove public IP on all except the fist Windows VM
#>

#region PRE-REQUISITE FUNCTIONS

function Get-PSGalleryModule
{
	[CmdletBinding(PositionalBinding = $false)]
	Param
	(
		# Required modules
		[Parameter(Mandatory = $true,
				   HelpMessage = "Please enter the PowerShellGallery.com modules required for this script",
				   ValueFromPipeline = $true,
				   Position = 0)]
		[ValidateNotNull()]
		[ValidateNotNullOrEmpty()]
		[string[]]$ModulesToInstall
	) #end param
	
	$Repository = "PSGallery"
	Set-PSRepository -Name $Repository -InstallationPolicy Trusted
	Install-PackageProvider -Name Nuget -ForceBootstrap -Force	
	foreach ($Module in $ModulesToInstall)
	{
		# To avoid multiple versions of a module is installed on the same system, first uninstall any previously installed and loaded versions if they exist
		Uninstall-Module -Name $Module -AllVersions -ErrorAction SilentlyContinue -Verbose
		
		# If the WriteToLogs module isn't already loaded, install and import it for use later in the script for logging operations
		If (!(Get-Module -Name $Module))
		{
			# https://www.powershellgallery.com/packages/WriteToLogs
			Install-Module -Name $Module -Repository $Repository -Force -Verbose
			Import-Module -Name $Module -Verbose
		} #end If
	} #end foreach
} #end function

function New-AzureRmAuthentication
{
    # Resets profiles in case you have multiple Azure Subscriptions and connects to your Azure Account [Uncomment if you haven't already authenticated to your Azure subscription]
	Clear-AzureProfile -Force
	Add-AzureRmAccount
} #end function

# Modules to add
# https://www.powershellgallery.com/packages/WriteToLogs
# https://www.powershellgallery.com/packages/nx
# https://www.powershellgallery.com/packages/Posh-SSH
# To avoid multiple versions installed on the same system, first uninstall any previously installed and loaded module versions if they exist


# Get any PowerShellGallery.com modules required for this script.
Get-PSGalleryModule -ModulesToInstall "WriteToLogs", "Posh-SSH", "nx"

#region SCRIPT LOG SETUP
# Set script custom log and transcript to record details of script activity.
[string]$ScriptName = $MyInvocation.MyCommand
$ScriptFileComponents = $ScriptName.Split(".")
$LogDirectory = $ScriptFileComponents[0]

$LogPath = $env:HOMEPATH + "\" + $LogDirectory
If (!(Test-Path -Path $LogPath))
{
	New-Item -Path $LogPath -ItemType Directory
} #End If

# Create log file with a "u" formatted time-date stamp
$StartTime = (((get-date -format u).Substring(0, 16)).Replace(" ", "-")).Replace(":", "")

$LogFile = "$LogDirectory-LOG" + "-" + $StartTime + ".log"
$TranscriptFile = "$LogDirectory-TRANSCRIPT" + "-" + $StartTime + ".log"
$Log = Join-Path -Path $LogPath -ChildPath $LogFile
$Transcript = Join-Path  -Path $LogPath -ChildPath $TranscriptFile
# Create Log file
New-Item -Path $Log -ItemType File -Verbose
# Create Transcript file
New-Item -Path $Transcript -ItemType File -Verbose
#endregion SCRIPT LOG SETUP

#region INITIALIZE VALUES	

# Authenticate to Azure.
New-AzureRmAuthentication 

$BeginTimer = Get-Date -Verbose

$cspCode = "AZR"

$RegionCode = @{
	EAAS1 = "eastasia"
	SEAS1 = "southeastasia"
	CEUS1 = "centralus"
	EAUS1 = "eastus"
	EAUS2 = "eastus2"
	WEUS1 = "westus"
	NCUS1 = "northcentralus"
	SCUS1 = "southcentralus"
	NREU1 = "northeurope"
	WEEU1 = "westeurope"
	WEJP1 = "japanwest"
	EAJP1 = "japaneast"
	STBR1 = "brazilsouth"
	EAAU1 = "australiaeast"
	SEAU1 = "australiasoutheast"
	STIN1 = "southindia"
	CEIN1 = "centralindia"
	WEIN1 = "westindia"
	CECA1 = "canadacentral"
	EACA1 = "canadaeast"
	STUK1 = "uksouth"
	WEUK1 = "ukwest"
	WCUS1 = "westcentralus"
	WEUS2 = "westus2"
} #end HashTable

$winFunctionCode = "WNDS"
$lnxFuncitonCode = "LNUX"

$seriesPrefix = "0"

Do
{
	# Subscription name
	(Get-AzureRmSubscription).SubscriptionName
	[string]$Subscription = Read-Host "Please enter your subscription name, i.e. [MIAC | MSFT] "
	$Subscription = $Subscription.ToUpper()
} #end Do
Until (($Subscription) -ne $null)

# Selects subscription based on subscription name provided in response to the prompt above
Select-AzureRmSubscription -SubscriptionName $Subscription
Do
{
 # Resource Group name
 [string]$rg = Read-Host "Please enter a new resource group name [rg##] "
} #end Do
Until (($rg) -match '^rg\d{2}$')

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
 $EnterRegionMessage = "Please enter the geographic location (Azure Data Center Region) for resources, i.e. [eastus2 | westus2]"
 Write-ToLogOnly -Output $EnterRegionMessage -Log $Log
 [string]$Region = Read-Host $EnterRegionMessage
 $Region = $Region.ToUpper()
 Write-ToConsoleAndLog -Output "`$Region selected: $Region " -Log $Log
 Write-ToConsoleAndLog -Output "" -Log $Log
} #end Do
Until ($Region -in $Regions)

New-AzureRmResourceGroup -Name $rg -Location $Region -Verbose

$azRegionCode = $RegionCode.Keys | Where-Object { $RegionCode[$_] -eq "$Region" }

$WinVmNamePrefix = $cspCode + $azRegionCode + $winFunctionCode + $seriesPrefix
$LnxVmNamePrefix = $cspCode + $azRegionCode + $lnxFuncitonCode + $seriesPrefix

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

# User name is specified directly in script
$windowsAdminName = "ent.g001.s001"
# Make the Linux admin username the same as Windows
$linuxAdminName = "linuxuser"
# Virtual Machine size
$wsVmSize = "Standard_D1_v2"
$lsVmSize = $wsVmSize
# Availability sets
$AvSetLsName = "AvSetLNUX"
$AvSetWsName = "AvSetWNDS"
$winAvSet = New-AzureRmAvailabilitySet -ResourceGroupName $rg -Name $AvSetWsName -Location $Region -PlatformUpdateDomainCount 5 -PlatformFaultDomainCount 2 $Region -Managed -Verbose
$lnxAvSet = New-AzureRmAvailabilitySet -ResourceGroupName $rg -Name $AvSetLsName -Location $Region -PlatformUpdateDomainCount 5 -PlatformFaultDomainCount 2 $Region -Managed -Verbose
$SiteNamePrefix = "net"
$gtld = ".lab"

# Prompt for Windows credentials
$windowsCred = Get-Credential -UserName $windowsAdminName -Message "Enter password for user: $windowsAdminName"
# $wsPw = $windowsCred.GetNetworkCredential().password

# Define Linux credential object using SSH public key
Write-WithTime -Output "Creating the Linux credential object..." -Log $Log
$lsSecurePassword = ConvertTo-SecureString ' ' -AsPlainText -Force
$linuxCred = New-Object System.Management.Automation.PSCredential ($linuxAdminName, $lsSecurePassword)

# An SSH public key must have first been created
Write-WithTime -Output "A public ssh rsa key is required for SSH authentication to the Linux VM. Please create an ssh key pair now if required..." -Log $Log
Do
{
 [string]$sshPublicKeyPath = Read-Host "Please enter the full path to the SSH Putty public key that will be used to authenticate to the Linux VM [ c:\<path>\<PublicKeyFile> ] "
 $publickeyContent = Get-Content -Path $sshPublicKeyPath
 If (Test-Path -Path $sshPublicKeyPath)
 {
  If ($publicKeyContent -ne $null)
  {
   $sshPublicKey = $publickeyContent
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
Until ((Test-Path -Path $sshPublicKeyPath) -AND ($publicKeyContent))

# Construct the destination authorized key path for the Linux server
$sshAuthorizedKeysPath = "/home/" + $linuxAdminName + "/.ssh/authorized_keys"

$DelimDouble = ("=" * 100 )
$Header = "LINUX LAB DEPLOYMENT EXCERCISE: " + $StartTime


# Create and populate site, subnet and VM properties of the domain with property-value pairs
$ObjDomain = [PSCustomObject]@{
 pFQDN = "R" + $time24hr + $gtld
 pDomainName = "R" + $time24hr
 pSite = $SiteNamePrefix + $time24hr
 # Subnet names matches the VM platforms (WS = Windows Server, LS = Linux Servers)
 pSubNetWS = "WS"
 pSubNetLS = "LS"
 pWs2016prefix = $WinVmNamePrefix # Based on the latest image of Windows Server 2016
 pLsUbuntu = $LnxVmNamePrefix + 1 # Based on the latest image of Linux UbuntuServer 17.04-LTS
 pLsCentOs = $LnxVmNamePrefix + 2 # Based on the latest image of Linux CentOS 7.3
 pLsOpenSUSE = $LnxVmNamePrefix + 3 # Based on the latest image of Linux OpenSUSE-Leap 42.2
} #end $ObjDomain

# Specify the number of Windows VMs to build (max is 3 based on subnet address space)
$WindowsInstanceCount = 0

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
$nsgRuleAllowSshIn = New-AzureRmNetworkSecurityRuleConfig -Name "AllowSshInbound" -Direction Inbound -Priority 100 -Access Allow -SourceAddressPrefix "Internet" -SourcePortRange "*" `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange 22 -Protocol Tcp -Verbose
# Create the AllowWsManInound rule for the LS (Linux) subnet
$nsgRuleAllowWsManIn = New-AzureRmNetworkSecurityRuleConfig -Name "AllowWsManInbound" -Direction Inbound -Priority 110 -Access Allow -SourceAddressPrefix "Internet" -SourcePortRange "8" `
-DestinationAddressPrefix "VirtualNetwork" -DestinationPortRange 5986 -Protocol Tcp -Verbose

# Apply the rules to the subnets
$nsgWsSubnetObj = New-AzureRmNetworkSecurityGroup -Name $nsgWsSubnetName -ResourceGroupName $rg -Location $Region -SecurityRules $nsgRuleAllowRdpIn -Verbose
$nsgLsSubnetObj = New-AzureRmNetworkSecurityGroup -Name $nsgLsSubnetName -ResourceGroupName $rg -Location $Region -SecurityRules $nsgRuleAllowSshIn, $nsgRuleAllowWsManIn -Verbose

# Associate NSGs with VNET subnets
Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Vnet -Name $ObjDomain.pSubNetWS -AddressPrefix $wsSubnet.AddressPrefix -NetworkSecurityGroup $nsgWsSubnetObj | Set-AzureRmVirtualNetwork -Verbose
Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $Vnet -Name $ObjDomain.pSubNetLS -AddressPrefix $lsSubnet.AddressPrefix -NetworkSecurityGroup $nsgLsSubnetObj | Set-AzureRmVirtualNetwork -Verbose

# Specify disk size as 10 GiB
[int]$wsDataDiskSize = 10
[int]$lsDataDiskSize = $wsDataDiskSize

# Write-ToConsoleAndLog -Output "Since only 1 instance of a Windows and 1 instance of each Linux virtual machine distros will be provisioned [Ubuntu, CentOS, openSUSE], an avalailability set will NOT be created" -Log $Log

# Populate Summary Display Object
# Add properties and values
# Make all values upper-case
 $SummObj = [PSCustomObject]@{
 SUBSCRIPTION = $Subscription.ToUpper()
 RESOURCEGROUP = $rg
 ATTENDEENUM = $time24hr.ToUpper()
 DOMAINFQDN = $ObjDomain.pFQDN.ToUpper()
 DOMAINNETBIOS = $ObjDomain.pDomainName.ToUpper()
 SITENAME = $ObjDomain.pSite.ToUpper()
 WSSUBNET = $ObjDomain.pSubNetWS.ToUpper()
 LSSUBNET = $ObjDomain.pSubNetLS.ToUpper()
 NSGLS = $nsgLsSubnetName.ToUpper()
 NSGWS = $nsgWsSubnetName.ToUpper()
 WS01 = $ObjDomain.pWs2016prefix.ToUpper() + 1
 WS02 = $ObjDomain.pWs2016prefix.ToUpper() + 2
 WS03 = $ObjDomain.pWs2016prefix.ToUpper() + 3
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
 [string]$RandomString = $RandomStringWithSpaces.Replace(" ","") 
 Return [string]$RandomString
} #end Function

# Create Windows VM 
Function Add-WindowsVm2016
{
 # Create the public ip (PIP) and NIC names
 Write-WithTime -Output "Creating public IP name..." -Log $Log
 # Append index to VM name
 $wsPipName = $Ws2016 + "-pip"
 $wsPipName = $wsPipName.ToLower()
 Write-WithTime -Output "Creating NIC name..." -Log $Log
 $wsNicName = $Ws2016 + "-nic" 
 $wsNicName = $wsNicName.ToLower()

 # Construct the drive names for the SYSTEM and DATA drives
 Write-WithTime -Output "Constructing SYSTEM drive name page blob..." -Log $Log
 $wsDriveNameSystem = "$Ws2016-SYST"
 $wsDriveNameData = "$Ws2016-DATA"

 # $x represents the value of the last octect of the private IP address. We skip the first 3 addresses in the network address because they are always reserved in Azure
 $x = 3 + $w

 # NOTE: Domain labels have to be lower case
 Write-WithTime -Output "Creating DNS domain label..." -Log $Log
 # Add a random infix (4 numeric digits) inside the Dnslabel name to avoid conflicts with existing deployments generated from this script. The -pip suffix indicates this is a public IP
 New-RandomString
 $DnsLabelInfix = $RandomString.SubString(8,4)
 $DomainLabel = $Ws2016 + $DnsLabelInfix + "-pip"
 $DomainLabel = $DomainLabel.ToLower()
 Write-WithTime -Output "Creating public IP..." -Log $Log
 # Now we can string all the pre-requisites together to construct both the VIP and NIC
 $wsPip = New-AzureRmPublicIpAddress -ResourceGroupName $rg -Name $wsPipName -Location $Region -AllocationMethod Static -DomainNameLabel $DomainLabel -Verbose

 Write-WithTime -Output "Creating NIC..." -Log $Log
 $wsNic = New-AzureRmNetworkInterface -ResourceGroupName $rg -Name $wsNicName -Location $Region -PrivateIpAddress "10.10.10.$x" -SubnetId $Vnet.Subnets[0].Id -PublicIpAddressId $wsPip.Id -Verbose
 
 # If the VM doesn't aready exist, configure and create it
 If (!((Get-AzureRmVM -ResourceGroupName $rg).Name -match $Ws2016))
 {
		Write-WithTime -Output "VM $Ws2016 doesn't already exist. Configuring..." -Log $Log
  # Setup new vm configuration
   $wsVmConfig = New-AzureRmVMConfig –VMName $Ws2016 -VMSize $wsVmSize -AvailabilitySetId $winAvSet.Id |
	Set-AzureRmVMOperatingSystem -Windows -ComputerName $Ws2016 -Credential $windowsCred -ProvisionVMAgent -EnableAutoUpdate | 
   	Set-AzureRmVMSourceImage -PublisherName $imageObj.publisherWindows -Offer $imageObj.offerWindows -Skus $imageObj.skuWindows -Version $imageObj.versionWindows | 
   	Set-AzureRmVMOSDisk -Name $wsDriveNameSystem -StorageAccountType StandardLRS -DiskSizeInGB 128 -CreateOption FromImage -Caching ReadWrite -Verbose

  # Add NIC
  Add-AzureRmVMNetworkInterface -VM $wsVmConfig -Id $wsNic.Id -Verbose

  # Create new VM
  Write-WithTime -Output "Creating VM from configuration..." -Log $Log
  New-AzureRmVM -ResourceGroupName $rg -Location $Region -VM $wsVmConfig -Verbose

  # Get current VM configuration
  $vmWs = Get-AzureRmVM -ResourceGroupName $rg -Name $Ws2016

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
		Write-ToConsoleAndLog -Output "$Ws2016 already exists..." -Log $Log
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
   $lsVmConfig = New-AzureRmVMConfig –VMName $LinuxSystem -VMSize $lsVmSize -AvailabilitySetId $lnxAvSet.Id  | 
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
  
  Get-AzureRmAutomationDscOnboardingMetaconfig -ResourceGroupName $autoAcctRg -AutomationAccountName $autoAcct -OutputFolder $LogPath -Confirm:$false -Force
  $AutoRegPath = Join-Path -Path $LogPath -ChildPath 'DscMetaConfigs'
  $AutoRegFile = Join-Path -Path $AutoRegPath -ChildPath localhost.meta.mof
  $AutoRegInfo = Get-Content -Path $AutoRegFile
  $AutoRegInfo | Select-String -Pattern "ServerURL", "RegistrationKey" | Sort-Object -Unique -OutVariable autoRegPrivate
  [string]$regKey = $autoRegPrivate[0]
  $regKey = $regKey.Split("`"")[1]
  [string]$regUrl = $autoRegPrivate[1]
  $regUrl = $regUrl.Split("`"")[1]
  Remove-Item -Path $AutoRegFile -Force

  # Apply DSC for Linux extension to all Linux VMs
  # https://github.com/Azure/azure-linux-extensions/blob/master/DSC/README.md
  $dscPrivateConf = "{
    `"RegistrationUrl`": `"$regUrl`",
    `"RegistrationKey`": `"$regKey`"
    }"
  $dscExtensionName = 'DSCForLinux'
  $dscPublisher = 'Microsoft.OSTCExtensions'
  $dscVersion = '2.4'
  $dscPublicConf = "{
    `"ExtensionAction`": `"Register`",
    `"NodeConfigurationName`":  `"$linuxNodeConfigName`",
    `"RefreshFrequencyMins`": 30,
    `"ConfigurationMode`": `"ApplyAndMonitor`"
    }"
    # `"FileUri`": [`"$dscMetaMofBlobUri[$i-1]`"]
    # `"ConfigurationModeFrequencyMins`": 15,
  Set-AzureRmVMExtension -ResourceGroupName $rg `
  -VMName $LinuxSystem `
  -Location $Region `
  -Name $dscExtensionName `
  -Publisher $dscPublisher `
  -ExtensionType $dscExtensionName `
  -TypeHandlerVersion $dscVersion `
  -SettingString $dscPublicConf `
  -ProtectedSettingString $dscPrivateConf

  # Apply custom script to all Linux VMs
  $cseExtensionName = 'CustomScriptForLinux'
  $csePublisher = 'Microsoft.OSTCExtensions'
  $cseVersion = '1.5'
  $csePublicConf = "{
    `"fileUris`": [`"$scriptBlobUri`"],
    `"commandToExecute`": `"sh $lnxCustomScript`"
    }"
  $csePrivateConf = "{
    `"storageAccountName`": `"$saName`",
    `"storageAccountKey`": `"$storageKeyPri`"
    }"

  Set-AzureRmVMExtension -ResourceGroupName $rg -VMName $LinuxSystem -Location $Region `
  -Name $cseExtensionName -Publisher $csePublisher `
  -ExtensionType $cseExtensionName -TypeHandlerVersion $cseVersion `
  -SettingString $csePublicConf -ProtectedSettingString $csePrivateConf




 } #end If
 else
 {
  Write-ToConsoleAndLog -Output "$LinuxSystem already exists..." -Log $Log
 } #end else
 
 # Add tag for OS version details
 Switch ($i) 
 {
  1 { Set-AzureRmResource -Tag @{ OsVersion="$($imageObj.urnUbuntu)" } -ResourceName $LinuxSystem -ResourceGroupName $rg -ResourceType Microsoft.Compute/virtualMachines -Confirm:$false -Force }
  2 { Set-AzureRmResource -Tag @{ OsVersion="$($imageObj.urnCentOS)" } -ResourceName $LinuxSystem -ResourceGroupName $rg -ResourceType Microsoft.Compute/virtualMachines -Confirm:$false -Force  }
  3 { Set-AzureRmResource -Tag @{ OsVersion="$($imageObj.urnOpenSUSE)" } -ResourceName $LinuxSystem -ResourceGroupName $rg -ResourceType Microsoft.Compute/virtualMachines -Confirm:$false -Force }
 } #end switch
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

 # NOTE: This storage account will only be used for diagnostic logging and to host any custom scripts or DSC configuration, data files, and modules if required.
 # Storage accounts will not be used for hosting the OS or data disk vhd drives for the VMs. This is because managed disks will be used instead for all VMs.

 Write-WithTime -Output "Create storage account for diagnostics logs and staging artifacts." -Log $Log

 <#
 Create a new random string, then extract the 4 lower-case characters and the 4 digits generated to use as the last characters for the storage account name suffix.
 If the storage account name has already been taken, i.e. not available, continue to generate a new name that can be used.
 #>

 Do 
 {
  $randomString = New-RandomString
  $saName  = $randomString.Substring(4,8)
 } #end while
 While (!((Get-AzureRmStorageAccountNameAvailability -Name $saName).NameAvailable)) 
 New-AzureRmStorageAccount -ResourceGroupName $rg -Name $saName -Location $Region -Type Standard_LRS -Kind Storage -Verbose
 
 $saResource = Get-AzureRmStorageAccount -ResourceGroupName $rg -Name $saName -Verbose
 $storageKeyPri = (Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $saName).Value[0]

 # linemark: Prompt for input?
 # Specify custom script directory, file and full local source path
 $LogPath = $env:HOMEPATH + "\" + $LogDirectory
If (!(Test-Path -Path $LogPath))
{
	New-Item -Path $LogPath -ItemType Directory
} #end If

 $ScriptDir = Join-Path -Path $LogPath -ChildPath "Scripts"

 If (!(Test-Path -Path $ScriptDir))
 {
    New-Item -Path $ScriptDir -ItemType Directory
 } #end if

 $ModulesDir = Join-Path -Path $LogPath -ChildPath "Modules"

 If (!(Test-Path -Path $ModulesDir))
 {
    New-Item -Path $ModulesDir -ItemType Directory
 } #end if

 $lnxCustomScript = "Install-OmiCimServerOnLinuxAndConfigure.sh"
 $lnxDscScript = "AddLinuxFileConfig.ps1"
 $lnxCustomScriptPath = Join-Path $scriptDir -ChildPath $lnxCustomScript
 $dscScriptSourcePath = Join-Path $scriptDir -ChildPath $lnxDscScript
 $saContainerStaging = "staging"
 $saContainerDSC = "powershell-dsc"
 $autoAcct = "auto00"
 $autoAcctRg = "rg00"
 $linuxDscConfigName = $lnxDscScript.Split(".")[0]
 $modulesSourceDir = "C:\Program Files\WindowsPowerShell\Modules"
 $requiredModuleName = "nx"
 $reqModulesSourceDir = Join-Path -Path $modulesSourceDir -ChildPath $requiredModuleName
 $requiredModulePath = Join-Path -Path $modulesDir -ChildPath $requiredModuleName

 $dscMetaConfigsDir = Join-Path -Path $scriptDir -ChildPath DscMetaConfigs
 $dscMetaMofFiles = Get-ChildItem -Path $dscMetaConfigsDir
 If (($dscMetaMofFiles).Count -gt 0) 
 {
     $dscMetaMofFiles | Remove-Item
 } # end if

 $LinuxSystems = @($ObjDomain.pLsUbuntu,$ObjDomain.pLsCentOs,$ObjDomain.pLsOpenSUSE)
 # Define the parameters for Get-AzureRmAutomationDscOnboardingMetaconfig using PowerShell Splatting
 $Params = @{
    ResourceGroupName = $autoAcctRg; # The name of the ARM Resource Group that contains your Azure Automation Account
    AutomationAccountName = $autoAcct; # The name of the Azure Automation Account where you want a node on-boarded to
    ComputerName = $LinuxSystems; # The names of the computers that the meta configuration will be generated for
    OutputFolder = $scriptDir;
 } # end params

# Use PowerShell splatting to pass parameters to the Azure Automation cmdlet being invoked
# For more info about splatting, run: Get-Help -Name about_Splatting
Get-AzureRmAutomationDscOnboardingMetaconfig @Params -Confirm:$false -Force
$dscMetaConfigsMof = Get-ChildItem -Path $dscMetaConfigsDir -Include *.mof -Recurse
 <#
 If (Test-Path -Path $requiredModulePath)
 {
    Remove-Item -Path $requiredModulePath -Recurse -Confirm:$false -Force
 } #end if
 Copy-Item -Path $reqModulesSourceDir -Destination $modulesDir -Recurse
 Compress-Archive -Path $requiredModulePath -DestinationPath $requiredModulePath -Update -Verbose
 $zipModuleFile = "$requiredModuleName.zip"
 $zipModuleName = "$requiredModulePath.zip"
 #>

 # Create blob containers
 If ($saResource -ne $null)
 {
  # Create container for scripts and temporary secrets
  New-AzureStorageContainer -Name $saContainerStaging -Context $saResource.Context -Permission Container -ErrorAction SilentlyContinue -Verbose
  # Create container for DSC
  New-AzureStorageContainer -Name $saContainerDSC -Context $saResource.Context -Permission Container -ErrorAction SilentlyContinue -Verbose
  # Upload Linux custom script
  Set-AzureStorageBlobContent -File $lnxCustomScriptPath -Blob $lnxCustomScript -Container $saContainerStaging -BlobType Block -Context $saResource.Context -Force -Verbose
  # Upload DSC Mof file
  # Set-AzureStorageBlobContent -File $mofFile -Blob $mofFileName -Container $saContainerDSC -BlobType Block -Context $saResource.Context -Force -Verbose
  # Create container for DSC artifacts
  New-AzureStorageContainer -Name $saContainerDSC -Context $saResource.Context -Permission Container -ErrorAction SilentlyContinue -Verbose
 } #end if
   # Upload metamofs
 $dscMetaMofBlobUri = @()
 ForEach ($mof in $dscMetaConfigsMof)
 {
   Set-AzureStorageBlobContent -File $mof.FullName -Blob $mof.Name -Container $saContainerDSC -BlobType Block -Context $saResource.Context -Force -Verbose
   $dscMetaMofBlobUri += ($saResource).PrimaryEndpoints.Blob + $saContainerDSC + "/" + $mof.Name
 } #end foreach
   
 # Construct full path to custom script block blob
 $scriptBlobUri = ($saResource).PrimaryEndpoints.Blob + $saContainerStaging + "/" + $lnxCustomScript
 # $mofBlobUri = ($saResource).PrimaryEndpoints.Blob + $saContainerDSC + "/" + $mofFileName

 $linuxFileConfigName = "AddLinuxFileConfig"
 $linuxNodeConfigName = "AddLinuxFileConfig.localhost"

 # New-AzureRmAutomationModule -ResourceGroupName $autoAcctRg -AutomationAccountName $autoAcct -Name $requiredModuleName -ContentLink $dscModuleBlobUri -Verbose
 Import-AzureRmAutomationDscConfiguration -AutomationAccountName $autoAcct -ResourceGroupName $autoAcctRg -SourcePath $dscScriptSourcePath -Description "Simple DSC file addition example" -Published -LogVerbose $true -Force
 <#
 Do
     {
        $importStatus = Get-AzureRmAutomationModule -ResourceGroupName $autoAcctRg -AutomationAccountName $autoAcct -Name $requiredModuleName -Verbose
        Start-Sleep -Seconds 3
     } #end do
 Until ($importStatus.ProvisioningState -eq "Succeeded")
 #>

 $CompilationJob = Start-AzureRmAutomationDscCompilationJob -ResourceGroupName $autoAcctRg -AutomationAccountName $autoAcct -ConfigurationName $linuxFileConfigName -Verbose
 while($CompilationJob.EndTime –eq $null -and $CompilationJob.Exception –eq $null)           
    {
        $CompilationJob = $CompilationJob | Get-AzureRmAutomationDscCompilationJob
        Start-Sleep -Seconds 3
    } #end while
 $CompilationJob | Get-AzureRmAutomationDscCompilationJobOutput –Stream Any 
 
 Write-ToConsoleAndLog -Output "Deploying environment..." -Log $Log
 For ($w = 1; $w -le $WindowsInstanceCount; $w++)
	{
		$Ws2016 = $WinVmNamePrefix + $w 
		Write-WithTime -Output "Building $Ws2016" -Log $Log
    	Add-WindowsVm2016
 	} #end ForEach
 # Initialize index for each linux system
 $i = 0
 # Build each linux system in collection
 ForEach ($LinuxSystem in $LinuxSystems)
 {
  $i++
  Add-LinuxVM
  <#
  Register-AzureRmAutomationDscNode -AutomationAccountName $autoAcct `
  -AzureVMName $LinuxSystem `
  -ResourceGroupName $autoAcctRg `
  -NodeConfigurationName $linuxNodeConfigName `
  -ActionAfterReboot ContinueConfiguration `
  -AllowModuleOverwrite $true `
  -AzureVMResourceGroup $rg `
  -AzureVMLocation $Region `
  -ConfigurationMode ApplyAndAutocorrect `
  -RebootNodeIfNeeded $true `
  -RefreshFrequencyMins 30
  
  https://social.msdn.microsoft.com/Forums/azure/en-US/1e0a1a55-4b30-42b8-85ad-7e969721259b/how-do-you-configure-a-linux-vm-to-tell-azure-automation-dsc-what-its-node-configuration-is?forum=azureautomation
  $node = Get-AzureRmAutomationDscNode -AutomationAccountName $autoAcct -Name $LinuxSystem -ResourceGroupName $autoAcctRg
  Set-AzureRmAutomationDscNode -AutomationAccountName $autoAcct -Id $node.Id -NodeConfigurationName $linuxNodeConfigName -ResourceGroupName $autoAcctRg -Force -Verbose
  #>
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

# https://blogs.technet.microsoft.com/stefan_stranger/2017/01/12/installing-linux-packages-on-an-azure-vm-using-powershell-dsc/
# Authenticate, connect and test the results of the DSC configuration applied to the VM
<#
# $linuxCred = Get-Credential
$sshSession = New-SSHSession -ComputerName "<[ip-address[es]]>" -Credential $linuxCred
Invoke-SSHCommand -Command { sudo cat /tmp/dir/file } -SSHSession $sshSession | Select-Object -ExpandProperty Output
#>

<#
To gracefully remove deployed resources, execute the following commands
Get-AzureRmVm -ResourceGroupName $rg | Stop-AzureRmVm -Force
Remove-AzureRmResourceGroup -Name $rg -Force
#>

Pause