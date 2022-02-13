use "Plc.sml";
exception testError;

(*TESTES DO PROFESSOR - TYPE CHECKING*)

(*Should NOT raise exceptions*)
teval(If(Prim2("=", ConI 11, ConI 12), ConI 1, ConI 0))[];
teval(Let("b", Prim2("=", ConI 1, ConI 2), If(Var "b", ConI 3, ConI 4)))[];
teval(Letrec("f1",IntT,"x",IntT,Prim2 ("+",Var "x",ConI 1),Call (Var "f1",ConI 12)))[];

(*Must throw exceptions*)
let
    val test = teval(Let("b", Prim2("=", ConI 1, ConI 2),If(Var "b", Var "b", ConI 6)))[];
in 
    print("ERRO! => DiffBrTypes não deu raised\n");
    raise testError
end handle DiffBrTypes => print ("PASSOU! => DiffBrTypes deu raised\n");

let
    val test = teval(Let("f",Anon (BoolT,"x",If (Var "x",ConI 11,ConI 22)),Call (Var "f",ConI 0)))[];
in
    print("ERRO! => CallTypeMisM não deu raised\n");
    raise testError
end handle CallTypeMisM => print ("PASSOU! => CallTypeMisM deu raised\n"); 

let 
    val test = teval(Letrec("f",BoolT,"x",BoolT,If (Var "x",ConI 11,ConI 22), Call (Var "f",ConB true)))[];
in
    print("ERRO! => WrongRetType não deu raised\n");
    raise testError
end handle WrongRetType => print ("PASSOU! => WrongRetType deu raised\n");

(*TESTES CRIADOS - TYPE CHECKING*)

let
    val test = teval (fromString "(Int [])") [];
in
    print("ERRO! => EmptySeq não deu raised\n");
    raise testError
end handle EmptySeq => print ("PASSOU! => EmptySeq deu raised\n");

let
    val test = teval (fromString "(3::4)") [("t", IntT)]
in
    print("ERRO! => UnknownType não deu raised\n");
    raise testError
end handle UnknownType => print ("PASSOU! => UnknownType deu raised\n");

let
    val test = teval (fromString "false != 2") [];
in
    print("ERRO! => NotEqTypes não deu raised\n");
    raise testError
end handle NotEqTypes => print ("PASSOU! => NotEqTypes deu raised\n");

let
    val test = teval (fromString "fun rec f():Bool = 0; f()") [];
in
    print("ERRO! => WrongRetType não deu raised\n");
    raise testError
end handle WrongRetType => print ("PASSOU! => WrongRetType deu raised\n");

let
    val test = teval (fromString "if foo then 0 else false") [("foo", BoolT)];
in
    print("ERRO! => DiffBrTypes não deu raised\n");
    raise testError
end handle DiffBrTypes => print ("PASSOU! => DiffBrTypes deu raised\n");

let
    val test = teval (fromString "if foo then 0 else 2") [("foo", IntT)];
in
    print("ERRO! => IfCondNotBool não deu raised\n");
    raise testError
end handle IfCondNotBool => print ("PASSOU! => IfCondNotBool deu raised\n");

let
    val test = teval (fromString "match foo with end") [("foo", IntT)];
in
    print("ERRO! => NoMatchResults não deu raised\n");
    raise testError
end handle NoMatchResults => print ("PASSOU! => NoMatchResults deu raised\n");

let
    val test = teval (fromString "match x with | 1 -> 0 | _ -> false end") [("x", IntT)]
in
    print("ERRO! => MatchResTypeDiff não deu raised\n");
    raise testError
end handle MatchResTypeDiff => print ("PASSOU! => MatchResTypeDiff deu raised\n");

let
    val test = teval (fromString "match x with | 1 -> true | 0 -> false end") [("x", BoolT)]
in
    print("ERRO! => MatchCondTypesDiff não deu raised\n");
    raise testError
end handle MatchCondTypesDiff => print ("PASSOU! => MatchCondTypesDiff deu raised\n");

let
    val test = teval (fromString "fun rec f():Bool = 0; f(1)") [];
in
    print("ERRO! => CallTypeMisM não deu raised\n");
    raise testError
end handle CallTypeMisM => print ("PASSOU! => CallTypeMisM deu raised\n");

let
    val test = teval (fromString "var x = false; x(false)") []
in
    print("ERRO! => NotFunc não deu raised\n");
    raise testError
end handle NotFunc => print ("PASSOU! => NotFunc deu raised\n");

let
    val test = teval (fromString "(1,2,3,4)[5]") []
in
    print("ERRO! => ListOutOfRange não deu raised\n");
    raise testError
end handle ListOutOfRange => print ("PASSOU! => ListOutOfRange deu raised\n");

let
    val test = teval (fromString "var x = false; x[1]") []
in
    print("ERRO! => OpNonList não deu raised\n");
    raise testError
end handle OpNonList => print ("PASSOU! => OpNonList deu raised\n");

(*TESTES CRIADOS - INTERPRETER*)

let 
    val test = eval (fromString "foo = false") [("foo", IntV 123)]
in
    print("ERRO! => Impossible deveria ter raised\n");
    raise testError
end handle Impossible => print ("PASSOU! => Impossible deu raised\n");

let 
    val test = eval (fromString "hd ([Int] [])") []
in
    print("ERRO! => HDEmptySeq deveria ter raised\n");
    raise testError
end handle HDEmptySeq => print ("PASSOU! => HDEmptySeq deu raised\n");

let 
    val test = eval (fromString "tl ([Int] [])") []
in
    print("ERRO! => TLEmptySeq deveria ter raised\n");
    raise testError
end handle TLEmptySeq => print ("PASSOU! => TLEmptySeq deu raised\n");

let 
    val test = eval (fromString "match foo with | true -> 1 end") [("foo", BoolV false)]
in
    print("ERRO! => ValueNotFoundInMatch deveria ter raised\n");
    raise testError
end handle ValueNotFoundInMatch => print ("PASSOU! => ValueNotFoundInMatch deu raised\n");

let 
    val test = eval (fromString "var foo = false; foo(false)") []
in
    print("ERRO! => NotAFunc deveria ter raised\n");
    raise testError
end handle NotAFunc => print ("PASSOU! => NotAFunc deu raised\n");

(*TESTES CRIADOS - ENVIRONING*)

let 
    val test = teval (fromString "foo") [("foo", BoolT)];
in
    let
        val test = teval (fromString "foo") [];
    in
        print("ERRO! => SymbolNotFound deveria ter dado raised\n");
        raise testError
    end handle SymbolNotFound => {}
end handle test => print("PASSOU! => SymbolNotFound deu raised\n");

print("SUCCESSO!");