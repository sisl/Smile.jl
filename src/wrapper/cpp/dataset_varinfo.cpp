// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//         DSL_DATASET_VARINFO       //
///////////////////////////////////////

void * createDatasetVarInfo()
{
	DSL_datasetVarInfo * dsetvi = new DSL_datasetVarInfo();
	void * retval = dsetvi;
	return retval;
}

void freeDatasetVarInfo( void * void_datasetvi )
{
	DSL_datasetVarInfo * dsetvi = reinterpret_cast<DSL_datasetVarInfo*>(void_datasetvi);
	delete dsetvi;
}

bool datasetvarinfo_getDiscrete( void * void_datasetvi )
{
	DSL_datasetVarInfo * dsetvi = reinterpret_cast<DSL_datasetVarInfo*>(void_datasetvi);
	return dsetvi->discrete;
}

void datasetvarinfo_getId( void * void_datasetvi, char *id )
{
	DSL_datasetVarInfo * dsetvi = reinterpret_cast<DSL_datasetVarInfo*>(void_datasetvi);
	sprintf( id, "%s", dsetvi->id.c_str() );
}

int datasetvarinfo_getMissingInt( void * void_datasetvi )
{
	DSL_datasetVarInfo * dsetvi = reinterpret_cast<DSL_datasetVarInfo*>(void_datasetvi);
	return dsetvi->missingInt;
}

float datasetvarinfo_getMissingFloat( void * void_datasetvi )
{
	DSL_datasetVarInfo * dsetvi = reinterpret_cast<DSL_datasetVarInfo*>(void_datasetvi);
	return dsetvi->missingFloat;
}

unsigned int datasetvarinfo_getStateNamesSize( void * void_datasetvi )
{
	DSL_datasetVarInfo * dsetvi = reinterpret_cast<DSL_datasetVarInfo*>(void_datasetvi);
	return dsetvi->stateNames.size();	
}

bool datasetvarinfo_getStateNameAt( void * void_datasetvi, char *stateName, unsigned int index )
{
	DSL_datasetVarInfo * dsetvi = reinterpret_cast<DSL_datasetVarInfo*>(void_datasetvi);
	if ( index < 0 || index >= dsetvi->stateNames.size() )
	{
		sprintf( stateName, "%s", "ERROR: INDEX OUT OF BOUNDS" );
		return false;
	}
	sprintf( stateName, "%s", dsetvi->stateNames[index].c_str() );
	return true;
}
