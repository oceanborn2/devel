Program ParseSectors;

Uses Crt,Disk;

Var F,P,S : Integer;
    I     : Integer;
    Ch    : Char;

Begin
     Clrscr;
     For I:=0 To 40 Do
     Begin
          Decompose(I,P,S,F);
          Writeln;
          Writeln ('Absolu  : ',I);
          Writeln ('Piste   : ',P);
          Writeln ('Secteur : ',S);
          Writeln ('Face    : ',F);
          Writeln;
          Lire(0,P,S,F);
          Ch:=Readkey;
          End;
     End.
