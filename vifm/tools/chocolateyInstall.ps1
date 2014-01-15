$packageName = 'vifm'
$url = 'http://sourceforge.net/projects/vifm/files/vifm-w32/vifm-w32-se-0.7.6-binary.zip/download'
$url64 = 'http://sourceforge.net/projects/vifm/files/vifm-w64/vifm-w64-se-0.7.6-binary.zip/download'

try {
  $toolsFolder = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $tempDir = Join-Path $env:TEMP "chocolatey\$($packageName)"
  if(Test-Path $tempDir) { rm -fo -r $tempDir }
  Install-ChocolateyZipPackage "$packageName" "$url" "$tempDir" "$url64"
  ls $tempDir -fi vifm-* | % { robocopy /e $_.FullName $toolsFolder }

  #Suppress creation of batch redirects for some rarely used executables
  'vifmrc-converter.exe', 'win_helper.exe' | % {
    Set-Content -Path (Join-Path $toolsFolder "${_}.ignore") -Encoding byte -Value @()
  }

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
