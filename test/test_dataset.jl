# let

	mat = [0.0 0.1 0.2 0.3]'
	dset = Dataset()
	indA = 0

	add_float_var(dset, "A")
	@test get_number_of_variables(dset) == 1
	@test !is_discrete(dset, indA)
	@test get_id(dset, indA) == "A"
	set_id(dset, indA, "Bubba")
	@test get_id(dset, indA) == "Bubba"
	set_id(dset, indA, "A")


	set_number_of_records(dset, length(mat))
	@test get_number_of_records(dset) == length(mat)

	for (i,v) in enumerate(mat)
		set_float(dset, indA, i-1, v)
	end
	for (i,v) in enumerate(mat)
		@test isapprox(get_float(dset, indA, i-1), v, atol=1e-8)
	end

	test_vec_approx_equal( dset[indA, 0:2], [0.0, 0.1, 0.2], 1e-7 )
	test_vec_approx_equal( dset[indA], [0.0, 0.1, 0.2, 0.3], 1e-7 )
	@test has_missing_data( dset, indA ) == false
	@test is_constant( dset, indA ) == false

	# add and remove a variable
	add_float_var(dset, "B")
	@test get_number_of_variables(dset) == 2
	remove_var(dset, 1)
	@test get_number_of_variables(dset) == 1
	for (i,v) in enumerate(mat)
		@test isapprox(get_float(dset, indA, i-1), v, atol=1e-8)
	end

	# create a dset copy
	dset2 = Dataset(dset)
	@test get_number_of_variables(dset2) == 1
	@test !is_discrete(dset2, indA)
	for (i,v) in enumerate(mat)
		@test isapprox(get_float(dset2, indA, i-1), v, atol=1e-8)
	end

	# test DatasetParseParams
	pp = DatasetParseParams()
	@test_throws ErrorException pp[:sadasdf]
	@test getindex(pp, :columnIdsPresent) == true
	@test pp[:missingValueToken] == "*"
	@test pp[:missingInt] == -1
	@test isnan(pp[:missingFloat])
	@test pp[:columnIdsPresent] == true
	setindex!(pp, "h", :missingValueToken)
	@test pp[:missingValueToken] == "h"
	pp[:missingInt] = 5
	@test pp[:missingInt] == 5
	pp[:missingFloat] = 1.2
	@test isapprox(pp[:missingFloat], 1.2, atol=1e-7)
	pp[:columnIdsPresent] = false
	@test pp[:columnIdsPresent] == false
	@test_throws ErrorException pp[:sadasdf]=5
	@test_throws AssertionError pp[:missingValueToken]=5

	# test DatasetWriteParams
	wp = DatasetWriteParams()
	@test_throws ErrorException pp[:sadasdf]
	@test getindex(wp, :columnIdsPresent) == true
	@test wp[:useStateIndices] == false
	@test wp[:separator] == '\t'
	@test wp[:missingValueToken] == "*"
	@test wp[:floatFormat] == "%g"
	wp[:columnIdsPresent] = false
	@test wp[:columnIdsPresent] == false
	wp[:useStateIndices] = true
	@test wp[:useStateIndices] == true
	wp[:separator] = ' '
	@test wp[:separator] == ' '
	wp[:missingValueToken] = "howaboutthat"
	@test wp[:missingValueToken] == "howaboutthat"
	wp[:floatFormat] = "%.3f"
	@test wp[:floatFormat] == "%.3f"

	dset3 = Dataset()
	write_file( dset, "out.dat" )
	@test isfile("out.dat")
	read_file( dset3, "out.dat" )
	rm("out.dat")
	@test get_number_of_variables(dset3) == 1
	@test !is_discrete(dset3, indA)
	for (i,v) in enumerate(mat)
		@test isapprox(get_float(dset3, indA, i-1), v, atol=1e-8)
	end

	dset4 = Dataset()
	write_file( dset, "out.dat", wp )
	read_file( dset4, "out.dat", pp )
	@test get_number_of_variables(dset4) == 1
	@test !is_discrete(dset4, indA)
	for (i,v) in enumerate(mat)
		@test isapprox(get_float(dset4, indA, i-1), v, atol=1e-8)
	end
	rm("out.dat")

	# ------------

	@test find_variable(dset, "A") == 0

	indB = 1
	add_int_var(dset, "B")
	for (i,v) in enumerate([0,1,0,2])
		set_int(dset, indB, i-1, v)
	end
	@test get_int_data(dset, indB) == [0, 1, 0, 2]
	test_vec_approx_equal( get_float_data(dset, indA), [0.0, 0.1, 0.2, 0.3], 1e-7 )

	# discretize
	discretize( dset, indA, 2, statePrefix="state", algorithm=DSL_DISCRETIZE_UNIFORMWIDTH )
	test_vec_approx_equal( dset[indA], [0,0,1,1], 1e-7 )

	indC = 2
	add_float_var( dset, "C" )
	dset[indC,0:3] = [0.0, 0.3, 0.2, 0.1]
	test_vec_approx_equal( dset[indC], [0.0, 0.3, 0.2, 0.1], 1e-7 )
	discretize( dset, indC, 2, algorithm=DSL_DISCRETIZE_UNIFORMCOUNT, edges=[0.05, 5.05, 5.15] )
	test_vec_approx_equal( dset[indC], [0, 1, 1, 1], 1e-7 )

	indD = 3
	add_float_var( dset, "D" )
	dset[indD,0:3] = [0.0, 0.3, 0.2, 0.1]
	test_vec_approx_equal( dset[indD], [0.0, 0.3, 0.2, 0.1], 1e-7 )
	edges = discretize_with_info( dset, indD, 2 )
	test_vec_approx_equal( dset[indD], [0, 1, 1, 0], 1e-7 )


# end
