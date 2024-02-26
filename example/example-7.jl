### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ c6db9542-dc93-11ee-293c-5bfdbe85cca8
using Pkg

# ╔═╡ 64d68b23-fd00-4523-8225-d2f07fbaa836
Pkg.develop(url = abspath(".."))

# ╔═╡ 71604b51-bf14-4a62-bb8b-d072104226b5
using Revise

# ╔═╡ b68a43fb-1686-4828-8510-1bedfba19f96
using Novempuss

# ╔═╡ 75da4173-80da-41d0-a4bf-20e02a52cc70
using SimpleWeightedGraphs

# ╔═╡ 9c58f19f-a183-488b-8240-d6e096f94f60
using PlotGraphviz

# ╔═╡ d4db239d-8682-4ec0-9505-82aecda15736
concat(x::String, y::String) = count(==('|'), x * "|" * y) < 2 ? [x * "|" * y, "😸"] : "😻"

# ╔═╡ c6c8340f-8558-4b26-bd12-5981a925aaef
lg = LogicalGraph{String}(concat)

# ╔═╡ 9125ffdf-d4c7-4696-8328-dc9d7c9845a9
push!(lg, ["🐈", "🐱"])

# ╔═╡ 18852ec3-2a8e-4167-aefa-eeb6eabae697
push!(lg, ["🐕", "🐶"])

# ╔═╡ b23874a2-f67e-47af-b9fa-8c0d0fff3c60
function plot(g::Novempuss.Graphlet)
	swdg = SimpleWeightedDiGraph(reverse(Novempuss.graph(g)))
	attrs = GraphvizAttributes(swdg)
	for (i, name) in Iterators.Enumerate(Novempuss.nodes(g))
		set!(attrs.nodes, i, Property("label", string(name)))
	end
	set!(attrs.node_options, "shape", "circle")
	plot_graphviz(swdg, attrs; scale = 600)
end

# ╔═╡ cd68e4a4-d04e-4484-b2f1-11c7c0d18d75
plot.(Novempuss.graphlets(lg))

# ╔═╡ 5f5d83d0-5f2e-4ffd-aef3-642b79f116de
plot(Novempuss.current(lg))

# ╔═╡ 49c9ac72-a27b-47e9-a563-9ac1339c557e
Novempuss.isroot(lg, "🐕")

# ╔═╡ 2713e4ac-061f-4085-870e-5b3d347b7393
Novempuss.rootfind(lg, "🐕|🐱")

# ╔═╡ 6195781e-b13e-4c80-89d5-a0d9e204dbc7


# ╔═╡ Cell order:
# ╠═c6db9542-dc93-11ee-293c-5bfdbe85cca8
# ╠═64d68b23-fd00-4523-8225-d2f07fbaa836
# ╠═71604b51-bf14-4a62-bb8b-d072104226b5
# ╠═b68a43fb-1686-4828-8510-1bedfba19f96
# ╠═75da4173-80da-41d0-a4bf-20e02a52cc70
# ╠═9c58f19f-a183-488b-8240-d6e096f94f60
# ╠═d4db239d-8682-4ec0-9505-82aecda15736
# ╠═c6c8340f-8558-4b26-bd12-5981a925aaef
# ╠═9125ffdf-d4c7-4696-8328-dc9d7c9845a9
# ╠═18852ec3-2a8e-4167-aefa-eeb6eabae697
# ╠═b23874a2-f67e-47af-b9fa-8c0d0fff3c60
# ╠═cd68e4a4-d04e-4484-b2f1-11c7c0d18d75
# ╠═5f5d83d0-5f2e-4ffd-aef3-642b79f116de
# ╠═49c9ac72-a27b-47e9-a563-9ac1339c557e
# ╠═2713e4ac-061f-4085-870e-5b3d347b7393
# ╠═6195781e-b13e-4c80-89d5-a0d9e204dbc7
