Program Format1024;

Uses Crt,Disk;

Const LectA = 0;
      Face0 = 0;
      Face1 = 1;

Var Face : Integer;
    I    : Integer;
    Ch   : Char;

Begin
     Clrscr;
     Writeln ('Formatteur de disquettes en 1024 octets par pistes ');
     Writeln;
     Writeln ('Lecteur A : ');
     Face:=Face0;
     Ch:=Readkey;
     For I:=1 To 19 Do
     Begin
          Gotoxy (1,5);
          Writeln ('Piste: ',I,'  Face: ',Face);
          If FormatPiste(LectA,Face,I,9,1024) <> 0 Then Writeln ('Erreur');
          If Face = Face0 Then Face:=Face1 Else Face:=Face0;
          Gotoxy (1,5);
          Writeln ('Piste: ',I,'  Face: ',Face);
          If FormatPiste(LectA,Face,I,9,1024) <> 0 Then Writeln ('Erreur');
          End;
     End.
