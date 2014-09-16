using BinDeps
@BinDeps.setup

version = "0.1.0"
url = "http://dl.bintray.com/tawheeler/generic/libsmilejl.so/libsmilejl.so"

libdep = library_dependency("libsmilejl")
provides(Binaries, URI(url), libdep)

@BinDeps.install