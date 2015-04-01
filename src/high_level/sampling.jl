
export 
        normalize!,
        draw_from_p_vec,
        get_cpt_probability_vec
       


# export logpdf

function normalize!(p::Vector{Float64})
    tot = sum(p)
    if !isapprox(tot, 1.0)
        if !isapprox(tot, 0.0)
            retval ./= tot
        else
            fill!(retval, 1/n)
        end
    end
    p
end
function draw_from_p_vec(p::Vector{Float64})
    # this assumes p is weighted so sum(p) == 1
    n = length(p)
    i = 1
    c = p[1]
    u = rand()
    while c < u && i < n
        c += p[i += 1]
    end
    return i
end

function get_cpt_probability_vec(net::Network, nodeid::Int32, assignment::Dict{Int32,Int32})

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
    retval = Array(Float64, n)
    for i = 1 : n
        coordinates[nPa] = i-1
        ind = coordinates_to_index(cpt, coordinates)
        retval[i] = get_at(cpt, ind)
    end

    retval
end

function Base.rand(net::Network; )

    # returns a Dict{Int32, Int32} of NodeIndex -> Value
    assignment = Dict{Int32, Int32}()
    ordering = partial_ordering(net)::IntArray
    for nodeid in ordering
        p = normalize!(get_p_vec(net, nodeid, assignment))
        assignment[nodeid] = draw_from_p_vec(p)
    end
    assignment
end

# function Base.rand!(net::Network, assignment::Dict{Symbol, Int})



# end

# logpdf(net, assignment) (marginal probability)

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

function monte_carlo_probability_estimate(net::Network, evidence::Dict{Cint, Cint}, nsamples::Int)

    @assert(nsamples > 0)

    counts = 0

    for i = 1 : nsamples
        assignment = rand(net)
        count += does_assignment_match_evidence(assignment, evidence)
    end

    count / nsamples
end