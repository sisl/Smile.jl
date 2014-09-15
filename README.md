Smile
=====
##### Julia Structural Modeling, Inference, and Learning Engine

A Julia wrapper for the **[Smile C++ Structural Modeling, Inference, and Learning Engine]**. This grants access to a wide variety of graphical decision-theoretical methods, such as Bayesian Networks and influence diagrams. 

[Smile C++ Structural Modeling, Inference, and Learning Engine]: https://dslpitt.org/genie/

The library has only been tested on Ubuntu-Linux.

## Documentation

Library documentation is available **[here]**.

[here]: http://smile.readthedocs.org/


## Installation

Smile can be installed through the Julia package manager (version 0.3 required)

```julia
julia> Pkg.clone("Smile")
```

Instructions are available **[here]** for those who wish to compile the C++ wrapper themselves.

[here]: http://smile.readthedocs.org/installation

## Credit

The Decision Systems Laboratory asks that all publications of research in which SMILE is used contain an explicit acknowledgement to that effect. A simple example is: "The models described in this paper were created using the
SMILE reasoning engine for graphical probabilisitc models developed by the Decision Systems Laboratory at the University of Pittsburgh and available at http://genie.sis.pitt.edu/."