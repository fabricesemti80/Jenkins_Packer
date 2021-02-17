# ! ON ANY VERSION
# * Windows Update Powershell module
choco install pswindowsupdate -y -f 

# ! ON ONLY NON-CORE VERSION
$regKey = 'HKLM:/SOFTWARE/Microsoft/Windows NT/CurrentVersion'
If ((Get-ItemProperty $regKey).InstallationType -ne 'Server Core') {
    # * BG Info    
    choco install bginfo -y -f
    # * Microsoft Edge
    choco install microsoft-edge -y -f     
}