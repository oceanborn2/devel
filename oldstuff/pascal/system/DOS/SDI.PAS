Program Super_Dos_Interpreter;

Uses Crt,Dos;

Const Max       : Integer = 0;
      LabPtr    : Integer = 0;
      RetPtr    : Integer = 0;
      InterpErr : Boolean = False;
      MainProc  : Integer = 1;

Type LabelArea = Record
                 N : String[16];
                 O : Integer;
                 End;

Var Filename : String;
    Filename2 : String;
    I,X      : Integer;
    F        : Text;
    Ch       : Char;
    S        : String;
    P        : Array [1..12000] of ^String;
    CHN      : String;
    Lab      : Array [1..256] of LabelArea;
    Ret      : Array [1..256] of Integer;

{LIT LE NOM DU FICHIER A INTERPRETER}
Procedure GetFilename;
Begin
     If ParamCount<1 Then Begin Writeln ('nom de fichier manquant');
     Halt(1); End;
     Filename:=ParamStr(1);
     End;

{LIBERE LA MEMOIRE TAMPON}
Procedure Free;
Begin
     For I:=1 To Max Do Freemem(P[I],Length(P[Max]^)+1);
     End;

{SORTIE ET LIBERATION DE LA MEMOIRE _ APPELLE FREE}
Procedure Terminate(N:Integer);
Begin
     Free;
     Halt(N);
     End;

{ENLEVE LES BLANCS ET LES TABULATIONS DU DEBUT DE LA CHAINE A}
Function  SkipBlanks(A:String):String;
Begin
     While ((A[1]=' ') Or (A[1]=#9)) Do Delete(A,1,1);
     SkipBlanks:=A;
     End;

{CONVERTIT UNE CHAINE EN MAJUSCULES}
Function  UpCaseStr(A:String):String;
Begin
     For I:=1 To Length(A) Do A[i]:=Upcase(A[i]);
     UpCaseStr:=A;
     End;

Procedure GetString;
Var C : String;
Begin
     C:='"'; Delete(S,1,1);
     While S[1]<>'"' Do
     Begin
          C:=C+S[1];
          Delete(S,1,1);
          End;
     Inc(Max);
     GetMem(P[Max],Length(C)+1);
     P[Max]^:=C;
     End;

{DECOUPE UNE PHRASE EN PLUSIEURS MORCEAUX}
{LE SEPARATEUR EST LE CARACTERE ESPACE}
Procedure CutSentence;
Var C  : String;
Begin
     S:=SkipBlanks(S);
     While S<>'' Do
     Begin
          If S[1]='"' Then GetString;
          C:='';
          While ((S[1]<>' ') and (S[1]<>#9) and (S<>'')) Do
          Begin
               C:=C+S[1];
               Delete(S,1,1);
               End;
          S:=SkipBlanks(S);
          Inc(Max);
          GetMem(P[Max],Length(C)+1);
          P[Max]^:=C;
          End;
     End;

{LIT LE FICHIER A INTERPRETER ET APPELLE CUTSENTENCE}
Procedure CutFile;
Begin
     Assign (F,Filename);
{$i-}
     DosError:=0;
     Reset(F);
{$i+}
     If DosError<>0 Then Terminate(1);
     S:='';
     While Not Eof(F) Do
     Begin
          Readln(F,S);
          CutSentence;
          End;
     Close(F);
     End;

{VERIFIE LA PRESENCE D'UNE INSTRUCTION}
Function  Match(A:String):Boolean;
Begin
     CHN:=P[X]^;
     CHN:=UpcaseStr(CHN);
     If (Pos(A,CHN)>0) Then Begin Match:=True; Exit; End;
     Match:=False;
     End;

{RECHERCHE LA PRESENCE D'UN CARACTERE}
Procedure WaitFor(C:Char; Inst:Integer);
Begin
     If CHN[1]<>C Then Begin
                       If X-1>0 Then Writeln (P[X-1]^);
                       Writeln (P[X]^);
                       If X+1<Max+1 Then Writeln (P[X+1]^);
                       TextColor(Yellow); TextBackGround(Red);
                       Writeln (C,' expected');
                       TextColor(White); TextBackground(Black);
                       Exit;
                       End;
     Case Inst of
          1 : Begin {POUR WRITEMESSAGE}
                 Delete(CHN,1,1);
                 While Pos('"',CHN)<=0 Do
                 Begin
                      Inc(X);
                      CHN:=CHN+' '+P[X]^;
                      End;
                 Delete(CHN,Pos('"',CHN),1);
                 End;
          End;
     End;

{AFFICHE UN MESSAGE D'ERREUR ET TERMINE LE PROGRAMME}
Procedure Error (A:String);
Begin
     TextColor(Yellow); TextBackGround(Red);
     Writeln (A);
     TextColor(White); TextBackground(Black);
     Terminate(1);
     End;

{LECTURE D'UN ENTIER}
Function ReadInteger : Integer;
Var II : Integer;
Begin
     Inc(X);
     CHN:=P[X]^;
     Val (CHN,I,II);
     If II<>0 Then Error('integer expected : '+CHN);
     ReadInteger:=I;
     End;

{SAUTE PLUSIEURS LIGNES _ RUNTIME}
Procedure SeveralLN;
Var Code : Integer;
Begin
     For I:=1 To ReadInteger Do Writeln;
     End;

{EFFACEMENT _ RUNTIME}
Procedure ClearSecond;
Begin
     Inc(X);
     If Match('SCREEN') Then Begin Clrscr; Exit; End;
     Error('SCREEN expected : '+CHN);
     End;

{GOTOXY _ RUNTIME}
Procedure DoGotoXY;
Begin
     Gotoxy(ReadInteger,ReadInteger);
     End;

{REDIRECTION _ RUNTIME}
Procedure GotoSecond;
Begin
     Inc(X);
     If Match('XY') Then Begin DoGotoXY; Exit; End;
     Error('XY expected : '+CHN);
     End;

{ECRIT UN MESSAGE _ RUNTIME}
Procedure WriteMessage;
Begin
     Inc(X);
     CHN:=P[X]^;
     WaitFor('"',1);
     Write (CHN);
     End;

{ECRIT UN ENTIER _ RUNTIME}
Procedure WriteInteger;
Begin
     Write(ReadInteger);
     End;

{ECRIT QUELQUECHOSE _ RUNTIME}
Procedure WriteSecond;
Begin
     Inc(X);
     If Match('STR') Then Begin WriteMessage; Exit; End;
     If Match('INT') Then Begin WriteInteger; Exit; End;
     Error('STR, or INT expected');
     End;

Procedure TextC;
Begin
     TextColor(ReadInteger);
     End;

Procedure TextG;
Begin
     TextBackground(ReadInteger);
     End;

Procedure TextM;
Begin
     TextMode(ReadInteger)
     End;

{MANIPULE L'ECRAN _ RUNTIME}
Procedure TextSecond;
Begin
     Inc(X);
     If Match('COLOR') Then Begin TextC; Exit; End;
     If Match('BACK') Then Begin TextG; Exit; End;
     If Match('MODE') Then Begin TextM; Exit; End;
     Error('COLOR, BACK or MODE expected');
     End;

{VERIFIE LE LABEL _ IL NE DOIT PAS ETRE UN MOT RESERVE }
Procedure CheckReserved;
Begin
     CHN:=P[X]^;
     If (CHN='') Then Error('procedure name expected');
     If (CHN='MODE') Or (CHN='COLOR') Or (CHN='BACK') Or
     (CHN='TEXT') Or (CHN='PROCEDURE') Or (CHN='CLEAR') Or
     (CHN='GOTO') Or (CHN='WRITE') Or (CHN='LN') Or (CHN='LN_') Or
     (CHN='STR') Or (CHN='INT') Or (CHN='XY') Or (CHN='CALL') Or
     (CHN='END') Or (CHN='MAINPROC') Or (CHN='EXIT') Then
     Error('reserved word : '+CHN);
     End;

{ENREGISTREMENT D'UN NOUVEAU LABEL}
Procedure GetLabel;
Begin
     Inc(X);
     CHN:=P[X]^;
     CheckReserved;
     Inc(LabPtr);
     Lab[LabPtr].N:=CHN;
     Lab[LabPtr].O:=X+1;
     End;

{EXECUTION D'UNE PROCEDURE _ RUNTIME}
Procedure CallLabel;
Begin
     Inc(X);
     CHN:=P[X]^;
     For I:=1 To LabPtr Do
     Begin
          If Lab[I].N=CHN Then Begin Inc(RetPtr);
                                     If RetPtr=257 Then Error('No more calls');
                                     Ret[RetPtr]:=X;
                                     X:=Lab[I].O; Exit; End;
          End;
     If Lab[I].N=CHN Then Exit;
     Error('unknown label : '+CHN);
     End;

Procedure Return;
Begin
     X:=Ret[RetPtr];
     Dec(RetPtr);
     End;

{LECTURE DE LA PREMIERE PARTIE D'UNE INSTRUCTION}
Procedure Interp;
Begin
     If Match('PROCEDURE') Then Inc(X,2);
     If Match('END')       Then Halt(0);
     If Match('EXIT')      Then Begin Return;         Exit; End;
     If Match('CALL')      Then Begin CallLabel;      Exit; End;
     If Match('TEXT')      Then Begin TextSecond;     Exit; End;
     If Match('CLEAR')     Then Begin ClearSecond;    Exit; End;
     If Match('GOTO')      Then Begin GotoSecond;     Exit; End;
     If Match('WRITE')     Then Begin WriteSecond;    Exit; End;
     If Match('LN_')       Then Begin SeveralLN;      Exit; End;
     If Match('LN')        Then Begin Writeln;        Exit; End;
     If Match('BEEP')      Then Begin Write(#7);      Exit; End;
     End;

{ENREGISTREMENT PREALABLE DES LABELS DES PROCEDURES}
Procedure FirstPass;
Begin
     For X:=1 To Max Do
     Begin
          If Match('PROCEDURE') Then GetLabel;
          If Match('MAINPROC') Then MainProc:=X+1;
          End;
     End;

{EXECUTION DU PROGRAMME}
Procedure Analyse;
Begin
     FirstPass;
     For X:=1 To Max Do Interp;
     End;

Begin
     GetFilename;
     CutFile;
     Analyse;
     Free;
     End.