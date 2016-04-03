Program ShowBoot;

Uses Crt,Disk;

Var PP , SS , FF ,I : Integer;

{Secteur abs = Piste * NbSectParPiste + Secteur + Face}
Procedure Parse (N : Integer; Var Piste, Secteur, Face  :Integer);
Begin
     If Odd(N) Then Face:=1 Else Face:=0;
     Piste:=N div 40;
     Secteur:=N mod 40;
     Writeln (N,'--> P : ',Piste,' S : ',Secteur,' F: ',Face);
     End;

Begin
     For I:=1 To 30 Do
     Begin
          Parse(I,PP,SS,FF);
          Lire(0,PP,SS,FF);
          End;
     End.
