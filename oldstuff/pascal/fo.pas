Program File_Observer;

Uses Crt,Dos;

Const
     HexNum : Array [0..15] of String[1] = ('0','1','2','3','4',
                                           '5','6','7','8','9',
                                           'A','B','C','D','E','F');
     InitCol=6;
     NbHex=375;
     FirstLine=3;

Type
     Screen = Record
              Cont : Array [1..1024] of byte;
              End;

     Shower = Object
              number:integer;
              Procedure Init;
              Procedure Err;
              Procedure Which;
              End;

     Banner = Object
              Procedure Init;
              Procedure Acceuil;
              Procedure ParamErr;
              Procedure Quit(ErrorCode:Integer);
              End;

     Pascal = Object
            F:Text;
            C:Integer;
            Function UpLine(S:String):String;
            Procedure Key;
            Procedure Show;
            End;

     Hexa   = Object
            F:File;
            Col,C:Integer;
            Procedure Newline;
            Procedure NewPage;
            Procedure Column;
            Procedure Disp;
            Procedure DispDigit;
            Procedure Show;
            End;

     Reality = Object
             F:File;
             C:Integer;
             Procedure Key;
             Procedure Disp;
             Procedure Show;
             End;

     Execut = Object
            F:File;
            Procedure Show;
            End;

     Texte   = Object
            F:Text;
            C:Integer;
            Procedure Key;
            Procedure Show;
            End;

     Comm   = Object
            F:File;
            Procedure Show;
            End;

     Directory = Object
                 F:Text;
                 Procedure Show;
                 End;

     Searcher = Object
                F:File;
                Procedure Search;
                Procedure Show;
                End;

     WhereIs = Object
               Procedure Search;
               Procedure Show;
               End;

Var
 DIRINFO : SearchRec;
  RESULT : Word;
     BUF : Array [1..32768] of char;
      NB : Integer;
     I,J : integer;
       S : Shower;
       B : Banner;
      CH : Char;
       P : Pointer;
  SECOND : String;

     PAS : Pascal;
     HEX : Hexa;
     EXE : Execut;
     TXT : Texte;
     COM : Comm;
     DIR : Directory;
    REAL : Reality;
  SEARCH : Searcher;
  WHERIS : WhereIs;

Procedure Banner.Acceuil;
Begin
     Clrscr; TextColor (White);
     TextBackground(Blue);
     ClrEol; Writeln ('File Observer 1.00                                                             ');
     ClrEol; Writeln ('Copyright (c) 1990. Pascal Munerot                                             ');
     TextColor (white);
     Gotoxy (1,25); ClrEol;
     Write('Modes availables are : '); TextColor(Yellow);
     Write ('COM EXE HEX TEXT DIR PASCAL REAL SEARCH WHEREIS');
     TextColor(White);
     Window(1,5,80,24); TextBackground(red); Clrscr;
     End;

Procedure Banner.Init;
Begin
     TextColor(White);
     TextBackGround(Black);
     Clrscr;
     Acceuil;
     End;

Procedure Banner.ParamErr;
Begin
     Gotoxy(1,7);
     Writeln ('Erreur de paramätre');
     Halt(1);
     End;

Procedure Banner.Quit(ErrorCode:Integer);
Begin
     Halt(ErrorCode);
     End;

Procedure Shower.Init;
Begin
     FindFirst(ParamStr(1),AnyFile,DirInfo);
     If DosError <> 0 Then Err;
     End;

Procedure Shower.Err;
Begin
     Gotoxy(1,7);
     Writeln ('Erreur DOS : ',Dos.DosError);
     Halt(1);
     End;

Procedure Up;
Begin
     Second:=ParamStr(2);
     For i:=1 to Length(Second) do
     Begin
          Second[i]:=Upcase(Second[i]);
          End;
     End;

Procedure Shower.Which;
Begin
     Up;
     If Second='PASCAL'  then Pas.Show;
     If Second='TEXT'    then Txt.Show;
     If Second='EXE'     then Exe.Show;
     If Second='HEX'     then Hex.Show;
     If Second='COM'     then Com.Show;
     If Second='DIR'     then Dir.Show;
     If Second='REAL'    then Real.Show;
     If Second='SEARCH'  then Search.Show;
     If Second='WHEREIS' then WherIs.Show;
     End;

Procedure Mode (A,B:String);
Begin
     Window(1,1,80,25); TextBackground(blue);
     Gotoxy(1,3);  ClrEol;
     Gotoxy (1,4); ClrEol;
     TextColor(White);
     TextBackground(Blue);
     Write('Fichier : ');
     TextColor(Yellow);
     Write(A);
     TextColor(White);
     Write('   Mode : ');
     TextColor(Yellow);
     Write(B);
     TextColor(white);
     Window(1,5,80,24); TextBackground(red); Clrscr;
     End;

Procedure Pascal.Key;
Begin
     Inc(C);
     if C=19 then Begin ch:=readkey; c:=0; Clrscr; End;
     End;

Function Pascal.UpLine(S:String):String;
Var I:Integer;
Begin
     For i:=1 to Length(S) do
     Begin
          S[i]:=Upcase(S[i]);
          End;
     UpLine:=S;
     End;

Procedure Pascal.Show;
Var Ligne:String[80];
Begin
     C:=0;
     Clrscr;
     Mode (ParamStr(1),'PASCAL');
     Assign (F,ParamStr(1));
     Reset(F);
     While Not Eof(F) do
     Begin
          Readln(F,Ligne);
          If Pos('PROCEDURE',Upline(ligne))>0 then
          Begin
               Writeln(ligne);
               Key;
               End;
          If Pos('FUNCTION',Upline(ligne))>0 then
          Begin
               Writeln(ligne);
               Key;
               End;
          End;
     End;

Procedure Reality.Key;
Begin
     If WhereY=19 then Begin ch:=Readkey; Clrscr; End;
     End;

Procedure Reality.Disp;
Begin
     C:=0;
     For i:=1 to Result div 512 do
     Begin
          For j:=1 to 512 do
          Begin
               inc (c);
               Write (Buf[c]);
               Key;
               End;
          End;
     For i:=1 to Result Mod 512 do
     Begin
          inc(c);
          Write (Buf[c]);
          Key;
          End;
     ch:=readkey;
     End;

Procedure Reality.Show;
Begin
     C:=0;
     Clrscr;
     Mode (ParamStr(1),'REAL');
     Assign (F,ParamStr(1));
     Reset(F,1);
     While Not Eof(F) do
     Begin
          BlockRead (F,Buf,32768,Result);
          Disp;
          End;
     End;

Procedure Texte.Key;
Begin
     Inc(C);
     if C=19 then Begin ch:=readkey; c:=0; End;
     End;

Procedure Texte.Show;
Var Ligne:String[80];
Begin
     Mode (ParamStr(1),'TEXT');
     Assign (F,ParamStr(1));
     Reset(F);
     While Not Eof(F) do
     Begin
          Readln(F,Ligne);
          Writeln(ligne);
          Key;
          End;
     Close(F);
     End;

Procedure Comm.Show;
Begin
     Mode (ParamStr(1),'COM');
     End;

Procedure Hexa.DispDigit;
Var A,B:Integer;
Begin
     C:=C+1;
     A:=Ord(Buf[C]) div 16;
     B:=Ord(Buf[C]) mod 16;
     if WhereX<77 then Write(HexNum[A]+HexNum[B]+' ') Else
                                                   Begin
                                                        NewLine;
                                                        Col:=InitCol;
                                                        Writeln;
                                                        Gotoxy (Col,WhereY);
                                                        End;
     End;


Procedure Hexa.Column;
Begin
     Inc(Col,3);
     If Col>70 Then Begin Col:=InitCol; Writeln; End;
     Gotoxy (Col,WhereY);
     End;

Procedure Hexa.NewLine;
Var D:Integer;
Begin
     D:=C-25;
     Gotoxy (1,WhereY);
     Write(HexNum[D div 256 div 16]);
     Write(HexNum[D div 256 mod 16]);
     Write(HexNum[D mod 256 div 16]);
     Write(HexNum[D mod 256 mod 16]);
     End;

Procedure Hexa.NewPage;
Begin
     ch:=readkey;
     Clrscr; Write ('Offset : '+HexNum[C div 256 div 16]);
     Write(HexNum[C div 256 mod 16]+HexNum[C mod 256 div 16]);
     Write(HexNum[C mod 256 mod 16]);
     Gotoxy (Col,FirstLine);
     End;

Procedure Hexa.Disp;
Begin
     C:=0; Col:=InitCol; Gotoxy (Col,FirstLine);
     For i:=1 to Result div NbHex do
     Begin
          For j:=1 to NbHex do
          Begin
               DispDigit;
               End;
          NewPage;
          End;
     For i:=1 to Result mod NbHex do
     Begin
          DispDigit;
          End;
     ch:=readkey; Clrscr; Gotoxy(Col,FirstLine);
     End;

Procedure Hexa.Show;
Begin
     Mode (ParamStr(1),'HEX');
     Assign (F,ParamStr(1));
     Reset(F,1);
     Clrscr;
     While Not Eof(F) do
     Begin
          BlockRead(F,Buf,32768,Result);
          Disp;
          If Result<32768 then Begin Close(F); Exit; End;
          End;
     Close(F);
     End;

Procedure Execut.Show;
Begin
     Mode (ParamStr(1),'EXE');
     End;

Procedure Directory.Show;
Begin
     Mode (ParamStr(1),'DIR');
     End;

Procedure Searcher.Search;
Begin
     End;

Procedure Searcher.Show;
Begin
     End;

Procedure WhereIs.Search;
Begin
     End;

Procedure WhereIs.Show;
Begin
     End;

Begin
     B.Init;
     S.Init;
     S.Which;
     Clrscr;
     Window(1,1,80,25);
     Clrscr;
     End.

