[cmdletbinding()]
param(
    # [Parameter(Mandatory = $true)] $homeFolder,
    # [Parameter(Mandatory = $true)]
    # [ValidateSet('2019_core', '2019_gui', '2016_core', '2016_gui')]
    # $buildName,
    # [Parameter(Mandatory)]
    # $productKey2019,
    # [Parameter(Mandatory)]
    # $productKey2016,
    # [Parameter(Mandatory)]
    # $sourceFolder,
    # [Parameter(Mandatory)]
    # $buildFolder,
    # [Parameter(Mandatory)]
    # $vCenterAdmin,
    [Parameter(Mandatory)][array]$builds,
    [Parameter(Mandatory)]
    $vCenterPwd,
    [Parameter(Mandatory)]
    # $localUser,
    # [Parameter(Mandatory)]
    $localPwd,
    [Parameter(Mandatory = $false)][switch] $build # if this switch is not enabled, the process will only validate
)

foreach ($buildName in $builds) {
    

    Set-Location $buildname 
    $loc = Get-Location
    Write-Output "Entered into folder $loc"
    
    $date = Get-Date -Format yyyyMMdd
    $buildJSON = '.\' + $date + '_build.json'

    switch ($buildName) {
        '2019_core' {
            if ($build.ispresent) {
                Write-Output 'We are building  template -> 2019 core server'  
            }
            else {
                Write-Output 'We are validating  template -> 2019 core server'  
            }
        
    
        } 
        '2019_gui' {
            if ($build.ispresent) {
                Write-Output 'We are building  template -> 2019 desktop server'  
            }
            else {
                Write-Output 'We are validating  template -> 2019 desktop server'  
            }
        } 
        '2016_core' {
            Write-Output 'We are building  templates -> 2016 core server'
        }
        '2016_gui' {
            Write-Output 'We are building  templates -> 2019 desktop server'
        }
    }
    
    # # Base Image
    if ($build.ispresent) {
        # build the template
        Start-Process -FilePath 'packer.exe' -ArgumentList "build  -var `"vm_name=$($buildName)`" -var `"vsphere-user=$($vCenterAdmin)`" -var `"vsphere-password=$($vCenterPwd)`" -var `"winadmin-password=$($localPwd)`" $buildJSON" -Wait -NoNewWindow
    }
    else {
        # validate the template
        Start-Process -FilePath 'packer.exe' -ArgumentList "validate -var `"vm_name=$($buildName)`" -var `"vsphere-user=$($vCenterAdmin)`" -var `"vsphere-password=$($vCenterPwd)`" -var `"winadmin-password=$($localPwd)`" $buildJSON" -Wait -NoNewWindow
    }

}




