export  Dataset, DatasetVarInfo, DatasetParseParams, DatasetWriteParams
export  DoubleArray
export  Header
export  IdArray
export  Network
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
type DatasetParseParams
	ptr::Ptr{Void}

	function DatasetParseParams()
		ptr = ccall( (:createDatasetParseParams, LIB_SMILE), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeDatasetParseParams, LIB_SMILE), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end
type DatasetWriteParams
	ptr::Ptr{Void}

	function DatasetWriteParams()
		ptr = ccall( (:createDatasetWriteParams, LIB_SMILE), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeDatasetWriteParams, LIB_SMILE), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end

type DMatrix

	ptr::Ptr{Void}
end

type DoubleArray
	ptr::Ptr{Void}
	
	function DoubleArray()
		ptr = ccall( (:createDoubleArray, LIB_SMILE), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeDoubleArray, LIB_SMILE), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end

type Header

	ptr::Ptr{Void}
end

type IdArray
	ptr::Ptr{Void}
	
	function IdArray()
		ptr = ccall( (:createIdArray, LIB_SMILE), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeIdArray, LIB_SMILE), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end

type Network
	ptr::Ptr{Void}

	function Network()
		ptr = ccall( (:createNetwork, LIB_SMILE), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeNetwork, LIB_SMILE), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end

type Node

	ptr::Ptr{Void}
end

type NodeDefinition

	ptr::Ptr{Void}
end

type NodeValue

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
end