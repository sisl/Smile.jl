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

int dataset_readFile( void * void_dataset, char * filename )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->ReadFile(filename);
}


void dataset_discretize( void * void_dataset, int var, int nBins, char *statePrefix)
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	dset->Discretize(var, DSL_dataset::Hierarchical, nBins, statePrefix);
}
void dataset_discretize_withedges( void * void_dataset, int var, int nBins, char *statePrefix, double* edges)
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	std::vector<double> v_edges (edges, edges + nBins);
	dset->Discretize(var, DSL_dataset::Hierarchical, nBins, statePrefix, v_edges);
}


unsigned dataset_discretize_getedges( void * void_dataset, int var, int nBins, char *statePrefix, double *binEdges)
{
	// discretizes but also returns the edges of the bins
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	std::vector<double> be;
	// one can choose Hierarchical, UniformWidth, UniformCount
	dset->Discretize(var, DSL_dataset::Hierarchical, nBins, statePrefix, be);
	for (unsigned i = 0; i < be.size(); ++i)
	{
		// std::cout << be[i] << std::endl;
		binEdges[i] = be[i];
	}
	return be.size();
}

void dataset_addFloatVar( void * void_dataset, char *varName )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	dset->AddFloatVar(varName);
}

float dataset_getFloat( void * void_dataset, int var, int rec )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetFloat(var, rec);
}

int dataset_getInt( void * void_dataset, int var, int rec )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetInt(var, rec);
}

int dataset_getNumberOfRecords( void * void_dataset )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetNumberOfRecords();	
}

int dataset_getNumberOfVariables( void * void_dataset )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->GetNumberOfVariables();
}

void dataset_getVariableInfo( void * void_dataset, void * void_datasetvi, unsigned index )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	DSL_datasetVarInfo * dsetvi = reinterpret_cast<DSL_datasetVarInfo*>(void_datasetvi);

	DSL_datasetVarInfo vi = dset->GetVariableInfo(index);
	dsetvi->discrete = vi.discrete;
	dsetvi->id = std::string(vi.id);
	dsetvi->missingInt = vi.missingInt;
	dsetvi->missingFloat = vi.missingFloat;
	for ( unsigned i = 0; i < vi.stateNames.size(); ++i )
		dsetvi->stateNames.push_back( vi.stateNames[i] );
}

bool dataset_isDiscrete( void * void_dataset, int var )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->IsDiscrete(var);
}

bool dataset_isMissing( void * void_dataset, int var, int rec )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->IsMissing(var, rec);
}

bool dataset_learnBayesianSearch( void * void_dataset, void * void_net,
						int max_parents, int max_search_time, int n_iterations, 
						double link_probability, double prior_link_probability,
						int prior_sample_size, int seed, 
						int * forcedarcs, int n_forcedarcs,
						int * forbiddenarcs, int n_forbiddenarcs,
						int * tiers, int lentiers )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);

	DSL_bs bs;

	bs.maxParents = max_parents;
	bs.maxSearchTime = max_search_time;
	bs.nrIteration = n_iterations;
	bs.linkProbability = link_probability;
	bs.priorLinkProbability = prior_link_probability;
	bs.priorSampleSize = prior_sample_size;
	bs.seed = seed;

	for ( int i = 0; i < n_forcedarcs; ++i )
	{
		int indi = forcedarcs[2*i];
		int indj = forcedarcs[2*i+1];
		bs.bkk.forcedArcs.push_back(std::pair<int,int>(indi, indj));
	}

	for ( int i = 0; i < n_forbiddenarcs; ++i )
	{
		int indi = forbiddenarcs[2*i];
		int indj = forbiddenarcs[2*i+1];
		bs.bkk.forbiddenArcs.push_back(std::pair<int,int>(indi, indj));
	}

	for ( int i = 0; i < lentiers; ++i )
	{
		int ind = tiers[2*i];  // index of the variable
		int tier = tiers[2*i+1]; // its associated tier
		bs.bkk.tiers.push_back(std::pair<int,int>(ind, tier));
	}

	return bs.Learn(*dset, *net) == DSL_OKAY;
}

bool dataset_learnDBN( void * void_dataset, void * void_net, 
	                   int max_parents, int max_search_time, int n_iterations,
	                   double link_probability, double prior_link_probability,
	                   int prior_sample_size, int seed )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);

	DSL_bs bs;       // bayesian search for structure learning

	// bs.maxParents = 5;
	// bs.maxSearchTime = 0;
	// bs.nrIteration = 20;
	// bs.linkProbability = 0.1;
	// bs.priorLinkProbability = 0.001;
	// bs.priorSampleSize = 50;
	// bs.seed = 0;

	bs.maxParents = max_parents;
	bs.maxSearchTime = max_search_time;
	bs.nrIteration = n_iterations;
	bs.linkProbability = link_probability;
	bs.priorLinkProbability = prior_link_probability;
	bs.priorSampleSize = prior_sample_size;
	bs.seed = seed;

	// run through the dataset and identify all of the time slice 0 and 1 nodes
	std::vector<int> slice0;
	std::vector<int> slice1;
	for (int i = 0; i < dset->GetNumberOfVariables(); ++i)
	{
		std::string id = dset->GetId(i);
		char lastchar = id[id.length()-1];
		if (lastchar == '0')
			slice0.push_back(i);
		else if(lastchar == '1')
			slice1.push_back(i);
		else
			std::cout << "invalid slice trailing character: " << lastchar << std::endl;
	}

	{
		std::cout << "slice0: ";
		for (unsigned i = 0; i < slice0.size(); ++i)
			std::cout << slice0[i] << " ";
		std::cout << "\n";

		std::cout << "slice1: ";
		for (unsigned i = 0; i < slice1.size(); ++i)
			std::cout << slice1[i] << " ";
		std::cout << "\n";
	}

	// forbid arcs among time slice 0 components
	int nSlice0 = slice0.size();
	for (int i = 0; i < nSlice0; ++i)
	{
		int indi = slice0[i];
		for (int j = i+1; j < nSlice0; ++j)
		{
			int indj = slice0[j];
			bs.bkk.forbiddenArcs.push_back(std::pair<int,int>(indi, indj));		
			bs.bkk.forbiddenArcs.push_back(std::pair<int,int>(indj, indi));
			std::cout << "forbidding: " << indi << " <-> " << indj << std::endl;
		}
	}

	// forbid arcs from slice 1 to slice 0
	int nSlice1 = slice1.size();
	for (int i = 0; i < nSlice0; ++i)
	{
		int s0 = slice0[i];
		for (int j = 0; j < nSlice1; ++j)
		{
			int s1 = slice1[j];
			bs.bkk.forbiddenArcs.push_back(std::pair<int,int>(s1, s0));
		    std::cout << "forbidding: " << s1 << " -> " << s0 << std::endl;	
		}
	}
	
	return (bs.Learn(*dset, *net) == DSL_OKAY);
}

bool dataset_learnGreedyThickThinning( void * void_dataset, void * void_net )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);

	DSL_greedyThickThinning gtt;
	return gtt.Learn(*dset, *net) == DSL_OKAY;
}



void dataset_removeVar( void * void_dataset, int var )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	dset->RemoveVar(var);
}

void dataset_setNumberOfRecords( void * void_dataset, int nRecords )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	dset->SetNumberOfRecords(nRecords);
}

void dataset_setFloat( void * void_dataset, int var, int rec, float value )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	dset->SetFloat(var, rec, value);
}

int dataset_setId( void * void_dataset, int var, char* newId)
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->SetId(var, newId);
}

bool dataset_setStateNames( void * void_dataset, int var, char** newNames, unsigned nNames )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);

	if ( var < 0 || var >= dset->GetNumberOfVariables() || nNames != dset->GetStateNames(var).size())
		return true;

	std::vector<std::string> newNamesVec;
	for (unsigned i = 0; i < nNames; ++i)
		newNamesVec.push_back(newNames[i]);

	return dset->SetStateNames( var, newNamesVec );
}

int dataset_writeFile( void * void_dataset, char * filename )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	return dset->WriteFile(filename);
}