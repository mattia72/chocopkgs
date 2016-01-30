#Automated installation steps based on the official manual steps at
#https://github.com/neovim/neovim/wiki/Installing-Neovim#windows

function GetAppVeyorBuildUrl() {
    function GetUrl($jobs, $jobName) {
        $jobId = ($jobs | ? name -eq $jobName).jobId
        "https://ci.appveyor.com/api/buildjobs/$jobId/artifacts/build/Neovim.zip"
    }

    $buildDetails = Invoke-RestMethod -Uri https://ci.appveyor.com/api/projects/equalsraf/neovim/branch/tb-mingw
    $jobs = $buildDetails.build.jobs
    GetUrl $jobs "Environment: GENERATOR=Visual Studio 14 Win64, DEPS_PATH=deps64"
}

function GetWorkingDirectory() {
    $chocTempDir = Join-Path ([IO.Path]::GetTempPath()) 'chocolatey'
    $tempDir = Join-Path $chocTempDir 'neovim'
    if($env:packageVersion -ne $null) { $tempDir = Join-Path $tempDir "$env:packageVersion" }
    [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null
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
    cp "$neovimDirectory\NeoVim\bin\nvim.exe" $neovimQtDirectory
    cp -r "$neovimDirectory\NeoVim\share\nvim\runtime\*" $neovimQtDirectory
    mv $neovimQtDirectory\nvim-qt.exe $neovimQtDirectory\neovim.exe
}

function MoveMergedApplicationToToolsDirectory($packageToolsDirectory, $mergedDirectory) {
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