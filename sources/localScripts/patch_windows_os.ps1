$sName = hostname

Write-Output "$sname - STARTING WINDOWS PATCHES"
Get-WUInstall -WindowsUpdate -AcceptAll -IgnoreReboot -Download -Install -Confirm:$false -Verbose # * get updates from our WSUS
Get-WUInstall -MicrosoftUpdate -AcceptAll -Download -Install -IgnoreReboot -Confirm:$false -Verbose # * get updates from Microsoft 
Write-Output "$sname - COMPLETED WINDOWS PATCHES"