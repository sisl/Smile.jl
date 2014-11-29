Bayesian Search
===============

This learning algorithm uses the `Bayesian Search`_ procedure. It is a general-purpose graph structure learning algorithm, meaning it will attempt to search the full space of graphs for the best graph.

The probability tables are filled out using Expectation Maximization.

The algorithm runs a partially directed graph search over Markov equivalence classes instead of directly searching the space of DAGs (which is superexponential in *n*). 

.. _`Bayesian Search`: https://dslpitt.org/genie/wiki/Reference_Manual:_DSL_bs

.. image:: https://raw.githubusercontent.com/sisl/Smile.jl/master/doc/bayesiansearch.png


Parameters
----------

.. code-block:: julia

    type LearnParams_BayesianSearch
        maxparents           :: Int            # limits the maximum number of parents a node can have
        maxsearchtime        :: Int            # maximum runtime of the algorithm [seconds?] (0 = infinite)
        niterations          :: Int            # number of searches (and indirectly number of random restarts)
        linkprobability      :: Float64        # defines the probabilty of having an arc between two nodes
        priorlinkprobability :: Float64        # defines a prior existence of an arc between two nodes
        priorsamplesize      :: Int            # influences the "strength" of prior link probability.
        seed                 :: Int            # random seed (0=none)
        forced_arcs          :: Vector{Tuple}  # a list of (i->j) arcs which are forced to be in the network
        forbidden_arcs       :: Vector{Tuple}  # a list of (i->j) arcs which are forbidden in the network
        tiers                :: Vector{Tuple}  # a list of (i->tier) associating nodes with a particular tier

        LearnParams_BayesianSearch() = new(5, 0, 20, 0.1, 0.001, 50, 0, Array(Tuple,0), Array(Tuple,0), Array(Tuple,0))
    end

Examples
--------

.. code-block:: julia

    net = Network()
    learn!( net, dset, LearnParams_BayesianSearch())

Algorithm
---------

Bayesian Search is not a specific algorithm, but a class of algorithms. Thus, what exactly is going on under the hood in SMILE is not known. However, the following is true about partially directed graph search and surmised to be true about Bayesian Search.

A Markov Equivalence class is a graph candidate containing both directed and undirected edges. A directed acyclic graph *G* is a member of the Markov equivalence class encoded by a particually directed graph *G'* iff *G* has the same edges as *G'* without regard to direction and has the same v-structures as *G'*. It follows that the space of marov equivalence classes is smaller.

Two graphs are *Markov equivalent* if they encode the same set of conditional independent assumptions. A Markov Equivalence class is thus a set containing all directed acyclic graphs that are Markov equivalent to each other.

In structure search we would like to maximize the posterior probability of the structure given the data, :math:`\arg\max_G P(G|D)`. An equivalent formulation seeks to maximize the *Bayesian Score*.

In general, two structures belonging to the same Markov equivalence class may be given different scores. However, specific priors, such as the *BDeu* prior, can be used to ensure score equivalence.

Greedy Hill Climbing
~~~~~~~~~~~~~~~~~~~~

Searching over the space of graphs typically runs as follows:

1. Start with a random intial graph

2. Search for the next-best graph reachable by applying one of each of the following operations:

    - Adding a new undirected or directed edge

    - Removing an existing edge

    - Reversing an existing directed edge

    - Converting :math:`A - B - C` to :math:`A\rightarrow B \leftarrow C`

3. Each candidate graph is scored. The Bayesian Score is defined only for directed acyclic graphs, so a member of the Markov equivalence graph must be generated from which the score is computed

4. The graph with the highest score is selected, and the process is continued until a local maxima is reached

Reference
---------

Kochenderfer, M. (2014). *Decision Making under Uncertainty*, 47-55.