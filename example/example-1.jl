### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 3e1061ab-e2dd-4de1-9b84-001ec243cdfa
using Pkg

# ╔═╡ e8097b14-e2d4-4a0b-959a-7e8c4ba75073
Pkg.develop(url = abspath(".."))

# ╔═╡ 93acf526-07ad-4976-8903-54a2b292fc8d
using Revise

# ╔═╡ 92ceb11c-fb31-422d-a43f-5f3e0861f773
using Novempuss

# ╔═╡ c6ed494e-3224-4672-b541-a9e7abb5b728
using CairoMakie

# ╔═╡ d80322d4-379c-4b40-a1ef-c3775a755e6e
using GraphMakie

# ╔═╡ 85895e00-8968-4fb8-8645-77b909e54399
abstract type Letter end

# ╔═╡ d92276df-56f2-45f8-9f06-0ddb19ee066e
value(x::T) where T <: Letter = x.value

# ╔═╡ 5441fd4b-b6e9-4d88-99e8-fb6bc25a526a
begin
	struct A <: Letter value::String end
    A() = A("A")
    struct B <: Letter value::String end
    B() = B("B")
    struct C <: Letter value::String end
    C() = C("C")
	struct D <: Letter value::String end
    D() = D("D")
end;

# ╔═╡ b042ed4a-4789-47df-a000-2ec02ca4dc16
begin
	rule(x::A)::B = B(x.value*"|B")
	rule(x::B)::C = C(x.value*"|C")
	multirule(x::C, y::A)::D = D("<"*x.value*"|D|"*y.value*">")
end;

# ╔═╡ 67d49f23-d02c-4494-ba61-f70cd879aa85
function plot(gl::Novempuss.Graphlet)
	names = value.(Novempuss.nodes(gl))
	f, ax, p = graphplot(Novempuss.graph(gl); ilabels=names, arrow_size = 30, node_color=:cyan, edge_color=map(x -> :gray, 1:Novempuss.ne(gl)), arrow_shift=:end)
	hidedecorations!(ax)
	hidespines!(ax)
	ax.aspect = DataAspect()
	ax.yautolimitmargin = (0.75f0, 0.75f0)
	ax.xautolimitmargin = (0.75f0, 0.75f0)
	return f
end

# ╔═╡ 5441c785-3322-41db-86ed-0d8caca32dea
let
	ms = Novempuss.MethodSet(rule)
	gl = Novempuss.Graphlet{Letter}(A(), ms)
	plot(gl)
end

# ╔═╡ ff144a09-00af-4526-9f36-e8e4cb4dd0a5
let
	ms = Novempuss.MethodSet([rule, multirule])
	gl = Novempuss.Graphlet{Letter}(A(), ms)
	plot(gl)
end

# ╔═╡ 3beaf052-4571-41d1-ae3e-e72268b9a85f
let
	gl1 = Novempuss.Graphlet{Letter}(A(), Novempuss.MethodSet([rule, multirule]))
	gl2 = Novempuss.Graphlet{Letter}(A(), Novempuss.MethodSet(rule))
	plot(Novempuss._simple_merge(gl1, gl2))
end

# ╔═╡ b9858d61-39a3-402f-9f22-4e264840b7b3
let
	gl1 = Novempuss.Graphlet{Letter}(A("b"), Novempuss.MethodSet([rule, multirule]))
	gl2 = Novempuss.Graphlet{Letter}(A("q"), Novempuss.MethodSet(rule))
	gls = gl2 + gl1 - gl2
	plot(gls)
end

# ╔═╡ Cell order:
# ╠═3e1061ab-e2dd-4de1-9b84-001ec243cdfa
# ╠═e8097b14-e2d4-4a0b-959a-7e8c4ba75073
# ╠═93acf526-07ad-4976-8903-54a2b292fc8d
# ╠═92ceb11c-fb31-422d-a43f-5f3e0861f773
# ╠═c6ed494e-3224-4672-b541-a9e7abb5b728
# ╠═d80322d4-379c-4b40-a1ef-c3775a755e6e
# ╠═85895e00-8968-4fb8-8645-77b909e54399
# ╠═d92276df-56f2-45f8-9f06-0ddb19ee066e
# ╠═5441fd4b-b6e9-4d88-99e8-fb6bc25a526a
# ╠═b042ed4a-4789-47df-a000-2ec02ca4dc16
# ╠═67d49f23-d02c-4494-ba61-f70cd879aa85
# ╠═5441c785-3322-41db-86ed-0d8caca32dea
# ╠═ff144a09-00af-4526-9f36-e8e4cb4dd0a5
# ╠═3beaf052-4571-41d1-ae3e-e72268b9a85f
# ╠═b9858d61-39a3-402f-9f22-4e264840b7b3
