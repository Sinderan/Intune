$Path = "$env:APPDATA\GoldWave"
$File = "GoldWave.xml"

Write-Output "Checking if exists: $Path"
If(!(Test-Path -PathType Container $Path))
{
    Write-Output "Path not found, Creating Path"
    New-Item -ItemType Directory -Path $Path
} Else {
    Write-Output "Path Exists"
}

Write-Output "Checking if exists: $Path\$File"
If(!(Test-Path -PathType Leaf $Path\$File))
{
    Write-Output "Path not found, Creating File"
    Copy-Item -Path $File -Destination $Path
} Else {
    Write-Output "File Exists"
}