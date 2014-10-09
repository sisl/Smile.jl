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

if isempty(find_library(["libsmilejl"]))
	warn("Could not communicate with libsmilejl. Make sure it exists and that it is on the path.")
else

	include("low_level/types.jl")
	include("low_level/network.jl")
	include("low_level/utils.jl")
	include("low_level/node.jl")
	include("low_level/nodedefinition.jl")
	include("low_level/idarray.jl")
	include("low_level/doublearray.jl")
	include("low_level/syscoordinates.jl")
	include("low_level/dataset.jl")
	include("low_level/nodevalue.jl")
	include("low_level/dmatrix.jl")

	include("high_level/learning.jl")

end

end # end module
