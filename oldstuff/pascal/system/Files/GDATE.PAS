Program GDate;

Uses Crt,Dos;

Var Fname  : String;
    F      : Text;
    Annee,
    Mois,
    Jour,
    JourS,
    Heure,
    Min,
    Sec,
    Sec100 : Word;

Begin
     If ParamCount<1 Then Fname:='date_.dat'
        Else Fname:=ParamStr(1);
     GetDate(Annee,Mois,Jour,JourS);
     GetTime(Heure,Min,Sec,Sec100);
     Assign(F,Fname);
     Rewrite(F);
     Writeln(F,Annee xor 12211);
     Writeln(F,Mois  xor 36098);
     Writeln(F,Jour  xor 28694);
     Writeln(F,Heure xor 11201);
     Writeln(F,Min   xor 43521);
     Writeln(F,Sec   xor 48735);
     Close(F);
     End.



