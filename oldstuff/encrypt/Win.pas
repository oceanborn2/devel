{************************************************** TPOO Juin 89 *}
{******************** Projet : WIN.TPU   *************************}
{*                                                               *}
{* Fichier Unit‚ WIN                                             *}
{* Utilise des routines assembleur se trouvant dans WIN.ASM !    *}
{********************** Copyright (c) 1989 Borland International *}

UNIT Win;

{$D-,S-}

INTERFACE

USES Crt;

TYPE

{ ChaŒne pour la barre de titre de la fenˆtre }
  TitleStr = string[63];

{ CaractŠres du cadre de fenˆtre }
  FrameChars = array[1..8] of Char;

{ Strcuture de stockage de l'‚tat de la fenˆtre }
  WinState = RECORD
    WindMin, WindMax: word;
    WhereX, WhereY  : byte;
    TextAttr        : byte;
  END;

CONST
{ Jeux de caractŠres standard pour cr‚er les cadres }

  SingleFrame: FrameChars = 'ÚÄ¿³³ÀÄÙ';
  DoubleFrame: FrameChars = 'ÉÍ»ººÈÍ¼';

{ Routines d'‚criture directe }
procedure WriteStr( X, Y: Byte; S: String; Attr: Byte);
procedure WriteChar(X, Y, Count: Byte; Ch: Char; Attr: Byte);

{ Routines de gestion de fenˆtre }
procedure FillWin(Ch: Char; Attr: Byte);
procedure ReadWin(var Buf);
procedure WriteWin(var Buf);
function WinSize: Word;
procedure SaveWin(var W: WinState);
procedure RestoreWin(var W: WinState);
procedure FrameWin(Title: TitleStr; var Frame: FrameChars;
  TitleAttr, FrameAttr: Byte);
procedure UnFrameWin;

IMPLEMENTATION

{$L WIN}

procedure WriteStr(X, Y: Byte; S: String; Attr: Byte);
external {WIN};

procedure WriteChar(X, Y, Count: Byte; Ch: Char; Attr: Byte);
external {WIN};

procedure FillWin(Ch: Char; Attr: Byte);
external {WIN};

procedure WriteWin(var Buf);
external {WIN};

procedure ReadWin(var Buf);
external {WIN};

function WinSize: Word;
external {WIN};

procedure SaveWin(var W: WinState);
BEGIN
  W.WindMin  := WindMin;
  W.WindMax  := WindMax;
  W.WhereX   := WhereX;
  W.WhereY   := WhereY;
  W.TextAttr := TextAttr;
END;

procedure RestoreWin(var W: WinState);
BEGIN
  WindMin  := W.WindMin;
  WindMax  := W.WindMax;
  GotoXY(W.WhereX, W.WhereY);
  TextAttr := W.TextAttr;
END;

procedure FrameWin(Title: TitleStr; var Frame: FrameChars;
  TitleAttr, FrameAttr: Byte);
var
  W, H, Y: Word;
BEGIN
  W := Lo(WindMax) - Lo(WindMin) + 1;
  H := Hi(WindMax) - Hi(WindMin) + 1;
  WriteChar(1, 1, 1, Frame[1], FrameAttr);
  WriteChar(2, 1, W - 2, Frame[2], FrameAttr);
  WriteChar(W, 1, 1, Frame[3], FrameAttr);
  if Length(Title) > W - 2 then Title[0] := Chr(W - 2);
  WriteStr((W - Length(Title)) shr 1 + 1, 1, Title, TitleAttr);
  for Y := 2 to H - 1 do
  BEGIN
    WriteChar(1, Y, 1, Frame[4], FrameAttr);
    WriteChar(W, Y, 1, Frame[5], FrameAttr);
  END;
  WriteChar(1, H, 1, Frame[6], FrameAttr);
  WriteChar(2, H, W - 2, Frame[7], FrameAttr);
  WriteChar(W, H, 1, Frame[8], FrameAttr);
  Inc(WindMin, $0101);
  Dec(WindMax, $0101);
END;

procedure UnFrameWin;
BEGIN
  Dec(WindMin, $0101);
  Inc(WindMax, $0101);
END;

END.

{       Fin de fichier unit‚ WIN.PAS             }
