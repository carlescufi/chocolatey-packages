$ErrorActionPreference = 'Stop';

$packageName= 'dtc-msys2'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$rtxvFile = if ((Get-ProcessorBits 64) -and $env:chocolateyForceX86 -ne 'true') {
         Write-Host "Getting x64 bit core .pkg.tar.xz"; Get-Item "$toolsDir\msys2-runtime-*x86_64.pkg.tar.xz"
} else { Write-Host "Getting x32 bit core .pkg.tar.xz"; Get-Item "$toolsDir\msys2-runtime-*i686.pkg.tar.xz" }

$dtcxvFile = if ((Get-ProcessorBits 64) -and $env:chocolateyForceX86 -ne 'true') {
         Write-Host "Getting x64 bit dtc .pkg.tar.xz"; Get-Item "$toolsDir\dtc-*x86_64.pkg.tar.xz"
} else { Write-Host "Getting x32 bit dtc .pkg.tar.xz"; Get-Item "$toolsDir\dtc-*i686.pkg.tar.xz" }

Get-ChocolateyUnzip -FileFullPath $rtxvfile -Destination $toolsDir
Get-ChocolateyUnzip -FileFullPath $dtcxvfile -Destination $toolsDir

$rttarFile = if ((Get-ProcessorBits 64) -and $env:chocolateyForceX86 -ne 'true') {
         Write-Host "Getting x64 bit core .pkg.tar"; Get-Item "$toolsDir\msys2-runtime-*x86_64.pkg.tar"
} else { Write-Host "Getting x32 bit core .pkg.tar"; Get-Item "$toolsDir\msys2-runtime-*i686.pkg.tar" }

$dtctarFile = if ((Get-ProcessorBits 64) -and $env:chocolateyForceX86 -ne 'true') {
         Write-Host "Getting x64 bit dtc .pkg.tar"; Get-Item "$toolsDir\dtc-*x86_64.pkg.tar"
} else { Write-Host "Getting x32 bit dtc .pkg.tar"; Get-Item "$toolsDir\dtc-*i686.pkg.tar" }

Get-ChocolateyUnzip -FileFullPath $dtctarfile -Destination $toolsDir
# Get file list for DTC
$dtcFiles = Get-ChildItem $toolsDir\usr\bin | ForEach-Object { $_.FullName }
Get-ChocolateyUnzip -FileFullPath $rttarfile -Destination $toolsDir

# don't need tars anymore
Remove-Item ($toolsDir + '\*.' + 'xz')
Remove-Item ($toolsDir + '\*.' + 'tar')

# Clean up \usr\bin folder, we only need a set of files
$rtFiles = "$toolsDir\usr\bin\msys-2.0.dll","$toolsDir\usr\bin\cygpath.exe"

$keepFiles = $dtcFiles + $rtFiles
$allFiles = Get-ChildItem $toolsDir\usr\bin | ForEach-Object { $_.FullName }

foreach ($file in $allFiles) {
  if ($keepFiles -notcontains $file) {
    Remove-Item ($file)
  }
}



