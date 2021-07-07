{************************************************** TPOO Juin 89 *}
{******************** Projet : WINDEMO   *************************}
{*                                                               *}
{* Fichier Programme WINDEMO                                     *}
{* Utilise l'unit‚ WIN et WIN.ASM                                *}
{********************** Copyright (c) 1989 Borland International *}

PROGRAM WinDemo;

{$S-}

USES Crt, Win;

CONST

  CClose  = ^F;  { Modifi‚ de ^C en anglais en ^F pour Fermer }
  CRight  = ^D;
  CUp     = ^E;
  CEnter  = ^M;
  CInsLin = ^N;
  COpen   = ^O;
  CRandom = ^R;  { Modifi‚ de ^R en anglais en ^A pour Al‚atoire }
  CLeft   = ^S;
  CDown   = ^X;
  CDelLin = ^Y;
  CExit   = ^[;

TYPE
  TitleStrPtr = ^TitleStr;

  WinRecPtr = ^WinRec;
  WinRec = RECORD
    Next: WinRecPtr;
    State: WinState;
    Title: TitleStrPtr;
    TitleAttr, FrameAttr: Byte;
    Buffer: Pointer;
  END;

VAR
  TopWindow: WinRecPtr;
  WindowCount: Integer;
  Done: Boolean;
  Ch: Char;

PROCEDURE ActiveWindow(Active: Boolean);
BEGIN
  IF TopWindow <> nil THEN
  BEGIN
    UnFrameWin;
    WITH TopWindow^ DO
      IF Active THEN
        FrameWin(Title^, DoubleFrame, TitleAttr, FrameAttr)
      ELSE
        FrameWin(Title^, SingleFrame, FrameAttr, FrameAttr);
  END;
END;

PROCEDURE OpenWindow(X1, Y1, X2, Y2: Byte; T: TitleStr;
  TAttr, FAttr: Byte);
VAR
  W: WinRecPtr;
BEGIN
  ActiveWindow(False);
  New(W);
  WITH W^ DO
  BEGIN
    Next := TopWindow;
    SaveWin(State);
    GetMem(Title, Length(T) + 1);
    Title^ := T;
    TitleAttr := TAttr;
    FrameAttr := FAttr;
    Window(X1, Y1, X2, Y2);
    GetMem(Buffer, WinSize);
    ReadWin(Buffer^);
    FrameWin(T, DoubleFrame, TAttr, FAttr);
  END;
  TopWindow := W;
  Inc(WindowCount);
END;

PROCEDURE CloseWindow;
VAR
  W: WinRecPtr;
BEGIN
  IF TopWindow <> nil THEN
  BEGIN
    W := TopWindow;
    WITH W^ DO
    BEGIN
      UnFrameWin;
      WriteWin(Buffer^);
      FreeMem(Buffer, WinSize);
      FreeMem(Title, Length(Title^) + 1);
      RestoreWin(State);
      TopWindow := Next;
    END;
    Dispose(W);
    ActiveWindow(True);
    Dec(WindowCount);
  END;
END;

PROCEDURE Initialize;
BEGIN
  CheckBreak := False;
  IF (LastMode <> CO80) AND (LastMode <> BW80) AND (LastMode <> Mono) THEN 
     TextMode(CO80);
  TextAttr := Black + LightGray * 16;
  Window(1, 2, 80, 24);
  FillWin(#178, LightGray + Black * 16);
  Window(1, 1, 80, 25);
  GotoXY(1, 1);
  Write('      *** D‚monstration de l''unit‚ WIN de Turbo Pascal 5.5 *** ');
  ClrEol;
  GotoXY(1, 25);
  Write(' Ins=InsLigne  Del=SupLigne  Alt-O=Ouvre ' +
        ' Alt-F=Ferme Alt-A=Al‚at  Esc=Sort');
  ClrEol;
  Randomize;
  TopWindow := nil;
  WindowCount := 0;
END;

PROCEDURE CreateWindow;
VAR
  X, Y, W, H: Integer;
  S: string[15];
  Color: Byte;
BEGIN
  W := Random(50) + 10;
  H := Random(15) + 5;
  X := Random(80 - W) + 1;
  Y := Random(23 - H) + 2;
  Str(WindowCount + 1, S);
  IF LastMode <> CO80 THEN
    Color := Black ELSE Color := WindowCount mod 6 + 1;
  OpenWindow(X, Y, X + W - 1, Y + H - 1, ' Fenˆtre ' + S + ' ',
    Color + LightGray * 16, LightGray + Color * 16);
  TextAttr := LightGray;
  ClrScr;
END;

PROCEDURE RandomText;
BEGIN
  REPEAT
    Write(Chr(Random(95) + 32));
  UNTIL KeyPressed;
END;

FUNCTION ReadChar: Char;
VAR
  Ch: Char;
BEGIN
  Ch := ReadKey;
  IF Ch = #0 THEN
    CASE ReadKey OF
{      #19: Ch := CRandom;} { Alt-R  Voir ci-dessous }
      #30: Ch := CRandom;   { Alt-A  Version fran‡aise !!! }
      #24: Ch := COpen;     { Alt-O }
      #45: Ch := CExit;     { Alt-X }
{      #46: Ch := CClose;}  { Alt-C }
      #33: Ch := CClose;    { Alt-F  Version fran‡aise !!! }
      #72: Ch := CUp;       { Up }
      #75: Ch := CLeft;     { Left }
      #77: Ch := CRight;    { Right }
      #80: Ch := CDown;     { Down }
      #82: Ch := CInsLin;   { Ins }
      #83: Ch := CDelLin;   { Del }
    END;
  ReadChar := Ch;
END;

PROCEDURE Beep;
BEGIN
  Sound(500); Delay(25); NoSound;
END;

{ D‚but de la d‚mo WINDEMO }
BEGIN
  Initialize;
  Done := False;
  REPEAT
    Ch := ReadChar;
    IF WindowCount = 0 THEN
      IF (Ch <> COpen) AND (Ch <> CExit) THEN Ch := #0;
    CASE Ch OF
      #32..#255: Write(Ch);
      COpen  : CreateWindow;
      CClose : CloseWindow;
      CUp    : GotoXY(WhereX, WhereY - 1);
      CLeft  : GotoXY(WhereX - 1, WhereY);
      CRight : GotoXY(WhereX + 1, WhereY);
      CDown  : GotoXY(WhereX, WhereY + 1);
      CRandom: RandomText;
      CInsLin: InsLine;
      CDelLin: DelLine;
      CEnter : WriteLn;
      CExit  : Done := True;
    ELSE
      Beep;
    END;
  UNTIL Done;
  Window(1, 1, 80, 25);
  NormVideo;
  ClrScr;
END.

{* Fin de Fichier Programme WINDEMO                                     *}
