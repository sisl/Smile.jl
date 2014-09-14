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

try
	ccall( (:libexists, "libsmilejl"), Bool, () )
catch
	error("Could not communicate with libsmilejl. Make sure it exists and that it is on the path.")
end


##############################################################################
##
## Load files
##
##############################################################################

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
