export
		next,
		set_unchecked_value

function next( sysc::SysCoordinates )
	ccall( (:syscoord_Next, "libsmilejl"), Void, (Ptr{Void},), sysc.ptr )	
end

function set_unchecked_value( sysc::SysCoordinates, val::Real )

	ccall( (:syscoord_SetUncheckedValue, "libsmilejl"), Void, (Ptr{Void},Float64), sysc.ptr, val )	
end