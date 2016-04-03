Program Rand_Generator;

Uses Crt;

Type Tab = Array [1..1000] of byte;

Var I   : Integer;
    A,B : Tab;

Procedure GetParam;
Var X : Integer;
    Idem : Boolean;
Begin
     Clrscr;
     Writeln ('entrez la valeur du RANDSEED : ');
     Readln(X);
     RandSeed:=X;
     For I:=1 To 1000 Do A[I]:=Random(255);
     RandSeed:=X;
     For I:=1 To 1000 Do B[I]:=Random(255);
     Idem:=True;
     For I:=1 To 1000 Do
     Begin
          If A[i]<>B[i] Then Idem:=False;
          End;
     If Idem Then Writeln ('Identique') Else Writeln ('Diff‚rent');
     End;

Begin
     GetParam;
     End.
