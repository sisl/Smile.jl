export
		discretize


function discretize{T<:Real}( data::Array{T,1}, nBins::Integer  )

	binedges = Array(Float64, nBins+1)
	discretized = Array(Int32, length(data))

	ccall( (:discretize, LIB_SMILE), Void, 
	 	(Ptr{Float32}, Uint32, Int32, Ptr{Float64}, Ptr{Int32}), 
	 	float32(data), length(data), nBins, binedges, discretized )
	
	return (discretized, binedges)
end