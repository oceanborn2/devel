Program Choisir_Didact_English;

{$M $4000, 0,0}

Uses Crt,Dos;

Var Ch : Char;

Procedure Choix_1;
Begin
     Ch:=Readkey;
     Case Ch of
          '1' : Exec('ORDRE.EXE'   ,'');
          '2' : Exec('ORTHO.EXE'   ,'');
          '3' : Exec('TEMPS.EXE'   ,'');
          '4' : Exec('SETCOUL.EXE' ,'');
          '5' : Halt(0);
     Else Choix_1;
      End;
     End;

Procedure Choix;
Begin
     TextBackGround(Blue);
     Clrscr;
     TextColor(White);
     Write('DIDACT ENGLISH - Choix du type d''exercice - Pascal Munerot'); ClrEol; Writeln;
     TextColor(Yellow);
     Writeln;
     Writeln;
     Writeln ('     1. Ordre des mots');
     Writeln;
     Writeln ('     2. Orthographe anglaise');
     Writeln;
     Writeln ('     3. Conjugaison des temps anglais');
     Writeln;
     Writeln ('     4. Changer les couleurs');
     Writeln;
     Writeln ('     5. Abandonner');
     Choix_1; {attente de la frappe d'une touche correcte}
     End;

Begin
     Choix;
     End.
