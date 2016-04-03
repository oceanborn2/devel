Program Graftabl;

Uses Crt,Dos;

Type
    PtrSep = Record
             O : Word;
             S : Word;
             End;

    Table = Array [1..512] of char;
    Str8  = String[8];

Var P  : Pointer;
    G  : ^PtrSep;
    H  : ^Table;

    I  : Integer;
    C  : Integer;
    Ch : Char;
    Car : Integer;

Function Bin (N : Char) : Str8;
Var S : String[8];
    X : Integer;
    B : Integer;
Begin
     S:='';
     B:=Ord(N);
     For X:=0 To 7
     Do
     Begin
          S[8-X]:=Chr(48+B mod 2);
          B:=B div 2;
          Inc(S[0]);
          End;
     Bin:=S;
     End;

Function ExplodeBin(N : Char) : String;
Var X : Integer;
    S1,S2 : String;
Begin
     S1:=Bin(N);
     S2:='';
     For X:=1 To 8 Do
     Begin
          S2:=S2+S1[X]+' ';
          End;
     ExplodeBin:=S2;
     End;

Function Hex (N : Word) : String;
Var L,H   : Byte;
    L1,H1 : Byte;
    S     : String;
Const hexa : String = '01234567890ABCDEF';
Begin
     S:='';
     H:=N div 256;
     L1:=H mod 16;
     H1:=H div 16;
     S:=S+Hexa[ H1+1 ] + Hexa[ L1+1 ];
     L:=N mod 256;
     L1:=L mod 16;
     H1:=L div 16;
     S:=S+Hexa[ H1+1 ] + Hexa [ L1+1 ];
     Hex:=S;
     End;

Begin
     Clrscr;
     GetIntVec($1F,P);
     G:=P;
     H:=P;
     C:=0;
     Car:=0;
     For I:=0 To 255*8 Do
     Begin
           Inc(C);
           If C=8 Then
           Begin
                C:=0;
                Inc(Car);
                Ch:=Readkey;
                Clrscr;
                End;
           Write(Chr(Car),'     ',Car);
           Gotoxy(10,10+C);
           Writeln(ExplodeBin(H^[i]));
           End;
     End.

