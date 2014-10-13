using Smile
using Base.Test

function test_vec_approx_equal{T<:Real}(a::Vector{T}, b::Vector{T})
	@test length(a) == length(b)
	for i = 1 : length(a)
		@test isapprox(a[i], b[i])
	end
	true
end
function test_vec_approx_equal{T<:Real}(a::Vector{T}, b::Vector{T}, tol::Float64)
	@test length(a) == length(b)
	for i = 1 : length(a)
		@test isapprox(a[i], b[i], tol)
	end
	true
end

# write your own tests here
include("test_dataset.jl")
# include("tut1_create_a_bayesian_network.jl")
# include("high_level_learning.jl")

