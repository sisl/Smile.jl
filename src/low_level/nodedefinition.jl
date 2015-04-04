export
		get_matrix,
		get_outcome_names,
		set_definition,
		set_number_of_outcomes,
		is_nodetype_id
export DSL_DECISION, DSL_CHANCE, DSL_DETERMINISTIC, DSL_UTILITY, DSL_DISCRETE, DSL_CASTLOGIC,
	   DSL_DEMORGANLOGIC, DSL_NOISYMAXLOGIC, DSL_NOISYADDERLOGIC, DSL_PARENTSCONTIN,
	   DSL_SCC, DSL_DCHILDHPARENT, DSL_CONTINUOUS, DSL_TRUTHTABLE, DSL_CPT, DSL_NOISY_MAX,
	   DSL_NOISY_ADDER, DSL_CAST, DSL_DEMORGAN, DSL_LIST, DSL_TABLE, DSL_MAU, DSL_EQUATION,
	   DSL_EQUATION_SCC, DSL_DCHILD_HPARENT, DSL_DISTRIBUTION, DSL_HEQUATION, DSL_NO_DEFINITION

# -------------

const DSL_DECISION         = unsafe_load(cglobal((:EDSL_DECISION,        LIB_SMILE), Int32))
const DSL_CHANCE           = unsafe_load(cglobal((:EDSL_CHANCE,          LIB_SMILE), Int32))
const DSL_DETERMINISTIC    = unsafe_load(cglobal((:EDSL_DETERMINISTIC,   LIB_SMILE), Int32))
const DSL_UTILITY          = unsafe_load(cglobal((:EDSL_UTILITY,         LIB_SMILE), Int32))
const DSL_DISCRETE         = unsafe_load(cglobal((:EDSL_DISCRETE,        LIB_SMILE), Int32))
const DSL_CASTLOGIC        = unsafe_load(cglobal((:EDSL_CASTLOGIC,       LIB_SMILE), Int32))
const DSL_DEMORGANLOGIC    = unsafe_load(cglobal((:EDSL_DEMORGANLOGIC,   LIB_SMILE), Int32))
const DSL_NOISYMAXLOGIC    = unsafe_load(cglobal((:EDSL_NOISYMAXLOGIC,   LIB_SMILE), Int32))
const DSL_NOISYADDERLOGIC  = unsafe_load(cglobal((:EDSL_NOISYADDERLOGIC, LIB_SMILE), Int32))
const DSL_PARENTSCONTIN    = unsafe_load(cglobal((:EDSL_PARENTSCONTIN,   LIB_SMILE), Int32))
const DSL_SCC              = unsafe_load(cglobal((:EDSL_SCC,             LIB_SMILE), Int32))
const DSL_DCHILDHPARENT	   = unsafe_load(cglobal((:EDSL_DCHILDHPARENT,   LIB_SMILE), Int32))
const DSL_CONTINUOUS	   = unsafe_load(cglobal((:EDSL_CONTINUOUS,      LIB_SMILE), Int32))

const DSL_TRUTHTABLE       = unsafe_load(cglobal((:EDSL_TRUTHTABLE,      LIB_SMILE), Int32))
const DSL_CPT              = unsafe_load(cglobal((:EDSL_CPT,             LIB_SMILE), Int32))
const DSL_NOISY_MAX        = unsafe_load(cglobal((:EDSL_NOISY_MAX,       LIB_SMILE), Int32))
const DSL_NOISY_ADDER      = unsafe_load(cglobal((:EDSL_NOISY_ADDER,     LIB_SMILE), Int32))
const DSL_CAST             = unsafe_load(cglobal((:EDSL_CAST,            LIB_SMILE), Int32))
const DSL_DEMORGAN         = unsafe_load(cglobal((:EDSL_DEMORGAN,        LIB_SMILE), Int32))
const DSL_LIST             = unsafe_load(cglobal((:EDSL_LIST,            LIB_SMILE), Int32))
const DSL_TABLE            = unsafe_load(cglobal((:EDSL_TABLE,           LIB_SMILE), Int32))
const DSL_MAU              = unsafe_load(cglobal((:EDSL_MAU,             LIB_SMILE), Int32))
const DSL_EQUATION         = unsafe_load(cglobal((:EDSL_EQUATION,        LIB_SMILE), Int32))
const DSL_EQUATION_SCC     = unsafe_load(cglobal((:EDSL_EQUATION_SCC,    LIB_SMILE), Int32))
const DSL_DCHILD_HPARENT   = unsafe_load(cglobal((:EDSL_DCHILD_HPARENT,  LIB_SMILE), Int32))
const DSL_DISTRIBUTION     = unsafe_load(cglobal((:EDSL_DISTRIBUTION,    LIB_SMILE), Int32))
const DSL_HEQUATION        = unsafe_load(cglobal((:EDSL_HEQUATION,       LIB_SMILE), Int32))
const DSL_NO_DEFINITION    = unsafe_load(cglobal((:EDSL_NO_DEFINITION,   LIB_SMILE), Int32))

# -------------

function get_matrix( nodedef::NodeDefinition )
	ptr = ccall( (:nodedef_GetMatrix, LIB_SMILE), Ptr{Void}, (Ptr{Void},), nodedef.ptr )
	return DMatrix(ptr)
end

function get_outcome_names(nodedef::NodeDefinition)
	ptr = ccall( (:nodedef_GetOutcomeNames, LIB_SMILE), Ptr{Void}, (Ptr{Void},), nodedef.ptr )
	return IdArray(ptr)
end

get_type(nodedef::NodeDefinition) =
	ccall( (:nodedef_GetType, LIB_SMILE), Int32, (Ptr{Void},), nodedef.ptr)

set_definition( nodedef::NodeDefinition, dblarr::DoubleArray ) = 
	ccall( (:nodedef_SetDefinition, LIB_SMILE), Int32, (Ptr{Void},Ptr{Void}), nodedef.ptr, dblarr.ptr )

set_number_of_outcomes( nodedef::NodeDefinition, idarr::IdArray ) = 
	ccall( (:nodedef_SetNumberOfOutcomes_Names, LIB_SMILE), Int32, (Ptr{Void},Ptr{Void}), nodedef.ptr, idarr.ptr )
set_number_of_outcomes( nodedef::NodeDefinition, outcomeNumber::Integer ) = 
	ccall( (:nodedef_SetNumberOfOutcomes_Int, LIB_SMILE), Int32, (Ptr{Void},Cint), nodedef.ptr, outcomeNumber )
get_number_of_outcomes(nodedef::NodeDefinition) =
	ccall( (:nodedef_GetNumberOfOutcomes, LIB_SMILE), Int32, (Ptr{Void},), nodedef.ptr)

function is_nodetype_id( typeID::Integer )
	return typeID == DSL_CPT  || typeID == DSL_TRUTHTABLE ||
	       typeID == DSL_LIST || typeID == DSL_NOISY_MAX  ||
	       typeID == DSL_MAU  || typeID == DSL_TABLE
end