Program Attribs;

Uses Crt,Dos;

Const Hide   : Boolean = False;
      Sys    : Boolean = False;
      Arc    : Boolean = False;
      ReadO  : Boolean = False;
      Any    : Boolean = False;

Var Mask     : PathStr;
    Sign     : Array [1..5] of Char;
    DirInfo1 : Searchrec;
    DirInfo2 : Searchrec;
    Ch       : Char;
    Att,Attx : Word;
    F        : File;
    Found    : Boolean;
    OkAttr   : Boolean;

Procedure LitMasque;
Begin
     Write   ('Masque de s‚lection : ');
     Readln(Mask);
     If Mask='' Then Mask:='*.*';
     Writeln;
     End;

Function  Ok : Boolean;
Begin
     Ch:=Readkey;
     If Upcase(Ch)='O' Then
     Begin
          Writeln('OK');
          Ok:=True;
          End Else Begin
                   Writeln;
                   Ok:=False;
                   End;
     End;

Procedure LitAttributs; Forward;

Procedure MontreAttr (Eff,Cf : Boolean);
Begin
     If Eff Then Clrscr;
     Writeln ('Attributs : ');
     If Hide   Then Writeln('CACHE');
     If Sys    Then Writeln('SYSTEME');
     If Any    Then Writeln('TOUT FICHIER');
     If Arc    Then Writeln('ARCHIVE');
     If ReadO  Then Writeln('LECTURE SEULE');
     Writeln;
     If CF Then
     Begin
          Writeln ('Entrez O pour confirmer ou une autre touche pour corriger');
          If Not Ok Then LitAttributs;
          End;
     End;

Procedure LitAttributs;
Begin
     Writeln;
     Writeln ('S‚lection des attributs ');
     Writeln ('Entrez O pour accepter ou une autre touche pour refuser');
     Writeln;
     Write ('CACHE         : ');
     If Ok Then Hide:=True Else Hide:=False;
     Write ('SYSTEME       : ');
     If Ok Then Sys:=True Else Sys:=False;
     Write ('TOUT FICHIER  : ');
     If Ok Then Any:=True Else Any:=False;
     Write ('ARCHIVE       : ');
     If Ok Then Arc:=True Else Arc:=False;
     Write ('LECTURE SEULE : ');
     If Ok Then ReadO:=True Else ReadO:=False;
     MontreAttr(True,True);
     End;

Procedure CalcAttr;
Begin
     Att:=0;
     If Sys   Then Inc(Att,SysFile);
     If Hide  Then Inc(Att,Hidden);
     If ReadO Then Inc(Att,ReadOnly);
     If Any   Then Inc(Att,AnyFile);
     If Arc   Then Inc(Att,Archive);
     End;

Procedure Modifie;
Begin
     Clrscr;
     Writeln ('MODIFICATION DES ATTRIBUTS DE FICHIERS');
     Writeln;
     Write   ('Masque    : ');
     Writeln (Mask);
     MontreAttr(False,False);
     CalcAttr;
     FindFirst(Mask,AnyFile,DirInfo2);
     If DosError <> 0 Then Begin
                                Writeln;
                                Writeln ('PAS DE FICHIERS CORRESPONDANTS ');
                                Exit;
                                End;

     Found:=False;
     While DosError = 0 Do
     Begin
          Found:=True;
          Assign(F,Dirinfo2.Name);
          Writeln (DirInfo2.Name);
          SetFattr(F,0);
          SetFAttr(F,Att);
          FindNext(DirInfo2);
          End;
     If Not Found Then Begin
                            Writeln;
                            Writeln ('PAS DE FICHIERS CORRESPONDANTS');
                            End;
     End;

Procedure AfficheLe;
Begin
     Writeln (DirInfo1.Name);
     Found:=True;
     End;

Procedure Affiche;
Begin
     Clrscr;
     Writeln ('AFFICHAGE DU REPERTOIRE');
     Writeln;
     Write   ('Masque    : ');
     Writeln (Mask);
     MontreAttr(False,False);
     CalcAttr;
     FindFirst(Mask,AnyFile,DirInfo1);
     If DosError <> 0 Then Begin
                                Writeln;
                                Writeln ('PAS DE FICHIERS CORRESPONDANTS ');
                                Halt(1);
                                End;

     Found:=False;
     While DosError = 0 Do
     Begin
          Assign(F,Dirinfo1.Name);
          GetFAttr(F,Attx);
          OkAttr:=True;
          If (Att=0) And (Attx<>0) And (Hide=False) And (Sys=False)
             And (ReadO=False) And (Any=False) And (Arc=False) Then OkAttr:=False;
          If Hide   Then If (Attx And Hidden   <> Hidden)   Then OkAttr:=False;
          If Sys    Then If (Attx And SysFile  <> SysFile)  Then OkAttr:=False;
          If ReadO  Then If (Attx And ReadOnly <> ReadOnly) Then OkAttr:=False;
          If Any    Then If (Attx And AnyFile  <> AnyFile)  Then OkAttr:=False;
          If Arc    Then If (Attx And Archive  <> Archive)  Then OkAttr:=False;
          If OkAttr Then Writeln(Attx,' ',DirInfo1.Name);
          If OkAttr Then Found:=True;
          FindNext(DirInfo1);
          End;
     If Not Found Then Begin
                            Writeln;
                            Writeln ('PAS DE FICHIERS CORRESPONDANTS');
                            End;
     Ch:=Readkey;
     End;

Procedure Option;
Begin
     Writeln;
     Writeln ('Voulez vous (A)fficher un r‚pertoire ou (M)odifier des attributs');
     Ch:=Upcase(Readkey);
     Case Ch of
          'M' : Modifie;
          'A' : Affiche;
          Else Option;
          End;
     End;

Procedure Banner;
Begin
     Clrscr;
     Writeln ('GESTION DES ATTRIBUTS DE FICHIERS');
     Writeln ('Pascal Munerot _ 1991');
     Writeln;
     Writeln;
     LitMasque;
     LitAttributs;
     Option;
     End;


Begin
     Banner;
     End.
