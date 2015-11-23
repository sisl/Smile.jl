export learn, learn!
export arc_requirements_do_not_conflict
export DSL_BayesianSearch,          LearnParams_BayesianSearch
export DSL_GreedyThickThinning,     LearnParams_GreedyThickThinning
export DSL_NaiveBayes,              LearnParams_NaiveBayes
export DSL_PC,                      LearnParams_PC
export DSL_TreeAugmentedNaiveBayes, LearnParams_TreeAugmentedNaiveBayes

# -------

const DSL_K2   = unsafe_load(cglobal((:EDSL_K2,   LIB_SMILE), Cint))
const DSL_BDeu = unsafe_load(cglobal((:EDSL_BDeu, LIB_SMILE), Cint))

# -------

abstract DSL_LearningAlgorithm
type DSL_BayesianSearch          <: DSL_LearningAlgorithm end
type DSL_GreedyThickThinning     <: DSL_LearningAlgorithm end
type DSL_NaiveBayes              <: DSL_LearningAlgorithm end
type DSL_PC                      <: DSL_LearningAlgorithm end
type DSL_TreeAugmentedNaiveBayes <: DSL_LearningAlgorithm end

# -------

abstract DSL_LearnParams
type LearnParams_BayesianSearch <: DSL_LearnParams
		maxparents           :: Int            # limits the maximum number of parents a node can have
		maxsearchtime        :: Int            # maximum runtime of the algorithm [seconds?] (0 = infinite)
		niterations          :: Int            # number of searches (and indirectly number of random restarts)
		linkprobability      :: Float64        # defines the probabilty of having an arc between two nodes
		priorlinkprobability :: Float64        # defines a prior existence of an arc between two nodes
		priorsamplesize      :: Int            # influences the "strength" of prior link probability.
		seed                 :: Int            # random seed (0=none)
		forced_arcs          :: Set{Tuple{Int,Int}} # a list of (i->j) arcs which are forced to be in the network
		forbidden_arcs       :: Set{Tuple{Int,Int}} # a list of (i->j) arcs which are forbidden in the network
		tiers                :: Set{Tuple{Int,Int}} # a list of (i->tier) associating nodes with a particular tier (tier starts at 1, variable starts at 0)

		LearnParams_BayesianSearch() = new(5, 0, 20, 0.1, 0.001, 50, 0, Set{Tuple{Int,Int}}(), Set{Tuple{Int,Int}}(), Set{Tuple{Int,Int}}())
end
type LearnParams_GreedyThickThinning <: DSL_LearnParams
		maxparents           :: Int # limits the maximum number of parents a node can have
		priors               :: Int # either K2 or BDeu
		netWeight            :: Float64
		forced_arcs          :: Set{Tuple{Int,Int}} # a list of (i->j) arcs which are forced to be in the network
		forbidden_arcs       :: Set{Tuple{Int,Int}} # a list of (i->j) arcs which are forbidden in the network
		tiers                :: Set{Tuple{Int,Int}} # a list of (i->tier) associating nodes with a particular tier
		LearnParams_GreedyThickThinning() = new(5, DSL_K2, 1.0, Set{Tuple{Int,Int}}(), Set{Tuple{Int,Int}}(), Set{Tuple{Int,Int}}())
end
type LearnParams_NaiveBayes <: DSL_LearnParams
	classVariableId :: AbstractString # the variable ID of the column that is our class

	LearnParams_NaiveBayes() = new("class")
	LearnParams_NaiveBayes(var::AbstractString) = new(var)
end
type LearnParams_PC <: DSL_LearnParams
	maxcache      :: UInt64
	maxAdjacency  :: Cint
	maxSearchTime :: Cint
	significance  :: Float64
	forced_arcs     :: Set{Tuple{Int,Int}} # a list of (i->j) arcs which are forced to be in the network
		forbidden_arcs  :: Set{Tuple{Int,Int}} # a list of (i->j) arcs which are forbidden in the network
		tiers           :: Set{Tuple{Int,Int}} # a list of (i->tier) associating nodes with a particular tier

	LearnParams_PC() = new(2048, 8, 0, 0.05, Set{Tuple{Int,Int}}(), Set{Tuple{Int,Int}}(), Set{Tuple{Int,Int}}())
end
type LearnParams_TreeAugmentedNaiveBayes <: DSL_LearnParams
	classvar      :: AbstractString # Used to pick the class variable for the network. Is case-sensitive.
	maxSearchTime :: Cint   # maximum runtime for the algorithm
	seed          :: UInt32 # random seed (0 for none)
	maxcache      :: UInt64 # maximum cache size (units?)

	LearnParams_TreeAugmentedNaiveBayes() = new("class", 0, 0, 2048)
	LearnParams_TreeAugmentedNaiveBayes(class) = new(class, 0, 0, 2048)
end

# ------

function learn!( net::Network, dset::Dataset, ::Type{DSL_BayesianSearch},
	params::LearnParams_BayesianSearch = LearnParams_BayesianSearch()
	)

	nforcedarcs,    forcedarcs_arr    = _get_arcs_arr(params.forced_arcs)
	nforbiddenarcs, forbiddenarcs_arr = _get_arcs_arr(params.forbidden_arcs)
	lentiers,       tiers_arr         = _get_arcs_arr(params.tiers)


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
function learn!( net::Network, dset::Dataset, ::Type{DSL_GreedyThickThinning},
	params::LearnParams_GreedyThickThinning = LearnParams_GreedyThickThinning()
	)

	nforcedarcs,    forcedarcs_arr    = _get_arcs_arr(params.forced_arcs)
	nforbiddenarcs, forbiddenarcs_arr = _get_arcs_arr(params.forbidden_arcs)
	lentiers,       tiers_arr         = _get_arcs_arr(params.tiers)

	retval = ccall( (:dataset_learnGreedyThickThinning, LIB_SMILE), Bool,
		(Ptr{Void},Ptr{Void},Int32,Int32,Float64,
			Ptr{Int32},Int32,Ptr{Int32},Int32,Ptr{Int32},Int32),
		dset.ptr, net.ptr, params.priors, params.maxparents,
		params.netWeight, forcedarcs_arr, nforcedarcs,
		forbiddenarcs_arr, nforbiddenarcs, tiers_arr, lentiers )
	if ( !retval )
		warn("Dataset::learn_greedy_thick_thinning: did not work")
	end
	return retval # true on success
end
function learn!( net::Network, dset::Dataset, ::Type{DSL_NaiveBayes},
	params::LearnParams_NaiveBayes = LearnParams_NaiveBayes()
	)

	if find_variable(dset, params.classVariableId) == -1
		warn("class variable $(params.classVariableId) could not be found")
	end

	retval = ccall( (:dataset_learnNaiveBayes, LIB_SMILE), Bool,
		(Ptr{Void},Ptr{Void},Ptr{UInt8}),
		dset.ptr, net.ptr, bytestring(params.classVariableId) )
	if ( !retval )
		warn("Dataset::learn_naive_bayes: did not work")
	end
	return retval # true on success
end
function learn!( net::Network, dset::Dataset, ::Type{DSL_TreeAugmentedNaiveBayes},
	params::LearnParams_TreeAugmentedNaiveBayes = LearnParams_TreeAugmentedNaiveBayes()
	)

	if find_variable(dset, params.classvar) == -1
		warn("class variable $(params.classvar) could not be found")
	end

	retval = ccall( (:dataset_learnTAN, LIB_SMILE), Bool,
		(Ptr{Void},Ptr{Void},Ptr{UInt8}, Cint, UInt32, UInt64),
		dset.ptr, net.ptr, bytestring(params.classvar), params.maxSearchTime, params.seed, params.maxcache )
	if ( !retval )
		warn("Dataset::learn_TAN: did not work")
	end
	return retval # true on success
end
function learn!( net::Network, dset::Dataset, ::Type{DSL_PC},
	params::LearnParams_PC = LearnParams_PC()
	)

	pat = Pattern()
	worked = learn!( pat, dset, DSL_PC, params )
	to_network(pat, dset, net)
	return worked
end
function learn!( pat::Pattern, dset::Dataset, ::Type{DSL_PC},
	params::LearnParams_PC = LearnParams_PC()
	)

	nforcedarcs,    forcedarcs_arr    = _get_arcs_arr(params.forced_arcs)
	nforbiddenarcs, forbiddenarcs_arr = _get_arcs_arr(params.forbidden_arcs)
	lentiers,       tiers_arr         = _get_arcs_arr(params.tiers)

	retval = ccall( (:dataset_learnPC, LIB_SMILE), Bool,
		(Ptr{Void},Ptr{Void},UInt64,Cint,Cint,Float64,
			Ptr{Int32},Int32,Ptr{Int32},Int32,Ptr{Int32},Int32),
		dset.ptr, pat.ptr, params.maxcache, params.maxAdjacency,
		params.maxSearchTime, params.significance,
		forcedarcs_arr, nforcedarcs, forbiddenarcs_arr,
		nforbiddenarcs, tiers_arr, lentiers)
	if ( !retval )
		warn("Dataset::dataset_learnPC: did not work")
	end
	return retval # true on success
end

learn!( net::Network, dset::Dataset, params::LearnParams_BayesianSearch ) =
	learn!(net, dset, DSL_BayesianSearch, params)
learn!( net::Network, dset::Dataset, params::LearnParams_GreedyThickThinning ) =
	learn!(net, dset, DSL_GreedyThickThinning, params)
learn!( net::Network, dset::Dataset, params::LearnParams_NaiveBayes ) =
	learn!(net, dset, DSL_NaiveBayes, params)
learn!( net::Network, dset::Dataset, params::LearnParams_TreeAugmentedNaiveBayes ) =
	learn!(net, dset, DSL_TreeAugmentedNaiveBayes, params)
learn!( net::Network, dset::Dataset, params::LearnParams_PC ) =
	learn!(net, dset, DSL_PC, params)
learn!( pat::Pattern, dset::Dataset, params::LearnParams_PC ) =
	learn!(pat, dset, DSL_PC, params)

function learn{S<:DSL_LearningAlgorithm}( dset::Dataset, alg::Type{S} )
	net = Network()
	worked = learn!(net, dset, alg)
	(net, worked)
end
function learn{S<:DSL_LearnParams}( dset::Dataset, params::S )
	net = Network()
	worked = learn!(net, dset, params)
	(net, worked)
end

# -------

function arc_requirements_do_not_conflict(
	forced_arcs    :: Set{Tuple{Int,Int}},
	forbidden_arcs :: Set{Tuple{Int,Int}}
	)
	# returns true if a forced arc is also a forbidden arc
	for tup in params.forbidden_arcs
		if in(tup, params.forced_arcs)
			return false
		end
	end
	true
end
function arc_requirements_do_not_conflict(
	forced_arcs    :: Set{Tuple{Int,Int}},
	forbidden_arcs :: Set{Tuple{Int,Int}},
	tiers          :: Set{Tuple{Int,Int}},
	)
	# converts tiers to arc requirements before checking conflict
	forced, forbidden = _tiers_to_arc_requirements(tiers)
	union!(forced, forced_arcs)
	union!(forbidden, forbidden_arcs)
	arc_requirements_do_not_conflict(forced, forbidden)
end
arc_requirements_do_not_conflict( params::DSL_BayesianSearch ) =
	arc_requirements_do_not_conflict(params.forced_arcs, params.forbidden_arcs, params.tiers)
arc_requirements_do_not_conflict( params::DSL_GreedyThickThinning ) =
	arc_requirements_do_not_conflict(params.forced_arcs, params.forbidden_arcs, params.tiers)
arc_requirements_do_not_conflict( params::DSL_BayesianSearch ) =
	arc_requirements_do_not_conflict(params.forced_arcs, params.forbidden_arcs, params.tiers)

# -------

function _get_arcs_arr(arcs::Set{Tuple{Int,Int}})
	narcs = length(arcs)
	arr = zeros(Int32, 2*narcs)
	for (i,tup) in enumerate(arcs)
		arr[2*i-1] = tup[1]
		arr[2*i] = tup[2]
	end
	(narcs, arr)
end
function _tiers_to_arc_requirements(
	tiers :: Set{Tuple{Int,Int}} # a list of (i->tier) associating nodes with a particular tier
	)

	# the node starts counting at 0
	# the tier starts counting at 1

	forced_arcs    :: Set{Tuple{Int,Int}}()
	forbidden_arcs :: Set{Tuple{Int,Int}}()

	for (i,tier_i) in tiers
		for (j,tier_j) in tiers
			if tier_i > tier_j
				push!(forbidden_arcs, (i,j))
			elseif tier_j > tier_i
				push!(forbidden_arcs, (j,i))
			end
		end
	end

	(forced_arcs, forbidden_arcs)
end
