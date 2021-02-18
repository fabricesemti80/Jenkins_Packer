$edition = (Get-WmiObject -Class Win32_OperatingSystem).Caption

if ($edition -like '*2019*') {
    # $cName = hostname
    
    # export pre-aut info
    # cscript C:\Windows\System32\slmgr.vbs /dli > $('c:\' + $cName + '_pre_activation.txt')
    # remove KMS
    Write-Host ''
    Write-Output 'Removing KMS product key'
    slmgr /upk
    Start-Sleep -Seconds 30
    # add MAK
    Write-Output 'Applying MAK key'
    slmgr /ipk 7FDQQ-NJWP6-YFXJ8-HDC9V-MBKRD
    Write-Output 'Product Key pudated'
    Write-Host ''
    #     cscript C:\Windows\System32\slmgr.vbs /dli > $('c:\' + $cName + '_post_activation.txt')
}