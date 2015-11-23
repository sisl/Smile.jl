export
		add,
		flush,
        find_position

add( idarr::IdArray, thisString::AbstractString ) = ccall( (:idarray_Add, LIB_SMILE), Int32, (Ptr{Void},Ptr{UInt8}), idarr.ptr, bytestring(thisString) )

# String Arrays
find_position( idarr::IdArray, ofThisString::AbstractString) =
    ccall( (:stringarray_FindPosition, LIB_SMILE), Int32, (Ptr{Void},Ptr{UInt8}), idarr.ptr, bytestring(ofThisString) )

Base.flush( idarr::IdArray ) = ccall( (:stringarray_Flush, LIB_SMILE), Void, (Ptr{Void},), idarr.ptr )
