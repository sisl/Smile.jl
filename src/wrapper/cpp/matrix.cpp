// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

//////////////////////////////////////
//             DSL_DMATRIX           //
///////////////////////////////////////

double dmatrix_GetAtCoord( void * void_dmat, int * theCoordinates, unsigned len )
{
	DSL_Dmatrix * dmat = reinterpret_cast<DSL_Dmatrix*>(void_dmat);
	
	DSL_intArray coords = DSL_intArray(len);
	for (unsigned i = 0; i < len; i++)
		coords[i] = theCoordinates[i];

	double retval = dmat->Subscript(coords);
	return retval;
}

double dmatrix_GetAtInd( void * void_dmat, int index )
{
	DSL_Dmatrix * dmat = reinterpret_cast<DSL_Dmatrix*>(void_dmat);
	double retval = dmat->Subscript(index);
	return retval;	
}

void dmatrix_SetAtInd( void * void_dmat, int index, double value )
{
	DSL_Dmatrix * dmat = reinterpret_cast<DSL_Dmatrix*>(void_dmat);
	dmat->Subscript(index) = value;
}

int dmatrix_GetNumberOfDimensions( void * void_dmat )
{
	DSL_Dmatrix * dmat = reinterpret_cast<DSL_Dmatrix*>(void_dmat);
	return dmat->GetNumberOfDimensions();
}

int dmatrix_GetSize( void * void_dmat )
{
	DSL_Dmatrix * dmat = reinterpret_cast<DSL_Dmatrix*>(void_dmat);
	return dmat->GetSize();
}

int dmatrix_GetSizeOfDimension( void * void_dmat, int aDimension )
{
	DSL_Dmatrix * dmat = reinterpret_cast<DSL_Dmatrix*>(void_dmat);
	return dmat->GetSizeOfDimension( aDimension );
}

int dmatrix_CoordinatesToIndex( void * void_dmat, void * void_intarr )
{
	DSL_Dmatrix * dmat = reinterpret_cast<DSL_Dmatrix*>(void_dmat);
	DSL_intArray * arr = reinterpret_cast<DSL_intArray*>(void_intarr);
	return dmat->CoordinatesToIndex(*arr);
}