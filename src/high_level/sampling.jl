
export 
        normalize!,
        draw_from_p_vec,
        get_cpt_probability_vec_noevidence,
        condition_on_beliefs!
       


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

function get_cpt_probability_vec_noevidence(net::Network, nodeid::Cint, assignment::Dict{Cint,Cint})

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
    for i = 1 : nPa
        coordinates[i-1] = assignment[parents[i]]
    end

    cpt = get_matrix(nodedef)::DMatrix
    coordinates[nPa] = 0
    ind = coordinates_to_index(cpt, coordinates)
    retval = Array(Float64, n)
    for i = 1 : n        
        retval[i] = get_at(cpt, ind)
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

function Base.rand(net::Network)

    # returns a Dict{Cint, Cint} of NodeIndex -> Value

    assignment = Dict{Cint, Cint}()
    ordering = to_native_int_array(partial_ordering(net)::IntArray)
    for nodeid in ordering
        p = normalize!(get_cpt_probability_vec_noevidence(net, nodeid, assignment))
        assignment[nodeid] = draw_from_p_vec(p)
    end
    assignment
end

function Base.rand!(net::Network, assignment::Dict{Cint, Cint})

    ordering = to_native_int_array(partial_ordering(net)::IntArray)
    ordering = [int32(0),int32(1)]

    set_default_BN_algorithm(net, DSL_ALG_BN_LAURITZEN)

    for nodeid in ordering
        if !haskey(assignment, nodeid)
            
            condition_on_beliefs!(net, assignment)

            nodeval = value(get_node(net, nodeid))
            thecoordinates = SysCoordinates(nodeval)
            nstates = get_size(nodeval)
            println("nstates: ", nstates)

            thecoordinates[0] = 0
            go_to_current_position(thecoordinates)

            p = Array(Float64, nstates)
            for i = 1 : nstates
                p[i] = unchecked_value(thecoordinates)
                if i != nstates
                    next(thecoordinates)
                end
            end
            normalize!(p)
            println("p: ", p)

            newstate = draw_from_p_vec(p)
            println("newstate: ", newstate)
            assignment[nodeid] = newstate
        end
    end
    assignment
end

# logpdf(net, assignment) (marginal probability)