Program Scrabble;

Uses Crt,Dos,WinExt;

Type

    TerrainDeJeu = Array [1..15,1..15] of char;

    Jeu = String[8]; {d‚finition d'un tirage de lettres}

    Sens = (vertical,horizontal);
    {sens d'‚criture des mots}

    Banner  = Object
              Procedure Init;
              Procedure Title (A:String; X,Y:Integer; Size:Byte);
              End;


    Terrain = Object(Banner)
              Procedure Init;
              Procedure Affiche;
              Procedure Rest;
              Procedure Sauve;
              Procedure Erreur(S:String);
              Function  EcritMot(X,Y:Integer; A:String; S:Sens) : Integer;
              End;

    Partie  = Object (Terrain)
              F         : Text;
              NbJoueurs : Integer;
              Procedure Init;
              Procedure SaisirLesNoms;     {saisie les noms des joueurs}
              Function  GenereJeu : String;
              Function  Confirm : Boolean; {le fichier existe d‚ja - confirmation}
              Function  Crypte (A:String):String; {crypte une chaine}
              Procedure SauverLaPartie; {sauvegarde de la partie}
              Procedure RechargerUnePartie; {charge une partie}
              Procedure AfficheLesScores; {affichage des scores des joueurs}
              Procedure Menu;
              End;


Const
    NbLettres : Array [1..27] Of Integer = (1,1,1,1,1,
                                            1,1,1,1,1,
                                            1,1,1,1,1,
                                            1,1,1,1,1,
                                            1,1,1,1,1,
                                            1,1);

    {d‚finition des valeurs des lettres}
    Lettres : Array [1..27] Of Shortint = (09,02,02,03,15,02,02,
                                           02,08,01,01,05,03,06,
                                           06,02,01,06,06,06,06,
                                           02,01,01,01,01,02);

    {d‚finition des coefficients multiplicateurs du scrabble}
    NU = 1; {case sans coefficient}
    MD = 2; {mot compte double}
    MT = 3; {mot compte triple}
    LD = 4; {lettre compte double}
    LT = 5; {lettre compte triple}

    Echiquier : array [1..15,1..15]      {d‚finition des coeffs mult }
                                         {sur l'‚chiquier}
    of Integer= ((MT,nu,nu,LD,nu,nu,nu,MT,nu,nu,nu,LD,nu,nu,MT),  {A}
                 (nu,MD,nu,nu,nu,LT,nu,nu,nu,LT,nu,nu,nu,MD,nu),  {B}
                 (nu,nu,MD,nu,nu,nu,LD,nu,LD,nu,nu,nu,MD,nu,nu),  {C}
                 (LD,nu,nu,MD,nu,nu,nu,LD,nu,nu,nu,MD,nu,nu,LD),  {D}
                 (nu,nu,nu,nu,MD,nu,nu,nu,nu,nu,MD,nu,nu,nu,nu),  {E}
                 (nu,LT,nu,nu,nu,LT,nu,nu,nu,LT,nu,nu,nu,LT,nu),  {F}
                 (nu,nu,LD,nu,nu,nu,LD,nu,LD,nu,nu,nu,LD,nu,nu),  {G}
                 (MT,nu,nu,LD,nu,nu,nu,MD,nu,nu,nu,LD,nu,nu,MT),  {H}
                 (nu,nu,LD,nu,nu,nu,LD,nu,LD,nu,nu,nu,LD,nu,nu),  {I}
                 (nu,LT,nu,nu,nu,LT,nu,nu,nu,LT,nu,nu,nu,LT,nu),  {J}
                 (nu,nu,nu,nu,MD,nu,nu,nu,nu,nu,MD,nu,nu,nu,nu),  {K}
                 (LD,nu,nu,MD,nu,nu,nu,LD,nu,nu,nu,MD,nu,nu,LD),  {L}
                 (nu,nu,MD,nu,nu,nu,LD,nu,LD,nu,nu,nu,MD,nu,nu),  {M}
                 (nu,MD,nu,nu,nu,LT,nu,nu,nu,LT,nu,nu,nu,MD,nu),  {N}
                 (MT,nu,nu,LD,nu,nu,nu,MT,nu,nu,nu,LD,nu,nu,MT)); {O}


Var
    Ban       : Banner;       {message d'invite}
    Ter       : Terrain;      {affichage du terrain de jeu}
    Jou       : Partie;       {gestion de la partie}

    Nom       : Array [1..4] of String[12]; {nom des joueurs}
    Ech,
    Anc       : TerrainDeJeu; {stockage des lettres}
    I,J       : Integer;
    X         : Integer;
    Ch        : Char;
    DirInfo   : SearchRec;    {recherche de fichiers}
    Fname     : String;
    JeuN      : Array [1..4] of Jeu;     {4 tirages}
    Scor      : Array [1..4] of Integer; {4 scores}

Procedure Banner.Init;
Begin
     Randomize;
     TopWindow:=Nil;
     TextBackGround(Black);
     Clrscr;
     TextColor(White); TextBackGround(Blue);
     Ban.Title('          S       C       R       A       B       B       L       E             ',1,1,80);
     TextColor(Yellow);
     Ban.Title('       P    A    S    C    A    L        M    U    N    E    R    O    T        ',1,25,79);
     End;

Procedure Banner.Title (A:String; X,Y:Integer; Size:Byte);
Begin
     Gotoxy (X,Y);
     For I:=1 To Size Do Write (' ');
     Gotoxy (X,Y);
     For I:=1 To Size Do Write(A[i]);
     End;

Procedure Terrain.Init;
Begin
     For I:=1 To 15 Do For J:=1 To 15 Do
     Begin
          Ech[I,J]:=' ';
          Anc[I,J]:=' ';
          End;
     TextBackGround(11);
     TextColor(White);
     For I:=1 To 15 Do
     Begin
          Gotoxy(47,2+I);
          Writeln ('                                  ');
          End;
     Gotoxy(48,4);
     Writeln ('F1. commencer une partie');
     Gotoxy(48,6);
     Writeln ('F2. recharger une partie');
     Gotoxy(48,8);
     Writeln ('F3. sauver la partie');
     Gotoxy(48,10);
     Writeln ('F4. quitter le jeu');
     End;

Procedure Terrain.Affiche;
Begin
     TextColor(White);
     For I:=1 To 15 Do
      For J:=1 To 15 Do
      Begin
           Gotoxy (I*3-2,2+J);
           TextBackGround(Echiquier[I,J] xor 216);
{           Ech[I,J]:=Chr(65+Random(26));}
           Write(' '+Ech[I,J]+' ');
           End;
     End;

Procedure Terrain.Erreur(S:String);
Begin
     Rest;
     OpenWindow(1,20,80,24,' '+S+' ',2,2);
     Clrscr;
     Writeln ('Erreur dans le placement des lettres, veuillez rejouer svp ...');
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Terrain.Rest;
Begin
     For I:=1 To 15 Do
         For J:=1 To 15 Do Ech[I,J]:=Anc[I,J];
     End;

Procedure Terrain.Sauve;
Begin
     For I:=1 To 15 Do
         For J:=1 To 15 Do Anc[I,J]:=Ech[I,J];
     End;

Function  Terrain.EcritMot (X,Y:Integer; A:String; S:Sens) : Integer;
Begin
     Sauve;
     Case S of
          Horizontal :
             Begin
                  For I:=X To X+Length(A)-1 Do
                  If (Ech[I,Y]=' ') Then Ech[I,Y]:=Upcase(A[I-X+1])
                  Else If (A[I-X+1]<>Ech[I,Y]) Then
                                               Begin
                                                    Erreur(A);
                                                    EcritMot:=0;
                                                    Exit;
                                               End;
             End;

          Vertical   :
             Begin
                  For I:=Y To Y+Length(A)-1 Do
                  If (Ech[X,I]=' ') Then Ech[X,I]:=Upcase(A[I-Y+1])
                  Else If (A[I-Y+1]<>Ech[X,I]) Then
                                               Begin
                                                    Erreur(A);
                                                    EcritMot:=0;
                                                    Exit;
                                               End;
             End;
          End;
     Affiche;
     EcritMot:=0;
     End;

Procedure Partie.Init;
Begin
     For I:=1 To 4 Do
     Begin
          Scor[i]:=0;
          JeuN[i]:='';
          End;
     End;

Function  Partie.Confirm : Boolean;
Begin
     Confirm:=False;
     OpenWindow(10,10,40,14,' LE FICHIER EXISTE DEJA ',2,2);
     Clrscr;
     Writeln ('Confirmation (O/N) ? ');
     Ch:=Upcase(Readkey);
     If (Ch='O') Then Confirm:=True;
     CloseWindow;
     End;

Function  Partie.Crypte (A:String) : String;
Begin
     For I:=1 To Length(A) Do A[i]:=Chr(Ord(A[i]) xor 10 xor 20 xor 12);
     Crypte:=A;
     End;

Procedure Partie.SauverLaPartie;
Var S : String;
Begin
     S:='';
     OpenWindow(1,1,80,10,' SAUVEGARDER LA PARTIE ',2,2);
     Clrscr;
     Write ('Nom du fichier : ');
     Readln(Fname);
{     FindFirst(Fname,DirInfo);}
     If DosError = 0 Then If Not Confirm Then Begin CloseWindow; Exit; End;
     Assign(F,Fname);
     Rewrite(F);

     {entˆte du fichier}
     Writeln (F,'SCRABBLE 1.0 - Pascal Munerot - 1991');

     Str(NbJoueurs,S);    {sauvegarde du nombre de joueurs}
     Writeln (F,S);

     For I:=1 To NbJoueurs Do
     Begin
          Writeln (F,Nom[i]);
          Str(Scor[i],S);
          Writeln (F,S);
          Writeln (F,JeuN[i]);
          End;
     For I:=1 To 15 Do
     Begin
          S:='';
          For J:=1 To 15 Do S:=S+Ech[I,J];
          Writeln(F,S);
          End;
     Close(F);
     CloseWindow;
     End;

Procedure Partie.RechargerUnePartie;
Var S : String;
Begin
     OpenWindow(1,1,80,10,' RECHARGER UNE PARTIE ',2,2);
     Clrscr;
     FindFirst('*.SCR',0,DirInfo);
     While DosError = 0 Do
     Begin
          Writeln (DirInfo.Name);
          FindNext(DirInfo);
          End;
     Write ('Nom du fichier : ');
     Readln(Fname);
     FindFirst(Fname,0,DirInfo);
     If DosError <> 0 Then RechargerUnePartie;
     Assign(F,Fname);
     Reset(F);
     Readln(F,S);
{     If S<>'SCRABBLE 1.0 - Pascal Munerot - 1991') Then ;}
     Readln(F,S);
     Val(S,NbJoueurs,I);
     For I:=1 To NbJoueurs Do
     Begin
          Readln(F,Nom[i]);
          Readln(F,S);
          Val(S,Scor[i],J);
          Readln(F,JeuN[i]);
          End;
     For I:=1 To 15 Do
     Begin
          Readln(F,S);
          For J:=1 To 15 Do Ech[I,J]:=S[J];
          End;
     Close(F);
     CloseWindow;
     End;

Procedure Partie.AfficheLesScores;
Begin
     TextBackGround(Blue);
     Gotoxy (1,19);
     Writeln (' NOMS                SCORES                 TIRAGES            JEUX             ');
     TextColor(Yellow);
     For I:=1 To NbJoueurs Do
     Begin
          Gotoxy (01,19+I); Write(' '+Nom[i]);
          For J:=Length(Nom[i]) To 78 Do Write(' ');
          TextColor(Yellow);
          Gotoxy (23,19+I); Write(Scor[i]:3);
          Gotoxy (45,19+I);
          Write(GenereJeu);
          Gotoxy (64,19+I); Write ('........');
          End;
     End;

Procedure Partie.SaisirLesNoms;
Begin
     OpenWindow(10,10,30,30,' NOM DES JOUEURS ',2,2);
     Clrscr;
     Writeln ('ENTREE pour terminer ... ');
     NbJoueurs:=0;
     I:=0;
     Repeat
          Inc(NbJoueurs);
          Inc(I);
          Write (I,' > ');
          Readln(Nom[i]);
          Until (Nom[i]='') Or (NbJoueurs=4);
     If NbJoueurs<>4 Then Dec(NbJoueurs);
     CloseWindow;
     CloseWindow;
     Init;
     AfficheLesScores;
     End;

{g‚nŠre un jeu pour un joueur}
{utiliser NBLETTRE et faire d‚croitre les valeurs des lettres pour que }
{le stock de lettres s'‚puise progressivement}
{tenir compte de l'importance de chaque lettre dans le nombre total de}
{lettres dans le jeu}
Function Partie.GenereJeu : String;
Var S : String;
Begin
     S:='';
     For X:=1 To 8 Do S:=S+Chr(65+Random(26));
     GenereJeu:=S;
     End;

Procedure Partie.Menu;
Begin
     Ch:=' ';
     While Ch<>#0 Do Ch:=Readkey;
     Ch:=Readkey;
     Case Ch of
          #59 : SaisirLesNoms;
          #60 : RechargerUnePartie;
          #61 : SauverLaPartie;
          #62 : Begin Clrscr; Halt(0); End;
          End;
     Menu;
     End;

Begin
     Ban.Init;
     Ter.Init;
     Ter.Affiche;
     Jou.Menu;
     Ch:=Readkey;
     End.

     Jou.Init;
     Jou.RechargerUnePartie;
     X:=Ter.EcritMot(01,01,'ANTISOCIAL',Horizontal);
     X:=Ter.EcritMot(01,01,'ASSURANCE',Vertical);
     X:=Ter.EcritMot(10,03,'VOITURE',Vertical);
     X:=Ter.EcritMot(09,04,'COLONNE',Horizontal);
