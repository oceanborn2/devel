Program ParseSectors;

Uses Crt,Disk;

Var F,P,S : Integer;
    I     : Integer;

Begin
     Clrscr;
     For I:=0 To 40 Do
     Begin
          Decompose(I+1,P,S,F);
          Writeln (I,'--> P : ',P,'  S : ',S,'   F : ',F);
          Writeln (P*9*2+S*2+F);
          Writeln;
          Delay(200);
          End;
     End.
