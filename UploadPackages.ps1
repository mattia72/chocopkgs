$ErrorActionPreference = 'Stop'

function CreateAllPackages() {
    ls -r -fi *.nuspec | % {
        cpack $_.FullName
        if(!$?) {
            throw "Failed to create package."
        }
    }
}

function UploadAllPackages() {
    ls *.nupkg | % {
        cpush $_
    }
}

function AskForApprovalOfAllPackages() {
    Write-Host "The following packages will be uploaded. Type YES when you have tested them to confirm they have been tested."
    ls *.nupkg | select -Expand Name | Write-Host
    if((Read-Host "Enter YES to upload") -ine 'YES') {
        throw "Upload aborted because user did not confirm."
    }
}

function RunWithinDirectory([string]$Path, [scriptblock]$Command) {
    pushd $Path
    try {
        & $Command
    }
    finally {
        popd
    }
}

RunWithinDirectory $PSScriptRoot {
    CreateAllPackages
    AskForApprovalOfAllPackages
    UploadAllPackages
}