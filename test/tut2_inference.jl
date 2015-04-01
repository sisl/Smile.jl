# This test follows the tutorial at:
# https://dslpitt.org/genie/wiki/SMILE_Tutorial_Code_2:_Performing_Inference_with_a_Bayesian_Network

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
set_unchecked_value(thecoordinates, 0.6)

# use clustering algorith
set_default_BN_algorithm(net, DSL_ALG_BN_LAURITZEN)
 
    
# suppose we want to compute P("Forecast" = Moderate)
# update the network
update_beliefs(net)

# get the result value

# DSL_sysCoordinates theCoordinates(*theNet.GetNode(forecast)->Value());
# DSL_idArray *theNames;
# theNames = theNet.GetNode(forecast)->Definition()->GetOutcomesNames();  
# int moderateIndex = theNames->FindPosition("Moderate"); // should be 1
# theCoordinates[0] = moderateIndex;
# theCoordinates.GoToCurrentPosition();

# // get P("Forecast" = Moderate)
# double P_ForecastIsModerate = theCoordinates.UncheckedValue();
# printf("P(\"Forecast\" = Moderate) = %f\n",P_ForecastIsModerate);

thecoordinates = SysCoordinates(value(get_node(net, forecast)))
thenames = get_outcome_names(definition(get_node(net, forecast)))
moderateIndex = find_position(thenames, "Moderate")
@assert(moderateIndex == 1)

thecoordinates[0] = moderateIndex
go_to_current_position(thecoordinates)
    
# get P("Forecast" = Moderate)
P_ForecastIsModerate = unchecked_value(thecoordinates)
@printf("P(\"Forecast\" = Moderate) = %f\n", P_ForecastIsModerate)
@assert(isapprox(P_ForecastIsModerate, 0.32))

# now we want to compute P("Success" = Failure | "Forecast" = Good)
# first, introduce the evidence
# 0 is the index of state [Good]

set_evidence(value(get_node(net, forecast)), 0)
 
# update the network again
update_beliefs(net)
    
    
# get the result value
link_to(thecoordinates, value(get_node(net, success)))
thecoordinates[0] = 1 # 1 is the index of state [Failure]
go_to_current_position(thecoordinates)
P_SuccIsFailGivenForeIsGood = unchecked_value(thecoordinates)
@printf("P(\"Success\" = Failure | \"Forecast\" = Good) = ")
@printf("%f\n",P_SuccIsFailGivenForeIsGood)
@assert(isapprox(P_SuccIsFailGivenForeIsGood, 0.5))

# now we want to compute P("Success" = Success | "Forecast" = Poor)
# first, clear the evidence in node "Forecast"
clear_evidence(value(get_node(net, forecast)))
    
# introduce the evidence in node "Success"
# 2 is the index of state [Poor]
set_evidence(value(get_node(net, forecast)), 2)
    
# update the network again
update_beliefs(net)
    
# get the result value
link_to(thecoordinates, value(get_node(net, success)))
thecoordinates[0] = 0 # 0 is the index of state [Success]
go_to_current_position(thecoordinates)
P_SuccIsSuccGivenForeIsPoor = unchecked_value(thecoordinates)
@printf("P(\"Success\" = Success | \"Forecast\" = Poor) = ")
@printf("%f\n", P_SuccIsSuccGivenForeIsPoor)
@assert(abs(P_SuccIsSuccGivenForeIsPoor - 0.0769) < 1e-2)
