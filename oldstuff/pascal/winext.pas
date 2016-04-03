{************************************************** TPOO Juin 89 *}
{******************** Projet : WINDEMO   *************************}
{*                                                               *}
{* Fichier Programme WINDEMO                                     *}
{* Utilise l'unit‚ WIN et WIN.ASM                                *}
{********************** Copyright (c) 1989 Borland International *}

Unit WinExt;

Interface

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


PROCEDURE ActiveWindow(Active: Boolean);
PROCEDURE OpenWindow(X1, Y1, X2, Y2: Byte; T: TitleStr;
  TAttr, FAttr: Byte);
PROCEDURE CloseWindow;

{$S-}


VAR
  TopWindow: WinRecPtr;
  WindowCount: Integer;
  Done: Boolean;
  Ch: Char;

Implementation

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

END.

{* Fin de Fichier Programme WINDEMO                                     *}
