%%

%name PlcParser

%pos int

%term VAR
    | FUN | REC | DOISP
    | IF | THEN | ELSE
    | MATCH | WITH
    | NOT
    | HD | TL | ISE
    | PRINT
    | AND
    | MAIS | MENOS | MULTI | DIV | IGUAL | DIF | MENOR | MENORIGUAL
    | ANONF | AFARROW | END
    | TRUE | FALSE
    | DOISDOISP
    | PONTOVIRG
    | VIRG
    | ACOL | FCOL | APAR | FPAR | ACHAVE | FCHAVE
    | BARRA | MARROW
    | UNDERSCORE
    | NIL | BOOL | INT
    | NAME of string | CINT of int
    | EOF

%nonterm Prog of expr
        | Decl of expr
        | Expr of expr
        | AtomExpr of expr
        | AppExpr of expr
        | Const of expr
        | Comps of expr list
        | MatchExpr of (expr option * expr) list
        | CondExpr of expr option
        | Args of (plcType * string) list
        | Params of (plcType * string) list
        | TypedVar of plcType * string
        | Type of plcType
        | AtomType of plcType
        | Types of plcType list

%right PONTOVIRG MARROW
%nonassoc IF
%left ELSE
%left AND
%left IGUAL DIF
%left MENOR MENORIGUAL
%right DOISDOISP
%left MAIS MENOS
%left MULTI DIV
%nonassoc NOT HD TL ISE PRINT
%left ACOL

%eop EOF

%noshift EOF

%start Prog

%%

Prog: Expr (Expr) 
    | Decl (Decl)

Decl: VAR NAME IGUAL Expr PONTOVIRG Prog (Let(NAME, Expr, Prog))
    | FUN NAME Args IGUAL Expr PONTOVIRG Prog (Let(NAME, makeAnon(Args, Expr), Prog))
    | FUN REC NAME Args DOISP Type IGUAL Expr PONTOVIRG Prog (makeFun(NAME, Args, Type, Expr, Prog))

Expr: AtomExpr(AtomExpr)
    | AppExpr(AppExpr)
    | IF Expr THEN Expr ELSE Expr (If(Expr1, Expr2, Expr3))
    | MATCH Expr WITH MatchExpr (Match(Expr, MatchExpr))
    | NOT Expr (Prim1("!", Expr))
    | Expr AND Expr (Prim2("&&", Expr1, Expr2))
    | HD Expr (Prim1("hd", Expr))
    | TL Expr (Prim1("tl", Expr))
    | ISE Expr (Prim1("ise", Expr))
    | PRINT Expr (Prim1("print", Expr))
    | Expr MAIS Expr (Prim2("+", Expr1, Expr2))
    | Expr MENOS Expr (Prim2("-", Expr1, Expr2))
    | Expr MULTI Expr (Prim2("*", Expr1, Expr2))
    | Expr DIV Expr (Prim2("/", Expr1, Expr2))
    | MENOS Expr (Prim1("-", Expr))
    | Expr IGUAL Expr (Prim2("=", Expr1, Expr2))
    | Expr DIF Expr (Prim2("!=", Expr1, Expr2))
    | Expr MENOR Expr (Prim2("<", Expr1, Expr2))
    | Expr MENORIGUAL Expr (Prim2("<=", Expr1, Expr2))
    | Expr DOISDOISP Expr (Prim2("::", Expr1, Expr2))
    | Expr PONTOVIRG Expr (Prim2(";", Expr1, Expr2))
    | Expr ACOL CINT FCOL (Item(CINT, Expr))

AtomExpr: Const (Const)
        | NAME (Var(NAME))
        | ACHAVE Prog FCHAVE (Prog)
        | APAR Comps FPAR (List(Comps))
        | APAR Expr FPAR (Expr)
        | ANONF Args AFARROW Expr END (makeAnon(Args, Expr))

AppExpr: AtomExpr AtomExpr (Call(AtomExpr1, AtomExpr2))
       | AppExpr AtomExpr (Call(AppExpr, AtomExpr))

Const: TRUE (ConB true) | FALSE (ConB false)
     | CINT (ConI(CINT))
     | APAR FPAR (List [])
     | APAR Type ACOL FCOL FPAR (ESeq(Type))

Comps: Expr VIRG Expr (Expr1 :: Expr2 :: [])
     | Expr VIRG Comps (Expr :: Comps)

MatchExpr: END ([])
         | BARRA CondExpr MARROW Expr MatchExpr ((CondExpr, Expr) :: MatchExpr)

CondExpr: UNDERSCORE (NONE)
        | Expr (SOME Expr)

Args: APAR FPAR ([])
    | APAR Params FPAR (Params)
    
Params: TypedVar (TypedVar :: [])
      | TypedVar VIRG Params (TypedVar :: Params)

TypedVar: Type NAME ((Type, NAME))

Type: AtomType (AtomType)
    | APAR Types FPAR (ListT(Types))
    | ACOL Type FCOL (SeqT(Type))
    | Type MARROW Type (FunT (Type1, Type2))

AtomType: NIL (ListT [])
        | BOOL (BoolT)
        | INT (IntT)
        | APAR Type FPAR (Type)

Types: Type VIRG Type (Type1::Type2::[])
     | Type VIRG Types (Type::Types)
