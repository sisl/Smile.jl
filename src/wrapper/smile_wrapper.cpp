#include "smile_wrapper.hpp"
#include "lib/smile.h"
#include "lib/smilearn.h"
#include <cstring>
#include <sstream>
#include <iostream>  // std::cout
#include <vector>

///////////////////////////////////////
//             UTILITIY              //
///////////////////////////////////////

	int getNodeTypeID( char * typeName )
	{
		/*
		Returns node type values given their string representation
		Returns -1 if the provided value is not known
		*/
		if ( strcmp(typeName, "DSL_LIST") == 0 )
			return DSL_LIST;
		else if ( strcmp(typeName, "DSL_TRUTHTABLE") == 0 )
			return DSL_TRUTHTABLE;
		else if ( strcmp(typeName, "DSL_CPT") == 0 )
			return DSL_CPT;
		else if ( strcmp(typeName, "DSL_NOISY_MAX") == 0 )
			return DSL_NOISY_MAX;
		else if ( strcmp(typeName, "DSL_TABLE") == 0 )
			return DSL_TABLE;
		else if ( strcmp(typeName, "DSL_MAU") == 0 )
			return DSL_MAU;
		return -1;
	}

	void discretize( float * data, unsigned datalen, int nBins, double *binEdges, int *discretized )
	{
		// this follows SMILearn Tutorial 3: Discretization
		DSL_dataset d;
		d.AddFloatVar("tempname");
		d.SetNumberOfRecords(datalen);

		binEdges[0] = data[0];
		binEdges[nBins] = data[0];
		for (unsigned y = 0; y < datalen; ++y)
		{
			d.SetFloat(0,y,data[y]);
			if (data[y] < binEdges[0])
				binEdges[0] = data[y];
			if (data[y] > binEdges[nBins])
				binEdges[nBins] = data[y];
		}

		// discretize once to get bin edges
		DSL_discretizer disc(d.GetFloatData(0));
		std::vector<double> be;
		disc.Discretize(DSL_discretizer::UniformCount, nBins, be);

		// discretize again to get discretized values
		std::vector<int> result; // Hierarchical
		disc.Discretize(DSL_discretizer::UniformCount, nBins, result);

		for (unsigned i = 0; i < be.size(); ++i)
			binEdges[i+1] = be[i];

		for (unsigned i = 0; i < result.size(); ++i)
			discretized[i] = result[i];
	}

///////////////////////////////////////
//            DSL_NETWORK            //
///////////////////////////////////////

	void * createNetwork()
	{
		DSL_network * theNet = new DSL_network();
		void * retval = theNet;
		return retval;
	}

	void freeNetwork(void * void_net)
	{
	    DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		delete net;
	}

	int network_AddArc(void * void_net, int theParent, int theChild)
	{
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		return net->AddArc( theParent, theChild );
	}

	int network_AddNode(void * void_net, int thisType, char *thisId, char *exception)
	{
		/*
		DSL_network.AddNode( int thisType, char* thisId)
		Adds a node of thisType to the network. thisId indicates the identifier of the new node.
		If thisId is NULL, a unique identifier will be generated.
		If the node is correctly created, the returning value will be the handle of the node
		This handle is guaranteed to remain constant for the lifetime of the network

		Error Values:
		DSL_OUT_OF_MEMORY
		*/
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		int uid = -1;
		uid = net->AddNode( thisType, thisId );
		
		if (uid < 0)
		{
			if ( uid == DSL_OUT_OF_MEMORY )
				sprintf( exception, "DSL_OUT_OF_MEMORY" );
			else if ( uid == DSL_OUT_OF_RANGE )
				sprintf( exception, "DSL_OUT_OF_RANGE" ); // thisId is already in use
			else
				sprintf( exception, "UNKNOWN_ERROR" );
		}

		return uid;
	}

	void network_GetChildren(void * void_net, int ofThisNode, int * childHandles, unsigned  * len)
	{
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		DSL_intArray children = net->GetChildren(ofThisNode);
		for ( unsigned i = 0; i < (unsigned)(children.NumItems()) && i < *len; i++ )
		{
			childHandles[i] = children[i];
		}
		*len = (unsigned)(children.NumItems());
	}

	int network_GetFirstNode( void * void_net )
	{
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		return net->GetFirstNode();
	}

	void network_GetParents(void * void_net, int ofThisNode, int * parentHandles, unsigned  * len)
	{
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		DSL_intArray parents = net->GetParents(ofThisNode);
		for ( unsigned i = 0; i < (unsigned)(parents.NumItems()) && i < *len; i++ )
		{
			parentHandles[i] = parents[i];
		}
		*len = (unsigned)(parents.NumItems());
	}

	int network_GetNextNode( void * void_net, int ofThisNode )
	{
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		return net->GetNextNode(ofThisNode);
	}

	void * network_GetNode(void * void_net, int theNode)
	{
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		DSL_node * node = net->GetNode(theNode);
		void * retval = node;
		return retval;
	}

	int network_GetNumberOfNodes( void * void_net )
	{
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		return net->GetNumberOfNodes();
	}

	int network_IsAcyclic( void * void_net )
	{
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		return net->IsAcyclic();
	}

	// int network_LearnDynamicBayesianNetwork( void * void_net, void * void_dataset )
	// {
	// 	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	// 	DSL_dataset * ds = reinterpret_cast<DSL_dataset*>(void_dataset);

	// 	// Note: this uses the code from smilearn tutorial 6: learning B.N.
	// 	// assumptions: 
	// 	//  - the data set contains all variables that exist in the network and no others
	// 	//  - all states from the data set are present in the network variables

	// 	// match variables:
	// 	std::vector<DSL_datasetMatch> dsMap(ds->GetNumberOfVariables());
	// 	for (int i = 0; i < ds->GetNumberOfVariables(); i++)
	// 	{
	// 		std::string id = ds->GetId(i);
	// 	    const char* idc = id.c_str();
	// 	    bool done = false;

	// 	    // std::cout << "id: = " << id << std::endl;

	// 	    for (int j = 0; j < (int) strlen(idc) && !done; j++) {
	// 	        if (idc[j] == '_') {
	// 	           // get the node handle:
	// 	           char* nodeId = (char*) malloc((j+1) * sizeof(char));
	// 	           strncpy(nodeId, idc, j);
	// 	           nodeId[j] = '\0';
		           
	// 	           std::cout << "node id: = " << nodeId << std::endl;

	// 	           int nodeHdl = net->FindNode(nodeId);
	// 	           assert(nodeHdl >= 0);
	// 	           DSL_intArray orders;
	// 	           net->GetTemporalOrders(nodeHdl, orders);
		           
	// 	           dsMap[i].node   = nodeHdl;
	// 	           dsMap[i].slice  = atoi(idc + j + 1);
	// 	           dsMap[i].column = i;
		           
	// 	           std::cout << "dsMap[" << i << "].node   = " << nodeHdl           << std::endl;
	// 	           std::cout << "dsMap[" << i << "].slice  = " << atoi(idc + j + 1) << std::endl;
	// 	           std::cout << "dsMap[" << i << "].column = " << i                 << std::endl;
		           
	// 	           free(nodeId);
	// 	           done = true;
	// 	        }
	// 	    }
	// 	    if (!done) {
	// 	        int nodeHdl = net->FindNode(idc);
	// 	        assert(nodeHdl >= 0);
	// 	        dsMap[i].node   = nodeHdl;
	// 	        dsMap[i].slice  = 0;
	// 	        dsMap[i].column = i;
	// 	    }
	// 	}

	// 	// match states:

	// 	for (int i = 0; i < ds->GetNumberOfVariables(); i++) 
	// 	{
	// 	    DSL_datasetMatch &p = dsMap[i];
	// 	    int nodeHdl = p.node;

	// 	    DSL_nodeDefinition* def = net->GetNode(nodeHdl)->Definition();
	// 	    DSL_idArray* ids = def->GetOutcomesNames();
	// 	    const DSL_datasetVarInfo &varInfo = ds->GetVariableInfo(i);
	// 	    const std::vector<std::string> &stateNames = varInfo.stateNames;
	// 	    std::vector<int> map(stateNames.size(), -1);
	// 	    for (int j = 0; j < (int) stateNames.size(); j++)
	// 	    {
	// 	        const char* id = stateNames[j].c_str();
	// 	        for (int k = 0; k < ids->NumItems(); k++)
	// 	        {
	// 	            char* tmpid = (*ids)[k];
	// 	            if (!strcmp(id, tmpid))
	// 	                map[j] = k;
	// 	        }
	// 	    }
	// 	    for (int k = 0; k < ds->GetNumberOfRecords(); k++)
	// 	    {
	// 	        if (ds->GetInt(i, k) >= 0)
	// 	            ds->SetInt(i, k, map[ds->GetInt(i, k)]);
	// 	    }
	// 	}

	// 	// perform parameter learning
	// 	DSL_em em;
	// 	return em.Learn(*ds, *net, dsMap);
	// }

	int network_ReadFile(void * void_net, char *thisFile)
	{
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		return net->ReadFile(thisFile);
	}

	int network_WriteFile(void * void_net, char *thisFile)
	{
		/*
		DSL_network.WriteFile( char *thisFile, int fileType=0)
		Writes the contents of the network to file
		*/
		DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
		return net->WriteFile(thisFile);
	}

///////////////////////////////////////
//              DSL_NODE             //
///////////////////////////////////////

	int node_ChangeType(void * void_node, int newType)
	{
		DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
		return node->ChangeType(newType);
	}

	void * node_Definition(void * void_node)
	{
		DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
		DSL_nodeDefinition * nodeDef = node->Definition();
		void * retval = nodeDef;
		return retval;
	}

	void node_GetName(void * void_node, char * retval)
	{
		DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
		sprintf( retval, "%s", node->Info().Header().GetName() );
	}

	int node_Handle(void * void_node)
	{
		DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
		return node->Handle();
	}

	void * node_Network(void * void_node)
	{
		DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
		DSL_network * net = node->Network();
		void * retval = net;
		return retval;
	}

	void node_SetName(void * void_node, char * name )
	{
		DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
		node->Info().Header().SetName(name);
	}

	void * node_Value(void * void_node)
	{
		DSL_node * node = reinterpret_cast<DSL_node*>(void_node);
		DSL_nodeValue * nodeValue = node->Value();
		void * retval = nodeValue;
		return retval;
	}

///////////////////////////////////////
//          DSL_NODE_DEFINITION      //
///////////////////////////////////////

	void * nodedef_GetMatrix( void * void_nodedef )
	{
		DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
		DSL_Dmatrix * dmat = nodedef->GetMatrix();
		void * retval = dmat;
		return retval;	
	}

	int nodedef_SetDefinition( void * void_nodedef, void * void_doubleArray )
	{
		DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
		DSL_doubleArray * dblarr = reinterpret_cast<DSL_doubleArray*>(void_doubleArray);
		return nodedef->SetDefinition(*dblarr);
	}

	int nodedef_SetNumberOfOutcomes(void * void_nodedef, void * void_stringArray)
	{
		DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
		DSL_stringArray * strarr = reinterpret_cast<DSL_stringArray*>(void_stringArray);
		return nodedef->SetNumberOfOutcomes(*strarr);
	}

///////////////////////////////////////
//           DSL_NODE_VALUE          //
///////////////////////////////////////

	void * nodevalue_GetMatrix( void * void_nodeval )
	{
		DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
		DSL_Dmatrix * dmat = nodeval->GetMatrix();
		void * retval = dmat;
		return retval;	
	}

	int nodevalue_GetSize( void * void_nodeval )
	{
		DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
		return nodeval->GetSize();
	}

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

///////////////////////////////////////
//           DSL_STRING_ARRAY        //
///////////////////////////////////////

	void stringarray_Flush( void * void_strarr )
	{
		DSL_stringArray * strarr = reinterpret_cast<DSL_stringArray*>(void_strarr);
		strarr->Flush();
	}

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

///////////////////////////////////////
//         DSL_SYS_COORDINATES       //
///////////////////////////////////////

	void * createSysCoordinatesFromNodeDefinition( void * void_nodedef )
	{
		DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
		DSL_sysCoordinates * syscoord = new DSL_sysCoordinates( *nodedef );
		void * retval = syscoord;
		return retval;
	}

	void freeSysCoordinates( void * void_syscoord )
	{
		DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
		delete syscoord;
	}

	void syscoord_Next( void * void_syscoord )
	{
		DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
		syscoord->Next();
	}

	void syscoord_SetUncheckedValue( void * void_syscoord, double val )
	{
		DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
		syscoord->UncheckedValue() = val;
	}

///////////////////////////////////////
//             DSL_DATASET           //
///////////////////////////////////////

	void * createDataset()
	{
		DSL_dataset * dset = new DSL_dataset();
		void * retval = dset;
		return retval;
	}

	void freeDataset( void * void_dataset )
	{
		DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
		delete dset;
	}

	void dataset_discretize( void * void_dataset, int var, int nBins, char *statePrefix)
	{
		DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
		dset->Discretize(var, DSL_dataset::Hierarchical, nBins, statePrefix);
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

	int dataset_readFile( void * void_dataset, char * filename )
	{
		DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dataset);
		return dset->ReadFile(filename);
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