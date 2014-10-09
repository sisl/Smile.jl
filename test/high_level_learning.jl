

# increment_alphanumeric_string
pairs = [("a","b"),("z","aa"),("aa","ba"),("bb","cb"),("za","ab"),("zz","aaa")]
for pair in pairs
	@test Smile.increment_alphanumeric_string(pair[1]) == pair[2]
end

# test alphanumeric_names
@test alphanumeric_names(5)==["a","b","c","d","e"]
@test_throws ErrorException alphanumeric_names(0)

# test learn_bayesian_search + !
mat = rand(1:4, 5000, 4)
@test learn_bayesian_search( mat )[2]
net = Network()
@test learn_bayesian_search!( mat, net )
params = NetworkLearningParams()
@test learn_bayesian_search( mat, params )[2]
@test learn_bayesian_search!( mat, net, params )

# test setting params
params.maxparents           = 1
params.maxsearchtime        = 10
params.niterations          = 5
params.linkprobability      = 0.5
params.priorlinkprobability = 0.5
params.priorsamplesize      = 5000
params.seed                 = 1
push!(params.forced_arcs, (1,2))
push!(params.forbidden_arcs, (1,3))
@test learn_bayesian_search!( mat, net, params )