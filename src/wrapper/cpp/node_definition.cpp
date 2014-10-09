// SISL SMILE
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//          DSL_NODE_DEFINITION      //
///////////////////////////////////////

void * nodedef_GetMatrix( void * void_nodedef )
{
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	DSL_Dmatrix * dmat = nodedef->GetMatrix();
	void * retval = dmat;
	return retval;	
}

int nodedef_SetDefinition( void * void_nodedef, void * void_doubleArray )
{
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	DSL_doubleArray * dblarr = reinterpret_cast<DSL_doubleArray*>(void_doubleArray);
	return nodedef->SetDefinition(*dblarr);
}

int nodedef_SetNumberOfOutcomes(void * void_nodedef, void * void_stringArray)
{
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	DSL_stringArray * strarr = reinterpret_cast<DSL_stringArray*>(void_stringArray);
	return nodedef->SetNumberOfOutcomes(*strarr);
}