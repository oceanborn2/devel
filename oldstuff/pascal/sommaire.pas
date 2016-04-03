Program Sommaire;

Uses Crt,Dos;

{$M 16384,0,350000}
{$F+}

Const
      MaxMen = 4;
          Mn : Array [1..MaxMen] of String = ('NUMERO','THEME','TITRE','QUITTER');
          C4 : Char=#227;
  BreakFlag  : Boolean=False;
         C10 : Char=#245;
       Posit : Array [1..MaxMen] of Integer = (1, 17, 34, 51);
          C8 : Char=#214;
         C11 : Char=#229;
          Ps : Integer = 0;
          C2 : Char=#243;
         C12 : Char=#231;
  KeyStriken : Boolean=True;
          C5 : Char=#244;
         C13 : Char=#234;
          C7 : Char=#242;
       Ecart : Integer = 17;
          C3 : Char=#232;
          C6 : Char=#233;
    FileName : String='ELEX.DAT';
          C1 : Char=#203;
      First  : Boolean=True;
          C9 : Char=#231;
      MaxLines = 8192;
      MaxRub : Integer= 0;

Type

    S = ^String;
    SR = String[20];
    SRPtr = ^SR;
    Z = Array [1..MaxLines] of S;
    Ecran = Array [1..4000] of Byte;

    BannerPtr=^Banner;
    Banner   = Object
               X:Integer;
               Y:Integer;
               F:Text;
               Procedure Config;
               Function  SaveScreen:Pointer;
               Function  UpcaseStr(S:String):String;
               Procedure RestoreScreen;
               Procedure Banner;
               Procedure Abort;
               Procedure Bip;
               Procedure Title     (A : String);
               Procedure CenterLn  (A : String);
               Procedure JumpLines (N : Integer);
               Procedure ClearLine;
               End;

    SommairPtr=^Sommair;
    Sommair  = Object(Banner)
               Max : Integer;
               Procedure Escape;
               Function  SkipBlanks(W:String):String;
               Procedure DWrite(A:String);
               Procedure DWriteln (A:String);
               Procedure ClearLinesToEnd;
               Procedure ClearLinesToEnd_Prime;
               Procedure Explanations;
               Function  ExtractNumber:Integer;
               Procedure StockNumero;
               Procedure ReadFile;
               Procedure Sommair;
               Procedure Terminate;
               Procedure Menu;
               Procedure Spec;
               Procedure Interp;
               Procedure NumberSearch;
               Procedure ThematicSearch;
               Procedure TitleSearch;
               Procedure Accept;
               End;

    Init     = Object
               Procedure Init;
               End;

Var                BP : BannerPtr;
                   SM : SommairPtr;
                  INT : Init;
            Int1BSave : Pointer;
                   CH : Char;
                   ST : Z;
                  J,I : Integer;
       EcranPtr       : ^Ecran;
       ColorScreen    : Boolean;
       LastNumber     : Integer;
       LastLine       : Integer;
       DirInfo        : SearchRec;
       EndOfProccess  : Boolean;
       Commentary     : Boolean;
       Num            : Array [1..256] of integer;
       Rubr           : Array [1..256] of SRPtr;

Procedure BreakHandler; interrupt;
Begin
    BreakFlag := True;
    End;

Procedure Init.Init;
Begin
     New(BP);
     BP^.Config;
     EcranPtr:=BP^.SaveScreen;
     BP^.Banner;
     New(SM);
     SM^.Sommair;
     Dispose(SM);
     BP^.Abort;
     Dispose(BP);
     End;

Procedure Banner.Config;
Var S : String;
Begin
     Assign (F,'SOMMAIRE.SYS');
     Reset(F);
     Readln(F,Mn[1]);
     Readln(F,Mn[2]);
     Readln(F,Mn[3]);
     Readln(F,Mn[4]);
     Readln(F,S);
     For I:=1 To Length(S) Do S[i]:=Upcase(S[i]);
     If (Pos('COULEUR',S)>0) Then ColorScreen:=True Else ColorScreen:=False;
     If Not Eof(F) Then Readln(F,FileName);
     Close(F);
     For I:=1 To 256 Do Num[i]:=0;
     For I:=1 To MaxMen Do
     Begin
          For J:=1 To Length(Mn[i]) Do
          Begin
               If Not (Mn[i,j] in ['A'..'Z']) Then Delete(Mn[i],j,1);
               End;
          End;
     End;

Function  Banner.SaveScreen:Pointer;
Begin
     New(EcranPtr);
     If (EcranPtr=Nil) Then SaveScreen:=Nil;
     If (ColorScreen=True) Then Move (Mem[$B800:0],EcranPtr^,4000)
                           Else Move (Mem[$B000:0],EcranPtr^,4000);
     SaveScreen:=EcranPtr;
     X:=WhereX; Y:=WhereY;
     End;

Function   Banner.UpCaseStr(S:String):String;
Var Compteur : Integer;
Begin
     For Compteur:=1 To Length(S) Do
     Begin
          S[Compteur]:=Upcase(S[Compteur]);
          If (S[Compteur]='‚') or (S[Compteur]='Š') or (S[Compteur]='‰') Then S[Compteur]:='E';
          If (S[Compteur]='…') or (S[Compteur]='„') or (S[Compteur]='ƒ') then S[Compteur]:='A';
          End;
     UpCaseStr:=S;
     End;

Procedure  Banner.RestoreScreen;
Begin
     If (EcranPtr=Nil) Then Exit;
     If (ColorScreen=True) Then Move (EcranPtr^,Mem[$B800:0],4000)
                           Else Move (EcranPtr^,Mem[$B000:0],4000);
     Gotoxy(X,Y);
     End;

Procedure Banner.ClearLine;
Var XA,YA : Integer;
Begin
     XA:=WhereX; YA:=WhereY;
     Write('                                                                                ');
     Gotoxy(XA,YA);
     End;

Procedure Banner.Banner;
Begin
     TextBackground(Blue);
     TextColor(Blue);
     Clrscr;
     JumpLines(10);
     TextBackground(White);
     CenterLn ('                                  ');
     CenterLn ('  Gestionnaire de sommaires ELEX  ');
     CenterLn ('                                  ');
     CenterLn ('       Pascal Munerot.1991        ');
     CenterLn ('                                  ');
     TextBackground(blue);
     TextColor(Yellow);
     JumpLines(9);
     End;

Procedure Banner.Title(A:String);
Begin
     TextBackground(White); TextColor(Blue);
     Write(' '); ClrEol; Gotoxy(1,WhereY);
     Writeln (A);
     TextColor(Yellow);  TextBackground(Blue);
     End;

Procedure Banner.Bip;
Var Compteur : Integer;
Begin
     For Compteur:=1 To 10 Do
     Begin
          Sound(1000+Compteur*1000);
          Delay(20);
          End;
     NoSound;
     End;

Procedure Banner.CenterLn (A:String);
Var I : Integer;
Begin
     I:=(80-Length(A)) div 2;
     Gotoxy (I,WhereY);
     Writeln (A);
     End;

Procedure Banner.JumpLines(N:Integer);
Var Compteur : Integer;
Begin
     For Compteur:=1 To N Do Writeln;
     End;

Procedure Banner.Abort;
Begin
     Clrscr;
     JumpLines(10);
     CenterLn ('Gestionnaire de sommaires');
     Writeln;
     CenterLn ('Pascal Munerot.1991');
     Writeln;
     CenterLn ('A BIENTOT');
     If (EcranPtr<>Nil) Then RestoreScreen;
     Dispose(EcranPtr);
     Gotoxy(X,Y);
     SetIntVec($1B,Int1BSave);
     Halt(0);
     End;

Procedure Sommair.Accept;
Begin
     Case PS of
          1 : NumberSearch;
          2 : ThematicSearch;
          3 : TitleSearch;
          4 : Begin terminate; Abort; End;
          End;
     End;

Procedure Sommair.Escape;
Begin
     EndOfProccess:=False;
     If Not KeyPressed Then Exit;
     Ch:=Readkey;
     If (Ch=#27) Then EndOfProccess:=True;
     End;

Procedure Sommair.Spec;
Begin
     Ch:=Readkey;
     Gotoxy (Posit[ps],2);
     Write(Mn[ps]);
     Case ord(ch) of
          77 : Begin Inc(PS);
                     If (PS>MaxMen) Then PS:=1;
                     End;
          75 : Begin Dec(PS);
                     If (PS<1) Then PS:=MaxMen;
                     End;
          End;
     TextBackground(Blue); TextColor(Yellow);
     Gotoxy (Posit[ps],2);
     Write(Mn[ps]);
     Textcolor(Blue); TextBackground(White);
     End;

Procedure Sommair.Interp;
Begin
     If (First=True) Then Begin
                                TextBackground(blue);
                                First:=False;
                                Write('                                                                                ');
                                Write('                                                                                ');
                                TextBackground(White);
                                End;
     Ch:=Readkey;
     Case Ord(Ch) of
          0 : Spec;
         13 : Accept;
          Else Bip;
          End;
     Interp;
     End;

Function  Sommair.ExtractNumber:Integer;
Var S : String;
    W : Integer;
    C : Integer;
Begin
     S:=ST[i]^;
     Delete(S,1,6);
     Val (S,W,C);
     ExtractNumber:=W;
     End;

Procedure Sommair.DWrite(A:String);
Begin
     If (WhereY<7) Then Gotoxy (1,7);
     If (WhereY>19) Then
                    Begin
                         Ch:=Readkey;
                         Gotoxy (1,7);
                         ClearLine; Writeln;
                         End;
     Write(A); ClrEol;
     End;

Procedure Sommair.DWriteln(A:String);
Begin
     DWrite(A); Writeln;
     End;

Procedure Sommair.Explanations;
Var S : String;
Begin
     While Not (ST[i]^[1]='@') Do
     Begin
          S:=ST[i]^; If (S[1]='_') Then Delete(S,1,1) Else Exit;
          DWriteln (S);
          Inc(I);
          End;
     End;

Procedure Sommair.ClearLinesToEnd_Prime;
Var Compteur : Integer;
Begin
     For Compteur:=3 To 22 Do
     Begin
          ClearLine; Writeln;
          End;
     End;

Procedure Sommair.ClearLinesToEnd;
Var Compteur : Integer;
Begin
     For Compteur:=WhereY To 22 Do
     Begin
          ClearLine; Writeln;
          End;
     Ch:=Readkey;
     End;

Procedure Sommair.NumberSearch;
Var Found : Boolean;
        W : Integer;
       XX : Integer;
    Y1,X1 : Integer;
        S : String;
Begin
     Found:=False;
     TextColor(Yellow); TextBackground(Blue);
     Gotoxy (1,3);
     ClearLinesToEnd_Prime;
     Gotoxy (1,5);
     ClearLine; Writeln;
     ClearLine; Writeln;
     ClearLine; Writeln;
     Gotoxy (3,5);
     Write ('> ');
     Readln(XX);
     If (XX=0) Then Exit;
     If (Num[XX]=0) Then Exit;
     For I:=Num[XX] To Max Do
     Begin
          Escape;
          If (EndOfProccess=True) Then Exit;
          If (I>Max) Then Exit;
          X1:=WhereX; Y1:=WhereY; Gotoxy (70,4); Write(I,'   ');
          Gotoxy (X1,Y1);
          If (Pos('NUMERO',ST[I]^)>0) Then
          Begin
               W:=ExtractNumber;
               LastNumber:=W;
               If (W=XX) Then Found:=True Else Found:=False;
               Inc(I);
               End;
          Escape;
          If (EndOfProccess=True) Then Exit;
          If (LastNumber>XX) Then Found:=False;
          If (Found=True) Then Begin
                               Bip;
                               Gotoxy (1,7);
                               DWrite   (ST[i]^+' : ');  {thŠme}
                               Inc (I);
                               DWriteln (ST[i]^);        {nom de l'article}
                               Inc (I);
                               S:=ST[i]^; Delete(S,1,1);
                               DWriteln ('Page(s) : '+S);
                               Inc(I);
                               Explanations;
                               ClearLinesToEnd;
                               If (Ch=#0) Then Ch:=Readkey;
                               If (ST[i+1]^[1]='@') And (ST[i+1]^[2]='@') Then
                               Begin ClearLinesToEnd; Exit; End;
                               End;
          Escape;
          If (EndOfProccess=True) Then Exit;
          End;
     TextColor(Blue); TextBackground(White);
     End;

Procedure Sommair.ThematicSearch;
Var   WW : String;
   Y1,X1 : Integer;
       S : String;
Begin
     TextColor(Yellow); TextBackground(Blue);
     Gotoxy (1,3);
     ClearLinesToEnd_Prime;
     Gotoxy (1,5); Write(''); ClrEol;
     Write ('> ');
     ClearLine; Writeln;
     ClearLine; Writeln;
     ClearLine; Writeln;
     Gotoxy (3,5);
     Readln(WW);
     WW:=UpcaseStr(WW);
     For I:=1 To Max Do
     Begin
          Escape;
          X1:=WhereX; Y1:=WhereY; Gotoxy (70,4); Write(I,'   ');
          Gotoxy (X1,Y1);
          If (Pos('NUMERO',ST[I]^)>0) Then
          Begin
               LastNumber:=ExtractNumber;
               Inc(I);
               End;
          LastLine:=I;
          Escape;
          If (EndOfProccess=True) Then Exit;
          If (I>Max) Then Exit;
          If (POS(WW,ST[i]^)>0) And (ST[i]^[1]='#') Then
          Begin
               Bip;
               Gotoxy(1,7);
               Write('NUMERO ',LastNumber); Writeln;
               I:=LastLine;
               DWrite   (ST[i]^+' : ');  {thŠme}
               Inc (I);
               DWriteln (ST[i]^);      {nom de l'article}
               Inc (I);
               S:=ST[i]^; Delete(S,1,1);
               DWriteln ('Page(s) : '+S);
               Inc(I);
               Explanations;
               ClearLinesToEnd;
               If (Ch=#0) Then Ch:=Readkey;
               Escape;
               If (EndOfProccess=True) Then Exit;
               End;
               Escape;
               If (EndOfProccess=True) Then Exit;
          End;
     TextColor(Blue); TextBackground(White);
     End;

Function  Sommair.SkipBlanks(W:String):String;
Begin
     While (W[1]=#9) or (W[1]=' ') Do Delete(W,1,1);
     SkipBlanks:=W;
     End;

Procedure Sommair.TitleSearch;
Var   WW : String;
   Y1,X1 : Integer;
       S : String;
Begin
     TextColor(Yellow); TextBackground(Blue);
     Gotoxy (1,3);
     ClearLinesToEnd_Prime;
     Gotoxy (1,5); Write(''); ClrEol;
     Write ('> ');
     ClearLine; Writeln;
     ClearLine; Writeln;
     ClearLine; Writeln;
     Gotoxy (3,5);
     Readln(WW);
     WW:=SkipBlanks(WW);
     WW:=UpCaseStr(WW);
     EndOfProccess:=False;
     For I:=1 To Max Do
     Begin
          Escape;
          If (EndOfProccess=True) Then Exit;
          X1:=WhereX; Y1:=WhereY; Gotoxy (70,4); Write(I,'   ');
          Gotoxy (X1,Y1);
          If (ST[i]^[1]='@') And (ST[i]^[2]='@') Then Inc(I);
          If (Pos('NUMERO',ST[I]^)>0) Then
          Begin
               LastNumber:=ExtractNumber;
               Inc(I);
               End;
          LastLine:=I;
          Inc (I);
          If (ST[i]^[1]='&') Then Begin Dec(I); Commentary:=True; End Else Commentary:=False;
          Escape;
          If (EndOfProccess=True) Then Exit;
          If (I>Max) Then Exit;
          If (POS(WW,ST[i]^)>0) And (ST[i]^[1]<>'#') Then
          Begin
               Bip;
               Gotoxy (1,7);
               If (ST[i]^[1]='@') And (ST[i]^[2]='@') Then Inc(I);
               Write('NUMERO ',LastNumber); Writeln;
               I:=LastLine;
               If (Commentary=True) Then Dec(I);
               DWrite   (ST[i]^+' : ');  {thŠme}
               Inc (I);
               DWriteln (ST[i]^);        {nom de l'article}
               Inc (I);
               S:=ST[i]^; Delete(S,1,1);
               DWriteln ('Page(s) : '+S);
               Inc(I);
               Explanations;
               ClearLinesToEnd;
               If (Ch=#0) Then Ch:=Readkey;
               End;
          Escape;
          If (EndOfProccess=True) Then Exit;
          End;
     TextColor(Blue); TextBackground(White);
     End;

Procedure Sommair.Menu;
Var A : String;
Begin
     Clrscr;
     C1:=Chr(Ord(C1) xor 251 xor 13 xor 112);
     C2:=Chr(Ord(C2) xor 251 xor 13 xor 112);
     C3:=Chr(Ord(C3) xor 251 xor 13 xor 112);
     C4:=Chr(Ord(C4) xor 251 xor 13 xor 112);
     C5:=Chr(Ord(C5) xor 251 xor 13 xor 112);
     C6:=Chr(Ord(C6) xor 251 xor 13 xor 112);
     C7:=Chr(Ord(C7) xor 251 xor 13 xor 112);
     C8:=Chr(Ord(C8) xor 251 xor 13 xor 112);
     C9:=Chr(Ord(C9) xor 251 xor 13 xor 112);
     C10:=Chr(Ord(C10) xor 251 xor 13 xor 112);
     C11:=Chr(Ord(C11) xor 251 xor 13 xor 112);
     C12:=Chr(Ord(C12) xor 251 xor 13 xor 112);
     C13:=Chr(Ord(C13) xor 251 xor 13 xor 112);
     A:=C8+C9+C10+C11+C12;
     A:=A+C13+' '+C1+C2+C3+C4+C5+C6+C7;
     Title('Sommaire ELEX - Menu principal. '+A+' 1991.');
     TextBackground(White); TextColor(Blue); Gotoxy(1,2); ClearLine;
     For I:=1 To MaxMen Do Begin Gotoxy((i-1)*Ecart,2); Write(Mn[i]); End;
     Repeat
           Write(' ');
           Until (WhereX=80);
     I:=WhereX; J:=WhereY;
     TextBackground(Blue);
     Write ('                                                                                                             ');
     Write ('                                                                                                             ');
     TextBackground(White);
     Gotoxy (I,J);
     Interp;
     End;

Procedure Sommair.StockNumero;
Var SX : String;
    XX : Integer;
    YY : Integer;
Begin
     SX:=St[Max]^;
     While Not (SX[1] in ['0'..'9']) Do Delete(SX,1,1);
     Val(SX,XX,YY);
     Num[XX]:=Max;
     End;

Procedure Sommair.ReadFile;
Begin
     Max:=0;
     TextColor(Blue+16);
     TextBackground(White);
     Bip;
     Write('Lecture du fichier ',FileName,' en cours ...'); ClrEol;
     TextColor(Yellow);
     TextBackground(Blue);
     Assign (F,FileName);
     Reset(F);
     While Not Eof (F) Do
     Begin
          If (Max=MaxLines+1) Then Begin Close(F); Abort; End;
          Inc(Max);
          New(ST[Max]);
          If (ST[Max]=Nil) Then Terminate;
          Readln (F,ST[Max]^);
          If (Pos('NUMERO',ST[Max]^)>0) Then StockNumero;
          End;
     Close(F);
     End;

Procedure Sommair.Terminate;
Begin
     For I:=1 To Max Do Begin Dispose(ST[i]); St[i]:=Nil; End;
     End;

Procedure Sommair.Sommair;
Begin
     ReadFile;
     Menu;
     ch:=readkey;
     Terminate;
     End;

Begin
     GetIntVec($1B,Int1BSave);
     SetIntVec($1B,Addr(BreakHandler));
     Int.Init;
     End.
