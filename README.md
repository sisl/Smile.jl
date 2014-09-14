Smile
=====
##### Julia Structural Modeling, Inference, and Learning Engine

A Julia wrapper for the **[Smile C++ Structural Modeling, Inference, and Learning Engine]**. This grants access to a wide variety of graphical decision-theoretical methods, such as Bayesian Networks and influence diagrams. 

[Smile C++ Structural Modeling, Inference, and Learning Engine]: https://dslpitt.org/genie/

The library has only been tested on Ubuntu-Linux.

## Installation

Smile can be installed through the Julia package manager (version 0.3 required)

```julia
julia> Pkg.add("Smile")
```

In addition, Smile.jl requires the Smile C++ library and the compiled C wrapper.

Download the C++ library from the **[University of Pittsburg Decision Systems Laboratory website]**. You may have to create an account. I use the Unit-like Linux (x64) / gcc 4.4.5 build, but the x84 build has been tested as well.

[University of Pittsburg Decision Systems Laboratory website]: https://dslpitt.org/genie/

The C++ wrapper is located in src/wrapper/. If you installed this package through the Julia package manager it will be in ~/.julia/Smile/src/wrapper/. 

Extract the downloaded files in the same directory as the wrapper code. Rename the extracted folder "lib". Copy libsmile.a and libsmilearn.a into the wrapper folder. The filestructure should now be:

	libsmile.a                Smile core static library
	libsmilearn.a             Smilearn static library
	smile_wrapper.cpp         Cpp wrapper source file
	smile_wrapper.hpp         Cpp wrapper header file
	smile_compile.sh          Compilation bash script
	lib/                      Smile Cpp compiled source

Run the bash script: ```bash -x ./smile_compile.sh```

This will produce smile_wrapper.o and libsmilejl.so.1.0. All that is left to do is place it on your library search path and perform the linking.

Move the file and perform linking: 

	$ sudo mv libsmilejl.so.1.0 /usr/lib
	$ sudo ln -sf /usr/lib/libsmilejl.so.1.0 /usr/lib/libsmilejl.so.1
	$ sudo ln -sf /usr/lib/libsmilejl.so.1.0 /usr/lib/libsmilejl.so

Restart the terminal to ensure libsmilejl is found before using Smile.jl