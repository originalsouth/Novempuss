### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 3171f5bc-e07a-11ee-3736-c9f9bd955878
using Pkg

# ╔═╡ 95bc44f0-e585-45b7-b2d7-a93881a8b512
Pkg.develop(url = abspath(".."))

# ╔═╡ b2a388ba-b42a-4ad3-a44c-6a1fb5cc2720
using Revise

# ╔═╡ 7f0027f9-aced-41a4-81ad-10627c6a8fb2
using Novempuss

# ╔═╡ 1701eea1-0219-404c-8b00-9801c40fc35c
using SimpleWeightedGraphs

# ╔═╡ 139d8468-4ed1-4081-8346-ac09392a0ca6
using PlotGraphviz

# ╔═╡ 0317ce8d-44bd-45aa-a6ba-f21e63d92049
function plot(lg::LogicalGraph)
	g = Novempuss.current(lg)
	swdg = SimpleWeightedDiGraph(reverse(Novempuss.graph(g)))
	attrs = GraphvizAttributes(swdg)
	for (i, obj) in Iterators.Enumerate(Novempuss.nodes(g))
		set!(attrs.nodes, i, Property("label", string(obj)))
		set!(attrs.nodes, i, Property("color", Novempuss.isroot(lg, obj) ? "red" : "blue"))
	end
	set!(attrs.node_options, "shape", "circle")
	plot_graphviz(swdg, attrs; scale = 1000)
end;

# ╔═╡ 0a44d752-63f3-4e47-9be4-dc0dc8b12907
collatz(x::BigInt) = iseven(x) ? x/2 : 3*x+1

# ╔═╡ 93c5e953-f098-4055-922f-eaca91dd2ddc
lg = LogicalGraph{BigInt}(collatz)

# ╔═╡ 797997d1-62f3-4216-a925-7aca111af8d5
for i in 1:26
	push!(lg, [BigInt(i)])
end

# ╔═╡ a5276dc0-c076-4ec2-975b-bb62a5c16c23
plot(lg)

# ╔═╡ 755e2848-e9a7-47fa-b210-ceb95aad2a56
Novempuss.rootfind(lg, BigInt(22))

# ╔═╡ 68e1e7db-9198-42a1-9ca7-40a9932212f7
Novempuss.rootfindall(lg, BigInt(22))

# ╔═╡ 10a99d68-5014-4f0f-aaca-49c2e037c397
Novempuss.rootfind(lg, BigInt(76))

# ╔═╡ 1f3e6dfe-13fa-47ee-ab61-f997c49ebe44
Novempuss.rootfindall(lg, BigInt(76))

# ╔═╡ b919d47e-8822-4b1f-ae0c-55dc466f063d
Novempuss.rootfind(lg, BigInt(40))

# ╔═╡ 0eadfe35-75da-4d7a-9469-2e891b26c50b
Novempuss.rootfindall(lg, BigInt(40))

# ╔═╡ 161c3c35-31bb-4648-9c01-18601fb11df6
Novempuss.rootfind(lg, BigInt(1))

# ╔═╡ 6f30c0b0-b956-4430-8b38-1d4a2f902277
Novempuss.rootfindall(lg, BigInt(1))

# ╔═╡ c416e1d9-34f7-4f85-a73d-a70fb1ce4b19
Novempuss.shortest(lg, BigInt(76), BigInt(1))

# ╔═╡ bc11fd0d-cb55-4ec8-86b9-830ad060a8b6
Novempuss.nodes(Novempuss.shortest(lg, BigInt(25), BigInt(1)))

# ╔═╡ Cell order:
# ╠═3171f5bc-e07a-11ee-3736-c9f9bd955878
# ╠═95bc44f0-e585-45b7-b2d7-a93881a8b512
# ╠═b2a388ba-b42a-4ad3-a44c-6a1fb5cc2720
# ╠═7f0027f9-aced-41a4-81ad-10627c6a8fb2
# ╠═1701eea1-0219-404c-8b00-9801c40fc35c
# ╠═139d8468-4ed1-4081-8346-ac09392a0ca6
# ╠═0317ce8d-44bd-45aa-a6ba-f21e63d92049
# ╠═0a44d752-63f3-4e47-9be4-dc0dc8b12907
# ╠═93c5e953-f098-4055-922f-eaca91dd2ddc
# ╠═797997d1-62f3-4216-a925-7aca111af8d5
# ╠═a5276dc0-c076-4ec2-975b-bb62a5c16c23
# ╠═755e2848-e9a7-47fa-b210-ceb95aad2a56
# ╠═68e1e7db-9198-42a1-9ca7-40a9932212f7
# ╠═10a99d68-5014-4f0f-aaca-49c2e037c397
# ╠═1f3e6dfe-13fa-47ee-ab61-f997c49ebe44
# ╠═b919d47e-8822-4b1f-ae0c-55dc466f063d
# ╠═0eadfe35-75da-4d7a-9469-2e891b26c50b
# ╠═161c3c35-31bb-4648-9c01-18601fb11df6
# ╠═6f30c0b0-b956-4430-8b38-1d4a2f902277
# ╠═c416e1d9-34f7-4f85-a73d-a70fb1ce4b19
# ╠═bc11fd0d-cb55-4ec8-86b9-830ad060a8b6
