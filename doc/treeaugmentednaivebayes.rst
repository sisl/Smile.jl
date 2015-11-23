Tree Augmented Naive Bayes
==========================

This learning algorithm creates a `Tree Augmented Naive Bayes`_ (TAN) graph structure in which a single class variable have no parents and all other variables have the class as a parent and at most one other attribute as a parent.

The probability tables are filled out using Expectation Maximization.

.. _`Tree Augmented Naive Bayes`: https://dslpitt.org/genie/wiki/Reference_Manual:_DSL_tan

.. image:: https://raw.githubusercontent.com/sisl/Smile.jl/master/doc/TAN.png



Parameters
----------

**classvar**: the variable id corresponding to the class variable, ``String``

**maxSearchTime**: the maximum runtime for the algorithm, milliseconds, ``Cint``

**seed**: the random seed to use, 0 for time-based random seed, ``UInt32``

**maxcache**: the maximum cache size, ``Uint64``

.. code-block:: julia

	LearnParams_TreeAugmentedNaiveBayes() = new("class", 0, 0, 2048)
	LearnParams_TreeAugmentedNaiveBayes(class) = new(class, 0, 0, 2048)

Examples
--------

.. code-block:: julia

	net = Network()
	learn!( net, dset, LearnParams_TreeAugmentedNaiveBayes())

Algorithm
---------

The TAN algorithm is :math:`O(n^2 \text{log} n)`, where *n* is the number of graph vertices:

1. Compute the mutual information between each pair of attributes

2. Build a complete undirected graph in which the vertices are the attributes *n* variables. The edges are weighted according to the pairwise mutual information

3. Build a maximum weighted spanning tree

4. Transform the resulting undirected graph to a directed graph by selecting the class variable as the root node and seeting the direction of all edges outward from it

5. Construct a TAN model by adding an arc from the class variable to all other variables

Reference
---------

The Decision Systems Laboratory recommends the following reference:

	Friedman, N., Geiger, D., & Goldszmidt, M. (1997). Bayesian network classifiers. *Machine learning*, 29(2), 131-163.