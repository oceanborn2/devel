Program Filtres;

Uses Crt,Dos;

Var FSource, FDest : PathStr;
    F,G            : Text;
    DirInfo        : SearchRec;

Procedure GetFileNames;
Begin
     If ParamCount<2 Then
     Begin
          Writeln;
          Writeln ('pas assez d''arguments sur la ligne de commande');
          Halt(1);
          End;
     FSource:=ParamStr(1);
     FDest:=ParamStr(2);
     End;

Function  Exist (A: String) : Boolean;
Begin
     FindFirst(A,0,DirInfo);
     If DosError = 0 Then Exist:=True
                     Else Exist:=False;
     End;

Procedure OpenFiles;
Begin
     Assign (F,Fsource);
     If Not Exist(FSource) Then
     Begin
          Writeln ('Le fichier ',FSource,' n''existe pas');
          Halt(1);
          End;
     Reset(F);
     Assign(G,FDest);
     If Exist(FDest) Then
     Begin
          Writeln ('Le fichier destination ',FDest,' existe dÇja');
          Writeln ('veuillez changer le nom du fichier destination');
          Writeln ('ou le dÇtruire avant de relancer ce programme');
          Halt(1);
          End;
     Rewrite(G);
     End;

Procedure CloseFiles;
Begin
     Close(F);
     Close(G);
     End;

Procedure DoIt;
Var S : String[255];
    P : Integer;
Begin
     While Not Eof(F) Do
     Begin
          Readln(F,S);
          P:=0;
          P:=Pos('Ç',S);
          While P>0 Do
          Begin
               S[p]:='e';
               P:=Pos('Ç',S);
               End;
          P:=0;
          P:=Pos('ä',S);
          While P>0 Do
          Begin
               S[p]:='e';
               P:=Pos('ä',S);
               End;
          P:=0;
          P:=Pos('Ö',S);
          While P>0 Do
          Begin
               S[p]:='a';
               P:=Pos('Ö',S);
               End;
          Writeln(S);
          Writeln (G,S);
          End;
     End;

Begin
     Clrscr;
     Writeln ('Programme de filtrage de caractäres');
     Writeln ('Pascal Munerot');
     GetFilenames;
     OpenFiles;
     DoIt;
     CloseFiles;
     End.

