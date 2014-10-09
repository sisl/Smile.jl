export
		discretize,
		get_nodetype_id,
		is_nodetype_id,
		DSL_CPT,
		DSL_TRUTHTABLE,
		DSL_LIST,
		DSL_NOISY_MAX,
		DSL_TABLE,
		DSL_MAU

function discretize{T<:Real}( data::Array{T,1}, nBins::Integer  )

	binedges = Array(Float64, nBins+1)
	discretized = Array(Int32, length(data))

	ccall( (:discretize, LIB_SMILE), Void, 
	 	(Ptr{Float32}, Uint32, Int32, Ptr{Float64}, Ptr{Int32}), 
	 	float32(data), length(data), nBins, binedges, discretized )
	
	return (discretized, binedges)
end

function get_nodetype_id( typeName::String )
	retval = ccall( (:getNodeTypeID, LIB_SMILE), Int32, (Ptr{Uint8},), bytestring(typeName) )
	if retval == -1
		error( "getNodeTypeID: node type not recognized: ", typeName )
	end
	return retval
end

function is_nodetype_id( typeID::Integer )
	return typeID == DSL_CPT  || typeID == DSL_TRUTHTABLE ||
	       typeID == DSL_LIST || typeID == DSL_NOISY_MAX  ||
	       typeID == DSL_MAU  || typeID == DSL_TABLE
end

# notetype ids
const DSL_CPT        = get_nodetype_id("DSL_CPT")
const DSL_TRUTHTABLE = get_nodetype_id("DSL_TRUTHTABLE")
const DSL_LIST       = get_nodetype_id("DSL_LIST")
const DSL_NOISY_MAX  = get_nodetype_id("DSL_NOISY_MAX")
const DSL_TABLE      = get_nodetype_id("DSL_TABLE")
const DSL_MAU        = get_nodetype_id("DSL_MAU")