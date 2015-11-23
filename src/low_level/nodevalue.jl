export
		get_matrix,
		get_size,
        get_evidence_int,
        get_evidence_double,
        set_evidence,
        clear_evidence

function get_matrix( nodeval::NodeValue )
	ptr = ccall( (:nodevalue_GetMatrix, LIB_SMILE), Ptr{Void}, (Ptr{Void},), nodeval.ptr )
	return DMatrix(ptr)
end

get_size( nodeval::NodeValue ) = 
    ccall( (:nodevalue_GetSize, LIB_SMILE), Int32, (Ptr{Void},), nodeval.ptr )

get_evidence_int( nodeval::NodeValue, val::AbstractFloat ) =
    ccall( (:nodevalue_GetEvidence_Int, LIB_SMILE), Int32, (Ptr{Void},), nodeval.ptr )
function get_evidence_double( nodeval::NodeValue )
    retval = 0.0::Cdouble
    err_int = ccall( (:nodevalue_GetEvidence, LIB_SMILE), Int32, (Ptr{Void},Ref{Cdouble}), nodeval.ptr, retval )
    if err_int < 0
        error( "nodeval_GetEvidence: code: ", err_int )
    end
    retval
end
set_evidence( nodeval::NodeValue, val::AbstractFloat ) =
    ccall( (:nodevalue_SetEvidence_Double, LIB_SMILE), Int32, (Ptr{Void},Cdouble), nodeval.ptr, val )
set_evidence( nodeval::NodeValue, val::Integer ) =
    ccall( (:nodevalue_SetEvidence_Int, LIB_SMILE), Int32, (Ptr{Void},Cint), nodeval.ptr, val )
clear_evidence( nodeval::NodeValue ) =
    ccall( (:nodevalue_ClearEvidence, LIB_SMILE), Int32, (Ptr{Void},), nodeval.ptr )