<#
.SYNOPSIS
  Name: NSP_CleanUpLargeFile.ps1
  Checks the storage location for LargeFile in the file system and checks this against the NSP. If it does not exist, it is deleted (selection)

.NOTES
  Version:        1.0.0
  Author:         Frank Fischer - freaky-media
    Purpose/Change: inital creation

   Version: 1.0.1
   Author: Frank Fischer - freaky-media
   Purpose/Change: Add Synopsis/Notes - Change Language 
#>


write-Host "---------------------------------------------" -ForegroundColor Yellow

#Path to the Webportal on Server
$filePath = "C:\Program Files\Net at Work Mail Gateway\enQsig Webportal\App_Data\Files"

if (Test-Path $filePath)
{
#Check Folders an geht all Folder Names 
$NSPStoreFolder = Get-ChildItem -Recurse -Force -Directory $filePath -ErrorAction SilentlyContinue
#Count all Folders
$NSPStoreFolderID = $NSPStoreFolder.Count
#Output Sum
Write-Host "Found $NSPStoreFolderID Entrys"

#do for each Folder Check / Check Folder ID with NSP ID - IF Found OK - Not Found aks to delete
foreach($NSPStoreFolderGET in $NSPStoreFolder)
{
$checkNSP = (Get-NspLargeFile -NameOrId $NSPStoreFolderGET).count

if($checkNSP -eq $true)
{
#if found Output Found - can be Disabled with a # next Line
#Write-Host "found" + $NSPStoreFolderGET -ForegroundColor Green
}
else
{
# not found in NSP
Write-Host "NoFound" + $NSPStoreFolderGET -ForegroundColor Red
# aks to delete from Filesystem
$NSPConfirmDEL = Read-Host "Delte entry $NSPStoreFolderGET that not found in NSP? (type y for yes)"
if($NSPConfirmDEL -eq 'y')
{ 
# remove ID from Storage 
#Remove-NspLargeFile -Id $NSPStoreFolderGET
Remove-Item -Path "$filePath\$NSPStoreFolderGET" -Recurse

Write-Host "$filePath\$NSPStoreFolderGET is deleted" -ForegroundColor Magenta
}
}

}


}
else {
write-warning -Message "--------Pfad existiert nicht ----------------"
}