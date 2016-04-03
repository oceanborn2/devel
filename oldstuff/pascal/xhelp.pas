Program XLISP_Help;

Uses Crt,Dos;

Var F        : Text; {fichier d'aide : xlisp.doc dans le path courant}
    Par      : Array [1..8] of String;
    I        : Integer;
    S        : String;

Procedure OpenHelp;
Begin
     Assign (F,'xlisp.doc');
     Reset(F);
     End;

Procedure DispItem;
Begin
     Writeln(S);
     While S<>'' Do
     Begin
          Readln(F,S);
          Writeln (S);
          End;
     Writeln;
     End;

Procedure SearchItems;
Begin
     If ParamCount < 1 Then
     Begin
          Writeln ('il faut donner au moins un critŠre de recherche sous la forme d''une chaine');
          Halt(1);
          End;
     If ParamCount > 8 Then
     Begin
          Writeln ('trop de critŠres de recherches');
          Halt(1);
          End;
     For I:=1 To ParamCount Do Par[i]:=ParamStr(I);
     While Not Eof(F) Do
     Begin
          Readln(F,S);
          For I:=1 To ParamCount Do
               If Pos(Par[i],s)>0 Then DispItem;
          End;
     End;

Procedure CloseHelp;
Begin
     Close(F);
     End;

Begin
     Assign(Input,'');  Reset(Input);
     Assign(Output,''); Rewrite(Output);
     OpenHelp;
     SearchItems;
     CloseHelp;
     End.
