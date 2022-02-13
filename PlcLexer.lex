(* Plc Lexer *)

(* User declarations *)

open Tokens
type pos = int
type slvalue = Tokens.svalue
type('a,'b) token =('a,'b) Tokens.token
type lexresult =(slvalue, pos)token

(* A function to print a message error on the screen. *)
val error = fn x => TextIO.output(TextIO.stdOut, x ^ "\n")
val lineNumber = ref 0

(* Get the current line being read. *)
fun getLineAsString() =
    let
        val lineNum = !lineNumber
    in
        Int.toString lineNum
    end

fun strtoint s =
    case Int.fromString s of
        SOME i => i
        | NONE => raise Fail("Não foi possivel converter '" ^ s ^ "' para int")

fun keyWord(s, x, y) =
    case s of 
        "var" => VAR(x, y)
        | "fun" => FUN(x, y)
        | "rec" => REC(x, y)
        | "if" => IF(x, y)
        | "then" => THEN(x, y)
        | "else" => ELSE(x, y)
        | "match" => MATCH(x, y)
        | "with" => WITH(x, y)
        | "hd" => HD(x, y)
        | "tl" => TL(x, y)
        | "ise" => ISE(x, y)
        | "print" => PRINT(x, y)
        | "fn" => ANONF(x, y)
        | "end" => END(x, y)
        | "true" => TRUE(x, y)
        | "false" => FALSE(x, y)
        | "_" => UNDERSCORE(x, y)
        | "Nil" => NIL(x, y)
        | "Bool" => BOOL(x, y)
        | "Int" => INT(x, y)
        | _   => NAME(s, x, y)

(* Define what to do when the end of the file is reached. *)
fun eof() = Tokens.EOF(0,0)

(* Initialize the lexer. *)
fun init() =()

%%
%header (functor PlcLexerFun( structure Tokens: PlcParser_TOKENS ));
whitespace = [\ \t];
alpha = [A-Za-z];
digit = [0-9];
identifier = [a-zA-Z_][a-zA-Z_0-9]*;

%s COMMENTARY;
%%

\n => (lineNumber := !lineNumber + 1; lex());
<INITIAL>{whitespace}+ => (lex());
<INITIAL>{digit}+ => (CINT(strtoint(yytext), yypos, yypos));
<INITIAL>{identifier} => (keyWord(yytext, yypos, yypos));
<INITIAL>"+" => (MAIS(yypos, yypos));
<INITIAL>"-" => (MENOS(yypos, yypos));
<INITIAL>"*" => (MULTI(yypos, yypos));
<INITIAL>"/" => (DIV(yypos, yypos));
<INITIAL>"=" => (IGUAL(yypos, yypos));
<INITIAL>"!=" => (DIF(yypos, yypos));
<INITIAL>"<" => (MENOR(yypos, yypos));
<INITIAL>"<=" => (MENORIGUAL(yypos, yypos));
<INITIAL>":" => (DOISP(yypos, yypos));
<INITIAL>"!" => (NOT(yypos, yypos));
<INITIAL>"&&" => (AND(yypos, yypos));
<INITIAL>"::" => (DOISDOISP(yypos, yypos));
<INITIAL>";" => (PONTOVIRG(yypos, yypos));
<INITIAL>"=>" => (AFARROW(yypos, yypos));
<INITIAL>"," => (VIRG(yypos, yypos));
<INITIAL>"|" => (BARRA(yypos, yypos));
<INITIAL>"->" => (MARROW(yypos, yypos));
<INITIAL>"[" => (ACOL(yypos, yypos));
<INITIAL>"]" => (FCOL(yypos, yypos));
<INITIAL>"(" => (APAR(yypos, yypos));
<INITIAL>")" => (FPAR(yypos, yypos));
<INITIAL>"{" => (ACHAVE(yypos, yypos));
<INITIAL>"}" => (FCHAVE(yypos, yypos));
<INITIAL>"(*" => (YYBEGIN COMMENTARY; lex());
<COMMENTARY>"*)" => (YYBEGIN INITIAL; lex());
<COMMENTARY>. => (lex());
<INITIAL>. => (error("\n***Erro ***\n");
                raise Fail("Erro no character do Lexer " ^yytext));