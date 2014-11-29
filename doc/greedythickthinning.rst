Greedy Thick Thinning
=====================

This learning algorithm uses the `Greedy Thick Thinning`_ procedure. It is a general-purpose graph structure learning algorithm, meaning it will attempt to search the full space of graphs for the best graph.

The probability tables are filled out using Expectation Maximization.

.. _`Greedy Thick Thinning`: https://dslpitt.org/genie/wiki/Reference_Manual:_DSL_greedyThickThinning

.. image:: https://raw.githubusercontent.com/sisl/Smile.jl/master/doc/bayesiansearch.png


Parameters
----------

.. code-block:: julia

    type LearnParams_GreedyThickThinning
        maxparents           :: Int # limits the maximum number of parents a node can have
        priors               :: Int # either K2 or BDeu
        netWeight            :: Float64 # for BDeu prior it defines the weight for the uniform prior
        forced_arcs          :: Vector{Tuple}  # a list of (i->j) arcs which are forced to be in the network
        forbidden_arcs       :: Vector{Tuple}  # a list of (i->j) arcs which are forbidden in the network
        tiers                :: Vector{Tuple}  # a list of (i->tier) associating nodes with a particular tier
        LearnParams_GreedyThickThinning() = new(5, DSL_K2, 1.0, Tuple[], Tuple[], Tuple[])
    end

Examples
--------

.. code-block:: julia

    net = Network()
    learn!( net, dset, LearnParams_GreedyThickThinning())

Algorithm
---------

The Greedy Thick Thinning algorithm starts with an empty graph and repeatedly adds the next arc which maximizes the Bayesian Score metric until a local maxima is reached. It then removes arcs untils a local maxima is reached.

The algorithm is thus fairly efficient at the expense of being prone to being trapped in local maxima. 

Two priors can be used. The *BDeu* prior ensures equal scoring across Markov equivalance classes. The *K2* prior is constant across all variables and is typically used for maximizing :math:`P(G\mid D)` when searching the space of graphs directly.

Reference
---------

Hesar, A. and Tabatabaee, H. and Jalali, M. (2012). *Structure Learning of Bayesian Networks Using Heuristic Methods*.