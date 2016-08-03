module Smile

##############################################################################
##
## Dependencies
##
##############################################################################


##############################################################################
##
## Ensure libsmilejl can be found
##
##############################################################################

pathtoadd = joinpath(dirname(@__FILE__), "..", "deps", "downloads")

if isempty(Libdl.find_library(collect(["libsmilejl"]), collect([pathtoadd])))
	warn("Could not communicate with libsmilejl. Make sure it exists and that it is on the path.")
else

	global const LIB_SMILE = Libdl.find_library(collect(["libsmilejl"]), collect([pathtoadd]))

	import Base: getindex, setindex!, print

	include("low_level/types.jl")
	include("low_level/network.jl")
	include("low_level/pattern.jl")
	include("low_level/node.jl")
	include("low_level/nodedefinition.jl")
	include("low_level/intarray.jl")
	include("low_level/idarray.jl")
	include("low_level/doublearray.jl")
	include("low_level/syscoordinates.jl")
	include("low_level/dataset.jl")
	include("low_level/nodevalue.jl")
	include("low_level/dmatrix.jl")
	include("low_level/learning.jl")

	include("high_level/learning.jl")
	include("high_level/sampling.jl")
end

end # end module
