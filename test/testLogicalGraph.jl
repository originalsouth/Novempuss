@testset "LogicalGraph" begin
    @testset "Basic Operations" begin
        N = 26
        lg = LogicalGraph{BigInt}(loop_collatz)
        for i in 1:N
            push!(lg, Set([BigInt(i)]))
        end
        graphlets = [Novempuss.Graphlet{BigInt}(BigInt(i), Novempuss.ms(lg)) for i in 1:N]
        for i in 1:N
            @test lg[[BigInt(i)]] == graphlets[i]
        end
        @test Novempuss.rootfindall(lg, BigInt(1)) == Novempuss.rootfind(lg, BigInt(1))
        @test Novempuss.rootfindall(lg, BigInt(22)) == Novempuss.rootfind(lg, BigInt(22))
        @test Novempuss.rootfindall(lg, BigInt(40)) == Novempuss.rootfind(lg, BigInt(40))
        @test Novempuss.rootfindall(lg, BigInt(76)) == Novempuss.rootfind(lg, BigInt(76))
        for i in 3:N
            @test permeq(Novempuss.nodes(Novempuss.shortest(lg, BigInt(i), BigInt(1))), Novempuss.nodes(lg[[BigInt(i)]]))
            @test Set(Novempuss.shortest(lg, BigInt(i), BigInt(1))) == delete!(Set(Novempuss.edges(lg[[BigInt(i)]])), (1, 4))
        end
    end

    @testset "Algae L-System" begin
        lg = LogicalGraph{Letter}(algealsystem)
        push!(lg, Set{Letter}([A("1")]))
        push!(lg, Set{Letter}([B("0")]))
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
        roots = [[🥔()], [🌾()], [🧅(), 🫘(), 🧄(), 🥬(), 🌶️()], [🥬(), 🥒(),🍅(), 🍋(), 🫒()]]
        for root in roots
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
        @test isempty(Novempuss.rootfind(kitchen, 🥙()))
        @test permeq(Novempuss.rootfindall(kitchen, 🥙()), union(Set{Food}.(roots), Set{Food}.([[🥭(), 🌶️(), 🍋()]])))
        delete!(kitchen, Food[🥔()])
        for i in [🧆, 🍲, 🥗, 🫓]
            @test i() in Novempuss.nodes(Novempuss.current(kitchen))
        end
        @test 🍟() ∉  Novempuss.nodes(Novempuss.current(kitchen))
        @test 🥙() ∉  Novempuss.nodes(Novempuss.current(kitchen))
        @test isempty(Novempuss.rootfindall(kitchen, 🥙()))
        @test Novempuss.rootfindall(kitchen, 🥗()) == Novempuss.rootfind(kitchen, 🥗())
    end

    @testset "Root Finding" begin
        lg = Novempuss.LogicalGraph{Letter}(Dcomposer)
        push!(lg, Letter[A("a")])
        push!(lg, Letter[B("b")])
        push!(lg, Letter[C("c")])
        @test Novempuss.rootfind(lg, A("a")) == Set{Letter}.([[A("a")]])
        @test Novempuss.isroot(lg, A("a"))
        @test !Novempuss.isroot(lg, D("abc"))
        @test isempty(Novempuss.rootfind(lg, D("abc")))
        @test Novempuss.rootfindall(lg, A("a")) == Novempuss.rootfind(lg, A("a"))
        @test permeq(Novempuss.rootfindall(lg, D("abc")), Set{Letter}.([[A("a")], [B("b")], [C("c")]]))
        lg = Novempuss.LogicalGraph{Letter}(Dcomposer)
        push!(lg, Letter[A("a"), B("b")])
        push!(lg, Letter[C("c")])
        @test !Novempuss.isroot(lg, Letter[A("a")])
        @test !Novempuss.isroot(lg, D("abc"))
        @test Novempuss.rootfindall(lg, A("a")) == Novempuss.rootfind(lg, A("a"))
        @test permeq(Novempuss.rootfindall(lg, D("abc")), Set{Letter}.([[A("a"), B("b")], [C("c")]]))
    end
end
