$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'freecommander-xe.portable' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://freecommander.com/downloads/FreeCommanderXE-32-public_portable.zip' # download url
#$fileLocation = Join-Path $toolsDir 'NAME_OF_EMBEDDED_INSTALLER_FILE'
#$fileLocation = '\\SHARE_LOCATION\to\INSTALLER_FILE'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  url64bit      = $url64

  validExitCodes= @(0) #please insert other valid exit codes here

  # optional, highly recommended
  softwareName  = 'freecommander-xe.portable*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  checksum      = '{{Checksum}}'
  checksumType  = 'md5' #default is md5, can also be sha1
  checksum64    = '{{Checksumx64}}'
  checksumType64= 'md5' #default is checksumType
}

Install-ChocolateyZipPackage @packageArgs

