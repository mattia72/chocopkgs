$url32 = 'http://download.microsoft.com/download/2/8/3/283DE38A-5164-49DB-9883-9D1CC432174D/MessageAnalyzer.msi'
$sha1Hash32 = 'F314B8C89A4974D1060F2524E7489081EE359628'
$url64 = 'http://download.microsoft.com/download/2/8/3/283DE38A-5164-49DB-9883-9D1CC432174D/MessageAnalyzer64.msi'
$sha1Hash64 = '62875FF451F13B10A8FF988F2943E76A4735D3D4'

Install-ChocolateyPackage 'microsoft-message-analyzer' 'msi' '/quiet' $url32 $url64 -checksumType 'sha1' -checksum64 $sha1Hash64 -checksum $sha1Hash32
