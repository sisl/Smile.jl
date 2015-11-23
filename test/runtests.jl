using Smile
using Base.Test

function test_vec_approx_equal{T<:Real, S<:Real}(a::Vector{T}, b::Vector{S})
	@test length(a) == length(b)
	for i = 1 : length(a)
		@test isapprox(a[i], b[i])
	end
	true
end
function test_vec_approx_equal{T<:Real, S<:Real}(a::Vector{T}, b::Vector{S}, tol::Float64)
	@test length(a) == length(b)
	for i = 1 : length(a)
		@test abs(a[i] - b[i]) < tol
	end
	true
end

# write your own tests here
include("test_intarray.jl")
include("test_pattern.jl")
include("test_dataset.jl")
include("test_learning.jl")
include("test_sampling.jl")
include("tut1_create_a_bayesian_network.jl")
include("high_level_learning.jl")
