// SISL SMILE
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//          DSL_NODE_DEFINITION      //
///////////////////////////////////////

int EDSL_DECISION         = DSL_DECISION;
int EDSL_CHANCE           = DSL_CHANCE;         
int EDSL_DETERMINISTIC    = DSL_DETERMINISTIC;  
int EDSL_UTILITY          = DSL_UTILITY;        
int EDSL_DISCRETE         = DSL_DISCRETE;       
int EDSL_CASTLOGIC        = DSL_CASTLOGIC;      
int EDSL_DEMORGANLOGIC    = DSL_DEMORGANLOGIC;  
int EDSL_NOISYMAXLOGIC    = DSL_NOISYMAXLOGIC;  
int EDSL_NOISYADDERLOGIC  = DSL_NOISYADDERLOGIC;
int EDSL_PARENTSCONTIN    = DSL_PARENTSCONTIN;  
int EDSL_SCC              = DSL_SCC;            
int EDSL_DCHILDHPARENT	  = DSL_DCHILDHPARENT;
int EDSL_CONTINUOUS		  = DSL_CONTINUOUS;

int EDSL_TRUTHTABLE       = DSL_TRUTHTABLE;    
int EDSL_CPT              = DSL_CPT;           
int EDSL_NOISY_MAX        = DSL_NOISY_MAX;     
int EDSL_NOISY_ADDER      = DSL_NOISY_ADDER;   
int EDSL_CAST             = DSL_CAST;          
int EDSL_DEMORGAN         = DSL_DEMORGAN;      
int EDSL_LIST             = DSL_LIST;          
int EDSL_TABLE            = DSL_TABLE;         
int EDSL_MAU              = DSL_MAU;           
int EDSL_EQUATION         = DSL_EQUATION;      
int EDSL_EQUATION_SCC     = DSL_EQUATION_SCC;  
int EDSL_DCHILD_HPARENT   = DSL_DCHILD_HPARENT;
int EDSL_DISTRIBUTION     = DSL_DISTRIBUTION;  
int EDSL_HEQUATION        = DSL_HEQUATION;     
int EDSL_NO_DEFINITION    = DSL_NO_DEFINITION;


void * nodedef_GetMatrix( void * void_nodedef )
{
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	DSL_Dmatrix * dmat = nodedef->GetMatrix();
	void * retval = dmat;
	return retval;	
}

int nodedef_GetType( void * void_nodedef )
{
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	return nodedef->GetType();
}


void * nodedef_GetOutcomeNames( void * void_nodedef )
{
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	DSL_idArray * theNames = nodedef->GetOutcomesNames();
	void * retval = theNames;
	return retval;
}

int nodedef_SetDefinition( void * void_nodedef, void * void_doubleArray )
{
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	DSL_doubleArray * dblarr = reinterpret_cast<DSL_doubleArray*>(void_doubleArray);
	return nodedef->SetDefinition(*dblarr);
}

int nodedef_GetNumberOfOutcomes(void * void_nodedef)
{
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	return nodedef->GetNumberOfOutcomes();	
}

int nodedef_SetNumberOfOutcomes_Names(void * void_nodedef, void * void_stringArray)
{
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	DSL_stringArray * strarr = reinterpret_cast<DSL_stringArray*>(void_stringArray);
	return nodedef->SetNumberOfOutcomes(*strarr);
}

int nodedef_SetNumberOfOutcomes_Int(void * void_nodedef, int outcomeNumber)
{
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	return nodedef->SetNumberOfOutcomes(outcomeNumber);
}