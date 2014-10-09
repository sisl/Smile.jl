// SISL SMILE
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//              DSL_NODE             //
///////////////////////////////////////

int node_ChangeType(void * void_node, int newType)
{
	DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
	return node->ChangeType(newType);
}

void * node_Definition(void * void_node)
{
	DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
	DSL_nodeDefinition * nodeDef = node->Definition();
	void * retval = nodeDef;
	return retval;
}

void node_GetName(void * void_node, char * retval)
{
	DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
	sprintf( retval, "%s", node->Info().Header().GetName() );
}

int node_Handle(void * void_node)
{
	DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
	return node->Handle();
}

void * node_Network(void * void_node)
{
	DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
	DSL_network * net = node->Network();
	void * retval = net;
	return retval;
}

void node_SetName(void * void_node, char * name )
{
	DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
	node->Info().Header().SetName(name);
}

void * node_Value(void * void_node)
{
	DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
	DSL_nodeValue * nodeValue = node->Value();
	void * retval = nodeValue;
	return retval;
}