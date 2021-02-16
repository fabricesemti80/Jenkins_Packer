

[cmdletbinding(SupportsShouldProcess = $True)]
[OutputType([int])]
param(

    [Parameter(Mandatory = $True)]
    [string]
    $buildFolder,

    [Parameter(Mandatory = $True)]
    [string] 
    [ValidateSet('2019_core', '2019_gui', '2016_core', '2016_gui')]
    $buildName,

    [Parameter(Mandatory = $True)]
    [string] 
    [ValidateSet('bnw', 'alx')]
    $cluster

)
    
begin {
    
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    $CurrentPath = Split-Path -Parent $PSCommandPath
    
}
    
process {

    # notify
    Write-Host "Building template: $buildname"; 
    Write-Host "Deployment cluster: $cluster" ;    

    switch (${buildName}) {
        '2019_core' {
            #
            Break 
        }
        '2019_gui' {
            #
            Break 
        }
        '2016_core' {
            #
            Break 
        }
        '2016_bui' {
            #
            Break 
        }                        
        Default {
        }
    }
        
}
    
end {
}
