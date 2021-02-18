$edition = (Get-WmiObject -Class Win32_OperatingSystem).Caption

if ($edition -like '*2019*') {

    <# 
    https://docs.microsoft.com/en-us/archive/blogs/rgullick/activating-windows-with-powershell
    #>
    Write-Output 'Changing product key to MAK'
    $computer = Get-Content env:computername

    $key = '7FDQQ-NJWP6-YFXJ8-HDC9V-MBKRD'

    $service = Get-WmiObject -Query 'select * from SoftwareLicensingService' -ComputerName $computer

    $service.InstallProductKey($key)

    $service.RefreshLicenseStatus()
    # # $cName = hostname
    
    # # export pre-aut info
    # # cscript C:\Windows\System32\slmgr.vbs /dli > $('c:\' + $cName + '_pre_activation.txt')
    # # remove KMS
    # Write-Host ''
    # Write-Output 'Removing KMS product key'
    # slmgr /upk
    # Start-Sleep -Seconds 30
    # # add MAK
    # Write-Output 'Applying MAK key'
    # slmgr /ipk 7FDQQ-NJWP6-YFXJ8-HDC9V-MBKRD
    # Write-Output 'Product Key pudated'
    # Write-Host ''
    # #     cscript C:\Windows\System32\slmgr.vbs /dli > $('c:\' + $cName + '_post_activation.txt')
}

Write-Host 'Product key updated'

