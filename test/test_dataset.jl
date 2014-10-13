
if true # create local scope

	mat = [0.0 0.1 0.2 0.3]'
	dset = Dataset()
	indA = 0

	add_float_var(dset, "A")
	@test get_number_of_variables(dset) == 1
	@test !is_discrete(dset, indA)
	

	set_number_of_records(dset, length(mat))
	@test get_number_of_records(dset) == length(mat)

	for (i,v) in enumerate(mat)
		set_float(dset, indA, i-1, v)
	end
	for (i,v) in enumerate(mat)
		@test isapprox(get_float(dset, indA, i-1), v)
	end

	# add and remove a variable
	add_float_var(dset, "B")
	@test get_number_of_variables(dset) == 2
	remove_var(dset, 1)
	@test get_number_of_variables(dset) == 1
	for (i,v) in enumerate(mat)
		@test isapprox(get_float(dset, indA, i-1), v)
	end

	# create a dset copy
	dset2 = Dataset(dset)
	@test get_number_of_variables(dset) == 1
	@test !is_discrete(dset, indA)
	for (i,v) in enumerate(mat)
		@test isapprox(get_float(dset, indA, i-1), v)
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
	@test isapprox(pp[:missingFloat], 1.2)
	pp[:columnIdsPresent] = false
	@test pp[:columnIdsPresent] == false
	@test_throws ErrorException pp[:sadasdf]=5
	@test_throws ErrorException pp[:missingValueToken]=5

end