export learn, learn!
export DSL_BayesianSearch, DSL_GreedyThickThinning
export LearnParams_BayesianSearch, LearnParams_GreedyThickThinning

# -------

const DSL_K2   = unsafe_load(cglobal((:EDSL_K2,   LIB_SMILE), Cint))
const DSL_BDeu = unsafe_load(cglobal((:EDSL_BDeu, LIB_SMILE), Cint))

# -------

abstract DSL_LearningAlgorithm
type DSL_BayesianSearch <: DSL_LearningAlgorithm end
type DSL_GreedyThickThinning <: DSL_LearningAlgorithm end

# -------

type LearnParams_BayesianSearch
	maxparents           :: Int            # limits the maximum number of parents a node can have
	maxsearchtime        :: Int            # maximum runtime of the algorithm [seconds?] (0 = infinite)
	niterations          :: Int            # number of searches (and indirectly number of random restarts)
    linkprobability      :: Float64        # defines the probabilty of having an arc between two nodes
    priorlinkprobability :: Float64        # defines a prior existence of an arc between two nodes
    priorsamplesize      :: Int            # influences the "strength" of prior link probability.
    seed                 :: Int            # random seed (0=none)
    forced_arcs          :: Vector{Tuple}  # a list of (i->j) arcs which are forced to be in the network
    forbidden_arcs       :: Vector{Tuple}  # a list of (i->j) arcs which are forbidden in the network
    tiers                :: Vector{Tuple}  # a list of (i->tier) associating nodes with a particular tier

    LearnParams_BayesianSearch() = new(5, 0, 20, 0.1, 0.001, 50, 0, Array(Tuple,0), Array(Tuple,0), Array(Tuple,0))
end
type LearnParams_GreedyThickThinning
	maxparents           :: Int # limits the maximum number of parents a node can have
	priors               :: Int # either K2 or BDeu
	netWeight            :: Float64   
    LearnParams_GreedyThickThinning() = new(5, DSL_K2, 1.0)
end

# ------

function learn!( net::Network, dset::Dataset, ::Type{DSL_BayesianSearch}; 
	params::LearnParams_BayesianSearch = LearnParams_BayesianSearch()
	)

	nforcedarcs = length(params.forced_arcs)
	forcedarcs_arr = zeros(Int32, 2*nforcedarcs)
	for i = 1 : nforcedarcs
		forcedarcs_arr[2*i-1]  = params.forced_arcs[i][1]
		forcedarcs_arr[2*i] = params.forced_arcs[i][2]
	end

	nforbiddenarcs = length(params.forbidden_arcs)
	forbiddenarcs_arr = zeros(Int32, 2*nforbiddenarcs)
	for i = 1 : nforbiddenarcs
		forbiddenarcs_arr[2*i-1] = params.forbidden_arcs[i][1]
		forbiddenarcs_arr[2*i] = params.forbidden_arcs[i][2]
	end

	lentiers = length(params.tiers)
	tiers_arr = zeros(Int32, 2*lentiers)
	for i = 1 : lentiers
		tiers_arr[2*i-1] = params.tiers[i][1]
		tiers_arr[2*i] = params.tiers[i][2]
	end

	retval = ccall( (:dataset_learnBayesianSearch, LIB_SMILE), Bool, 
		(Ptr{Void},Ptr{Void},Int32,Int32,Int32,Float64,Float64,Int32,Int32,
			Ptr{Int32},Int32,Ptr{Int32},Int32,Ptr{Int32},Int32), 
		dset.ptr, net.ptr, params.maxparents, params.maxsearchtime, params.niterations, 
		params.linkprobability, params.priorlinkprobability, params.priorsamplesize, 
		params.seed, forcedarcs_arr, nforcedarcs,
		forbiddenarcs_arr, nforbiddenarcs, tiers_arr, lentiers )
	if ( !retval )
		warn("Dataset::learn_bayesian_search: did not work")
	end
	return retval # true on success
end
function learn!( net::Network, dset::Dataset, ::Type{DSL_GreedyThickThinning}; 
	params::LearnParams_GreedyThickThinning = LearnParams_GreedyThickThinning()
	)

	retval = ccall( (:dataset_learnGreedyThickThinning, LIB_SMILE), Bool, 
		(Ptr{Void},Ptr{Void},Int32,Int32,Float64),
		dset.ptr, net.ptr, params.priors, params.maxparents, params.netWeight )
	if ( !retval )
		warn("Dataset::learn_greedy_thick_thinning: did not work")
	end
	return retval # true on success
end

function learn( dset::Dataset )
	net = Network()
	learn!(net, dset, DSL_BayesianSearch)
	net
end
function learn( dset::Dataset, alg )
	net = Network()
	learn!(net, dset, alg)
	net
end
function learn( dset::Dataset, alg, params )
	net = Network()
	learn!(net, dset, alg, params=params)
	net
end