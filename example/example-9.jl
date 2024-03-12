### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ c314ddec-df90-11ee-32ec-a3e35021b851
using Pkg

# ╔═╡ 7761c99d-2e7a-4cfe-9ae2-33ec9ce1ca12
Pkg.develop(url = abspath(".."));

# ╔═╡ 40eff408-4140-4e26-815f-9dd9f8262925
using Revise

# ╔═╡ 16d953e2-403e-4669-b961-2f3f4b4ae7eb
using Novempuss

# ╔═╡ 80dbabae-21ab-4e17-b90c-1494c246d726
using SimpleWeightedGraphs

# ╔═╡ 2f124af8-ff40-48fb-90a4-0f25cdd9d745
using PlotGraphviz

# ╔═╡ 843d5a67-c75a-4647-a1b9-7da7145741e6
md"""
### Making Falafel

Falafel is a popular Middle Eatern dish combining various other dishes from the reagon. The dish itself is so old that Pythagoras prohibited eating it because it "contains the spirits of dead people".

For falafel we need ingredients to make the various sub-dishes.
"""

# ╔═╡ 13839892-4c31-4dbd-b795-56262dc906d7
abstract type Food end

# ╔═╡ b91dc53d-34da-4e5d-8a0f-a9dd8d45ffbb
abstract type Ingredient <: Food end

# ╔═╡ 6f7cd13f-7c6b-4dda-bd5a-620dd487846d
name(_::T) where T<:Food = last(split(string(T), "."))

# ╔═╡ 8c730f32-b212-4baf-9303-5180dabcfcec
for ingredient in [:🥔, :🧅, :🥕, :🥬, :🥒, :🍅, :🧄, :🫚, :🍆, :🥚, :🥭, :🧀, :🫘, :🌶️, :🍋, :🫒, :🌾]
	@eval begin
		struct $ingredient<:Ingredient end
	end
end

# ╔═╡ a5e70ae4-9bb6-4c1c-a571-b5fb20d6b069
abstract type Dish <: Food end

# ╔═╡ f33ed7ce-2bd7-4631-9d5f-8485bc5b82b2
for dish in [:🍟, :🧆, :🥙, :🍲, :🥗, :🫓]
	@eval begin
		struct $dish<:Dish end
	end
end

# ╔═╡ 5b4a1970-6a31-466c-9f97-6b48416e81fb
md"""
### Define the recipes
At a good falafel stand you can often choose and combine the various ingredients that go into it.
Here for bravity sake we simplify the dishes, pretending Falafel is comprised of fries, pita bread, falafel balls, salad and sauce. Mixing them properly together makes a falafel.
"""

# ╔═╡ c36d160f-38e8-4e2f-8881-c1102f0730c7
begin
	recipe(_::🥔) = 🍟()
	recipe(_::🌾) = 🫓()
	recipe(_::🧅, _::🫘, _::🧄, _::🥬, _::🌶️) = 🧆()
	recipe(_::🥬, _::🥒, _::🍅, _::🍋, _::🫒) = 🥗()
	recipe(_::🥭, _::🌶️, _::🍋) = 🍲()
	recipe(_::🍟, _::🧆, _::🍲, _::🥗, _::🫓) = 🥙()
end

# ╔═╡ 3224e795-8bd0-425e-ae5f-b5c98f48f4e2
function plot(g::Novempuss.Graphlet)
	swdg = SimpleWeightedDiGraph(reverse(Novempuss.graph(g)))
	attrs = GraphvizAttributes(swdg)
	for (i, obj) in Iterators.Enumerate(Novempuss.nodes(g))
		set!(attrs.nodes, i, Property("label", name(obj)))
		set!(attrs.nodes, i, Property("color", obj isa Ingredient ? "orange" : "green"))
	end
	set!(attrs.node_options, "shape", "circle")
	plot_graphviz(swdg, attrs; scale = 1000)
end;

# ╔═╡ bb3c6b73-6835-41f1-b93d-642e0340d891
md"""
### Populating the kitchen
Now let us start cooking we start with populating the kitchen with our raw ingredients.
"""

# ╔═╡ 66d93942-d44a-4c36-872d-e1fbd8f01601
kitchen = Novempuss.LogicalGraph{Food}(recipe)

# ╔═╡ 33559047-f327-480c-bd88-7631f66af3ec
for root in [[🥔()], [🌾()], [🧅(), 🫘(), 🧄(), 🥬(), 🌶️()], [🥬(), 🥒(),🍅(), 🍋(), 🫒()]]
	push!(kitchen, Food[root...])
end

# ╔═╡ 9e65df60-b4a5-4f35-99a0-e760352c8dc8
plot(Novempuss.current(kitchen))

# ╔═╡ 7585e718-3d67-452a-b069-9bfb8761e0c1
push!(kitchen, Food[🥭(), 🌶️(), 🍋()])

# ╔═╡ 62e71e33-9a48-43da-a76e-32b6abcb173b
plot(Novempuss.current(kitchen))

# ╔═╡ 298b405d-3803-47a5-aa75-9b4ce1794632
delete!(kitchen, Food[🥔()])

# ╔═╡ 2c611e46-338d-4475-9684-89af8f5b61fc
plot(Novempuss.current(kitchen))

# ╔═╡ 8c4828f3-7514-4298-8016-660298b40eb9
Novempuss.rootfind(kitchen, 🥙())

# ╔═╡ b2fcf6ed-8c7a-4fc3-b44f-f129692a3bad
Novempuss.rootfindall(kitchen, 🥙())

# ╔═╡ 384ec12a-4410-48c8-9d6b-2dce84848dd2
Novempuss.rootfind(kitchen, 🥗())

# ╔═╡ 3f835569-9126-4b69-82b0-37f3fbea898f
Novempuss.rootfindall(kitchen, 🥗())

# ╔═╡ Cell order:
# ╠═c314ddec-df90-11ee-32ec-a3e35021b851
# ╠═7761c99d-2e7a-4cfe-9ae2-33ec9ce1ca12
# ╠═40eff408-4140-4e26-815f-9dd9f8262925
# ╠═16d953e2-403e-4669-b961-2f3f4b4ae7eb
# ╠═80dbabae-21ab-4e17-b90c-1494c246d726
# ╠═2f124af8-ff40-48fb-90a4-0f25cdd9d745
# ╟─843d5a67-c75a-4647-a1b9-7da7145741e6
# ╠═13839892-4c31-4dbd-b795-56262dc906d7
# ╠═b91dc53d-34da-4e5d-8a0f-a9dd8d45ffbb
# ╠═6f7cd13f-7c6b-4dda-bd5a-620dd487846d
# ╠═8c730f32-b212-4baf-9303-5180dabcfcec
# ╠═a5e70ae4-9bb6-4c1c-a571-b5fb20d6b069
# ╠═f33ed7ce-2bd7-4631-9d5f-8485bc5b82b2
# ╟─5b4a1970-6a31-466c-9f97-6b48416e81fb
# ╠═c36d160f-38e8-4e2f-8881-c1102f0730c7
# ╠═3224e795-8bd0-425e-ae5f-b5c98f48f4e2
# ╠═bb3c6b73-6835-41f1-b93d-642e0340d891
# ╠═66d93942-d44a-4c36-872d-e1fbd8f01601
# ╠═33559047-f327-480c-bd88-7631f66af3ec
# ╠═9e65df60-b4a5-4f35-99a0-e760352c8dc8
# ╠═7585e718-3d67-452a-b069-9bfb8761e0c1
# ╠═62e71e33-9a48-43da-a76e-32b6abcb173b
# ╠═298b405d-3803-47a5-aa75-9b4ce1794632
# ╠═2c611e46-338d-4475-9684-89af8f5b61fc
# ╠═8c4828f3-7514-4298-8016-660298b40eb9
# ╠═b2fcf6ed-8c7a-4fc3-b44f-f129692a3bad
# ╠═384ec12a-4410-48c8-9d6b-2dce84848dd2
# ╠═3f835569-9126-4b69-82b0-37f3fbea898f
