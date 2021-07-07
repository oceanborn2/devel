Program Xlisp_To_Pascal;

Uses Crt,Dos,WinExt,Analyse;

Const
     Dep:Boolean=False;

     _Err:Array [0..9] of string[40]=(
         'USES clause expected',           {0}
         'ENDEP clause expected',          {1}
         '( expected',                     {2}
         'Unknown identifier',             {3}
         'Illegal right Parenthesis',      {4}
         'End of file reached',            {5}
         '',
         '',
         '',
         '');

Type
    Banner = Object
           Procedure   Banner;
           End;

    Filer = Object
            DirInfo:SearchRec;
            S:Text;
            D:Text;
            W:Array [1..32] of String[30];
            Procedure Err(N:Integer);                 {GESTION DES ERREURS}
            Procedure Init;                           {LANCE LA COMPILATION}
            Procedure Open;                           {OUVRE SOURCE ET DEST}
            Procedure ReRead;                         {PASSE COMMENT / CRLF}
            Function  FReadLn:String;                 {LIT UNE LIGNE}
            Function  Match(A:String):Boolean;        {CHAINE TROUVEE}
            Function  Unknown(A:String):Boolean;      {CHAINE NON TROUVEE}
            Function  Occur(A:String; Er:Integer):Boolean; {RECHERCHE L'INST}
            Procedure FWriteln(A:String);             {ECRITURE DEST}
            Procedure NextLine;                       {SAUTE UNE LIGNE}
            Procedure SetName;                        {NOMME LE PROGRAMME}
            Procedure SkipTo(A:String; Er:Integer);   {VA JUSQU'A A}
            Procedure CountPar;                       {LIT UNE LIGNE AUTONOME}
            Procedure GetSyms;                        {SEPARATION SYMBOLES}
            Procedure Anal;                           {ANALYSE LE SOURCE}
            Procedure SearchDependencies;             {CHERCHE DEPENDANCES}
            Procedure SDep1;
            Procedure Sdep;                           {TROUVE DEPENDANCES}
            Procedure SPO;                            {CHERCHE PAR OUV}
            Procedure SPF;                            {CHERCHE PAR FER}
            Procedure SetMain;                        {DEBUT PROG PRINCIPAL}
            Procedure CloseMain;                      {FIN PROG PRINCIPAL}
            Procedure Closer;                         {FIN DEST ET SOURCE}
            End;

Var Ban : Banner;
   Fich : Filer;

   Str  : String;
   StrP : String;
   St2  : String;
   Ch   : char;
    J,I : Integer;


Procedure Banner.Banner;
Begin
     TextColor(White); TextBackground(Black);
     Clrscr;
     Writeln ('XLISP 2.0 to Turbo Pascal 5.x compiler ');
     Writeln ('First release');
     Writeln ('Copyright (c) 1990. Pascal Munerot');
     Writeln;
     TopWindow:=Nil;
     OpenWindow (1,5,80,25,' Compilation Result ',15,15);
     Clrscr;
     End;

Procedure Filer.Open;
Begin
     If ParamCount<2 then
                     Begin
                          Writeln ('Parameters Error');
                          Halt(1);
                          End;
     Assign (S,Paramstr(1));
     Assign (D,ParamStr(2));
     FindFirst(ParamStr(1),0,DirInfo);
     if DosError <> 0 Then
                      Begin
                           Writeln ('No Source File');
                           Halt(1);
                           End;
     Reset(S);
     Rewrite(D);
     End;

Procedure Filer.FWriteln(A:String);
Begin
     Writeln (D,A);
     Writeln (A);
     End;

Procedure Filer.NextLine;
Begin
     FWriteln ('');
     End;

Procedure Filer.SetName;
Begin
     FWriteln ('{ XLISP 2.0 to Turbo Pascal 5.x Compiler }');
     FWriteln ('{ First Release }');
     FWriteln ('{ Copyright (c) 1990. Pascal Munerot } ');
     NextLine;
     Str:=DirInfo.Name;
     Delete (Str,Pos('.',Str),4);
     FWriteln ('Program '+Str+';');
     NextLine;
     End;

Procedure Filer.ReRead;
Begin
     If Eof(S) then Err(5);
     Readln (S,StrP);
     If StrP='' then ReRead;
     If StrP[1]=';' then ReRead;
     End;

Function NotAlphaNum(C:Char):Boolean;
Begin
     NotAlphaNum:=True;
     Case Upcase(C) of
          'A'..'Z':NotAlphaNum:=False;
          '0'..'9':NotAlphaNum:=False;
          '(':NotAlphaNum:=False;
          ')':NotAlphaNum:=False;
          '''':NotAlphaNum:=False;
          End;
     End;

Procedure DelSpaces;
Begin
     For I:=1 To Length(St2) do
     Begin
          If (St2[i]=' ') and (St2[i+1]=' ')
             then Begin Delete(St2,i,1); Exit; End;
          End;
     End;

Function Filer.FreadLn:String;
Begin
     ReRead;
     St2:=UpString(SkipBlanks(StrP));
     For J:=1 To Length(St2) do DelSpaces;
     I:=Pos('( ',St2);
     While I>0 Do Begin Delete(St2,I+1,1); I:=Pos('( ',St2); End;
     I:=Pos(' )',St2);
     While I>0 Do Begin Delete(St2,I  ,1); I:=Pos(' )',St2); End;
     TextColor(Green); Writeln (St2); TextColor(White);
     FreadLn:=St2;
     End;

Function Filer.Match(A:String):Boolean;
Begin
     If Pos(A,Str)>0 Then Match:=True else Match:=False;
     End;

Function Filer.Unknown(A:String):Boolean;
Begin
     Unknown:=Not(Match(A));
     End;

Procedure Filer.SPO;
Begin
     Str:=FreadLn;
     End;

Procedure Filer.SPF;
Begin
     End;

Procedure Filer.Err(n:Integer);
Begin
     Writeln;
     Writeln (Str);
     Writeln ('--> Error ',n,' : ',_Err[n]);
     Closer;
     Halt(1);
     End;

Procedure Filer.Sdep1;
Var St:String;
    FirstOne:Boolean;
Begin
     FirstOne:=True;
     St:='Uses ';
     if (Match('CRT')) and (FirstOne=False) then Begin
                                              FirstOne:=False;
                                              St:=St+',Crt';
                                              End;
     if (Match('CRT')) and (FirstOne=True) then Begin
                                              FirstOne:=False;
                                              St:=St+'Crt';
                                              End;
     if (Match('DOS')) and (FirstOne=False) then Begin
                                              FirstOne:=False;
                                              St:=St+',Dos';
                                              End;
     if (Match('DOS')) and (FirstOne=True) then Begin
                                              FirstOne:=False;
                                              St:=St+'Dos';
                                              End;
     if (Match('OVL')) and (FirstOne=False) then Begin
                                              FirstOne:=False;
                                              St:=St+',Overlay';
                                              End;
     if (Match('OVL')) and (FirstOne=True) then Begin
                                              FirstOne:=False;
                                              St:=St+'Overlay';
                                              End;
     if (Match('GRAPH')) and (FirstOne=False) then Begin
                                              FirstOne:=False;
                                              St:=St+',Graph';
                                              End;
     if (Match('GRAPH')) and (FirstOne=True) then Begin
                                              FirstOne:=False;
                                              St:=St+'Graph';
                                              End;
     if (Match('PRINTER')) and (FirstOne=False) then Begin
                                              FirstOne:=False;
                                              St:=St+',Printer';
                                              End;
     if (Match('PRINTER')) and (FirstOne=True) then Begin
                                              FirstOne:=False;
                                              St:=St+'Printer';
                                              End;
     St:=St+';';
     FWriteln (St);
     NextLine;
     End;

Function Filer.Occur(A:String; Er:Integer):Boolean;
Begin
     While Not Eof(S) do
     Begin
          If Match(A) then Begin Occur:=True; Exit; End;
          Str:=Freadln;
          End;
     Err(Er);
     End;

Procedure Filer.SDep;
Begin
     Str:=FreadLn;
     If Occur('USES ',0) then Sdep1;
     If Occur('ENDEP',1) then Begin Dep:=True; Exit; End;
     End;

Procedure Filer.SearchDependencies;
Begin
     Dep:=False;
     While Not Eof (S) do
     Begin
          Sdep;
          If (Dep=True) Then Exit;
          End;
     End;

Procedure Filer.SkipTo(A:String; Er:Integer);
Begin
     While Pos(A,Str)=0 Do
     Begin
          If Eof(S) then Err(5);
          Str:=Freadln;
          End;

     End;

Procedure CompSetq;
Begin
     End;

Procedure CompDefun;
Begin
     End;

Procedure Filer.GetSyms;
Begin
     CountPar;
     Parse(Str,' ');
     End;

Procedure Filer.CountPar;
Var St3 : String;
    PO  : Integer;
    PF  : Integer;
Begin
     PO:=0;
     PF:=0;
     St3:=Str;
     I:=Pos('(',St3);
     While I>0 Do
     Begin
          Inc(PO);
          Delete (St3,i,1);
          I:=Pos('(',St3);
          End;
     I:=Pos(')',St3);
     While I>0 Do
     Begin
          Inc(PF);
          Delete (St3,i,1);
          I:=Pos(')',St3);
          End;
     If PO>PF then Begin Str:=Str+' '+FreadLn; CountPar; End;
     IF PO<PF then Err(4);
     End;

Procedure Filer.Anal;
Begin
     SearchDependencies;
     While Not Eof (S) do
     Begin
          GetSyms;
          Str:=FreadLn;
          End;
     End;

Procedure Filer.SetMain;
Begin
     FWriteln ('Begin');
     End;

Procedure Filer.CloseMain;
Begin
     FWriteln ('   End.');
     End;

Procedure Filer.Closer;
Begin
     Close(D);
     Close(S);
     End;

Procedure Filer.Init;
Begin
     Open;
     SetName;
     Anal;
     SetMain;
     CloseMain;
     Closer;
     End;

Begin
     Ban.Banner;
     Fich.Init;
     End.
