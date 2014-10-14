// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//       DSL_DATASET_WRITEPARAMS     //
///////////////////////////////////////

void * createDatasetWriteParams() {
	DSL_datasetWriteParams * pp = new DSL_datasetWriteParams();
	void * retval = pp;
	return retval;
}
void freeDatasetWriteParams( void * void_datasetpp ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	delete pp;
}

void datasetwriteparams_getMissingValueToken( void * void_datasetpp, char * retval ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	sprintf( retval, "%s", pp->missingValueToken.c_str() );
}
bool datasetwriteparams_getColumnIdsPresent( void * void_datasetpp ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	return pp->columnIdsPresent;
}
bool datasetwriteparams_getUseStateIndices( void * void_datasetpp ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	return pp->useStateIndices;
}
char datasetwriteparams_getSeparator( void * void_datasetpp ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	return pp->separator;
}
void datasetwriteparams_getFloatFormat( void * void_datasetpp, char * retval ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	sprintf( retval, "%s", pp->floatFormat.c_str() );
}

void datasetwriteparams_setMissingValueToken( void * void_datasetpp, char * str ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	std::string str2(str);
	pp->missingValueToken = str2;
}
void datasetwriteparams_setColumnIdsPresent( void * void_datasetpp, bool b ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	pp->columnIdsPresent = b;
}
void datasetwriteparams_setUseStateIndices( void * void_datasetpp, bool b ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	pp->useStateIndices = b;
}
void datasetwriteparams_setSeparator( void * void_datasetpp, char c ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	pp->separator = c;
}
void datasetwriteparams_setFloatFormat( void * void_datasetpp, char * str ) {
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_datasetpp);
	std::string str2(str);
	pp->floatFormat = str2;
}
