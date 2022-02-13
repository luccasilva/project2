(* Plc interpreter main file *)

CM.make("$/basis.cm");
CM.make("$/ml-yacc-lib.cm");

use "Environ.sml";
use "Absyn.sml";
use "PlcParserAux.sml";
use "PlcParser.yacc.sig";
use "PlcParser.yacc.sml";
use "PlcLexer.lex.sml";
use "Parse.sml";
use "PlcInterp.sml";
use "PlcChecker.sml";

Control.Print.printLength := 1000;
Control.Print.printDepth  := 1000;
Control.Print.stringDepth := 1000;

open PlcFrontEnd;

fun run exp =
        let
            val expType = teval exp []
            val expResult = eval exp []
        in
            val2string(expResult) ^ " : " ^ type2string(expType)
        end
        (*INTERPRETER EXCEPTIONS*)
        handle Impossible => "Impossible: esse erro nao deveria acontecer"
        | HDEmptySeq =>  "HDEmptySeq: sem permissao para acessar o HEAD"
        | TLEmptySeq =>  "TLEmptySeq: sem permissao para acessar o TAIL"
        | ValueNotFoundInMatch =>  "ValueNotFoundInMatch: casamento nao encontrado"
        | NotAFunc =>  "NotAFunc: tratamento de nao-funcoes nao permitido"
        (*TYPE CHECKER EXCEPTIONS*)
        | EmptySeq =>  "EmptySeq: sequencia sem tipos nao permitidas"
        | UnknownType => "UnknownType: tipo desconhecido"
        | NotEqTypes =>  "NotEqTypes: comparar tipos diferentes nao e permitido"
        | WrongRetType =>  "WrongRetType: diferente tipo de declaracao"
        | DiffBrTypes =>  "DiffBrTypes: nao permitido"
        | IfCondNotBool =>  "IfCondNotBool: condicao nao booleana nao permitida"
        | NoMatchResults =>  "NoMatchResults: sem resultado no casamento"
        | MatchResTypeDiff =>  "MatchResTypeDiff: diferentes resultados no casamento nao permitido"
        | MatchCondTypesDiff =>  "MatchCondTypesDiff: diferentes condicoes no casamento nao permitido"
        | CallTypeMisM =>  "CallTypeMisM: impossivel chamar uma funcao sem tipo"
        | NotFunc =>  "NotFunc: nao e uma funcao"
        | ListOutOfRange =>  "ListOutOfRange: lista fora do escopo"
        | OpNonList =>  "OpNonList: tratando algo que nao e uma lista"
        (*ENVIRON EXCEPTIONS*)
        | SymbolNotFound => "SymbolNotFound: sem definicao de simbolo"
        (*UNKNOWN EXCEPTIONS*)
        | _ => "UnknownError: erro nao encontrado"