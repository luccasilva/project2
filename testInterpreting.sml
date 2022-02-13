use "Plc.sml";
exception testError;

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


print("SUCCESS!\n")