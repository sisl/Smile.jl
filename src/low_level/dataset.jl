export
		add_float_var,
		discretize,
		discretize_with_info,
		get_float,
		get_int,
		get_number_of_records,
		get_number_of_variables,
		is_discrete,
		is_missing,
		read_file,
		remove_var,
		learn_bayesian_search!,
		learn_dynamic_bayesian_network,
		learn_greedy_thick_thinning,
		set_variable_info,
		set_number_of_records,
		set_float,
		set_id,
		set_state_names,
		write_file,
		get_discrete,
		get_id,
		get_missing_int,
		get_missing_float,
		get_state_names
export DSL_DISCRETIZE_HIERARCHICAL, DSL_DISCRETIZE_UNIFORMWIDTH, DSL_DISCRETIZE_UNIFORMCOUNT

# --------------

const DSL_DISCRETIZE_HIERARCHICAL = unsafe_load(cglobal((:EDSL_DISCRETIZE_HIERARCHICAL, LIB_SMILE), Int32))
const DSL_DISCRETIZE_UNIFORMWIDTH = unsafe_load(cglobal((:EDSL_DISCRETIZE_UNIFORMWIDTH, LIB_SMILE), Int32))
const DSL_DISCRETIZE_UNIFORMCOUNT = unsafe_load(cglobal((:EDSL_DISCRETIZE_UNIFORMCOUNT, LIB_SMILE), Int32))

# --------------

function add_float_var( dset::Dataset, varName::String )
	
	ccall( (:dataset_addFloatVar, LIB_SMILE), Void, (Ptr{Void},Ptr{Uint8}), dset.ptr, bytestring(varName) )
end

function discretize{T<:Real}( dset::Dataset, var::Integer, nBins::Integer, statePrefix::String, edges::Vector{T}=Float64[] )
	@assert( nBins > 1 )
	if isempty(edges)
		ccall( (:dataset_discretize, LIB_SMILE), Void, (Ptr{Void},Int32,Int32,Ptr{Uint8}), dset.ptr, var, nBins, bytestring(statePrefix) )
	else
		@assert(length(edges) == nBins + 1)
		ccall( (:dataset_discretize_withedges, LIB_SMILE), Void, 
			(Ptr{Void},Int32,Int32,Ptr{Uint8},Ptr{Float64}), 
			dset.ptr, var, nBins, bytestring(statePrefix), edges )
	end
end

function discretize_with_info( dset::Dataset, var::Integer, nBins::Integer, statePrefix::String )
	binEdges = Array(Float64, nBins-1)
	nActualBins = ccall( (:dataset_discretize_getedges, LIB_SMILE), Uint32, (Ptr{Void},Int32,Int32,Ptr{Uint8},Ptr{Float64}), dset.ptr, var, nBins, bytestring(statePrefix), binEdges )
	binEdges = binEdges[1:nActualBins]
	return binEdges
end

function get_float( dset::Dataset, var::Integer, rec::Integer )
	@assert( !is_discrete(dset, var) )
	retval = ccall( (:dataset_getFloat, LIB_SMILE), Float32, (Ptr{Void},Int32,Int32), dset.ptr, var, rec )
	return retval
end

function get_int( dset::Dataset, var::Integer, rec::Integer )
	@assert( is_discrete(dset, var) )
	retval = ccall( (:dataset_getInt, LIB_SMILE), Int32, (Ptr{Void},Int32,Int32), dset.ptr, var, rec )
	return retval
end

function get_number_of_records( dset::Dataset )
	retval = ccall( (:dataset_getNumberOfRecords, LIB_SMILE), Int32, (Ptr{Void},), dset.ptr )
	return retval
end

function get_number_of_variables( dset::Dataset )
	retval = ccall( (:dataset_getNumberOfVariables, LIB_SMILE), Int32, (Ptr{Void},), dset.ptr )
	return retval
end

function is_discrete( dset::Dataset, var::Integer )
	retval = ccall( (:dataset_isDiscrete, LIB_SMILE), Bool, (Ptr{Void},Int32), dset.ptr, var )
	return retval
end

function is_missing( dset::Dataset, var::Integer, rec::Integer )
	retval = ccall( (:dataset_isMissing, LIB_SMILE), Bool, (Ptr{Void},Int32,Int32), dset.ptr, var, rec )
	return retval
end

function learn_bayesian_search!( dset::Dataset, net::Network;
    maxparents=5, maxsearchtime=0, niterations=20,
    linkprobability=0.1, priorlinkprobability=0.001,
    priorsamplesize=50, seed=0, forced_arcs=Array(Tuple,0),
    forbidden_arcs=Array(Tuple,0), tiers=Array(Tuple,0) )

	# maxparents: limits the maximum number of parents a node can have
	# maxsearchtime: the maximum runtime of the algorithm (0 = infinite)
	# niterations: sets the number of searches (and indirectly number of random restarts)
	# linkprobability: used by random network generator that generates the starting nets
	#                  defines the probabilty of having an arc between two nodes
	# priorlinkprobability: defines a prior existence of an arc between two nodes
	#                       the prior probability is used for all possible arcs
	#                       setting a low probability will create a prior bias towards
	#                       finding more sparse networks
	# priorsamplesize: influences the "strength" of prior link probability. Bigger values
	#                  increase the influence of the prior
	#                  most noticeable with smaller data sets
	# seed:            random seed used for generating random starting points (0 = use system time)
	# forced_arcs: a list of (i->j) arcs which are forbidden in the network

	nforcedarcs = length(forced_arcs)
	forcedarcs_arr = zeros(Int32, 2*nforcedarcs)
	for i = 1 : length(forced_arcs)
		forcedarcs_arr[2*i-1]  = forced_arcs[i][1]
		forcedarcs_arr[2*i] = forced_arcs[i][2]
	end

	nforbiddenarcs = length(forbidden_arcs)
	forbiddenarcs_arr = zeros(Int32, 2*nforbiddenarcs)
	for i = 1 : length(forbidden_arcs)
		forbiddenarcs_arr[2*i-1] = forbidden_arcs[i][1]
		forbiddenarcs_arr[2*i] = forbidden_arcs[i][2]
	end

	lentiers = length(tiers)
	tiers_arr = zeros(Int32, 2*lentiers)
	for i = 1 : length(tiers)
		tiers_arr[2*i-1] = tiers[i][1]
		tiers_arr[2*i] = tiers[i][2]
	end

	retval = ccall( (:dataset_learnBayesianSearch, LIB_SMILE), Bool, 
		(Ptr{Void},Ptr{Void},Int32,Int32,Int32,Float64,Float64,Int32,Int32,
			Ptr{Int32},Int32,Ptr{Int32},Int32,Ptr{Int32},Int32), 
		dset.ptr, net.ptr, maxparents, maxsearchtime, niterations, linkprobability,
		priorlinkprobability, priorsamplesize, seed, forcedarcs_arr, nforcedarcs,
		forbiddenarcs_arr, nforbiddenarcs, tiers_arr, lentiers )
	if ( !retval )
		warn("Dataset::learn_bayesian_search: did not work")
	end
	return retval # true on success
end

function learn_dynamic_bayesian_network( dset::Dataset, net::Network; 
	                 maxparents=5, maxsearchtime=0, niterations=20,
	                 linkprobability=0.1, priorlinkprobability=0.001,
	                 priorsamplesize=50, seed=0 )

	# maxparents: limits the maximum number of parents a node can have
	# maxsearchtime: the maximum runtime of the algorithm (0 = infinite)
	# niterations: sets the number of searches (and indirectly number of random restarts)
	# linkprobability: used by random network generator that generates the starting nets
	#                  defines the probabilty of having an arc between two nodes
	# priorlinkprobability: defines a prior existence of an arc between two nodes
	#                       the prior probability is used for all possible arcs
	#                       setting a low probability will create a prior bias towards
	#                       finding more sparse networks
	# priorsamplesize: influences the "strength" of prior link probability. Bigger values
	#                  increase the influence of the prior
	#                  most noticeable with smaller data sets
	# seed:            random seed used for generating random starting points (0 = use system time)

	retval = ccall( (:dataset_learnDBN, LIB_SMILE), Bool, 
		(Ptr{Void},Ptr{Void},Int32,Int32,Int32,Float64,Float64,Int32,Int32), 
		dset.ptr, net.ptr, maxparents, maxsearchtime, niterations, linkprobability,
		priorlinkprobability, priorsamplesize, seed )
	if ( !retval )
		warn("Dataset::learn_dynamic_bayesian_network: did not work")
	end
	return retval
end

function learn_greedy_thick_thinning( dset::Dataset, net::Network )
	retval = ccall( (:dataset_learnGreedyThickThinning, LIB_SMILE), Bool, (Ptr{Void},Ptr{Void}), dset.ptr, net.ptr )
	return retval # true on success
end

function remove_var( dset::Dataset, var::Integer )

	retval = ccall( (:dataset_removeVar, LIB_SMILE), Void, (Ptr{Void},Int32), dset.ptr, var )
end

function read_file( dset::Dataset, filename::String )
	retval = ccall( (:dataset_readFile, LIB_SMILE), Int32, (Ptr{Void},Ptr{Uint8}), dset.ptr, bytestring(filename) )
	return retval == 0 # true if success
end

function set_variable_info( dset::Dataset, dsetvi::DatasetVarInfo, index::Integer )
	
	ccall( (:dataset_getVariableInfo, LIB_SMILE), Void, (Ptr{Void},Ptr{Void},Uint32), dset.ptr, dsetvi.ptr, index )
end

function set_number_of_records( dset::Dataset, nRecords::Integer )
	
	ccall( (:dataset_setNumberOfRecords, LIB_SMILE), Void, (Ptr{Void},Int32), dset.ptr, nRecords )
end

function set_float( dset::Dataset, variableIndex::Integer, recordIndex::Integer, value::FloatingPoint )

	ccall( (:dataset_setFloat, LIB_SMILE), Void, (Ptr{Void},Int32,Int32,Float32), dset.ptr, variableIndex, recordIndex, value )
end

function set_id( dset::Dataset, var::Integer, newId::String )

	retval = ccall( (:dataset_setId, LIB_SMILE), Int32, (Ptr{Void},Int32,Ptr{Uint8}), dset.ptr, var, bytestring(newId) )
	return retval
end

function set_state_names( dset::Dataset, var::Integer, newNames::Array{ASCIIString,1} )
	retval = ccall( (:dataset_setStateNames, LIB_SMILE), Bool, (Ptr{Void},Int32,Ptr{Ptr{Uint8}},Uint32), dset.ptr, var, newNames, length(newNames) )
	if retval
		warn("Dataset::set_state_names did not work")
	end
	return retval
end

function write_file( dset::Dataset, filename::String )
	retval = ccall( (:dataset_writeFile, LIB_SMILE), Int32, (Ptr{Void},Ptr{Uint8}), dset.ptr, bytestring(filename) )
	return retval == 0 # true if success
end



# DatasetVarInfo - a struct within DSL_dataset
##############################################

function get_discrete( dsetvi::DatasetVarInfo )
	retval = ccall( (:datasetvarinfo_getDiscrete, LIB_SMILE), Bool, (Ptr{Void},), dsetvi.ptr )
	return retval
end

function get_id( dsetvi::DatasetVarInfo )
	id_buf = Array(Uint8, 128)
	ccall( (:datasetvarinfo_getId, LIB_SMILE), Void, (Ptr{Void},Ptr{Uint8}), dsetvi.ptr, id_buf )
	return bytestring(convert(Ptr{Uint8}, id_buf))
end

function get_missing_int( dsetvi::DatasetVarInfo )
	retval = ccall( (:datasetvarinfo_getMissingInt, LIB_SMILE), Int32, (Ptr{Void},), dsetvi.ptr )
	return retval
end

function get_missing_float( dsetvi::DatasetVarInfo )
	retval = ccall( (:datasetvarinfo_getMissingFloat, LIB_SMILE), Float32, (Ptr{Void},), dsetvi.ptr )
	return retval
end

function get_state_names( dsetvi::DatasetVarInfo )
	# NOTE: this uses Hierarchical. It is possible to modify sislsmile to use uniformwidth and uniformcount

	size = ccall( (:datasetvarinfo_getStateNamesSize, LIB_SMILE), Uint32, (Ptr{Void},), dsetvi.ptr )

	names = Array(String, size)
	for i = 1 : size
		str_buf = Array(Uint8, 128)
		worked = ccall( (:datasetvarinfo_getStateNameAt, LIB_SMILE), Bool, (Ptr{Void},Ptr{Uint8},Uint32), dsetvi.ptr, str_buf, i-1 )
		if worked
			names[i] = bytestring(convert(Ptr{Uint8}, str_buf))
		else
			error(bytestring(convert(Ptr{Uint8}, str_buf)))
		end
	end

	return names
end

# DatasetParseParams - a struct within DSL_dataset
##################################################
function getindex( pp::DatasetParseParams, entry::Symbol )
	if entry == :missingValueToken
		str_buf = Array(Uint8, 128)
		ccall( (:datasetparseparams_getMissingValueToken, LIB_SMILE), Void, (Ptr{Void},Ptr{Uint8}), pp.ptr, str_buf )
		return bytestring(convert(Ptr{Uint8}, str_buf))
	elseif entry == :missingInt
		return ccall( (:datasetparseparams_getMissingInt, LIB_SMILE), Int32, (Ptr{Void},), pp.ptr )
	elseif entry == :missingFloat
		return ccall( (:datasetparseparams_getMissingFloat, LIB_SMILE), Float32, (Ptr{Void},), pp.ptr )
	elseif entry == :columnIdsPresent
		return ccall( (:datasetparseparams_getColumnIdsPresent, LIB_SMILE), Bool, (Ptr{Void},), pp.ptr )
	end	
	error("Index not found")
end
function setindex!( pp::DatasetParseParams, value, entry::Symbol)
	if entry == :missingValueToken
		@assert(isa(value, String))
		ccall( (:datasetparseparams_setMissingValueToken, LIB_SMILE), Void, (Ptr{Void},Ptr{Uint8}), pp.ptr, bytestring(value) )
	elseif entry == :missingInt
		return ccall( (:datasetparseparams_setMissingInt, LIB_SMILE), Void, (Ptr{Void},Int32), pp.ptr, value )
	elseif entry == :missingFloat
		return ccall( (:datasetparseparams_setMissingFloat, LIB_SMILE), Void, (Ptr{Void},Float32), pp.ptr, value )
	elseif entry == :columnIdsPresent
		return ccall( (:datasetparseparams_setColumnIdsPresent, LIB_SMILE), Void, (Ptr{Void},Bool), pp.ptr, value )
	else
		error("Index not found")
	end
end