# Smile Tutorial 1: Creating a Bayesian Network
# this is the Julia version for the tutorial at 
# https://dslpitt.org/genie/wiki/SMILE_Tutorial_1:_Creating_a_Bayesian_Network

using Smile

net = Network()
success = add_node(net, DSL_CPT, "success")
forecast = add_node(net, DSL_CPT, "forecast")

nodeA = get_node(net, success)
nodeDefA = definition(nodeA)
nodeValA = value(nodeA)

somenames = IdArray()
add(somenames, "Success")
add(somenames, "Failure")
set_number_of_outcomes( nodeDefA, somenames )

flush(somenames)
add(somenames, "Good")
add(somenames, "Moderate")
add(somenames, "Poor")
set_number_of_outcomes( definition(get_node(net, forecast)), somenames )

add_arc(net, success, forecast)

theprobs = DoubleArray()
set_size(theprobs, 2)
set_at(theprobs, 0, 0.2)
set_at(theprobs, 1, 1.8)
set_definition(definition(get_node(net, success)), theprobs)

thecoordinates = SysCoordinates(definition(get_node(net, forecast)))

write_file(net, "output.xdsl")