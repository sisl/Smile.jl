PC
==

This learning algorithm uses the PC_ procedure. It is a general-purpose graph structure learning algorithm, meaning it will attempt to search the full space of graphs for the best graph.

The probability tables are filled out using Expectation Maximization.

.. _PC: https://dslpitt.org/genie/wiki/Reference_Manual:_DSL_pc

.. image:: https://raw.githubusercontent.com/sisl/Smile.jl/master/doc/bayesiansearch.png


Parameters
----------

.. code-block:: julia

    type LearnParams_PC
        maxcache      :: Uint64 # the maximum algorithm cache size
        maxAdjacency  :: Cint   # thought to be the max number of parents
        maxSearchTime :: Cint   # the maximum runtime of the algorithm, ms
        significance  :: Float64 # the significance level used in independence tests
        forced_arcs    :: Vector{Tuple}  # a list of (i->j) arcs which are forced to be in the network
        forbidden_arcs :: Vector{Tuple}  # a list of (i->j) arcs which are forbidden in the network
        tiers          :: Vector{Tuple}  # a list of (i->tier) associating nodes with a particular tier

        LearnParams_PC() = new(2048, 8, 0, 0.05, Tuple[], Tuple[], Tuple[])
    end

Examples
--------

.. code-block:: julia

    net = Network()
    learn!( net, dset, LearnParams_PC())

Algorithm
---------

* Start with a complete undirected graph on all *n* variables, with edges between all nodes

* For each pair of variables *X* and *Y*, and each set of other variables *S*, see if X and Y are conditionally indepdendent given S. If so, remove the edge between X and Y

* Find colliders by checking for conditional dependence; orient the edges of colliders

* Try to orient undirected edges by consistency with already-oriented edges; do this recursively until no more edges can be oriented

Reference
---------

Spirtes, P. and Glymour, C. and Scheines, R. (2001). *Causation, Prediction, and Search*.