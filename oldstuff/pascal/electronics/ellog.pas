Program ElectroLog;

Uses Crt;

Const
     Num : Integer = 0;

Type
       Banner = Object
                Procedure Init;
                End;

       Memoire = Array [1..1024] of char;
       Pobjet = ^Objet;
       Objet  = Record
                P : ^Memoire;
                N : String[12];
                C : Word;
                End;

       Edite  = Object
                Procedure Monte;
                Procedure Descend;
                Procedure Gauche;
                Procedure Droite;
                Procedure Clavier;
                Procedure ClavSpec;
                Procedure TakeIt;
                Procedure BackSpace;
                Procedure EnMemoire;
                Procedure Erreur(A:String);
                End;

       Menu   = Object(Edite)
                Procedure Edite;
                Procedure Main;
                Procedure Specials;
                Procedure Scrute;
                Procedure Cree;
                Procedure Detruit;
                Procedure Liste;
                Procedure Modifie;
                Procedure Quitte;
                Procedure Regarde_1;
                Procedure Regarde;
                Procedure Sauve;
                Procedure Charge;
                Procedure Resultats;
                Procedure Title (A:String);
                End;

Var      Ban : Banner;
         Men : Menu;
         Nom : String;
           O : Array [1..256] of Pobjet;
           B : Array [1..1024] of char;
         J,I : Integer;
          Ch : Char;
  Terminated : Boolean;
      Alread : Boolean;
       Modif : Boolean;
       Compt : Word;

Procedure Banner.Init;
Begin
     For I:=1 To 256 Do
     Begin
          O[i]:=Nil;
          O[i]^.N:='            ';
          O[i]^.N:='';
          O[i]^.P:=Nil;
          O[i]^.C:=0;
          End;
     End;

Procedure Edite.Monte;
Begin
     If (WhereY>3)  Then Gotoxy(WhereX,WhereY-1);
     Dec(Compt,79);
     End;

Procedure Edite.Descend;
Begin
     If (WhereY<=22) Then Gotoxy(WhereX,WhereY+1);
     Inc(Compt,79);
     End;

Procedure Edite.Gauche;
Begin
     If (Compt>1) Then Dec(Compt,1);
     If (WhereX>1)   Then Gotoxy (WhereX-1,WhereY);
     If (WhereX=1)   and (WhereY>3) Then
                     If (Alread=True) Then Begin
                                           Gotoxy (80,WhereY-1);
                                           Alread:=False;
                                           End
                                           Else Alread:=True;
                     End;

Procedure Edite.Droite;
Begin
     If (Compt<1024) Then Inc(Compt);
     If (WhereX<80)  Then Gotoxy (WhereX+1,WhereY);
     If (WhereX=80)  and (WhereY<22) Then Gotoxy (1,WhereY+1);
     End;

Procedure Edite.ClavSpec;
Begin
     Ch:=Readkey;
     Case Ch of
          #80 : Descend;
          #72 : Monte;
          #75 : Gauche;
          #77 : Droite;
          End;
     End;

Procedure Edite.TakeIt;
Begin
     Write(Ch);
     Inc(Compt);
     If (Compt=1025) Then Erreur('PROCEDURE TROP LONGUE');
     B[Compt]:=Ch;
     End;

Procedure Edite.BackSpace;
Begin
     Dec(Compt);
     Write(' ');
     If (WhereX=1)   and (WhereY>3) Then Begin
                                    Gotoxy (79,WhereY-1);
                                    Exit;
                                    End;
     If (WhereX=2)   and (WhereY>3) Then Begin
                     Gotoxy (80,WhereY-1);
                     Exit;
                     End;
     If (WhereX>2)   Then Gotoxy (WhereX-2,WhereY);
     End;

Procedure Edite.EnMemoire;
Begin
     If (Modif=True) Then Begin
                          O[i]^.C:=Compt;
                          For J:=1 To 1024 Do O[i]^.P^[j]:=B[j];
                          Exit;
                          End;
     O[i]^.C:=Compt;
     GetMem(O[i]^.P,1024);
     For J:=1 To 1024 Do O[i]^.P^[j]:=B[j];
     End;

Procedure Edite.Clavier;
Begin
     Terminated:=False;
     Ch:=Upcase(Readkey);
     If Ch in ['0'..'9','$',';','.','A'..'Z',' ',''''] Then TakeIt;
     Case Ch of
          #27 : Begin Terminated:=True; EnMemoire; Exit; End;
          #10 : Begin Writeln; TakeIt; End;
          #13 : Begin Writeln; TakeIt; End;
          #08 : BackSpace;
          #00 : ClavSpec;
          End;
     If (Terminated=True) Then Exit;
     Clavier;
     End;

Procedure Edite.Erreur (A:String);
Begin
     TextBackground(Red);
     TextColor(White);
     Write(#7);
     Write (A);
     ClrEol;
     TextColor(Yellow);
     TextBackground(Blue);
     Delay(1000);
     End;

Procedure Menu.Quitte;
Begin
     Clrscr;
     For I:=1 To 256 Do
     Begin
          If (O[i]^.P<>Nil) Then
          Begin
               If (Modif=False) Then
               Begin
                    Writeln ('DESTRUCTION : ',O[i]^.N);
                    FreeMem(O[i]^.P,1024);
                    O[i]^.P:=Nil;
                    O[i]:=Nil;
                    End;
               End;
          End;
     Halt(0);
     End;

Procedure Menu.Title(A:String);
Begin
     TextBackGround(Blue);
     Clrscr;
     TextBackGround(7);
     TextColor(Black);
     Write(A);
     ClrEol;
     TextBackground(Blue); TextColor(Yellow);
     Writeln; Writeln;
     End;

Procedure Menu.Edite;
Begin
     If (Modif=False) Then Clrscr;
     Compt:=O[i]^.C;
     For J:=1 To 1024 Do B[j]:=O[i]^.P^[j];
     If (Modif=False) Then Title('EDITION D''UNE PROCEDURE');
     Writeln;
     Clavier;
     Main;
     End;

Procedure Menu.Cree;
Var Done : Boolean;
Begin
     Modif:=False;
     Clrscr;
     Title('CREATION D''UNE PROCEDURE');
     Write ('> ');
     Readln (Nom);
     For I:=1 To Length(Nom) Do Nom[i]:=Upcase(Nom[i]);
     If (Nom='') Then Exit;
     Done:=False;
     For I:=1 To 256 Do
     Begin
          If (O[i]=Nil) Then
          Begin
               If (Done=True) then exit;
               New(O[i]);
               O[i]^.N:=Nom;
               Done:=True;
               End;
          O[i]^.C:=0;
          If (Done=True) then Edite;
          End;
     Main;
     End;

Procedure Menu.Detruit;
Var Destroyed : Boolean;
Begin
     Destroyed:=False;
     Clrscr;
     Title('DESTRUCTION D''UNE PROCEDURE');
     Write ('> ');
     Readln (Nom);
     For I:=1 To Length(Nom) Do Nom[i]:=Upcase(Nom[i]);
     If (Nom='') Then Exit;
     For I:=1 To 256 Do
     Begin
          If (O[i]^.N=Nom) Then
          Begin
               FreeMem(O[i]^.P,1024);
               O[i]^.P:=Nil;
               Dispose(O[i]);
               O[i]:=Nil;
               Destroyed:=True;
               End;
          End;
     If Not Destroyed Then Erreur('PROCEDURE NON TROUVEE');
     Main;
     End;

Procedure Menu.Regarde_1;
Begin
     For I:=1 To 256 Do
     Begin
          If (Nom=O[i]^.N) Then Exit;
          End;
     End;

Procedure Menu.Regarde;
Begin
     Clrscr;
     Title('LISTING D''UNE PROCEDURE');
     Writeln;
     Write ('> ');
     Readln(Nom);
     If (Nom='') Then Exit;
     Regarde_1;
     For J:=1 To O[i]^.C Do
     Begin
          Ch:=O[i]^.P^[j];
          If Ch in [' ','A'..'Z','0'..'9',',','''',';','.'] Then Write(Ch);
          If (Ch=#13) Then Writeln;
          End;
     Ch:=Readkey;
     Main;
     End;

Procedure Menu.Modifie;
Begin
     Modif:=True;
     Clrscr;
     Title('EDITION D''UNE PROCEDURE');
     Write ('> ');
     Readln (Nom);
     If (Nom='') Then Main;
     Regarde_1;
     Clrscr; Gotoxy (1,3);
     For J:=1 To O[i]^.C Do
     Begin
          Ch:=O[i]^.P^[j];
          If Ch in [' ','A'..'Z','0'..'9',',','''',';','.'] Then Write(Ch);
          If (Ch=#13) Then Writeln;
          End;
     GotoXY(1,3);
     Edite;
     Main;
     End;

Procedure Menu.Charge;
Begin
     Clrscr;
     Main;
     End;

Procedure Menu.Sauve;
Begin
     Clrscr;
     Main;
     End;

Procedure Menu.Liste;
Begin
     Clrscr;
     Title('LISTE DES PROCEDURES');
     For I:=1 To 256 Do
     Begin
          If (O[i]<>Nil) Then Writeln(O[i]^.N);
          End;
     Writeln;
     Writeln ('FIN DE LA LISTE');
     Ch:=Readkey;
     Main;
     End;

Procedure Menu.Resultats;
Begin
     Clrscr;
     Main;
     End;

Procedure Menu.Specials;
Begin
     Ch:=Readkey;
     Case ch of
          #59:Cree;
          #60:Detruit;
          #61:Regarde;
          #62:Modifie;
          #63:Charge;
          #64:Sauve;
          #65:Liste;
          #66:Resultats;
          End;
     End;

Procedure Menu.Scrute;
Begin
     Ch:=Upcase(Readkey);
     Case ch of
          #27 : Quitte;
          #0  : Specials;
          End;
     Scrute;
     End;

Procedure Menu.Main;
Begin
     Clrscr;
     Title('Electronic Logo - Copyright (c) 1991. Pascal Munerot ');
     Writeln ('Echelle : 1 point sur l''‚cran --> 1 mm sur le papier');
     Writeln;
     Writeln ('F1. Cr‚er proc‚dure       F2. D‚truire proc‚dure');
     Writeln ('F3. Voir proc‚dure        F4. Modifier proc‚dure');
     Writeln ('F5. Charger proc‚dure     F6. Sauver proc‚dure');
     Writeln ('F7. Liste des proc‚dures  F8. R‚sultat proc‚dure');
     Writeln;
     Writeln ('Instructions en vigueur : ');
     Writeln;
     Writeln ('Nom              ParamŠtres   R‚sultat');
     Writeln ('---------------  ----------   --------');
     Writeln ('AV,AVANCE        n            Avance de n points');
     Writeln ('RE,RECULE        n            Recule de n points');
     Writeln ('TO,TOURNE        n            Tourne de n degr‚s');
     Scrute;
     End;

Begin
     Ban.Init;
     Men.Main;
     End.
