$url32 = 'http://download.microsoft.com/download/2/8/3/283DE38A-5164-49DB-9883-9D1CC432174D/MessageAnalyzer.msi'
$sha1Hash32 = '290428C4F89533D511A3D6D16A267FE7141945FB'
$url64 = 'http://download.microsoft.com/download/2/8/3/283DE38A-5164-49DB-9883-9D1CC432174D/MessageAnalyzer64.msi'
$sha1Hash64 = '357012E1E5D84CDE3857F5F9C27677A04EE15998'

Install-ChocolateyPackage 'microsoft-message-analyzer' 'msi' '/quiet' $url32 $url64 -checksumType 'sha1' -checksum64 $sha1Hash64 -checksum $sha1Hash32
