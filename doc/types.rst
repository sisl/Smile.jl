Available Types
===============

Smile.jl represents SMILE objects as Julia types with void pointers to their C++ counterparts. Garbage collection is handled automatically through the use of a finalizer set in the type constructor.

The available types are:

	================== ======================== =====================================
	   **Type**         ***SMILE Object***        **Description**
	------------------ ------------------------ -------------------------------------
	``Dataset``          DSL_dataset             A basic container class for passing,
												 data to preprocessing and learning classes
	``DatasetVarInfo``   DSL_variableInfo        A structure containing information about
												 a variable type and its values
	``DoubleArray``		 DSL_doubleArray		 SMILE class offering array-like and
												 list-like behavior
	``Header``			 DSL_header				 A placeholder providing objects with an
												 identifier, a name, and a comment
	``IdArray``			 DSL_idArray			 SMILE class offering array-like and
												 list-like behavior
	``Network``			 DSL_network			 A network of nodes
	``Node``			 DSL_node				 A node within a network; contains a 
												 definition and a value
	``NodeDefinition``   DSL_nodeDefinition		 The underlying definition of how a specific
												 node is defined
	``NodeValue``		 DSL_nodeValue			 The current value that the node possesses
	``SysCoordinates``	 DSL_sysCoordinates		 A class for constructing probability tables
	=================== ======================= =====================================

All objects are constructed without parameters, with the exception of SysCoordinates, which requires a NodeDefinition.

