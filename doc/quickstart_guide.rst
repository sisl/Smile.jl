QuickStart Guide
================

This tutorial will cover some basic steps in creating a Bayesian network. It closely mimics the first smile tutorial_.

.. _tutorial: https://dslpitt.org/genie/wiki/SMILE_Tutorial_1:_Creating_a_Bayesian_Network

We start by declaring an instance of a network.

.. code-block:: Julia

	net = Network()

Now we are going to create a node called Success. The node will represent a random discrete event (CPT = Conditional Probability Table).

.. code-block:: Julia

	success = add_node(net, DSL_CPT, "Success")
	somenames = IdArray()
	add(somenames, "Sucess")
	add(somenames, "Failure")
	set_number_of_outcomes(definition(get_node(net, success)), somenames)

Here we create the node, obtained a node handle, and then proceed to give it two states. We can similary create a second node with three states.

.. code-block:: Julia

	forecast = add_node(net, DSL_CPT, "Forecast")
	flush(somenames)
	add(somenames, "Good")
	add(somenames, "Moderate")
	add(somenames, "Poor")
	set_number_of_outcomes(definition(get_node(net, forecast)), somenames)

Notice that the syntax used closely follows what is defined in SMILE.

Next we add an arc from "Success" to "Forecast" to represent the conditional dependencies of the latter on the former:

.. code-block:: Julia

	add_arc(net, success, forecast)

Note that handles of the nodes are required to do this.

Next we fill in the probability distribution using the Smile.jl equivalent of the DSL_doubleArray.

.. code-block:: Julia

	theprobs = DoubleArray()
	set_size(theprobs, 2)
	set_at(theprobs, 0, 0.2)
	set_at(theprobs, 1, 0.8)
	set_definition(definition(get_node(net, success)), theprobs)

Specifying the 2x3 probability table for the second node is done as follows:

.. code-block:: Julia

	thecoordinates = SysCoordinates(definition(get_node(net, forecast)))
	set_unchecked_value(thecoordinates, 0.4); next(thecoordinates)
	set_unchecked_value(thecoordinates, 0.4); next(thecoordinates)
	set_unchecked_value(thecoordinates, 0.2); next(thecoordinates)
	set_unchecked_value(thecoordinates, 0.1); next(thecoordinates)
	set_unchecked_value(thecoordinates, 0.3); next(thecoordinates)
	set_unchecked_value(thecoordinates, 0.6);

Note that there was no checking. This is for speed reasons, and how the SMILE tutorial was written.

We end by writing the network to a file, either as a ".dsl" or ".xdsl".

.. code-block:: Julia

	write_file(net, "mynet.xdsl")