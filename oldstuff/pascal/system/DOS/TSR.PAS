{**********************************************************************}
{*                              T S R                                 *}
{*--------------------------------------------------------------------*}
{*    Fonction       : Cr‚e un programme TSR … l'aide d'un module     *}
{*                     assembleur.                                    *}
{*--------------------------------------------------------------------*}
{*    Auteur         : MICHAEL TISCHER                                *}
{*    D‚velopp‚ le   : 18/08/1988                                     *}
{*    DerniŠre modif.: 19/04/1989                                     *}
{**********************************************************************}

program TSRP;

uses DOS, CRT;                                   { Int‚grer unit‚s DOS et CRT }

{$M 2048, 0, 5120}   { 2Ko pour la pile et 5 Ko maximum pour le Heap }
{$L tsrp}                             { Int‚grer le module assembleur }

const LSHIFT =     1;                                   { Touche SHIFT gauche }
      RSHIFT =     2;                                   { Touche SHIFT droite }
      CTRL   =     4;                                           { Touche CTRL }
      ALT    =     8;                                            { Touche ALT }
      SYSREQ =  1024;                 { Touche SYS-REQ (seulement clavier AT) }
      BREAK  =  4096;                                          { Touche BREAK }
      NUM    =  8192;                                            { Touche NUM }
      CAPS   = 16384;                                           { Touche CAPS }
      INSERT = 32768;                                         { Touche INSERT }

      NO_END_FCT = $FFFF;                 { Ne pas appeler de fonction de fin }

type IdsType = string[ 16 ];              { D‚crit la chaŒne d'identification }
     VBuf    = array[1..25, 1..80] of word;                  { D‚crit l'‚cran }
     VPtr    = ^VBuf;                        { Pointeur sur un buffer d'‚cran }

var IdString : IdsType;                  { La chaŒne ID pour le programme TSR }
    MBuf     : VBuf absolute $B000:0000;            { La RAM vid‚o monochrome }
    CBuf     : Vbuf absolute $B800:0000;               { La RAM vid‚o couleur }
    VioPtr   : VPtr;                              { Pointeur sur la RAM vid‚o }

{** D‚claration de la fonction externe du module assembleur ***********}

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
Begin
  TextBackground( Black );                                      { Fond sombre }
  TextColor( LightGray );                                   { Ecriture claire }
  writeln('Le programme TSR a ‚t‚ appel‚ ', ATimes, ' fois.');
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

Procedure Init;
Begin
     inc( ATimes );                           { Incr‚menter le compteur d'appels }
     DispInit;                            { D‚terminer l'adresse de la RAM vid‚o }
     GetMem(BufPtr, SizeOf(VBuf) );                            { R‚server buffer }
     SaveScreen( BufPtr );                   { Sauvegarder le contenu de l'‚cran }
     Ligne := WhereY;                     { Rechercher ligne actuelle de l'‚cran }
     Colonne := WhereX;                 { Rechercher colonne actuelle de l'‚cran }
     TextBackground( LightGray );                                   { Fond clair }
     TextColor( Black );                                       { Ecriture sombre }
     ClrScr;                                         { Vider l'‚cran entiŠrement }
     GotoXY(22, 12);
     write('DEV _ Dos Enhanced Environment -  (c) 1991 by Pascal Munerot');
     End;

Procedure Away;
Begin
     GotoXY(30, 14);
     write('Veuillez frapper une touche ...');
     Touche := ReadKey;                                    { Attendre une touche }
     RestoreScreen( BufPtr );             { Recopier l'ancien contenu de l'‚cran }
     FreeMem( BufPtr, SizeOf(VBuf) );                { Lib‚rer le buffer r‚serv‚ }
     GotoXY( Colonne, Ligne );    { Ramener le curseur sur sa position d'origine }
     End;
Begin
     Init;
     Away;
end;

{**********************************************************************}
{**                       PROGRAMME PRINCIPAL                        **}
{**********************************************************************}

begin
  writeln('TSR  -  (c) 1988 by MICHAEL TISCHER');
  IdString := 'TROTZKY';
  if ( IsInst( IdString ) ) then                  { Programme d‚j… install‚ ? }
    begin                                                               { OUI }
      writeln('Le programme TSR a ‚t‚ d‚sinstall‚.');
      UnInst( Ofs( PrcFin ) );                  { D‚sinstaller le programme }

      {** Si aucune fonction de fin ne doit ˆtre appel‚e, l'appel *****
       ** sera : UnInst( NO_END_FCT );                             ****}
    end
  else                               { Le programme n'est pas encore install‚ }
    begin
      ATimes := 0;                   { Le programme n'a pas encore ‚t‚ activ‚ }
      writeln('Le programme TSR a ‚t‚ install‚. Lancement: <LSHIFT> + ',
              '<RSHIFT>');
      TsrInit( Ofs(Tsr), LSHIFT or RSHIFT, ResPara, IdString );
    end;
end.
