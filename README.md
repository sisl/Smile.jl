Smile
=====
##### Julia Structural Modeling, Inference, and Learning Engine

A Julia wrapper for the **[Smile C++ Structural Modeling, Inference, and Learning Engine]**. This grants access to a wide variety of graphical decision-theoretical methods, such as Bayesian Networks and influence diagrams. 

[Smile C++ Structural Modeling, Inference, and Learning Engine]: https://dslpitt.org/genie/

[![Build Status](https://travis-ci.org/sisl/Smile.jl.svg?branch=master)](https://travis-ci.org/sisl/Smile.jl)
[![Coverage Status](https://coveralls.io/repos/sisl/Smile.jl/badge.svg)](https://coveralls.io/r/sisl/Smile.jl)
[![Documentation Status](https://readthedocs.org/projects/smile/badge/?version=latest)](https://readthedocs.org/projects/smile/?badge=latest)

# End of Life

Smile.jl is no longer needed as of Julia 0.5. Julians can use the [Cxx](https://github.com/Keno/Cxx.jl) library to call the Smile C++ .so files directly. There is also the [BayesNets](https://github.com/sisl/BayesNets.jl) package which provides native Julia implementations.

## Documentation

Library documentation is available **[here]**.

[here]: http://smile.readthedocs.org/


## Installation

Smile can be installed through the Julia package manager (version 0.3 required)

```julia
julia> Pkg.add("Smile")
```

Instructions are available **[as well]** for those who wish to compile the C++ wrapper themselves.

[as well]: http://smile.readthedocs.org/en/latest/installation.html

## Credit

The Decision Systems Laboratory asks that all publications of research in which SMILE is used contain an explicit acknowledgement to that effect. A simple example is: "The models described in this paper were created using the
SMILE reasoning engine for graphical probabilisitc models developed by the Decision Systems Laboratory at the University of Pittsburgh and available at http://genie.sis.pitt.edu/."
