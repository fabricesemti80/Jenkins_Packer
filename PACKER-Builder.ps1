[cmdletbinding()]
param(
    [Parameter(Mandatory)][array]$clusters,
    [Parameter(Mandatory)][array]$builds,
    [Parameter(Mandatory)]
    $vCenterPwd,
    [Parameter(Mandatory)]
    # $localUser,
    # [Parameter(Mandatory)]
    $localPwd,
    [Parameter(Mandatory = $false)][switch] $deploy # if this switch is not enabled, the process will only validate
)

# If (Get-Module -Name 'Start-parallel') {
Get-Module 'start-parallel' -ListAvailable | Import-Module -Verbose -Force
# }
# else {
#     Install-Module 'Start-parallel' -Force
# }

$timeStamp = Get-Date -Format yyyy-MM-dd
$note = "This template was created on $timeStamp using Packer!"

function Create-VMTemplate {
    param (
        
        [Parameter(Mandatory )]
        [string]
        $cluster,

        [Parameter(Mandatory )]
        [string]
        $note,        
        
        [Parameter(Mandatory )]
        [string]
        $buildName,
        
        [Parameter(Mandatory = $false)][switch] $deploy # if this switch is not enabled, the process will only validate        
    )
    Set-Location $buildname 

    $loc = (Get-Location)        
    Write-Output "Entered into folder $loc"
    
    $date = Get-Date -Format yyyyMMdd
    $buildJSON = '.\' + $date + '_' + $cluster + '_build.json'
    
    # # Base Image
    if ($deploy.ispresent) {
        # build the template
        Write-Host # lazy line break
        Write-Output "Deploying build: $buildName"
        Write-Output "Deployment cluster: $cluster"
        Write-Output "Template file: $buildJSON"

        Start-Process -FilePath 'packer.exe' -ArgumentList "build -timestamp-ui -force -var `"vm-note=$($note)`" -var `"vm_name=$($buildName)`" -var `"vsphere-user=$($vCenterAdmin)`" -var `"vsphere-password=$($vCenterPwd)`" -var `"winadmin-password=$($localPwd)`" $buildJSON" -Wait -NoNewWindow
    }
    else {
        # validate the template
        Write-Host # lazy line break
        Write-Output "Validating build: $buildName"
        Write-Output "Deployment cluster: $cluster"
        Write-Output "Template file: $buildJSON"

        Start-Process -FilePath 'packer.exe' -ArgumentList "validate -var `"vm-note=$($note)`" -var `"vm_name=$($buildName)`" -var `"vsphere-user=$($vCenterAdmin)`" -var `"vsphere-password=$($vCenterPwd)`" -var `"winadmin-password=$($localPwd)`" $buildJSON" -Wait -NoNewWindow
    }
    # exited folder
    Set-Location ..
    $loc = Get-Location
    Write-Output "Entered into folder $loc"    
    
}

foreach ($cluster in $clusters) {
    $builds | Start-parallel -Scriptblock { PARAM ($buildname, $cluster, $note) ; Create-VMTemplate -cluster $cluster -note $note -buildName $buildName }
    # foreach ($buildName in $builds) {

    #     if ($deploy.IsPresent) {
    #         Create-VMTemplate -cluster $cluster -note $note -buildName $buildName -deploy
    #     }
    #     else {
    #         Create-VMTemplate -cluster $cluster -note $note -buildName $buildName
    #     }
        

        
    # }

 
}


# foreach ($cluster in $clusters) {
#     foreach ($buildName in $builds) {
    

#         Set-Location $buildname 
#         $loc = Get-Location
#         Write-Output "Entered into folder $loc"
    
#         $date = Get-Date -Format yyyyMMdd
#         $buildJSON = '.\' + $date + '_' + $cluster + '_build.json'

#         # switch ($buildName) {
#         #     '2019_core' {
#         #         if ($deploy.ispresent) {
#         #             Write-Output 'We are building  template -> 2019 core server'  
#         #         }
#         #         else {
#         #             Write-Output 'We are validating  template -> 2019 core server'  
#         #         }
        
    
#         #     } 
#         #     '2019_gui' {
#         #         if ($deploy.ispresent) {
#         #             Write-Output 'We are building  template -> 2019 desktop server'  
#         #         }
#         #         else {
#         #             Write-Output 'We are validating  template -> 2019 desktop server'  
#         #         }
#         #     } 
#         #     '2016_core' {
#         #         Write-Output 'We are building  templates -> 2016 core server'
#         #     }
#         #     '2016_gui' {
#         #         Write-Output 'We are building  templates -> 2019 desktop server'
#         #     }
#         # }
    
#         # # Base Image
#         if ($deploy.ispresent) {
#             # build the template
#             Write-Host # lazy line break
#             Write-Output "Deploying build: $buildName"
#             Write-Output "Deployment cluster: $cluster"
#             Write-Output "Template file: $buildJSON"

#             Start-Process -FilePath 'packer.exe' -ArgumentList "build -timestamp-ui -force -var `"vm-note=$($note)`" -var `"vm_name=$($buildName)`" -var `"vsphere-user=$($vCenterAdmin)`" -var `"vsphere-password=$($vCenterPwd)`" -var `"winadmin-password=$($localPwd)`" $buildJSON" -Wait -NoNewWindow
#         }
#         else {
#             # validate the template
#             Write-Host # lazy line break
#             Write-Output "Validating build: $buildName"
#             Write-Output "Deployment cluster: $cluster"
#             Write-Output "Template file: $buildJSON"

#             Start-Process -FilePath 'packer.exe' -ArgumentList "validate -var `"vm-note=$($note)`" -var `"vm_name=$($buildName)`" -var `"vsphere-user=$($vCenterAdmin)`" -var `"vsphere-password=$($vCenterPwd)`" -var `"winadmin-password=$($localPwd)`" $buildJSON" -Wait -NoNewWindow
#         }
#         # exited folder
#         Set-Location ..
#         $loc = Get-Location
#         Write-Output "Entered into folder $loc"
#     }

 
# }



