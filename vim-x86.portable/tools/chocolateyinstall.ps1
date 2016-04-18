$packageName = 'vim-x86.portable'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$destDir = Join-Path $toolsDir "vim74"
$url = "http://tuxproject.de/projects/vim/complete-x86.7z"
$url86 = $url

Get-ChildItem "$destDir\*.bat" | %{ Install-BinFile -Name $_.BaseName -Path $_ }
Install-ChocolateyZipPackage $packageName $url $destDir $url86
Start-Process "$destDir\install.exe" -ArgumentList "-add-start-menu" -WorkingDirectory "$destDir" -Wait
