use "Plc.sml";
exception testError;

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