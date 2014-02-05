$packageName = 'vifm'
$url32 = 'http://download.microsoft.com/download/F/4/4/F4461C3D-B378-473D-B15A-28BC0BD849E8/MessageAnalyzer.msi'
$url64 = 'http://download.microsoft.com/download/F/4/4/F4461C3D-B378-473D-B15A-28BC0BD849E8/MessageAnalyzer64.msi'

Install-ChocolateyPackage 'microsoft-message-analyzer' 'msi' '/quiet' $url32 $url64