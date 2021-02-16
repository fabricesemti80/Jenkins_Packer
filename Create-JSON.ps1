

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

    $date = Get-Date -Format yyyyMMdd
    
}
    
process {

    # source files
    $2019builders = '.\sources\JSON\2019_builders.json'
    $baseProvisioners = '.\sources\JSON\base_provisioners.json'
    $variables = '.\sources\JSON\bnw_variables.json'
    if ($cluster -match 'bnw') {
        # bnw cluster 
        $variables = '.\sources\JSON\bnw_variables.json'
    }
    else {
        # alw cluster
        $variables = '.\sources\JSON\anw_variables.json'
    }
    # notify
    Write-Host "Building template: $buildname"; 
    Write-Host "Deployment cluster: $cluster" ;    

    switch (${buildName}) {
        '2019_core' {
            # merge and save the powershell file
            $buildJSON = '.\' + $buildName + '\' + $date + '_build.json'
            $data1 = Get-Content $2019builders -Raw | ConvertFrom-Json
            $data2 = Get-Content $baseProvisioners -Raw | ConvertFrom-Json
            $data3 = Get-Content $variables -Raw | ConvertFrom-Json
            #
            @($data1; $data2; $data3) | ConvertTo-Json -Depth 5 | Out-File $buildJSON
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
