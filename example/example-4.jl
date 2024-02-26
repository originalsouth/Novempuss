### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ affb4ade-d0d1-11ee-0fce-51f72c0cf815
using Pkg

# ╔═╡ f0ceb90f-9a89-459f-b4b1-972ab8bec146
Pkg.develop(url = abspath(".."))

# ╔═╡ 5e7edf33-2740-413c-8ca6-2c8ec3db7cef
using Revise

# ╔═╡ 93f66259-7351-47a0-8451-bbb2dc5b9272
using Novempuss

# ╔═╡ ef9c7c26-2be6-4af7-b34e-7fa4ae19596d
using Graphs

# ╔═╡ ae6428fb-e64e-4dfd-859b-6b37700d4e56
using SimpleWeightedGraphs

# ╔═╡ 7a3167cd-c6c9-4dfa-a02e-a50cf58ab469
using PlotGraphviz

# ╔═╡ 48e1ed78-db44-4060-96b8-e0284698bedf
collatz(x::BigInt) = iseven(x) ? x/2 : 3*x+1

# ╔═╡ 39846268-a986-4bdf-947a-0fddd18ebeff
ms = Novempuss.MethodSet(collatz)

# ╔═╡ eb7a22b6-53b6-46fe-8daf-0d3de15d5a4d
graphlets = map(x -> Novempuss.Graphlet{BigInt}(BigInt(x), ms), 1:2^12)

# ╔═╡ aa4064f1-cd26-4aa9-9873-7c78303c857e
gl = Novempuss._simple_merge(graphlets)

# ╔═╡ a1efe45a-3d63-4f0a-b677-971cb2bb54d9
begin
	swdg = SimpleWeightedDiGraph(reverse(Novempuss.graph(gl)))
	attrs = GraphvizAttributes(swdg)
	for (i, name) in Iterators.Enumerate(Novempuss.nodes(gl))
		set!(attrs.nodes, i, Property("label", string(name)))
	end
	set!(attrs.node_options, "shape", "circle")
	plot_graphviz(swdg, attrs; scale = 400)
end

# ╔═╡ Cell order:
# ╠═affb4ade-d0d1-11ee-0fce-51f72c0cf815
# ╠═f0ceb90f-9a89-459f-b4b1-972ab8bec146
# ╠═5e7edf33-2740-413c-8ca6-2c8ec3db7cef
# ╠═93f66259-7351-47a0-8451-bbb2dc5b9272
# ╠═ef9c7c26-2be6-4af7-b34e-7fa4ae19596d
# ╠═ae6428fb-e64e-4dfd-859b-6b37700d4e56
# ╠═7a3167cd-c6c9-4dfa-a02e-a50cf58ab469
# ╠═48e1ed78-db44-4060-96b8-e0284698bedf
# ╠═39846268-a986-4bdf-947a-0fddd18ebeff
# ╠═eb7a22b6-53b6-46fe-8daf-0d3de15d5a4d
# ╠═aa4064f1-cd26-4aa9-9873-7c78303c857e
# ╠═a1efe45a-3d63-4f0a-b677-971cb2bb54d9
