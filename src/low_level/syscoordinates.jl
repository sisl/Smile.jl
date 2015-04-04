export
        unchecked_value,
		set_unchecked_value,
        go_to_current_position,
        go_to,
        link_to

Base.next( sysc::SysCoordinates ) =
    ccall( (:syscoord_Next, LIB_SMILE), Void, (Ptr{Void},), sysc.ptr )

Base.getindex(sysc::SysCoordinates, index::Integer) = 
    ccall( (:syscoord_GetIndex, LIB_SMILE), Cint, (Ptr{Void},Cint), sysc.ptr, index )
Base.setindex!(sysc::SysCoordinates, value::Integer, index::Integer) = 
    ccall( (:syscoord_SetIndex, LIB_SMILE), Void, (Ptr{Void},Cint,Cint), sysc.ptr, index, value )

unchecked_value(sysc::SysCoordinates) = 
    ccall( (:syscoord_UncheckedValue, LIB_SMILE), Cdouble, (Ptr{Void},), sysc.ptr )

set_unchecked_value( sysc::SysCoordinates, val::Real ) = 
	ccall( (:syscoord_SetUncheckedValue, LIB_SMILE), Void, (Ptr{Void},Float64), sysc.ptr, val )	

go_to(sysc::SysCoordinates, theIndex::Integer) =
    ccall( (:syscoord_GoTo, LIB_SMILE), Cint, (Ptr{Void},Cint), sysc.ptr, theIndex)
go_to_current_position(sysc::SysCoordinates) =
    ccall( (:syscoord_GoToCurrentPosition, LIB_SMILE), Void, (Ptr{Void},), sysc.ptr)

link_to(sysc::SysCoordinates, dmat::DMatrix) = 
    ccall( (:syscoord_LinkTo_DMatrix, LIB_SMILE), Void, (Ptr{Void},Ptr{Void}), sysc.ptr, dmat.ptr) 
link_to(sysc::SysCoordinates, nodedef::NodeDefinition) = 
    ccall( (:syscoord_LinkTo_NodeDefinition, LIB_SMILE), Void, (Ptr{Void},Ptr{Void}), sysc.ptr, nodedef.ptr) 
link_to(sysc::SysCoordinates, nodeval::NodeValue) = 
    ccall( (:syscoord_LinkTo_NodeValue, LIB_SMILE), Void, (Ptr{Void},Ptr{Void}), sysc.ptr, nodeval.ptr) 