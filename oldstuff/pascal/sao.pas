Program Computer_Tester;

Uses Crt,Dos,Win,WinExt;

Type  Chrono = Record
               hour:word;
               min:word;
               sec:word;
               cent:word;
               End;

Var    P : Pointer;
 J,FOUND : Integer;
   NUM,I : Integer;
       X : Real;
      CH : Char;
  F,G    : File;
  TIMING : Longint;
      DT : Chrono;
     RES : Chrono;
     MEM : Chrono;
     CAL : Chrono;
     ECR : Chrono;
    DIS  : Array [1..16] of Chrono;
     NEW : Chrono;
    NOTE : Real;
  UNITES : String;

Procedure Ban;
Begin
     Writeln ('Copyright (c) 1991. Pascal Munerot ');
     Writeln; Writeln;
     Writeln ('si vous trouvez ce logiciel utile et que vous vous en servez ');
     Writeln ('r‚guliŠrement, alors veuillez envoyer une somme de 70 FF minimum … ');
     Writeln ('l''adresse suivante : ');
     Writeln;
     Writeln ('Pascal Munerot');
     Writeln ('76690 Fontaine-Le-Bourg');
     Writeln ('FRANCE');
     Writeln;
     Writeln ('vous recevrez en retour votre accord de licence et vous recevrez');
     Writeln ('la prochaine version de ce logiciel d‚s qu''elle sera disponible');
     End;

Procedure Banner;
Begin
     Clrscr;
     TopWindow:=Nil;
     OpenWindow(1,1,80,24,' SAO. SystŠme d''auto‚valuation d''un ordinateur ',15,1);
     TextColor(15);
     Gotoxy (1,1);
     Ban;
     delay (1000); Clrscr;
     End;

Procedure DispResult;
Begin
     With Res do Write(Hour,':',Min,':',Sec,':',Cent);
     End;

Procedure StartChrono;
Begin
     SetTime(0,0,0,0);
     End;

Procedure StopChrono;
Begin
     With Res Do GetTime(hour,min,sec,cent);
     End;

Procedure Fill256;
Begin
     Fillchar (P^,32000,'#');
     Fillchar (P^,32000,'#');
     Fillchar (P^,32000,'#');
     Fillchar (P^,32000,'#');
     Fillchar (P^,32000,'#');
     Fillchar (P^,32000,'#');
     Fillchar (P^,32000,'#');
     Fillchar (P^,32000,'#');
     End;

Procedure Memory;
Begin
     OpenWindow(2,2,79,4,' Test de la m‚moire ',15,4);
     Writeln;
     Write ('128 Remplissages de 32 kilo-octets (4 MO)                 : ');
     GetMem(P,32000);
     If (P=Nil) then Halt(1);
     StartChrono;
     Fill256; Fill256; Fill256; Fill256;
     Fill256; Fill256; Fill256; Fill256;
     Fill256; Fill256; Fill256; Fill256;
     Fill256; Fill256; Fill256; Fill256;
     StopChrono;
     FreeMem(P,32000);
     DispResult;
     Mem:=Res;
     End;

Procedure Nombre_Prems_1;
Begin
     For I:=2 To (Num-1) Do
     Begin
          If Int(Num/I)=(Num/I) then Begin Inc(Num); Nombre_Prems_1; End;
          If (I=Num-1) then Begin
                            Inc(Found);
                            Inc(Num);
                            End;
          If (Found=41) then exit;
          End;
     If (Found<41) then Begin Inc(Num); Nombre_Prems_1; End;
     End;

Procedure Nombre_Prems;
Begin
     Found:=3;
     Num:=3;
     Nombre_Prems_1;
     If (Found<41) then Begin Inc(Num); Nombre_Prems_1; End;
     End;

Procedure Calcul;
Begin
     OpenWindow(2,5,79,7,' Test des fonctions de calcul ',15,4);
     StartChrono;
     Writeln;
     Write ('Ln de 1 … 100, 40 nombres premiers.                       : ');
     For I:=1 To 100 Do Begin X:=Ln(i); End;
     Nombre_Prems;
     StopChrono;
     DispResult;
     Cal:=Res;
     With Res do Timing:=Timing+(hour*3600)+(min*60)+sec;
     End;

Procedure Delai(A:Word);
Begin
     Delay(A*1000);
     Inc(Timing,A);
     End;

Procedure Ecran_Test;
Begin
     For I:=1 To 255 Do
     Begin
          For J:=1 To 16 Do
          Begin
               Textcolor(J);
               Write(chr(I));
               End;
          End;
     Randomize;
     For I:=1 To 2500 Do
     Begin
          Write(Chr(Random(255)));
          TextBackground(Random(16));
          End;
     End;

Procedure Ecran;
Begin
     OpenWindow(2,8,79,10,' Test des fonctions de l''‚cran ',15,4);
     Clrscr;
     Write ('remplissages al‚at. et non al‚at. Mode direct et indirect : ');
     OpenWindow(2,11,79,24,' Ecran virtuel ',15,4);
     Gotoxy(1,1);
     StartChrono;
     directvideo:=false;
     Ecran_Test;
     directvideo:=true;
     Ecran_Test;
     StopChrono;
     CloseWindow;
     TextColor(15);
     TextBackground(Black);
     Clrscr;
     CloseWindow;
     OpenWindow(2,8,79,10,' Test des fonctions de l''‚cran ',15,4);
     Gotoxy(1,1);
     Write ('remplissages al‚at. et non al‚at. Mode direct et indirect : ');
     DispResult;
     Ecr:=Res;
     With Res do Timing:=Timing+(hour*3600)+(min*60)+sec;
     End;

Procedure Teste_Disque;
Begin
     Assign(F,Unites[I]+':\$$$.$$$');
     Rewrite(F,1);
     BlockWrite(F,P^,16000);
     Close(F);
     Reset(F,1);
     Assign(G,Unites[I]+':\$$.$$$');
     Rewrite(G,1);
     BlockRead(F,P^,16000);
     BlockWrite(G,P^,16000);
     Close(G);
     Close(F);
     Erase(F);
     Erase(G);
     End;

Procedure Disques;
Begin
     StartChrono;
     OpenWindow(2,11,79,21,' Test des disques ',15,4);
     Writeln;
     Write ('Liste des unit‚s dont vous disposez : ');
     Readln(Unites);
     If Length(Unites)>16 then Begin Writeln ('Trop de disques '); Halt(1); End;
     For I:=1 To Length(Unites) Do Unites[I]:=Upcase(Unites[I]);
     StopChrono;
     With Res do Timing:=Timing+(hour*3600)+(min*60)+sec;
     For I:=1 To Length(Unites) Do
     Begin
          Write('Unit‚ ',Unites[I],'   ');
          If Not(Unites[I] in ['A'..'Z']) then Begin CloseWindow; Disques; End;
          StartChrono;
          Teste_Disque;
          StopChrono; DispResult; Dis[I]:=Res; Writeln;
          End;
     End;

Procedure Teste;
Begin
     Memory;
     Calcul;
     Ecran;
     Disques;
     End;

Procedure Init;
Begin
     GetTime(dt.hour,dt.min,dt.sec,dt.cent);
     Timing:=(dt.hour*3600)+(dt.min*60)+dt.sec;
     End;

Procedure Convert;
Var Interm:Real;
Begin
     With Res do Interm:=(hour*3600)+(min*60)+sec+(cent/100);
     Gotoxy (48,WhereY);
     Write(Interm:3:2);
     Interm:=Interm/60;
     Note:=Note+Interm;
     Gotoxy (58,WhereY);  Writeln('   ',(1/0.21)*Interm:3:2);
     Writeln;
     End;

Procedure Recap;
Var Nb:Integer;
Begin
     note:=0; nb:=3;
     CloseWindow; CloseWindow; CloseWindow; CloseWindow; CloseWindow;
     OpenWindow(1,1,79,24,' R‚capitulation des r‚sultats ',15,4);
     TextColor(15);
     Gotoxy (1,3);

     Write (' M‚moire :    '); Res:=Mem; Gotoxy(20,WhereY);
     DispResult; Gotoxy(32,WhereY); Convert;

     Write (' Calculs :    '); Res:=Cal; Gotoxy(20,WhereY);
     DispResult; Gotoxy(32,WhereY); Convert;

     Write (' Ecran   :    '); Res:=Ecr; Gotoxy(20,WhereY);
     DispResult; Gotoxy(32,WhereY); Convert;

     Writeln (' Disques :    '); Writeln;
     For I:=1 To Length(Unites) Do
     Begin
          Inc(Nb);
          Write ('  Disque ',Unites[I],'    ');
          Res:=Dis[I]; Gotoxy (20,WhereY); DispResult;
          Gotoxy(32,WhereY); Convert;
          End;
     Writeln;
     Writeln;
     Writeln (' Note globale : ',(100)*(note/Nb):3:2);
     Writeln (' Nota : plus la note est basse, meilleure elle est.');
     ch:=readkey;
     closewindow;
     End;

Procedure NewTime;
Begin
     Clrscr;
     Ban;
     With dt do
     Begin
          Hour:=Timing div 3600; Dec(Timing,Hour*3600);
          Min:=Timing div 60; Dec(Timing,Min*60);
          Sec:=Timing;
          SetTime(hour,min,sec,0);
          End;
     End;

Begin
     Init;
     Banner;
     Teste;
     Recap;
     NewTime;
     End.
