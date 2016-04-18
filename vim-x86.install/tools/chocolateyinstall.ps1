$packageName = 'vim-x86.install'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$destDir = Join-Path $toolsDir "vim74"
$url = "http://tuxproject.de/projects/vim/complete-x86.7z"
$url86 = $url

Install-ChocolateyZipPackage $packageName $url $destDir $url86
Start-ChocolateyProcessAsAdmin "-create-batfiles evim view gview vimdiff gvimdiff -install-popup -install-openwith -add-start-menu" "$destDir\install.exe" -validExitCodes '0'
