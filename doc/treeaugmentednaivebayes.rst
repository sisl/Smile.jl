Tree Augmented Naive Bayes
==========================

This learning algorithm creates a `Tree Augmented Naive Bayes`_ (TAN) graph structure in which a single class variable have no parents and all other variables have the class as a parent and at most one other attribute as a parent.

The probability tables are filled out using Expectation Maximization.

.. _`Tree Augmented Naive Bayes`: https://dslpitt.org/genie/wiki/Reference_Manual:_DSL_tan

.. image:: https://raw.githubusercontent.com/sisl/Smile.jl/master/doc/TAN.png



Parameters
----------

**classVariableId**: the variable id corresponding to the class variable

.. code-block:: julia

	LearnParams_NaiveBayes() = new("class")
	LearnParams_NaiveBayes(var::String) = new(var)

Examples
--------

.. code-block:: julia

	net = Network()
	learn!( net, dset, LearnParams_NaiveBayes())

Algorithm
---------

The TAN algorithm is :math:`O(n^2 \log n)`, where *n* is the number of graph vertices:

1. Compute the mutual information between each pair of attributes

2. Build a complete undirected graph in which the vertices are the attributes :math:`A_1,\ldots,A_n`. The edges are weighted according to the pairwise mutual information

3. Build a maximum weighted spanning tree

4. Transform the resulting undirected graph to a directed graph by selecting the class variable as the root node and seeting the direction of all edges outward from it

5. Construct a TAN model by adding an arc from the class variable to all other variables