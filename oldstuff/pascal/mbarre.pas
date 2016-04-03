Program Menu_Rapide;

Uses Crt;

Const MaxL = 9;
Type  MArray = Array [1..2*MaxL] of Char;

Const Menu : Array [1..10] of String[MaxL]=(' Fichier ',' Editeur ',
                           ' Bureau ',' Option ',' Suivi ',
                           ' Debug ',' Compile ',' Run ',
                           ' Linkeur ',' Quitter ');

      MPtr : Array [1..10] of ^Marray= (NIL,NIL,NIL,NIL,NIL,NIL,NIL,
                                        NIL,NIL,NIL);

      IPtr : Array [1..10] of ^Marray= (NIL,NIL,NIL,NIL,NIL,NIL,NIL,
                                        NIL,NIL,NIL);

      My : Integer = 1;

      YPos : Integer = 160;
      XPos : Integer = 10;
      MultX : Integer = 2;
      MultY : Integer = 2;
Var Ch : Char;
   I,J : Integer;

Procedure Monte;
Begin
     Move(Mptr[MY]^,Ptr($B800,(MY-1)*MultX*XPos+(MY+2)*YPos*MultY)^,2*MaxL);
     Dec(MY);
     If (MY<1) Then MY:=10;
     Move(Iptr[MY]^,Ptr($B800,(MY-1)*MultX*XPos+(MY+2)*YPos*MultY)^,2*MaxL);
     End;

Procedure Descend;
Begin
     Move(Mptr[MY]^,Ptr($B800,(MY-1)*MultX*XPos+(MY+2)*YPos*MultY)^,2*MaxL);
     Inc(MY);
     If (MY>10) Then MY:=1;
     Move(Iptr[MY]^,Ptr($B800,(MY-1)*MultX*XPos+(MY+2)*YPos*MultY)^,2*MaxL);
     End;

Procedure Specials;
Begin
     Ch:=Readkey;
     Case Ord(Ch) of
         72 : Monte;
         80 : Descend;
         End;
     End;

Procedure Terminate;
Begin
     For I:=1 To 10 Do
     Begin
          If (Mptr[I]<>Nil) Then Begin
                            Dispose(MPtr[I]);
                            Dispose(IPtr[I]);
                            Mptr[I]:=Nil;
                            Iptr[I]:=Nil;
                            End;
          End;
     End;

Procedure AfficheMenu;
Begin
     TextBackground(Blue); Clrscr;
     TextBackground(White);
     For I:=1 To 10 Do
     Begin
          Move(Mptr[I]^,Ptr($B800,(MY-1)*MultX*XPos+(I+2)*YPos*MultY)^,2*MaxL);
          End;
     Move(IPtr[1]^,Ptr($B800,(MY-1)*MultX*XPos+3*YPos*MultY)^,2*MaxL);
     End;

Procedure Interp;
Label Boucle;
Begin
Boucle:
     Ch:=Readkey;
     If Ch=#27 Then Exit;
     Case Ch of
          #0  : Specials;
          #13 : Write(#7);
          End;
     Goto Boucle;
     End;

Procedure Prepare;
Var C : Integer;
Begin
     Clrscr;
     For I:=1 To 10 Do
     Begin
          New(Mptr[I]);
          New(Iptr[I]);
          If (MPtr[I]=Nil) Then Begin Writeln('Erreur Pointeur ...'); Halt(1); End;
          If (IPtr[I]=Nil) Then Begin Writeln('Erreur Pointeur ...'); Halt(1); End;
          C:=0;
          For J:=1 To MaxL*2 Do
          Begin
               Inc(C);
               MPtr[I]^[J]:=Menu[I,C];
               IPtr[I]^[J]:=Menu[I,C];
               MPtr[I]^[J+1]:=Chr(White*8);
               IPtr[I]^[J+1]:=Chr(Red*16);
               Inc(J);
               End;
          MPtr[I]^[4]:=Chr(White*8+Red);
          IPtr[I]^[4]:=Chr(Red*16+Black);
          End;
     MPtr[1]^[1]:=' ';
     IPtr[1]^[1]:=' ';
     MPtr[1]^[2]:=Chr(White*8+Red);
     IPtr[1]^[2]:=Chr(8*8+Red);
     End;

Begin
     TextBackGround(Black); TextColor(Yellow);
     Prepare;
     AfficheMenu;
     Interp;
     Terminate;
     End.

