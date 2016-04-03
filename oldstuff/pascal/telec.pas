Program Telechargement;

Uses Crt,Dos;

Var Ch : Char;

Procedure Banner;
Begin
     Writeln ('TELEC. SystŠme de t‚l‚chargement rapide');
     Writeln ('Copyright (c) 1991. Pascal Munerot');
     End;

Procedure Emission;
Begin
     Write ('Nom de fichier : ');
     Readln(Path);
     End;

Procedure Reception;
Begin
     End;

Procedure Option;
Begin
     Writeln; Writeln;
     Writeln ('Emission / R‚ception (E / R) ? ');
     Ch:=Upcase(Readkey);
     Case Ch of
          'E':Emission;
          'R':Reception;
          End;
     End;

Begin
     Banner;
     Option;
     End.
