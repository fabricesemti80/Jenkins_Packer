$edition = (Get-WmiObject -Class Win32_OperatingSystem).Caption

if ($edition -like '*2019*') {
    $cName = hostname
    Write-Output 'Applying workaround for 2019 ---> replace KMS key to MAK key'
    # export pre-aut info
    cscript C:\Windows\System32\slmgr.vbs /dli > $('c:\' + $cName + '_pre_activation.txt')
    # remove KMS
    slmgr /upk
    Start-Sleep -Seconds 30
    # add MAK
    slmgr /ipk 7FDQQ-NJWP6-YFXJ8-HDC9V-MBKRD
    cscript C:\Windows\System32\slmgr.vbs /dli > $('c:\' + $cName + '_post_activation.txt')
}