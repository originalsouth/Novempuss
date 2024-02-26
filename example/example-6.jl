### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 12c4354e-d6f2-11ee-296c-39d6ef49de56
using Pkg

# ╔═╡ c56d5d47-a249-42df-b0ad-46aaba8ad273
Pkg.develop(url = abspath(".."))

# ╔═╡ db872e9e-40a8-43d3-95c7-bfcdee19a7fb
using Revise

# ╔═╡ d730ba9a-b46a-477c-83e9-ef47b6a03575
using Novempuss

# ╔═╡ e23f89b5-a505-4895-b209-dc08165cd1f6
using Graphs

# ╔═╡ 7a71979d-8b69-4f78-aa8a-dd5eaca52e77
using SimpleWeightedGraphs

# ╔═╡ 490cac50-742f-4f87-a040-906beb3be069
using PlotGraphviz

# ╔═╡ 1d730c00-71fa-4803-bd62-c32b2ef07904
concat(x::String, y::String) = count(==('|'), x * "|" * y) < 2 ? [x * "|" * y, "😸"] : "😻"

# ╔═╡ b7855810-c63a-47c2-ad5e-e6a86d45ce99
ms = Novempuss.MethodSet(concat)

# ╔═╡ df95ddc2-7a1c-44b9-9780-8f9dc57108cd
gl = Novempuss.Graphlet{String}(["🐈", "🐱"], ms)

# ╔═╡ 9b963c4a-d858-43ad-9786-c57d8265300d
function plot(g::Novempuss.Graphlet)
	swdg = SimpleWeightedDiGraph(reverse(Novempuss.graph(g)))
	attrs = GraphvizAttributes(swdg)
	for (i, name) in Iterators.Enumerate(Novempuss.nodes(g))
		set!(attrs.nodes, i, Property("label", string(name)))
	end
	set!(attrs.node_options, "shape", "circle")
	plot_graphviz(swdg, attrs; scale = 600)
end

# ╔═╡ c50f938a-c547-408f-a1c6-de5c1eafe6fe
plot(gl)

# ╔═╡ Cell order:
# ╠═12c4354e-d6f2-11ee-296c-39d6ef49de56
# ╠═c56d5d47-a249-42df-b0ad-46aaba8ad273
# ╠═db872e9e-40a8-43d3-95c7-bfcdee19a7fb
# ╠═d730ba9a-b46a-477c-83e9-ef47b6a03575
# ╠═e23f89b5-a505-4895-b209-dc08165cd1f6
# ╠═7a71979d-8b69-4f78-aa8a-dd5eaca52e77
# ╠═490cac50-742f-4f87-a040-906beb3be069
# ╠═1d730c00-71fa-4803-bd62-c32b2ef07904
# ╠═b7855810-c63a-47c2-ad5e-e6a86d45ce99
# ╠═df95ddc2-7a1c-44b9-9780-8f9dc57108cd
# ╠═9b963c4a-d858-43ad-9786-c57d8265300d
# ╠═c50f938a-c547-408f-a1c6-de5c1eafe6fe
