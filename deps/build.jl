using BinDeps
@BinDeps.setup

deps = [
	libsmilejl = library_dependency("smilejl", aliases=["libsmilejl", "libsmilejl.so.1.0", "libsmilejl.so.1", "libsmilejl.so"], os=:Unix)
]

@BinDeps.if_install begin

provides(Binaries, {URI("http://dl.bintray.com/tawheeler/generic/libsmilejl.so/libsmilejl.so") => deps}, os = :Unix)


@BinDeps.install