#include "smile_wrapper.hpp"

#include "lib/smile.h"
#include "lib/smilearn.h"
#include <cstring>
#include <sstream>
#include <iostream>
#include <vector>

#include "cpp/util.cpp"
#include "cpp/network.cpp"
#include "cpp/node.cpp"
#include "cpp/node_definition.cpp"
#include "cpp/node_value.cpp"
#include "cpp/id_array.cpp"
#include "cpp/string_array.cpp"
#include "cpp/double_array.cpp"
#include "cpp/sys_coordinates.cpp"
#include "cpp/dataset.cpp"
#include "cpp/dataset_varinfo.cpp"
#include "cpp/matrix.cpp"

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