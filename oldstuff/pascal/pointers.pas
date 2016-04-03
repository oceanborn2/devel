Program Pointeurs;

Uses Crt;

Type
    Iptr = ^Integer;

Var I,J,A,MAX : Integer;
    P         : Array [1..255] of Iptr;
    CH        : Char;

Procedure DoIt;
Begin
     For I:=1 To 255 Do
     Begin
          Readln(A);
          New(P[i]);
          P[i]^:=A;
          If (A=0) then Begin Max:=I; Clrscr; Exit; End;
          End;
     Clrscr;
     End;

Procedure Disp;
Begin
     Clrscr;
     For I:=1 to Max Do
     Begin
          If (P[i]<>Nil) Then
          Begin
               Write(I);
               Gotoxy (30,WhereY);
               Writeln(P[i]^);
               End;
          End;
     End;

Procedure Init;
Begin
     Clrscr;
     For I:=1 To 255 Do P[I]:=Nil;
     DoIt;
     Disp;
     End;

Procedure Modif;
Begin
     Writeln;
     Write ('Modification d''une donn‚e   > ');
     Readln(I);
     If Not (I in [1..Max]) then Modif;
     Readln(A);
     P[I]^:=A; Write('--> ',I,'   ',A);
     Disp;
     End;

Procedure Dispse;
Begin
     Writeln;
     Writeln ('Destruction d''une donn‚e  > ');
     Readln(I); Writeln(P[i]^);
     If (I=Max) Then Dec(Max);
     Dispose(P[I]);
     P[i]:=Nil;
     Disp;
     End;

Procedure Clean;
Begin
     For I:=1 To Max Do
     Begin
          If (P[i]<>Nil) Then Dispose(P[i]);
          End;
     Writeln('Au revoir et … bient“t');
     Halt(0);
     End;

Procedure Modify;
Begin
     Ch:=Upcase(Readkey);
     Case ch of
          #27:Clean;
          'A':Dispse;
          'M':Modif;
          End;
     Modify;
     End;

Begin
     Init;
     Modify;
     End.

