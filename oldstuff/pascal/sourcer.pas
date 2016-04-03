Program Compressed_Source_Lister;

Uses Crt,Dos,Printer;

Type
    Ban    = ^Banner;
    Banner = Object
             Procedure Banner;
             End;

    List   = ^Liste;
    Liste  = Object
             DirInfo:SearchRec;
             F:Text;
             Procedure Liste;
             End;

    Init   = Object
             Procedure Init;
             End;

Var PB : Ban;
    PL : List;
    IT : Init;

Procedure Banner.Banner;
Begin
     Clrscr;
     Writeln ('Listeur de fichiers sources');
     Writeln ('Impression en mode compress‚ uniquement');
     Writeln ('Copyright (c) 1991. Pascal Munerot');
     Writeln;
     End;

Procedure Liste.Liste;
Var Nom : String;
Begin
     If (ParamCount<1) Then
     Begin
          Writeln ('Veuillez pr‚ciser le nom du fichier');
          Halt(1);
          End;
     Nom:=ParamStr(1);
     FindFirst(Nom,0,DirInfo);
     If (DosError<>0) Then
     Begin
          Writeln ('Fichier introuvable');
          Halt(1);
          End;
     Write (Lst,#27+#19);
     Write (Lst,#27+#15);
     Assign (F,Nom);
     Reset (F);
     While Not Eof(F) Do
     Begin
          Readln (F,Nom);
          Writeln (Lst,Nom);
          End;
     Close(F);
     End;

Procedure Init.Init;
Begin
     PB:=New(Ban);
     PB^.Banner;
     Dispose(PB);
     PL:=New(List);
     PL^.Liste;
     Dispose(PL);
     End;

Begin
     It.Init;
     End.
