$ErrorActionPreference = 'Stop';

$packageName= 'rsvg-convert'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Write-Host "Getting rsvg-convert .7z"
$zFile = Get-Item "$toolsDir\rsvg-convert-*.7z"

Get-ChocolateyUnzip -FileFullPath $zfile -Destination $toolsDir

