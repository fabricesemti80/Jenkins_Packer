$edition = (Get-WmiObject -Class Win32_OperatingSystem).Caption

# switch -wildcard ($edition) {
#     '*2019*' {
#         <# 
#     https://docs.microsoft.com/en-us/archive/blogs/rgullick/activating-windows-with-powershell
#     #>
#         Write-Output 'Changing product key to MAK'
#         $computer = Get-Content env:computername

#         $key = 'N69G4-B89J2-4G8F4-WWYCC-J464C' # evaluation - https://docs.microsoft.com/en-us/answers/questions/58587/windows-server-2019-activation-from-evaluation.html
#         # $key = 'NR8HF-4K9W8-F7PHW-XMWVW-9TRBQ' # xma
#         # $key = '7FDQQ-NJWP6-YFXJ8-HDC9V-MBKRD' # westcoast

#         $service = Get-WmiObject -Query 'select * from SoftwareLicensingService' -ComputerName $computer

#         $service.InstallProductKey($key)

#         $service.RefreshLicenseStatus()
#         break }
#         '*2016'{
#         <# 
#     https://docs.microsoft.com/en-us/archive/blogs/rgullick/activating-windows-with-powershell
#     #>
#         Write-Output 'Changing product key to MAK'
#         $computer = Get-Content env:computername

#         $key = '' # 2016 product key goes here

#         $service = Get-WmiObject -Query 'select * from SoftwareLicensingService' -ComputerName $computer

#         $service.InstallProductKey($key)

#         $service.RefreshLicenseStatus()
#         Break
#         }
#     Default {}
# }

# # if ($edition -like '*2019*') {

# #     <# 
# #     https://docs.microsoft.com/en-us/archive/blogs/rgullick/activating-windows-with-powershell
# #     #>
# #     Write-Output 'Changing product key to MAK'
# #     $computer = Get-Content env:computername

# #     $key = 'N69G4-B89J2-4G8F4-WWYCC-J464C' # evaluation - https://docs.microsoft.com/en-us/answers/questions/58587/windows-server-2019-activation-from-evaluation.html
# #     # $key = 'NR8HF-4K9W8-F7PHW-XMWVW-9TRBQ' # xma
# #     # $key = '7FDQQ-NJWP6-YFXJ8-HDC9V-MBKRD' # westcoast

# #     $service = Get-WmiObject -Query 'select * from SoftwareLicensingService' -ComputerName $computer

# #     $service.InstallProductKey($key)

# #     $service.RefreshLicenseStatus()
# # } 

Write-Host "Product key updated for $edition"

