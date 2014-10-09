// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: 09/13/2014
// Stanford Intelligence Systems Laboratory

#ifndef _SMILE_WRAPPER_H_
#define _SMILE_WRAPPER_H_

///////////////////////////////////////
//              UTILITY              //
///////////////////////////////////////

extern "C" bool         libexists() { return true; }
extern "C" int          getNodeTypeID(char * typeName);
extern "C" void         discretize( float * data, unsigned datalen, int nBins, double *binEdges, int *discretized );

///////////////////////////////////////
//            DSL_NETWORK            //
///////////////////////////////////////

extern "C" void *       createNetwork();
extern "C" void         freeNetwork(void * void_net);
extern "C" int          network_AddArc(void * void_net, int theParent, int theChild);
extern "C" int          network_AddNode(void * void_net, int thisType, char *thisId, char *exception);
extern "C" void         network_GetChildren(void * void_net, int ofThisNode, int * childHandles, unsigned * len);
extern "C" int 			network_GetFirstNode( void * void_net );
extern "C" void         network_GetParents(void * void_net, int ofThisNode, int * parentHandles, unsigned  * len);
extern "C" int          network_GetNextNode( void * void_net, int ofThisNode );
extern "C" void *       network_GetNode(void * void_net, int theNode);
extern "C" int 			network_GetNumberOfNodes( void * void_net );
extern "C" int 	        network_IsAcyclic( void * void_net );
extern "C" int          network_LearnDynamicBayesianNetwork( void * void_net, void * void_dataset );
extern "C" int          network_ReadFile(void * void_net, char *thisFile);
extern "C" int          network_WriteFile(void * void_net, char *thisFile);

///////////////////////////////////////
//              DSL_NODE             //
///////////////////////////////////////

extern "C" int          node_ChangeType(void * void_node, int newType);
extern "C" void *       node_Definition(void * void_node);
extern "C" void 		node_GetName(void * void_node, char * retval);
extern "C" int          node_Handle(void * void_node);
extern "C" void *       node_Network(void * void_node);
extern "C" void         node_SetName(void * void_node, char * name );
extern "C" void *       node_Value(void * void_node);

///////////////////////////////////////
//          DSL_NODE_DEFINITION      //
///////////////////////////////////////

extern "C" void *       nodedef_GetMatrix( void * void_nodedef );
extern "C" int          nodedef_SetDefinition( void * void_nodedef, void * void_doubleArray );
extern "C" int          nodedef_SetNumberOfOutcomes(void * void_nodedef, void * void_stringArray);

///////////////////////////////////////
//           DSL_NODE_VALUE          //
///////////////////////////////////////

extern "C" void *       nodevalue_GetMatrix( void * void_nodeval );
extern "C" int 			nodevalue_GetSize( void * void_nodeval );

///////////////////////////////////////
//             DSL_ID_ARRAY          //
///////////////////////////////////////
extern "C" void *       createIdArray();
extern "C" void         freeIdArray( void * void_idarr );
extern "C" int          idarray_Add( void * void_idarr, char *thisString );

///////////////////////////////////////
//           DSL_STRING_ARRAY        //
///////////////////////////////////////
extern "C" void         stringarray_Flush( void * void_strarr );

///////////////////////////////////////
//           DSL_DOUBLE_ARRAY        //
///////////////////////////////////////
extern "C" void *       createDoubleArray();
extern "C" void         freeDoubleArray( void * void_dblarr );
extern "C" double       doublearray_At( void * void_dblarr, int index, char *exception );
extern "C" int          doublearray_GetSize( void * void_dblarr );
extern "C" void         doublearray_SetAt( void * void_dblarr, int index, double value, char *exception );
extern "C" int          doublearray_SetSize( void * void_dblarr, int thisSize );

///////////////////////////////////////
//         DSL_SYS_COORDINATES       //
///////////////////////////////////////
extern "C" void *       createSysCoordinatesFromNodeDefinition( void * void_nodedef );
extern "C" void         freeSysCoordinates( void * void_syscoord );
extern "C" void         syscoord_Next( void * void_syscoord );
extern "C" void         syscoord_SetUncheckedValue( void * void_syscoord, double val );

///////////////////////////////////////
//             DSL_DATASET           //
///////////////////////////////////////
extern "C" void *       createDataset();
extern "C" void         freeDataset( void * void_dataset );
extern "C" void         dataset_addFloatVar( void * void_dataset, char *varName );
extern "C" void         dataset_discretize( void * void_dataset, int var, int nBins, char *statePrefix);
extern "C" unsigned     dataset_discretize_getedges( void * void_dataset, int var, int nBins, char *statePrefix, double *binEdges);
extern "C" float 	    dataset_getFloat( void * void_dataset, int var, int rec );
extern "C" int 	        dataset_getInt( void * void_dataset, int var, int rec );
extern "C" int          dataset_getNumberOfRecords( void * void_dataset );
extern "C" int          dataset_getNumberOfVariables( void * void_dataset );
extern "C" void         dataset_getVariableInfo( void * void_dataset, void * void_datasetvi, unsigned index );
extern "C" bool			dataset_isDiscrete( void * void_dataset, int var );
extern "C" bool			dataset_isMissing( void * void_dataset, int var, int rec );
extern "C" bool			dataset_learnBayesianSearch( void * void_dataset, void * void_net, int max_parents, int max_search_time, int n_iterations, double link_probability, double prior_link_probability, int prior_sample_size, int seed, int * forcedarcs, int n_forcedarcs, int * forbiddenarcs, int n_forbiddenarcs, int * tiers, int lentiers );
extern "C" bool         dataset_learnDBN( void * void_dataset, void * void_net, int max_parents, int max_search_time, int n_iterations, double link_probability, double prior_link_probability, int prior_sample_size, int seed );
extern "C" bool			dataset_learnGreedyThickThinning( void * void_dataset, void * void_net );
extern "C" int          dataset_readFile( void * void_dataset, char * filename );
extern "C" void         dataset_removeVar( void * void_dataset, int var );
extern "C" void         dataset_setNumberOfRecords( void * void_dataset, int nRecords );
extern "C" void         dataset_setFloat( void * void_dataset, int var, int rec, float value );
extern "C" int 	        dataset_setId( void * void_dataset, int var, char* newId);
extern "C" bool			dataset_setStateNames( void * void_dataset, int var, char** newNames, unsigned nNames );
extern "C" int          dataset_writeFile( void * void_dataset, char * filename );

///////////////////////////////////////
//         DSL_DATASET_VARINFO       //
///////////////////////////////////////

extern "C" void *       createDatasetVarInfo();
extern "C" void         freeDatasetVarInfo( void * void_datasetvi );
extern "C" bool         datasetvarinfo_getDiscrete( void * void_datasetvi );
extern "C" void         datasetvarinfo_getId( void * void_datasetvi, char *id );
extern "C" int          datasetvarinfo_getMissingInt( void * void_datasetvi );
extern "C" float        datasetvarinfo_getMissingFloat( void * void_datasetvi );
extern "C" unsigned     datasetvarinfo_getStateNamesSize( void * void_datasetvi );
extern "C" bool         datasetvarinfo_getStateNameAt( void * void_datasetvi, char *stateName, unsigned index );

///////////////////////////////////////
//             DSL_DMATRIX           //
///////////////////////////////////////

extern "C" double       dmatrix_GetAtCoord( void * void_dmat, int * theCoordinates, unsigned len );
extern "C" double       dmatrix_GetAtInd( void * void_dmat, int index );
extern "C" int 			dmatrix_GetNumberOfDimensions( void * void_dmat );
extern "C" int 			dmatrix_GetSize( void * void_dmat );
extern "C" int          dmatrix_GetSizeOfDimension( void * void_dmat, int aDimension );

#endif