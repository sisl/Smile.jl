if true

	dset = Dataset()
	indA = 0
	add_int_var(dset, "A")
	add_int_var(dset, "B")

	mat = [0 0;
	       0 0;
	       1 1;
	       1 1;
	       0 1]
	n,m = size(mat)
	set_number_of_records(dset, n)
	dset[0,0:n-1] = mat[:,1]
	dset[1,0:n-1] = mat[:,2]

	net1 = learn(dset, DSL_BayesianSearch)
	net2 = learn(dset, DSL_GreedyThickThinning)
	net3 = learn(dset, LearnParams_GreedyThickThinning() )
	net4 = learn(dset, LearnParams_PC() )
	net5 = learn(dset, LearnParams_NaiveBayes("A") )
	net6 = learn(dset, LearnParams_TreeAugmentedNaiveBayes("A") )
	
end