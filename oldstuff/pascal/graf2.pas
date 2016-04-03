Program Graftabl;

Uses Crt,Dos;

Type
    PtrSep = Record
             S : Word;
             O : Word;
             End;

    Table = Array [1..512] of char;

    Str8  = String[8];

Var P  : Pointer;
    G  : ^PtrSep;
    H  : ^Table;

    I  : Integer;
    Ch : Char;

Begin
     Clrscr;
     GetIntVec($1F,P);
     G:=P;
     H:=Ptr(G^.S,G^.O);
     For I:=0 To 255 Do H^[i]:=Chr(Random(255));
     For I:=0 To 32 Do Write(Chr(I));
     End.

