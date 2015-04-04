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
void * createSysCoordinatesFromNodeValue( void * void_nodeval )
{
	DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
	DSL_sysCoordinates * syscoord = new DSL_sysCoordinates( *nodeval );
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

int syscoord_GetIndex( void * void_syscoord, int index )
{
	DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
	DSL_sysCoordinates syscoord2 = (*syscoord);
	return syscoord2[index];
}
void syscoord_SetIndex( void * void_syscoord, int index, int value )
{
	DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
	(*syscoord)[index] = value;
}
 
double syscoord_UncheckedValue(void * void_syscoord)
{
	DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
	return syscoord->UncheckedValue();
}

void syscoord_SetUncheckedValue( void * void_syscoord, double val )
{
	DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
	syscoord->UncheckedValue() = val;
}

int syscoord_GoTo( void * void_syscoord, int theIndex )
{
	DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
	return syscoord->GoTo(theIndex);
}

void syscoord_GoToCurrentPosition( void * void_syscoord )
{
	DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
	syscoord->GoToCurrentPosition();
}

void syscoord_LinkTo_DMatrix( void * void_syscoord, void * void_dmat )
{
	DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
	DSL_Dmatrix * dmat = reinterpret_cast<DSL_Dmatrix*>(void_dmat);
	syscoord->LinkTo(*dmat);
}
void syscoord_LinkTo_NodeDefinition( void * void_syscoord, void * void_nodedef )
{
	DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
	DSL_nodeDefinition * nodedef = reinterpret_cast<DSL_nodeDefinition*>(void_nodedef);
	syscoord->LinkTo(*nodedef);
}
void syscoord_LinkTo_NodeValue( void * void_syscoord, void * void_nodeval )
{
	DSL_sysCoordinates * syscoord = reinterpret_cast<DSL_sysCoordinates*>(void_syscoord);
	DSL_nodeValue * nodeval = reinterpret_cast<DSL_nodeValue*>(void_nodeval);
	syscoord->LinkTo(*nodeval);
}