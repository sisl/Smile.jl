// SISL SMILE
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//           DSL_STRING_ARRAY        //
///////////////////////////////////////

int stringarray_FindPosition( void * void_strarr, char *ofThisString )
{
    DSL_stringArray * strarr = reinterpret_cast<DSL_stringArray*>(void_strarr);
    return strarr->FindPosition(ofThisString);   
}

void stringarray_Flush( void * void_strarr )
{
	DSL_stringArray * strarr = reinterpret_cast<DSL_stringArray*>(void_strarr);
	strarr->Flush();
}