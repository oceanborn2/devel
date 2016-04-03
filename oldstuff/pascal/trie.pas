Program Tri;

Uses Crt;

Const Max = 1500;

Var A     : Array [1..Max] of integer;
    I,J,D : Integer;
    Ch    : Char;
    Per   : Boolean;

Procedure Affiche;
Begin
     For I:=1 To Max Do Write(A[i],' ');
     End;

Procedure Trie;
Begin
     Per:=False;
     For I:=1 To Max Do
     Begin
          Per:=False;
          For J:=1 To Max Do
          Begin
               If (A[i]<=A[j]) Then
                              Begin
                                   D:=A[i];
                                   A[i]:=A[j];
                                   A[j]:=D;
                                   Per:=True;
                                   End;
               End;
          If Not Per Then Exit;
          End;
     End;

Begin
     RandSeed:=1;
     Clrscr;
     For I:=1 To Max Do A[i]:=Random(Max);
     Trie;
     Affiche;
     Ch:=Readkey;
     End.
