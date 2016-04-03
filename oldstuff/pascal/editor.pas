Program Editor;

Uses Crt,Dos;

Const  CC : Integer = 1;
       LC : Integer = 1;
    LCMax : Integer = 1;

Type   MemoryArea = Array [1..800] of String[80];
       MemoryPtr  = ^MemoryArea;

       Init       = Object
                    Constructor Init;
                    Destructor  Done;
                    End;

       Edit       = Object
                    X,Y : Integer;
                    Ins : Boolean;
                      F : Text;
                    Nom : String;

                    Procedure Edit; {proc‚dure principale}

                    Procedure Interp;    {gestion du clavier}
                    Procedure Specials;
                    Procedure Gauche;
                    Procedure Droite;
                    Procedure Monte;
                    Procedure Descend;
                    Procedure PageDown;
                    Procedure PageUp;

                    Procedure DeleteCar;
                    Procedure InsertMode;

                    Procedure StatusLine;     {proc‚dures de gestion de}
                    Procedure EditorScreen;   {la barre de menu et de statut}

                    Procedure Sauve;
                    Procedure Charge;
                    End;

Var    Mem : MemoryPtr;
        It : Init;
        Ch : Char;
       Edt : ^Edit;
         I : Integer;

Constructor Init.Init;
Begin
     Mem:=Nil;
     Mem:=New(MemoryPtr);
     If (Mem=Nil) Then Begin Writeln ('Erreur d''allocation m‚moire');
                             Halt(0); End;

     New(Edt);
     Edt^.Edit;
     End;

Destructor  Init.Done;
Begin
     Dispose(Mem);
     Dispose(Edt);
     End;

Procedure Edit.Sauve;
Begin
     StatusLine; Writeln;
     EditorScreen; Clrscr;
     Assign (F,Nom);
     For I:=1 To LC Do Writeln (F,Mem^[I]);
     Close(F);
     End;

Procedure Edit.Charge;
Begin
     StatusLine;
     Write ('Nom de fichier : ');
     Read(Nom);
     EditorScreen;
     Assign (F,Nom);
     Reset(F);
     LC:=1;
     While Not Eof(F) Do Begin Inc(LCMax); Readln(F,Mem^[LCMax]); End;
     Close(F);
     For I:=1 To 22 Do Writeln (Mem^[I]);
     Gotoxy(1,1);
     End;

Procedure Edit.Monte;
Begin
     If (LC=1) Then Exit;
     If (WhereY=1) Then Begin InsLine; Dec(LC); Exit; End;
     Gotoxy (WhereX,WhereY-1); Dec(LC);
     End;

Procedure Edit.Descend;
Begin
     If (LC=LCMax) Then Exit;
     If (WhereY>21) Then Begin X:=WhereX; Y:=WhereY;
                               Gotoxy(1,1); DelLine;
                               Gotoxy(X,Y); Inc(LC); Exit; End;
     Gotoxy (WhereX,WhereY+1); Inc(LC);
     End;

Procedure Edit.Gauche;
Begin
     If (WhereX=1) Then Begin Monte; Gotoxy (80,WhereY);
                              CC:=80; Dec(LC); Exit; End;
     Gotoxy (WhereX-1,WhereY);
     Dec(CC);
     End;

Procedure Edit.Droite;
Begin
     If (WhereX=80) Then Begin Descend; Gotoxy (1,WhereY);
                         CC:=1; Inc(LC); Exit; End;
     Gotoxy (WhereX+1,WhereY);
     Inc(CC);
     End;

Procedure Edit.PageDown;
Begin
     If (WhereY+12<22) Then Begin Gotoxy (WhereX,WhereY+12); End
     Else Begin X:=12-(22-WhereY); For I:=1 To X Do Descend; End;
     End;

Procedure Edit.PageUp;
Begin
     If (WhereY-12>0) Then Begin Gotoxy (WhereX,WhereY-12); End
     Else Begin X:=12-WhereY; Gotoxy (WhereX,1); For I:=1 To X Do Monte; End;
     End;

Procedure  Edit.DeleteCar;
Begin
     End;

Procedure  Edit.StatusLine;
Begin
     Window (1,24,80,25); TextBackground(White); TextColor(Black);
     End;

Procedure  Edit.EditorScreen;
Begin
     Window(1,2,80,23); TextBackground(Blue); TextColor(White);
     End;

Procedure  Edit.InsertMode;
Begin
     If (Ins=True) Then Ins:=False Else Ins:=True;
     StatusLine; Writeln;
     If (Ins=True) Then Write('Insert    ') Else Write('OverWrite ');
     EditorScreen;
     End;

Procedure  Edit.Specials;
Begin
     Ch:=Readkey;
     {Write(Ord(Ch));}
     Case Ch of
          #59 : Charge;
          #60 : Sauve;
          #71 : Gotoxy (1,1);
          #82 : InsertMode;
          #83 : DeleteCar;
          #81 : PageDown;
          #73 : PageUp;
          #72 : Monte;
          #80 : Descend;
          #75 : Gauche;
          #77 : Droite;
          End;
     End;

Procedure  Edit.Interp;
Label Back;
Begin
Back :
     Ch:=Readkey;
     Case Upcase(Ch) of
          #9   : Write('        ');
          #27  : Exit;
          #10  : Writeln;
          #13  : Writeln;
          #0   : Specials;
          Else Write(Ch);
          End;
     Goto Back;
     End;

Procedure  Edit.Edit;
Begin
     Window(1,1,80,2); TextBackground(White); TextColor(Black); Clrscr;
     Writeln ('Condor Text 1.0 - Pascal Munerot - 1991');
     StatusLine; Clrscr;
     Writeln('');
     EditorScreen;
     Clrscr;
     Interp;
     Window(1,1,80,25);
     End;

Begin
     Clrscr;
     It.Init;
     It.Done;
     End.


