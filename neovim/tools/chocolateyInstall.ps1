﻿#Automated installation steps based on the official manual steps at
#https://github.com/neovim/neovim/wiki/Installing-Neovim#windows

function GetAppVeyorBuildUrl() {
    function GetUrl($jobs, $jobName) {
        $jobId = ($jobs | ? name -eq $jobName).jobId
        "https://ci.appveyor.com/api/buildjobs/$jobId/artifacts/build/Neovim.zip"
    }

    $buildDetails = Invoke-RestMethod -Uri https://ci.appveyor.com/api/projects/equalsraf/neovim/branch/tb-mingw
    $build = $buildDetails.build
    $buildStatus = $build.status
    if($buildStatus -ne 'success') {
        throw "Unable to download neovim because the latest build is failing (current status = $buildStatus). " +
        "Please see the build status page at https://ci.appveyor.com/project/equalsraf/neovim/branch/tb-mingw. " +
        "Also consider creating a new issue for the neovim project at https://github.com/neovim/neovim/issues."
    }
    $jobs = $build.jobs
    GetUrl $jobs "Environment: GENERATOR=Visual Studio 14 Win64, DEPS_PATH=deps64"
}

function GetWorkingDirectory() {
    $chocTempDir = Join-Path ([IO.Path]::GetTempPath()) 'chocolatey'
    $tempDir = Join-Path $chocTempDir 'neovim'
    if($env:packageVersion -ne $null) { $tempDir = Join-Path $tempDir "$env:packageVersion" }
    [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null
    Write-Host "Working directory is $tempDir."
    $tempDir
}

function ClearWorkingDirectory() {
    rm -r -fo -ea 0 (GetWorkingDirectory)
}

function DownloadAndExtractArchive($url, $destinationFileName) {
    $workingDirectory = GetWorkingDirectory
    $localZipFilePath = Join-Path $workingDirectory $destinationFileName
    $extractDirectory = Join-Path $workingDirectory ([IO.Path]::GetFileNameWithoutExtension($destinationFileName))
    Get-ChocolateyWebFile neovim $localZipFilePath $url $url | Out-Null
    Get-ChocolateyUnzip $localZipFilePath $extractDirectory -Package 'neovim' | Out-Null
    $extractDirectory
}

function MergeApplicationDirectories($neovimDirectory, $neovimQtDirectory) {
    cp "$neovimDirectory\NeoVim\bin\*" $neovimQtDirectory
    cp -r "$neovimDirectory\NeoVim\share\nvim\runtime\*" $neovimQtDirectory
    mv $neovimQtDirectory\nvim-qt.exe $neovimQtDirectory\neovim.exe
}

function MoveMergedApplicationToToolsDirectory($packageToolsDirectory, $mergedDirectory) {
    Write-Host "Copying package from $mergedDirectory to $packageToolsDirectory..."
    cp -r $mergedDirectory $packageToolsDirectory
}

function IgnoreToolsExecutables($packageToolsDirectory) {
    ls $packageToolsDirectory -fi *.exe | ? Name -ne 'neovim.exe' | % { echo ignore > $packageToolsDirectory\$_.ignore }
}

$neovim64Url = GetAppVeyorBuildUrl
$neovimqtUrl = "https://github.com/equalsraf/neovim-qt/releases/download/staging/neovim-qt.zip"

ClearWorkingDirectory
$neovimDirectory = DownloadAndExtractArchive $neovim64Url 'neovim.zip'
$neovimQtDirectory = DownloadAndExtractArchive $neovimqtUrl 'neovimqt.zip'
MergeApplicationDirectories $neovimDirectory $neovimQtDirectory
$packageToolsDirectory = "$PSScriptRoot\neovim"
MoveMergedApplicationToToolsDirectory $packageToolsDirectory $neovimQtDirectory
IgnoreToolsExecutables $packageToolsDirectory