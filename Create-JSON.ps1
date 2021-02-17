

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
    [ValidateSet('bnw', 'alw')]
    $cluster

)
    
begin {
    
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    #$CurrentPath = Split-Path -Parent $PSCommandPath

    #region MERGE JSON https://gist.github.com/Badabum/a61e49019fb96bef4d5d9712e07b2af7
    function Join-Objects($source, $extend) {
        if ($source.GetType().Name -eq 'PSCustomObject' -and $extend.GetType().Name -eq 'PSCustomObject') {
            foreach ($Property in $source | Get-Member -type NoteProperty, Property) {
                if ($null -eq $extend.$($Property.Name)) {
                    continue;
                }
                $source.$($Property.Name) = Join-Objects $source.$($Property.Name) $extend.$($Property.Name)
            }
        }
        else {
            $source = $extend;
        }
        return $source
    }
    function AddPropertyRecurse($source, $toExtend) {
        if ($source.GetType().Name -eq 'PSCustomObject') {
            foreach ($Property in $source | Get-Member -type NoteProperty, Property) {
                if ($null -eq $toExtend.$($Property.Name)) {
                    $toExtend | Add-Member -MemberType NoteProperty -Value $source.$($Property.Name) -Name $Property.Name `
            
                }
                else {
                    $toExtend.$($Property.Name) = AddPropertyRecurse $source.$($Property.Name) $toExtend.$($Property.Name)
                }
            }
        }
        return $toExtend
    }
    function Json-Merge($source, $extend) {
        $merged = Join-Objects $source $extend
        $extended = AddPropertyRecurse $merged $extend
        return $extended
    }
    #endregion

    $date = Get-Date -Format yyyyMMdd
    
}
    
process {

    # source files
    $builders = '.\sources\JSON\builders.json'
    $baseProvisioners = '.\sources\JSON\base_provisioners.json'
    # $variables = '.\sources\JSON\bnw_variables.json'

    switch ($cluster) {
        'bnw' {
            $variables = '.\sources\JSON\bnw_variables.json'; break 
        }
        'alw' {
            $variables = '.\sources\JSON\alw_variables.json'; break 
        }
        Default {
            Write-Output 'Unrecognized cluster!'
        }
    }


    # if ($cluster -match 'bnw') {
    #     # bnw cluster 
    #     $variables = '.\sources\JSON\bnw_variables.json'
    # }
    # else {
    #     # alw cluster
    #     $variables = '.\sources\JSON\anw_variables.json'
    # }
    # build file
    $buildJSON = '.\' + $buildName + '\' + $date + '_' + $cluster + '_build.json'
    # notify
    Write-Output "Building template JSON: $buildname"; 
    Write-Output "Deployment cluster: $cluster" ;    

    # switch -wildcard  (${buildName}) {
    #     '2019*' {
    # merge and save the powershell file
            
    $data1 = Get-Content $builders -Raw | ConvertFrom-Json
    $data2 = Get-Content $baseProvisioners -Raw | ConvertFrom-Json
    $data3 = Get-Content $variables -Raw | ConvertFrom-Json
    #
    # @($data1; $data2; $data3) | ConvertTo-Json -Depth 5 | Out-File $buildJSON

    $JSON = Json-Merge $data1 $data2
    $JSON = Json-Merge $JSON $data3
    $JSON | ConvertTo-Json -Depth 5 | Out-File $buildJSON -Encoding Ascii -Force
    #     Break 
    # }
    # '2016*' {
    #     # merge and save the powershell file
            
    #     $data1 = Get-Content $builders -Raw | ConvertFrom-Json
    #     $data2 = Get-Content $baseProvisioners -Raw | ConvertFrom-Json
    #     $data3 = Get-Content $variables -Raw | ConvertFrom-Json
    #     #
    #     # @($data1; $data2; $data3) | ConvertTo-Json -Depth 5 | Out-File $buildJSON

    #     $JSON = Json-Merge $data1 $data2
    #     $JSON = Json-Merge $JSON $data3
    #     $JSON | ConvertTo-Json -Depth 5 | Out-File $buildJSON -Encoding Ascii -Force
    #     Break 
    # }                     
    # Default {
    # }
    #  }
        
}
    
end {
}
