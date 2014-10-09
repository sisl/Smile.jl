export
		change_type,
		definition,
		get_name,
		handle,
		network,
		set_name,
		value

function change_type( node::Node, newNodeType::Integer )
	if !is_nodetype_id(newNodeType)
		error( "network_AddNode: newNodeType not a recognized type" )
	end

	err_int = ccall( (:node_ChangeType, "libsmilejl"), Int32, (Ptr{Void},Int32), node.ptr, newNodeType )
	if err_int < 0
		error( "node_ChangeType: ", err_int )
	end
end

function definition( node::Node )
	ptr = ccall( (:node_Definition, "libsmilejl"), Ptr{Void}, (Ptr{Void},), node.ptr )
	return NodeDefinition(ptr)
end

function get_name( node::Node )
	retval = Array(Uint8, 128)
	ccall( (:node_GetName, "libsmilejl"), Void, (Ptr{Void}, Ptr{Uint8}), node.ptr, retval )
	bytestring(convert(Ptr{Uint8}, retval))
end

function handle( node::Node )
	retval = ccall( (:node_Handle, "libsmilejl"), Int32, (Ptr{Void},), node.ptr )
	return retval
end

function network( node::Node )
	ptr = ccall( (:node_Network, "libsmilejl"), Ptr{Void}, (Ptr{Void},), node.ptr )
	return Network(ptr)
end

function set_name( node::Node, name::String )
	
	ccall( (:node_SetName, "libsmilejl"), Void, (Ptr{Void}, Ptr{Uint8}), node.ptr, bytestring(name) )
end

function value( node::Node )
	ptr = ccall( (:node_Value, "libsmilejl"), Ptr{Void}, (Ptr{Void},), node.ptr )
	return NodeValue(ptr)
end