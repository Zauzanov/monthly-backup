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

