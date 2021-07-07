Unit Tools;

Interface

Uses Crt,Dos;

Const
     Hex : Array [0..15] of Char = ('0','1','2','3','4','5','6','7','8','9',
                                 'A','B','C','D','E','F');
     Ch  : Char = #0;
  Sortie : Boolean = False;

Type
     Calculator = Object       {TERMINE}
     M    : Array [1..26] of Extended;
     Answer  : Extended;        {registre de calcul courant}
     Code : Integer;     {code d'erreur ‚ventuel pour val}
     Fst  : Extended;        {Premier argument}
     Sec  : Extended;        {Seconde argument}
     Line : String;      {ligne}
     Procedure DoIt;     {mise en fonction de la calculatrice}
     Procedure Spec;     {Touche sp‚ciale (raccourci clavier)}
     Procedure Screen;   {menu principal du module calculatrice}
     Procedure GetOpt;   {lecture de l'op‚ration … effectuer}
     Procedure Display;  {affichage du r‚sultat de l'op‚ration courante}
     Procedure Add;
     Procedure Substract;
     Procedure Divide;
     Procedure Multiply;
     Procedure Opposite;
     Procedure Absol;
     Procedure Square;
     Procedure Root;
     Procedure Fln;
     Procedure Log;
     Procedure Puissance;
     Procedure Entire;
     Procedure Invert;
     Procedure Tangent;
     Procedure Cosine;
     Procedure Sinus;
     Procedure Exponent;
     Procedure Dixx;
     Procedure First;
     Procedure Second;
     Procedure PutInMemory;
     Procedure GetInMemory;
     Procedure Err;
     Procedure Title (A:String);
     End;

     Banner = Object    {TERMINE}
     Procedure BannerLN (A: String; EM,FM,EN,FN: Integer; CL: Boolean);  {OK}
     Procedure Banner   (A: String; EM,FM,EN,FN: Integer; CL: Boolean);  {OK}
     Procedure Blink    (A: String; EM,FM,EN,FN: Integer; CL: Boolean);  {OK}
     Procedure ClearWin (X1,Y1,X2,Y2:Integer);                           {OK}
     Procedure ColorWin (X1,Y1,X2,Y2,COL:Integer);                       {OK}
     Procedure Value    (M1,M2,M3 : String; AT1B,AT1C,AT2B,AT2C:Integer);{OK}
     End;

     RS232 = Object
     Stat : word;
     Function  Init         (N:Word; B:Byte)    : Word; {OK}
     Function  Status       (N:Word)            : Word; {OK}
     Function  Receive      (N:Word)            : Byte; {OK}
     Procedure Emit         (N:Word; B:Byte);           {OK}
     Procedure EmitStr      (N:Word; S:String);         {OK}
     Procedure EmitStrLN    (N:Word; S:String);         {OK}
     Function  ReceiveStr   (N:Word) :String;
     End;

     SimpleRS232 = Object(Rs232)
     Num:Word;
     Procedure Choose(N:Word);                          {OK}
     Function  Init           (B:Byte)    : Word;       {OK}
     Function  Status       : Word;                     {OK}
     Function  Receive      : Byte;
     Procedure Emit           (B:Byte);                 {OK}
     Procedure EmitStr        (S:String);               {OK}
     Procedure EmitStrLN      (S:String);               {OK}
     Function  ReceiveStr   : String;
     End;

     Minitel = Object(RS232)
     Function  InitMin (N:Word) : Word;                 {OK}
     Function  ReceiveStr (N:Word):String;
     Procedure Cls     (N:Word) ;                       {OK}
     Procedure Cursor  (N:Word) ;                       {OK}
     End;

     SimpleMinitel = Object (SimpleRS232)
     Function InitMin:Word;                             {OK}
     Function ReceiveStr:String;
     Procedure Cls;                                     {OK}
     Procedure Cursor;                                  {OK}
     End;

     DataClass = Object
     End;

     Hexa = Object {TERMINE}
     Procedure DispByte(A:Byte);                        {OK}
     Procedure DispWord(A:Word);                        {OK}
     Procedure DispPointer(A,B:Word);                   {OK}
     Function  HexToByte(A:String):Byte;                {OK}
     Function  HexToWord(A1:String):Word;               {OK}
     Function  HexToPointer(A2:String):Pointer;         {OK}
     End;

     Liste = Array [1..10] of String;
     StrClass = Object {TERMINE}
     Function SkipBlanks (A:String):String;             {OK}
     Function UpcaseStr  (A:String):String;             {OK}
     Function UpcaseSubStr (A,B:String):String;         {OK}
     Function LowCaseStr (A:String):String;             {OK}
     Function LowCaseSubStr (A,B:String):String;        {OK}
     Function Right(A:String; N:Integer):String;        {OK}
     Function Left (A:String; N:Integer):String;        {OK}
     Function Flushing(Dest:String; L:Liste):String;    {OK}
     Function FlushingN(Dest:String; L:Liste; N:Integer):String; {OK}
     End;

     DirectStr      = String[8];
     DirectStrPtr   = ^DirectStr;
     DirectStrArea  = Array [1..256] of DirectStrPtr;

     DirectoryClass = Object
     DirInfo : SearchRec;
     Function  SubDirectories(Path:String):Integer;     {OK}
     Function  ExistFile(Path:String):Boolean;          {OK}
     End;

     MathClass = Object
     Complex : Boolean;
     Function  PrimeNumber (X:Longint) : Boolean;        {OK}
     Function  ComplexModule (A,B:Real):Real;            {OK}
     Function  DeltaNumber   (A,B,C:Real):Real;          {OK}
     Function  DeltaFirstSol (A,B,C:Real):Real;          {OK}
     Function  DeltaSecondSol(A,B,C:Real):Real;          {OK}
     Function  Fact(X:Integer):Real;                     {OK}
     Function  Power(X:Real; Y:Integer):Real;            {OK}
     Function  Log(X:Real):Real;                         {OK}
     Function  DegToRad (X:Real):Real;                   {OK}
     Function  RadToDeg (X:Real):Real;                   {OK}
     Function  ArcCos(X:Real):Real;                      {OK}
     Function  ArcSin(X:Real):Real;                      {OK}
     Function  Tan (X:Real):Real;                        {OK}
     End;

     Encrypt  = Object
     Function EnCryptXOR(A,B:String):String;                               {OK}
     Function EnCryptXORRND1(A,B:String; Cle:Byte):String;                 {OK}
     Function EnCryptXORRND2(A,B:String; Cle1,Cle2:Byte):String;           {OK}
     Function EnCryptXORRND3(A,B:String; Cle1,Cle2,Cle3:Byte):String;      {OK}
     Function EnCryptXORRND4(A,B:String; Cle1,Cle2,Cle3,Cle4:Byte):String; {OK}
     End;

Var P : DirectStrArea;

Implementation

{TESTE L'EXISTENCE D'UN FICHIER}
Function DirectoryClass.ExistFile(Path:String):Boolean;
Begin
     FindFirst(Path,AnyFile,DirInfo);
     If (DosError = 0) Then ExistFile:=True Else ExistFile:=False;
     End;

{LISTE DES SOUS REPERTOIRES D'UN REPERTOIRE}
Function DirectoryClass.SubDirectories(Path:String):Integer;
Var II : Integer;
Begin
     For II:=1 To 256 Do P[II]:=Nil;
     II:=0;
     FindFirst(Path,$10,DirInfo);
     If (DosError<>0) Then SubDirectories:=0;
     While (DosError = 0) Do
     Begin
          If ((DirInfo.Attr and $10) <> 0) Then
          Begin
               Inc(II);
               GetMem(P[II],8);
               P[II]^:=DirInfo.Name;
               End;
          FindNext(DirInfo);
          End;
     SubDirectories:=II;
     End;

{CRYPTAGE XOR}
Function Encrypt.EncryptXOR(A,B:String):String;
Var C1,C2 : Integer;
        L : Integer;
Begin
     L:=Length(B);
     C2:=0;
     For C1:=1 To Length(A) Do
     Begin
          Inc(C2);
          If (C2=L+1) Then C2:=1;
          A[C1]:=Chr(Ord(A[C1]) xor Ord(B[C2]));
          End;
     EncryptXOR:=A;
     End;

{CRYPTAGE XOR + NOMBRES ALEAT 1 CLE}
Function Encrypt.EncryptXORRND1(A,B:String; Cle:Byte):String;
Var C1,C2 : Integer;
        L : Integer;
Begin
     RandSeed:=Cle;
     L:=Length(B);
     C2:=0;
     For C1:=1 To Length(A) Do
     Begin
          Inc(C2);
          If (C2=L+1) Then C2:=1;
          A[C1]:=Chr(Ord(A[C1]) xor Ord(B[C2]) xor random(255));
          End;
     EncryptXORRND1:=A;
     End;

{CRYPTAGE XOR + NOMBRES ALEAT 2 CLES}
Function Encrypt.EncryptXORRND2(A,B:String; Cle1,Cle2:Byte):String;
Var C1,C2 : Integer;
        L : Integer;
Begin
     RandSeed:=Cle1;
     L:=Length(B);
     C2:=0;
     For C1:=1 To Length(A) Do
     Begin
          Inc(C2);
          If (C2=L+1) Then C2:=1;
          A[C1]:=Chr(Ord(A[C1]) xor Ord(B[C2]) xor random(255) xor random(cle2));
          End;
     EncryptXORRND2:=A;
     End;

{CRYPTAGE XOR + NOMBRES ALEAT 3 CLES}
Function Encrypt.EncryptXORRND3(A,B:String; Cle1,Cle2,Cle3:Byte):String;
Var C1,C2 : Integer;
        L : Integer;
Begin
     RandSeed:=Cle1;
     L:=Length(B);
     C2:=0;
     For C1:=1 To Length(A) Do
     Begin
          Inc(C2);
          If (C2=L+1) Then C2:=1;
          A[C1]:=Chr(Ord(A[C1]) xor Ord(B[C2]) xor random(255)
          xor random(cle2) xor random(cle3));
          End;
     EncryptXORRND3:=A;
     End;

{CRYPTAGE XOR + NOMBRES ALEAT 4 CLES}
Function Encrypt.EncryptXORRND4(A,B:String; Cle1,Cle2,Cle3,Cle4:Byte):String;
Var C1,C2 : Integer;
        L : Integer;
Begin
     RandSeed:=Cle1;
     L:=Length(B);
     C2:=0;
     For C1:=1 To Length(A) Do
     Begin
          Inc(C2);
          If (C2=L+1) Then C2:=1;
          A[C1]:=Chr(Ord(A[C1]) xor Ord(B[C2]) xor random(255)
          xor random(Cle2) xor random(cle3) xor random(cle4));
          End;
     EncryptXORRND4:=A;
     End;

{TESTEUR DE NOMBRE PREMIER}
Function  MathClass.PrimeNumber(X:Longint):Boolean;
Var II : Integer;
Begin
     X:=Abs(X);
     If (X=1) or (X=0) Then Begin PrimeNumber:=True; Exit; End;
     For II:=2 To (X-1) Do
     Begin
          If (X Div II = X / II) Then Begin PrimeNumber:=False; Exit; End;
          End;
     PrimeNumber:=True;
     End;

{CONVERSION DEG --> RAD}
Function  MathClass.DegToRad (X:Real):Real;
Begin
     DegToRad:=(X*2*Pi)/360;
     End;

{CONVERSION RAD --> DEG}
Function  MathClass.RadToDeg (X:Real):Real;
Begin
     RadToDeg:=(X*360)/2*Pi;
     End;

{ARC COSINUS}
Function  MathClass.ArcCos(X:Real):Real;
Begin
     ArcCos:=(Pi/2)-ArcTan(X/Sqrt(1-X*X));
     End;

{ARC SINUS}
Function  MathClass.ArcSin(X:Real):Real;
Begin
     ArcSin:=ArcTan(X/Sqrt(1-X*X));
     End;

{TANGENTE}
Function  MathClass.Tan(X:Real):Real;
Begin
     Tan:=Sin(X)/Cos(X);
     End;

{CALCUL DE DELTA}
Function  MathClass.DeltaNumber (A,B,C:Real):Real;
Var Delt : Real;
Begin
     Delt:=(B*B)-(4*A*C);
     If (Delt<0) Then Complex:=True Else Complex:=False;
     DeltaNumber:=Delt;
     End;

{PREMIERE SOLUTION DE DELTA}
Function  MathClass.DeltaFirstSol (A,B,C:Real):Real;
Var Delta : Real;
Begin
     Delta:=DeltaNumber(A,B,C);
     DeltaFirstSol:=(-B-Sqrt(Delta))/(2*A);
     End;

{SECONDE SOLUTION DE DELTA}
Function  MathClass.DeltaSecondSol (A,B,C:Real):Real;
Var Delta : Real;
Begin
     Delta:=DeltaNumber(A,B,C);
     DeltaSecondSol:=(-B+Sqrt(Delta))/(2*A);
     End;

{MODULE D'UN NOMBRE COMPLEXE}
Function  MathClass.ComplexModule (A,B:Real):Real;
Begin
     ComplexModule:=Sqrt(A*A+B*B);
     End;

{CALCUL DE X PUISSANCE Y}
Function  MathClass.Power (X:Real; Y:Integer):Real;
Var II : Integer;
    Interm : Real;
Begin
     Interm:=1;
     For II:=1 To Y Do Interm:=Interm*X;
     Power:=Interm;
     End;

{CALCUL DE FACTORIELLE}
Function  MathClass.Fact (X:Integer):Real;
Var II : Integer;
 Interm: Real;
Begin
     Interm:=1;
     For II:=1 To X Do Interm:=Interm*II;
     Fact:=Interm;
     End;

{CALCUL DU LOGARITHMME BASE 10}
Function  MathClass.Log (X:Real):Real;
Begin
     Log:=Ln(X)/Ln(10);
     End;

{MODULE CALCULATRICE}
Procedure Calculator.Title(A:String);
Begin
     TextColor(0); TextBackground(White); ClrEol;
     Writeln(A);
     TextColor(White); TextBackground(blue);
     End;

Procedure Calculator.PutInMemory;
Var X : Integer;
Begin
     Ch:=Upcase(Readkey);
     If Not (Ch in ['A'..'Z']) then Ch:='A';
     X:=Ord(Ch)-64;
     M[X]:=Answer;
     Write ('EM : ',Ch,Answer,'                   ');
     End;

Procedure Calculator.GetInMemory;
Var X : Integer;
Begin
     Ch:=Upcase(Readkey);
     If Not (Ch in ['A'..'Z']) then Ch:='A';
     X:=Ord(Ch)-64;
     Answer:=M[X];
     Write ('DM : ',Ch,'   ',Answer,'                    ');
     End;

Procedure Calculator.First;
Begin
     Gotoxy(1,19);
     Write(' '); ClrEol; Write ('F> ');
     Readln(Line);
     If (Upcase(Line[1]) in ['A'..'Z']) then Begin
                            Fst:=M[Ord(Upcase(Line[1]))-64];
                            Exit; End;
     Val(Line,Fst,Code);
     End;

Procedure Calculator.Second;
Begin
     Gotoxy(1,20);
     Write(' '); ClrEol; Write ('S> ');
     Readln(Line);
     If (Upcase(Line[1]) in ['A'..'Z']) then Begin
                            Sec:=M[Ord(Upcase(Line[1]))-64];
                            Exit; End;
     Val(Line,Sec,Code);
     End;

Procedure Calculator.Add; Begin Answer:=Fst + Sec; End;

Procedure Calculator.Substract; Begin Answer:=Fst - Sec; End;

Procedure Calculator.Multiply;  Begin Answer:=Fst * Sec; End;

Procedure Calculator.Err;
Begin
     Gotoxy (1,22);
     Write('Calcul impossible');
     End;

Procedure Calculator.Divide;
Begin
     If (Sec=0) then Begin Err; Exit; End;
     Answer:=Fst / Sec;
     End;

Procedure Calculator.Opposite;  Begin Answer:=- Fst;    End;

Procedure Calculator.Absol;     Begin Answer:=Abs(Fst); End;

Procedure Calculator.Square;    Begin Answer:=Sqr(Fst); End;

Procedure Calculator.Root;
Begin
     If (Fst<0) then Begin Err; Exit; End;
     Answer:=Sqrt(Fst);
     End;

Procedure Calculator.Fln;
Begin
     If (Fst<=0) then Begin Err; Exit; End;
     Answer:=Ln(Fst);
     End;

Procedure Calculator.Exponent;
Begin
     Sec:=Exp(1);
     Puissance;
     End;

Procedure Calculator.Log;
Begin
     If (Fst<=0) then Begin Err; Exit; End;
     Answer:=Ln(Fst)/Ln(10);
     End;

Procedure Calculator.Dixx;
Begin
     Sec:=10;
     Puissance;
     End;

Procedure Calculator.Entire;    Begin Answer:=Round(Fst); End;

Procedure Calculator.Tangent;
Begin
     If (Cos(Fst)=0) then Begin Err; Exit; End;
     Answer:=Sin(Fst)/Cos(Fst);
     End;

Procedure Calculator.Cosine; Begin Answer:=Cos(Fst); End;

Procedure Calculator.Sinus;  Begin Answer:=Sin(Fst); End;

Procedure Calculator.Puissance;
Var X : Integer;
Begin
     Answer:=1;
     For X:=1 To Round(Fst) Do
     Begin
          Answer:= Sec * Answer;
          End;
     End;

Procedure Calculator.Invert;
Begin
     If (Fst=0) then Begin Err; Exit; End;
     Answer:=1/Fst;
     End;

Procedure Calculator.DoIt;
Begin
     GetOpt;
     If (Sortie=True) then exit;
     DoIt;
     End;

Procedure Calculator.Display;
Begin
     M[1]:=Answer;
     Write(Answer); Writeln('                            ');
     Write(' '); ClrEol;
     End;

Procedure Calculator.Spec;
Begin
     Ch:=readkey;
     Case ch of
          #59:Add;
          #60:Substract;
          #61:Multiply;
          #62:Divide;
          #63:Square;
          #64:Root;
          #65:Puissance;
          #66:Absol;
          #67:Opposite;
          #68:Entire;
          End;
     Display;
     End;

Procedure Calculator.GetOpt;
Var S:String;
Begin
     Gotoxy (1,21);
     ch:=upcase(readkey);
     Case ch of
          #0:Spec;
          #27:Begin Sortie:=True;  Exit; End;
          '+':Begin First; Second; Add;       Display; Exit; End;
          '-':Begin First; Second; Substract; Display; Exit; End;
          '/':Begin First; Second; Divide;    Display; Exit; End;
          '*':Begin First; Second; Multiply;  Display; Exit; End;
          'M':Begin PutInMemory; Exit; End;
          'G':Begin GetInMemory; Exit; End;
          End;
     If (Sortie=True) Then Exit;
     Write(ch);
     S:=Ch;
     Ch:=Upcase(readkey);
     Write(ch);
     S:=S+ch;
     If (Ch=#27) then Exit;
     If (S='OF') then Begin Sortie:=True; Exit;    End;
     If (S='CA') then Begin First; Square;       Display; End;
     If (S='RA') then Begin First; Root;         Display; End;
     If (S='TG') then Begin First; Tangent;      Display; End;
     If (S='CS') then Begin First; Cosine;       Display; End;
     If (S='SN') then Begin First; Sinus;        Display; End;
     If (S='LG') then Begin First; Log;          Display; End;
     If (S='LN') then Begin First; Fln;          Display; End;
     If (S='XY') then Begin First; Second;     Puissance; Display; End;
     If (S='OP') then Begin First; Opposite;     Display; End;
     If (S='EN') then Begin First; Entire;       Display; End;
     If (S='IN') then Begin First; Invert;       Display; End;
     If (S='PI') then Begin Answer:=Pi;          Display; End;
     If (S='RE') then Begin Answer:=0;           Display; End;
     If (S='EX') then Begin First; Exponent;     Display; End;
     If (S='10') then Begin First; Dixx;         Display; End;
     End;

Procedure Calculator.Screen;
Begin
     Clrscr;
     Sortie:=False;
     Title('Elektron. Calculatrice g‚n‚rale ');
     Writeln; Writeln;
     Writeln ('ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
     Writeln ('³ Mx       ³ Ecriture m‚moire   ³         ³                    ³');
     Writeln ('³ Gx       ³ Lecture  m‚moire   ³         ³                    ³');
     Writeln ('³ +   (F1) ³ Addition           ³ -   (F2)³ Soustraction       ³');
     Writeln ('³ *   (F3) ³ Multiplication     ³ /   (F4)³ Division           ³');
     Writeln ('³ CA  (F5) ³ Carr‚              ³ RA  (F6)³ Racine             ³');
     Writeln ('³ XY  (F7) ³ Puissance          ³ VA  (F8)³ Valeur absolue     ³');
     Writeln ('³ OP  (F9) ³ Changement de signe³ EN (F10)³ Valeur entiŠre     ³');
     Writeln ('³ LG       ³ Logarithme d‚cimal ³ LN      ³ Logarithme n‚p‚rien³');
     Writeln ('³ 10       ³ Dix Puissance X    ³ EX      ³ Exponentielle      ³');
     Writeln ('³ CS       ³ Cosinus            ³ SN      ³ Sinus              ³');
     Writeln ('³ TG       ³ Tangente           ³ IN      ³ Inversion          ³');
     Writeln ('³ RE       ³ Reset              ³ PI      ³ Valeur de Pi       ³');
     Writeln ('ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
     Writeln (' [esc]     Sortie');
     End;

{AFFICHE UN BYTE}
Procedure Hexa.DispByte(A:Byte);
Var I,J:Integer;
Begin
     I:=A div 16; J:=A mod 16;
     Write(Hex[i]+Hex[j]);
     End;

{AFFICHE UN MOT}
Procedure Hexa.DispWord(A:Word);
Var I,J:Integer;
Begin
     I:=A div 256; J:=A mod 256;
     DispByte(I); DispByte(J);
     End;

{AFFICHE UN POINTEUR SOUS LA FORME SEGMENT:DEPLACEMENT}
Procedure Hexa.DispPointer(A,B:Word);
Begin
     DispWord(A);
     Write(':');
     DispWord(B);
     End;

{TRANSFORME UN HEXA EN BYTE}
Function Hexa.HexToByte(A:String):Byte;
Var I,J : ShortInt;
   Code : Integer;
Begin
     Case A[1] of
          '0'..'9':Val(A[1],I,Code);
          'A':I:=10;
          'B':I:=11;
          'C':I:=12;
          'D':I:=13;
          'E':I:=14;
          'F':I:=15;
          End;

     Case A[2] of
          '0'..'9':Val(A[2],J,Code);
          'A':J:=10;
          'B':J:=11;
          'C':J:=12;
          'D':J:=13;
          'E':J:=14;
          'F':J:=15;
          End;
     HexToByte:=I*16+J;
     End;

{TRANSFORME UN HEXA EN WORD}
Function Hexa.HexToWord(A1:String):Word;
Var I,J:Byte;
Begin
     I:=HexToByte(A1[1]+A1[2]);
     J:=HexToByte(A1[3]+A1[4]);
     HexToWord:=I*256+J;
     End;

{TRANSFORMER UN POINTEUR HEXA EN POINTEUR MEMOIRE}
Function Hexa.HexToPointer(A2:String):Pointer;
Var I,J:Word;
Begin
     I:=HexToWord(A2[1]+A2[2]+A2[3]+A2[4]);
     J:=HexToWord(A2[6]+A2[7]+A2[8]+A2[9]);
     HexToPointer:=Ptr(I,J);
     End;

{MESSAGE D'INVITE SUR UNE MEME LIGNE}
Procedure Banner.Banner(A:String; EM,FM,EN,FN:Integer; CL:Boolean);
Begin
     If (CL=True) then Clrscr;
     TextBackground(FM);
     TextColor(EM);
     Write(A);
     ClrEol;
     TextColor(EN);
     TextBackground(FN);
     End;

{MESSAGE D'INVITE + RETOUR A LA LIGNE}
Procedure Banner.BannerLN(A:String; EM,FM,EN,FN:Integer; CL:Boolean);
Begin
     Banner(A,EM,FM,EN,FN,CL);
     Writeln;
     End;

{MESSAGE D'INVITE CLIGNOTANT}
Procedure Banner.Blink (A:String; EM,FM,EN,FN:Integer; CL:Boolean);
Begin
     Banner(A,EM+16,FM,EN,FN,CL);
     End;

{EFFACER UNE PLAGE DE L'ECRAN}
Procedure Banner.ClearWin (X1,Y1,X2,Y2:Integer);
Var XX1,YY1,XX2,YY2 : Integer;
Begin
     XX1:=Lo(WindMin)+1; YY1:=Hi(WindMin)+1;
     XX2:=Lo(WindMax)+1; YY2:=Hi(WindMax)+1;
     Window(X1,Y1,X2,Y2);
     Clrscr;
     Window(XX1,YY1,XX2,YY2);
     End;

{COLORIER UNE PLAGE DE L'ECRAN TEXTE}
Procedure Banner.ColorWin (X1,Y1,X2,Y2,COL:Integer);
Var XX1,YY1,XX2,YY2,CCOL : Integer;
Begin
     XX1:=Lo(WindMin); YY1:=Hi(WindMin);
     XX2:=Lo(WindMax); YY2:=Hi(WindMax);
     CCOL:=TextAttr;
     TextBackGround(COL);
     ClearWin (X1,Y1,X2,Y2);
     TextBackground(CCOL);
     Window(XX1,YY1,XX2,YY2);
     End;

{MISE EN VALEUR D'UNE INFORMATION A L'ECRAN}
Procedure Banner.Value (M1,M2,M3 : String; AT1B,AT1C,AT2B,AT2C : Integer);
Begin
     TextBackground(AT1B);
     TextColor(AT1C);
     Write(M1);
     TextColor(AT2C);
     TextBackground(AT2B);
     Write(M2);
     TextColor(AT1C);
     TextBackground(AT1B);
     Writeln(M3);
     End;

{GESTION DE PLUSIEURS INTERFACES SERIELLES}

{N : NUMERO DE LA SORTIE SERIE}

{INITIALISATION D'UNE SORTIE SERIE}
Function RS232.Init(N:Word; B:Byte):Word;
Var Regs : Registers;
Begin
     Regs.ah:=0;
     Regs.al:=B;
     Regs.dx:=N;
     intr($14,Regs);
     Stat:=regs.ax;
     Init:=regs.ax;
     End;

{STATUT D'UNE SORTIE SERIE}
Function RS232.Status(N:Word):Word;
Var Regs : Registers;
Begin
     regs.ah:=3;
     regs.dx:=N;
     intr($14,regs);
{     stat:=regs.ax;}
     Status:=regs.ax;
     End;

{RECEPTION D'UN CARACTERE}
Function  RS232.Receive(N:Word):Byte;
Var Regs : Registers;
Label    ABC;
Begin
ABC:
     regs.dx:=N;
     regs.ah:=2;
     intr($14,regs);
     If ((Status(N) and 1) <> 0) Then Goto ABC;
     Receive:=regs.al;
     End;

{EMISSION D'UN CARACTERE}
Procedure RS232.Emit(N:Word; B:Byte);
Var Regs : Registers;
Begin
     regs.dx:=N;
     regs.ah:=1;
     regs.al:=B;
     intr($14,regs);
     Stat:=regs.ax;
     End;

{EMISSION D'UNE CHAINE DE CARACTERES}
Procedure RS232.EmitStr(N:Word; S:String);
Var I:Integer;
Begin
     For I:=1 To Length(S) Do Emit(N,Ord(S[i]));
     End;

{EMISSION D'UNE CHAINE DE CARACTERES + RETOUR A LA LIGNE}
Procedure RS232.EmitStrLN (N:Word; S:String);
Begin
     EmitStr(N,S);
     Emit(N,10);
     Emit(N,13);
     End;

{RECEPTION D'UNE CHAINE DE CARACTERES}
Function RS232.ReceiveStr(N:Word):String;
Var S:String;
    C:Byte;
Begin
     S:='';
     C:=Receive(N);
     While (C<>10) Do
     Begin
          S:=S+Chr(C);
          C:=Receive(N);
          End;
     ReceiveStr:=S;
     End;

{GESTION D'UNE SEULE INTERFACE SERIELLE}
Procedure SimpleRS232.Choose(N:Word);
Begin
     Num:=N;
     End;

{INITIALISATION}
Function SimpleRS232.Init(B:Byte):Word;
Begin
     Stat:=Rs232.Init(Num,B);
     Init:=Stat;
     End;

{STATUT}
Function SimpleRS232.Status:Word;
Begin
     Stat:=Rs232.Status(Num);
     Status:=Stat;
     End;

{RECEPTION CAR}
Function SimpleRS232.Receive:Byte;
Begin
     Receive:=Rs232.Receive(Num);
     End;

{EMISSION CAR}
Procedure SimpleRS232.Emit(B:Byte);
Begin
     Rs232.Emit(Num,B);
     End;

{EMISSION CHAINE DE CAR}
Procedure SimpleRS232.EmitStr(S:String);
Begin
     Rs232.EmitStr(Num,S);
     End;

{EMISSION CHAINE DE CAR + RETOUR A LA LIGNE}
Procedure SimpleRS232.EmitStrLN (S:String);
Begin
     Rs232.EmitStrLN(Num,S);
     End;

{RECEPTION D'UNE CHAINE DE CAR}
Function SimpleRs232.ReceiveStr:String;
Begin
     ReceiveStr:=Rs232.ReceiveStr(Num);
     End;

{GESTION DE PLUSIEURS MINITELS}

{RECEPTION CHAINE DE CARACTERES}
Function Minitel.ReceiveStr(N:Word):String;
Var S:String;
    C:Byte;
Begin
     S:='';
     C:=Receive(N);
     While (C<>65) Do
     Begin
          S:=S+Chr(C);
          C:=Receive(N);
          End;
     ReceiveStr:=S;
     End;

{INITIALISATION}
Function Minitel.InitMin(N:Word):Word;
Begin
     Stat:=Init(N,154);
     InitMin:=Stat;
     End;

{VIDER L'ECRAN}
Procedure Minitel.Cls(N:Word);
Begin
     Emit(N,12);
     End;

{ALLUMAGE CURSEUR}
Procedure Minitel.Cursor(N:Word);
Begin
     Emit(N,17);
     End;

{GESTION D'UN SEUL MINITEL}

{INIT}
Function SimpleMinitel.InitMin:Word;
Begin
     Stat:=Rs232.Init(Num,154);
     InitMin:=Stat;
     End;

{RECEPTION D'UNE CHAINE DE CAR}
Function SimpleMinitel.ReceiveStr:String;
Var S:String;
    C:Byte;
Begin
     S:='';
     C:=Receive;
     While (C<>65) Do
     Begin
          S:=S+Chr(C);
          C:=Receive;
          End;
     ReceiveStr:=S;
     End;

{VIDE ECRAN}
Procedure SimpleMinitel.Cls;
Begin
     Rs232.Emit(Num,12);
     End;

{ALLUMAGE CURSEUR}
Procedure SimpleMinitel.Cursor;
Begin
     Rs232.Emit(Num,17);
     End;

{PASSE LES ESPACES ET LES TABULATIONS DE DEBUT DE CHAINE}
Function StrClass.SkipBlanks (A:String):String;
Begin
     While ((A[1]=#9) or (A[1]=' ')) Do Delete(A,1,1);
     SkipBlanks:=A;
     End;

{TOUTE LA CHAINE EN MAJUSCULES}
Function StrClass.UpcaseStr (A:String):String;
Var II : Integer;
Begin
     For II:=1 To Length(A) Do
     Begin
          A[II]:=Upcase(A[II]);
          If (A[II] in ['…','ƒ','„']) then A[II]:='A';
          If (A[II] in ['‚','Š','‰','ˆ']) then A[II]:='E';
          If (A[II]='‡') then A[II]:='C';
          End;
     UpcaseStr:=A;
     End;

{UNE SOUS CHAINE EN MAJUSCULES}
Function StrClass.UpcaseSubStr (A,B:String):String;
Var P,II : Integer;
Begin
     P:=Pos(B,A);
     If (P<=0) Then Begin UpcaseSubStr:=''; Exit; End;
     For II:=P To (P+Length(B)-1) Do
     Begin
          A[II]:=Upcase(A[II]);
          If (A[II] in ['…','„','ƒ']) Then A[II]:='A';
          If (A[II] in ['‚','Š','‰']) Then A[II]:='E';
          If (A[II]='‡') Then A[II]:='C';
          End;
     UpcaseSubStr:=A;
     End;

{TOUTE LA CHAINE EN MINUSCULES}
Function StrClass.LowcaseStr (A:String):String;
Var II : Integer;
Begin
     For II:=1 To Length(A) Do
     Begin
          Case A[II] of
               'A'..'Z':A[II]:=Chr(Ord(A[II])+32);
               End;
          End;
     LowCaseStr:=A;
     End;

{UNE PARTIE DE LA CHAINE EN MINUSCULES}
Function StrClass.LowcaseSubStr (A,B:String):String;
Var P,II : Integer;
Begin
     P:=Pos(B,A);
     If (P<=0) Then Begin LowcaseSubStr:=''; Exit; End;
     For II:=P To (P+Length(B)-1) Do
     Begin
          Case A[II] of
               'A'..'Z':A[II]:=Chr(Ord(A[II])+32);
               End;
          End;
     LowCaseSubStr:=A;
     End;

{N CARACTERES LES PLUS A DROITES DE LA CHAINE}
Function StrClass.Right (A:String; N:Integer):String;
Begin
     Delete(A,1,Length(A)-N);
     Right:=A;
     End;

{N CARACTERES LES PLUS A GAUCHES DE LA CHAINE}
Function StrClass.Left (A:String; N:Integer):String;
Begin
     Delete(A,N+1,Length(A)-N);
     Left:=A;
     End;

{RECHERCHE ET ELIMINATION DE PORTIONS DE CHAINES DANS UNE AUTRE}
{DESTRUCTION D'OCCURENCES DE MOTS DANS UNE CHAINE}
Function StrClass.Flushing (Dest:String; L:Liste):String;
Var P,II : Integer;
Begin
     For II:=1 To 10 Do
     Begin
          P:=Pos(L[II],Dest);
          If (L[II]='') Then Begin Flushing:=Dest; Exit; End;
          While (P>0) Do
          Begin
               Delete(Dest,P,Length(L[II]));
               P:=Pos(L[II],Dest);
               End;
          End;
     Flushing:=Dest;
     End;

{FLUSHING JUSQU'A UNE POSITION FIXEE A L'AVANCE}
Function StrClass.FlushingN (Dest:String; L:Liste; N:Integer):String;
Var P,II : Integer;
Begin
     For II:=1 To 10 Do
     Begin
          P:=Pos(L[II],Dest);
          If (L[II]='') Then Begin FlushingN:=Dest; Exit; End;
          While (P>0) And (P<N) Do
          Begin
               Delete(Dest,P,Length(L[II]));
               P:=Pos(L[II],Dest);
               End;
          End;
     FlushingN:=Dest;
     End;

     End.
