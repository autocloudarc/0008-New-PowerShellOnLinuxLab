<#
Attached you will find 2 spreadsheets. These are results of a PowerShell scripts that parsed directories to identify name and version numbers of DLLs.
Now, the next step is to compare the two outputs and determine where DLLs are missing or different on one server or the other. 
For example, server 1 may have file atl110.dll, version 11.0.60610.1; 
but server 2 does not have the file. Or Server 2 has file nxancs.dll, version 5.1.18.312; but server 1 doesn’t contain the file. 
Or, they both have file atl110.dll, but different version numbers. 
If you can point me in the right direction to develop a PowerShell script to do this comparison, that would be wonderful. Thanks 
#>

$BasePath = "C:\DATA\git\0000-scripts\CompareFiles"
# $RefObjectFileName = "INTDBP1S1System32dlls.csv"
# $DifObjectFileName = "INTDBP2S1System32dlls.csv"
$RefObjectFileName = "ht1.csv"
$DifObjectFileName = "ht2.csv"
$RefObjectPath = Join-Path -Path $BasePath -ChildPath $RefObjectFileName
$DifObjectPath = Join-Path -Path $BasePath -ChildPath $DifObjectFileName
$RefObject = Import-Csv -Path $RefObjectPath
$DifObject = Import-Csv -Path $DifObjectPath
Compare-Object -ReferenceObject $RefObject -DifferenceObject $DifObject