// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//             DSL_DATASET           //
///////////////////////////////////////

int EDSL_DISCRETIZE_HIERARCHICAL = DSL_dataset::Hierarchical;
int EDSL_DISCRETIZE_UNIFORMWIDTH = DSL_dataset::UniformWidth;
int EDSL_DISCRETIZE_UNIFORMCOUNT = DSL_dataset::UniformCount;

int EDSL_MISSING_INT             = DSL_MISSING_INT;
float EDSL_MISSING_FLOAT         = DSL_MISSING_FLOAT;

void * createDataset() {
	DSL_dataset * dset = new DSL_dataset();
	void * retval = dset;
	return retval;
}
void * copyDataset( void * void_dataset ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	DSL_dataset * dset2 = new DSL_dataset(*dset);
	void * retval = dset2;
	return retval;
}
void freeDataset( void * void_dataset ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	delete dset;
}

int dataset_readFile( void * void_dataset, char * filename ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->ReadFile(filename);
}
int dataset_readFile_withparams( void * void_dataset, char * filename, void * void_params )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	DSL_datasetParseParams * pp = reinterpret_cast<DSL_datasetParseParams*>(void_params);
	return dset->ReadFile(filename, pp);
}
int dataset_writeFile( void * void_dataset, char * filename ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->WriteFile(filename);
}
int dataset_writeFile_withparams( void * void_dataset, char * filename, void * void_params ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	DSL_datasetWriteParams * pp = reinterpret_cast<DSL_datasetWriteParams*>(void_params);
	return dset->WriteFile(filename, pp);
}

int dataset_addIntVar( void * void_dataset, char *varName, int missingValue ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->AddIntVar(varName, missingValue);
}
int dataset_addFloatVar( void * void_dataset, char *varName, float missingValue ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->AddFloatVar(varName, missingValue);
}
int dataset_removeVar( void * void_dataset, int var ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->RemoveVar(var);
}
void dataset_addEmptyRecord( void * void_dataset ){
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	dset->AddEmptyRecord();
}
void dataset_setNumberOfRecords( void * void_dataset, int numRecords ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	dset->SetNumberOfRecords(numRecords);
}
int dataset_removeRecord( void * void_dataset, int rec ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->RemoveRecord(rec);
}

int dataset_findVariable( void * void_dataset, char *id ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->FindVariable(id);
}
int dataset_getNumberOfVariables( void * void_dataset ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetNumberOfVariables();
}
int dataset_getNumberOfRecords( void * void_dataset ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetNumberOfRecords();	
}

int dataset_getInt( void * void_dataset, int var, int rec ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetInt(var, rec);
}
float dataset_getFloat( void * void_dataset, int var, int rec ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetFloat(var, rec);
}
void dataset_setInt( void * void_dataset, int var, int rec, int value ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	dset->SetInt(var, rec, value);
}
void dataset_setFloat( void * void_dataset, int var, int rec, float value ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	dset->SetFloat(var, rec, value);
}
void dataset_setMissing( void * void_dataset, int var, int rec ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	dset->SetMissing(var, rec);
}
int  dataset_getMissingInt( void * void_dataset, int var ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetMissingInt(var);
}
float dataset_getMissingFloat( void * void_dataset, int var ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetMissingFloat(var);
}
bool dataset_isMissing( void * void_dataset, int var, int rec ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->IsMissing(var, rec);
}
bool dataset_isDiscrete( void * void_dataset, int var ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->IsDiscrete(var);
}
void dataset_getIntData( void * void_dataset, int var, int * retval ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	std::vector<int> data = dset->GetIntData(var);
	for (unsigned i = 0; i < data.size(); ++i)
		retval[i] = data[i];
}
void dataset_getFloatData( void * void_dataset, int var, float * retval ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	std::vector<float> data = dset->GetFloatData(var);
	for (unsigned i = 0; i < data.size(); ++i)
		retval[i] = data[i];
}
void dataset_getId( void * void_dataset, int var, char * str ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	sprintf( str, "%s", dset->GetId(var).c_str() );
}
int dataset_setId( void * void_dataset, int var, char* newId) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->SetId(var, newId);
}


int dataset_getNumStates( void * void_dataset, int var ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetStateNames(var).size();
}
void dataset_getStateNames( void * void_dataset, int var, char** names ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	std::vector<std::string> statenames = dset->GetStateNames(var);
	for (unsigned i = 0; i < statenames.size(); i++ )
		sprintf( names[i], "%s", statenames[i].c_str() );
}
int dataset_setStateNames( void * void_dataset, int var, char** newNames ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	std::vector<std::string> newNamesVec;
	for (unsigned i = 0; i < dset->GetStateNames(var).size(); ++i)
		newNamesVec.push_back(newNames[i]);
	return dset->SetStateNames( var, newNamesVec );
}


bool dataset_hasMissingData( void * void_dataset, int var ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->HasMissingData(var);
}
bool dataset_isConstant( void * void_dataset, int var ) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->IsConstant(var);
}


void dataset_discretize( void * void_dataset, int var, int nBins, char *statePrefix, int alg) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	DSL_dataset::DiscretizeAlgorithm algorithm = DSL_dataset::Hierarchical;
	if (alg == int(DSL_dataset::UniformWidth))
		algorithm = DSL_dataset::UniformWidth;
	else if (alg == int(DSL_dataset::UniformCount))
		algorithm = DSL_dataset::UniformCount;
	dset->Discretize(var, algorithm, nBins, statePrefix);
}
void dataset_discretize_withedges( void * void_dataset, int var, int nBins, char *statePrefix, double* edges) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	std::vector<double> v_edges;
	for (int i = 0; i < nBins+1; i++)
		v_edges.push_back(edges[i]);
	dset->Discretize(var, DSL_dataset::Hierarchical, nBins, statePrefix, v_edges);
}
unsigned dataset_discretize_getedges( void * void_dataset, int var, int nBins, char *statePrefix, int alg, double *binEdges) {
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	DSL_dataset::DiscretizeAlgorithm algorithm = DSL_dataset::Hierarchical;
	if (alg == int(DSL_dataset::UniformWidth))
		algorithm = DSL_dataset::UniformWidth;
	else if (alg == int(DSL_dataset::UniformCount))
		algorithm = DSL_dataset::UniformCount;

	std::vector<double> be;
	dset->Discretize(var, algorithm, nBins, statePrefix, be);
	for (unsigned i = 0; i < be.size(); ++i)
		binEdges[i] = be[i];
	return be.size();
}



