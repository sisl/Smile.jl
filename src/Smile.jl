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

	include("types.jl")
	include("network.jl")
	include("utils.jl")
	include("node.jl")
	include("nodedefinition.jl")
	include("idarray.jl")
	include("doublearray.jl")
	include("syscoordinates.jl")
	include("dataset.jl")
	include("nodevalue.jl")
	include("dmatrix.jl")

end

end
