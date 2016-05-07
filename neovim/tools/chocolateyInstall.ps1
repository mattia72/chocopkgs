#Automated installation steps based on the official manual steps at
#https://github.com/neovim/neovim/wiki/Installing-Neovim#windows

$ErrorActionPreference = 'Stop'; 

$packageName= 'neovim'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = '{{DownloadUrl}}' 
$url64      = '{{DownloadUrlx64}}'
$neovimQtUrl = "https://github.com/equalsraf/neovim-qt/releases/download/staging/neovim-qt.zip"
$exeNotToIgnore='neovim.exe'

$neovimPackageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  url64bit      = $url64
  validExitCodes= @(0) 
  softwareName  = 'Neovim*' 
  checksum      = '{{Checksum}}'
  checksumType  = 'md5' 
  checksum64    = '{{Checksumx64}}'
  checksumType64= 'md5' 
}
$neovimQtPackageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $neovimQtUrl
  url64bit      = $neovimQtUrl
  validExitCodes= @(0) 
  softwareName  = 'Neovim*' 
  checksum      = '{{Checksum}}'
  checksumType  = 'md5' 
  checksum64    = '{{Checksumx64}}'
  checksumType64= 'md5' 
}

function MergeApplicationDirectories($neovimDirectory, $neovimQtDirectory) {
    mv "$neovimDirectory\NeoVim\bin\*" $neovimQtDirectory
    mv -r "$neovimDirectory\NeoVim\share\nvim\runtime\*" $neovimQtDirectory
    mv $neovimQtDirectory\nvim-qt.exe $neovimQtDirectory\neovim.exe
}

function IgnoreToolsExecutables() {
  Get-ChildItem ".\*" -Force -Include *.exe -Exclude $exeNotToIgnore | % { '' > "$_.ignore" }
}

Install-ChocolateyZipPackage @neovimQtPackageArgs
Install-ChocolateyZipPackage @neovimPackageArgs

MergeApplicationDirectories $toolsDir $toolsDir

Push-Location "$toolsDir"
IgnoreToolsExecutables 
Pop-Location

