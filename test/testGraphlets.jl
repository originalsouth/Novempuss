@testset "Graphlets" begin
    @testset "Sanity" begin
        @test A <: Letter
        @test B <: Letter
        @test C <: Letter
        @test value(A()) == "A"
        @test value(B()) == "B"
        @test value(C()) == "C"
        @test typeof(rule(A())) == B
        @test typeof(rule(B())) == C
        @test typeof(multirule(C(), A())) == D
        @test value(rule(A())) == "A|B"
        @test value(rule(B())) == "B|C"
        @test value(multirule(C("A"), A("C"))) == "<A|D|C>"
    end

    @testset "MethodSets" begin
        ms = Novempuss.MethodSet(rule)
        @test length(Novempuss.MethodSets.methodset(ms)) == 2
        ms = Novempuss.MethodSet([rule, multirule])
        @test length(Novempuss.MethodSets.methodset(ms)) == 3
    end

    @testset "Linear Inference" begin
        ms = Novempuss.MethodSet(rule)
        g1 = Novempuss.Graphlet{Letter}(A(), ms)
        @test value.(collect(Novempuss.nodes(g1))) == ["A", "A|B", "A|B|C"]
        @test size(g1) == (3, 2)
        g2 = Novempuss.Graphlet{Letter}(B(), ms)
        @test value.(collect(Novempuss.nodes(g2))) == ["B", "B|C"]
        @test size(g2) == (2, 1)
        g3 = Novempuss.Graphlet{Letter}(C(), ms)
        @test value.(collect(Novempuss.nodes(g3))) == ["C"]
        @test size(g3) == (1, 0)
    end

    @testset "Multirule Inference" begin
        gl = Novempuss.Graphlet{Letter}(A(), Novempuss.MethodSet([rule, multirule]))
        nd = Novempuss.nodes(gl)
        @test permeq(["A", "A|B", "A|B|C", "<A|B|C|D|A>"], value.(nd))
        @test !Novempuss.Graphs.is_cyclic(Novempuss.graph(gl))
        nn = Dict(A => ["A|B", "<A|B|C|D|A>"], B => ["A|B|C"], C => ["<A|B|C|D|A>"], D => [])
        for d in nd
            @test permeq(nn[typeof(d)], value.(Novempuss.Graphs.neighbors(gl, d)))
        end
        @test (:rule, Tuple{A}) in Novempuss.edge(gl, A("A"), B("A|B"))
        @test (:rule, Tuple{B}) in Novempuss.edge(gl, B("A|B"), C("A|B|C"))
        @test (:multirule, Tuple{C, A}) in Novempuss.edge(gl, C("A|B|C"), D("<A|B|C|D|A>"))
        @test (:multirule, Tuple{C, A}) in Novempuss.edge(gl, A("A"), D("<A|B|C|D|A>"))
    end

    @testset "Circular Inference" begin
        gl = Novempuss.Graphlet{Letter}(A(), Novempuss.MethodSet(circular_rule))
        nd = collect(Novempuss.nodes(gl))
        @test value.(nd) == ["A", "A|B", "A|B|C"]
        @test size(gl) == (3, 3)
        @test Novempuss.Graphs.is_cyclic(Novempuss.graph(gl))
        for i in 1:length(nd)
            @test Novempuss.Graphs.neighbors(gl, nd[i]) == [nd[i%length(nd)+1]]
        end
    end

    @testset "Collatz Conjecture" begin
        ms = Novempuss.MethodSet(collatz)
        gl = Novempuss.Graphlet{BigInt}(BigInt(27), ms)
        @test size(gl) == (112, 111)
        graphlets = [Novempuss.Graphlet{BigInt}(BigInt(i), ms) for i in 1:26]
        gl = Novempuss._simple_merge(graphlets)
        @test size(gl) == (45, 44)
        nds = union(1:26, [28, 29, 32, 34, 35, 38, 40, 44, 46, 52, 53, 58, 64, 70, 76, 80, 88, 106, 160])
        glr = reduce(Novempuss._simple_merge, graphlets)
        @test permeq(nds, Novempuss.nodes(gl))
        @test Novempuss.graph(gl) == Novempuss.graph(glr)
        @test Novempuss.nodes(gl) == Novempuss.nodes(glr)
        @test Novempuss.links(gl) == Novempuss.links(glr)
        for (i, nn) in zip([10, 16, 22, 40], [[[3, 20], [5]], [[5, 32], [8]], [[7, 44], [11]], [[13, 80], [20]]])
            @test permeq(nn[1], Novempuss.inneighbors(gl, BigInt(i)))
            @test permeq(nn[2], Novempuss.outneighbors(gl, BigInt(i)))
        end
        for i in setdiff(nds, [1, 21, 15, 18, 24, 25, 10, 16, 22, 40])
            @test length(Novempuss.inneighbors(gl, BigInt(i))) == 1
            @test length(Novempuss.outneighbors(gl, BigInt(i))) == 1
        end
        for i in [21, 15, 18, 24, 25]
            @test length(Novempuss.inneighbors(gl, BigInt(i))) == 0
            @test length(Novempuss.outneighbors(gl, BigInt(i))) == 1
        end
        @test length(Novempuss.inneighbors(gl, BigInt(1))) == 1
        @test length(Novempuss.outneighbors(gl, BigInt(1))) == 0
    end

    @testset "Multidimensional Inference and Merge" begin
        ms = Novempuss.MethodSet(concat)
        g1 = Novempuss.Graphlet{String}(["A", "B"], ms)
        g2 = Novempuss.Graphlet{String}(["C", "D"], ms)
        g3 = Novempuss.Graphlet{String}(["E", "F"], ms)
        n1 = ["B", "A", "B|B", "B|A", "A|B", "A|A"]
        @test length(Novempuss.links(g1)) == Novempuss.Graphs.ne(g1)
        @test length(Novempuss.nodes(g1)) == Novempuss.Graphs.nv(g1)
        @test permeq(n1, Novempuss.nodes(g1))
        @test isempty(Novempuss.inneighbors(g1, "B"))
        @test isempty(Novempuss.inneighbors(g1, "A"))
        @test length(Novempuss.outneighbors(g1, "B")) == 3
        @test length(Novempuss.outneighbors(g1, "A")) == 3
        @test permeq(["B|B", "B|A", "A|B"], Novempuss.outneighbors(g1, "B"))
        @test permeq(["B|A", "A|B", "A|A"], Novempuss.outneighbors(g1, "A"))
        @test isempty(Novempuss.outneighbors(g1, "A|A"))
        @test Novempuss.inneighbors(g1, "A|A") == ["A"]
        @test permeq(["A", "B"], Novempuss.inneighbors(g1, "A|B"))
        g12 = Novempuss._merge(g1, g2, ms)
        @test length(Novempuss.links(g12)) == Novempuss.Graphs.ne(g12)
        @test length(Novempuss.nodes(g12)) == Novempuss.Graphs.nv(g12)
        @test permeq(["A", "B"], Novempuss.inneighbors(g12, "A|B"))
        @test permeq(["A", "D"], Novempuss.inneighbors(g12, "A|D"))
        @test length(Novempuss.outneighbors(g12, "A")) == length(Novempuss.outneighbors(g12, "D"))
        @test length(Novempuss.outneighbors(g12, "B")) == length(Novempuss.outneighbors(g12, "C"))
        g123 = Novempuss._merge([g1, g2, g3], ms)
        @test length(Novempuss.links(g123)) == Novempuss.Graphs.ne(g123)
        @test length(Novempuss.nodes(g123)) == Novempuss.Graphs.nv(g123)
        @test permeq(["A", "B"], Novempuss.inneighbors(g123, "A|B"))
        @test permeq(["A", "D"], Novempuss.inneighbors(g123, "A|D"))
        @test permeq(["A", "F"], Novempuss.inneighbors(g123, "A|F"))
        @test permeq(["C", "F"], Novempuss.inneighbors(g123, "C|F"))
        @test length(Novempuss.outneighbors(g123, "A")) == length(Novempuss.outneighbors(g123, "D"))
        @test length(Novempuss.outneighbors(g123, "B")) == length(Novempuss.outneighbors(g123, "C"))
        @test length(Novempuss.outneighbors(g123, "A")) == length(Novempuss.outneighbors(g123, "E"))
        @test length(Novempuss.outneighbors(g123, "B")) == length(Novempuss.outneighbors(g123, "F"))
    end
end
