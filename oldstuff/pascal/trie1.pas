Program Tri;

Uses Crt;

Const Max = 1500;

Var A,B   : Array [1..Max] of integer;
    I,J   : Integer;
    CP    : Integer;
    Ch    : Char;
    Per   : Boolean;

Procedure Affiche;
Begin
     For I:=1 To Max Do Write(B[i],' ');
     End;

Procedure Trie;
Begin
     Cp:=0;
     For I:=1 To 1500 Do
     Begin
          For J:=1 To Max Do
          Begin
               If (A[j]=i) Then
                              Begin
                                   Inc(Cp);
                                   B[cp]:=I;
                                   End;
               End;
          If Cp=500 Then Exit;
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