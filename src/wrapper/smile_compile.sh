# RUN THIS TO COMPILE THE LIBRARY "bash -x ./smile_compile.sh"

g++ -Wall -fPIC -c smile_wrapper.cpp -L./lib -lsmile
gcc -shared -o libsmilejl.so -Wl,--whole-archive libsmile.a libsmilearn.a -Wl,--no-whole-archive -Wl,-soname,libsmilejl.so.1 -o libsmilejl.so.1.0  smile_wrapper.o


rm ../../deps/downloads/libsmilejl.so
mv libsmilejl.so.1.0 ../../deps/downloads/libsmilejl.so

# sudo rm downloads/libsmilejl*
# sudo mv libsmilejl.so.1.0 /usr/lib/
# sudo ln -sf /usr/lib/libsmilejl.so.1.0 /usr/lib/libsmilejl.so.1
# sudo ln -sf /usr/lib/libsmilejl.so.1.0 /usr/lib/libsmilejl.so