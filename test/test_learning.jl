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
	dset[0,0:n-1] = [0, 0, 1, 1, 0]
	dset[1,0:n-1] = [0, 0, 1, 1, 1]

	net = learn(dset)
	net2 = learn(dset, DSL_GreedyThickThinning)
	net3 = learn(dset, DSL_GreedyThickThinning, LearnParams_GreedyThickThinning() )
end