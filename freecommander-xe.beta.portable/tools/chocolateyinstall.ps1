$ErrorActionPreference = 'Stop'; 

$packageName= 'freecommander-xe.beta.portable' 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = '{{DownloadUrl}}' 
$exeNotToIgnore='FreeCommander.exe'

function IgnoreToolsExecutables() {
  Get-ChildItem ".\*" -Force -Include *.exe -Exclude $exeNotToIgnore | % { '' > "$_.ignore" }
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  url64bit      = $url64

  validExitCodes= @(0) 

  #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  softwareName  = 'FreeCommander XE*' 
  checksum      = '{{Checksum}}'
  checksumType  = 'md5' 
  checksum64    = '{{Checksumx64}}'
  checksumType64= 'md5' 
}

Install-ChocolateyZipPackage @packageArgs
Push-Location "$toolsDir"
IgnoreToolsExecutables 
Pop-Location
