export
		NetworkLearningParams,
		matrix_to_dataset,
		learn_bayesian_search,
		learn_bayesian_search!,
		alphanumeric_names

# ----------
# types

type NetworkLearningParams
	maxparents           :: Int            # limits the maximum number of parents a node can have
	maxsearchtime        :: Int            # maximum runtime of the algorithm [seconds?] (0 = infinite)
	niterations          :: Int            # number of searches (and indirectly number of random restarts)
    linkprobability      :: Float64        # defines the probabilty of having an arc between two nodes
    priorlinkprobability :: Float64        # defines a prior existence of an arc between two nodes
    priorsamplesize      :: Int            # influences the "strength" of prior link probability.
    seed                 :: Int            # random seed (0=none)
    forced_arcs          :: Vector{Tuple}  # a list of (i->j) arcs which are forced to be in the network
    forbidden_arcs       :: Vector{Tuple}  # a list of (i->j) arcs which are forbidden in the network
    tiers                :: Vector{Tuple}  # a list of (i->tier) associating nodes with a particular tier

    NetworkLearningParams() = new(5, 0, 20, 0.1, 0.001, 50, 0, Array(Tuple,0), Array(Tuple,0), Array(Tuple,0))
end

# ----------
# functions

function learn_bayesian_search!( dset::Dataset, net::Network, params::NetworkLearningParams )
	return learn_bayesian_search!( dset, net,
		maxparents           = params.maxparents,
		maxsearchtime        = params.maxsearchtime,
		niterations          = params.niterations,
    	linkprobability      = params.linkprobability, 
    	priorlinkprobability = params.priorlinkprobability,
    	priorsamplesize      = params.priorsamplesize, 
    	seed                 = params.seed, 
    	forced_arcs          = params.forced_arcs,
    	forbidden_arcs       = params.forbidden_arcs, 
    	tiers                = params.tiers 
	    )
end
function learn_bayesian_search( mat::Matrix{Int} )
	dset = matrix_to_dataset(mat)
	net  = Network()
	worked = learn_bayesian_search!( dset, net )
	(net, worked)
end
function learn_bayesian_search( mat::Matrix{Int}, params::NetworkLearningParams )
	dset = matrix_to_dataset(mat)
	net  = Network()
	worked = learn_bayesian_search!( dset, net, params )
	(net, worked)
end
function learn_bayesian_search!( mat::Matrix{Int}, net::Network )
	dset = matrix_to_dataset(mat)
	return learn_bayesian_search!( dset, net )
end
function learn_bayesian_search!( mat::Matrix{Int}, net::Network, params::NetworkLearningParams )
	dset = matrix_to_dataset(mat)
	return learn_bayesian_search!( dset, net, params )
end

function matrix_to_dataset{R <: Real, S<:String}( mat::Matrix{R}, names::Vector{S}=alphanumeric_names(size(mat,2)) )
	# converts a Matrix{Int} to a Dataset by writing it to a tempfile and loading it back in
	ftempname = tempname()
	writetable(ftempname, mat, names)
	dset = Dataset()
	if !read_file(dset, ftempname)
		error("Could not read data file $ftempname")
	end
	rm(ftempname)
	dset
end

function writetable{R <: Real, S<:String}(filename::String, mat::Matrix{R}, names::Vector{S}; separator::Char='\t')
	n,m = size(mat)
	f = open(filename, "w")
	
	for name in names[1:end-1]
		@printf(f, "%s%c", name, separator)
	end
	@printf(f, "%s\n", names[end])

	if isa(R, Integer)
		for i = 1 : n
			for j = 1 : m-1
				@printf(f, "%d%c", mat[i,j], separator)
			end
			@printf(f, "%d\n", mat[i,m])
		end
	else
		for i = 1 : n
			for j = 1 : m-1
				@printf(f, "%f%c", mat[i,j], separator)
			end
			@printf(f, "%f\n", mat[i,m])
		end
	end

	close(f)
end

function increment_alphanumeric_string(n,i=1)
	if i > length(n)
		n = "a"^i
	elseif n[i] != 'z'
		n = n[1:i-1]*string(n[i]+1)*n[i+1:end]
	else
		n = increment_alphanumeric_string(n[1:i-1]*"a"*n[i+1:end], i+1)
	end
	n
end
function alphanumeric_names(n::Int)
	# generate the first n lexographic names
	# a,b,c,...,z,aa,ab,...
	@assert(n > 0)
	names = Array(String, n)
	names[1] = "a"
	for i = 2 : n
		names[i] = increment_alphanumeric_string(names[i-1])
	end
	names
end