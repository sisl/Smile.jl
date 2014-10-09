// SMILE.JL
// A C library wrapper for SMILE (Structural Modeling, Inference, and Learning Engine)
// so that users may call SMILE functions through Julia
//
// author: Tim Wheeler
// date: October 2014
// Stanford Intelligence Systems Laboratory

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


