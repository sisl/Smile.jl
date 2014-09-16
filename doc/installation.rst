Installation
============

The wrapper library for Smile comes pre-built and is installed automatically when Smile is added through the Julia package manager:

.. code-block:: julia

	Pkg.add("Smile")

Advanced
--------

SMILE is a C++ project for which headers and static libraries are freely distributed. It is recommended that users download a copy of the latest version of SMILE_ for their operating system.

-- _SMILE: https://dslpitt.org/genie/

Software for the C++ wrapper is located in /src/wrapper/. If you installed this package through the Julia package manager it will be in ~/.julia/Smile/src/wrapper/.

Extract the downloaded files in the same directory as the wrapper code. Rename the extracted folder to "lib". Copy libsmile.a and libsmilearn.a into the wrapper folder. The filestructure should now be:

	========================= =========================
	libsmile.a                Smile core static library
	libsmilearn.a             Smilearn static library
	smile_wrapper.cpp         Cpp wrapper source file
	smile_wrapper.hpp         Cpp wrapper header file
	smile_compile.sh          Compilation bash script
	lib/                      Smile Cpp compiled source
	========================= =========================

Run the bash script:

.. code-block:: bash

	$ bash -x ./smile_compile.sh

This will produce smile_wrapper.o and libsmilejl.so.1.0. All that is left to do is place it on your library search path and perform the linking.

Move the file and perform linking: 

.. code-block:: bash

	$ sudo mv libsmilejl.so.1.0 /usr/lib
	$ sudo ln -sf /usr/lib/libsmilejl.so.1.0 /usr/lib/libsmilejl.so.1
	$ sudo ln -sf /usr/lib/libsmilejl.so.1.0 /usr/lib/libsmilejl.so

Restart the terminal to ensure libsmilejl is found before using Smile.jl