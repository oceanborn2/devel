{trie trois nombres A,B et C dans l'ordre croissant}

Program TriABC;

uses crt;

Var A,B,C,D : Integer;
    Ch      : char;

Begin
     Writeln ('Entrez A,B et C : ');
     Readln (A,B,C);
     If (A>B) Then
                 Begin
                      D:=A;
                      A:=B;
                      B:=D;
                 End;
     If (A>C) Then
                  Begin
                       D:=A;
                       A:=C;
                       C:=D;
                  End;
     If (B>C) Then
                  Begin
                       D:=B;
                       B:=C;
                       C:=D;
                  End;
     Writeln (A,' ',B,' ',C);
     Ch:=readkey;
     End.
