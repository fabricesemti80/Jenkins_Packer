function Set-BGInfo {
    [cmdletbinding(SupportsShouldProcess = $True)]
    [OutputType([int])]
    param(
    )
    begin {
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        #$CurrentPath = Split-Path -Parent $PSCommandPath
        $BGInfoRegPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
        $BGInfoRegkey = 'BGInfo'
        $BGInfoRegType = 'String'
        $BGInfoRegkeyValue = 'C:\ProgramData\chocolatey\lib\BGInfo\Tools\BGInfo.exe C:\BGInfo\logon.BGI /timer:0 /nolicprompt'
        $regKeyExists = (Get-Item $BGInfoRegPath -EA Ignore).Property -contains $BGInfoRegkey
    }
    process {
        # copy BGnfo config
        Write-Output '# Copying BGInfo config file' -ForegroundColor Green
        [void](New-Item -Path 'C:\BGInfo' -ItemType 'Directory' -Force)
        Copy-Item -Path 'a:\logon.BGI' -Destination 'C:\BGInfo\logon.BGI'
        # set registry
        If ($regKeyExists -eq $True) {
            Write-Output '# BGInfo regkey exists, script will go on' 
        }
        Else {
            New-ItemProperty -Path $BGInfoRegPath -Name $BGInfoRegkey -PropertyType $BGInfoRegType -Value $BGInfoRegkeyValue
            Write-Output'# BGInfo regkey added'
        }
    }
    end {
        C:\ProgramData\chocolatey\lib\BGInfo\Tools\BGInfo.exe C:\BGInfo\logon.BGI /timer:0 /nolicprompt
        Write-Host '# BGInfo started' 
    }
}
$regKey = 'HKLM:/SOFTWARE/Microsoft/Windows NT/CurrentVersion'
If ((Get-ItemProperty $regKey).InstallationType -ne 'Server Core') {
    Set-BGInfo
}
