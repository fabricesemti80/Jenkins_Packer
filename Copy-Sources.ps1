[cmdletbinding(SupportsShouldProcess = $True)]
[OutputType([int])]
param(
    [Parameter(Mandatory = $True)]
    [string]
    $buildFolder,
    [Parameter(Mandatory = $false)]
    [string]
    $folder1 = 'localScripts',
    [Parameter(Mandatory = $false)]
    [string]
    $folder2 = 'remoteScripts'  
)
begin {
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    #$CurrentPath = Split-Path -Parent $PSCommandPath
}
process {
    Copy-Item -Path ".\sources\$folder1" -Destination "$buildFolder\$folder1" -Recurse
    Copy-Item -Path ".\sources\$folder2" -Destination "$buildFolder\$folder2" -Recurse
}
end {
}
