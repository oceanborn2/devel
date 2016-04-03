{**********************************************************************}
{*                          D I S K _ M O N                           *}
{*--------------------------------------------------------------------*}
{*    Fonction       : DISK_MON est un petit moniteur de disquette    *}
{*                     reposant sur les fonctions de l'interruption   *}
{*                     disquette $13 du DOS                           *}
{*--------------------------------------------------------------------*}
{*    Auteur         : MICHAEL TISCHER                                *}
{*    D‚velopp‚ le   : 09/07/1987                                     *}
{*    DerniŠre modif.: 27/02/1989                                     *}
{**********************************************************************}

program DISK_MON;

Uses Crt, Dos;                            { Int‚grer unit‚s CRT et DOS }
type TypeBuffer = array [1..1] of char;
     TypeFormat = record           { Le BIOS a besoin de ces        }
                   Piste,          { informations pour tout secteur }
                   Face,           { d'une piste … formater         }
                   Secteur,
                   Longueur  : byte;
                 end;

var ErrCode     : byte;           { Etat d'erreur aprŠs op‚rations disquette }
    Instruction : string[1];          { Instruction entr‚e par l'utilisateur }
    Typef,                    { Type de disquette pour fonction de formatage }
    Lecteur,                                      { Num‚ro du lecteur actuel }
    Face       : integer;          { Num‚ro de la face de disquette actuelle }
    Dummy       : integer;                                { Variable fictive }
    AT          : boolean;                     { L'ordinateur est-il un AT ? }

{************************************************************************}
{* ResetDisk: R‚initialisation de tous les lecteurs disquette connect‚s *}
{* Entr‚e : Aucune                                                      *}
{* Sortie : Etat d'erreur                                               *}
{************************************************************************}

function ResetDisk : integer;

var Regs : Registers;  { Registres du processeur pour l'appel d'interruption }

begin
 Regs.ah := 0;                           { Num‚ro de fonction pour Reset : 0 }
 Intr($13, Regs);                      { Appeler interruption disque du BIOS }
 ResetDisk := Regs.ah;                                { Lire l'‚tat d'erreur }
end;

{**********************************************************************}
{* GetDiskStatus: Lire l'‚tat d'erreur                                *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Etat d'erreur                                             *}
{**********************************************************************}

function GetDiskStatus : integer;

var Regs : Registers;  { Registres du processeur pour l'appel d'interruption }

begin
 Regs.ah := 1;                  { Nø de fonction pour Lire ‚tat d'erreur : 1 }
 Intr($13, Regs);                      { Appeler interruption disque du BIOS }
 GetDiskStatus := Regs.ah;                              { Lire ‚tat d'erreur }
end;

{**********************************************************************}
{* ReadSectors: Lire un nombre de secteurs d‚termin‚                  *}
{* Entr‚e : Voir plus bas                                             *}
{* Sortie : Etat d'erreur                                             *}
{**********************************************************************}

function ReadSectors(Lecteur,    { Lecteur disquette utilis‚ pour la lecture }
                     Face,                          { Face ou num‚ro de tˆte }
                     Piste,                                   { Piste … lire }
                     Secteur,                       { Premier secteur … lire }
                     Nombre,                     { Nombre de secteurs … lire }
                     SegAdr,                  { Adresse de segment du buffer }
                     OfsAdr : integer;          { Adresse d'offset du buffer }
                     var Lu : integer) : integer;
var Regs : Registers;  { Registres du processeur pour l'appel d'interruption }

begin
 Regs.ah := 2;                            { Num‚ro de fonction pour Lire : 2 }
 Regs.al := Nombre;                        { Fixer nombre de secteurs … lire }
 Regs.dh := Face;                                     { Fixer num‚ro de face }
 Regs.dl := Lecteur;                               { Fixer num‚ro de lecteur }
 Regs.ch := Piste;                                   { Fixer num‚ro de piste }
 Regs.cl := Secteur;                               { Fixer num‚ro de secteur }
 Regs.es := SegAdr;                                { Fixer adresse de buffer }
 Regs.bx := OfsAdr;
 Intr($13, Regs);                      { Appeler interruption disque du BIOS }
 Lu := Regs.al;                                     { Nombre de secteurs lus }
 ReadSectors := Regs.ah;                                { Lire ‚tat d'erreur }
end;

{**********************************************************************}
{* WriteSectors: Ecrire un nombre de secteurs d‚termin‚               *}
{* Entr‚e : Voir plus bas                                             *}
{* Sortie : Etat d'erreur                                             *}
{**********************************************************************}

function WriteSectors(Lecteur,           { Lecteur disquette pour l'‚criture }
                      Face,                         { Face ou num‚ro de tˆte }
                      Piste,                                { Piste … ‚crire }
                      Secteur,                    { Premier secteur … ‚crire }
                      Nombre,                  { Nombre de secteurs … ‚crire }
                      SegAdr,                 { Adresse de segment du buffer }
                      OfsAdr : integer;         { Adresse d'offset du buffer }
                      var Ecrit : integer) : integer;

var Regs : Registers;  { Registres du processeur pour l'appel d'interruption }

begin
 Regs.ah := 3;                         { Num‚ro de fonction pour Ecrire : 3  }
 Regs.al := Nombre;                      { Fixer nombre de secteurs … ‚crire }
 Regs.dh := Face;                                     { Fixer num‚ro de face }
 Regs.dl := Lecteur;                               { Fixer num‚ro de lecteur }
 Regs.ch := Piste;                                   { Fixer num‚ro de piste }
 Regs.cl := Secteur;                               { Fixer num‚ro de secteur }
 Regs.es := SegAdr;                                { Fixer adresse de buffer }
 Regs.bx := OfsAdr;
 Intr($13, Regs);                      { Appeler interruption disque du BIOS }
 Ecrit := Regs.al;                               { Nombre de secteurs ‚crits }
 WriteSectors := Regs.ah;                               { Lire ‚tat d'erreur }
end;

{**********************************************************************}
{* SetDASD: doit ˆtre appel‚e, sur un AT, avant tout formatage, pour  *}
{*          indiquer si le format … utiliser est le format 360 Ko ou  *}
{*          le format 1,2 Mo                                          *}
{* Entr‚e : Voir plus bas                                             *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure SetDASD(DiskFormat : integer);

var Regs : Registers;  { Registres du processeur pour l'appel d'interruption }

begin
 Regs.ah := $17;                                  { Fixer num‚ro de fonction }
 Regs.al := DiskFormat;                                       { Fixer format }
 Regs.dl := Lecteur;                               { Fixer num‚ro de lecteur }
 Intr($13, Regs);                      { Appeler interruption disque du BIOS }
end;

{**********************************************************************}
{* FormatPiste: formate un secteur                                    *}
{* Entr‚e : Voir plus bas                                             *}
{* Sortie : Etat d'erreur                                             *}
{**********************************************************************}

function FormatPiste(Lecteur,               { Num‚ro du lecteur de disquette }
                      Face,                      { Num‚ro de face ou de tˆte }
                      Piste,                              { Piste … formater }
                      Nombre,           { Nombre de secteurs sur cette piste }
                      Bytes   :  integer) :  integer;

var Regs : Registers;  { Registres du processeur pour l'appel d'interruption }
    Tableau  : array [1..15] of TypeFormat;         { 15 secteurs au maximum }
    Compteur : integer;                                 { Compteur de boucle }

begin
 for Compteur := 1 to Nombre do       { Mettre en place ‚criture sur secteur }
  begin
   Tableau[Compteur].Piste   := Piste;                  { Num‚ro de la piste }
   Tableau[Compteur].Face    := Face;                       { Face disquette }
   Tableau[Compteur].Secteur := Compteur;                { Num‚ro du secteur }
   Tableau[Compteur].Longueur := Bytes;    { Nombre d'octets dans le secteur }
  end;
 Regs.ah := 5;                                    { Fixer num‚ro de fonction }
 Regs.al := Nombre;                     { Nombre de secteurs sur cette piste }
 Regs.es := Seg(Tableau[1]);                       { Adresse du tableau dans }
 Regs.bx := Ofs(Tableau[1]);                        { les registres ES et BX }
 Regs.dh := Face;                                     { Fixer num‚ro de face }
 Regs.dl := Lecteur;                               { Fixer num‚ro de lecteur }
 Regs.ch := Piste;                                   { Fixer num‚ro de piste }
 Intr($13, Regs);                      { Appeler interruption disque du BIOS }
 FormatPiste := Regs.ah;                                { Lire ‚tat d'erreur }
end;

{**********************************************************************}
{* WriteError: sort un message d'erreur en fonction du code d'erreur  *}
{*             transmis                                               *}
{* Entr‚e : Le num‚ro d'erreur                                        *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure WriteError(NumeroErreur : integer);

begin
 case NumeroErreur of
  $00 : ;                                          { 0 signifie pas d'erreur }
  $01 : writeln('ERREUR : Num‚ro de fonction non autoris‚');
  $02 : writeln('ERREUR : Marque d"adresse non trouv‚e');
  $03 : writeln('ERREUR : Tentative d"‚criture sur un disque prot‚g‚ contre l"‚criture');
  $04 : writeln('ERREUR : Secteur non trouv‚');
  $06 : writeln('ERREUR : Disquette a ‚t‚ chang‚e');
  $08 : writeln('ERREUR : D‚bordement DMA');
  $09 : writeln('ERREUR : Transfert de donn‚es par-del… la limite de segment');
  $10 : writeln('ERREUR : Erreur en lecture');
  $20 : writeln('ERREUR : Erreur sur le contr“leur de disquette');
  $40 : writeln('ERREUR : Piste non trouv‚e');
  $80 : writeln('ERREUR : Erreur de Time Out');
  else  writeln('ERREUR : Erreur ',NumeroErreur,' inconnue');
 end;
 if (NumeroErreur <> 0) then NumeroErreur:=ResetDisk;       { Ex‚cuter Reset }
end;

{**********************************************************************}
{* Constantes: Entr‚e des deux constantes num‚ro de lecteur et face   *}
{*             disquette ou num‚ro de tˆte, plus sur l'AT le type de  *}
{*             disquette                                              *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure Constantes;

begin
 write('Num‚ro de lecteur (0-3)   : ');
 readln(Lecteur);                                { Lire le num‚ro de lecteur }
 write('Face disquette (0 ou 1)   : ');
 readln(Face);                                         { Lire num‚ro de tˆte }
 if AT then                                        { N'ex‚cuter que sur l'AT }
  begin
   writeln('ParamŠtres de formatage :');
   writeln('  1 = disquette 320/360 Ko sur lecteur 320/360 Ko');
   writeln('  2 = disquette 320/360 Ko sur lecteur 1,2 Mo');
   writeln('  3 = disquette 1,2 Mo sur un lecteur 1,2 Mo');
   write('                    Votre entr‚e : ');
   readln(Typef)
  end;
end;

{**********************************************************************}
{* Help: Sortir texte d'aide sur l'‚cran                              *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure Help;

begin
 writeln(#13#10'LISTE  D"INSTRUCTIONS');
 writeln('---------------------------');
 writeln('t = Termin‚');
 writeln('l = Lire');
 writeln('s = Remplir un secteur');
 writeln('r = R‚initialiser');
 writeln('f = Formater');
 writeln('c = Constantes');
 writeln('? = Aide'#13#10);
end;

{**********************************************************************}
{* Lire : Charger un secteur de la disquette et l'afficher sur        *}
{*        l'‚cran                                                     *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure Lire;

var BufferDonnees : array [1..512] of char;             { Les caractŠres lus }
    Piste,                                                 { La piste … lire }
    Secteur : integer;                                      { Secteur … lire }

begin
 write('piste  : ');
 readln(Piste);                                    { Entrer piste au clavier }
 write('secteur: ');
 readln(Secteur);                                { Entrer secteur au clavier }
 ErrCode := ReadSectors(Lecteur, Face, Piste, Secteur, 1,
                         seg(BufferDonnees), ofs(BufferDonnees), Dummy);
 if (ErrCode = 0) then                         { Erreur apparue en lecture ? }
  begin
   write('----------------------------------------'+
         '----------------------------------------');
   for Dummy:=1 to 512 do                        { Sortir les 512 caractŠres }
    begin
     case BufferDonnees[Dummy] of
      #00 : write('<NUL>');  { Traitement sp‚cial des caractŠres de commande }
      #07 : write('<BEL>');
      #08 : write('<BS>');
      #09 : write('<TAB>');
      #10 : write('<LF>');
      #13 : write('<CR>');
      #27 : write('<ESC>');
      else  write(BufferDonnees[Dummy]); { Sortir tels quels caract. normaux }
     end;
    end;
   write(#13#10'----------------------------------------'+
               '----------------------------------------');
  end
  else WriteError(ErrCode);                        { Sortir message d'erreur }
end;

{**********************************************************************}
{* Formater: formate un nombre d‚termin‚ de secteurs d'une piste en   *}
{*           512 octets                                               *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure Formater;

var Piste,                                                { Piste … formater }
    Nombre : integer;                 { Nombre de secteurs … mettre en place }

begin
  write('piste  : ');
  readln(Piste);                      { Entrer num‚ro de la piste au clavier }
  write('nombre: ');
  readln(Nombre);                     { Entrer nombre de secteurs au clavier }
  if AT then SetDASD(Typef);             { Si AT, alors fixer type disquette }
  WriteError(FormatPiste(Lecteur, Face, Piste, Nombre, 2));
end;

{**********************************************************************}
{* Remplir: Remplir un secteur avec un caractŠre                      *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure Remplir;

var BufferDonnees : array [1..512] of char;   { Contenu du secteur … remplir }
    Compteur,                                           { Compteur de boucle }
    Piste,                 { Piste dans laquelle figure le secteur … remplir }
    Secteur : integer;                         { Num‚ro du secteur … remplir }
    Caractere : char;                          { Le caractŠre de remplissage }

begin
 write('piste   : ');
 readln(Piste);                                    { Entrer piste au clavier }
 write('secteur : ');
 readln(Secteur);                                { Entrer secteur au clavier }
 write('Caractere: ');
 readln(Caractere);             { Entrer caractŠre de remplissage au clavier }
 for Compteur := 1 to 512 do
  BufferDonnees[Compteur] := Caractere;      { Remplir buffer avec caractŠre }
 WriteError(WriteSectors(Lecteur, Face, Piste, Secteur, 1,
                          seg(BufferDonnees), ofs(BufferDonnees), Dummy));
end;

{**********************************************************************}
{**                        PROGRAMME PRINCIPAL                       **}
{**********************************************************************}

begin
 ClrScr;                                                       { Vider ‚cran }
 TextBackground( LightGray );                                   { Fond clair }
 TextColor( Black );                                       { Ecriture sombre }
 writeln(' DISKMON: (c) 1987 by Michael Tischer   '+           { Ligne titre }
         '                              ? = Aide ');
 TextBackground( Black );                                      { Fond sombre }
 TextColor( LightGray );                                   { Ecriture claire }
 Window(1, 2, 80, 25);{ Seule la 1Šre ligne ne fait pas partie de la fenˆtre }
 Lecteur := 0;                           { D‚finir lecteur 0 comme constante }
 Face := 0;                                 { D‚finir face 0 comme constante }
 Typef := 3;                           { Disquette 1,2 Mo sur lecteur 1,2 Mo }
 if Mem[$F000:$FFFE] = $FC then AT := true            { Tester si AT ou bien }
                           else AT := false;          { PC ou XT             }
 repeat
  repeat
   write('DISKMON>');                           { Sortir message de dialogue }
   readln(Instruction);                      { Entrer instruction au clavier }
  until (Instruction <> '');
  case (Instruction[1]) of                             { Evaluer instruction }
   '?' : Help;                                         { Sortir texte d'aide }
   'r' : WriteError(ResetDisk);                  { Ex‚cuter r‚initialisation }
   's' : Remplir;                                       { Remplir un secteur }
   'f' : Formater;                                      { Formater une piste }
   'l' : Lire;                                             { Lire un secteur }
   'c' : Constantes;                                 { Entrer des constantes }
   else if Instruction <> 't' then writeln('Instruction inconnue');
  end;
 until (Instruction = 't');           { Si instruction 't', fin du programme }
end.
