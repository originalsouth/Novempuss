### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ b24b53be-d480-11ee-2b06-f1feccd5ecd5
using Pkg

# ╔═╡ 4be1e4b1-16b8-4d1e-9cb2-d6fa3aab98f3
Pkg.develop(url = abspath(".."))

# ╔═╡ 41ea21dc-4d1f-4f22-8cee-ac1cd1157959
using Revise

# ╔═╡ 22ac1e85-649f-4a53-8a0e-aa18400b767c
using Novempuss

# ╔═╡ 234895b7-cc63-4824-ba04-90ffc1651455
using Graphs

# ╔═╡ 376279fe-9be6-4d5f-b983-92fca1708084
using SimpleWeightedGraphs

# ╔═╡ 5020a06c-fd19-442c-a680-68901922f779
using PlotGraphviz

# ╔═╡ 76d3240d-6284-485d-aaa8-d50687e06cb3
concat(x::String, y::String) = count(==('|'), x * "|" * y) < 2 ? x * "|" * y : nothing

# ╔═╡ 2497f723-cfb6-4c88-91d9-d48aff5dc5eb
ms = Novempuss.MethodSet(concat)

# ╔═╡ ae3a89e2-3c94-43ff-b9be-39f7e93138e4
 g1 = Novempuss.Graphlet{String}(["A", "B"], ms)

# ╔═╡ 0a0d07ed-1933-4abb-9bb0-8ba4b6b75b3a
 g2 = Novempuss.Graphlet{String}(["C", "D"], ms)

# ╔═╡ 58ca4f72-980c-4e5e-85d4-355cfb80e962
 g3 = Novempuss.Graphlet{String}(["E", "F"], ms)

# ╔═╡ 526b7d3b-e271-4258-9c6c-a13c8c81f201
function plot(g::Novempuss.Graphlet)
	swdg = SimpleWeightedDiGraph(reverse(Novempuss.graph(g)))
	attrs = GraphvizAttributes(swdg)
	for (i, name) in Iterators.Enumerate(Novempuss.nodes(g))
		set!(attrs.nodes, i, Property("label", string(name)))
	end
	set!(attrs.node_options, "shape", "circle")
	plot_graphviz(swdg, attrs; scale = 400)
end

# ╔═╡ 7d703d83-7d42-4ff8-a4b3-3b6be3fd7827
plot(g1)

# ╔═╡ 18f1061a-2307-48f7-9b67-b6f88e7ae57e
plot(g2)

# ╔═╡ fdb6bd47-5735-47e7-aae6-ed60ecbbfc29
plot(g3)

# ╔═╡ c0497f3e-2924-487a-a522-f9535f4c698b
plot(Novempuss._merge(g1, g2, ms))

# ╔═╡ 61986f85-dd8c-459e-adcf-9a6d63eeb437
plot(Novempuss._merge(g2, g1, ms))

# ╔═╡ 4427ce49-4b82-4b0a-8f23-230a0365fdaf
plot(Novempuss._merge([g1, g2, g3], ms))

# ╔═╡ Cell order:
# ╠═b24b53be-d480-11ee-2b06-f1feccd5ecd5
# ╠═4be1e4b1-16b8-4d1e-9cb2-d6fa3aab98f3
# ╠═41ea21dc-4d1f-4f22-8cee-ac1cd1157959
# ╠═22ac1e85-649f-4a53-8a0e-aa18400b767c
# ╠═234895b7-cc63-4824-ba04-90ffc1651455
# ╠═376279fe-9be6-4d5f-b983-92fca1708084
# ╠═5020a06c-fd19-442c-a680-68901922f779
# ╠═76d3240d-6284-485d-aaa8-d50687e06cb3
# ╠═2497f723-cfb6-4c88-91d9-d48aff5dc5eb
# ╠═ae3a89e2-3c94-43ff-b9be-39f7e93138e4
# ╠═0a0d07ed-1933-4abb-9bb0-8ba4b6b75b3a
# ╠═58ca4f72-980c-4e5e-85d4-355cfb80e962
# ╠═526b7d3b-e271-4258-9c6c-a13c8c81f201
# ╠═7d703d83-7d42-4ff8-a4b3-3b6be3fd7827
# ╠═18f1061a-2307-48f7-9b67-b6f88e7ae57e
# ╠═fdb6bd47-5735-47e7-aae6-ed60ecbbfc29
# ╠═c0497f3e-2924-487a-a522-f9535f4c698b
# ╠═61986f85-dd8c-459e-adcf-9a6d63eeb437
# ╠═4427ce49-4b82-4b0a-8f23-230a0365fdaf
