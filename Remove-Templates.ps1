<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
#>
[cmdletbinding(SupportsShouldProcess = $True)]
[OutputType([int])]
param(
    [Parameter(Mandatory = $false)][string]$vCenterServer = 'bnwvcsa01.westcoast.co.uk',
    [Parameter(Mandatory = $false, ParameterSetName = 'withCredential')][PSCredential]$vCenterCred,
    [Parameter(Mandatory, ParameterSetName = 'withUnamePassword')][string]$vCenterAdmin,
    [Parameter(Mandatory, ParameterSetName = 'withUnamePassword')][string]$vCenterPwd,
    [Parameter(Mandatory)][array]$builds,
    [Parameter(Mandatory)][array]$clusters
)
begin {
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    #$CurrentPath = Split-Path -Parent $PSCommandPath
    # modules
    Import-Module VMware.PowerCLI | Out-Null
}
process {
    #region CONNECT TO vCenter
    if (-not $vCenterCred) {
        $vCenterSecurePwd = (ConvertTo-SecureString $vCenterPwd -AsPlainText -Force)
        $vCenterCred = New-Object System.Management.Automation.PSCredential -ArgumentList $vCenterAdmin, $vCenterSecurePwd
    }
    Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    try {
        Connect-VIServer -Server $vCenterServer -Protocol https -Credential $vCenterCred
        Write-Output "Successfully connected to $vCenterServer! Continuing.."   
    }
    catch {
        Write-Output "Could not connect to $vCenterserver"
        Write-Host $_.Exception.Message
        Write-Host $_.Exception.ItemName
    }
    #endregion
    #region FIND TEMPLATES
    foreach ($cluster in $clusters) {
        switch ($cluster) {
            'bnw' {
                $folder = 'bn-Templates'; break 
            }
            'alw' {
                $folder = 'al-Templates'; break 
            }
            Default {
                Write-Warning 'Unrecognized cluster!'
            }
        }
        
    }
    foreach ($build in $builds) {
        $oldTemplates = Get-Folder $folder | Get-Template | Where-Object { $_.Name -match $build } -ErrorAction Ignore    
        #endregion
        #region REMOVE TEMPLATES
        if ($oldTemplates) {
            foreach ($VMtemplate in $oldTemplates) {            
                Remove-Template -Template $VMTemplate -Confirm:$false -Verbose # -WhatIf
            }
        }
        else {
            Write-Output "No templates found matching [$build]"
        } 
    }

    #endregion
}
end {
    #region DISCONNECT vCenter
    Disconnect-VIServer $vCenterServer -Confirm:$False
    #endregion
}