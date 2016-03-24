$url32 = 'http://download.microsoft.com/download/2/8/3/283DE38A-5164-49DB-9883-9D1CC432174D/MessageAnalyzer.msi'
$sha1Hash32 = '1ECFBA636839F19D458D555337571C306047D13D'
$url64 = 'http://download.microsoft.com/download/2/8/3/283DE38A-5164-49DB-9883-9D1CC432174D/MessageAnalyzer64.msi'
$sha1Hash64 = '46693308FD80139C65E6DA434CEC0ECAA21909E5'

Install-ChocolateyPackage 'microsoft-message-analyzer' 'msi' '/quiet' $url32 $url64 -checksumType 'sha1' -checksum64 $sha1Hash64 -checksum $sha1Hash32
