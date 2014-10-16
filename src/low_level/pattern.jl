export get_size, set_size, get_edge, set_edge, has_directed_path, has_cycle
export is_DAG, to_DAG, set, to_network, has_incoming_edge, has_outgoing_edge
export print, get_adjacent_nodes, get_parents, get_children
export DSL_EDGETYPE_NONE, DSL_EDGETYPE_UNDIRECTED, DSL_EDGETYPE_DIRECTED

# ------

const DSL_EDGETYPE_NONE       = unsafe_load(cglobal((:EDSL_EDGETYPE_NONE,       LIB_SMILE), Cint))
const DSL_EDGETYPE_UNDIRECTED = unsafe_load(cglobal((:EDSL_EDGETYPE_UNDIRECTED, LIB_SMILE), Cint))
const DSL_EDGETYPE_DIRECTED   = unsafe_load(cglobal((:EDSL_EDGETYPE_DIRECTED,   LIB_SMILE), Cint))

# ------

get_size( pat::Pattern ) = ccall( (:pattern_getSize, LIB_SMILE), Cint, (Ptr{Void},), pat.ptr )
set_size( pat::Pattern, size::Integer ) = ccall( (:pattern_setSize, LIB_SMILE), Void, (Ptr{Void},Cint), pat.ptr, size )
get_edge( pat::Pattern, from::Integer, to::Integer ) = ccall( (:pattern_getEdge, LIB_SMILE), Cint, (Ptr{Void},Cint,Cint), pat.ptr, from, to )
set_edge( pat::Pattern, from::Integer, to::Integer, edgetype::Cint ) = ccall( (:pattern_setEdge, LIB_SMILE), Void, (Ptr{Void},Cint,Cint,Cint), pat.ptr, from, to, edgetype )
has_directed_path( pat::Pattern, from::Integer, to::Integer ) = ccall( (:pattern_hasDirectedPath, LIB_SMILE), Bool, (Ptr{Void},Cint,Cint), pat.ptr, from, to )
has_cycle( pat::Pattern ) = ccall( (:pattern_hasCycle, LIB_SMILE), Bool, (Ptr{Void},), pat.ptr )
is_DAG( pat::Pattern ) = ccall( (:pattern_isDAG, LIB_SMILE), Bool, (Ptr{Void},), pat.ptr )
to_DAG( pat::Pattern ) = ccall( (:pattern_toDAG, LIB_SMILE), Bool, (Ptr{Void},), pat.ptr )
set( pat::Pattern, net::Network ) = ccall( (:pattern_set, LIB_SMILE), Void, (Ptr{Void},Ptr{Void}), pat.ptr, net.ptr )
to_network( pat::Pattern, dset::Dataset, net::Network ) = ccall( (:pattern_toNetwork, LIB_SMILE), Bool, (Ptr{Void},Ptr{Void},Ptr{Void}), pat.ptr, dset.ptr, net.ptr )
has_incoming_edge( pat::Pattern, to::Integer ) = ccall( (:pattern_hasIncomingEdge, LIB_SMILE), Bool, (Ptr{Void},Cint), pat.ptr, to )
has_outgoing_edge( pat::Pattern, from::Integer ) = ccall( (:pattern_hasOutgoingEdge, LIB_SMILE), Bool, (Ptr{Void},Cint), pat.ptr, from )
print( pat::Pattern ) = ccall( (:pattern_print, LIB_SMILE), Void, (Ptr{Void},), pat.ptr )

function get_adjacent_nodes( pat::Pattern, node::Integer )
	size = get_size(pat)
	arr  = Array(Cint, size)
	len  = ccall( (:pattern_getAdjacentNodes, LIB_SMILE), Cint, (Ptr{Void},Cint,Ptr{Cint}), pat.ptr, node, arr )
	arr[1:len]
end
function get_parents( pat::Pattern, node::Integer )
	size = get_size(pat)
	arr  = Array(Cint, size)
	len  = ccall( (:pattern_getParents, LIB_SMILE), Cint, (Ptr{Void},Cint,Ptr{Cint}), pat.ptr, node, arr )
	arr[1:len]
end
function get_children( pat::Pattern, node::Integer)
	size = get_size(pat)
	arr  = Array(Cint, size)
	len  = ccall( (:pattern_getChildren, LIB_SMILE), Cint, (Ptr{Void},Cint,Ptr{Cint}), pat.ptr, node, arr )
	arr[1:len]
end