// SISL SMILE
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//           DSL_DOUBLE_ARRAY        //
///////////////////////////////////////

void * createDoubleArray()
{
	DSL_doubleArray * dblarr = new DSL_doubleArray();
	void * retval = dblarr;
	return retval;
}

void freeDoubleArray( void * void_dblarr )
{
	DSL_doubleArray * dblarr = reinterpret_cast<DSL_doubleArray*>(void_dblarr);
	delete dblarr;
}

double doublearray_At( void * void_dblarr, int index, char *exception )
{
	//TODO: check whether in bounds
	DSL_doubleArray * dblarr = reinterpret_cast<DSL_doubleArray*>(void_dblarr);

	if ( index >= dblarr->GetSize() || index < 0 )
	{
		sprintf( exception, "error: index out of bounds" );
		return 0.0;
	}

	return (*dblarr)[index];
}

int doublearray_GetSize( void * void_dblarr )
{
	DSL_doubleArray * dblarr = reinterpret_cast<DSL_doubleArray*>(void_dblarr);	
	return dblarr->GetSize();
}

void doublearray_SetAt( void * void_dblarr, int index, double value, char *exception )
{
	DSL_doubleArray * dblarr = reinterpret_cast<DSL_doubleArray*>(void_dblarr);

	if ( index >= dblarr->GetSize() || index < 0 )
	{
		sprintf( exception, "error: index out of bounds" );
		return;
	}
	
	(*dblarr)[index] = value;
}

int doublearray_SetSize( void * void_dblarr, int thisSize )
{
	DSL_doubleArray * dblarr = reinterpret_cast<DSL_doubleArray*>(void_dblarr);
	return dblarr->SetSize(thisSize);
}
