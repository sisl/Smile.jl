
# let
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

    test_vec_approx_equal(get_cpt_probability_vec(net, success, Dict{Cint, Cint}()), [0.2, 0.8], 1e-7)
    test_vec_approx_equal(get_cpt_probability_vec(net, forecast, Dict(success=>Int32(0))), [0.4, 0.4, 0.2], 1e-7)
    test_vec_approx_equal(get_cpt_probability_vec(net, forecast, Dict(success=>Int32(1))), [0.1, 0.3, 0.6], 1e-7)

    set_default_BN_algorithm(net, DSL_ALG_BN_LAURITZEN)
    clear_all_evidence(net)
    rand(net)

    evidence = Dict(forecast=>Int32(0)) # forecast is good
    @test( does_assignment_match_evidence(Dict(success=>Int32(0), forecast=>Int32(0)), evidence))
    @test( does_assignment_match_evidence(Dict(success=>Int32(1), forecast=>Int32(0)), evidence))
    @test(!does_assignment_match_evidence(Dict(success=>Int32(0), forecast=>Int32(1)), evidence))


    @test(abs(monte_carlo_probability_estimate(net, evidence, 1000) - 0.16) < 0.1)
    @test(abs(monte_carlo_probability_estimate(net, Dict(success=>Int32(1)), evidence, 100000) - 0.5) < 0.1)

    # println(rand!(net, [forecast=>Int32(2)]))
    # println(rand!(net, [success =>Int32(1)]))

    @test(isapprox(marginal_probability(net, Dict(success=>Int32(0)), Dict(forecast=>Int32(0))), 0.5))
    @test(isapprox(marginal_probability(net, Dict(success=>Int32(1)), Dict(forecast=>Int32(0))), 0.5))
    @test(isapprox(marginal_probability(net, Dict(success=>Int32(0)), Dict(forecast=>Int32(1))), 0.25))
    @test(isapprox(marginal_probability(net, Dict(success=>Int32(1)), Dict(forecast=>Int32(1))), 0.75))
    @test(isapprox(marginal_probability(net, Dict(success=>Int32(0)), Dict(forecast=>Int32(2))), 0.0769, atol=0.001))
    @test(isapprox(marginal_probability(net, Dict(success=>Int32(1)), Dict(forecast=>Int32(2))), 0.9231, atol=0.001))

    @test(isapprox(marginal_probability(net, Dict(forecast=>Int32(0)), Dict(success=>Int32(0))), 0.4))
    @test(isapprox(marginal_probability(net, Dict(forecast=>Int32(1)), Dict(success=>Int32(0))), 0.4))
    @test(isapprox(marginal_probability(net, Dict(forecast=>Int32(2)), Dict(success=>Int32(0))), 0.2))
    @test(isapprox(marginal_probability(net, Dict(forecast=>Int32(0)), Dict(success=>Int32(1))), 0.1))
    @test(isapprox(marginal_probability(net, Dict(forecast=>Int32(1)), Dict(success=>Int32(1))), 0.3))
    @test(isapprox(marginal_probability(net, Dict(forecast=>Int32(2)), Dict(success=>Int32(1))), 0.6))

    @test(isapprox(probability(net, Dict(success=>Int32(0), forecast=>Int32(0))), 0.2*0.4))
    @test(isapprox(probability(net, Dict(success=>Int32(0), forecast=>Int32(1))), 0.2*0.4))
    @test(isapprox(probability(net, Dict(success=>Int32(0), forecast=>Int32(2))), 0.2*0.2))
    @test(isapprox(probability(net, Dict(success=>Int32(1), forecast=>Int32(0))), 0.8*0.1))
    @test(isapprox(probability(net, Dict(success=>Int32(1), forecast=>Int32(1))), 0.8*0.3))
    @test(isapprox(probability(net, Dict(success=>Int32(1), forecast=>Int32(2))), 0.8*0.6))

    @test(isapprox(probability(net, Dict(success=>Int32(0))), 0.2))
    @test(isapprox(probability(net, Dict(success=>Int32(1))), 0.8))

    @test(isapprox(probability(net, Dict(forecast=>Int32(0))), 0.16))
    @test(isapprox(probability(net, Dict(forecast=>Int32(1))), 0.32))
    @test(isapprox(probability(net, Dict(forecast=>Int32(2))), 0.52))

    @test(isapprox(logprob(net, Dict(success=>Int32(0), forecast=>Int32(0))), log(0.2*0.4)))
    @test(isapprox(logprob(net, Dict(success=>Int32(0), forecast=>Int32(1))), log(0.2*0.4)))
    @test(isapprox(logprob(net, Dict(success=>Int32(0), forecast=>Int32(2))), log(0.2*0.2)))
    @test(isapprox(logprob(net, Dict(success=>Int32(1), forecast=>Int32(0))), log(0.8*0.1)))
    @test(isapprox(logprob(net, Dict(success=>Int32(1), forecast=>Int32(1))), log(0.8*0.3)))
    @test(isapprox(logprob(net, Dict(success=>Int32(1), forecast=>Int32(2))), log(0.8*0.6)))

    @test(isapprox(logprob(net, Dict(success=>Int32(0))), log(0.2)))
    @test(isapprox(logprob(net, Dict(success=>Int32(1))), log(0.8)))

    @test(isapprox(logprob(net, Dict(forecast=>Int32(0))), log(0.16)))
    @test(isapprox(logprob(net, Dict(forecast=>Int32(1))), log(0.32)))
    @test(isapprox(logprob(net, Dict(forecast=>Int32(2))), log(0.52)))
# end
