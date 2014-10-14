// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//               LEARNING            //
///////////////////////////////////////

int EDSL_K2      = 0;
float EDSL_BDeu  = 1;

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

bool dataset_learnGreedyThickThinning( void * void_dataset, void * void_net,
						int priors, int maxParents, double netWeight
 )
{
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);

	DSL_greedyThickThinning gtt;
	gtt.maxParents = maxParents;
	gtt.netWeight  = netWeight;
	if (priors == EDSL_K2)
		gtt.priors = gtt.K2;
	else
		gtt.priors = gtt.BDeu;

	return gtt.Learn(*dset, *net) == DSL_OKAY;
}