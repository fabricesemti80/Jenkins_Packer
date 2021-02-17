function Install-Apps {
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
}

function Install-Choco {
    
    If (Get-ItemProperty -Path 'Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\' -Name 'proxyenable' -ErrorAction SilentlyContinue ) {
        # w proxy
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }

    else {
        # w/o proxy
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
}

$chocov = choco -v
$i = 0

do {
    Write-Host "ATTEMPT---> $i"
    if ($chocov) {
        Write-Output 'APP install commencing'
        Install-Apps
    }
    else {
        Install-Choco
        Write-Output 'CHOCO install commencing'
    }
    $i++
} until (($null -ne $chocov) -or ($i -ge 5))
