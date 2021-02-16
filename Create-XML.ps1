

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
    $sourceAnswerFile = '.\sources\answerFiles\autounattend.xml'
    # build file
    $buildXML = '.\' + $buildName + '\' + 'answerFiles' + '\' + 'autounattend.xml'

    $editionSelector = '/IMAGE/NAME'

    # notify
    Write-Host "Building template XML: $buildname"; 
    Write-Host "Deployment cluster: $cluster" ;    

    switch (${buildName}) {
        '2019_core' {
            $productKey = '7FDQQ-NJWP6-YFXJ8-HDC9V-MBKRD'
            $edition = 'Windows Server 2019 SERVERSTANDARDCORE'

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
