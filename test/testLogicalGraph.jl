@testset "LogicalGraph" begin
    @testset "Basic Operations" begin
        N = 26
        lg = LogicalGraph{BigInt}(loop_collatz)
        for i in 1:N
            push!(lg, [BigInt(i)])
        end
        graphlets = [Novempuss.Graphlet{BigInt}(BigInt(i), Novempuss.ms(lg)) for i in 1:N]
        for i in 1:N
            @test lg[[BigInt(i)]] == graphlets[i]
        end
    end

    @testset "Algae L-System" begin
        lg = LogicalGraph{Letter}(algealsystem)
        push!(lg, Letter[A("1")])
        push!(lg, Letter[B("0")])
        @test Novempuss.Graphs.nv(lg) == 29
        @test Novempuss.Graphs.ne(lg) == 36
        @test length(filter(x -> x isa A, Novempuss.nodes(Novempuss.current(lg)))) == 10
        @test length(filter(x -> x isa B, Novempuss.nodes(Novempuss.current(lg)))) == 10
        @test length(filter(x -> x isa C, Novempuss.nodes(Novempuss.current(lg)))) == 9
        for i in Novempuss.nodes(Novempuss.current(lg))
            kn = Novempuss.outneighbors(lg, i)
            val = parse(Int, value(i))
            if i isa A && val < 10
                @test A(string(val+1)) in kn
                @test B(string(val+1)) in kn
            elseif i isa B && val < 10
                @test A(string(val+1)) in kn
                @test C(string(val+1)) in kn
            else
                @test isempty(kn)
            end
        end
    end

    @testset "Falafel Kitchen" begin
        kitchen = Novempuss.LogicalGraph{Food}(recipe)
        for root in [[🥔()], [🌾()], [🧅(), 🫘(), 🧄(), 🥬(), 🌶️()], [🥬(), 🥒(),🍅(), 🍋(), 🫒()]]
            push!(kitchen, Food[root...])
        end
        for i in [🍟, 🧆, 🥗, 🫓]
            @test i() in Novempuss.nodes(Novempuss.current(kitchen))
        end
        @test 🍲() ∉  Novempuss.nodes(Novempuss.current(kitchen))
        @test 🥙() ∉  Novempuss.nodes(Novempuss.current(kitchen))
        push!(kitchen, Food[🥭(), 🌶️(), 🍋()])
        for i in [🍟, 🧆, 🥙, 🍲, 🥗, 🫓]
            @test i() in Novempuss.nodes(Novempuss.current(kitchen))
        end
        delete!(kitchen, Food[🥔()])
        for i in [🧆, 🍲, 🥗, 🫓]
            @test i() in Novempuss.nodes(Novempuss.current(kitchen))
        end
        @test 🍟() ∉  Novempuss.nodes(Novempuss.current(kitchen))
        @test 🥙() ∉  Novempuss.nodes(Novempuss.current(kitchen))
    end
end
