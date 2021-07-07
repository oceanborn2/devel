Program Menus;

Uses Crt,Dos;
                                            
{$F+}           {pour pouvoir appeler les proc‚dures … partir des menus}
{$R+,S+,I+,V+}  {v‚rification des domaines des donn‚es}
                {des d‚bordements de pile}
                {des erreurs d'entr‚es / sorties}
                {et de la longueur des chaines de caractŠres}

                {test provisoire de fiabilit‚}
                {code plus volumineux}

Const
      Sign : String = #2#10#90#13;
      LenProtect= 31; {longueur de la chaine de protection du bureau}
      DebutFichier = 0; {seek : au d‚but du fichier}

      SCAD_BG = 'À'; SCAD_BD = 'Ù'; SCAD_HD = '¿';
      SCAD_HG = 'Ú'; SCAD_HO = 'Ä'; SCAD_VE = '³';
      DCAD_BG = 'È'; DCAD_BD = '¼'; DCAD_HD = '»';
      DCAD_HG = 'É'; DCAD_HO = 'Í'; DCAD_VE = 'º';

      NC  : Byte = Black     + 16 * LightGray;
      NHC : Byte = Red       + 16 * LightGray;
      IC  : Byte = White     + 16 * Black;
      IHC : Byte = White     + 16 * Black;
      NS  : Byte = Blue      + 16 * LightGray;
      NSI : Byte = LightGray + 16 * Blue;
      NX  : Byte = Green     + 16 * LightGray;
      NXI : Byte = LightGray + 16 * Green;

      A1 : String = '0$1$2$3$4';
      A2 : String = '9$A$B$C$D$E$F';
      A3 : String = '$5$6$7$8$';

      NORMAL        = $07;            { D‚finition des attributs de caractŠre }
      CLAIR         = $0f;            { pour une carte d'‚cran }
      INVERSE       = $70;            { monochrome }
      SOULIGNE      = $01;
      CLIGNOTER     = $80;

               { Attributs de couleur de la carte couleur }
      NOIR          = $00; BLEU          = $01; VERT          = $02;
      BLEUCOBALT    = $03; ROUGE         = $04; VIOLET        = $05;
      MARRON        = $06; GRISCLAIR     = $07; GRISSOMBRE    = $01;
      BLEUCLAIR     = $09; VERTCLAIR     = $0A; COBALTCLAIR   = $0B;
      ROUGECLAIR    = $0C; VIOLETCLAIR   = $0D; JAUNE         = $0E;
      BLANC         = $0F;

Type
    BufferPtr = ^Buffer;                {pointeur sur le buffer fichier}
    Buffer = array [1..32000] Of Word;  {pour calcul de CRC}

    {enregistrement pour les couleurs des boutons}

    ColorRec = Record
               AAVN,
               HHAVN,
               AAVI,
               HHAVI,
               AAVS,
               HHAVS,
               AAVX,
               HHAVX : Byte;
               End;

    {m‚morise les coordonn‚es de la fenˆtre active}
    WindowRec = Record
                X1,Y1,X2,Y2 : Byte;
                End;

    VBuf    = array[1..25, 1..80] of word;                  { D‚crit l'‚cran }
    VPtr    = ^VBuf;                        { Pointeur sur un buffer d'‚cran }

    TextTyp = string[80];

    {type pointeur sur le type objet bouton}
    {pour l'utilisation par l'objet menu qui initialise les boutons}
    {de maniŠre dynamique}

    PtrBouton = ^Bouton;

    {type pointeur de tableau de chaines}
    {utilis‚ par sauvezone pour sauvegarder une partie de l'‚cran}
    {avant l'installation d'une fenˆtre}

    ArrayChar = Array [1..80*25*2] of char;
    PtrArrayChar = ^ArrayChar;

    ArrayString = Array [1..25] of String;
    PtrArrayString = ^ArrayString;

    PtrString = ^String;

    {PARTIE DECLARATIVE DE L'OBJET ECRAN}

    Ecran = Object
      Initial : Word;        {signature du bouton pour identification}
      PX    : Byte;          {position x du bouton}
      PY    : Byte;          {position y du bouton}
      AVN   : Byte;          {attribut vid‚o normal}
      AVI   : Byte;          {attribut vid‚o inverse}
      HAVN  : Byte;          {attribut vid‚o normal hotkey}
      HAVI  : Byte;          {attribut vid‚o inverse hotkey}
      HPOS  : Byte;          {position hotkey}
      AVS   : Byte;          {attribut vid‚o s‚lection}
      HAVS  : Byte;          {attribut vid‚o s‚lection hotkey}
      HAVX  : Byte;          {attribut vid‚o hotkey interdit}
      AVX   : Byte;          {attribut vid‚o interdit}
      T     : PtrString;     {texte}
      P     : PtrBouton;     {espace de m‚morisation}
      Procedure DetecteEcran;{d‚tecte le type d'‚cran (MONO/COULEUR)}
      Procedure DPrint( Colonne,Ligne,Couleur : byte; StrOut: TextTyp);
      Procedure Sauve    (SPtr : VPtr);{sauvegarde de l'‚cran}
      Procedure Restaure (BPtr : VPtr);{restauration de l'‚cran}
      Procedure LireCarAttr(Var C,A : Char);{lit un attribut vid‚o … la position courante du curseur}
      Function  SauveZone (X1,Y1,X2,Y2 : Byte) : PtrArrayChar;{sauvegarde une zone d'‚cran pour installation d'une fenˆtre}
      Procedure RestaureZone (X1,Y1,X2,Y2 : Byte; Var Temp : PtrArrayChar); {restaure une portion d'‚cran}
      Procedure CadreSimple (X1,Y1,X2,Y2,A : Byte);{affiche un cadre simple}
      Procedure CadreDouble (X1,Y1,X2,Y2,A : Byte);{affiche un cadre double}
      Procedure SauveFenetre (Var W : WindowRec); {sauvegarde les coordonn‚es}
                                                  {la fenˆtre active}
      Procedure RestaureFenetre(Var W : WindowRec); {restaure une fenˆtre}
      End;

    {statut d'activit‚ d'un bouton}
    Statut = (Norm,Invers,Indefini);

    {orientation du menu, pour la gestion des flŠches}
    Orientation = (Vertical,Horizontal,Aucun);

    {type pointeur de sous programme}
    Lancement = Procedure;

    {PARTIE DECLARATIVE DE L'OBJET BOUTON}

    Bouton = Object(Ecran)
      Proc   : Lancement;  {proc‚dure … lancer}
      Stat   : Statut;
      Selec    : Boolean; {est-ce le bouton est s‚lectionn‚}
      Interd : Boolean; {est-ce que le bouton est autoris‚}
      S     : PtrString;     {sauvegarde de l'‚cran}
      Constructor Init(XX,YY,HHPOS:Byte; Col:ColorRec; TT:String; PProc:Lancement);
      Procedure SauveZoneBouton (XX,YY,Taille : Byte);{sauvegarde la portion d'‚cran occup‚e par un bouton}
      Procedure Select; {s‚lectionne un bouton - faux par d‚faut}
      Procedure Deselect; {d‚s‚lectionne un bouton}
      Procedure Interdit; {interdit une option du menu - faux par d‚faut}
      Procedure Autorise; {autorise une option}
      Function  Signature : Word; {signature du bouton}
      Function  StatBouton : Statut; {renvoie l'activit‚ du bouton}
      Procedure MontreNormal; {affiche un bouton dans ses couleurs normales}
      Procedure MontreInverse;{affiche un bouton dans ses couleurs inverses}
      Procedure MontreSelect; {affiche un bouton s‚lectionn‚}
      Procedure MontreSelectI;
      Procedure MontreInterd;  {affiche un bouton interdit}
      Procedure MontreInterdI; {affiche un bouton interdit en inverse}
      Procedure Cache; {cache un bouton}
      Destructor Done; {met fin … l'activit‚ d'un bouton et libŠre la m‚moire}
                       {qui lui ‚tait associ‚e}
      End;

    {enregistrement faisant partie de la liste des boutons}
    {et pointeur sur cette cellule}

    PtrCellBouton = ^CellBouton;
    CellBouton = Record
                 Next : PtrCellBouton;
                 Prev : PtrCellBouton;
                 Bou  : PtrBouton;
                 End;

    {type liste de boutons pour gestion par l'objet MENU}
    ListeBoutons = Record
                 Deb : PtrCellBouton;
                 Fin : PtrCellBouton;
                 End;

{    PtrCellProc = ^CellProc;
    CellProc = Record
                 Next : PtrCellProc;
                 Prev : PtrCellProc;
                 Ptr  : Lancement;
                 End; }

    {PARTIE DECLARATIVE DE L'OBJET MENU}

    PtrMenu = ^Menu;
    PtrCellMenu = ^CellMenu;
    CellMenu = Record
                 Next : PtrCellMenu;
                 Prev : PtrCellMenu;
                 Men  : PtrMenu;
                 End;

    {type liste de boutons pour gestion par l'objet MENU}
    ListeMenus = Record
                 Deb : PtrCellMenu;
                 Fin : PtrCellMenu;
                 End;

    Menu = Object(Bouton)
      Aff       : Boolean;    {‚tat d'affichage du menu}
      ListB     : ListeBoutons;
      Actuel    : PtrCellBouton; {bouton actuel}
      Orient    : Orientation; {orientation du menu}
      Principal : Boolean;
      Constructor Init(Sens : Orientation; Princ : Boolean);
      Function AjBouton(XX,YY,HHPOS : Byte;
                            Col : ColorRec;
                            TT : String; PPRoc : Lancement) : PtrBouton;
      Procedure Affiche;   {affiche tous les boutons du menu}
      Procedure Descendre; {prochain bouton en descendant}
      Procedure Monter;    {prochain bouton en montant}
      Procedure Gauche;    {prochain bouton … gauche}
      Procedure Droite;    {prochain bouton … droite}
      Function  HotKey : Boolean;   {gestion des touches raccourcies}
      Procedure Choisir_1; {runtime pour choisir}
      Procedure Choisir;   {appel une m‚thode initialis‚e quand un bouton est cliqu‚}
      Procedure Specials;  {gestion des caractŠres sp‚ciaux}
      Procedure CacheTout; {cache tous les boutons}
      Destructor Done;     {libŠre la m‚moire des boutons ainsi que celle}
                           {du menu}
    End;

    {PARTIE DECLARATIVE DE L'OBJET SOURIS}

    Souris = Object(Menu)
      Sour : Boolean;    {la souris est t'elle pr‚sente et/ou demand‚e?}
      Constructor Init;  {initialise la souris}
      Procedure   Montre;{montre le curseur de la souris}
      Procedure   Cache; {cache le curseur de la souris}
      Destructor  Done;  {destruction de l'objet souris}
    End;

    PtrApplication = ^Application;
    Application = Object(Souris)
      Nom      : String[8]; {nom de l'application}
      Bureau   : String[8]; {nom du bureau}
      CRC      : Word;      {CRC de l'application}
      PassWord : Boolean;   {y a t'il un mot de passe ?}
      Trouve   : Boolean;   {est-ce la chaine de protection est trouv‚e?}
      ListM    : ListeMenus; {liste des menus}
      Constructor Init (NNom : String; HSouris : Boolean);
       {initialise l'application avec son nom}
      Function    VerifieCode (Var C : String) : Boolean;
      Function    NouveauCode(AncienC, Nouveau : String): Boolean;
      Procedure   AjMenu(Var M : PtrMenu);
      Function    Crypte (St : String) : String;
      Function    CalcCrc (Var Fname : String; Var Err : Boolean) : Word;
      Function    ChangeBureau (Var Fname : String) : Boolean;
      Procedure   Scan (Var Pos : Longint);
      Procedure   ChercheProt;
      Function    ChargeBureau : Boolean;
      Function    SauveBureau (Fname : String) : Boolean;
      Procedure   GoodBeep;
      Destructor  Done;
    End;

Const
    Sortie        : Boolean = False; {flag de sortie d'un sous menu par une }
                                     {flŠche de direction de sens oppos‚ …}
                                     {celui du menu}
    FakeConst     : String = '$0$1$2$3$4$5$6$7$8$9$A$B$C$D$E$F';
    Pass          : String = '        '; {mot de passe}
    PassFlag      : Boolean = False;     {flag du mot de passe}
    Bureau        : String = '        '; {nom du bureau}

    Memory        : POINTER     = NIL;

    {variables de type objets}
    Princ         : PtrMenu     = NIL;
    Opt           : PtrMenu     = NIL;
    Meth          : PtrMenu     = NIL;

    Zone          : PtrArrayChar = NIL ; {sauvegarde d'une fenˆtre}
    Zone1         : PtrArrayChar = NIL ; {sauvegarde d'une fenˆtre}
    Zone2         : PtrArrayChar = NIL ; {sauvegarde d'une fenˆtre}
    Zone3         : PtrArrayChar = NIL ; {sauvegarde d'une fenˆtre}

Var
    mdp           : String;

    PageEcran     : Byte Absolute $40:$62; {page ‚cran courante}
    KeybState     : Byte absolute $40:$17; {‚tat du clavier}

    FProtect      : File of char;{variable fichier utilis‚e pour rechercher}
                                 {la chaine du bureau}

    Enc           : Application;
    Ec            : Ecran;

    {variables diverses}
    Ch            : Char;
    I             : Integer;
    VSeg          : Word;                     { Segment vid‚o}

    Win,
    Win1,
    Win2,
    Win3          : WindowRec;


    Coul          : ColorRec;
    MBuf          : VBuf absolute $B000:0000; { La RAM vid‚o monochrome }
    CBuf          : Vbuf absolute $B800:0000; { La RAM vid‚o couleur }
    VioPtr        : VPtr;                     { Pointeur sur la RAM vid‚o }

    OUEX,NALE,ROCR,RODE,PERM : PtrBouton; {boutons du menu des m‚thodes}
    SOUR,COULEUR,CHARG,
    PASSW,SAUV               : PtrBouton; {boutons du menu des options}
    CODE,METHODS,QUIT,
    OPTION,ENCR              : PtrBouton; {boutons du menu principal}


{d‚termine si l'‚cran est couleur ou monochrome}

Procedure Ecran.DetecteEcran;
Var Crtc_Port : Word Absolute $0040:0063;
Begin
  If CRTC_PORT = $3B4 Then
    VSeg := $B000
  Else
    VSeg := $B800;
End;

{sauvegarde l'‚cran dans un buffer}
Procedure Ecran.Sauve( SPtr : VPtr );
Var ligne,
    colonne : byte;
Begin
  For ligne:=1 To 25 Do
    For colonne:=1 To 80 Do
      SPtr^[ligne, colonne] := VioPtr^[ligne, colonne];
End;

{restaure l'‚cran}
Procedure Ecran.Restaure ( BPtr : VPtr );
Var ligne,
    colonne : byte;
Begin
  For ligne:=1 To 25 Do
    For colonne:=1 To 80 Do
      VioPtr^[ligne, colonne] := BPtr^[ligne, colonne];
End;

{‚criture directement en m‚moire vid‚o d'une chaine de caractŠres}
Procedure Ecran.DPrint( Colonne, Ligne, Couleur : byte; StrOut : TextTyp);
Var PAGE_OFS : Word Absolute $0040:$004E;
    Offset   : Word;
    i, j     : Byte;
    Attribut : Word;
Begin
  Offset := Ligne * 160 + Colonne * 2 + PAGE_OFS;
  I := length( StrOut );
  For j:=1 To i Do
    Begin
      memw[VSeg:Offset] := Attribut or ord( StrOut[j] );
      Offset := Offset + 2;
    End;
End;

{lit l'attribut vid‚o et le caractŠre … la position du curseur}
Procedure Ecran.LireCarAttr (Var C,A : Char);
Var regs : registers;
Begin
     regs.ah:=$08;
     regs.bh:=PageEcran;
     intr($10,regs);
     C:=Char(regs.al);
     A:=Char(regs.ah);
     End;

{dessine un cadre simple}
Procedure Ecran.CadreSimple(X1,Y1,X2,Y2,A : Byte);
Var I     : Integer;
    SAttr : Byte;
Begin
     SAttr:=TextAttr;
     TextAttr:=A;
     Gotoxy(X1,Y1); Write(SCAD_HG);
     While WhereX < X2 Do Write(SCAD_HO);
     Write(SCAD_HD);
     For I:=1 To (Y2-Y1)-1 Do
     Begin
          Gotoxy(X1,Y1+I); Write(SCAD_VE);
          Gotoxy(X2,Y1+I); Write(SCAD_VE);
          End;
     Gotoxy(X1,Y2); Write(SCAD_BG);
     While WhereX < X2 Do Write(SCAD_HO);
     Write(SCAD_BD);
     TextAttr:=SAttr;
     End;

{dessine un cadre double}
Procedure Ecran.CadreDouble(X1,Y1,X2,Y2,A : Byte);
Var I     : Integer;
    SAttr : Byte;
Begin
     SAttr:=TextAttr;
     TextAttr:=A;
     Gotoxy(X1,Y1); Write(DCAD_HG);
     While WhereX < X2 Do Write(DCAD_HO);
     Write(DCAD_HD);
     For I:=1 To (Y2-Y1)-1 Do
     Begin
          Gotoxy(X1,Y1+I); Write(DCAD_VE);
          Gotoxy(X2,Y1+I); Write(DCAD_VE);
          End;
     Gotoxy(X1,Y2); Write(DCAD_BG);
     While WhereX < X2 Do Write(DCAD_HO);
     Write(DCAD_BD);
     TextAttr:=SAttr;
     End;

{sauvegarde une zone de l'‚cran pour pouvoir installer une fenˆtre}
Function Ecran.SauveZone (X1,Y1,X2,Y2 : Byte) : PtrArrayChar;
Var TX,TY : Integer; {tailles horizontales et verticales  de la zone … sauver}
    Temp  : PtrArrayChar; {pointeur temporaire renvoy‚ par la fonction}
    C,A   : Char;     {caractŠre et attribut lus … l'‚cran}
    Count : Integer;  {compteur pour le buffer de caractŠres}
    II,JJ : Integer;
Begin
     SauveZone:=Nil;
     If X2 <= X1 Then Exit;
     If Y2 <= Y1 Then Exit;
     TX:=X2-X1;
     TY:=Y2-Y1;
     GetMem(Temp,TX*TY*2); {r‚servation de la m‚moire n‚c‚ssaire}
     Count:=1;             {initialisation du compteur}
     For II:=0 To TY-1 Do
     Begin
          For JJ:=0 To TX-1 Do
          Begin
               Gotoxy(X1+JJ,Y1+II);
               LireCarAttr(C,A);
               Temp^[ count ] := C; {sauvegarde du caractŠre}
               Inc( count );       {sauvegarde de l'attribut}
               Temp^[ count ] := A;
               Inc( count ) ;      {caractŠre suivant}
          End;
     End;
  SauveZone:=Temp;
  End;

{restaure une portion d'‚cran sauvegard‚e par Ecran.SauveZone}

Procedure Ecran.RestaureZone (X1,Y1,X2,Y2 : Byte; Var Temp : PtrArrayChar);
Var TX,TY : Integer;{tailles horizontales et verticales  de la zone … sauver}
    Count : Integer;{compteur pour le buffer de caractŠres}
    II,JJ : Integer;
    SAttr : Byte;
Begin
     If X2 <= X1 Then Exit;
     If Y2 <= Y1 Then Exit;
     TX:=X2-X1;                           
     TY:=Y2-Y1;
     Count:=1;             {initialisation du compteur}
     SAttr:=TextAttr;
     For II:=0 To TY-1 Do
     Begin
          Gotoxy(X1,Y1+II);
          For JJ:=0 To TX-1 Do
          Begin
               TextAttr:=Byte(Temp^[ count + 1 ]);
               Inc( count );
               Write(Temp^[ count - 1 ]);
               Inc( count ) ;      {caractŠre suivant}
          End;
     End;
  TextAttr:=SAttr;
  Freemem(Temp,TX*TY*2);
  End;

{sauvegarde les coordonn‚es de la fenˆtre active}

Procedure Ecran.SauveFenetre(Var W : WindowRec);
Begin
     W.X1:=Lo(WindMin);
     W.Y1:=Hi(WindMin);
     W.X2:=Lo(WindMax);
     W.Y2:=Hi(WindMax);
     End;

{restaure une fenˆtre sauvegard‚e dans un registre de type WindowRec}

Procedure Ecran.RestaureFenetre(Var W : WindowRec);
Begin
     With W Do Window(X1+1,Y1+1,X2+1,Y2+1);
     End;

{sauvegarde d'une zone occup‚e par un bouton}
Procedure Bouton.SauveZoneBouton(XX,YY,Taille : Byte);
Var II : ShortInt;
    ST : String;
    CC,
    AA : Char;
Begin
     Gotoxy(PX,PY);
     ST:='';
     For II:=0 To Taille-1 Do
     Begin
          Gotoxy(PX+II,PY);
          LireCarAttr(CC,AA);
          ST:=ST+CC+AA;
          End;
     Getmem(S,Length(St)+1);
     S^:=St;
     End;

{cr‚ation d'un nouveau bouton}
Constructor Bouton.Init(XX,YY,HHPOS: Byte;
                        Col : ColorRec;
                        TT  : String; PProc : Lancement);
Begin
     Initial:=Ord(TT[1]) * Ord(TT[2]) xor Ord(TT[0]);
     Stat:=Indefini;
     Interd:=False;{autorisation d'utilisation d'un bouton}
     Selec:=False; {‚tat de s‚lection d'un bouton}
     HAVS:=Col.HHAVS;  {couleurs d'un bouton s‚lectionn‚}
     AVS:=Col.AAVS;
     HAVX:=Col.HHAVX;  {couleurs d'un bouton interdit}
     AVX:=Col.AAVX;
     PX:=XX;
     PY:=YY;
     AVN:=Col.AAVN;
     AVI:=Col.AAVI;
     HAVN:=Col.HHAVN;
     HAVI:=Col.HHAVI;
     HPOS:=HHPOS;
     GetMem(T,Length(TT)+1);
     T^:=TT;
     @Proc:=@PProc;
     SauveZoneBouton(XX,YY,Length(TT));
     End;

{renvoie le statut d'un bouton : norm, invers, indefini}
Function  Bouton.StatBouton : Statut;
Begin
     StatBouton:=Stat;
     End;

{s‚lectionne un bouton}

Procedure Bouton.MontreSelect;
Var SAttr : Byte;
Begin
     Stat:=Norm;
     SAttr:=TextAttr;
     Gotoxy(PX,PY);
     TextAttr:=AVS;
     Write(T^);
     TextAttr:=HAVS;
     Gotoxy(PX+HPOS,PY);
     Write(T^[HPos+1]);
     TextAttr:=SAttr;
     End;

{s‚lectionne un bouton}

Procedure Bouton.MontreInterd;  {affiche un bouton interdit}
Var SAttr : Byte;
Begin
     Stat:=Norm;
     SAttr:=TextAttr;
     Gotoxy(PX,PY);
     TextAttr:=AVX;
     Write(T^);
     TextAttr:=HAVX;
     Gotoxy(PX+HPOS,PY);
     Write(T^[HPos+1]);
     TextAttr:=SAttr;
     End;

Procedure Bouton.MontreInterdI; {affiche un bouton interdit en inverse}
Var SAttr : Byte;
Begin
     Stat:=Norm;
     SAttr:=TextAttr;
     Gotoxy(PX,PY);
     TextAttr:=HAVX;
     Write(T^);
     TextAttr:=AVX;
     Gotoxy(PX+HPOS,PY);
     Write(T^[HPos+1]);
     TextAttr:=SAttr;
     End;

Procedure Bouton.MontreSelectI;
Var SAttr : Byte;
Begin
     Stat:=Norm;
     SAttr:=TextAttr;
     Gotoxy(PX,PY);
     TextAttr:=HAVS;
     Write(T^);
     TextAttr:=AVS;
     Gotoxy(PX+HPOS,PY);
     Write(T^[HPos+1]);
     TextAttr:=SAttr;
     End;

Procedure Bouton.Select;
Begin
     Selec:=True;
     End;

{d‚s‚lectionne un bouton}

Procedure Bouton.DeSelect;
Begin
     Selec:=False;
     End;

{interdit l'utilisation d'un bouton}

Procedure Bouton.Interdit;
Begin
     Interd:=True;
     End;

{autorise l'utilisation d'un bouton}

Procedure Bouton.Autorise;
Begin
     Interd:=False;
     End;

{calcule la signature d'un bouton pour v‚rification avant affichage}

Function Bouton.Signature : Word;
Begin
     Signature:=Ord(T^[1]) * Ord(T^[2]) xor Ord(T^[0]);
     End;

{affiche un bouton dans ses couleurs normales}

Procedure Bouton.MontreNormal;
Var SAttr : Byte;
Begin
     If Initial <> Signature Then Exit;
     If Interd Then Begin MontreInterd; Exit; End;
     If Selec  Then Begin MontreSelect; Exit; End;
     Stat:=Norm;
     SAttr:=TextAttr;
     Gotoxy(PX,PY);
     TextAttr:=AVN;
     Write(T^);
     TextAttr:=HAVN;
     Gotoxy(PX+HPOS,PY);
     Write(T^[HPos+1]);
     TextAttr:=SAttr;
     End;

{affiche un bouton dans ses couleurs inverses}
Procedure  Bouton.MontreInverse;
Var SAttr : Byte;
Begin
     If Initial <> Signature Then Exit;
     If Interd Then Begin MontreInterdI; Exit; End;
     If Selec  Then Begin MontreSelectI; Exit; End;
     Stat:=Invers;
     SAttr:=TextAttr;
     Gotoxy(PX,PY);
     TextAttr:=AVI;
     Write(T^);
     TextAttr:=HAVI;
     Gotoxy(PX+HPOS,PY);
     Write(T^[HPos+1]);
     TextAttr:=SAttr;
     End;

{efface un bouton et restaure la portion d'‚cran qu'il occupait}

Procedure Bouton.Cache;
Var SAttr : Byte;
    I     : Byte;
    Offst : Word;
Begin
     If Initial <> Signature Then Exit;
     Sattr:=TextAttr;
     Gotoxy(PX,PY);
     For I:=1 To Length(S^) Do
     Begin
          TextAttr:=Byte(S^[i+1]);
          Write(S^[i]);
          Inc(I,1);
          End;
     TextAttr:=SAttr;
     End;

{libŠre la m‚moire occup‚e par un bouton}
Destructor Bouton.Done;
Begin
     Freemem(T,Length(T^)+1); {lib‚ration de la m‚moire allou‚e pour le bouton}
     Freemem(S,Length(S^)+1);   {lib‚ration de la m‚moire allou‚e pour l'‚cran}
     T:=NIL; S:=NIL;
     End;

{initialise la structure d'un menu}
Constructor Menu.Init(Sens : Orientation; Princ : Boolean);
Begin
     Aff:=False;  {le menu n'est pas encore affich‚}
     ListB.Deb:=Nil; {la liste des boutons est … NIL}
     ListB.Fin:=Nil;
     Orient:=Sens;   {stocke l'orientation du menu}
     Principal:=Princ; {est-ce que c'est le menu principal}
                       {ou un menu dont on ne d‚sire par sortir par}
                       {la touche ESC}
     End;

Function  Menu.AjBouton (XX,YY,HHPOS : Byte;
                             Col : ColorRec;
                             TT : String;
                             PProc : Lancement) : PtrBouton;
Const Temp : PtrCellBouton = NIL;
Begin
     New(Temp);
     New(Temp^.Bou,Init(XX,YY,HHPOS,Col,TT,PProc));
     If (ListB.Deb = Nil) Then
        Begin
            ListB.Deb:=Temp;
            ListB.Deb^.Prev:=Nil;
            ListB.Deb^.Next:=Nil;
            ListB.Fin:=ListB.Deb;
            Actuel:=Temp;
        End
       Else
       Begin
            ListB.Fin^.Next:=Temp;   {ajoute le bouton}
            Temp^.Prev:=ListB.Fin;
            Temp^.Next:=Nil;
            ListB.Fin:=ListB.Fin^.Next;
            ListB.Fin^.Next:=Nil;
       End;
     AjBouton:=Temp^.Bou; {renvoie l'adresse du bouton pour exploitation}
                              {ult‚rieure par les m‚thodes utilisateurs}
     End;

{cache tous les boutons d'un menu}

Procedure Menu.CacheTout;
Const Liste : PtrCellBouton = NIL;
Begin
     Liste:=ListB.Deb;
     While Liste <> Nil Do
     Begin
          If Liste<> Nil Then Liste^.Bou^.Cache;
          Liste:=Liste^.Next;
          End;
     Aff:=False; {le menu n'est plus affich‚}
     End;

{restauration de l'ancien curseur}
{restauration de l'‚cran d'avant le lancement}

Destructor Menu.Done;
Const ListeBout : PtrCellBouton = NIL;
Begin
     CacheTout;
     ListeBout:=ListB.Deb;
     While ListeBout <> Nil Do
     Begin
          Dispose(ListeBout^.Bou,Done);

          {lib‚rer la cellule associ‚e au bouton}
          ListeBout:=ListeBout^.Next; {bouton suivant}
          End;
     End;

{… gauche}

Procedure Menu.Droite;
Begin
     If Not Aff Then Affiche;
     If Orient = Vertical Then
     Begin
          If Not Principal Then
          Sortie:=True; {efface le menu courant si ce}
          Exit;         {n'est pas le menu principal}
          End; {retour au menu pr‚c‚dent}
     Actuel^.Bou^.MontreNormal;                       {montre normal}
     If Actuel^.Next = Nil Then Actuel:=ListB.Deb     {passe au suivant}
                           Else Actuel:=Actuel^.Next; {… droite}
     Actuel^.Bou^.MontreInverse;                      {montre inverse}
     End;

{… droite}

Procedure Menu.Gauche;
Begin
     If Not Aff Then Affiche;
     If Orient = Vertical Then
     Begin
          If Not Principal Then
               Sortie:=True; {efface le menu courant si ce}
          Exit;                            {n'est pas le menu principal}
          End;
     Actuel^.Bou^.MontreNormal;                       {montre normal}
     If Actuel = ListB.Deb Then Actuel:=ListB.Fin     {passe au suivant}
                           Else Actuel:=Actuel^.Prev; {… gauche}
     Actuel^.Bou^.MontreInverse;                      {montre inverse}
     End;

{monte}

Procedure Menu.Monter;
Begin
     If Not Aff Then Affiche;
     If Orient = Horizontal Then
     Begin
          If Not Principal Then
               Sortie:=True;
          Exit; {retour au menu pr‚c‚dent}  {si ce n'est pas le menu principal}
          End;
     Actuel^.Bou^.MontreNormal;                       {montre normal}
     If Actuel = ListB.Deb Then Actuel:=ListB.Fin     {passe au suivant}
                           Else Actuel:=Actuel^.Prev; {… gauche}
     Actuel^.Bou^.MontreInverse;                      {montre inverse}
     End;

{descend}

Procedure Menu.Descendre;
Begin
     If Not Aff Then Affiche;
     If Orient = Horizontal Then
     Begin
          If Not Principal Then
               Sortie:=True; {efface le menu courant si ce }
          Exit; {retour au menu pr‚c‚dent} {n'est pas le menu principal}
          End;
     Actuel^.Bou^.MontreNormal;                             {montre normal}
     If Actuel^.Next = Nil Then Actuel:=ListB.Deb           {passe au suivant}
                           Else Actuel:=Actuel^.Next;       {… droite}
     Actuel^.Bou^.MontreInverse;                            {montre inverse}
     End;

Procedure Menu.Affiche;
Const Liste : PtrCellBouton = NIL;
Begin
     Liste:=ListB.Deb;
     While Liste <> Nil Do
     Begin
          Liste^.Bou^.MontreNormal;
          Liste:=Liste^.Next;
          End;
     ListB.Deb^.Bou^.MontreInverse;
     Actuel:=ListB.Deb;
     Aff:=True; {le menu est affich‚}
     End;

{gestion des caractŠres sp‚ciaux du clavier}
Procedure Menu.Specials;
Begin
     Ch:=Readkey;
     Case Ord(Ch) of
          80 : Descendre;
          72 : Monter;
          75 : Gauche;
          77 : Droite;
          End;
     End;

Function  Menu.HotKey : Boolean;
Const LBout : PtrCellBouton = NIL;
Begin
     Hotkey:=False;
     LBout:=ListB.Deb;
     While LBout <> Nil Do
     Begin
          If Upcase(LBout^.Bou^.T^[ LBout^.Bou^.Hpos+1 ]) = Upcase(Ch) Then
             Begin
                  Actuel^.Bou^.MontreNormal; {le bouton que l'on quitte doit}
                                             {ˆtre affich‚ normalement}
                  Actuel:=LBout; {le bouton destination est le nouveau bouton}
                                 {courant}
                  LBout^.Bou^.MontreInverse; {inverse le bouton appell‚}
                  LBout^.Bou^.Proc;
                  HotKey:=True;
                  Exit;
             End;
          LBout:=LBout^.Next;
          End;
     End;

Procedure Menu.Choisir_1;
Begin
     Sortie:=False;
     Ch:=Readkey;  {l'instruction case of n'est pas utilis‚e car elle}
                   {perturbe le fonctionnement de Choisir_1}
     If Hotkey And Not Principal Then Exit;
     If Ch = #0  Then Specials;
     If Ch = #13 Then
        Begin
          Actuel^.Bou^.Proc;
        End;
     If Ch = #27 Then If Not Principal Then
                      Begin
                           CacheTout;
                           Exit;
                      End;
     If Not Sortie Then Choisir_1;
     End;

{choisir une des options}

Procedure Menu.Choisir;
Begin
     Affiche;
     Choisir_1;
     Sortie:=False; {la sortie n'est plus valable pour les menus suivants}
     If Actuel <> ListB.Fin Then MontreNormal
       Else
         Begin
              ListB.Fin:=ListB.Deb;
              MontreNormal;
         End;
     End;

{initialise le driver de la souris}

Constructor Souris.Init;
Var regs : registers;
Begin
     regs.ax:=0;
     intr($33,regs);
     if regs.ax = 0 Then Sour:=False;
     End;

{montre le curseur de la souris}

Procedure Souris.Montre;
Var regs : registers;
Begin
     If Not Sour Then Exit; {souris non initialis‚e}
     regs.ax:=$0001;
     intr($33,regs);
     End;

{cache le curseur de la souris}

Procedure Souris.Cache;
var Regs : registers;
Begin
     If Not Sour Then Exit; {souris non initialis‚e}
     regs.ax:=$0002;
     intr($33,regs);
     End;

{enlŠve l'objet souris de la table des m‚thodes virtuelles}
{et d‚sactive le driver associ‚ … la souris}
Destructor Souris.Done;
Var regs : registers;
Begin
     If Not Sour Then Exit; {souris non initialis‚e}
     regs.ax:=$001f;
     intr($33,regs);
     End;

{initialise une application}

Constructor Application.Init (NNom : String; HSouris : Boolean);
Var Regs : Registers;
Begin
     Sour:=HSouris;
     Nom:=NNom;
     PassWord:=False;
     ListM.Deb:=Nil; {initialise la liste des menus … NIL}
     ListM.Fin:=Nil;
     If Sour Then
        Begin
             Souris.Init;
             Souris.Montre;
        End;
     End;

Procedure Application.AjMenu(Var M : PtrMenu);
Const Temp : PtrCellMenu = NIL;
Begin
     New(Temp);       {cr‚ation d'une cellule non li‚e}
     Temp^.Men:=M;    {stockage de l'adresse du menu}
     Temp^.Next:=Nil; {cette cellule repr‚sente la fin de la liste obtenue}
                      {… la fin de cette routine}

     {cr‚ation du lien entre la cellule temp et la liste des menus}

     If ListM.Deb = Nil Then   {cr‚ation de la premiŠre cellule}
        Begin                  {c…d le premier menu install‚}
             ListM.Deb:=Temp;
             ListM.Fin:=ListM.Deb;
        End
     Else
        Begin
             Temp^.Prev:=ListM.Fin; {cr‚ation d'une nouvelle cellule}
             ListM.Fin^.Next:=Temp; {li‚e en fin de liste}
             ListM.Fin:=ListM.Fin^.Next;
        End;
     End;

Function   Application.Crypte (St : String) : String;
Var I,J : ShortInt;
Begin
     J:=0;
     While Length(St)<8 Do St:=St+' ';
     For I:=1 To 8 Do
     Begin
          Inc(J);
          If J>Length(Sign) Then J:=1;
          St[i]:=Chr(Ord(St[i]) xor Ord(Sign[j]));
          End;
     Crypte:=St;
     End;

Function ToHex8 (X : LongInt) : String;
Const Thex :String = '0123456789ABCDEF';
Var   Fort,
      Faible : Byte;
Begin
     Fort:=X div 16;
     Faible:=X mod 16;
     ToHex8:=THex[ Fort +1 ]+THex [ Faible +1 ];
     End;

Function ToHex16 (X : LongInt) : String;
Var   Fort,
      Faible : Byte;
Begin
     Fort:=X div 256;
     Faible:=X mod 256;
     ToHex16:=ToHex8(Fort)+ToHex8(Faible);
     End;

Function ToHex32 (X : LongInt) : String;
Var   Fort,
      Faible : Word;
Begin
     Fort:=X div 65536;
     Faible:=X mod 65536;
     ToHex32:=ToHex16(Fort)+ToHex16(Faible);
     End;

{extrait le 15 Šme bit d'un mot}

Function Extrait (Mot : Word) : Word;
   Inline($58/$25/$00/$80/$B1/$0F/$D3/$E8);

  {58           POP AX}
  {25 00 80     AND AX,7FFF}
  {B1 0F        MOV CL,0Fh}
  {D3 E8        SHR AX,CL}

{calcul du CRC d'un fichier}

Function   Application.CalcCrc (Var Fname : String; Var Err : Boolean): Word;
Var Buf     : BufferPtr;  {instanciation du buffer}
    Lus     : Word;       {blockread : nombre d'octets lus = taille buffer}
    POLY,
    PremierBit,
    SecondBit,
    Res,
    I       : Word;
    J       : ShortInt;
    F       : File; {variable n‚c‚ssaire pour le traitement du fichier}
Begin
     Err:=False;
     Assign(F,Fname);
     {$i-}
     Reset(F,2); {lecture de mots et non d'octets}
     If IOResult<>0 Then
        Begin
             CalcCRC:=$FFFF; {le fichier n'a pas ‚t‚ ouvert}
             Err:=True;
             Exit;
        End;
     {$i+}
     New(Buf);
     POLY:=$FBCD;
     While Not Eof(F) Do
     Begin
          BlockRead(F,Buf^,32000,Lus);
            For I:=1 To Lus Do
             Begin
                  For J:=1 To 15 Do
                  Begin
                     PremierBit:=Extrait(Buf^[i]);
                     Buf^[i]:=Buf^[i] shl 1;
                     SecondBit:=Extrait(POLY);
                     Res:=PremierBit XOR SecondBit;
                     POLY:=POLY shl 1;
                     Inc(POLY,Res);
                  End;
             End;
     End;
     Dispose(Buf);
     Close(F);
     CalcCRC:=POLY; {r‚sultat final du CRC}
     End;

{change de bureau actif}

Function   Application.ChangeBureau(Var Fname : String) : Boolean;
Begin
     Bureau:=Fname;
     ChangeBureau:=SauveBureau(Fname);
     End;

Procedure  Application.Scan (Var Pos : Longint);
Var   Pr : String[31];
Begin
     Ch:=#0;
     While (Not Eof (FProtect)) and (Ch<>'$') Do
     Begin
          Read(Fprotect,Ch);
          End;
     Pos:=FilePos(FProtect);
     Pr:='';
     For I:=1 To 32 Do
     Begin
          Read(FProtect,Ch);
          Pr:=Pr+Ch;
          End;
     If Pr=A1+A3+A2 Then Begin Trouve:=True; Exit; End;
     If Not Trouve Then Scan (Pos); {continue la recherche}
     End;

{cherche la chaine de protection}

Procedure  Application.ChercheProt;
Var Posit : Longint;
Begin
     Trouve:=False;
     Posit:=16000; {taille minimale du programme}
     Seek(FProtect,Posit);
     Scan(Posit); {recherche la chaine bureau}
     Seek(FProtect,DebutFichier);
     Seek(FProtect,Posit+LenProtect);
     End;

Procedure  Application.GoodBeep;
Var I : Integer;
Begin
     Sound(2000);
     For I:=2000 Downto 20 Do Sound(I);
     NoSound;
     End;

{v‚rifie le mot de passe du systŠme}

Function   Application.VerifieCode (Var C : String) : Boolean;
Var I,J : ShortInt;
    Pss : String[8];
Begin
     If Not Password Then VerifieCode:=True; {pas de code dans le bureau}
     Pss:=Crypte(Pass); {d‚crypte le code}
     While Pss[ Length(Pss) ] = #0  Do Delete (Pss,Length(Pss),1);
     While Pss[ Length(Pss) ] = ' ' Do Delete (Pss,Length(Pss),1);
     If C = Pss Then VerifieCode:=True Else VerifieCode:=False;
     End;

{ajoute un mot de passe au systŠme}

Function  Application.NouveauCode(AncienC, Nouveau : String) : Boolean;
Var I,J : ShortInt;
Begin
     NouveauCode:=False;
     Nouveau:=Crypte(Nouveau);
     If Not PassWord Then   {pas encore de code}
     Begin                  {on peut installer le premier code}
       Pass:=Nouveau;
       PassWord:=True;
       NouveauCode:=True;
       Exit;
     End
       Else  {il y a d‚j… un code d'application}
          AncienC:=Crypte(AncienC);
          While Pass [ Length (Pass) ] = #0 Do Delete (Pass,Length(Pass),1);
          If Pass = AncienC Then {l'ancien mot de passe pr‚cis‚ est le bon}
            Begin
                 NouveauCode:=True;
                 Pass:=Nouveau;
                 PassWord:=True;
            End;
     End;

{charge le bureau en m‚moire vive}

Function   Application.ChargeBureau : Boolean;
Begin
     Assign (FProtect,Nom+'.exe');
     Reset(FProtect);

     ChercheProt;

     {lecture du mot de passe}
     For I:=1 To 8 Do Read(FProtect,Pass[i]);

     {lecture du flag de mot de passe}
     Read(FProtect,Ch);
     PassWord:=Boolean(Ch);  {transtypage char -> boolean}

     {lecture du nom de l'application}
     For I:=1 To 8 Do Read(FProtect,Nom[i]);
     Nom:=Crypte(Nom);
     While (Nom[Length(Nom)]=' ') Do Delete (Nom,Length(Nom),1);

     {lecture du nom du bureau}
     For I:=1 To 8 Do Read(FProtect,Bureau[i]);
     Bureau:=Crypte(Bureau);
     While (Bureau[Length(Bureau)]=' ') Do Delete (Bureau,Length(Bureau),1);
     ChargeBureau:=True;
     GoodBeep;
     End;

{sauvegarde le bureau de l'application}

Function   Application.SauveBureau(Fname : String) : Boolean;
Begin
     SauveBureau:=True;
     Assign (FProtect,Fname+'.exe');
     {$i-}
     Reset(FProtect);
     If IoResult <> 0 Then
         Begin
              SauveBureau:=False;
              Exit;
         End;

     ChercheProt;

     {‚criture du mot de passe}
     For I:=1 To 8 Do Write(FProtect,Pass[i]);

     {‚criture du flag de mot de passe}
     Write(FProtect,Char(PassWord));

     {‚criture du nom de l'application}
     While Length(Fname)<8 Do Fname:=Fname+' ';
     Fname:=Crypte(Fname);
     For I:=1 To 8 Do Write(FProtect,Fname[i]);

     {‚criture du nom du bureau}
     While Length(Bureau)<8 Do Bureau:=Bureau+' ';
     Bureau:=Crypte(Bureau);
     For I:=1 To 8 Do Write(FProtect,Bureau[i]);

     Close(FProtect);
     GoodBeep;
     End;


Destructor Application.Done;
Const ListeMen : PtrCellMenu = NIL;
Begin
     ListeMen:=ListM.Deb;
     While ListeMen <> Nil Do
     Begin
          Dispose(ListeMen^.Men,Done); {met fin … l'activit‚ du menu en cours de}
                                    {traitement}
          ListeMen:=ListeMen^.Next;       {prochain menu … lib‚rer}
     End;
  Souris.Cache;
  Souris.Done;
  End;

Procedure ClearScreen;
Begin
     TextColor(White); TextBackGround(Black); Clrscr;
     Gotoxy(1,1); TextBackGround(White); ClrEol; TextBackGround(White);
     End;

Procedure GOuEx;
Begin
     OuEx^.Selec:=Not(OuEx^.Selec);
     Meth^.Affiche;
     End;

Procedure GNoAl;
Begin
     Nale^.Selec:=Not(Nale^.Selec);
     Nale^.MontreInverse;
     End;

Procedure GRotatC;
Begin
     RoCr^.Selec:=Not(RoCr^.Selec);
     RoCr^.MontreInverse;
     End;

Procedure GRotatD;
Begin
     RoDe^.Selec:=Not(RoDe^.Selec);
     RoDe^.MontreInverse;
     End;

Procedure GPerm;
Begin
     Perm^.Selec:=Not(Perm^.Selec);
     Perm^.MontreInverse;
     End;

Procedure GCode;
Var Zone : PtrArrayChar;
    Code : String;
Begin
     Zone:=Ec.SauveZone(1,2,80,5);
     Ec.CadreSimple(1,2,79,4,10);
     Gotoxy (3,3);
     Write ('CODE : '); Readln(Code);
     Ec.RestaureZone(1,2,80,5,Zone);
     End;

Procedure GCConf;
Begin
     If Not Enc.ChargeBureau Then Write(#7);
     End;

Procedure GSConf;
Begin
     If Not Enc.SauveBureau ('e:\menus') Then Write(#7);
     End;

Procedure GMeth;
Begin
     Zone:=Meth^.SauveZone(1,2,24,9);
     Meth^.CadreSimple(1,2,23,8,LightGray*16+Black);
     Meth^.Choisir;
     Meth^.CacheTout;
     Meth^.RestaureZone(1,2,24,9,Zone);
     End;

Procedure GOpt;
Begin
     Zone:=Opt^.SauveZone(29,2,62,9);
     Opt^.CadreSimple(29,2,61,8,LightGray*16+Black);
     Opt^.Choisir;
     Opt^.CacheTout;
     Opt^.RestaureZone(29,2,62,9,Zone);
     End;

Procedure GSouris;
Begin
     Sour^.Selec:=Not(Sour^.Selec);
     Sour^.MontreInverse;
     End;

Procedure GCoul;
Begin
     Couleur^.Selec:=Not(Couleur^.Selec);
     Couleur^.MontreInverse;
     End;

Procedure GEnc;
Begin
     End;

Procedure GPass;
Var Anc   : String;
    Nou   : String;
    SAttr : Byte;
Begin
     SAttr:=TextAttr;
     Opt^.SauveFenetre(Win);
     Zone1:=Opt^.SauveZone(33,06,66,10);
     Window(33,06,65,9);
     Clrscr;
     Opt^.CadreSimple(1,1,32,4,Black + 16 * LightGray);
     TextBackGround(Blue); TextColor(Yellow);
     If Enc.PassWord Then
     Begin
         Gotoxy(2,2); Write(' ANCIEN CODE : ');
         Readln(Anc);
         End;
     Gotoxy(2,2); Write (' NOUVEAU CODE :             ');
     Gotoxy(17,2); Readln(Nou);
     If Enc.PassWord Then
        If Enc.NouveauCode(Anc,Nou) Then Pass:=Enc.Crypte(Nou)
           Else Write(#7);
     If Not Enc.PassWord Then
        Begin
          Pass:=Enc.Crypte(Nou);
          Enc.PassWord:=True;
        End;
     Opt^.RestaureFenetre(Win);
     Opt^.RestaureZone(33,06,66,10,Zone1);
     TextAttr:=Sattr;
     End;

Procedure GQuitte;
Begin
     Enc.Done;
     Gotoxy(1,1);
     TextColor(Black); Writeln ('Encrypt Version 2.0 - Pascal Munerot');
     Release(Memory);
     Halt(0);
     End;

Begin

 Mark(Memory); {m‚morise le pointeur m‚moire libre}

 Window(1,1,80,43);
 ClearScreen;
 Ec.DetecteEcran;

 {initialisations des couleurs des boutons de cette application}

 Coul.AAVN:=NC;  Coul.HHAVN:=NHC;
 Coul.AAVI:=IC;  Coul.HHAVI:=IHC;
 Coul.AAVS:=NS;  Coul.HHAVS:=NSI;
 Coul.AAVX:=NX;  Coul.HHAVX:=NXI;

 Enc.Init ('e:\menus',TRUE); {initialisation de l'application}

 {r‚servation de m‚moire et initialisation : menu principal}

 New(Princ,Init(Horizontal,True));
 Enc.AjMenu(Princ);

 {r‚servation de m‚moire et initialisation : menu m‚thodes}

 New(Meth,Init(Vertical,False));
 Enc.AjMenu(Meth);

 {r‚servation de m‚moire et initialisation : menu options}

 New(Opt,Init(Vertical,False));
 Enc.AjMenu(Opt);

    SOUR:=Opt^.AjBouton(30,3,01,Coul,' Souris                        ',GSouris);
 COULEUR:=Opt^.AjBouton(30,4,02,Coul,' Couleurs                      ',GCoul);
   PASSW:=Opt^.AjBouton(30,5,01,Coul,' Mot de passe de l''application ',GPass);
   CHARG:=Opt^.AjBouton(30,6,01,Coul,' Charge la configuration       ',GCConf);
    SAUV:=Opt^.AjBouton(30,7,02,Coul,' Sauve la configuration        ',GSConf);

   OUEX:=Meth^.AjBouton(2,3,01,Coul,' OU exclusif         ', GOuEx);
   NALE:=Meth^.AjBouton(2,4,01,Coul,' Nombres al‚atoires  ', GNoAl);
   ROCR:=Meth^.AjBouton(2,5,10,Coul,' Rotation cryptage   ', GRotatC);
   RODE:=Meth^.AjBouton(2,6,10,Coul,' Rotation d‚cryptage ', GRotatD);
   PERM:=Meth^.AjBouton(2,7,01,Coul,' Permutations        ', GPerm);

 CODE:=    Princ^.AjBouton(02,1,1,Coul,' Code '     , Gcode);
 METHODS:= Princ^.AjBouton(15,1,1,Coul,' M‚thodes ' , GMeth);
 OPTION:=  Princ^.AjBouton(28,1,1,Coul,' Options '  , GOpt);
 ENCR:=    Princ^.AjBouton(45,1,1,Coul,' Encrypter ', GEnc);
 QUIT:=    Princ^.AjBouton(60,1,1,Coul,' Quitter '  , Gquitte);

 If Not Enc.ChargeBureau Then
 Begin
      Writeln ('La recherche du bureau n''a pas aboutie');
      Halt(1);
      End;

 If Enc.Password Then
 Begin
      Zone3:=Ec.SauveZone(10,10,60,14);
      TextColor(Yellow);
      TextBackGround(Blue);
      Gotoxy(11,11);
      Write('mot de passe, application ',enc.nom,' : ');
      Readln(mdp);
      If Not Enc.VerifieCode (mdp) Then
                                   Begin Ec.RestaureZone(10,10,60,14,Zone3);
                                         Enc.Done; Halt(1);
                                   End;
      Ec.RestaureZone(10,10,60,14,Zone3);
      End;

 OuEx^.Interd:=False;
 Princ^.Choisir;

 End.

