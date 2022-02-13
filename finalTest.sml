exception codeError;

use "testInterpreting.sml";
use "testEnvironing.sml";
use "testParserCases.sml";
use "testParser.sml";
use "testTypeChecking.sml";

fun runAll ([]) = "SUCCESSO!\n"
    | runAll ((x:string,y:expr)::t) = 
        let in 
            val2string(eval(fromString(x))[]);
            runAll(t) 
        end; 

use "Plc.sml";
val result = val2string (eval(fromFile ("example.plc"))[]);
if result <> "15" then raise codeError else true;

print ("Se não houve raised então SUCESSO!\n");
