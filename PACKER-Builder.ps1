[cmdletbinding()]
param(
    [Parameter(Mandatory)][array]$clusters,
    [Parameter(Mandatory)][array]$builds,
    [Parameter(Mandatory)]
    $vCenterPwd,
    [Parameter(Mandatory)]
    $localPwd,
    [Parameter(Mandatory = $false)][switch] $deploy, # if this switch is not enabled, the process will only validate
    [Parameter(Mandatory)] [ValidateSet('seq', 'par')]
    $mode
)
$timeStamp = Get-Date -Format yyyy-MM-dd
$note = "This template was created on $timeStamp using Packer!"

switch ($mode) {
    'par' {
        ### * ---> PARALELL BUILD --->
        foreach ($cluster in $clusters) {
            $inerCluster = $null
            $inerNote = $null
            $inerLocalPwd = $null
            $inervCenterPwd = $null
            $inerDeploy = $null
            $builds | ForEach-Object -Parallel {
                $inerCluster = $using:cluster
                $inerNote = $using:note
                $inerLocalPwd = $using:localPwd
                $inervCenterPwd = $using:vCenterPwd
                $inerDeploy = $using:Deploy
                function New-PACKERTemplate {
                    param (
                        [Parameter(Mandatory )]
                        [string]
                        $cluster,
                        [Parameter(Mandatory )]
                        [string]
                        $note,  
                        [Parameter(Mandatory )]
                        [string]
                        $localPwd, 
                        [Parameter(Mandatory )]
                        [string]
                        $vCenterPwd, 
                        [Parameter(Mandatory )]
                        [string]
                        $buildName,
                        [Parameter(Mandatory = $false)][switch] $deploy # if this switch is not enabled, the process will only validate        
                    )
                    Set-Location $buildname 
                    $vmName = $($cluster + '_' + $buildName )
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
                        Start-Process -FilePath 'packer.exe' -ArgumentList "build -timestamp-ui -force -var `"vm-note=$($note)`" -var `"vm_name=$($vmName)`" -var `"vsphere-user=$($vCenterAdmin)`" -var `"vsphere-password=$($vCenterPwd)`" -var `"winadmin-password=$($localPwd)`" $buildJSON" -Wait -NoNewWindow -PassThru
                        Write-Host # lazy line break
                        Write-Output "DEPLOYMENT $buildName / $cluster / $buildJSON COMPLETED SUCCESFULLY!"
                        Write-Host # lazy line break
                    }
                    else {
                        # validate the template
                        Write-Host # lazy line break
                        Write-Output "Validating build: $buildName"
                        Write-Output "Deployment cluster: $cluster"
                        Write-Output "Template file: $buildJSON"
                        Start-Process -FilePath 'packer.exe' -ArgumentList "validate -var `"vm-note=$($note)`" -var `"vm_name=$($vmName)`" -var `"vsphere-user=$($vCenterAdmin)`" -var `"vsphere-password=$($vCenterPwd)`" -var `"winadmin-password=$($localPwd)`" $buildJSON" -Wait -NoNewWindow -PassThru
                    }
                    # exited folder
                    Set-Location ..
                    $loc = Get-Location
                    Write-Output "Entered into folder $loc"    
                }
                Write-Output "PROCESSING --> $($_)"
                if ($inerDeploy.IsPresent) {
                    New-PACKERTemplate -cluster $inerCluster -note $inerNote -localpwd $inerLocalPwd -vcenterpwd $inervCenterPwd -buildName $($_) -deploy
                }
                else {
                    New-PACKERTemplate -cluster $inerCluster -note $inerNote -localpwd $inerLocalPwd -vcenterpwd $inervCenterPwd -buildName $($_)
                }
            }
        }
        break 
    }
    'seq' {
        ### * ---> SEQUENTIAL BUILD --->
        foreach ($cluster in $clusters) {
            foreach ($buildName in $builds) {
                Set-Location $buildname 
                $vmName = ($buildName + '_' + "$cluster")
                $loc = Get-Location
                Write-Output "Entered into folder $loc"
                $date = Get-Date -Format yyyyMMdd
                $buildJSON = '.\' + $date + '_' + $cluster + '_build.json'
                # # Base Image
                if ($deploy.ispresent) {
                    # build the template
                    Write-Host # lazy line break
                    Write-Output "Deploying build: $buildName [$vmName]"
                    Write-Output "Deployment cluster: $cluster"
                    Write-Output "Template file: $buildJSON"
                    Start-Process -FilePath 'packer.exe' -ArgumentList "build -timestamp-ui -force -var `"vm-note=$($note)`" -var `"vm_name=$($vmName)`" -var `"vsphere-user=$($vCenterAdmin)`" -var `"vsphere-password=$($vCenterPwd)`" -var `"winadmin-password=$($localPwd)`" $buildJSON" -Wait -NoNewWindow
                }
                else {
                    # validate the template
                    Write-Host # lazy line break
                    Write-Output "Validating build: $buildName [$vmName]"
                    Write-Output "Deployment cluster: $cluster"
                    Write-Output "Template file: $buildJSON"
                    Start-Process -FilePath 'packer.exe' -ArgumentList "validate -var `"vm-note=$($note)`" -var `"vm_name=$($vmName)`" -var `"vsphere-user=$($vCenterAdmin)`" -var `"vsphere-password=$($vCenterPwd)`" -var `"winadmin-password=$($localPwd)`" $buildJSON" -Wait -NoNewWindow
                }
                # exited folder
                Set-Location ..
                $loc = Get-Location
                Write-Output "Entered into folder $loc"
            }
        }
        break 
    }
    Default {
        Write-Warning 'Valid execution mode required!'
    }
}

