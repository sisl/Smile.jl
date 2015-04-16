export
	   to_native_int_array,
       num_items,
       use_as_list

function to_native_int_array(arr::IntArray)
    n = num_items(arr)
    retval = Array(Int32, n)
    for i = 1 : n
        retval[i] = arr[i-1]
    end
    retval
end

use_as_list(arr::IntArray, nItems::Integer=-1) =
    ccall( (:intarray_UseAsList, LIB_SMILE), Void, (Ptr{Void},Cint), arr.ptr, nItems)
num_items(arr::IntArray) = 
    ccall( (:intarray_NumItems, LIB_SMILE), Int32, (Ptr{Void},), arr.ptr )
Base.size(arr::IntArray) = 
    ccall( (:intarray_GetSize, LIB_SMILE), Int32, (Ptr{Void},), arr.ptr )
Base.getindex(arr::IntArray, index::Integer) = 
    ccall( (:intarray_GetIndex, LIB_SMILE), Int32, (Ptr{Void},Int32), arr.ptr, index )
Base.setindex!(arr::IntArray, value::Integer, index::Integer) = 
    ccall( (:intarray_SetIndex, LIB_SMILE), Void, (Ptr{Void},Int32,Int32), arr.ptr, index, value )
Base.insert!(arr::IntArray, here::Integer, thisNumber::Integer) = 
    ccall( (:intarray_Insert, LIB_SMILE), Cint, (Ptr{Void},Cint,Cint), arr.ptr, here, thisNumber )
Base.push!(arr::IntArray, thisNumber::Integer) =
    ccall( (:intarray_Add, LIB_SMILE), Cint, (Ptr{Void},Cint), arr.ptr, thisNumber )