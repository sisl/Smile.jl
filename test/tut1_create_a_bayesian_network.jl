# This test follows the tutorial at:
# https://dslpitt.org/genie/wiki/SMILE_Tutorial_1:_Creating_a_Bayesian_Network

using Smile

# create a net
net = Network()

# add a success node
success = add_node(net, DSL_CPT, "Success")
somenames = IdArray()
add(somenames, "Success")
add(somenames, "Failure")
set_number_of_outcomes(definition(get_node(net, success)), somenames)

# add a forecast node
forecast = add_node(net, DSL_CPT, "Forecast")
flush(somenames)
add(somenames, "Good")
add(somenames, "Moderate")
add(somenames, "Poor")
set_number_of_outcomes(definition(get_node(net, forecast)), somenames)

# add an arc from "Success" to "Forecast" to represent conditional independence
add_arc(net, success, forecast)

# add the distributions
theprobs = DoubleArray()
set_size(theprobs, 2)
set_at(theprobs, 0, 0.2)
set_at(theprobs, 1, 0.8)
set_definition(definition(get_node(net, success)), theprobs)

thecoordinates = SysCoordinates(definition(get_node(net, forecast)))
set_unchecked_value(thecoordinates, 0.4); next(thecoordinates)
set_unchecked_value(thecoordinates, 0.4); next(thecoordinates)
set_unchecked_value(thecoordinates, 0.2); next(thecoordinates)
set_unchecked_value(thecoordinates, 0.1); next(thecoordinates)
set_unchecked_value(thecoordinates, 0.3); next(thecoordinates)
set_unchecked_value(thecoordinates, 0.6);

# write to file
filename = tempname() * ".xdsl"
write_file(net, filename)
@test isfile(filename)
rm(filename)

filename = tempname() * ".dsl"
write_file(net, filename)
@test isfile(filename)
rm(filename)