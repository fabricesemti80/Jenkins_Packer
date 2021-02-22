

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
    $cluster,

    [Parameter(Mandatory = $True)]
    [string]
    $pKey2016,
    
    [Parameter(Mandatory = $True)]
    [string]
    $pKey2019   

)
    
begin {
    
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    #$CurrentPath = Split-Path -Parent $PSCommandPath

    #$date = Get-Date -Format yyyyMMdd
    
}
    
process {

    # source files
    $sourceAnswerFile = '.\sources\answerFiles\autounattend.xml'
    # build file
    $buildXML = '.\' + $buildName + '\' + 'answerFiles' + '\' + 'autounattend.xml'

    $editionSelector = '/IMAGE/NAME'

    # notify
    Write-Host "Building template XML: $buildname"; 
    Write-Host "Deployment cluster: $cluster" ;    

    switch ($buildName) {
        '2019_core' {
            #$productKey = '7FDQQ-NJWP6-YFXJ8-HDC9V-MBKRD' # MAK
            $productKey = 'N69G4-B89J2-4G8F4-WWYCC-J464C' # KMS
            $edition = 'Windows Server 2019 SERVERSTANDARDCORE'
            Break 
        }
        '2019_gui' {
            #$productKey = '7FDQQ-NJWP6-YFXJ8-HDC9V-MBKRD' # MAK
            $productKey = 'N69G4-B89J2-4G8F4-WWYCC-J464C' # KMS
            $edition = 'Windows Server 2019 SERVERSTANDARD'
            Break             
        }
        '2016_core' {
            $productKey = 'JRYFV-RCN7X-6BH4H-JQGQ7-X77YC'
            $edition = 'Windows Server 2016 SERVERSTANDARDCORE'
            Break 
            
        }
        '2016_gui' {
            $productKey = 'JRYFV-RCN7X-6BH4H-JQGQ7-X77YC'
            $edition = 'Windows Server 2016 SERVERSTANDARD'
            Break  
        }                        
        Default {
        }
    }
        
    [xml]$XmlDocument = Get-Content $sourceAnswerFile
    [xml]$newXmlDocument = $XmlDocument
    # update activation key
    ($newXmlDocument.unattend.settings.component | Where-Object { $_.Name -match 'Microsoft-Windows-Setup' }).userdata.productkey.key = $productKey
    # update edition
    ($newXmlDocument.unattend.settings.component | Where-Object { $_.Name -match 'Microsoft-Windows-Setup' }).imageinstall.osimage.installfrom.metadata.key = $editionSelector
    ($newXmlDocument.unattend.settings.component | Where-Object { $_.Name -match 'Microsoft-Windows-Setup' }).imageinstall.osimage.installfrom.metadata.value = $edition
    $newXmlDocument.save("$buildXML")
}
    
end {
}
