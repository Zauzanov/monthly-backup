# Path to source folder
$source = "C:\Users\user\Downloads\UT"

# Path to backup destination folder
$destinationFolder = "E:\Backups\UT"

# Create the destination folder if it does'nt exist
if (!(Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder
}

# Format the current date for the filename
$date = Get-Date -Format "yyyyMMdd"

# Archive name
$backupFile = "$destinationFolder\UT_Backup_$date.zip"

# Creating a ZIP-archive
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($source, $backupFile)

Write-Output "Backup has been created: $backupFile"