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
end