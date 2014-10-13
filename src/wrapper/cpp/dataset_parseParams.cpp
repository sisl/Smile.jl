// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//       DSL_DATASET_PARSEPARAMS     //
///////////////////////////////////////

void * createDatasetParseParams() {
	DSL_datasetParseParams * pp = new DSL_datasetParseParams();
	void * retval = pp;
	return retval;
}
void freeDatasetParseParams( void * void_datasetpp ) {
	DSL_datasetParseParams * pp = reinterpret_cast<DSL_datasetParseParams*>(void_datasetpp);
	delete pp;
}

void datasetparseparams_getMissingValueToken( void * void_datasetpp, char * retval ) {
	DSL_datasetParseParams * pp = reinterpret_cast<DSL_datasetParseParams*>(void_datasetpp);
	sprintf( retval, "%s", pp->missingValueToken.c_str() );
}
int datasetparseparams_getMissingInt( void * void_datasetpp ) {
	DSL_datasetParseParams * pp = reinterpret_cast<DSL_datasetParseParams*>(void_datasetpp);
	return pp->missingInt;
}
float datasetparseparams_getMissingFloat( void * void_datasetpp ) {
	DSL_datasetParseParams * pp = reinterpret_cast<DSL_datasetParseParams*>(void_datasetpp);
	return pp->missingFloat;
}
bool datasetparseparams_getColumnIdsPresent( void * void_datasetpp ) {
	DSL_datasetParseParams * pp = reinterpret_cast<DSL_datasetParseParams*>(void_datasetpp);
	return pp->columnIdsPresent;
}

void datasetparseparams_setMissingValueToken( void * void_datasetpp, char * str ) {
	DSL_datasetParseParams * pp = reinterpret_cast<DSL_datasetParseParams*>(void_datasetpp);
	std::string str2(str);
	pp->missingValueToken = str2;
}
void datasetparseparams_setMissingInt( void * void_datasetpp, int i ) {
	DSL_datasetParseParams * pp = reinterpret_cast<DSL_datasetParseParams*>(void_datasetpp);
	pp->missingInt = i;
}
void datasetparseparams_setMissingFloat( void * void_datasetpp, float f ) {
	DSL_datasetParseParams * pp = reinterpret_cast<DSL_datasetParseParams*>(void_datasetpp);
	pp->missingFloat = f;
}
void datasetparseparams_setColumnIdsPresent( void * void_datasetpp, bool b ) {
	DSL_datasetParseParams * pp = reinterpret_cast<DSL_datasetParseParams*>(void_datasetpp);
	pp->columnIdsPresent = b;
}
