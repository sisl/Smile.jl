export
		Dataset,
		DatasetVarInfo,
		DoubleArray,
		Header,
		IdArray,
		Network,
		Node,
		NodeDefinition,
		NodeValue,
		SysCoordinates		
		
type Dataset
	ptr::Ptr{Void}
	
	function Dataset()
		ptr = ccall( (:createDataset, "libsmilejl"), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeDataset, "libsmilejl"), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end

type DatasetVarInfo
	ptr::Ptr{Void}

	function DatasetVarInfo()
		ptr = ccall( (:createDatasetVarInfo, "libsmilejl"), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeDatasetVarInfo, "libsmilejl"), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end		

type DMatrix

	ptr::Ptr{Void}
end

type DoubleArray
	ptr::Ptr{Void}
	
	function DoubleArray()
		ptr = ccall( (:createDoubleArray, "libsmilejl"), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeDoubleArray, "libsmilejl"), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end

type Header

	ptr::Ptr{Void}
end

type IdArray
	ptr::Ptr{Void}
	
	function IdArray()
		ptr = ccall( (:createIdArray, "libsmilejl"), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeIdArray, "libsmilejl"), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end

type Network
	ptr::Ptr{Void}

	function Network()
		ptr = ccall( (:createNetwork, "libsmilejl"), Ptr{Void}, ())
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeNetwork, "libsmilejl"), Void, (Ptr{Void},), obj.ptr ))
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
		ptr = ccall( (:createSysCoordinatesFromNodeDefinition, "libsmilejl"), Ptr{Void}, (Ptr{Void},), nodedef.ptr )
		smart_p = new(ptr)
		finalizer(smart_p, obj -> ccall( (:freeSysCoordinates, "libsmilejl"), Void, (Ptr{Void},), obj.ptr ))
		smart_p
	end
end