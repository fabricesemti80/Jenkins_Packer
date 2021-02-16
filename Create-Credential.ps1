[cmdletbinding(SupportsShouldProcess = $True)]
[OutputType([int])]
param(
    [Parameter(Mandatory = $false)]
    [string]
    $user = 'administrator@vsphere.local'
)
begin {
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    $CurrentPath = Split-Path -Parent $PSCommandPath
    $credXML = $CurrentPath + '\' + 'creds' + '\' + $(($user -replace '@', '_') -replace '\.', '_') + '_cred.xml'
}
process {
    $Credential = Get-Credential -UserName $user
    $Credential | Export-Clixml $credXML
}
end {
}
