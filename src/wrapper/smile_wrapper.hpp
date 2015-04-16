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
extern "C" int          network_FindNode(void * void_net, char *withThisId);
extern "C" int          network_GetNextNode( void * void_net, int ofThisNode );
extern "C" void *       network_GetNode(void * void_net, int theNode);
extern "C" int 			network_GetNumberOfNodes( void * void_net );
extern "C" int 	        network_IsAcyclic( void * void_net );
extern "C" int          network_LearnDynamicBayesianNetwork( void * void_net, void * void_dataset );
extern "C" int          network_ReadFile(void * void_net, char *thisFile);
extern "C" int          network_WriteFile(void * void_net, char *thisFile);
extern "C" void         network_SetDefaultBNAlgorithm(void * void_net, int theAlgorithm);
extern "C" void         network_SetDefaultIDAlgorithm(void * void_net, int theAlgorithm);
extern "C" void         network_SetDefaultHBNAlgorithm(void * void_net, int theAlgorithm);
extern "C" int          network_GetDefaultBNAlgorithm(void * void_net);
extern "C" int          network_GetDefaultIDAlgorithm(void * void_net);
extern "C" int          network_GetDefaultHBNAlgorithm(void * void_net);
extern "C" int          network_UpdateBeliefs(void * void_net);
extern "C" int          network_InvalidateAllBeliefs(void * void_net);
extern "C" int          network_CallIDAlgorithm(void * void_net);
extern "C" int          network_CallBNAlgorithm(void * void_net);
extern "C" int          network_CallEqAlgorithm(void * void_net);
extern "C" int          network_CallHBNAlgorithm(void * void_net);
extern "C" int          network_ClearAllEvidence(void * void_net);
extern "C" int          network_ClearAllDecision(void * void_net);
extern "C" int          network_ClearAllPropagatedEvidence(void * void_net);
extern "C" int          network_IsThereAnyEvidence(void * void_net);
extern "C" int          network_IsThereAnyDecision(void * void_net);
extern "C" void *       network_PartialOrdering(void * void_net);


///////////////////////////////////////
//            DSL_PATTERN            //
///////////////////////////////////////

extern "C" void *       createPattern();
extern "C" void         freePattern(void * void_pattern);
extern "C" int          pattern_getSize( void * void_pattern );
extern "C" void         pattern_setSize( void * void_pattern, int size );
extern "C" int          pattern_getEdge( void * void_pattern, int from, int to );
extern "C" void         pattern_setEdge( void * void_pattern, int from, int to, int edgetype );
extern "C" bool         pattern_hasDirectedPath( void * void_pattern, int from, int to );
extern "C" bool         pattern_hasCycle( void * void_pattern );
extern "C" bool         pattern_isDAG( void * void_pattern );
extern "C" bool         pattern_toDAG( void * void_pattern );
extern "C" void         pattern_set( void * void_pattern, void * void_net );
extern "C" bool         pattern_toNetwork( void * void_pattern, void * void_dset, void * void_net );
extern "C" bool         pattern_hasIncomingEdge( void * void_pattern, int to );
extern "C" bool         pattern_hasOutgoingEdge( void * void_pattern, int from );
extern "C" void         pattern_print( void * void_pattern );
extern "C" int          pattern_getAdjacentNodes( void * void_pattern, int node, int * arr );
extern "C" int          pattern_getParents( void * void_pattern, int node, int * arr );
extern "C" int          pattern_getChildren( void * void_pattern, int node, int * arr );

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
extern "C" int          nodedef_GetType( void * void_nodedef );
extern "C" void *       nodedef_GetOutcomeNames( void * void_nodedef );
extern "C" int          nodedef_SetDefinition( void * void_nodedef, void * void_doubleArray );
extern "C" int          nodedef_GetNumberOfOutcomes(void * void_nodedef);
extern "C" int          nodedef_SetNumberOfOutcomes_Names(void * void_nodedef, void * void_stringArray);
extern "C" int          nodedef_SetNumberOfOutcomes_Int(void * void_nodedef, int outcomeNumber);

///////////////////////////////////////
//           DSL_NODE_VALUE          //
///////////////////////////////////////

extern "C" void *       nodevalue_GetMatrix( void * void_nodeval );
extern "C" int          nodevalue_GetType( void * void_nodeval );
extern "C" int 			nodevalue_GetSize( void * void_nodeval );
extern "C" int          nodevalue_GetEvidence_Double( void * void_nodeval, double &evidence );
extern "C" int          nodevalue_GetEvidence_Int( void * void_nodeval );
extern "C" int          nodevalue_SetEvidence_Double( void * void_nodeval, double evidence );
extern "C" int          nodevalue_SetEvidence_Int( void * void_nodeval, int evidence );
extern "C" int          nodevalue_ClearEvidence(void * void_nodeval);

///////////////////////////////////////
//             DSL_INT_ARRAY         //
///////////////////////////////////////

extern "C" void *       createIntArray();
extern "C" void *       createIntArray_InitialSize(int initialSize);
extern "C" void *       createIntArray_Copy(void * void_intarr);
extern "C" void         freeIntArray( void * void_intarr );
extern "C" void         intarray_UseAsList( void * void_intarr, int nItems );
extern "C" int          intarray_NumItems( void * void_intarr );
extern "C" int          intarray_GetSize( void * void_intarr );
extern "C" int          intarray_GetIndex( void * void_intarr, int index );
extern "C" void         intarray_SetIndex( void * void_intarr, int index, int value );
extern "C" int          intarray_Insert( void * void_intarr, int here, int thisNumber );
extern "C" int          intarray_Add( void * void_intarr, int thisNumber );

///////////////////////////////////////
//             DSL_ID_ARRAY          //
///////////////////////////////////////
extern "C" void *       createIdArray();
extern "C" void         freeIdArray( void * void_idarr );
extern "C" int          idarray_Add( void * void_idarr, char *thisString );

///////////////////////////////////////
//           DSL_STRING_ARRAY        //
///////////////////////////////////////
extern "C" int          stringarray_FindPosition( void * void_strarr, char *ofThisString );
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
extern "C" void *       createSysCoordinatesFromNodeValue(void * void_nodeval );
extern "C" void         freeSysCoordinates( void * void_syscoord );
extern "C" void         syscoord_Next( void * void_syscoord );
extern "C" int          syscoord_GetIndex( void * void_syscoord, int index );
extern "C" void         syscoord_SetIndex( void * void_syscoord, int index, int value );
extern "C" double       syscoord_UncheckedValue(void * void_syscoord);
extern "C" void         syscoord_SetUncheckedValue( void * void_syscoord, double val );
extern "C" int          syscoord_GoTo( void * void_syscoord, int theIndex );
extern "C" void         syscoord_GoToCurrentPosition( void * void_syscoord );
extern "C" void         syscoord_LinkTo_DMatrix( void * void_syscoord, void * void_dmat );
extern "C" void         syscoord_LinkTo_NodeDefinition( void * void_syscoord, void * void_nodedef );
extern "C" void         syscoord_LinkTo_NodeValue( void * void_syscoord, void * void_nodeval );


///////////////////////////////////////
//             DSL_DATASET           //
///////////////////////////////////////
extern "C" void *       createDataset();
extern "C" void *       copyDataset( void * void_dataset );
extern "C" void         freeDataset( void * void_dataset );

extern "C" int          dataset_readFile( void * void_dataset, char * filename );
extern "C" int          dataset_readFile_withparams( void * void_dataset, char * filename, void * void_params );
extern "C" int          dataset_writeFile( void * void_dataset, char * filename );
extern "C" int          dataset_writeFile_withparams( void * void_dataset, char * filename, void * void_params );

extern "C" int          dataset_addIntVar( void * void_dataset, char *varName, int missingValue );
extern "C" int          dataset_addFloatVar( void * void_dataset, char *varName, float missingValue );
extern "C" int          dataset_removeVar( void * void_dataset, int var );
extern "C" void         dataset_addEmptyRecord( void * void_dataset );
extern "C" void         dataset_setNumberOfRecords( void * void_dataset, int numRecords );
extern "C" int          dataset_removeRecord( void * void_dataset, int rec );

extern "C" int          dataset_findVariable( void * void_dataset, char *id );
extern "C" int          dataset_getNumberOfVariables( void * void_dataset );
extern "C" int          dataset_getNumberOfRecords( void * void_dataset );

extern "C" int 	        dataset_getInt( void * void_dataset, int var, int rec );
extern "C" float 	    dataset_getFloat( void * void_dataset, int var, int rec );
extern "C" void         dataset_setInt( void * void_dataset, int var, int rec, int value );
extern "C" void         dataset_setFloat( void * void_dataset, int var, int rec, float value );
extern "C" void         dataset_setMissing( void * void_dataset, int var, int rec );
extern "C" int          dataset_getMissingInt( void * void_dataset, int var );
extern "C" float        dataset_getMissingFloat( void * void_dataset, int var );
extern "C" bool			dataset_isMissing( void * void_dataset, int var, int rec );
extern "C" bool			dataset_isDiscrete( void * void_dataset, int var );
extern "C" void         dataset_getIntData( void * void_dataset, int var, int * retval );
extern "C" void         dataset_getFloatData( void * void_dataset, int var, float * retval );
extern "C" void         dataset_getId( void * void_dataset, int var, char * str );
extern "C" int 	        dataset_setId( void * void_dataset, int var, char* newId);

extern "C" int          dataset_getNumStates( void * void_dataset, int var );
extern "C" void         dataset_getStateNames( void * void_dataset, int var, char** names );
extern "C" int	     	dataset_setStateNames( void * void_dataset, int var, char** newNames );

extern "C" bool         dataset_hasMissingData( void * void_dataset, int var );
extern "C" bool         dataset_isConstant( void * void_dataset, int var );

extern "C" void         dataset_discretize( void * void_dataset, int var, int nBins, char *statePrefix, int alg);
extern "C" void         dataset_discretize_withedges( void * void_dataset, int var, int nBins, char *statePrefix, double *edges);
extern "C" unsigned     dataset_discretize_getedges( void * void_dataset, int var, int nBins, char *statePrefix, int alg, double *binEdges);

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
//       DSL_DATASET_PARSEPARAMS     //
///////////////////////////////////////

extern "C" void *       createDatasetParseParams();
extern "C" void         freeDatasetParseParams( void * void_datasetpp );
extern "C" void         datasetparseparams_getMissingValueToken( void * void_datasetpp, char * retval );
extern "C" int          datasetparseparams_getMissingInt( void * void_datasetpp );
extern "C" float        datasetparseparams_getMissingFloat( void * void_datasetpp );
extern "C" bool         datasetparseparams_getColumnIdsPresent( void * void_datasetpp );
extern "C" void         datasetparseparams_setMissingValueToken( void * void_datasetpp, char * str );
extern "C" void         datasetparseparams_setMissingInt( void * void_datasetpp, int i );
extern "C" void         datasetparseparams_setMissingFloat( void * void_datasetpp, float f );
extern "C" void         datasetparseparams_setColumnIdsPresent( void * void_datasetpp, bool b );

///////////////////////////////////////
//       DSL_DATASET_WRITEPARAMS     //
///////////////////////////////////////

extern "C" void *       createDatasetWriteParams();
extern "C" void         freeDatasetWriteParams( void * void_datasetpp );
extern "C" void         datasetwriteparams_getMissingValueToken( void * void_datasetpp, char * retval );
extern "C" bool         datasetwriteparams_getColumnIdsPresent( void * void_datasetpp );
extern "C" bool         datasetwriteparams_getUseStateIndices( void * void_datasetpp );
extern "C" char         datasetwriteparams_getSeparator( void * void_datasetpp );
extern "C" void         datasetwriteparams_getFloatFormat( void * void_datasetpp, char * retval );
extern "C" void         datasetwriteparams_setMissingValueToken( void * void_datasetpp, char * str );
extern "C" void         datasetwriteparams_setColumnIdsPresent( void * void_datasetpp, bool b );
extern "C" void         datasetwriteparams_setUseStateIndices( void * void_datasetpp, bool b );
extern "C" void         datasetwriteparams_setSeparator( void * void_datasetpp, char c );
extern "C" void         datasetwriteparams_setFloatFormat( void * void_datasetpp, char * str );

///////////////////////////////////////
//             DSL_DMATRIX           //
///////////////////////////////////////

extern "C" double       dmatrix_GetAtCoord( void * void_dmat, int * theCoordinates, unsigned len );
extern "C" double       dmatrix_GetAtInd( void * void_dmat, int index );
extern "C" void         dmatrix_SetAtInd( void * void_dmat, int index, double value );
extern "C" int 			dmatrix_GetNumberOfDimensions( void * void_dmat );
extern "C" int 			dmatrix_GetSize( void * void_dmat );
extern "C" int          dmatrix_GetSizeOfDimension( void * void_dmat, int aDimension );
extern "C" int          dmatrix_CoordinatesToIndex( void * void_dmat, void * void_intarr );

///////////////////////////////////////
//             LEARNING              //
///////////////////////////////////////

extern "C" bool			dataset_learnBayesianSearch( void * void_dataset, void * void_net, int max_parents, int max_search_time, int n_iterations, double link_probability, double prior_link_probability, int prior_sample_size, int seed, int * forcedarcs, int n_forcedarcs, int * forbiddenarcs, int n_forbiddenarcs, int * tiers, int lentiers );
extern "C" bool			dataset_learnGreedyThickThinning( void * void_dataset, void * void_net, int priors, int maxParents, double netWeight, int * forcedarcs, int n_forcedarcs, int * forbiddenarcs, int n_forbiddenarcs, int * tiers, int lentiers );
extern "C" bool	        dataset_learnNaiveBayes( void * void_dataset, void * void_net, char * classVariableId );
extern "C" bool	        dataset_learnPC( void * void_dataset, void * void_pat, unsigned long maxcache, int maxAdjacency, int maxSearchTime, double significance, int * forcedarcs, int n_forcedarcs, int * forbiddenarcs, int n_forbiddenarcs, int * tiers, int lentiers );
extern "C" bool         dataset_learnTAN( void * void_dataset, void * void_net, char * classvar, int maxSearchTime, unsigned int seed, unsigned long maxcache );

#endif