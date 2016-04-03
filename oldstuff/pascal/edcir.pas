Program EDCI; {Enhanced Dos Command Interpreter}

{$M 2048, 0, 55120}   { 2Ko pour la pile et 5 Ko maximum pour le Heap }
{$L tsrp}                             { Int‚grer le module assembleur }

Uses Crt,Dos,WinExt;

Const
      LSHIFT =     1;                                   { Touche SHIFT gauche }
      RSHIFT =     2;                                   { Touche SHIFT droite }
      CTRL   =     4;                                           { Touche CTRL }
      ALT    =     8;                                            { Touche ALT }
      SYSREQ =  1024;                 { Touche SYS-REQ (seulement clavier AT) }
      BREAK  =  4096;                                          { Touche BREAK }
      NUM    =  8192;                                            { Touche NUM }
      CAPS   = 16384;                                           { Touche CAPS }
      INSERT = 32768;                                         { Touche INSERT }

      NO_END_FCT = $FFFF;                 { Ne pas appeler de fonction de fin }

     Max   : Integer = 0;
     Mask  : String = '*.*';
     MMenu : Array [1..2] of Integer=(1,1);

     MaxFM = 5;
     MaxSM = 9;

     MFM   : Integer=1;
     MSM   : Integer=1;

     FM    : Array [1..MaxFM] of String[10] = ('File','Calendar','Calculator','Notebook','Dos');
     SM    : Array [1..MaxSM] of String[9] = ('Dir','Type','Copy','Delete','Execute','Media','ChDir','MDir','Rdir');

Type
     IdsType = string[ 16 ];              { D‚crit la chaŒne d'identification }
     VBuf    = array[1..25, 1..80] of word;                  { D‚crit l'‚cran }
     VPtr    = ^VBuf;                        { Pointeur sur un buffer d'‚cran }

    Banner = Object
             Procedure Banner;
             End;

    FileOb = Object
             Procedure DirectoryFile(A:Boolean);
             Procedure TypeFile;
             Procedure CopyFile;
             Procedure DeleteFile;
             Procedure Execute;
             Procedure Media;
             Procedure ChangeDir;
             Procedure MakeDir;
             Procedure EraseDir;
             End;

    Menu =   Object
             Procedure Main_Right;
             Procedure Main_Left;
             Procedure Main_Specials;
             Procedure Main_Interp;
             Procedure Main_ChoiceMade;

             Procedure File_Right;
             Procedure File_Left;
             Procedure File_Specials;
             Procedure File_Interp;
             Procedure File_ChoiceMade;
             Procedure File_Desk;

             Procedure Init;
             Procedure Calendar_Desk;
             Procedure Calculator_Desk;
             Procedure NoteBook_Desk;
             End;

    Init =   Object
             Procedure Init;
             End;

Var
    MenuPtr   : ^Menu;
    BannerPtr : ^Banner;
    FilePtr   : ^FileOb;
    Runner    : Init;

            I : Integer;
           CH : Char;

    DirInfo   : SearchRec;
    IdString : IdsType;                  { La chaŒne ID pour le programme TSR }
    MBuf     : VBuf absolute $B000:0000;            { La RAM vid‚o monochrome }
    CBuf     : Vbuf absolute $B800:0000;               { La RAM vid‚o couleur }
    VioPtr   : VPtr;                              { Pointeur sur la RAM vid‚o }

Procedure Erreur (n:integer);
Begin
     Case N of
          0 : Writeln ('Fichier(s) non trouv‚');
          End;
     Ch:=Readkey;
     End;

Procedure YellowAndBlue;
Begin
     TextColor(Yellow); TextBackground(Blue);
     End;

Procedure WhiteAndBlack;
Begin
     TextColor(White); TextBackground(Black);
     End;

Procedure BlackAndWhite;
Begin
     TextColor(Black); TextBackground(White);
     End;

Procedure WhiteAndBlue;
Begin
     TextColor(White); TextBackground(Blue);
     End;

Procedure Banner.Banner;
Begin
     Clrscr;
     Writeln ('Enhanced Dos Command Interpreter');
     Writeln ('(C) 1991. Pascal Munerot');
     Writeln;
     Writeln ('This program is a resident program which is able to');
     Writeln ('give you access to a lot of commands under a program');
     Writeln ('which is already running. It''s the main goal of this ');
     Writeln ('software');
     Writeln;
     Writeln ('It uses a menu to allow you enter the commands');
     Writeln;
     Writeln ('Its first possibilities are to manipulate files more easily');
     Writeln ('than the standard DOS interpreter');
     End;

Procedure Menu.File_Left;
Begin
     BlackAndWhite; {Black White}
     Gotoxy ((MSM-1)*9+2,1); Write(SM[MSM]);
     TextColor(Red); Gotoxy ((MSM-1)*9+2,1);
     Write(SM[MSM,1]);
     Dec(MSM);
     If (MSM<1) Then MSM:=MaxSM;
     WhiteAndBlue;
     Gotoxy ((MSM-1)*9+2,1); Write(SM[MSM]);
     End;

Procedure Menu.File_Right;
Begin
     BlackAndWhite;
     Gotoxy ((MSM-1)*9+2,1); Write(SM[MSM]);
     TextColor(Red); Gotoxy ((MSM-1)*9+2,1);
     Write(SM[MSM,1]);
     Inc(MSM);
     If (MSM>MaxSM) Then MSM:=1;
     WhiteAndBlue;
     Gotoxy ((MSM-1)*9+2,1); Write(SM[MSM]);
     End;

Procedure Menu.File_Specials;
Begin
     Ch:=Readkey;
     Case Ch of
          #77 : File_Right;
          #75 : File_Left;
          End;
     End;

Procedure Menu.File_Interp;
Begin
     Ch:=Upcase(Readkey);
     Case CH of
          #0  : File_Specials;
          #13 : File_ChoiceMade;
          #27 : Begin CloseWindow; Exit; End;
          End;
     File_Interp;
     End;

Procedure FileOb.DirectoryFile(A:Boolean);
Const S : String='';
Begin
     OpenWindow(1,7,80,24,' Directory List ',2,2);
     YellowAndBlue;
     Clrscr;
     If A Then Begin Write ('> '); Readln(S); End Else S:=Mask;
     FindFirst(S,AnyFile,DirInfo);
     Gotoxy(1,1);
     While (DosError = 0) Do
     Begin
          If (WhereY>15) Then Begin Gotoxy (1,1); Ch:=Readkey; End;
          Write (DirInfo.Name); Gotoxy(30,WhereY); Writeln(DirInfo.Size,'     ');
          FindNext(DirInfo);
          End;
     Ch:=Readkey;
     WhiteAndBlack;
     CloseWindow;
     End;

Procedure FileOb.TypeFile;
Var F : Text;
    S : String;
Begin
     S:='';
     OpenWindow(1,7,80,24,' Displaying a file ',2,2);
     DirectoryFile(False);
     YellowAndBlue;
     Clrscr;
     Write('> '); Readln(S);
     Assign (F,S);
     FindFirst(S,0,DirInfo);
     If (DosError <> 0) Then Begin CloseWindow; Exit; End;
     Reset(F);
     While Not Eof(F) Do
     Begin
          Readln (F,S);
          Writeln(S);
          If (WhereY>14) Then Begin Ch:=Readkey;
                                    If (Ch=#27) Then Begin CloseWindow;
                                                           Exit;
                                                           End;
                                    Clrscr;
                                    End;
          End;
     CloseWindow;
     End;

Procedure FileOb.CopyFile;
Begin
     End;

Procedure FileOb.DeleteFile;
Var S : String;
    F : File;
    Conf : Boolean;
Begin
     S:='';
     OpenWindow (1,7,80,24,' Deleting file(s) ',2,2);
     Clrscr;
     Write('> '); Readln(S);
     If (S='') Then Begin CloseWindow; Exit; End;
     Writeln ('Do you want to check files ? (Y/N) ');
     Ch:=Upcase(Readkey);
     Case CH of
          'N':Conf:=False;
          Else Conf:=True;
          End;
     FindFirst(S,0,DirInfo);
     If (DosError<>0) Then Erreur(0);
     While DosError = 0 Do
     Begin
          Assign (F,DirInfo.Name);
          Writeln(DirInfo.Name);
          If (Conf=True) Then
                         Begin
                              Write('    Do i delete this file (Y/N) ? ');
                              Ch:=Upcase(Readkey);
                              Case Ch of
                                  'Y':Erase(F);
                                  'N':Writeln('Skipped');
                                  End;
                              End Else Erase(F);
          Writeln;
          FindNext(DirInfo);
          End;
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure FileOb.Execute;
Begin
     End;

Procedure FileOb.Media;
Begin
     End;

Procedure FileOb.ChangeDir;
Var S : String;
Begin
     OpenWindow (1,7,80,24,' Changing of directory ',2,2);
     Clrscr;
     Write ('> '); Readln(S);
{$i-}
     ChDir(S);
     If (IoResult<>0) Then Begin CloseWindow; Exit; End;
{$i+}
     CloseWindow;
     End;

Procedure FileOb.MakeDir;
Var S : String;
Begin
     OpenWindow (1,7,80,24,' Making a new directory ',2,2);
     Clrscr;
     Write ('> '); Readln(S);
{$i-}
     MkDir(S);
     If (IoResult<>0) Then Begin CloseWindow; Exit; End;
{$i+}
     CloseWindow;
     End;

Procedure FileOb.EraseDir;
Var S : String;
Begin
     OpenWindow (1,7,80,24,' Deleting a directory ',2,2);
     Clrscr;
     Write ('> '); Readln(S);
{$i-}
     RmDir(S);
     If (IoResult<>0) Then Begin CloseWindow; Exit; End;
{$i+}
     CloseWindow;
     End;

Procedure Menu.File_ChoiceMade;
Begin
     Case MSM of
          1 : FilePtr^.DirectoryFile(True);
          2 : FilePtr^.TypeFile;
          3 : FilePtr^.CopyFile;
          4 : FilePtr^.DeleteFile;
          5 : FilePtr^.Execute;
          6 : FilePtr^.Media;
          7 : FilePtr^.ChangeDir;
          8 : FilePtr^.MakeDir;
          9 : FilePtr^.EraseDir;
      End;
     End;

Procedure Menu.File_Desk;            {M1}
Begin
     OpenWindow(1,4,80,6,' File Section ',2,2);
     BlackAndWhite;
     Clrscr;
     For I:=1 To MaxSM Do Begin Gotoxy ((I-1)*9+2,1); Write(SM[i]); End;
     TextColor(Red);
     For I:=1 To MaxSM Do Begin Gotoxy ((I-1)*9+2,1); Write(SM[i,1]); End;
     WhiteAndBlue;
     Gotoxy((MSM-1)*9+2,1); Write(SM[MSM]);
     BlackAndWhite;
     File_Interp;
     Ch:=Readkey;
     End;

Procedure Menu.Calendar_Desk;         {M2}
Begin
     OpenWindow(1,4,80,24,' Calendar Section ',2,2);
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Menu.Calculator_Desk;       {M3}
Begin
     OpenWindow(1,4,80,24,' Calculator Section ',2,2);
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Menu.NoteBook_Desk;         {M4}
Begin
     OpenWindow(1,4,80,24,' NoteBook Section ',2,2);
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Menu.Main_ChoiceMade;
Begin
     Case MFM of
          1 : File_Desk;
          2 : Calendar_Desk;
          3 : Calculator_Desk;
          4 : NoteBook_Desk;
      MaxFM : Begin CloseWindow; Dispose(MenuPtr); Halt(0); End;
      End;
     End;

Procedure Menu.Main_Left;
Begin
     BlackAndWhite;
     Gotoxy ((MFM-1)*15+2,1); Write(FM[MFM]);
     TextColor(Red); Gotoxy ((MFM-1)*15+2,1);
     Write(FM[MFM,1]);
     Dec(MFM);
     If (MFM<1) Then MFM:=MaxFM;
     WhiteAndBlue;
     Gotoxy ((MFM-1)*15+2,1); Write(FM[MFM]);
     End;

Procedure Menu.Main_Right;
Begin
     BlackAndWhite;
     Gotoxy ((MFM-1)*15+2,1); Write(FM[MFM]);
     TextColor(Red); Gotoxy ((MFM-1)*15+2,1);
     Write(FM[MFM,1]);
     Inc(MFM);
     If (MFM>MaxFM) Then MFM:=1;
     WhiteAndBlue;
     Gotoxy ((MFM-1)*15+2,1); Write(FM[MFM]);
     End;

Procedure Menu.Main_Specials;
Begin
     Ch:=Readkey;
     Case Ch of
          #77 : Main_Right;
          #75 : Main_Left;
          End;
     End;

Procedure Menu.Main_Interp;
Begin
     Ch:=Upcase(Readkey);
     Case CH of
          #0  : Main_Specials;
          #13 : Main_ChoiceMade;
          #27 : Begin CloseWindow; Exit; End;
          End;
     Main_Interp;
     End;

Procedure Menu.Init;
Begin
     WhiteAndBlack;
     TopWindow:=Nil;
     OpenWindow(1,1,80,3,' E D C I - (C) 1991. Pascal Munerot ',2,2);
     BlackAndWhite;
     Clrscr;
     For I:=1 To MaxFM Do Begin Gotoxy ((I-1)*15+2,1); Write(FM[i]); End;
     TextColor(Red);
     For I:=1 To MaxFM Do Begin Gotoxy ((I-1)*15+2,1); Write(FM[i,1]); End;
     WhiteAndBlue;
     Gotoxy((MFM-1)*10+2,1); Write(FM[MFM]);
     WhiteAndBlack;
     Main_Interp;
     End;

Procedure Init.Init;
Begin
     WhiteAndBlack;
     New(MenuPtr);
     MenuPtr^.Init;
     Dispose(MenuPtr);
     End;


procedure TsrInit( PrcPtr   : word;    { Adresse d'offset de la proc‚dure TSR }
                   KeyMask  : word;                { La Hot Key (voyez CONST) }
                   ResPara  : word;        { Nombre de paragraphes … r‚server }
                   IdString : IdsType ) ; external ;           { La chaŒne ID }

function IsInst( IdString : IdsType ) : boolean ; external ;

procedure UnInst( PrcPtr : word ); external;         { R‚inst. programme TSR. }


var ATimes : integer;                              { Nombre d'activations TSR }

{**********************************************************************}
{* DispInit: Met en place un pointeur sur la RAM vid‚o                *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure DispInit;

var Regs: Registers;                     { Re‡oit les registres du processeur }

begin
  Regs.ah := $0f;                       { Fonction nø 15 = Lire le mode vid‚o }
  Intr($10, Regs);                     { Appeler l'interruption vid‚o du BIOS }
  if Regs.al=7 then                                { Carte vid‚o monochrome ? }
    VioPtr := @MBuf            { Oui, fixer pointeur sur RAM vid‚o monochrome }
  else                             { On a affaire … une carte EGA, VGA ou CGA }
    VioPtr := @CBuf;                   { Fixer pointeur sur RAM vid‚o couleur }
end;

{**********************************************************************}
{* SaveScreen: Sauve le contenu de l'‚cran dans un buffer             *}
{* Entr‚e : SPTR : Pointeur sur le buffer dans lequel le contenu de   *}
{*                 l'‚cran doit ˆtre sauvegard‚.                      *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure SaveScreen( SPtr : VPtr );

var ligne,                                       { Ligne actuellement trait‚e }
    colonne : byte;                            { Colonne actuellement trait‚e }

begin
  for ligne:=1 to 25 do                  { Parcourir les 25 lignes de l'‚cran }
    for colonne:=1 to 80 do            { Parcourir les 80 colonnes de l'‚cran }
      SPtr^[ligne, colonne] := VioPtr^[ligne, colonne];     { Ranger c.&attr. }
end;

{**********************************************************************}
{* RestoreScreen: Copie le contenu d'un buffer dans la RAM vid‚o      *}
{* Entr‚e : BPTR : Pointeur sur le buffer dont le contenu doit ˆtre   *}
{*                 copi‚ dans la RAM vid‚o.                           *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure RestoreScreen( BPtr : VPtr );

var ligne,                                       { Ligne actuellement trait‚e }
    colonne : byte;                            { Colonne actuellement trait‚e }

begin
  for ligne:=1 to 25 do                  { Parcourir les 25 lignes de l'‚cran }
    for colonne:=1 to 80 do            { Parcourir les 80 colonnes de l'‚cran }
      VioPtr^[ligne, colonne] := BPtr^[ligne, colonne];    { Retirer c.&attr. }
end;

{**********************************************************************}
{* ResPara: Calcule le nombre de paragraphes devant ˆtre allou‚s au   *}
{*          programme                                                 *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Nombre de paragraphes … r‚server                          *}
{**********************************************************************}

function ResPara : word;

begin
  ResPara := Seg(FreePtr^)+$1000-PrefixSeg;           { Nombre de paragraphes }
end;

{**********************************************************************}
{* PrcFin: Est appel‚e par le module assembleur lors de la            *}
{*         r‚installation du programme TSR                            *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Aucune                                                    *}
{* Infos   : Cette proc‚dure doit figurer dans le programme principal *}
{*           et ne doit pas ˆtre convertie en une proc‚dure FAR avec  *}
{*           la directive $F+- du compilateur                         *}
{**********************************************************************}

{$F-}                                   { Ne pas cr‚er une proc‚dure FAR }

procedure PrcFin;

begin
  TextBackground( Black );                                      { Fond sombre }
  TextColor( LightGray );                                   { Ecriture claire }
  writeln('Le programme EDCI a ‚t‚ appel‚ ', ATimes, ' fois.');
end;

{**********************************************************************}
{* Tsr: Cette proc‚dure est appel‚e par le module assembleur lorsque  *}
{*      la Hot Key a ‚t‚ actionn‚e                                    *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Aucune                                                    *}
{* Infos  : Cette proc‚dure doit figurer dans le programme principal  *}
{*          et ne doit pas ˆtre convertie en une proc‚dure FAR avec   *}
{*          la directive $F+- du compilateur                          *}
{**********************************************************************}

{$F-}                                   { Ne pas cr‚er une proc‚dure FAR }

procedure Tsr;

var BufPtr : VPtr;                  { Re‡oit le pointeur sur le buffer allou‚ }
    Colonne,                                    { Colonne actuelle de l'‚cran }
    Ligne  : byte;                                { Ligne actuelle de l'‚cran }
    Touche  : char;

begin
  inc( ATimes );                           { Incr‚menter le compteur d'appels }
  DispInit;                            { D‚terminer l'adresse de la RAM vid‚o }
  GetMem(BufPtr, SizeOf(VBuf) );                            { R‚server buffer }
  SaveScreen( BufPtr );                   { Sauvegarder le contenu de l'‚cran }
  Ligne := WhereY;                     { Rechercher ligne actuelle de l'‚cran }
  Colonne := WhereX;                 { Rechercher colonne actuelle de l'‚cran }
  TextBackground( LightGray );                                   { Fond clair }
  TextColor( Black );                                       { Ecriture sombre }
  ClrScr;                                         { Vider l'‚cran entiŠrement }
  Runner.Init;
  RestoreScreen( BufPtr );             { Recopier l'ancien contenu de l'‚cran }
  FreeMem( BufPtr, SizeOf(VBuf) );                { Lib‚rer le buffer r‚serv‚ }
  GotoXY( Colonne, Ligne );    { Ramener le curseur sur sa position d'origine }
end;

{**********************************************************************}
{**                       PROGRAMME PRINCIPAL                        **}
{**********************************************************************}

begin
  writeln('EDCI  -  (c) 1991 Pascal Munerot');
  IdString := 'CONDOR';
  if ( IsInst( IdString ) ) then                  { Programme d‚j… install‚ ? }
    begin                                                               { OUI }
      writeln('Le programme EDCI a ‚t‚ d‚sinstall‚.');
      UnInst( Ofs( PrcFin ) );                  { D‚sinstaller le programme }

      {** Si aucune fonction de fin ne doit ˆtre appel‚e, l'appel *****
       ** sera : UnInst( NO_END_FCT );                             ****}
    end
  else                               { Le programme n'est pas encore install‚ }
    begin
      ATimes := 0;                   { Le programme n'a pas encore ‚t‚ activ‚ }
      writeln('Le programme EDCI a ‚t‚ install‚. Lancement: <LSHIFT> + ',
              '<RSHIFT>');
      TsrInit( Ofs(Tsr), LSHIFT or RSHIFT, ResPara, IdString );
    end;
end.
