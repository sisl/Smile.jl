export
		get_matrix,
		set_definition,
		set_number_of_outcomes

function get_matrix( nodedef::NodeDefinition )
	ptr = ccall( (:nodedef_GetMatrix, LIB_SMILE), Ptr{Void}, (Ptr{Void},), nodedef.ptr )
	return DMatrix(ptr)
end

function set_definition( nodedef::NodeDefinition, dblarr::DoubleArray )

	err_int = ccall( (:nodedef_SetDefinition, LIB_SMILE), Int32, (Ptr{Void},Ptr{Void}), nodedef.ptr, dblarr.ptr )
	if err_int < 0
		error( "nodedef_SetDefinition: code: ", err_int )
	end
end

function set_number_of_outcomes( nodedef::NodeDefinition, idarr::IdArray )

	err_int = ccall( (:nodedef_SetNumberOfOutcomes, LIB_SMILE), Int32, (Ptr{Void},Ptr{Void}), nodedef.ptr, idarr.ptr )
	if err_int < 0
		error( "nodedef_SetNumberOfOutcomes: code: ", err_int )
	end
end