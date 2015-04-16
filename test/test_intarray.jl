
arr = IntArray(4)
push!(arr, 1)
push!(arr, 2)
push!(arr, 3)
push!(arr, 4)
use_as_list(arr, 4)
@test size(arr) == 4

@test arr[0] == 1
@test arr[1] == 2
@test arr[2] == 3
@test arr[3] == 4

a = [1,2,3,4]
b = IntArray(a)
@test b[0] == 1
@test b[1] == 2
@test b[2] == 3
@test b[3] == 4
@test size(b) == 4

c = IntArray(arr)
@test b[0] == 1
@test b[1] == 2
@test b[2] == 3
@test b[3] == 4
@test size(c) == 4

d = to_native_int_array(c)
@test d[1] == 1
@test d[2] == 2
@test d[3] == 3
@test d[4] == 4
@test length(d) == 4

