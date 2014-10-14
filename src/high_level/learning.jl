export  alphanumeric_names

# ----------
# types

# ----------
# functions

function learn( mat::Matrix{Int} )
	dset = matrix_to_dataset(mat)
	net  = Network()
	worked = learn!( net, dset, DSL_BayesianSearch )
	(net, worked)
end
function learn( mat::Matrix{Int}, params )
	dset = matrix_to_dataset(mat)
	net  = Network()
	
	alg  = DSL_BayesianSearch
	if isa(params,LearnParams_GreedyThickThinning)
		alg - DSL_GreedyThickThinning
	end

	worked = learn!( net, dset, alg, params=params )
	(net, worked)
end
function learn( mat::Matrix{Int}, alg, params )
	dset = matrix_to_dataset(mat)
	net  = Network()
	worked = learn!( net, dset, alg, params=params )
	(net, worked)
end
function learn!( mat::Matrix{Int}, net::Network )
	dset = matrix_to_dataset(mat)
	return learn!( net, dset, DSL_BayesianSearch )
end
function learn!( mat::Matrix{Int}, net::Network, alg, params )
	dset = matrix_to_dataset(mat)
	return learn!( net, dset, alg, params=params )
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