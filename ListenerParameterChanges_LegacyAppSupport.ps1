#AGListenerResourceName is the NetworkName listed in the output of Get-ClusterResource
#AGResourceName is the SQL Server Availability Group name listed in the output of Get-ClusterResource
#Change HostRecordTTL as needed in the script directly
Get-ClusterResource
$AGLisResName = Read-Host -Prompt "Input AG Listener Resource Name"
$AGResName = Read-Host -Prompt "Input AG Resource Name"
Get-ClusterResource $AGLisResName | Set-ClusterParameter -Name HostRecordTTL -Value 10
Get-ClusterResource $AGLisResName | Set-ClusterParameter -Name RegisterAllProvidersIP -Value 0
Remove-ClusterResourceDependency -Resource $AGResName -Provider $AGLisResName
Stop-ClusterResource $AGLisResName
Start-ClusterResource $AGLisResName
Get-ClusterResource $AGLisResName | Update-ClusterNetworkNameResource
Add-ClusterResourceDependency -Resource $AGResName -Provider $AGLisResName
Get-ClusterResourceDependency $AGResName
Get-ClusterResource $AGLisResName| Get-ClusterParameter HostRecordTTL, RegisterAllProvidersIP
Get-ClusterResource