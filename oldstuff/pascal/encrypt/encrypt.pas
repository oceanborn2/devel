Program Encrypt;

Uses Crt,Dos,WinExt;

Type
    Chrono = Record
               hour:word;
               min:word;
               sec:word;
               cent:word;
               End;

     AP   = Array [1..65535] of char;
     Mode = (Invite,Commande,MenuType);

     Banner = Object
              F       : File;    {variable fichier}
              Z       : Char;    {caractère interm‚diaire}
              VChem   : String;  {ancien chemin}
              Chemin  : DirStr;  {chemin d'accès au fichier}
              Pass    : String;  {mot de passe}
              Fich    : String;  {nom du fichier}
              NomFich : NameStr; {nom du fichier pour FSplit}
              Taille  : Longint; {taille totale du fichier}
              Posit   : Longint; {position dans le fichier}
              P       : ^AP;     {pointeur sur le buffer}
              L       : Integer; {longueur du password}
              Fait    : Longint; {compte le nombre d'octets crypt‚s}
              Procedure Banner;  {message d'invite}
              Procedure IfDosError; {affiche une erreur DOS}
              End;

       {méthode traditionnelle}
       Trad = Object(Banner)
              Procedure Terminate;   {crypte le dernier bloc}
              Procedure Crypte_1;    {crypte un bloc}
              Procedure Crypte;      {initialise la procédure de cryptage}
              End;

       {méthode étendue}
       Eten = Object(Trad)
              Procedure Terminate;   {crypte le dernier bloc}
              Procedure Crypte_1;    {crypte un bloc}
              Procedure Crypte;      {initialise la procédure de cryptage}
              End;

      {m‚thode complète}
      Compl = Object(Eten)
              Procedure TerminateC; {crypte le dernier bloc}
              Procedure CrypteC_1;  {crypte un bloc}
              Procedure CrypteC;    {initialise la procédure de cryptage}
              Procedure TerminateD; {décrypte le dernier bloc}
              Procedure CrypteD_1;  {décrypte un bloc}
              Procedure CrypteD;    {initialise la procédure de décryptage}
              End;

     Crypte = Object(Compl)
              Fil : Array [1..8] of String;  {liste des fichiers}
              Procedure Option; {sélection du mode de cryptage ou du mode menu}
              Procedure Init;        {initialise le programme}
              Procedure Alloue;      {alloue 64 ko de mémoire}
              Procedure Libere;      {libère la m‚moire}
              Procedure Menu_1;      {mode menu}
              Procedure Menu;        {activation du mode menu}
              Procedure Quitte;      {termine la session}
              Procedure Methode;     {sélectionne une m‚thode en mode menu}
              Procedure AideE;       {aide éxécution}
              Procedure AideM;       {aide méthodes}
              Procedure AideC;       {aide code}
              Procedure AideQ;       {aide fin de session}
              Procedure AideF;       {aide fichiers}
              Procedure Aide;        {lancement de l'aide}
              Procedure Code_1;
              Procedure Code;        {lecture du code}
              Procedure Err(A,B:String); {messages d'erreurs}
              Procedure Execute;     {éxécution du cryptage}
              Procedure Fichiers_1;  {déja des fichiers en mémoire}
              Procedure Fichiers;    {lecture de la liste des fichiers }
              End;                   {en mode menu}

Const
     BreakFlag : Boolean = FALSE;
      MaxMethods = 4;
      Meth     : Array [1..MaxMethods] of String[40] =
      ('TRADITIONNELLE          ','ETENDUE                 ',
       'COMPLETE CRYPTAGE       ','COMPLETE DECRYPTAGE     ');
      MaxFiles : Integer = 0;
      NewList  : Boolean = False;

      FileF    : Boolean = False;
      CodeF    : Boolean = False;
      MethodF  : Boolean = False;
      MD       : Mode = Invite; {s‚lectionne le message d'invite par d‚faut}

Var
     Int1BSave : Pointer;
           DT  : Chrono;
           RES : Chrono;

            Cr : Crypte;

      Timing,I : LongInt;
       J,Bloc  : Integer;
        P1,MC  : Integer;
       DirInfo : SearchRec;
            Ch : Char;
           Opt : String[2];
           ExS : Pointer;

Procedure DispResult;
Begin
     With Res do Writeln(Hour,':',Min,':',Sec,':',Cent);
     End;

Procedure StartChrono;
Begin
     SetTime(0,0,0,0);
     End;

Procedure StopChrono;
Begin
     With Res Do GetTime(hour,min,sec,cent);
     End;

Procedure MemChrono;
Begin
     GetTime(dt.hour,dt.min,dt.sec,dt.cent);
     Timing:=(dt.hour*3600)+(dt.min*60)+dt.sec;
     End;

Procedure NewTime;
Begin
     Clrscr;
     With dt do
     Begin
          Hour:=Timing div 3600; Dec(Timing,Hour*3600);
          Min:=Timing div 60; Dec(Timing,Min*60);
          Sec:=Timing;
          SetTime(hour,min,sec,0);
          End;
     End;

{passe une chaine de caractères en majuscules}
Function UpcaseStr (A:String):String;
Var X : Integer;
Begin
     For X:=1 To Length(A) Do
     Begin
          A[X]:=Upcase(A[X]);
          End;
     UpcaseStr:=A;
     End;

{implémentation de la fonction ROL en assembleur}
Function ROL (B,C : Byte) : Byte;
begin
  {$ifDef CPUx86_64}
    { $ ASMMODE intel}
    {asm
      POP CX
      POP AX
      ROL AL,CL
      XOR AH,AH
      {EndDef}
    end;}
  {$endIf}
  {$ifDef CPUaarch64}
    { $ ASMMODE aarch64}
    {asm
    end;}
  {$endIf}
end; 

{implémentation de la fonction ROR en assembleur}
Function ROR (B,C : Byte) : Byte;
begin
  {$ifDef CPUx86_64}
    { $ ASMMODE intel}
    {asm
      POP CX
      POP AX
      ROR AL,CL
      XOR AH,AH
      {EndDef}
    end;}
  {$endIf}
  {$ifDef CPUaarch64}
    { $ ASMMODE aarch64}
    {asm
    end;}
  {$endIf}
end;


Procedure Banner.Banner;
Begin
     Window(1,1,80,25);
     Clrscr;
     Writeln (' Encrypt - Logiciel de cryptage multi-méthodes ');
     Writeln (' Pascal Munerot - 1991 ');
     Writeln;
     Writeln (' Syntaxe générale : <Encrypt Methode Fichier Code> [Chemin]');
     Writeln ('                    <Encrypt ?> lance le mode menu');
     Writeln;
     Writeln (' OT .. ou exclusif, OE .. codage ou exclusif étendu');
     Writeln (' CD .. méthode complète, décryptage');
     Writeln (' CC .. méthode complète, cryptage');
     Writeln;
     Writeln (' Si vous trouvez ce logiciel utile et que vous vous en servez r‚gulièrement,');
     Writeln (' alors veuillez envoyer 50 FF par chèque … l''adresse suivante :');
     Writeln;
     Writeln (' Pascal Munerot');
     Writeln (' 76690 Fontaine-Le-Bourg');
     Writeln;
     Writeln (' Vous recevrez en retour votre accord de licence et la prochaine version de ce');
     Writeln (' programme vous sera envoyée dès qu''elle sera disponible. Cependant, si le ');
     Writeln (' package de cette version dont vous disposez n''est pas complet, ou si il');
     Writeln (' présente un défaut (virus, programme défectueux), je vous enverrai une copie');
     Writeln (' de ce logiciel contre 15 FF');
     End;

Procedure Crypte.Libere;
Begin
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     If P<>Nil Then FreeMem(P,65535);
     P:=Nil;
     End;

Procedure Crypte.Alloue;
Begin
     GetMem(P,65535);
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     If (P=Nil) Then Begin
                Writeln ('Erreur d''allocation m‚moire'); Halt(1); End;
     End;

Procedure Crypte.Quitte;
Begin
     While TopWindow<>Nil Do CloseWindow;
     Clrscr;
     Halt(0);
     End;

Procedure Crypte.Methode;
Const Sort : Boolean = false;
Begin
     Sort:=False;
     TextBackGround(Black);
     Window(1,1,80,25);

     Ch:=Readkey;
     Case Ch of
          ' ' : Begin
                     Gotoxy (1,13); TextColor(White); Write ('M‚thode : ');
                     TextColor(Yellow); Write(Meth[MC],'     ');
                     Inc(MC);
                     If MC=MaxMethods+1 Then MC:=1;
                     End;
          #13 : Begin Sort:=True; Exit; End;
          Else Methode;
          End;
     MethodF:=True;
     If Sort Then Exit;
     Methode;
     End;

Procedure Crypte.Menu_1;
Begin
     Ch:=Upcase(Readkey);
     Case Ch of
          'A' : Aide;
          'E' : Execute;
          'F' : Fichiers;
          'C' : Code;
          'M' : Begin MC:=1; Methode; End;
          'Q' : Quitte;
          Else Menu_1;
          End;
     Menu_1;
     End;

Procedure Crypte.AideE;
Begin
     OpenWindow(5,5,75,24,' AIDE EXECUTION ',2,2);
     Clrscr;
     Writeln;
     Writeln ('  L''‚x‚cution consiste en l''‚x‚cution du cryptage des');
     Writeln ('  fichiers s‚lectionn‚s par la commande (F)ichiers et');
     Writeln ('  ceci avec les paramètres programm‚s, … savoir : ');
     Writeln;
     Writeln ('   - le mot de passe        - commande C     ');
     Writeln ('   - la m‚thode de cryptage - commande M     ');
     Writeln ('   - la liste des fichiers  - commande F     ');
     Writeln;
     Writeln ('  si une de ces commandes n''a pas ‚t‚ activ‚e au moins');
     Writeln ('  une fois, le logiciel ‚met un message d''erreur dans');
     Writeln ('  une fenˆtre et demande l''appui sur une touche quelquonque.');
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Crypte.AideF;
Begin
     OpenWindow(5,5,75,24,' AIDE FICHIERS ',2,2);
     Clrscr;
     Writeln;
     Writeln ('  Cette commande permet de définir la liste des fichiers ');
     Writeln ('  que vous désirez crypter ou décrypter. ');
     Writeln;
     Writeln ('  Pour cela, vous pouvez préciser jusqu''à 8 lignes de noms');
     Writeln ('  de fichiers. ');
     Writeln;
     Writeln ('  La seule contrainte étant de ne préciser que des noms de ');
     Writeln ('  fichiers respectant la syntaxe du système d''exploitation.');
     Writeln;
     Writeln ('  Quelques exemples : ');
     Writeln ('  \tools\*.c ');
     Writeln ('  a?.* ');
     Writeln ('  a*.* ');
     Writeln ('  *.*  ');
     Writeln ('  c:\doc\*.doc');
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Crypte.AideM;
Begin
     OpenWindow(5,5,75,24,' AIDE METHODE ',2,2);
     Clrscr;
     Writeln;
     Writeln ('  Cette commande permet de spécifier la méthode de ');
     Writeln ('  cryptage et / ou de décryptage. ');
     Writeln;
     Writeln ('  il existe 3 méthodes : ');
     Writeln ('   - la méthode traditionnelle : codage par ou exclusif    (OT)');
     Writeln ('   - la méthode étendue        : codage par ou exclusif    (OE)');
     Writeln ('                                 + nombres al‚atoires          ');
     Writeln ('   - la méthode complète       : méthode précdente améliorée');
     Writeln;
     Writeln ('  la m‚thode traditionnelle est la plus rapide mais aussi la moins');
     Writeln ('  efficace, contrairement … la m‚thode complète qui est la plus ');
     Writeln ('  lente mais qui chiffre les donn‚es de manière très complexe. ');
     Writeln;
     Writeln ('  la m‚thode complète se s‚pare en une m‚thode de cryptage (CC)');
     Writeln ('  et une m‚thode de d‚cryptage (CD). ');
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Crypte.AideQ;
Begin
     OpenWindow(5,5,75,24,' AIDE QUITTER ',2,2);
     Clrscr;
     Writeln;
     Writeln ('  Avec cette commande, vous pouvez terminer correctement une ');
     Writeln ('  session de cryptage. Je dis bien CORRECTEMENT car interrompre');
     Writeln ('  ce programme en effectuant un BREAK au clavier empˆche le ');
     Writeln ('  logiciel de terminer correctement. ');
     Writeln;
     Writeln ('  En effet, le programme doit vider la m‚moire tampon allou‚e');
     Writeln ('  comme zone de cryptage des fichiers. ');
     Writeln;
     Writeln ('  Assurez vous avant de terminer une s‚ance de bien m‚moriser');
     Writeln ('  votre mot de passe si vous venez d''effectuer une session  ');
     Writeln ('  de cryptage car vous ne pourriez pas … d‚crypter sans      ');
     Writeln ('  celui-ci. ');
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Crypte.AideC;
Begin
     OpenWindow(5,5,75,24,' AIDE CODE ',2,2);
     Clrscr;
     Writeln;
     Writeln ('  cette commande vous permet d''entrer le mot de passe que vous ');
     Writeln ('  désirez utiliser pour le cryptage ou le décryptage.');
     Writeln;
     Writeln ('  si vous ne vous rappeller pas du mot de passe que avez rentr‚');
     Writeln ('  ou si vous avez un doute, alors, je vous conseille VIVEMENT  ');
     Writeln ('  de le retaper pour ˆtre sur de sa d‚finition exacte.');
     Writeln;
     Writeln ('  En effet, en cas d''oubli de votre mot de passe, je ne vous serai');
     Writeln ('  d''aucun secours. Ce logiciel est efficace et son utilisation ');
     Writeln ('  ne doit pas être prise à la légère.');
     Writeln;
     Writeln ('  le fichier crypté ne contient bien évidemment pas ce mot de passe,');
     Writeln ('  il sert simplement au calcul des nombres nécessaires au cryptage.');
     Writeln;
     Writeln ('  Attention : le programme fait la différence entre les minuscules');
     Writeln ('  et les majuscules. Le cryptage ne donne pas les mêmes résultats.');
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Crypte.Aide;
Begin
     OpenWindow(1,2,80,14,' AIDE ',2,2);
     TextBackGround(13); TextColor(Yellow);
     Clrscr;
     Writeln ('Tapez la lettre de l''option d‚sir‚e ');
     Writeln;
     Writeln (' E --> Ex‚cution  ');
     Writeln (' F --> Fichiers   ');
     Writeln (' C --> Code       ');
     Writeln (' M --> M‚thode    ');
     Writeln (' Q --> Quitter    ');
     Writeln;
     Writeln (' D --> G‚n‚ralit‚s');
     Ch:=Upcase (Readkey);
     Case Ch of
          'E' : AideE;
          'F' : AideF;
          'C' : AideC;
          'M' : AideM;
          'Q' : AideQ;
          End;
     CloseWindow;
     TextColor(White); TextBackGround(Black);
     End;

Procedure Crypte.Err(A,B:String);
Begin
     OpenWindow(1,12,80,15, ' Attention !!! ',10,10);
     TextBackGround(Red); TextColor(Yellow);
     Clrscr;
     Writeln (A);
     Write   (B);
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Crypte.Execute;
Var Extens : ExtStr;
    XXX    : Integer;
Begin
     If (MethodF = False) Then
     Begin
          Err('vous n''avez pas sélectionné de méthode',
          'appuyez sur une touche');
          Exit;
          End;
     If (FileF   = False) Then
     Begin
          Err('vous n''avez pas précisé de nom de fichier',
          'appuyez sur une touche');
          Exit;
          End;
     If (CodeF   = False) Then
     Begin
          Err('vous n''avez pas précisé le code','appuyez sur une touche');
          Exit;
          End;
     OpenWindow(1,1,80,25,' Ex‚cution ',2,2);
     TextColor(Yellow);
     Clrscr;
     For XXX:=1 To MaxFiles Do
     Begin
          If Fil[XXX]<>'' Then
          Begin
               Fsplit(Fil[XXX],Chemin,NomFich,Extens);
               If Chemin[Length(Chemin)]='\' Then Delete(Chemin,Length(Chemin),1);
               Fich:=NomFich+Extens;
               Case MC-1 of
                    1 : Trad.Crypte;
                    2 : Eten.Crypte;
                    3 : Compl.CrypteC;
                    0 : Compl.CrypteD;
                    Else Exit;
                    End;
               End;
          End;
     Ch:=Readkey;
     CloseWindow;
     End;

{il y a d‚ja des fichiers en m‚moire - confirmation de l'effacement }
Procedure Crypte.Fichiers_1;
Begin
     OpenWindow(1,12,80,15, ' Attention !!! ',10,10);
     TextBackGround(Red); TextColor(Yellow);
     Clrscr;
     Writeln ('il y a d‚ja une liste de noms de fichiers ');
     Write   ('voulez vous la d‚truire (O/N) ? ');
     Ch:=Readkey;
     If Upcase (Ch)='O' Then NewList:=True Else NewList:=False;
     CloseWindow;
     End;

Procedure Crypte.Fichiers;
Begin
     OpenWindow(1,2,65,12,' FICHIER(S) ',2,2);
     TextBackGround(White); TextColor(Black);
     Clrscr;
     If MaxFiles<>0 Then Fichiers_1;
     If (MaxFiles<>0) And (NewList=False) Then Begin CloseWindow; Exit; End;
     If NewList Then MaxFiles:=0;
     For I:=1 To 8 Do Fil[I]:='                  ';
     For I:=1 To 8 Do Fil[I]:='';
     Repeat
           Inc(MaxFiles);
           If MaxFiles=9 Then exit;
           Write ('> ');
           Readln (Fil[MaxFiles]);
           Until (Fil[MaxFiles]='') Or (MaxFiles=8);
     CloseWindow;
     TextColor(Yellow); TextBackGround(Black);
     Window(1,1,80,25);
     For I:=1 To 8 Do
     Begin
          Gotoxy (2,I+2);
          If Fil[i]<>'' Then
          Begin
               Write (Fil[I]);
               ClrEol;
               Writeln;
               End Else Begin
                              Gotoxy(2,I+2);
                              Write(' ');
                              ClrEol;
                              End;
          End;
     FileF:=True;
     If (MaxFiles=1) And (Fil[1]='') Then FileF:=False;
     End;

Procedure Crypte.Code_1;
Begin
     Write ('> '); Readln (pass);
     If pass='' Then Code_1;
     End;

Procedure Crypte.Code;
Begin
     OpenWindow(40,5,70,10,' CODE ',2,2);
     TextBackGround(White); TextColor(Black);
     Clrscr;
     Code_1;
     CodeF:=True;
     CloseWindow;
     TextColor(White); TextBackGround(Black);
     End;

Procedure Crypte.Menu;
Begin
     pass:='';
     TextBackGround(Black);
     Clrscr;
     Window(1,15,80,25);
     TextColor(Yellow); TextBackGround(Blue);
     Clrscr;
     Gotoxy(1,1);
     Writeln;
     Writeln (' ÛÛÛÛÛ ÛÛ  Û ÛÛÛÛÛ ÛÛÛÛ  Û   Û ÛÛÛÛÛ ÛÛÛÛÛ         La licence du logiciel ne');
     Writeln (' Û     Û Û Û Û     Û   Û Û   Û Û   Û   Û           côute que 50 FF et donne ');
     Writeln (' ÛÛ    Û Û Û Û     ÛÛÛÛ   ÛÛÛ  ÛÛÛÛÛ   Û           droit à la prochaine     ');
     Writeln (' Û     Û  ÛÛ Û     Û   Û   Û   Û       Û           version pour 15 FF.      ');
     Writeln (' ÛÛÛÛÛ Û   Û ÛÛÛÛÛ Û   Û   Û   Û       Û                                    ');
     Writeln ('                                          1.00     Pour cela, envoyez un    ');
     Writeln (' Logiciel de cryptage multi-méthodes               chèque … cette adresse : ');
     Writeln (' Auteur : Pascal Munerot _ Version 1991            38, av. des Dahlias      ');
     Writeln ('                                                   76610 Le Havre           ');
     Window(1,1,80,1);
     TextBackGround(White); TextColor(Black); Clrscr;
     Write (' (A)ide  (E)x‚cution  (F)ichiers  (C)ode  (M)‚thode  (Q)uitter');
     TextBackGround(Black); TextColor(White);
     Menu_1;
     End;

Procedure Crypte.Init;
Begin
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     TopWindow:=Nil; {pas de fenêtres pour l'instant}
     P:=Nil; {P mis … NIL pour éviter un FREEMEM précoce}
     TextMode(Co80);
     For I:=1 To 8 Do Fil[i]:='';
     If (ParamCount<1) Then Halt(0);
     Alloue;
     Option;
     End;

Procedure Crypte.Option;
Begin
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     Clrscr;
     Fich:=ParamStr(2);
     Pass:=ParamStr(3);
     If MD=Commande Then Opt:=UpcaseStr(ParamStr(1));
     If ParamCount>3 Then Chemin:=ParamStr(4) Else Chemin:='';

     If Opt='OT' Then Begin Trad.Crypte;   Ch:=Readkey; Exit; End;

     If Opt='OE' Then Begin Eten.Crypte;   Ch:=Readkey; Exit; End;

     If Opt='CC' Then Begin Compl.CrypteC; Ch:=Readkey; Exit; End;

     If Opt='CD' Then Begin Compl.CrypteD; Ch:=Readkey; Exit; End;

     If Opt='?' Then Begin MD:=MenuType; Menu; Exit; End;
     Writeln ('Option invalide ...');
     Writeln ('Appuyez sur une touche '); Ch:=Readkey;
     Halt(1);
     End;

{crypte ou d‚crypte le dernier bloc - m‚thode traditionnelle}
Procedure Trad.Terminate;
Var J:Integer;
Begin
     Writeln ('Dernier bloc');
     Posit:=FilePos(F);
     BlockRead(F,P^,Taille);
     J:=0;
     L:=Length(Pass);
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     For I:=1 To Taille do
     Begin
          Inc(J);
          If (J=L+1) Then J:=1;
          Z:=Chr(Ord(P^[i]) xor Ord(Pass[j]));
          If (P^[i]<>' ') And (Z<>' ') Then P^[i]:=Z;
          End;
     Seek(F,Posit);
     BlockWrite(F,P^,Taille);
     Writeln ('Fin de traitement ');
     ChDir(VChem);
     Close(F);
     StopChrono;
     DispResult;
     Writeln;
     End;

{crypte ou d‚crypte un bloc - m‚thode traditionnelle}
Procedure Trad.Crypte_1;
Begin
     StartChrono;
     J:=0;
     Bloc:=0;
     If Chemin<>'' Then ChDir(Chemin);
     Writeln('METHODE TRADITIONNELLE');
     Writeln('CRYPTAGE DU FICHIER ','\'+UpcaseStr(Chemin)+'\'+UpcaseStr(DirInfo.Name),' : ');
     Assign (F,DirInfo.Name);
     Reset(F,1);
     Taille:=FileSize(F);
     While (Taille<>0) Do
     Begin
          Inc(Bloc);
          If (Taille<65535) Then Begin Terminate; Exit; End;
          Posit:=FilePos(F);
          Writeln ('BLOC:',bloc);
          BlockRead(F,P^,65535);
{         SetIntVec(1,Ptr(0,0));
          SetIntVec(3,Ptr(0,0));}
          For I:=1 to 65535 Do
          Begin
               Inc(J);
               If (J=L+1) Then J:=1;
               P^[i]:=chr(ord(P^[i]) xor ord(pass[j]));
               End;
               Seek(F,Posit);
               BlockWrite(F,P^,65535);
               Dec(Taille,65535);
               End;
     Close(F);
     StopChrono;
     DispResult;
     End;

Procedure Banner.IfDosError;
Begin
     If DosError <> 0 Then
     Begin
          Writeln ('Erreur DOS : ',DosError);
          Case DosError Of
               2 : Writeln ('Fichier non trouv‚');
               3 : Writeln ('Chemin non trouv‚');
               5 : Writeln ('Accès refus‚');
               6 : Writeln ('Mauvais identificateur de fichier');
               8 : Writeln ('Pas assez de m‚moire');
              10 : Writeln ('Environnement incorrect');
              11 : Writeln ('Format invalide');
              18 : Writeln ('Plus de fichiers');
              End;
          Writeln ('Appuyez sur une touche ');
          Ch:=Readkey;
          End;
     End;

{initialise le cryptage ou le d‚cryptage - m‚thode traditionnelle}
Procedure Trad.Crypte;
Var J:Integer;
    Bloc:Integer;
Begin
     DosError:=0;
     FindFirst(Chemin+'\'+Fich,0,DirInfo);
     L:=Length(Pass);
     GetDir(0,VChem);
     IfDosError;
     While DosError = 0 Do
     Begin
          Crypte_1;
          FindNext(DirInfo);
          End;
     ChDir(VChem);
     End;

{crypte ou d‚crypte le dernier bloc - m‚thode ‚tendue}
Procedure Eten.Terminate;
Var J  : Integer;
Begin
     RandSeed:=Ord(Pass[L]);
     Writeln ('Dernier bloc');
     Posit:=FilePos(F);
     BlockRead(F,P^,Taille);
     J:=0;
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     L:=Length(Pass);
     For I:=1 To Taille do
     Begin
          Inc(J);
          If (J=L+1) Then J:=1;
          P^[i]:=chr(ord(P^[i]) xor ord(pass[j]) xor random(255) xor random(125) xor random(76 xor P1));
          End;
     Seek(F,Posit);
     BlockWrite(F,P^,Taille);
     Writeln ('Fin de traitement ');
     ChDir(VChem);
     Close(F);
     StopChrono;
     DispResult;
     Writeln;
     End;

{crypte ou d‚crypte un bloc - m‚thode ‚tendue}
Procedure Eten.Crypte_1;
Begin
     StartChrono;
     J:=0;
     Bloc:=0;
     If Chemin<>'' Then ChDir(Chemin);
     Writeln('METHODE ETENDUE');
     Writeln('CRYPTAGE DU FICHIER ','\'+UpcaseStr(Chemin)+'\'+UpcaseStr(DirInfo.Name),' : ');
     Assign (F,DirInfo.Name);
     Reset(F,1);
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     Taille:=FileSize(F);
     While (Taille<>0) Do
     Begin
          Inc(Bloc);
          If (Taille<65535) Then Begin Terminate; Exit; End;
          Posit:=FilePos(F);
{          SetIntVec(1,Ptr(0,0));}
          Writeln ('BLOC:',bloc);
          BlockRead(F,P^,65535);
{          SetIntVec(3,Ptr(0,0));  }
          For I:=1 to 65535 Do
          Begin
               Inc(J);
               If (J=L+1) Then J:=1;
               P^[i]:=chr(ord(P^[i]) xor ord(pass[j]) xor random(255) xor random(125) xor random(76 xor P1));
               End;
          Seek(F,Posit);
          BlockWrite(F,P^,65535);
{          SetIntVec(1,Ptr(0,0));}
          Dec(Taille,65535);
          End;
          Close(F);
     StopChrono;
     DispResult;
     End;

{initialise le cryptage ou le d‚cryptage - m‚thode ‚tendue}
Procedure Eten.Crypte;
Begin
     FindFirst(Chemin+'\'+Fich,0,DirInfo);
     L:=Length(Pass);
     P1:=Ord(Pass[1]);
     RandSeed:=Ord(Pass[L]);
     IfDosError;
     GetDir(0,VChem);
     While DosError = 0 Do
     Begin
          Crypte_1;
          FindNext(DirInfo);
          End;
     ChDir(VChem);
     End;

{crypte le dernier bloc - m‚thode complète}
Procedure Compl.TerminateC;
Var J  : Integer;
Begin
     RandSeed:=Ord(Pass[L]);
     Writeln ('Dernier bloc');
     Posit:=FilePos(F);
     BlockRead(F,P^,Taille);
     J:=0;
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     L:=Length(Pass);
     For I:=1 To Taille do
     Begin
          Inc(J);
          If (J=L+1) Then J:=1;
          P^[i]:=chr(ord(P^[i]) xor ord(pass[j]) xor random(255) xor random(125) xor random(76 xor P1));
          P^[i]:=Chr(Ror(Ord(P^[i]),Ord(pass[j])));
          End;
     Seek(F,Posit);
     BlockWrite(F,P^,Taille);
     Writeln ('Fin de traitement ');
     ChDir(VChem);
     Close(F);
     StopChrono;
     DispResult;
     Writeln;
     End;

{crypte un bloc - m‚thode complète}
Procedure Compl.CrypteC_1;
Begin
     StartChrono;
     J:=0;
     Bloc:=0;
     If Chemin<>'' Then ChDir(Chemin);
     Writeln('METHODE COMPLETE');
     Writeln('CRYPTAGE DU FICHIER ','\'+UpcaseStr(Chemin)+'\'+UpcaseStr(DirInfo.Name),' : ');
     Assign (F,DirInfo.Name);
     Reset(F,1);
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     Taille:=FileSize(F);
     While (Taille<>0) Do
     Begin
          Inc(Bloc);
          If (Taille<65535) Then Begin TerminateC; Exit; End;
          Posit:=FilePos(F);
{          SetIntVec(1,Ptr(0,0));}
          Writeln ('BLOC:',bloc);
          BlockRead(F,P^,65535);
{          SetIntVec(3,Ptr(0,0));  }
          For I:=1 to 65535 Do
          Begin
               Inc(J);
               If (J=L+1) Then J:=1;
               P^[i]:=chr(ord(P^[i]) xor ord(pass[j]) xor random(255) xor random(125) xor random(76 xor P1));
               P^[i]:=Chr(Ror(Ord(P^[i]),Ord(pass[j])));
               End;
          Seek(F,Posit);
          BlockWrite(F,P^,65535);
{          SetIntVec(1,Ptr(0,0));}
          Dec(Taille,65535);
          End;
          Close(F);
     StopChrono;
     DispResult;
     End;

{initialise le cryptage - m‚thode complète}
Procedure Compl.CrypteC;
Begin
     FindFirst(Chemin+'\'+Fich,0,DirInfo);
     L:=Length(Pass);
     IfDosError;
     P1:=Ord(Pass[1]);
     RandSeed:=Ord(Pass[L]);
     GetDir(0,VChem);
     While DosError = 0 Do
     Begin
          CrypteC_1;
          FindNext(DirInfo);
          End;
     ChDir(VChem);
     End;

{d‚crypte le dernier bloc - m‚thode complète}
Procedure Compl.TerminateD;
Var J  : Integer;
Begin
     RandSeed:=Ord(Pass[L]);
     Writeln ('Dernier bloc');
     Posit:=FilePos(F);
     BlockRead(F,P^,Taille);
     J:=0;
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     L:=Length(Pass);
     For I:=1 To Taille do
     Begin
          Inc(J);
          If (J=L+1) Then J:=1;
          P^[i]:=Chr(Rol(Ord(P^[i]),Ord(pass[j])));
          P^[i]:=chr(ord(P^[i]) xor ord(pass[j]) xor random(255) xor random(125) xor random(76 xor P1));
          End;
     Seek(F,Posit);
     BlockWrite(F,P^,Taille);
     Writeln ('Fin de traitement ');
     ChDir(VChem);
     Close(F);
     StopChrono;
     DispResult;
     Writeln;
     End;

{d‚crypte un bloc - m‚thode complète}
Procedure Compl.CrypteD_1;
Begin
     StartChrono;
     J:=0;
     If Chemin<>'' Then ChDir(Chemin);
     Bloc:=0;
     Writeln('METHODE COMPLETE');
     Writeln('DECRYPTAGE DU FICHIER ','\'+UpcaseStr(Chemin)+'\'+UpcaseStr(DirInfo.Name),' : ');
     Assign (F,DirInfo.Name);
     Reset(F,1);
{     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     Taille:=FileSize(F);
     While (Taille<>0) Do
     Begin
          Inc(Bloc);
          If (Taille<65535) Then Begin TerminateD; Exit; End;
          Posit:=FilePos(F);
{          SetIntVec(1,Ptr(0,0));}
          Writeln ('BLOC:',bloc);
          BlockRead(F,P^,65535);
{          SetIntVec(3,Ptr(0,0));  }
          For I:=1 to 65535 Do
          Begin
               Inc(J);
               If (J=L+1) Then J:=1;
               P^[i]:=Chr(Rol(Ord(P^[i]),Ord(pass[j])));
               P^[i]:=chr(ord(P^[i]) xor ord(pass[j]) xor random(255) xor random(125) xor random(76 xor P1));
               End;
          Seek(F,Posit);
          BlockWrite(F,P^,65535);
{          SetIntVec(1,Ptr(0,0));}
          Dec(Taille,65535);
          End;
          Close(F);
     StopChrono;
     DispResult;
     End;

{initialise le d‚cryptage - m‚thode complète}
Procedure Compl.CrypteD;
Begin
     FindFirst(Fich,0,DirInfo);
     L:=Length(Pass);
     IfDosError;
     P1:=Ord(Pass[1]);
     RandSeed:=Ord(Pass[L]);
     While DosError = 0 Do
     Begin
          CrypteD_1;
          FindNext(DirInfo);
          End;
     End;

{$f+}
Procedure StopBreak; Interrupt;
Begin
{     BreakFlag := TRUE;
     Cr.Err('Touche interdite','Appuyez sur une autre touche');
}
     End;
{$f-}

{$f+}
Procedure Sortie; {$f-}
Begin
     While TopWindow<>Nil Do CloseWindow;
     Cr.Libere;
     Cr.Banner;
     SetIntVec($1B,Int1BSave);
     ExitProc:=ExS;
     End;

Begin
{
     SetIntVec(1,Ptr(0,0));
     SetIntVec(3,Ptr(0,0));}
     GetIntVec($1B,Int1BSave);
     SetIntVec($1B,Addr(StopBreak));
     ExS:=ExitProc;
     ExitProc:=@Sortie;
     MemChrono;
     MD:=Commande;
     Cr.Init;
     End.



