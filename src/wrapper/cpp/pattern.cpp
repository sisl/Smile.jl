// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

///////////////////////////////////////
//              PATTERN              //
///////////////////////////////////////

int EDSL_EDGETYPE_NONE       = DSL_pattern::None;
int EDSL_EDGETYPE_UNDIRECTED = DSL_pattern::Undirected;
int EDSL_EDGETYPE_DIRECTED   = DSL_pattern::Directed;

void * createPattern() {
	DSL_pattern* pat = new DSL_pattern();
	void * retval = pat;
	return retval;
}
void freePattern( void * void_pattern ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	delete pat;
}
int pattern_getSize( void * void_pattern ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	return pat->GetSize();
}
void pattern_setSize( void * void_pattern, int size ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	pat->SetSize(size);
}
int pattern_getEdge( void * void_pattern, int from, int to ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	return int(pat->GetEdge(from, to));
}
void pattern_setEdge( void * void_pattern, int from, int to, int edgetype ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	DSL_pattern::EdgeType type = DSL_pattern::None;
	if (edgetype == int(DSL_pattern::Undirected))
		type = DSL_pattern::Undirected;
	else if (edgetype == int(DSL_pattern::Directed))
		type = DSL_pattern::Directed;
	pat->SetEdge(from, to, type);
}
bool pattern_hasDirectedPath( void * void_pattern, int from, int to ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	return pat->HasDirectedPath( from, to );
}
bool pattern_hasCycle( void * void_pattern ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	return pat->HasCycle();
}
bool pattern_isDAG( void * void_pattern ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	return pat->IsDAG();
}
bool pattern_toDAG( void * void_pattern ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	return pat->ToDAG();
}
void pattern_set( void * void_pattern, void * void_net ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	DSL_network * net = reinterpret_cast<DSL_network*>(void_net);
	pat->Set(*net);
}
bool pattern_toNetwork( void * void_pattern, void * void_dset, void * void_net ) {
	DSL_pattern * pat  = reinterpret_cast<DSL_pattern*>(void_pattern);
	DSL_dataset * dset = reinterpret_cast<DSL_dataset*>(void_dset);
	DSL_network * net  = reinterpret_cast<DSL_network*>(void_net);
	return pat->ToNetwork(*dset, *net);
}
bool pattern_hasIncomingEdge( void * void_pattern, int to ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	return pat->HasIncomingEdge(to);
}
bool pattern_hasOutgoingEdge( void * void_pattern, int from ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	return pat->HasOutgoingEdge(from);
}
void pattern_print( void * void_pattern ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	pat->Print();
}
int pattern_getAdjacentNodes( void * void_pattern, int node, int * arr ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	std::vector<int> adj;
	pat->GetAdjacentNodes(node, adj);
	for (unsigned i = 0; i < adj.size(); i++)
		arr[i] = adj[i];
	return (int)(adj.size());
}
int pattern_getParents( void * void_pattern, int node, int * arr ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	std::vector<int> par;
	pat->GetParents(node, par);
	for (unsigned i = 0; i < par.size(); i++)
		arr[i] = par[i];
	return (int)(par.size());
}
int pattern_getChildren( void * void_pattern, int node, int * arr ) {
	DSL_pattern * pat = reinterpret_cast<DSL_pattern*>(void_pattern);
	std::vector<int> child;
	pat->GetChildren(node, child);
	for (unsigned i = 0; i < child.size(); i++)
		arr[i] = child[i];
	return (int)(child.size());
}