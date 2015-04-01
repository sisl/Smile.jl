// SISL SMILE
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//           DSL_NODE_VALUE          //
///////////////////////////////////////

void * nodevalue_GetMatrix( void * void_nodeval )
{
	DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
	DSL_Dmatrix * dmat = nodeval->GetMatrix();
	void * retval = dmat;
	return retval;	
}

int nodevalue_GetSize( void * void_nodeval )
{
	DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
	return nodeval->GetSize();
}

int nodevalue_GetEvidence_Int( void * void_nodeval )
{
    DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
    return nodeval->GetEvidence();
}

int nodevalue_GetEvidence_Double( void * void_nodeval, double &evidence )
{
    DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
    return nodeval->GetEvidence(evidence);
}

int nodevalue_SetEvidence_Int( void * void_nodeval, int evidence )
{
    DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
    return nodeval->SetEvidence(evidence);
}

int nodevalue_SetEvidence_Double( void * void_nodeval, double evidence )
{
    DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
    return nodeval->SetEvidence(evidence);
}

int nodevalue_ClearEvidence( void * void_nodeval )
{
    DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
    return nodeval->ClearEvidence();
}
