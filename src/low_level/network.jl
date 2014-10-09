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
		write_file

function add_arc( net::Network, theParent::Integer, theChild::Integer )
	err_int = ccall( (:network_AddArc, "libsmilejl"), Int32, (Ptr{Void}, Int32, Int32), net.ptr, theParent, theChild)
	if err_int < 0
		error( "network_AddArc: code: ", err_int )
	end
end

function add_node( net::Network, nodeType::Integer, nodeName::String )

	if !is_nodetype_id(nodeType)
		error( "network_AddNode: nodeType not a recognized type" )
	end

	error_buffer = Array(Uint8, 128)
	nodeId = ccall( (:network_AddNode, "libsmilejl"), Int32, (Ptr{Void}, Int32, Ptr{Uint8}, Ptr{Uint8}), net.ptr, nodeType, bytestring(nodeName), error_buffer )
	if nodeId < 0
		error_str = bytestring(error_buffer)
		error( "network_AddNode: ", error_str )
	end
	return nodeId
end

function get_all_nodes( net::Network )

	n = get_number_of_nodes(net)
	if n == 0
		return []
	end

	nodeHandles = Array(Integer,n)
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
	ccall( (:network_GetChildren, "libsmilejl"), Void, (Ptr{Void},Int32,Ptr{Int32},Ptr{Uint32}), net.ptr, ofThisNode, arr, len )
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
	retval = ccall( (:network_GetFirstNode, "libsmilejl"), Int32, (Ptr{Void},), net.ptr )
	return retval
end

function get_next_node( net::Network, ofThisNode::Integer )
	retval = ccall( (:network_GetNextNode, "libsmilejl"), Int32, (Ptr{Void},Int32), net.ptr, ofThisNode )
	return retval
end

function get_node( net::Network, nodeHandle::Integer )
	ptr = ccall( (:network_GetNode, "libsmilejl"), Ptr{Void}, (Ptr{Void},Int32), net.ptr, nodeHandle )
	return Node(ptr)
end

function get_number_of_nodes( net::Network )
	retval = ccall( (:network_GetNumberOfNodes, "libsmilejl"), Int32, (Ptr{Void},), net.ptr )
	return retval
end

function get_parents( net::Network, ofThisNode::Integer, len_start = 10 )
	len = Array(Uint32,1)
	len[1] = len_start
	arr = Array(Int32, len_start)
	ccall( (:network_GetParents, "libsmilejl"), Void, (Ptr{Void},Int32,Ptr{Int32},Ptr{Uint32}), net.ptr, ofThisNode, arr, len )
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
	retval = ccall( (:network_IsAcyclic, "libsmilejl"), Int32, (Ptr{Void},), net.ptr )
	return retval != 0 # true if non zero
end

function read_file( net::Network, fileName::String )
	# TODO: check that fileName ends with a valid file type
	retval = ccall( (:network_ReadFile, "libsmilejl"), Int32, (Ptr{Void},Ptr{Uint8}), net.ptr, bytestring(fileName) )
	return retval
end

function write_file( net::Network, fileName::String )
	ext = splitext(fileName)[2]
	@assert(ext == ".dsl" || ext == ".xdsl")

	retval = ccall( (:network_WriteFile, "libsmilejl"), Int32, (Ptr{Void},Ptr{Uint8}), net.ptr, bytestring(fileName) )
	return retval
end