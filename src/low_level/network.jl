export
		add_arc,
		add_node,
		get_all_nodes,
		get_children,
		get_first_node,
		get_next_node,
		get_node,
		get_number_of_nodes,
		get_parents,
		is_acyclic,
		read_file,
		write_file,
		set_default_BN_algorithm,
		set_default_ID_algorithm,
		set_default_HBN_algorithm,
		get_default_BN_algorithm,
		get_default_ID_algorithm,
		get_default_HBN_algorithm,
		DSL_ALG_BN_LAURITZEN, DSL_ALG_BN_HENRION, DSL_ALG_BN_PEARL, DSL_ALG_BN_LSAMPLING,
		DSL_ALG_BN_SELFIMPORTANCE, DSL_ALG_BN_HEURISTICIMPORTANCE, DSL_ALG_BN_BACKSAMPLING,
		DSL_ALG_BN_AISSAMPLING, DSL_ALG_BN_EPISSAMPLING, DSL_ALG_BN_LBP, DSL_ALG_BN_LAURITZEN_OLD,
		DSL_ALG_BN_RELEVANCEDECOMP, DSL_ALG_BN_RELEVANCEDECOMP2, DSL_ALG_HBN_HEPI,
		DSL_ALG_HBN_HLW, DSL_ALG_HBN_HLBP, DSL_ALG_HBN_HLOGICSAMPLING,
		update_beliefs,
		invalidate_all_beliefs,
		call_ID_algorithm,
		call_BN_algorithm,
		call_Eq_algorithm,
		call_HBN_algorithm

function add_arc( net::Network, theParent::Integer, theChild::Integer )
	err_int = ccall( (:network_AddArc, LIB_SMILE), Int32, (Ptr{Void}, Int32, Int32), net.ptr, theParent, theChild)
	if err_int < 0
		error( "network_AddArc: code: ", err_int )
	end
end

function add_node( net::Network, nodeType::Integer, nodeName::String )

	if !is_nodetype_id(nodeType)
		error( "network_AddNode: nodeType not a recognized type" )
	end

	error_buffer = Array(Uint8, 128)
	nodeId = ccall( (:network_AddNode, LIB_SMILE), Int32, (Ptr{Void}, Int32, Ptr{Uint8}, Ptr{Uint8}), net.ptr, nodeType, bytestring(nodeName), error_buffer )
	if nodeId < 0
		error_str = bytestring(error_buffer)
		error( "network_AddNode: ", error_str )
	end
	return nodeId
end

function get_all_nodes( net::Network )

	n = get_number_of_nodes(net)
	if n == 0
		return Int[]
	end

	nodeHandles = Array(Int,n)
	nodeHandles[1] = get_first_node( net )
	for i = 2 : n
		nodeHandles[i] = get_next_node( net, nodeHandles[i-1] )
	end

	return nodeHandles
end

function get_children( net::Network, ofThisNode::Integer, len_start = 10 )
	len = Array(Uint32,1)
	len[1] = len_start
	arr = Array(Int32, len_start)
	ccall( (:network_GetChildren, LIB_SMILE), Void, (Ptr{Void},Int32,Ptr{Int32},Ptr{Uint32}), net.ptr, ofThisNode, arr, len )
	len_end = len[1]

	if len_end == 0
		return []
	end
	if len_end > len_start
		error("get_children:: not enough spaces allocated in array")
	end
	return arr[1:len_end]
end

function get_first_node( net::Network )
	retval = ccall( (:network_GetFirstNode, LIB_SMILE), Int32, (Ptr{Void},), net.ptr )
	return retval
end

function get_next_node( net::Network, ofThisNode::Integer )
	retval = ccall( (:network_GetNextNode, LIB_SMILE), Int32, (Ptr{Void},Int32), net.ptr, ofThisNode )
	return retval
end

function get_node( net::Network, nodeHandle::Integer )
	ptr = ccall( (:network_GetNode, LIB_SMILE), Ptr{Void}, (Ptr{Void},Int32), net.ptr, nodeHandle )
	return Node(ptr)
end

function get_number_of_nodes( net::Network )
	retval = ccall( (:network_GetNumberOfNodes, LIB_SMILE), Int32, (Ptr{Void},), net.ptr )
	return retval
end

function get_parents( net::Network, ofThisNode::Integer, len_start = 10 )
	len = Array(Uint32,1)
	len[1] = len_start
	arr = Array(Int32, len_start)
	ccall( (:network_GetParents, LIB_SMILE), Void, (Ptr{Void},Int32,Ptr{Int32},Ptr{Uint32}), net.ptr, ofThisNode, arr, len )
	len_end = len[1]

	if len_end == 0
		return []
	end
	if len_end > len_start
		error("get_parents:: not enough spaces allocated in array")
	end
	return arr[1:len_end]
end

function is_acyclic( net::Network )
	retval = ccall( (:network_IsAcyclic, LIB_SMILE), Int32, (Ptr{Void},), net.ptr )
	return retval != 0 # true if non zero
end

function read_file( net::Network, fileName::String )
	# TODO: check that fileName ends with a valid file type
	retval = ccall( (:network_ReadFile, LIB_SMILE), Int32, (Ptr{Void},Ptr{Uint8}), net.ptr, bytestring(fileName) )
	return retval
end

function write_file( net::Network, fileName::String )
	ext = splitext(fileName)[2]
	@assert(ext == ".dsl" || ext == ".xdsl")

	retval = ccall( (:network_WriteFile, LIB_SMILE), Int32, (Ptr{Void},Ptr{Uint8}), net.ptr, bytestring(fileName) )
	return retval
end

# BN algorithms
const DSL_ALG_BN_LAURITZEN            = int32( 0)
const DSL_ALG_BN_HENRION              = int32( 1)
const DSL_ALG_BN_PEARL                = int32( 2)
const DSL_ALG_BN_LSAMPLING            = int32( 3)
const DSL_ALG_BN_SELFIMPORTANCE       = int32( 4)
const DSL_ALG_BN_HEURISTICIMPORTANCE  = int32( 5)
const DSL_ALG_BN_BACKSAMPLING         = int32( 6)
const DSL_ALG_BN_AISSAMPLING          = int32( 7)
const DSL_ALG_BN_EPISSAMPLING         = int32( 8)
const DSL_ALG_BN_LBP				  = int32( 9)
const DSL_ALG_BN_LAURITZEN_OLD        = int32(10)
const DSL_ALG_BN_RELEVANCEDECOMP      = int32(11)
const DSL_ALG_BN_RELEVANCEDECOMP2     = int32(12)
const DSL_ALG_HBN_HEPIS				  = int32(13)
const DSL_ALG_HBN_HLW                 = int32(14)
const DSL_ALG_HBN_HLBP				  = int32(15)
const DSL_ALG_HBN_HLOGICSAMPLING	  = int32(16)

# ID algorithms
const DSL_ALG_ID_COOPERSOLVING        = int32(0)
const DSL_ALG_ID_SHACHTER             = int32(1)

set_default_BN_algorithm(net::Network,  algorithm::Integer) = ccall( (:network_SetDefaultBNAlgorithm,  LIB_SMILE), Void, (Ptr{Void},Int32), net.ptr, algorithm )
set_default_ID_algorithm(net::Network,  algorithm::Integer) = ccall( (:network_SetDefaultIDAlgorithm,  LIB_SMILE), Void, (Ptr{Void},Int32), net.ptr, algorithm )
set_default_HBN_algorithm(net::Network, algorithm::Integer) = ccall( (:network_SetDefaultHBNAlgorithm, LIB_SMILE), Void, (Ptr{Void},Int32), net.ptr, algorithm )
get_default_BN_algorithm(net::Network)  = ccall( (:network_GetDefaultBNAlgorithm,  LIB_SMILE), Int32, (Ptr{Void},), net.ptr )
get_default_ID_algorithm(net::Network)  = ccall( (:network_GetDefaultIDAlgorithm,  LIB_SMILE), Int32, (Ptr{Void},), net.ptr )
get_default_HBN_algorithm(net::Network) = ccall( (:network_GetDefaultHBNAlgorithm, LIB_SMILE), Int32, (Ptr{Void},), net.ptr )

# Inference
update_beliefs(net::Network)         = ccall( (:network_UpdateBeliefs,        LIB_SMILE), Int32, (Ptr{Void},), net.ptr )
invalidate_all_beliefs(net::Network) = ccall( (:network_InvalidateAllBeliefs, LIB_SMILE), Int32, (Ptr{Void},), net.ptr )
call_ID_algorithm(net::Network)      = ccall( (:network_CallIDAlgorithm,      LIB_SMILE), Int32, (Ptr{Void},), net.ptr )
call_BN_algorithm(net::Network)      = ccall( (:network_CallBNAlgorithm,      LIB_SMILE), Int32, (Ptr{Void},), net.ptr )
call_Eq_algorithm(net::Network)      = ccall( (:network_CallEqAlgorithm,      LIB_SMILE), Int32, (Ptr{Void},), net.ptr )
call_HBN_algorithm(net::Network)     = ccall( (:network_CallHBNAlgorithm,     LIB_SMILE), Int32, (Ptr{Void},), net.ptr )