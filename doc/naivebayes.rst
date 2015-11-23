Naive Bayes
===========

This learning algorithm creates a `Naive Bayes`_ graph structure in which a single class variable points to all other variables. The probability tables are filled out using Expectation Maximization.

.. _`Naive Bayes`: https://dslpitt.org/genie/wiki/Reference_Manual:_DSL_bs

.. image:: https://raw.githubusercontent.com/sisl/Smile.jl/master/doc/naive_bayes.png

Parameters
----------

**classVariableId**: the variable id corresponding to the class variable

.. code-block:: julia

	LearnParams_NaiveBayes() = new("class")
	LearnParams_NaiveBayes(var::AbstractString) = new(var)

Examples
--------

.. code-block:: julia

	net = Network()
	learn!( net, dset, LearnParams_NaiveBayes())
	
