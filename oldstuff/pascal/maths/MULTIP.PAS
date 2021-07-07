Program Multiplication_Egyptienne;

Uses Crt;

Var A,B,Som,M : Integer;
    Par       : Boolean;

Procedure Echange (Var A,B : Integer);
Var S : Integer;
Begin
     S:=B;
     B:=A;
     A:=S;
     Writeln (A,' <--> ',B);
     End;

Procedure Pair(N : Integer; Var R : Boolean);
Begin
     If (N mod 2) = 0 Then R:=True Else R:=False;
     End;

Procedure Div2(Var N : Integer);
Begin
     N:=N div 2;
     End;

Procedure Add (Source : Integer; Var Dest : Integer);
Begin
     Dest:=Dest+Source;
     End;

Begin
     Clrscr;
     Writeln ('Entrez A : ');
     Readln(A);
     Writeln ('Entrez B : ');
     Readln(B);
     Som:=0;
     If A<B Then Echange(A,B);
     Writeln (A,' * ',B,' + ',Som,' = ',A*B+Som);
     While B<>1 Do
     Begin
          Pair(B,Par);
          If Not Par Then
                     Begin
                          B:=B-1;
                          Som:=Som+A;
                     End
                Else
                     Begin
                          Div2(B);
                          M:=A;
                          Add(M,A);
                     End;
     Writeln (A,' * ',B,' + ',Som,' = ',(A*B)+Som);
          End;
     Writeln (A,' * ',B,' + ',Som,' = ',(A*B)+Som);
     End.

