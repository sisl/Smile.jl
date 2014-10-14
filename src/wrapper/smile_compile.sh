# RUN THIS TO COMPILE THE LIBRARY "bash -x ./smile_compile.sh"

# compile wrapper
g++ -Wall -fPIC -c smile_wrapper.cpp -L./lib -lsmile
# create shared library
gcc -shared -o libsmilejl.so -Wl,--whole-archive libsmile.a libsmilearn.a -Wl,--no-whole-archive -Wl,-soname,libsmilejl.so.1 -o libsmilejl.so.1.0  smile_wrapper.o
# delete any existing shared library
rm ../../deps/downloads/libsmilejl.so
# move shared library over
mv libsmilejl.so.1.0 ../../deps/downloads/libsmilejl.so
