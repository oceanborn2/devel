Program Xc;

Uses Crt,Dos;

Var F1,F2:File;

Procedure Banner;
Begin
     Clrscr;
     Writeln ('Echangeur de fichier : Turbo.Tpl / Turbo.Bak ');
     Writeln;
     End;

Procedure DoIt;
Begin
     Assign (F1,'TURBO.TPL');
     Assign (F2,'TURBO.BAK');
     Rename (F1,'TURBO.B');
     Rename (F2,'TURBO.TPL');
     Rename (F1,'TURBO.BAK');
     End;

Begin
     Banner;
     DoIt;
     End.

