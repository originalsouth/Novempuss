### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ bee484d8-cfdf-11ee-07f4-8b74550a5431
using Pkg

# ╔═╡ 8af6c257-bde7-454c-a42b-067b59739eb9
Pkg.develop(url = abspath(".."))

# ╔═╡ 6ace7b2d-f2f6-41e8-8523-0bcc0b2f1873
using Revise

# ╔═╡ 6fe2e1da-8eed-45e0-a2f1-cfc65c85a505
using Novempuss

# ╔═╡ 992aa48d-53a7-419a-97f0-c0be90094f30
using GraphPlot

# ╔═╡ 1d98e9a7-64d4-45ae-b88c-a189d9cb731e
using Compose

# ╔═╡ 1f26cf6a-f0b8-40a1-b49c-8d089284a1ab
abstract type Letter end

# ╔═╡ 3f87c936-fba9-4352-ab36-c42e8ba03ae2
value(x::T) where T <: Letter = x.value

# ╔═╡ 4f7cb636-2c2a-4097-80ae-f121f76f3507
begin
	struct A <: Letter value::String end
    A() = A("A")
    struct B <: Letter value::String end
    B() = B("B")
    struct C <: Letter value::String end
    C() = C("C")
end;

# ╔═╡ a589c616-f5ed-4bdd-b066-cafad6c87dad
begin
	N = 40
	rule(x::A) = length(x.value) <= 2*N ? B("$(x.value)B") : nothing
	rule(x::B) = length(x.value) <= 2*N ? A("$(x.value)A") : nothing
	rule(x::A, y::B) = length(x.value) <= N ? C("$(x.value)C$(y.value)") : A()
	ms = Novempuss.MethodSet(rule)
end;

# ╔═╡ d332e6ba-14cf-4c43-820f-dfc9f7e226c3
function plot(gl::Novempuss.Graphlet)
	names = value.(Novempuss.nodes(gl))
	return gplot(Novempuss.graph(gl))
end

# ╔═╡ 4f31f24a-353b-41f8-ba0b-aa53ded3795d
gl = Novempuss.Graphlet{Letter}(A(), ms)

# ╔═╡ dd01af39-964f-4db6-8e21-f4a605279ca5
Novempuss.Graphs.is_cyclic(Novempuss.graph(gl))

# ╔═╡ 8b3e4cac-8f38-46d9-bb0e-242cef903a6f
size(gl)

# ╔═╡ f52fb8db-d9e5-4601-b596-6d48ad98d715
plot(gl)

# ╔═╡ Cell order:
# ╠═bee484d8-cfdf-11ee-07f4-8b74550a5431
# ╠═8af6c257-bde7-454c-a42b-067b59739eb9
# ╠═6ace7b2d-f2f6-41e8-8523-0bcc0b2f1873
# ╠═6fe2e1da-8eed-45e0-a2f1-cfc65c85a505
# ╠═992aa48d-53a7-419a-97f0-c0be90094f30
# ╠═1d98e9a7-64d4-45ae-b88c-a189d9cb731e
# ╠═1f26cf6a-f0b8-40a1-b49c-8d089284a1ab
# ╠═3f87c936-fba9-4352-ab36-c42e8ba03ae2
# ╠═4f7cb636-2c2a-4097-80ae-f121f76f3507
# ╠═a589c616-f5ed-4bdd-b066-cafad6c87dad
# ╠═d332e6ba-14cf-4c43-820f-dfc9f7e226c3
# ╠═4f31f24a-353b-41f8-ba0b-aa53ded3795d
# ╠═dd01af39-964f-4db6-8e21-f4a605279ca5
# ╠═8b3e4cac-8f38-46d9-bb0e-242cef903a6f
# ╠═f52fb8db-d9e5-4601-b596-6d48ad98d715
