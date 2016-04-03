Program MasterMind_Codeur;

Uses Crt,Dos,Analyse,Win,WinExt;

Type Banner = Object
     Procedure Banner;
     End;

     Game = Record
          Jeu:Array [1..4] of Byte;
          End;

     Players = Object
     Gagne:Boolean;
     Ans:String;
     Ctr:Array [1..4] of boolean;
     Jeu:Game;
     Rep:Game;
     Nombre:Integer;
     Plays:Integer;
     Nom:Array [1..128] of String[20];
     Scr:Array [1..128] of Integer;
     Procedure Init;
     Procedure _GetNames;
     Procedure GetNames;
     Procedure PlaysNumber;
     Procedure Play;
     Procedure PlayAGame;
     Procedure WhichPlay;
     Procedure ANewGame;
     Procedure GameBoard;
     Procedure Teste;
     Procedure Corrige;
     Procedure Interprete;
     Procedure Readline;
     Procedure GreatSound(A:Integer);
     Procedure HeWon;
     Procedure SetIt(A:Integer);
     Procedure SemiFound(KK,VAL,NUM:Integer);
     Procedure Found;
     Procedure ShowScore;
     End;

Var
   I,J,K,Z : Integer;
   Ch      : Char;

   Ban     : Banner;
   Play    : Players;

   NbrTr   : Array [0..5] Of Integer;
   NbrPr   : Array [0..5] Of Integer;

Procedure Title(A:String);
Begin
     TextBackGround(Black);
     Clrscr;
     TextBackground(Blue);
     ClrEol;
     TextColor(Yellow);
     Writeln(A);
     TextColor(White);
     TextBackGround(Black);
     End;

Procedure Banner.Banner;
Begin
     Title('Mastermind Codeur - Copyright (c) 1990. Pascal Munerot ');
     End;

Procedure Players.Init;
Begin
     For I:=1 To 128 Do
     Begin
          Nom[I]:='';
          Scr[I]:=0;
          End;
     End;

Procedure Players._GetNames;
Begin
     Nombre:=0;
     For I:=1 To 128 Do
     Begin
          Gotoxy (1,3);
          Writeln ('Joueur n ø ',i);
          Gotoxy (1,5); ClrEol;
          Readln(Nom[I]);
          If (Nom[I]='') then Exit;
          Inc(Nombre);
          End;
     Randomize;
     End;

Procedure Players.GetNames;
Var X:Integer;
Begin
     X:=0;
     _GetNames;
     TopWindow:=Nil;
     ActiveWindow(True);
     OpenWindow(1,3,80,21,' Liste des joueurs ',Yellow,White);
     TextBackground(Blue); Clrscr;
     For I:=1 To Nombre Do
     Begin
          If (X=3) then Begin X:=0; Writeln; End;
          Gotoxy(X*20+4,WhereY);
          Nom[i]:=UpString(Nom[i]);
          Write(Nom[i]);
          Inc(X);
          If (WhereY=19) Then Begin Ch:=Readkey; Clrscr; End;
          End;
     Ch:=Readkey;
     CloseWindow;
     Clrscr;
     End;

Procedure Players.PlaysNumber;
Begin
     Title('Nombre de parties par joueur ');
     Writeln;
     Write('> ');
     Readln(Plays);
     Clrscr;
     Title('Mastermind Codeur - Copyright (c) 1990. Pascal Munerot ');
     End;

Procedure Players.WhichPlay;
Var S1,S2:String;
Begin
     Str(I,S1);
     Str(Scr[J],S2);
     Title('Joueur  : '+Nom[J]+'   Partie n ø '+S1+'    Score : '+S2);
     End;

Function Aleat:Integer;
Begin
     Aleat:=Round(Random(6));
     End;

Procedure Players.GreatSound(A:Integer);
Begin
     Sound(900*A); Delay (100); NoSound;
     End;

Procedure Players.ANewGame;
Begin
     For K:=1 To 4 Do Jeu.Jeu[K]:=Aleat;
     End;

Procedure Players.GameBoard;
Begin
     Gagne:=False;
     OpenWindow(5,5,75,20,'>>> MasterMind <<<',Yellow,White);
     WhichPlay;
     Writeln;
     TextBackground(7);
     Gotoxy(3,WhereY);
     Writeln ('                                    ');
     For K:=1 To 5 Do
     Begin
          Gotoxy (3,WhereY);
          Writeln ('  x   x   x   x      x   x   x   x  ');
          Gotoxy (3,WhereY);
          Writeln('                                    ');
          End;
     TextBackground(White);
     Gotoxy (50,4); Write('0=Rouge , 1=Noir  ');
     Gotoxy (50,5); Write('2=Blanc , 3=Bleu  ');
     Gotoxy (50,6); Write('4=Jaune , 5=Vert  ');
     End;

Procedure Players.PlayAGame;
Begin
     GameBoard;
     ANewGame;
     Teste;
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Players.Play;
Begin
     For I:=1 To Plays Do
     Begin
          For J:=1 To Nombre Do
          Begin
               PlayAGame;
               End;
          End;
     End;

Procedure Players.SetIt(A:Integer);
Begin
     Gotoxy ((K-1)*4+5,Z*2+2);
     Case A Of
          0:Begin TextColor(Red);   Write('0'); End;
          1:Begin TextColor(Black); Write('1'); End;
          2:Begin TextColor(White); Write('2'); End;
          3:Begin TextColor(Blue);  Write('3'); End;
          4:Begin TextColor(14);    Write('4'); End;
          5:Begin TextColor(10);    Write('5'); End;
          End;
     TextColor(White);
     End;

Procedure Players.Interprete;
Begin
     For K:=1 To 4 Do
     Begin
          Case Upcase(Ans[K]) Of
               '0':Begin Rep.Jeu[K]:=0; End;
               '1':Begin Rep.Jeu[K]:=1; End;
               '2':Begin Rep.Jeu[K]:=2; End;
               '3':Begin Rep.Jeu[K]:=3; End;
               '4':Begin Rep.Jeu[K]:=4; End;
               '5':Begin Rep.Jeu[K]:=5; End;
               End;
          SetIt(Rep.Jeu[K]);
          End;
     End;

Procedure Players.ReadLine;
Var Correct:Boolean;
Begin
     Randomize;
     Correct:=True;
     Gotoxy (50,8);
     Write('> ');
     Readln(Ans);
     For K:=1 To 4 Do
     Begin
          Ans[K]:=Upcase(Ans[K]);
          If (Ans[K]<>'0') and (Ans[K]<>'1')
             and (Ans[K]<>'2') and (Ans[K]<>'3')
             and (Ans[K]<>'4') and (Ans[K]<>'5') Then Correct:=False;
         End;
     If Correct=False Then Begin Beep; ReadLine; End;
     GreatSound(1);
     End;

Procedure Players.Teste;
Begin
     For K:=1 To 4 Do Ctr[K]:=False;
     For Z:=1 To 5 Do
     Begin
          If (Gagne=True) Then Exit;
          Ans:='';
          Readline;
          Interprete;
          Corrige;
          End;
     End;

Procedure Players.Found;
Begin
     Randomize;
     Gotoxy (24+(K-1)*4,Z*2+2);
     TextColor(Red);
     Write('x');
     TextColor(White);
     Inc(NbrTr[Rep.Jeu[K]]);
     End;

Procedure Players.HeWon;
Begin
     For K:=1 To 10 Do Begin GreatSound(K); End;
     Inc(Scr[J]);
     Gagne:=True;
     End;

Procedure Players.SemiFound(KK,VAL,NUM:Integer);
Begin
     If (Ctr[NUM]=True) Then Exit;
     Ctr[NUM]:=True;
     If NbrPr[Val]<=NbrTr[Val] Then Exit;
     Dec(NbrPr[Val]);
     Gotoxy (24+(KK-1)*4,Z*2+2);
     TextColor(Green);
     Write('x');
     TextColor(White);
     End;

Procedure Players.Corrige;
Var Correct:Boolean;
Begin
     Correct:=True;
     For K:=0 To 5 Do NbrPr[K]:=0;
     For K:=0 To 5 Do NbrTr[K]:=0;
     For K:=1 To 4 Do Inc(NbrPr[Rep.Jeu[K]]);

     For K:=1 To 4 Do
     Begin
          If (Rep.Jeu[K]=Jeu.Jeu[K]) Then Found Else Correct:=False;
          End;

     If (Correct=True) Then Begin HeWon; Exit; End;

     If (Rep.Jeu[1]=Jeu.Jeu[2]) then SemiFound(1,Jeu.Jeu[2],2);
     If (Rep.Jeu[1]=Jeu.Jeu[3]) then SemiFound(1,Jeu.Jeu[3],3);
     If (Rep.Jeu[1]=Jeu.Jeu[4]) then SemiFound(1,Jeu.Jeu[4],4);

     If (Rep.Jeu[2]=Jeu.Jeu[1]) then SemiFound(2,Jeu.Jeu[1],1);
     If (Rep.Jeu[2]=Jeu.Jeu[3]) then SemiFound(2,Jeu.Jeu[3],3);
     If (Rep.Jeu[2]=Jeu.Jeu[4]) then SemiFound(2,Jeu.Jeu[4],4);

     If (Rep.Jeu[3]=Jeu.Jeu[1]) then SemiFound(3,Jeu.Jeu[1],1);
     If (Rep.Jeu[3]=Jeu.Jeu[2]) then SemiFound(3,Jeu.Jeu[2],2);
     If (Rep.Jeu[3]=Jeu.Jeu[4]) then SemiFound(3,Jeu.Jeu[4],4);

     If (Rep.Jeu[4]=Jeu.Jeu[1]) then SemiFound(3,Jeu.Jeu[1],1);
     If (Rep.Jeu[4]=Jeu.Jeu[2]) then SemiFound(3,Jeu.Jeu[2],2);
     If (Rep.Jeu[4]=Jeu.Jeu[3]) then SemiFound(3,Jeu.Jeu[3],3);

     End;

Procedure Players.ShowScore;
Var Z:Integer;
Begin
     Z:=1;
     OpenWindow(1,1,80,24,'>>> scores <<<',Yellow,White);
     Title('Les scores des diff‚rents joueurs dans l''ordre sont ');
     For I:=1 To 10 Do
     Begin
          For J:=1 To Nombre Do
          Begin
               If (Scr[J]=11-I) Then Begin
                                Gotoxy(2,WhereY);
                                Write ('#',Z);
                                Gotoxy(5,WhereY);
                                Writeln(Nom[J]+'    ',Scr[J]);
                                Inc(Z);
                                If WhereY=24 then Ch:=Readkey;
                                End;
               End;
          End;
     End;

Procedure DoBanner;
Begin
     Randomize;
     Ban.Banner;
     End;

Procedure DoPlay;
Begin
     Randomize;
     Play.Init;
     Play.GetNames;
     Play.PlaysNumber;
     Play.Play;
     Play.ShowScore;
     Ch:=Readkey;
     If (Ch='R') or (Ch='r') then Begin CloseWindow;
                                        CloseWindow;
                                        DoBanner;
                                        DoPlay;
                                        End;
     CloseWindow;
     CloseWindow;
     CloseWindow;
     End;

Begin
     DoBanner;
     DoPlay;
     End.

