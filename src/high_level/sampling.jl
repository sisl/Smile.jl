
export
        normalize!,
        draw_from_p_vec,
        get_marginal_probability_vec,
        get_cpt_probability_vec,
        condition_on_beliefs!,
        monte_carlo_probability_estimate,
        does_assignment_match_evidence,
        rejection_sample,
        probability,
        probabilities,
        logprob,
        marginal_probability,
        marginal_logprob


# export logpdf

function normalize!(p::Vector{Float64})
    tot = sum(p)
    if !isapprox(tot, 1.0)
        if !isapprox(tot, 0.0)
            p ./= tot
        else
            fill!(p, 1/length(p))
        end
    end
    p
end
function draw_from_p_vec(p::Vector{Float64})
    # this assumes p is weighted so sum(p) == 1
    # returns an index starting at 0

    n = length(p)
    i = 1
    c = p[1]
    u = rand()
    while c < u && i < n
        c += p[i += 1]
    end
    return i-1
end

function get_marginal_probability_vec(net::Network, nodeid::Cint, evidence::Dict{Cint, Cint}=Dict{Cint,Cint}())

    #=
    Returns the probabilty vector [P_nodeid=0, P_nodeid=1, ...]::Vector{Float64}
    Assumes no parental assignment
    =#

    condition_on_beliefs!(net, evidence)

    node    = get_node(net, nodeid)
    nodedef = definition(node)
    nodeval = value(node)
    coord = SysCoordinates(nodeval)
    n = get_number_of_outcomes(nodedef)

    retval = Array(Float64, n)
    for i = 1 : n
        coord[0] = i-1
        go_to_current_position(coord)
        retval[i] = unchecked_value(coord)
    end

    retval
end
function get_cpt_probability_vec(net::Network, nodeid::Cint, parental_assignment::Dict{Cint,Cint})

    #=
    Returns the probabilty vector [P_nodeid=0, P_nodeid=1, ...]::Vector{Float64}
    Only works if assignment contains the parental assignments
    =#

    nodedef = definition(get_node(net, nodeid))
    @assert(get_type(nodedef) == DSL_CPT)
    n = get_number_of_outcomes(nodedef)

    parents = get_parents(net, nodeid)
    nPa = length(parents)

    coordinates = IntArray(nPa+1)
    for i in 1 : nPa
        coordinates[i-1] = parental_assignment[parents[i]]
    end

    cpt = get_matrix(nodedef)::DMatrix
    coordinates[nPa] = 0
    ind = coordinates_to_index(cpt, coordinates)
    retval = Array(Float64, n)
    for i in 1 : n
        retval[i] = cpt[ind]
        ind += 1
    end

    retval
end

function condition_on_beliefs!(net::Network, assignment::Dict{Cint, Cint})

    clear_all_evidence(net)

    for (nodeid, state) in assignment
        set_evidence(value(get_node(net, nodeid)), state)
    end

    update_beliefs(net)
    net
end

function Base.rand{I<:Integer}(net::Network;
    ordering::Vector{I} = to_native_int_array(partial_ordering(net)::IntArray)
    )

    # returns a Dict{Cint, Cint} of NodeIndex -> Value

    assignment = Dict{Cint, Cint}()
    for nodeid in ordering
        p = normalize!(get_cpt_probability_vec(net, Int32(nodeid), assignment))
        assignment[nodeid] = draw_from_p_vec(p)
    end
    assignment
end

function Base.rand!{I<:Integer}(net::Network, assignment::Dict{Cint, Cint};
    ordering::Vector{I} = to_native_int_array(partial_ordering(net)::IntArray)
    )

    condition_on_beliefs!(net, assignment)

    for nodeid in ordering
        if !haskey(assignment, nodeid)

            nodeval = value(get_node(net, nodeid))
            thecoordinates = SysCoordinates(nodeval)
            nstates = get_size(nodeval)

            thecoordinates[0] = 0
            go_to_current_position(thecoordinates)

            p = Array(Float64, nstates)
            for i in 1 : nstates
                p[i] = unchecked_value(thecoordinates)
                if i != nstates
                    next(thecoordinates)
                end
            end
            normalize!(p)

            newstate = draw_from_p_vec(p)
            assignment[nodeid] = newstate
            set_evidence(value(get_node(net, nodeid)), newstate)
            update_beliefs(net)
        end
    end
    assignment
end

function probability{I<:Integer}(net, assignment::Dict{Cint, Cint};
    ordering::Vector{I} = to_native_int_array(partial_ordering(net)::IntArray)
    )
    # P(assignment)

    retval = 1.0

    clear_all_evidence(net)
    update_beliefs(net)

    for nodeid in ordering
        if haskey(assignment, nodeid)
            val = assignment[nodeid]
            nodeval = value(get_node(net, nodeid))
            thecoordinates = SysCoordinates(nodeval)
            thecoordinates[0] = val
            go_to_current_position(thecoordinates)
            retval *= unchecked_value(thecoordinates) # NOTE(tim): this assumes it has been normalized

            if isapprox(retval, 0.0)
                return 0.0
            end

            set_evidence(value(get_node(net, nodeid)), val)
            update_beliefs(net)
        end
    end

    retval
end
function probabilities{I<:Integer}(net, assignment::Dict{Cint, Cint}, evidence::Dict{Cint, Cint}=Dict{Cint,Cint}();
    ordering::Vector{I} = to_native_int_array(partial_ordering(net)::IntArray),
    )
    # P(assignment)

    retval = Dict{Cint, Float64}()

    if !isempty(evidence)
        @assert(!issubset(evidence, assignment))
        condition_on_beliefs!(net, evidence)
    else
        clear_all_evidence(net)
        update_beliefs(net)
    end


    for nodeid in ordering
        if haskey(assignment, nodeid)
            val = assignment[nodeid]
            nodeval = value(get_node(net, nodeid))
            thecoordinates = SysCoordinates(nodeval)
            thecoordinates[0] = val
            go_to_current_position(thecoordinates)
            retval[nodeid] = unchecked_value(thecoordinates) # NOTE(tim): this assumes it has been normalized

            set_evidence(nodeval, val)
            update_beliefs(net)
        end
    end

    retval
end
function logprob{I<:Integer}(net, assignment::Dict{Cint, Cint};
    ordering::Vector{I} = to_native_int_array(partial_ordering(net)::IntArray)
    )
    # P(assignment)

    retval = 0.0

    clear_all_evidence(net)
    update_beliefs(net)

    for nodeid in ordering
        if haskey(assignment, nodeid)
            val = assignment[nodeid]
            nodeval = value(get_node(net, nodeid))
            thecoordinates = SysCoordinates(nodeval)
            thecoordinates[0] = val
            go_to_current_position(thecoordinates)
            retval += log(unchecked_value(thecoordinates)) # NOTE(tim): this assumes it has been normalized

            if isinf(retval)
                return -Inf
            end

            set_evidence(nodeval, val)
            update_beliefs(net)
        end
    end

    retval
end


function marginal_probability(net, target::Dict{Cint, Cint}, evidence::Dict{Cint, Cint}=Dict{Cint,Cint}())
    # P(target ∣ evidence)

    retval = 1.0

    condition_on_beliefs!(net, evidence)

    for (nodeid, val) in target
        nodeval = value(get_node(net, nodeid))
        thecoordinates = SysCoordinates(nodeval)
        nstates = get_size(nodeval)
        thecoordinates[0] = val
        go_to_current_position(thecoordinates)
        retval *= unchecked_value(thecoordinates) # NOTE(tim): this assumes it has been normalized
        if isapprox(retval, 0.0)
            break
        end
    end

    retval
end
function marginal_logprob(net, target::Dict{Cint, Cint}, evidence::Dict{Cint, Cint}=Dict{Cint,Cint}())
    # P(target ∣ evidence)

    retval = 0.0

    condition_on_beliefs!(net, evidence)

    for (nodeid, val) in target
        nodeval = value(get_node(net, nodeid))
        thecoordinates = SysCoordinates(nodeval)
        nstates = get_size(nodeval)
        thecoordinates[0] = val
        go_to_current_position(thecoordinates)
        retval += log(unchecked_value(thecoordinates)) # NOTE(tim): this assumes it has been normalized
        if isinf(retval)
            break
        end
    end

    retval
end

function does_assignment_match_evidence(assignment::Dict{Cint, Cint}, evidence::Dict{Cint, Cint})
    for (k,v) in evidence
        if assignment[k] != v
            return false
        end
    end
    return true
end

function rejection_sample(net::Network, evidence::Dict{Cint, Cint})
    assignment = rand(net)
    while !does_assignment_match_evidence(assignment, evidence)
        assignment = rand(net)
    end
    assignment
end

function monte_carlo_probability_estimate(net::Network, evidence::Dict{Cint, Cint}, nsamples::Integer)

    @assert(nsamples > 0)

    counts = 0

    for i = 1 : nsamples
        assignment = rand(net)
        counts += does_assignment_match_evidence(assignment, evidence)
    end

    counts / nsamples
end
function monte_carlo_probability_estimate(net::Network, target::Dict{Cint,Cint}, evidence::Dict{Cint, Cint}, nsamples::Integer)

    @assert(nsamples > 0)

    counts_evidence = 0
    counts_target   = 0

    for i = 1 : nsamples
        assignment = rand(net)
        if does_assignment_match_evidence(assignment, evidence)
            counts_evidence += 1
            counts_target += does_assignment_match_evidence(assignment, target)
        end
    end

    counts_target / counts_evidence
end
