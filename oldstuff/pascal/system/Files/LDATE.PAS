Program LDate;

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
    C      : Byte;

Begin
     If ParamCount<1 Then Fname:='date_.dat'
        Else Fname:=ParamStr(1);
     Assign(F,Fname);
     Reset(F);
     Readln(F,Annee);
     Annee:=Annee xor 12211;
     Readln(F,Mois);
     Mois:=Mois xor 36098;
     Readln(F,Jour);
     Jour:=jour xor 28694;
     Readln(F,Heure);
     Heure:=Heure xor 11201;
     Readln(F,Min);
     Min:=Min xor 43521;
     Readln(F,Sec);
     Sec:=Sec xor 48735;
     Write(jour:2,'/',mois:2,'/',annee:4,'   ',Heure:2,':',Min:2,':',Sec:2);
     Close(F);
     End.

 