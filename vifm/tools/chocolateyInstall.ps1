$packageName = 'vifm'
$url = 'http://sourceforge.net/projects/vifm/files/vifm-w32/vifm-w32-se-0.7.7-binary.zip/download'
$url64 = 'http://sourceforge.net/projects/vifm/files/vifm-w64/vifm-w64-se-0.7.7-binary.zip/download'

try {
  $toolsFolder = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $tempDir = Join-Path $env:TEMP "chocolatey\$($packageName)"
  if(Test-Path $tempDir) { rm -fo -r $tempDir }
  Install-ChocolateyZipPackage "$packageName" "$url" "$tempDir" "$url64"
  $subdir = ls $tempDir -fi vifm-* 
  if($subdir.GetType().FullName -ne 'System.IO.DirectoryInfo') {
    throw "Expected to find one subfolder."
  }
  $subdir | % { 
    robocopy /e /nfl /ndl /njh /njs /np $_.FullName $toolsFolder | Out-Null
    if($LASTEXITCODE -gt 4) {
        throw "Failed to copy files."
    }
  }

  #Suppress creation of batch redirects for some rarely used executables
  'vifmrc-converter.exe', 'win_helper.exe' | % {
    Set-Content -Path (Join-Path $toolsFolder "${_}.ignore") -Encoding byte -Value @()
  }

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
