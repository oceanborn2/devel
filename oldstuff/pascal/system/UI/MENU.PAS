Unit MenuMan;

Interface

Uses Crt;

Type

    Proc = Procedure;
    ProcPtr = ^Proc;
    Menu = Object
           Sg  : Word; {segment de la carte vid‚o}
           L   : Byte; {longueur d'une option}
           AuB : Integer; {autre que premier car - couleur du fond}
           AuF : Integer; {autre que premier car - couleur ‚criture}
           PrB : Integer; {premier car           - couleur du fond}
           PrF : Integer; {premier car           - couleur ‚criture}
           Cpt : Integer; {nombre d'options}
           O   : Array [1..16] of ^String;  {buffer pour une option}
           P   : Array [1..16] of ProcPtr;  {pointeur proc pour une option}
           X   : Array [1..16] of Byte; {abcisse d'une option}
           Y   : Array [1..16] of Byte; {ordonn‚e d'une option}
           Procedure Init; {valeurs par d‚fauts}
           Procedure SetSeg(S:Word);
           Procedure SetColors(PF,PB,AF,AB  : Byte); {change les couleurs}
           Procedure AddOpt(A  : String; XX,
                            YY : Byte; Adr  : ProcPtr); {ajoute une option}
           Procedure DispMenu; {‚x‚cution du menu}
           Procedure SaveScreen(X1,Y1,X2,Y2 : Integer; PS:Pointer);
           Procedure RestScreen(X1,Y1,X2,Y2 : Integer; PS:Pointer);
           End;

Implementation

Var I  : Integer;
    Cx : Char;

Procedure Menu.Init;
Begin
     Sg:=$B800;
     Prf:=1; Prb:=2;
     Auf:=3; Aub:=4;
     Cpt:=0;
     For I:=1 To 16 Do
     Begin
          O[i]:=Nil;
          P[i]:=Nil;
          End;
     End;

Procedure Menu.AddOpt(A:String; XX,YY : Byte; Adr : ProcPtr);
Begin
     Inc(Cpt);
     If Cpt=17 Then Begin Writeln ('trop d''options pour ce menu');
                          Halt(1);
                          End;
     GetMem(O[Cpt],(Length(A)*2)+1);
     If O[Cpt]=Nil Then Begin Writeln ('Erreur de gestion m‚moire ');
                              Halt(1);
                              End;

     O[cpt]^[2]:=Chr(Prb*16+Prf);
     O[cpt]^[3]:=A[1];
     For I:=4 To Length(A)*2 Do
     Begin
          O[cpt]^[i]:=Chr(AuB*16+Auf);
          Inc(I);
          O[cpt]^[i]:=A[i];
          End;
     For I:=Length(A)*2+1 To L Do
     Begin
          O[cpt]^[i]:=Chr(AuB*16+Auf);
          Inc(I);
          O[cpt]^[i]:=' ';
          End;
     P[Cpt]:=Adr;
     X[Cpt]:=XX; Y[Cpt]:=YY;
     End;

Procedure Menu.SetSeg(S : Word);
Begin
     Sg:=S;
     End;

Procedure Menu.SetColors(PF,PB,AF,AB : Byte);
Begin
     Prf:=Pf; Prb:=Pb; Auf:=Af; Aub:=Ab;
     End;

Procedure Menu.DispMenu;
Begin
     For I:=1 To Cpt Do
     Begin
          End;
     End;

Procedure Menu.SaveScreen(X1,Y1,X2,Y2 : Integer; PS:Pointer);
Begin
     End;

Procedure Menu.RestScreen(X1,Y1,X2,Y2 : Integer; PS:Pointer);
Begin
     End;

Begin
     End.
