# using BinDeps
# @BinDeps.setup

# libsmilejl = library_dependency("libsmilejl.so", os=:Unix)

# provides(Binaries,
# 	URI("http://dl.bintray.com/tawheeler/generic/libsmilejl.so/libsmilejl.so"),
# 	libsmilejl, os=:Unix, unpacked_dir="libsmilejl")

# @BinDeps.install [:libsmilejl => :libsmilejl]


downloads = joinpath(dirname(@__FILE__), "downloads")
println(downloads)

if !isdir(downloads)
	mkdir(downloads)
end

destfile = joinpath(downloads, "libsmilejl.so")
println(destfile)

download("https://bintray.com/artifact/download/tawheeler/generic/generic/libsmilejl.so", destfile)
