# * Microsoft Edge
choco install microsoft-edge -y -f 
# * Windows Update Powershell module
choco install pswindowsupdate -y -f 
# * BG Info
$regKey = 'HKLM:/SOFTWARE/Microsoft/Windows NT/CurrentVersion'
If ((Get-ItemProperty $regKey).InstallationType -ne 'Server Core') {
    choco install bginfo -y -f
}