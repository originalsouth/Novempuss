### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 196d561c-d005-11ee-0873-afb8d813717f
using Pkg

# ╔═╡ 33b3c069-750a-49d2-83eb-df5f9215a56b
Pkg.develop(url = abspath(".."))

# ╔═╡ aa94d4c2-7b70-41ee-9a77-173c2b46cfc1
using Revise

# ╔═╡ 7b5f913d-51d3-46ca-86f3-c9ae9f546b2c
using Novempuss

# ╔═╡ e13deb27-5fee-4d28-8af7-eaf791f0042a
using CairoMakie

# ╔═╡ 3d043c12-044a-4ca0-921e-8343bb616015
using GraphMakie

# ╔═╡ a3375900-87fc-402b-b81d-f233d1636e16
function collatz(x::BigInt)
	if x == BigInt(1)
		return nothing
	else
		if iseven(x)
			return x/2
		else
			return 3*x+1
		end
	end
end

# ╔═╡ f06309d6-88a9-4c59-b024-19d07f60d1f0
ms = Novempuss.MethodSet(collatz)

# ╔═╡ d60bf47c-85b4-43a5-af38-cb91323c8464
function plot(gl::Novempuss.Graphlet)
	names = collect(Novempuss.nodes(gl))
	f, ax, p = graphplot(Novempuss.graph(gl); layout=GraphMakie.NetworkLayout.Stress(), nlabels=string.(names), nlabels_fontsize=8, node_color=:cyan, edge_color=map(x -> :gray, 1:Novempuss.ne(gl)), arrow_shift=:end)
	hidedecorations!(ax)
	hidespines!(ax)
	ax.aspect = DataAspect()
	return f
end

# ╔═╡ 92829539-b334-4605-a0b1-e46f90755d1c
Novempuss.Graphlet{BigInt}(BigInt(27), ms)

# ╔═╡ 68d07a5e-e474-474c-beb3-dbc54af97afd
graphlets = [Novempuss.Graphlet{BigInt}(BigInt(i), ms) for i in 1:26]

# ╔═╡ ba36d56e-6be8-4061-9ce3-6f634c29e091
plot.(graphlets)

# ╔═╡ f5ad4e9c-0906-4566-b1e8-ee2b987b7cf9
gl = reduce(Novempuss._simple_merge, graphlets)

# ╔═╡ 1050f4c3-5cda-4f16-a0b6-32c2fab2fb5a
g2 = Novempuss._simple_merge(graphlets)

# ╔═╡ e3275089-a25d-4de7-84c2-812dd003ddb8
plot(gl)

# ╔═╡ 3faacbcb-6a45-4f32-b9f3-6dd3d9d88c1c
plot(g2)

# ╔═╡ Cell order:
# ╠═196d561c-d005-11ee-0873-afb8d813717f
# ╠═33b3c069-750a-49d2-83eb-df5f9215a56b
# ╠═aa94d4c2-7b70-41ee-9a77-173c2b46cfc1
# ╠═7b5f913d-51d3-46ca-86f3-c9ae9f546b2c
# ╠═e13deb27-5fee-4d28-8af7-eaf791f0042a
# ╠═3d043c12-044a-4ca0-921e-8343bb616015
# ╠═a3375900-87fc-402b-b81d-f233d1636e16
# ╠═f06309d6-88a9-4c59-b024-19d07f60d1f0
# ╠═d60bf47c-85b4-43a5-af38-cb91323c8464
# ╠═92829539-b334-4605-a0b1-e46f90755d1c
# ╠═68d07a5e-e474-474c-beb3-dbc54af97afd
# ╠═ba36d56e-6be8-4061-9ce3-6f634c29e091
# ╠═f5ad4e9c-0906-4566-b1e8-ee2b987b7cf9
# ╠═1050f4c3-5cda-4f16-a0b6-32c2fab2fb5a
# ╠═e3275089-a25d-4de7-84c2-812dd003ddb8
# ╠═3faacbcb-6a45-4f32-b9f3-6dd3d9d88c1c
