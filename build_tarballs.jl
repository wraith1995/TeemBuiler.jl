# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "teem"
version = v"0.0.0"

# Collection of sources required to build teem
sources = [
    "https://downloads.sourceforge.net/project/teem/teem/1.11.0/teem-1.11.0-src.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fteem%2Ffiles%2Fteem%2F1.11.0%2Fteem-1.11.0-src.tar.gz%2Fdownload%3Fuse_mirror%3Dcfhcable%26download%3D&ts=1565376769" =>
    "a01386021dfa802b3e7b4defced2f3c8235860d500c1fa2f347483775d4c8def",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
mv teem-1.11.0-src.tar.gz\?r\=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fteem%2Ffiles%2Fteem%2F1.11.0%2Fteem-1.11.0-src.tar.gz%2Fdownload%3Fuse_mirror%3Dcfhcable%26download%3D\&ts\=1565376769 teem.tar.gz
tar -xvf teem.tar.gz 
mkdir teem-build
cd teem-build/
cmake ../teem-1.11.0-src/
cmake  -DBUILD_SHARED_LIBS=True -DCMAKE_INSTALL_PREFIX=/workspace/destdir ../teem-1.11.0-src/
make
make install


if [ $target = "x86_64-apple-darwin14" ]; then
cd $WORKSPACE/srcdir
cd teem-build
cmake ../teem-1.11.0-src/
cmake  -DBUILD_SHARED_LIBS=True -DCMAKE_INSTALL_PREFIX=/workspace/destdir ../teem-1.11.0-src/
make
make install
fi

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc),
    Linux(:i686, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libteem", :libteem)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

