Program PGCD;

Uses Crt;

Var X,Y,I : Integer;
    Ch    : char;

Begin
     Clrscr;
     Writeln ('entrez X et Y : ');
     Readln(X,Y);
     If Y<X Then
     Begin
          I:=X;
          X:=Y;
          Y:=I;
          End;
     Writeln (x,' ',y);
     Repeat
           Y:=X mod Y;
           Until X mod Y = 0;
     Writeln (x);
     Ch:=readkey;
     End.

