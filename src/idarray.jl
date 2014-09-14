export
		add,
		flush

function add( idarr::IdArray, thisString::String )

	err_int = ccall( (:idarray_Add, "libsmilejl"), Int32, (Ptr{Void},Ptr{Uint8}), idarr.ptr, bytestring(thisString) )
	if err_int < 0
		error( "idarray_Add: code: ", err_int )
	end
end

function flush( idarr::IdArray )

	ccall( (:stringarray_Flush, "libsmilejl"), Void, (Ptr{Void},), idarr.ptr )
end