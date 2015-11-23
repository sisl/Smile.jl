export
		at,
		get_size,
		set_at,
		set_size

function at( dblarr::DoubleArray, index::Integer )

	error_buffer = Array(UInt8, 128)
	retval = ccall( (:doublearray_At, LIB_SMILE), Int32, (Ptr{Void},Int32,Ptr{UInt8}), dblarr.ptr, index, error_buffer )
	error_str = bytestring(error_buffer)
	if startswith(error_str, "error")
		error( "doublearray_At: ", error_str )
	end
	return retval
end

function get_size( dblarr::DoubleArray )

	retval = ccall( (:doublearray_GetSize, LIB_SMILE), Int32, (Ptr{Void},), dblarr.ptr )
	return retval
end

function set_at( dblarr::DoubleArray, index::Integer, value::AbstractFloat )
	# indexing starts at 0

	error_buffer = Array(UInt8, 128)
	ccall( (:doublearray_SetAt, LIB_SMILE), Int32, (Ptr{Void},Int32,Float64,Ptr{UInt8}), dblarr.ptr, index, value, error_buffer )
	error_str = bytestring(error_buffer)
	if startswith(error_str, "error")
		error( "doublearray_At: ", error_str )
	end
end

function set_size( dblarr::DoubleArray, thisSize::Integer )

	err_int = ccall( (:doublearray_SetSize, LIB_SMILE), Int32, (Ptr{Void},Int32), dblarr.ptr, thisSize )
	if err_int < 0
		error( "doublearray_SetSize: ", err_int )
	end
end
