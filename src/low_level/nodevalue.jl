export
		get_matrix,
		get_size

function get_matrix( nodeval::NodeValue )
	ptr = ccall( (:nodevalue_GetMatrix, LIB_SMILE), Ptr{Void}, (Ptr{Void},), nodeval.ptr )
	return DMatrix(ptr)
end

function get_size( nodeval::NodeValue )
	retval = ccall( (:nodevalue_GetSize, LIB_SMILE), Int32, (Ptr{Void},), nodeval.ptr )
	return retval
end