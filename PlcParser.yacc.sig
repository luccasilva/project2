signature PlcParser_TOKENS =
sig
type ('a,'b) token
type svalue
val EOF:  'a * 'a -> (svalue,'a) token
val CINT: (int) *  'a * 'a -> (svalue,'a) token
val NAME: (string) *  'a * 'a -> (svalue,'a) token
val INT:  'a * 'a -> (svalue,'a) token
val BOOL:  'a * 'a -> (svalue,'a) token
val NIL:  'a * 'a -> (svalue,'a) token
val UNDERSCORE:  'a * 'a -> (svalue,'a) token
val MARROW:  'a * 'a -> (svalue,'a) token
val BARRA:  'a * 'a -> (svalue,'a) token
val FCHAVE:  'a * 'a -> (svalue,'a) token
val ACHAVE:  'a * 'a -> (svalue,'a) token
val FPAR:  'a * 'a -> (svalue,'a) token
val APAR:  'a * 'a -> (svalue,'a) token
val FCOL:  'a * 'a -> (svalue,'a) token
val ACOL:  'a * 'a -> (svalue,'a) token
val VIRG:  'a * 'a -> (svalue,'a) token
val PONTOVIRG:  'a * 'a -> (svalue,'a) token
val DOISDOISP:  'a * 'a -> (svalue,'a) token
val FALSE:  'a * 'a -> (svalue,'a) token
val TRUE:  'a * 'a -> (svalue,'a) token
val END:  'a * 'a -> (svalue,'a) token
val AFARROW:  'a * 'a -> (svalue,'a) token
val ANONF:  'a * 'a -> (svalue,'a) token
val MENORIGUAL:  'a * 'a -> (svalue,'a) token
val MENOR:  'a * 'a -> (svalue,'a) token
val DIF:  'a * 'a -> (svalue,'a) token
val IGUAL:  'a * 'a -> (svalue,'a) token
val DIV:  'a * 'a -> (svalue,'a) token
val MULTI:  'a * 'a -> (svalue,'a) token
val MENOS:  'a * 'a -> (svalue,'a) token
val MAIS:  'a * 'a -> (svalue,'a) token
val AND:  'a * 'a -> (svalue,'a) token
val PRINT:  'a * 'a -> (svalue,'a) token
val ISE:  'a * 'a -> (svalue,'a) token
val TL:  'a * 'a -> (svalue,'a) token
val HD:  'a * 'a -> (svalue,'a) token
val NOT:  'a * 'a -> (svalue,'a) token
val WITH:  'a * 'a -> (svalue,'a) token
val MATCH:  'a * 'a -> (svalue,'a) token
val ELSE:  'a * 'a -> (svalue,'a) token
val THEN:  'a * 'a -> (svalue,'a) token
val IF:  'a * 'a -> (svalue,'a) token
val DOISP:  'a * 'a -> (svalue,'a) token
val REC:  'a * 'a -> (svalue,'a) token
val FUN:  'a * 'a -> (svalue,'a) token
val VAR:  'a * 'a -> (svalue,'a) token
end
signature PlcParser_LRVALS=
sig
structure Tokens : PlcParser_TOKENS
structure ParserData:PARSER_DATA
sharing type ParserData.Token.token = Tokens.token
sharing type ParserData.svalue = Tokens.svalue
end
