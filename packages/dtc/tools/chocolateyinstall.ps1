﻿$ErrorActionPreference = 'Stop';

$packageName= 'dtc-msys2'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Write-Host "Getting x64 bit yaml .pkg.tar.zst"
$yamlxvFile = Get-Item "$toolsDir\libyaml-*x86_64.pkg.tar.zst"

Write-Host "Getting x64 bit libs .pkg.tar.zst"
$libxvFile = Get-Item "$toolsDir\gcc-libs-*x86_64.pkg.tar.zst"

Write-Host "Getting x64 bit core .pkg.tar.zst"
$rtxvFile = Get-Item "$toolsDir\msys2-runtime-*x86_64.pkg.tar.zst"

Write-Host "Getting x64 bit dtc .pkg.tar.zst"
$dtcxvFile = Get-Item "$toolsDir\dtc-*x86_64.pkg.tar.zst"

zstd --quiet --decompress $yamlxvfile
zstd --quiet --decompress $libxvfile
zstd --quiet --decompress $rtxvfile
zstd --quiet --decompress $dtcxvfile

Write-Host "Getting x64 bit libs .pkg.tar"
$yamltarFile = Get-Item "$toolsDir\libyaml-*x86_64.pkg.tar"

Write-Host "Getting x64 bit libs .pkg.tar"
$libtarFile = Get-Item "$toolsDir\gcc-libs-*x86_64.pkg.tar"

Write-Host "Getting x64 bit core .pkg.tar"
$rttarFile = Get-Item "$toolsDir\msys2-runtime-*x86_64.pkg.tar"

Write-Host "Getting x64 bit dtc .pkg.tar"
$dtctarFile = Get-Item "$toolsDir\dtc-*x86_64.pkg.tar"

Get-ChocolateyUnzip -FileFullPath64 $dtctarfile -Destination $toolsDir
# Get file list for DTC
$dtcFiles = Get-ChildItem $toolsDir\usr\bin | ForEach-Object { $_.FullName }
Get-ChocolateyUnzip -FileFullPath64 $libtarfile -Destination $toolsDir
Get-ChocolateyUnzip -FileFullPath64 $rttarfile -Destination $toolsDir
Get-ChocolateyUnzip -FileFullPath64 $yamltarfile -Destination $toolsDir

# don't need tars anymore
Remove-Item ($toolsDir + '\*.' + 'zst')
Remove-Item ($toolsDir + '\*.' + 'tar')

# Clean up \usr\bin folder, we only need a set of files
$rtFiles = "$toolsDir\usr\bin\msys-2.0.dll","$toolsDir\usr\bin\cygpath.exe", "$toolsDir\usr\bin\msys-gcc_s-1.dll", "$toolsDir\usr\bin\msys-yaml-0-2.dll"

$keepFiles = $dtcFiles + $rtFiles
$allFiles = Get-ChildItem $toolsDir\usr\bin | ForEach-Object { $_.FullName }

foreach ($file in $allFiles) {
  if ($keepFiles -notcontains $file) {
    Remove-Item ($file)
  }
}

# Delete unneeded folders
Remove-Item -Recurse -Force $toolsDir\usr\include
Remove-Item -Recurse -Force $toolsDir\usr\lib
Remove-Item -Recurse -Force $toolsDir\usr\share


