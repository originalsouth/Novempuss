### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 2ef771b6-df87-11ee-2477-37c04af15b58
using Pkg

# ╔═╡ 26df969e-27b3-49ac-a37f-1d439645116d
Pkg.develop(url = abspath(".."))

# ╔═╡ 7456e50c-0900-41f7-8fed-8f6bda71c3c4
using Revise

# ╔═╡ 2fee6654-bc9b-4259-9046-38a4d5e97a8d
using Novempuss

# ╔═╡ 57a8a94b-6f05-4e56-9a89-79534287f140
using SimpleWeightedGraphs

# ╔═╡ 2f8b47ee-e8f6-4e23-b59c-533d8e229484
using PlotGraphviz

# ╔═╡ fcc70739-c2e0-41f8-8c3d-9a0d54ee082a
abstract type Letter end

# ╔═╡ d44f8ec5-6c66-48a1-9f69-b429fc6b614d
value(x::T) where T <: Letter = x.value

# ╔═╡ f6a0e784-6cdd-43d2-b000-7409bbdab268
for lt in [:A, :B, :C, :D]
	@eval begin
		struct $lt <: Letter value::String end
		$lt() = $lt(string($lt))
	end
end

# ╔═╡ feb63206-dd03-4e33-9ef8-9fb3a5b1babc
function plot(g::Novempuss.Graphlet)
	swdg = SimpleWeightedDiGraph(reverse(Novempuss.graph(g)))
	coldict = Dict(A => "red", B => "blue", C => "green")
	attrs = GraphvizAttributes(swdg)
	for (i, obj) in Iterators.Enumerate(Novempuss.nodes(g))
		set!(attrs.nodes, i, Property("label", value(obj)))
		set!(attrs.nodes, i, Property("color", coldict[typeof(obj)]))
	end
	set!(attrs.node_options, "shape", "circle")
	plot_graphviz(swdg, attrs; scale = 1000)
end

# ╔═╡ f6da476e-209c-4928-9766-2ef13cd461d8
function algealsystem(x::A)
    val = parse(Int, value(x))
    if val < 10
        newval = string(val+1)
        return [A(newval), B(newval)]
    else
        nothing
    end
end

# ╔═╡ 80db3000-88e1-4d40-b175-5df34287a9f1
function algealsystem(x::B)
    val = parse(Int, value(x))
    if val < 10
        newval = string(val+1)
        return [A(newval), C(newval)]
    else
        nothing
    end
end

# ╔═╡ 9b5e733f-9bcf-4760-bfc3-616c2e1adb9f
lg = LogicalGraph{Letter}(algealsystem)

# ╔═╡ 610db448-9d1e-46b3-8a73-d4b7896ba7ac
push!(lg, Letter[A("1")])

# ╔═╡ 8a22dbc3-8436-48e0-aefa-63670d5e48a9
plot(Novempuss.current(lg))

# ╔═╡ eb27ade6-e3d8-4b38-ad28-f37645cba619
push!(lg, Letter[B("0")])

# ╔═╡ 0e11ff9e-4f8f-42dd-9df8-bdd5bfdc4978
plot(Novempuss.current(lg))

# ╔═╡ 3a07aad2-2289-4372-ba80-2a61edb2ba56
Novempuss.current(lg)

# ╔═╡ cac657b2-a10b-4d58-ae4b-c0dd2280b363
Novempuss.graph(Novempuss.current(lg))

# ╔═╡ a862c6a6-091d-40b3-a966-79ea692b69d6
Novempuss.Graphs.ne(lg)

# ╔═╡ Cell order:
# ╠═2ef771b6-df87-11ee-2477-37c04af15b58
# ╠═26df969e-27b3-49ac-a37f-1d439645116d
# ╠═7456e50c-0900-41f7-8fed-8f6bda71c3c4
# ╠═2fee6654-bc9b-4259-9046-38a4d5e97a8d
# ╠═57a8a94b-6f05-4e56-9a89-79534287f140
# ╠═2f8b47ee-e8f6-4e23-b59c-533d8e229484
# ╠═fcc70739-c2e0-41f8-8c3d-9a0d54ee082a
# ╠═d44f8ec5-6c66-48a1-9f69-b429fc6b614d
# ╠═f6a0e784-6cdd-43d2-b000-7409bbdab268
# ╠═feb63206-dd03-4e33-9ef8-9fb3a5b1babc
# ╠═f6da476e-209c-4928-9766-2ef13cd461d8
# ╠═80db3000-88e1-4d40-b175-5df34287a9f1
# ╠═9b5e733f-9bcf-4760-bfc3-616c2e1adb9f
# ╠═610db448-9d1e-46b3-8a73-d4b7896ba7ac
# ╠═8a22dbc3-8436-48e0-aefa-63670d5e48a9
# ╠═eb27ade6-e3d8-4b38-ad28-f37645cba619
# ╠═0e11ff9e-4f8f-42dd-9df8-bdd5bfdc4978
# ╠═3a07aad2-2289-4372-ba80-2a61edb2ba56
# ╠═cac657b2-a10b-4d58-ae4b-c0dd2280b363
# ╠═a862c6a6-091d-40b3-a966-79ea692b69d6
