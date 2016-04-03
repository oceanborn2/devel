UNIT Disk;

INTERFACE

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

Procedure Decompose(N:Integer; Var Pis,Sec,Fac : Integer);
function ResetDisk : integer;
function GetDiskStatus : integer;
function ReadSectors(Lecteur, Face, Piste, Secteur,
                     Nombre, SegAdr, OfsAdr : integer;
                     var Lu : integer) : integer;
function WriteSectors(Lecteur, Face, Piste, Secteur, Nombre,
                      SegAdr, OfsAdr : integer; var Ecrit : integer) : integer;
procedure SetDASD(DiskFormat : integer);
function FormatPiste(Lecteur, Face, Piste, Nombre, Bytes : integer) : integer;
procedure WriteError(NumeroErreur : integer);
procedure Lire (Lecteur, Piste, Secteur, Face : Integer);
procedure Remplir (Lecteur, Piste, Secteur, Face : Integer; C : Char);
procedure Formater (Lecteur, Piste, Face, Nombre : Integer);
Procedure Constantes;


IMPLEMENTATION

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
{* Lire : Charger un secteur de la disquette et l'afficher sur        *}
{*        l'‚cran                                                     *}
{* Entr‚e : Aucune                                                    *}
{* Sortie : Aucune                                                    *}
{**********************************************************************}

procedure Lire (Lecteur, Piste, Secteur, Face : Integer);
var BufferDonnees : array [1..512] of char;
begin
 ErrCode := ReadSectors(Lecteur, Face, Piste, Secteur, 1,
                         seg(BufferDonnees), ofs(BufferDonnees), Dummy);
 if (ErrCode = 0) then
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
  else WriteError(ErrCode);
end;

{**********************************************************************}
{* Formater: formate un nombre d‚termin‚ de secteurs d'une piste en   *}
{*           512 octets                                               *}
{**********************************************************************}

procedure Formater (Lecteur, Piste, Face, Nombre : Integer);
begin
  if AT then SetDASD(Typef);             { Si AT, alors fixer type disquette }
  WriteError(FormatPiste(Lecteur, Face, Piste, Nombre, 2));
end;

{**********************************************************************}
{* Remplir: Remplir un secteur avec un caractŠre                      *}
{**********************************************************************}
procedure Remplir (Lecteur, Piste, Secteur, Face : Integer; C : Char);
var BufferDonnees : array [1..512] of char;   { Contenu du secteur … remplir }
    Compteur      : Integer;
begin
 for Compteur := 1 to 512 do BufferDonnees[Compteur] := C;
 WriteError(WriteSectors(Lecteur, Face, Piste, Secteur, 1,
                          seg(BufferDonnees), ofs(BufferDonnees), Dummy));
end;

{d‚compose un secteur absolu en son adresse piste / secteur / face}
Procedure Decompose(N:Integer; Var Pis,Sec,Fac : Integer);
Const NbSectPerTrack = 18; {5p25.360 ko}
Begin
     Fac:=N mod 2; {2 tˆtes de lecture / ‚criture}
     Pis:=N div NbSectPerTrack;
     Sec:=(N mod NbSectPerTrack) div 2;
     Inc(Sec);
     If Sec>9 Then Begin
                        Sec:=1;
                        Inc(Pis);
                        If Fac=1 Then Fac:=0 Else Fac:=1;
                   End;
     End;

Begin
     End.
