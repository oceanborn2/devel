Program Format42;

Uses Crt,Disk;

Const Lect : integer = 0;
      Face0 = 0;
      Face1 = 1;

Var Face : Integer;
    I    : Integer;
    Ch   : Char;
    S    : String;

Begin
     Clrscr;
     Writeln ('Formatteur de disquettes en 42 pistes');
     Writeln;
     Writeln ('Lecteur ',ParamStr(1),':');
     S:=ParamStr(1);
     Ch:=Upcase(S[1]);
     Lect:=Ord(Ch)-65;
     Face:=Face0;
     Ch:=Readkey;
     For I:=0 To 42 Do
     Begin
          Gotoxy (1,5);
          Writeln ('Piste: ',I,'  Face: ',Face);
          If FormatPiste(Lect,Face,I,9,512) <> 0 Then Writeln ('Erreur en piste ',I);
          If Face = Face0 Then Face:=Face1 Else Face:=Face0;
          Gotoxy (1,5);
          Writeln ('Piste: ',I,'  Face: ',Face);
          If FormatPiste(Lect,Face,I,9,512) <> 0 Then Writeln ('Erreur en piste ',I);
          End;
     End.
