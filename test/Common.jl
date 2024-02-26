using Test
using Novempuss

test_ms_f(x::Int64) = x
test_ms_f(x::Float64) = pi*x

test_ms_f(x::Int64, y::Int64) = x + y
test_ms_f(x::Float64, y::Float64) = hypot(x, y)

test_ms_f(x::Int64, y::Int64, z::Int64) = [x, 2*y, 3*z]
test_ms_f(x::Float64, y::Float64, z::Float64) = (x + y + z)^2

test_ms_g(x::Int64) = 2^x
test_ms_g(x::Float64) = exp(x)

abstract type Letter end
value(x::T) where T <: Letter = x.value

for lt in [:A, :B, :C, :D]
	@eval begin
		struct $lt <: Letter value::String end
		$lt() = $lt(string($lt))
	end
end

rule(x::A)::B = B(x.value*"|B")
rule(x::B)::C = C(x.value*"|C")

multirule(x::C, y::A)::D = D("<"*x.value*"|D|"*y.value*">")

circular_rule(x::A)::B = B(x.value*"|B")
circular_rule(x::B)::C = C(x.value*"|C")
circular_rule(_::C)::A = A()

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

concat(x::String, y::String) = count(==('|'), x * "|" * y) < 2 ? x * "|" * y : nothing
permeq(x, y) = all(in.(x, Ref(y)))
loop_collatz(x::BigInt) = iseven(x) ? x/2 : 3*x+1

function algealsystem(x::A)
    val = parse(Int, value(x))
    if val < 10
        newval = string(val+1)
        return [A(newval), B(newval)]
    else
        nothing
    end
end

function algealsystem(x::B)
    val = parse(Int, value(x))
    if val < 10
        newval = string(val+1)
        return [A(newval), C(newval)]
    else
        nothing
    end
end

abstract type Food end
abstract type Ingredient <: Food end
abstract type Dish <: Food end
name(_::T) where T<:Food = last(split(string(T), "."))

for ingredient in [:🥔, :🧅, :🥕, :🥬, :🥒, :🍅, :🧄, :🫚, :🍆, :🥚, :🥭, :🧀, :🫘, :🌶️, :🍋, :🫒, :🌾]
	@eval begin
		struct $ingredient<:Ingredient end
	end
end

for dish in [:🍟, :🧆, :🥙, :🍲, :🥗, :🫓]
	@eval begin
		struct $dish<:Dish end
	end
end

recipe(_::🥔) = 🍟()
recipe(_::🌾) = 🫓()
recipe(_::🧅, _::🫘, _::🧄, _::🥬, _::🌶️) = 🧆()
recipe(_::🥬, _::🥒, _::🍅, _::🍋, _::🫒) = 🥗()
recipe(_::🥭, _::🌶️, _::🍋) = 🍲()
recipe(_::🍟, _::🧆, _::🍲, _::🥗, _::🫓) = 🥙()
