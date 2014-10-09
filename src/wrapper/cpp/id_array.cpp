// SISL SMILE
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//             DSL_ID_ARRAY          //
///////////////////////////////////////

void * createIdArray()
{
	DSL_idArray * idarr = new DSL_idArray();
	void * retval = idarr;
	return retval;
}

void freeIdArray( void * void_idarr )
{
	DSL_idArray * idarr = reinterpret_cast<DSL_idArray*>(void_idarr);
	delete idarr;
}

int idarray_Add( void * void_idarr, char *thisString )
{
	DSL_idArray * idarr = reinterpret_cast<DSL_idArray*>(void_idarr);
	return idarr->Add(thisString);
}