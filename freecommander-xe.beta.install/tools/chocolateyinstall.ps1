$ErrorActionPreference = 'Stop'; 

$packageName= 'freecommander-xe.beta.install' 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = '{{DownloadUrl}}' 
$zipFileName= $url -replace ".*/", ""
# name of the executable within the zip
$exeFileName= 'FreeCommanderXE-32-public_beta_setup.exe'


function GetWorkingDirectory() {
    $chocTempDir = Join-Path ([IO.Path]::GetTempPath()) 'chocolatey'
    $tempDir = Join-Path $chocTempDir $packageName
    if($env:packageVersion -ne $null) { $tempDir = Join-Path $tempDir "$env:packageVersion" }
    [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null
    Write-Debug "Working directory is $tempDir."
    $tempDir
}

function ClearWorkingDirectory() {
    Write-Debug "Cleaning working directory ..."
    Remove-Item -Recurse -Force -ErrorAction 0 (GetWorkingDirectory)
    Write-Debug "Working directory cleaned."
}

function DownloadAndExtractArchive($url) {
    $workingDirectory = GetWorkingDirectory
    Push-Location $workingDirectory
    Get-WebFile $url | Out-Null
    Pop-Location
    $localZipFilePath=Join-Path $workingDirectory $zipFileName
    $extractDirectory = Join-Path $workingDirectory ([IO.Path]::GetFileNameWithoutExtension($zipFileName))

    Get-ChocolateyUnzip $localZipFilePath $extractDirectory -Package $packageName | Out-Null
    Write-Debug "$zipFileName extracted to $extractDirectory"
    $extractDirectory
}

ClearWorkingDirectory

$extractDirectory = DownloadAndExtractArchive $url 

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'exe' 
  file = Join-Path $extractDirectory $exeFileName
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs

ClearWorkingDirectory

