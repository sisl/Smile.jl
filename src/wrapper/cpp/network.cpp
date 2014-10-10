// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//            DSL_NETWORK            //
///////////////////////////////////////

void * createNetwork()
{
	DSL_network * theNet = new DSL_network();
	void * retval = theNet;
	return retval;
}

void freeNetwork(void * void_net)
{
    DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	delete net;
}

int network_AddArc(void * void_net, int theParent, int theChild)
{
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	return net->AddArc( theParent, theChild );
}

int network_AddNode(void * void_net, int thisType, char *thisId, char *exception)
{
	/*
	DSL_network.AddNode( int thisType, char* thisId)
	Adds a node of thisType to the network. thisId indicates the identifier of the new node.
	If thisId is NULL, a unique identifier will be generated.
	If the node is correctly created, the returning value will be the handle of the node
	This handle is guaranteed to remain constant for the lifetime of the network

	Error Values:
	DSL_OUT_OF_MEMORY
	*/
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	int uid = -1;
	uid = net->AddNode( thisType, thisId );
	
	if (uid < 0)
	{
		if ( uid == DSL_OUT_OF_MEMORY )
			sprintf( exception, "DSL_OUT_OF_MEMORY" );
		else if ( uid == DSL_OUT_OF_RANGE )
			sprintf( exception, "DSL_OUT_OF_RANGE" ); // thisId is already in use
		else
			sprintf( exception, "UNKNOWN_ERROR" );
	}

	return uid;
}

void network_GetChildren(void * void_net, int ofThisNode, int * childHandles, unsigned  * len)
{
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	DSL_intArray children = net->GetChildren(ofThisNode);
	for ( unsigned i = 0; i < (unsigned)(children.NumItems()) && i < *len; i++ )
	{
		childHandles[i] = children[i];
	}
	*len = (unsigned)(children.NumItems());
}

int network_GetFirstNode( void * void_net )
{
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	return net->GetFirstNode();
}

void network_GetParents(void * void_net, int ofThisNode, int * parentHandles, unsigned  * len)
{
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	DSL_intArray parents = net->GetParents(ofThisNode);
	for ( unsigned i = 0; i < (unsigned)(parents.NumItems()) && i < *len; i++ )
	{
		parentHandles[i] = parents[i];
	}
	*len = (unsigned)(parents.NumItems());
}

int network_GetNextNode( void * void_net, int ofThisNode )
{
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	return net->GetNextNode(ofThisNode);
}

void * network_GetNode(void * void_net, int theNode)
{
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	DSL_node * node = net->GetNode(theNode);
	void * retval = node;
	return retval;
}

int network_GetNumberOfNodes( void * void_net )
{
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	return net->GetNumberOfNodes();
}

int network_IsAcyclic( void * void_net )
{
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	return net->IsAcyclic();
}

int network_ReadFile(void * void_net, char *thisFile)
{
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	return net->ReadFile(thisFile);
}

int network_WriteFile(void * void_net, char *thisFile)
{
	/*
	DSL_network.WriteFile( char *thisFile, int fileType=0)
	Writes the contents of the network to file
	*/
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	return net->WriteFile(thisFile);
}