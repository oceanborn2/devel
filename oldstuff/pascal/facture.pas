Program Menu_Rapide;

Uses Crt;

Const MaxL = 10;  {NOMBRE DE CARACTERES MAXIMUM PAR OPTION}
Type  MArray = Array [1..2*MaxL] of Char; {UNE BARRE MENU}

Const Menu : Array [1..10] of String[MaxL]=(' Fichier  ',' Editeur  ',
                           ' Bureau  ',' Option  ',' Suivi  ',
                           ' Debug  ',' Compile  ',' Run  ',
                           ' Linkeur  ',' Quitter  ');   {MENU}

      ScrSeg : Word = $B800;

      MPtr : Array [1..10] of ^Marray= (NIL,NIL,NIL,NIL,NIL,NIL,NIL,
                                        NIL,NIL,NIL);  {ZONE MEMOIRE MENU}

      IPtr : Array [1..10] of ^Marray= (NIL,NIL,NIL,NIL,NIL,NIL,NIL,
                                        NIL,NIL,NIL);
                                        {ZONE MEMOIRE MENU INVERSE}

      My : Integer = 1;                {OPTION COURANTE}

      YPos : Integer = 160;            {GOTOXY(?,YPOS*Y);}
      XPos : Integer = 10;             {GOTOXY(10,?);}

      B_Fore : Integer = White;        {BARRE : AVANT PLAN}
      B_Back : Integer = Red;          {BARRE : ARRIERE PLAN}

      M_Fore : Integer = Black;        {MENU  : AVANT PLAN}
      M_Back : Integer = White;        {MENU  : ARRIERE PLAN}

      BFL_Back : Integer = Red;        {BARRE PREMIERE LETTRE ARRIERE PLAN}
      BFL_Fore : Integer = White;      {BARRE PREMIERE LETTRE AVANT PLAN}

      MFL_Back : Integer = White;      {MENU PREMIERE LETTRE ARRIERE PLAN}
      MFL_Fore : Integer = Red;        {MENU PREMIERE LETTRE AVANT PLAN}

Var Ch : Char;
   I,J : Integer;

Procedure Monte;
Begin
     Move(Mptr[MY]^,Ptr(ScrSeg,XPos+(MY+2)*YPos)^,2*MaxL);
     Dec(MY);
     If (MY<1) Then MY:=10;
     Move(Iptr[MY]^,Ptr(ScrSeg,XPos+(MY+2)*YPos)^,2*MaxL);
     End;

Procedure Descend;
Begin
     Move(Mptr[MY]^,Ptr(ScrSeg,XPos+(MY+2)*YPos)^,2*MaxL);
     Inc(MY);
     If (MY>10) Then MY:=1;
     Move(Iptr[MY]^,Ptr(ScrSeg,XPos+(MY+2)*YPos)^,2*MaxL);
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
     TextColor(Black); Write ('Logiciel de facturation - Pascal Munerot - 29/06/91 ');
     ClrEol;
     For I:=1 To 10 Do
     Begin
          Move(Mptr[I]^,Ptr(ScrSeg,XPos+(I+2)*YPos)^,2*MaxL);
          End;
     Move(IPtr[1]^,Ptr(ScrSeg,XPos+3*YPos)^,2*MaxL);
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
               MPtr[I]^[J+1]:=Chr(M_Back*8+M_Fore);
               IPtr[I]^[J+1]:=Chr(B_Back*16+B_Fore);
               Inc(J);
               End;
          MPtr[I]^[4]:=Chr(MFL_Back*8+MFL_Fore);
          IPtr[I]^[4]:=Chr(BFL_Back*16+BFL_Fore);
          End;
     MPtr[1]^[1]:=' ';
     IPtr[1]^[1]:=' ';
     MPtr[1]^[2]:=Chr(M_Back*8+M_Fore);
     IPtr[1]^[2]:=Chr(B_Back*16+B_Fore);
     End;

Begin
     TextBackGround(Black); TextColor(Yellow);
     Prepare;
     AfficheMenu;
     Interp;
     Terminate;
     End.

