Program Recherche;

Uses Crt,Dos;

Var DirInfo : SearchRec;

Procedure Cherche;
Begin
     Clrscr;
     FindFirst('\essai\*.*',0,DirInfo);
     While DosError = 0 Do
     Begin
          Writeln ('\essai\'+DirInfo.Name);
          FindNext(DirInfo);
          End;
     End;

Begin
     Cherche;
     End.

