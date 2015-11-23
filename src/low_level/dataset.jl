export read_file, write_file
export add_int_var, add_float_var, remove_var, add_empty_record, set_number_of_records, remove_record
export find_variable, get_number_of_records, get_number_of_variables
export get_int, get_float, set_int, set_float, set_missing, get_missing_int, get_missing_float
export is_missing, is_discrete, get_int_data, get_float_data, get_id, set_id
export get_num_states, get_state_names, set_state_names
export has_missing_data, is_constant
export discretize, discretize_with_info
export disc_alg_string
export DSL_DISCRETIZE_HIERARCHICAL, DSL_DISCRETIZE_UNIFORMWIDTH, DSL_DISCRETIZE_UNIFORMCOUNT
export DSL_MISSING_INT, DSL_MISSING_FLOAT

# --------------

const DSL_DISCRETIZE_HIERARCHICAL = unsafe_load(cglobal((:EDSL_DISCRETIZE_HIERARCHICAL, LIB_SMILE), Cint))
const DSL_DISCRETIZE_UNIFORMWIDTH = unsafe_load(cglobal((:EDSL_DISCRETIZE_UNIFORMWIDTH, LIB_SMILE), Cint))
const DSL_DISCRETIZE_UNIFORMCOUNT = unsafe_load(cglobal((:EDSL_DISCRETIZE_UNIFORMCOUNT, LIB_SMILE), Cint))

const DSL_MISSING_INT             = unsafe_load(cglobal((:EDSL_MISSING_INT,             LIB_SMILE), Cint))
const DSL_MISSING_FLOAT           = unsafe_load(cglobal((:EDSL_MISSING_FLOAT,           LIB_SMILE), Cfloat))

# --------------

function read_file( dset::Dataset, filename::AbstractString )
	retval = ccall( (:dataset_readFile, LIB_SMILE), Int32, (Ptr{Void},Ptr{UInt8}), dset.ptr, bytestring(filename) )
	return retval == 0 # true if success
end
function read_file( dset::Dataset, filename::AbstractString, pp::DatasetParseParams )
	retval = ccall( (:dataset_readFile_withparams, LIB_SMILE), Int32, (Ptr{Void},Ptr{UInt8},Ptr{Void}), dset.ptr, bytestring(filename), pp.ptr )
	return retval == 0 # true if success
end
function write_file( dset::Dataset, filename::AbstractString )
	retval = ccall( (:dataset_writeFile, LIB_SMILE), Int32, (Ptr{Void},Ptr{UInt8}), dset.ptr, bytestring(filename) )
	return retval == 0 # true if success
end
function write_file( dset::Dataset, filename::AbstractString, wp::DatasetWriteParams )
	retval = ccall( (:dataset_writeFile_withparams, LIB_SMILE), Int32, (Ptr{Void},Ptr{UInt8},Ptr{Void}), dset.ptr, bytestring(filename), wp.ptr )
	return retval == 0 # true if success
end

function add_int_var( dset::Dataset, id::AbstractString, missingValue::Integer = DSL_MISSING_INT )

	ccall( (:dataset_addIntVar, LIB_SMILE), Cint, (Ptr{Void},Ptr{UInt8},Cint), dset.ptr, bytestring(id), missingValue )
end
function add_float_var( dset::Dataset, varName::AbstractString, missingValue::Cfloat = DSL_MISSING_FLOAT )

	ccall( (:dataset_addFloatVar, LIB_SMILE), Cint, (Ptr{Void},Ptr{UInt8},Cfloat), dset.ptr, bytestring(varName), missingValue )
end
function remove_var( dset::Dataset, var::Integer )

	ccall( (:dataset_removeVar, LIB_SMILE), Void, (Ptr{Void},Int32), dset.ptr, var )
end
function add_empty_record( dset::Dataset )

	ccall( (:dataset_addEmptyRecord, LIB_SMILE), Void, (Ptr{Void},), dset.ptr )
end
function set_number_of_records( dset::Dataset, numRecords::Integer )

	ccall( (:dataset_setNumberOfRecords, LIB_SMILE), Void, (Ptr{Void},Int32), dset.ptr, numRecords )
end
function remove_record( dset::Dataset, rec::Integer )

	ccall( (:dataset_removeRecord, LIB_SMILE), Cint, (Ptr{Void},Cint), dset.ptr, rec )
end

function find_variable( dset::Dataset, id::AbstractString )

	ccall( (:dataset_findVariable, LIB_SMILE), Cint, (Ptr{Void},Ptr{UInt8}), dset.ptr, bytestring(id) )
end
function get_number_of_variables( dset::Dataset )

	ccall( (:dataset_getNumberOfVariables, LIB_SMILE), Cint, (Ptr{Void},), dset.ptr )
end
function get_number_of_records( dset::Dataset )

	ccall( (:dataset_getNumberOfRecords, LIB_SMILE), Cint, (Ptr{Void},), dset.ptr )
end


function get_int( dset::Dataset, var::Integer, rec::Integer )
	@assert( is_discrete(dset, var) )
	ccall( (:dataset_getInt, LIB_SMILE), Cint, (Ptr{Void},Cint,Cint), dset.ptr, var, rec )
end
function get_float( dset::Dataset, var::Integer, rec::Integer )
	@assert( !is_discrete(dset, var) )
	ccall( (:dataset_getFloat, LIB_SMILE), Cfloat, (Ptr{Void},Cint,Cint), dset.ptr, var, rec )
end
function set_int( dset::Dataset, var::Integer, rec::Integer, value::Integer )
	@assert( is_discrete(dset, var) )
	ccall( (:dataset_setInt, LIB_SMILE), Void, (Ptr{Void},Cint,Cint,Cint), dset.ptr, var, rec, value )
end
function set_float( dset::Dataset, var::Integer, rec::Integer, value::AbstractFloat )

	ccall( (:dataset_setFloat, LIB_SMILE), Void, (Ptr{Void},Cint,Cint,Cfloat), dset.ptr, var, rec, value )
end
set_missing( dset::Dataset, var::Integer, rec::Integer ) =
	ccall( (:dataset_setMissing, LIB_SMILE), Void, (Ptr{Void},Cint,Cint), dset.ptr, var, rec )
get_missing_int( dset::Dataset, var::Integer ) =
	ccall( (:dataset_getMissingInt, LIB_SMILE), Cint, (Ptr{Void},Cint), dset.ptr, var )
function get_missing_float( dset::Dataset, var::Integer )

	ccall( (:dataset_getMissingFloat, LIB_SMILE), Cfloat, (Ptr{Void},Cint), dset.ptr, var )
end
function is_missing( dset::Dataset, var::Integer, rec::Integer )

	ccall( (:dataset_isMissing, LIB_SMILE), Bool, (Ptr{Void},Cint,Cint), dset.ptr, var, rec )
end
function is_discrete( dset::Dataset, var::Integer )

	ccall( (:dataset_isDiscrete, LIB_SMILE), Bool, (Ptr{Void},Cint), dset.ptr, var )
end
function get_int_data( dset::Dataset, var::Integer )
	n = get_number_of_records(dset)
	retval = Array(Cint, n)
	ccall( (:dataset_getIntData, LIB_SMILE), Void, (Ptr{Void},Cint,Ptr{Cint}), dset.ptr, var, retval )
	retval
end
function get_float_data( dset::Dataset, var::Integer )
	n = get_number_of_records(dset)
	retval = Array(Cfloat, n)
	ccall( (:dataset_getFloatData, LIB_SMILE), Void, (Ptr{Void},Cint,Ptr{Cfloat}), dset.ptr, var, retval )
	retval
end
function get_id( dset::Dataset, var::Integer )
	str_buf = Array(UInt8, 128)
	ccall( (:dataset_getId, LIB_SMILE), Void, (Ptr{Void},Cint,Ptr{UInt8}), dset.ptr, var, str_buf )
	bytestring(pointer(str_buf))
end
function set_id( dset::Dataset, var::Integer, newId::AbstractString )

	ccall( (:dataset_setId, LIB_SMILE), Cint, (Ptr{Void},Cint,Ptr{UInt8}), dset.ptr, var, bytestring(newId) )
end


function get_num_states( dset::Dataset, var::Integer )

	ccall( (:dataset_getNumStates, LIB_SMILE), Cint, (Ptr{Void},Cint), dset.ptr, var )
end
function get_state_names( dset::Dataset, var::Integer )
	n = get_num_states(dset, var)
	retval = Array(ASCIIString, n)
	ccall( (:dataset_getStateNames, LIB_SMILE), Void, (Ptr{Void},Cint,Ptr{Ptr{UInt8}}), dset.ptr, var, retval )
	retval
end
function set_state_names( dset::Dataset, var::Integer, newNames::Vector{ASCIIString} )
	@assert( length(newNames) == get_num_states(dset, var) )
	ccall( (:dataset_setStateNames, LIB_SMILE), Cint, (Ptr{Void},Cint,Ptr{Ptr{UInt8}}), dset.ptr, var, newNames )
end


function getindex( dset::Dataset, var::Integer, rec::Integer )
	if is_discrete(dset, var)
		return get_int(dset, var, rec)
	else
		return get_float(dset, var, rec)
	end
end
function getindex{I<:Integer}( dset::Dataset, var::Integer, rng::UnitRange{I} )
	if is_discrete(dset, var)
		return map(i->get_int(dset, var, i), rng)
	else
		return map(i->get_float(dset, var, i), rng)
	end
end
function getindex( dset::Dataset, var::Integer )
	m = get_number_of_records(dset)
	if is_discrete(dset, var)
		return map(i->get_int(dset, var, i), 0:(m-1))
	else
		return map(i->get_float(dset, var, i), 0:(m-1))
	end
end
function setindex!( dset::Dataset, val, var::Integer, rec::Integer )
	if is_discrete( dset, var )
		set_int(dset, var, rec, val)
	else
		set_float(dset, var, rec, val)
	end
end
function setindex!{I<:Integer}( dset::Dataset, val::Vector, var::Integer, rng::UnitRange{I} )
	@assert(length(val) == length(rng))
	if is_discrete( dset, var )
		for (i,ind) in enumerate(rng)
			set_int(dset, var, ind, val[i])
		end

	else
		for (i,ind) in enumerate(rng)
			set_float(dset, var, ind, val[i])
		end
	end
end


function has_missing_data( dset::Dataset, var::Integer )

	ccall( (:dataset_hasMissingData, LIB_SMILE), Bool, (Ptr{Void},Int32), dset.ptr, var )
end
function is_constant( dset::Dataset, var::Integer )

	ccall( (:dataset_isConstant, LIB_SMILE), Bool, (Ptr{Void},Int32), dset.ptr, var )
end


function discretize{T<:Real}(
	dset        :: Dataset,
	var         :: Integer,
	nBins       :: Integer;
 	statePrefix :: AbstractString    = "s",
 	edges       :: Vector{T} = Float64[], # seems to require nBins+1 edges but only first nBins-1 edges matter, and edge[0] should be the larger bound of the first bin
 	algorithm   :: Cint      = DSL_DISCRETIZE_HIERARCHICAL
 	)

	@assert( nBins > 1 )
	@assert( algorithm == DSL_DISCRETIZE_HIERARCHICAL || algorithm == DSL_DISCRETIZE_UNIFORMWIDTH || algorithm == DSL_DISCRETIZE_UNIFORMCOUNT )

	if isempty(edges)
		ccall( (:dataset_discretize, LIB_SMILE), Void, (Ptr{Void},Cint,Cint,Ptr{UInt8},Cint), dset.ptr, var, nBins, bytestring(statePrefix), algorithm )
	else
		@assert(length(edges) == nBins+1)
		ccall( (:dataset_discretize_withedges, LIB_SMILE), Void,
			(Ptr{Void},Cint,Cint,Ptr{UInt8},Ptr{Float64}),
			dset.ptr, var, nBins, bytestring(statePrefix), edges )
	end
end
function discretize_with_info(
	dset        :: Dataset,
	var         :: Integer,
	nBins       :: Integer;
	statePrefix :: AbstractString = "s",
	algorithm   :: Cint   = DSL_DISCRETIZE_HIERARCHICAL
	)

	# the edge list contains the boundaries between edges
	# |edges| = nBins-1

	@assert( nBins > 1 )
	@assert( algorithm == DSL_DISCRETIZE_HIERARCHICAL || algorithm == DSL_DISCRETIZE_UNIFORMWIDTH || algorithm == DSL_DISCRETIZE_UNIFORMCOUNT )

	binEdges = Array(Float64, nBins-1)
	nActualBins = ccall( (:dataset_discretize_getedges, LIB_SMILE), UInt32,
		(Ptr{Void},Cint,Cint,Ptr{UInt8},Cint,Ptr{Float64}),
		dset.ptr, var, nBins, bytestring(statePrefix), algorithm, binEdges )
	binEdges[1:nActualBins]
end
function discretize{T<:Real}(
	data  :: Vector{T},
	nBins :: Integer;
	statePrefix :: AbstractString = "s",
	algorithm   :: Cint   = DSL_DISCRETIZE_HIERARCHICAL
	)


	n = length(data)
	@assert(n > 1)

	dset = Dataset()
	add_float_var(dset, "A")
	set_number_of_records(dset, n)
	dset[0,0:n-1] = float32(data)

	minv, maxv = extrema(data)
	binedges = discretize_with_info(dset, 0, nBins, statePrefix=statePrefix, algorithm=algorithm)
	discretized = dset[0,0:n-1]
	(discretized, [minv, binedges, maxv])
end

function disc_alg_string( alg::Cint )
	if alg == DSL_DISCRETIZE_HIERARCHICAL
		return "HIERARCHICAL"
	elseif alg == DSL_DISCRETIZE_UNIFORMWIDTH
		return "UNIFORMWIDTH"
	elseif alg == DSL_DISCRETIZE_UNIFORMCOUNT
		return "UNIFORMCOUNT"
	end
	error("alg not found")
end

# DatasetParseParams - a struct within DSL_dataset
##################################################
function getindex( pp::DatasetParseParams, entry::Symbol )
	if entry == :missingValueToken
		str_buf = Array(UInt8, 128)
		ccall( (:datasetparseparams_getMissingValueToken, LIB_SMILE), Void, (Ptr{Void},Ptr{UInt8}), pp.ptr, str_buf )
		return bytestring(pointer(str_buf))
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
		@assert(isa(value, AbstractString))
		ccall( (:datasetparseparams_setMissingValueToken, LIB_SMILE), Void, (Ptr{Void},Ptr{UInt8}), pp.ptr, bytestring(value) )
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

# DatasetWriteParams - a struct within DSL_dataset
##################################################
function getindex( pp::DatasetWriteParams, entry::Symbol )
	if entry == :missingValueToken
		str_buf = Array(UInt8, 128)
		ccall( (:datasetwriteparams_getMissingValueToken, LIB_SMILE), Void, (Ptr{Void},Ptr{UInt8}), pp.ptr, str_buf )
		return bytestring(pointer(str_buf))
	elseif entry == :columnIdsPresent
		return ccall( (:datasetwriteparams_getColumnIdsPresent, LIB_SMILE), Bool, (Ptr{Void},), pp.ptr )
	elseif entry == :useStateIndices
		return ccall( (:datasetwriteparams_getUseStateIndices, LIB_SMILE), Bool, (Ptr{Void},), pp.ptr )
	elseif entry == :separator
		return Char(ccall( (:datasetwriteparams_getSeparator, LIB_SMILE), UInt8, (Ptr{Void},), pp.ptr ))
	elseif entry == :floatFormat
		str_buf = Array(UInt8, 128)
		ccall( (:datasetwriteparams_getFloatFormat, LIB_SMILE), Void, (Ptr{Void},Ptr{UInt8}), pp.ptr, str_buf )
		return bytestring(pointer(str_buf))
	end
	error("Index not found")
end
function setindex!( pp::DatasetWriteParams, value, entry::Symbol)
	if entry == :missingValueToken
		@assert(isa(value, AbstractString))
		ccall( (:datasetwriteparams_setMissingValueToken, LIB_SMILE), Void, (Ptr{Void},Ptr{UInt8}), pp.ptr, bytestring(value) )
	elseif entry == :columnIdsPresent
		ccall( (:datasetwriteparams_setColumnIdsPresent, LIB_SMILE), Void, (Ptr{Void},Bool), pp.ptr, value )
	elseif entry == :useStateIndices
		ccall( (:datasetwriteparams_setUseStateIndices, LIB_SMILE), Void, (Ptr{Void},Bool), pp.ptr, value )
	elseif entry == :separator
		ccall( (:datasetwriteparams_setSeparator, LIB_SMILE), Void, (Ptr{Void},UInt8), pp.ptr, value )
	elseif entry == :floatFormat
		@assert(isa(value, AbstractString))
		ccall( (:datasetwriteparams_setFloatFormat, LIB_SMILE), Void, (Ptr{Void},Ptr{UInt8}), pp.ptr, bytestring(value) )
	else
		error("Index not found")
	end
end
