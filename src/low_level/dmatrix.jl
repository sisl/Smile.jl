export
		get_number_of_dimensions,
		get_size,
		get_size_of_dimension

function get_at{T <: Integer}( dmat::DMatrix, coord::Array{T,1} )
	retval = ccall( (:dmatrix_GetAtCoord, LIB_SMILE), Float64, (Ptr{Void},Ptr{Int32},UInt32), dmat.ptr, Int32(coord), length(coord) )
	return retval
end


# the order of the probabilities is given by considering the state of
# the first parent as "most significant", then the second parent, then
# the third (and so on), and finally considering the coordinate of the
# node itself as the least significant one.

# Example: consider a node C with two parents, A and B
# A has 2 instances: A1 & A2
# B has 3 instances: B1 & B2 & B3
# C has 2 instances: C1 & C2
# the first index, 0, corresponds to [A1 B1 C1]
# the next index,  1, corresponds to [A1 B1 C2]
# then             2,       ->       [A1 B2 C1]
#                  3,       ->       [A1 B2 C2]
#                  4,       ->       [A1 B3 C1]
#     ...
#                  11       ->       [A2 B3 C2]

Base.getindex(dmat::DMatrix, index::Integer) =
    ccall( (:dmatrix_GetAtInd, LIB_SMILE), Float64, (Ptr{Void},Int32), dmat.ptr, index )
Base.setindex!(dmat::DMatrix, value::Real, ind::Integer) =
    ccall( (:dmatrix_SetAtInd, LIB_SMILE), Void, (Ptr{Void},Int32,Float64), dmat.ptr, ind, value )

get_number_of_dimensions( dmat::DMatrix ) =
	ccall( (:dmatrix_GetNumberOfDimensions, LIB_SMILE), Int32, (Ptr{Void},), dmat.ptr )

function get_size( dmat::DMatrix )
	retval = ccall( (:dmatrix_GetSize, LIB_SMILE), Int32, (Ptr{Void},), dmat.ptr )
	return retval
end

function get_size_of_dimension( dmat::DMatrix, aDimension::Integer )
	# indexing starts at 0
	# returns 0 if you pick a bad value for aDimension
	retval = ccall( (:dmatrix_GetSizeOfDimension, LIB_SMILE), Int32, (Ptr{Void},Int32), dmat.ptr, aDimension )
	return retval
end

coordinates_to_index(dmat::DMatrix, arr::IntArray) =
	ccall( (:dmatrix_CoordinatesToIndex, LIB_SMILE), Int32, (Ptr{Void},Ptr{Void}), dmat.ptr, arr.ptr )
