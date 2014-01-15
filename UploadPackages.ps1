$ErrorActionPreference = 'Stop'

function PackageViFm() {
    cpack vifm\vifm.nuspec
}

pushd $PSScriptRoot
try {
    PackageViFm 
}
finally {
popd
}