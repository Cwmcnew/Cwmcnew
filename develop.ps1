# Define the network drives
$drives = @(
    "\\CVCV0FIL2009\GSOpsCtr$",
    "\\CVCV0FI215\GSOCdata$",
    "\\Shaker\CSindex$",
    "\\PMDC0FIL2001\GSOCSIP$"
)

# Function to get the next available drive letter
function Get-NextAvailableDriveLetter {
    $usedDrives = Get-WmiObject Win32_LogicalDisk | Select-Object -ExpandProperty DeviceID
    $alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.ToCharArray()

    foreach ($letter in $alphabet) {
        $drive = "$letter:"
        if ($usedDrives -notcontains $drive) {
            return $drive
        }
    }

    throw "No available drive letters!"
}

# Loop through each network drive and map it to the next available drive letter
foreach ($drivePath in $drives) {
    try {
        $nextDrive = Get-NextAvailableDriveLetter
        Write-Host "Mapping $drivePath to $nextDrive"
        New-PSDrive -Name $nextDrive.Substring(0, 1) -PSProvider FileSystem -Root $drivePath -Persist
    } catch {
        Write-Host "Error: $_"
    }
}

Write-Host "All drives mapped."
