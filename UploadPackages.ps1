$ErrorActionPreference = 'Stop'

function PackageViFm() {
    cpack vifm\vifm.nuspec
    cpush (ls vifm*.nupkg)
}

pushd $PSScriptRoot
try {
    PackageViFm 
}
finally {
popd
}
