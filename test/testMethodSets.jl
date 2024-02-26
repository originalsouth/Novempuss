@testset "MethodSets" begin
    @testset "Test Method getters" begin
        eval_method = first(methods(eval))
        @test Novempuss.MethodSets.name(eval_method) == :eval
        @test Novempuss.MethodSets.mod(eval_method) == Base.MainInclude
        @test sign(eval_method) == Tuple{Any}
        @test Novempuss.MethodSets.args(eval_method) == 1
        @test run(eval_method) == eval
        @test run(eval_method, ("test",)) == "test"
    end

    @testset "Test MethodSet Constructors" begin
        @test Novempuss.MethodSet isa DataType
        @test Novempuss.MethodSet() isa Novempuss.MethodSets.MethodSet
        @test Novempuss.MethodSet(first(methods(test_ms_f))) isa Novempuss.MethodSets.MethodSet
        @test Novempuss.MethodSet(test_ms_f) isa Novempuss.MethodSets.MethodSet
        @test Novempuss.MethodSet(methods(test_ms_f)) isa Novempuss.MethodSets.MethodSet
        @test Novempuss.MethodSet([test_ms_f, test_ms_g]) isa Novempuss.MethodSets.MethodSet
    end

    @testset "Test MethodSet Pushing and Deleting" begin
        ms = Novempuss.MethodSet()
        push!(ms, test_ms_f)
        @test length(Novempuss.MethodSets.methodset(ms)) == 6
        delete!(ms, first(methods(test_ms_f)))
        @test length(Novempuss.MethodSets.methodset(ms)) == 5
        delete!(ms, test_ms_f)
        @test length(Novempuss.MethodSets.methodset(ms)) == 0
        push!(ms, first(methods(test_ms_f)))
        @test length(Novempuss.MethodSets.methodset(ms)) == 1
        push!(ms, test_ms_f)
        @test length(Novempuss.MethodSets.methodset(ms)) == 6
        push!(ms, test_ms_g)
        @test length(Novempuss.MethodSets.methodset(ms)) == 8
        delete!(ms, test_ms_f)
        @test length(Novempuss.MethodSets.methodset(ms)) == 2
        delete!(ms, test_ms_f)
        @test length(Novempuss.MethodSets.methodset(ms)) == 2
    end

    @testset "Test MethodSet merge and methodset getter" begin
        msf = Novempuss.MethodSet(test_ms_f)
        msg = Novempuss.MethodSet(test_ms_g)
        ms = Novempuss.MethodSet([test_ms_f, test_ms_g])
        @test length(Novempuss.MethodSets.methodset(msf)) == 6
        @test length(Novempuss.MethodSets.methodset(msg)) == 2
        @test length(Novempuss.MethodSets.methodset(ms)) == 8
        @test length(Novempuss.MethodSets.methodset(msf, 1)) == length(Novempuss.MethodSets.methodset(msg, 1))
        @test length(Novempuss.MethodSets.methodset(msf, [1, 2])) == 4
        @test length(Novempuss.MethodSets.methodset(msf, [1, 3])) == 4
        @test length(Novempuss.MethodSets.methodset(msf, [2, 3])) == 4
        @test length(Novempuss.MethodSets.methodset(msf, [3, 2])) == 4
        @test length(Novempuss.MethodSets.methodset(msf, [2, 1])) == 4
        @test length(Novempuss.MethodSets.methodset(msf, [3, 1])) == 4
        for T in sign(ms)
            for method in filter(x -> sign(x) == T, methods(test_ms_f))
                @test method in ms[T]
            end
            for method in filter(x -> sign(x) == T, methods(test_ms_g))
                @test method in ms[T]
            end
        end
    end

    @testset "Test MethodSet signatures" begin
        ms = Novempuss.MethodSet([test_ms_f, test_ms_g])
        sigs = sign(ms)
        @test sigs isa Set{DataType}
        for signature in union(sign.(methods(test_ms_f)), sign.(methods(test_ms_g)))
            @test signature in sigs
        end
        sigs = sign(ms, 1)
        @test sigs isa Set{DataType}
        for signature in [Tuple{Int64}, Tuple{Float64}]
            @test signature in sigs
        end
    end

    @testset "Test MethodSet runs" begin
        ms = Novempuss.MethodSet([test_ms_f, test_ms_g])
        arguments = Vector{Tuple}([(1,), ("_",), (1.0,), (3.0, 4.0)])
        @test run(ms, ("_",)) == Any[]
        results = sort.(run(ms, arguments))
        @test results == [[1, 2], Any[], [exp(1.0), pi], [5.0]]
    end
end
