// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

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