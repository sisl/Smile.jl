export  Dataset, DatasetVarInfo, DatasetParseParams, DatasetWriteParams
export  DoubleArray
export  Header
export  IdArray
export  Network
export  Pattern
export  Node
export  NodeDefinition
export  NodeValue
export  SysCoordinates		
		
type Dataset
	ptr::Ptr{Void}
	
	function Dataset()
		ptr = ccall( (:createDataset, LIB_SMILE), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeDataset, LIB_SMILE), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
	function Dataset( dset::Dataset )
		ptr = ccall( (:copyDataset, LIB_SMILE), Ptr{Void}, (Ptr{Void},), dset.ptr)
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeDataset, LIB_SMILE), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end

immutable DMatrix
	ptr::Ptr{Void}
end

immutable Header
	ptr::Ptr{Void}
end

for str = ("DatasetParseParams", "DatasetWriteParams", "DoubleArray", "IdArray","Network","Pattern",)
	fname = symbol(str)
	f_sym 

	op_cr = QuoteNode(symbol("create$str"))
	op_fr = QuoteNode(symbol("free$str"))

	@eval begin
		type $fname
			ptr::Ptr{Void}

			($fname)(ptr::Ptr{Void}) = new(ptr)
			function ($fname)()
				ptr = ccall( ($op_cr, LIB_SMILE), Ptr{Void}, ())
				smart_p = new(ptr)
				finalizer(smart_p, obj -> ccall( ($op_fr, LIB_SMILE), Void, (Ptr{Void},), obj.ptr ))
				smart_p
			end
		end
	end
end

immutable Node
	ptr::Ptr{Void}
end

immutable NodeDefinition
	ptr::Ptr{Void}
end

immutable NodeValue
	ptr::Ptr{Void}
end

type SysCoordinates
	ptr::Ptr{Void}
	
	function SysCoordinates( nodedef::NodeDefinition )
		ptr = ccall( (:createSysCoordinatesFromNodeDefinition, LIB_SMILE), Ptr{Void}, (Ptr{Void},), nodedef.ptr )
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeSysCoordinates, LIB_SMILE), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
	function SysCoordinates( nodeval::NodeValue )
		ptr = ccall( (:createSysCoordinatesFromNodeValue, LIB_SMILE), Ptr{Void}, (Ptr{Void},), nodeval.ptr )
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeSysCoordinates, LIB_SMILE), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
	
end