Program Electronic_Draw;

Uses Crt,Graph;

Type           Tools       = Object
                             Procedure CenterLN(A:String; Y:Integer);
                             Procedure InWhite(X,Y:Integer; A:String);
                             Procedure InAWhiteLine(X,Y:Integer; A:String);
                             End;

               Prog        = Object(Tools)
                             Procedure Interp;
                             Procedure Menu;
                             Procedure Terminate;
                             Procedure Banner;
                             Procedure Sauve;
                             Procedure Charge;
                             Procedure Lien;
                             Procedure Quitte;
                             Procedure Retour;
                             Procedure ReDessine;
                             Procedure Efface;
                             Procedure Pastille;
                             End;

Var Card,Mode : Integer;
           Ch : Char;
            P : Prog;

Procedure Tools.CenterLN(A:String; Y:Integer);
Var I:Integer;
Begin
     I:=TextWidth(A);
     I:=640-I;
     I:=I div 2;
     OutTextXY(I,Y,A);
     End;

Procedure Tools.InWhite(X,Y:Integer; A:String);
Begin
     SetColor(1);
     Rectangle(X-2,Y-2,X+TextWidth(A)+2,Y+TextHeight(A)+2);
     FloodFill(X,Y,1); SetColor(0); OutTextXY(X,Y,A);
     SetColor(1);
     End;

Procedure Tools.InAWhiteLine(X,Y:Integer; A:String);
Begin
     SetColor(1);
     Rectangle(X-1,Y-1,635,Y+TextHeight(A)+1);
     FloodFill(X,Y,1); SetColor(0); OutTextXY(X,Y,A);
     SetColor(1);
     End;

Procedure Prog.Banner;
Begin
     Card:=Detect;
     InitGraph(Card,Mode,'');
     SetTextStyle(0,0,1);
     SetColor(1);
     Rectangle(135,70,485,120);
     FloodFill(150,90,1);
     SetColor(0);
     CenterLN('Electronic Drawer',80);
     CenterLN('Copyright (c) 1991. Pascal Munerot',100);
     InAWhiteLine(10,190,'Appuyez sur une touche pour d‚marrer la session ...');
     Ch:=Readkey; ClearDevice;
     End;

Procedure Prog.Interp;
Begin
     Ch:=Upcase(Readkey);
     Case Ch of
          'S':Sauve;
          'C':Charge;
          'Q':Quitte;
          'R':Retour;
          'D':Redessine;
          'E':Efface;
          'P':Pastille;
          'L':Lien;
          End;
     Interp;
     End;

Procedure Prog.Sauve;
Begin
     End;

Procedure Prog.Charge;
Begin
     End;

Procedure Prog.Quitte;
Begin
     End;

Procedure Prog.Retour;
Begin
     End;

Procedure Prog.Redessine;
Begin
     End;

Procedure Prog.Efface;
Begin
     End;

Procedure Prog.Pastille;
Begin
     End;

Procedure Prog.Lien;
Begin
     End;

Procedure Prog.Menu;
Begin
     InAwhiteLine(5,5,'(S)auve  (C)harge  (Q)uitte  (R)etour re(D)essine');
     InAWhiteLine(5,16,'(E)fface  (P)astille  (L)ien');
     Rectangle(3,30,638,199);
     Interp;
     End;

Procedure Prog.Terminate;
Begin
     Ch:=Readkey;
     CloseGraph;
     End;

Begin
     P.Banner;
     P.Menu;
     P.Terminate;
     End.
