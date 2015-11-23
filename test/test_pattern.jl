if true

	p = Pattern()
	@test get_size(p) == 0
	set_size(p, 3)
	@test get_size(p) == 3

	for i = 0 : 2, j = i+1 : 2
		@test get_edge(p, i, j) == DSL_EDGETYPE_NONE
		@test get_edge(p, j, i) == DSL_EDGETYPE_NONE
		@test has_directed_path(p, i, j) == false
		@test has_directed_path(p, j, i) == false
		@test has_incoming_edge(p, i) == false
		@test has_outgoing_edge(p, i) == false
	end

	@test has_cycle(p) == false
	@test is_DAG(p) == true

	set_edge(p, 0, 1, DSL_EDGETYPE_DIRECTED)
	set_edge(p, 1, 2, DSL_EDGETYPE_DIRECTED)
	@test is_DAG(p) == true
	@test has_directed_path(p, 0, 2) == true
	@test has_incoming_edge(p, 1) == true
	@test has_outgoing_edge(p, 1) == true

	set_edge(p, 2, 0, DSL_EDGETYPE_DIRECTED)
	@test is_DAG(p) == false

	@test get_parents(p, 0) == [2]
	@test get_parents(p, 1) == [0]
	@test get_parents(p, 2) == [1]
	@test get_children(p, 0) == [1]
	@test get_children(p, 1) == [2]
	@test get_children(p, 2) == [0]
	@test get_adjacent_nodes(p, 0) == [1,2]
	@test get_adjacent_nodes(p, 1) == [0,2]
	@test get_adjacent_nodes(p, 2) == [0,1]

	set_edge(p, 0, 2, DSL_EDGETYPE_DIRECTED)
	@test get_children(p, 0) == [1,2]

	p = Pattern()
	set_size(p, 3)
	set_edge(p, 0, 1, DSL_EDGETYPE_DIRECTED)
	set_edge(p, 0, 2, DSL_EDGETYPE_DIRECTED)
	set_edge(p, 1, 2, DSL_EDGETYPE_DIRECTED)
	net = Network()

	mat = round(Int, 3*rand(1000,3))
	dset = Dataset()
	add_int_var(dset, "A")
	add_int_var(dset, "B")
	add_int_var(dset, "C")
	set_number_of_records(dset, 1000)
	dset[0,0:999] = mat[:,1]
	dset[1,0:999] = mat[:,2]
	dset[2,0:999] = mat[:,3]

	to_network(p, dset, net)

	@test get_number_of_nodes(net) == 3
	@test get_parents(p, 0) == []
	@test get_parents(p, 1) == [0]
	@test get_parents(p, 2) == [0,1]
	@test get_children(p, 0) == [1,2]
	@test get_children(p, 1) == [2]
	@test get_children(p, 2) == []

	# test learning pattern
	# pat = Pattern()
	# n = 1000
	# mat = Array(Int, n, 2)
	# for i = 1 : n
	# 	a = rand(0:3)
	# 	b = clamp(a+rand(-1:1), 0, 3)
	# 	mat[i,:] = [a,b]
	# end

	# learn!(pat, Smile.matrix_to_dataset(mat), DSL_PC )

	# println("size: ", get_size(pat))
	# println("isdag: ", is_DAG(pat))
	# println("children 0: ", get_children(pat, 0))
	# println("children 1: ", get_children(pat, 1))

end
