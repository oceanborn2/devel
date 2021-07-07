{essai de commentaire}
{commentaire sur
plusieurs lignes}

Program Super_Pascal_Compiler;

Uses Crt,Dos;

Type StPtr = ^String;
     LabelArea = Record
                      Val : Word;
                      Nom : String;
                 End;

     PossType = (Tchar,Tbyte,Tpointer,Tinteger,Treal,Tstring,TEnum);
     TypeArea = Record
                Nom : String;
                Typ : PossType;
                Siz : Byte;
                End;

     Vars = Record
            Typ : Byte; {r‚f‚rence … un num‚ro de TypeArea --> T}
            Nom : String;
            Cst : Boolean;
            End;

Const
     IP     : Word = 0;    {instruction pointer}
     LabelN : Integer = 0; {compteur de labels}
     VarN   : Integer = 0; {compteur de variables}

     {opcodes}
     OPEN_PROG : String[2] = 'PM';  {d‚but de programme}
     CLOSE_PROG : String[2] = 'pm'; {fin de programme}
     FOR_INC   = #1;
     FOR_DEC   = #2;
     IF_THEN   = #3;
     IF_THEN_E = #4;
     WHILE_DO  = #5;
     REPEAT_UN = #6;
     SHR_OP    = #7;
     SHL_OP    = #8;
     EXPR      = #9;


     {valeurs maximales des labels, erreurs et mots r‚serv‚s}
     MaxTypes = 256;
     MaxVars  = 256;
     MaxLabel = 512;
     MaxErr   = 11;
     MaxRes   = 26;
     MaxIdent = 12000;

     {messages d'erreurs}
     Er : Array [1..MaxErr] of String = (
                                  {1} 'PROGRAM attendu',
                                  {2} '; attendu',
                                  {3} 'mot r‚serv‚',
                                  {4} 'trop de noms de sous programmes',
                                  {5} 'TO ou DOWNTO manquant',
                                  {6} 'DO manquant',
                                  {7} 'identificateur existant',
                                  {8} 'premier car. non alphab‚tique',
                                  {9} 'plus assez de m‚moire',
                                 {10} ': ou = attendu',
                                 {11} ': attendu');

     {liste des mots r‚serv‚s}
     Res : Array [1..MaxRes] of String = ('PROGRAM','PROCEDURE','FUNCTION',
                                     'DO','END','BEGIN','FOR','TO','DOWNTO',
                                     'IF','THEN','ELSE','WHILE','REPEAT',
                                     'UNTIL','TYPE','VAR','CONST','ARRAY',
                                     'SHR','SHL','INC','DEC','OR','AND','XOR');

Var
     Cm1,
     Cm2  : Integer;
     Apos : Boolean;
        I : Integer;
       Ch : Char;
        F : Text;
        G : File of char;
     ST,S : String;
        C : Char;
  DirInfo : Searchrec;
        P : Array [1..MaxIdent] of ^String;
        V : Array [1..MaxVars] of ^Vars;
        T : Array [1..MaxTypes] of ^TypeArea;
        L : Array [1..MaxLabel] of ^LabelArea;
    MaxId : Integer;

{lib‚ration de la m‚moire des expressions}
Procedure Libere;
Begin
     For I:=1 To MaxIdent Do If P[i]<>Nil Then Freemem(P[i],Length(P[i]^)+1);
     For I:=1 To MaxLabel Do
         If L[i]<>Nil Then Freemem(L[i],Length(L[i]^.Nom)+3);
     For I:=1 To MaxVars Do
         If V[i]<>Nil Then Freemem(V[i],Length(V[i]^.Nom)+3);
     End;

{g‚nŠre une erreur de compilation}
Procedure Comp_Err(N:Integer);
Begin
     Writeln;
     TextColor(Yellow); TextBackGround(Red);
     Write ('Ident : ',I,' --> ',P[i]^); ClrEol; Writeln;
     Write (Er[N]); ClrEol; Writeln;
     TextColor(White); TextBackGround(Black);
     Writeln;
     Libere;
     Halt(1);
     End;

{compile un caractŠre}
Procedure CompChar (C:Char);
Begin
     Write(G,C);
     Inc(IP);
     End;

{compile une chaine}
Procedure CompString (S:String);
Var X : Integer;
Begin
     For X:=1 To Length(S) Do Write(G,S[X]);
     Inc(IP,Length(S));
     End;

{compile un entier}
Procedure CompInt (X:Integer);
Begin
     C:=Chr(X div 256); Write(G,C);
     C:=Chr(X mod 256); Write(G,C);
     Inc(IP,2);
     End;

{renvoie une chaine sans les tabs et les blancs de d‚but}
Function  SkipBlanks(A:String):String;
Begin
     If A='' Then Begin SkipBlanks:=''; Exit; End;
     While ((A[1]=' ') or (A[1]=#9)) Do
     Begin
          Delete(A,1,1);
          If A='' Then Begin SkipBlanks:=''; Exit; End;
          End;
     SkipBlanks:=A;
     End;

{passe une chaine en majuscules}
Procedure UpcaseStr;
Var X
 : Integer;
Begin
     For X:=1 To Length(P[i]^) Do P[i]^[x]:=Upcase(P[i]^[x]);
     End;

{initialisation des pointeurs}
Procedure Init;
Begin
     For I:=1 To MaxIdent Do P[i]:=Nil;
     For I:=1 To MaxLabel Do L[i]:=Nil;
     For I:=1 To MaxVars  Do V[i]:=Nil;
     For I:=1 To MaxTypes Do T[i]:=Nil;
     End;

{allocation d'un pointeur d'expression}
Procedure Allocate(A:String);
Begin
     Inc(MaxId);
     GetMem(P[MaxId],Length(A)+1);
     If P[MaxId]=Nil Then Comp_Err(9)
     End;

{s‚paration d'une expression en plusieurs sous expressions}
Procedure Separe;
Begin
     St:='';
     For I:=1 To Length(S) Do
     Begin
          C:=S[i];
          If (C='''') or (C=',') or (C=';')
          or (C='(')  or (C=')') or (C=' ')
          or (C=':')  or (C='=') Then
          Begin
               Allocate(St);
               P[MaxId]^:=ST;
               St:='';
               Allocate(C);
               P[MaxId]^:=C;
               End Else St:=St+C;
          End;
     End;

Procedure NextPass;
Begin
     Writeln ('-------------------------------------------------------------------------------');
     End;

{lecture du source}
Procedure GetSource;
Begin
     MaxId:=0;
     Assign(F,ParamStr(1));
     FindFirst(ParamStr(1),0,DirInfo);
     If DosError <> 0 Then
     Begin
          Writeln ('fichier source non trouv‚ ... ');
          Libere;
          Halt(1);
          End;
     Reset(F);
     While Not Eof(F) Do
     Begin
          Readln(F,S);
          Cm1:=Pos('{',S);
          Cm2:=Pos('}',S);
          If Cm1>0 Then If Cm2>0 Then Delete(S,Cm1,Cm2-Cm1+1);
          If (Cm1>0) And (Cm2<1) Then Delete(S,Cm1,Length(S)-Cm1+1);
          If (Cm1<1) And (Cm2>0) Then Delete(S,1,Cm2);
          S:=SkipBlanks(S);
          Separe;
          End;
     Close(F);
     Apos:=False;
     For I:=1 To MaxId-1 Do
     Begin
          If P[i]^='''' Then if Apos Then Apos:=False Else Apos:=True;
          If Not Apos Then UpcaseStr;
          End;
     Writeln ('S‚paration des mots r‚serv‚s et des expressions ');
     NextPass;
{     For I:=1 To MaxId-1 Do Write(P[I]^,'þ');}
     End;

{message d'invite}
Procedure Banner;
Begin
     Clrscr;
     Writeln ('Compilateur Pascal');
     Writeln ('Pascal Munerot');
     Writeln ('premiŠre version');
     Writeln;
     Init;
     End;

{v‚rifie si A n'est pas un mot r‚serv‚}
Function  Reserved (A:String) : Boolean;
Var   X : Integer;
Begin
     For X:=1 To MaxRes Do
     Begin
          If A=Res[X] Then Begin Reserved:=True; Exit; End;
          End;
     Reserved:=False;
     End;

{cherche la d‚claration de programme}
Procedure ProgDecl;
Begin
     Writeln ('Recherche de la d‚claration de programme');
     For I:=1 To MaxId-1 Do
     Begin
          If P[i]^='PROGRAM' Then
          Begin
                If I<MaxId-2 Then
               Begin
                    {program et ident doivent ˆtre s‚par‚s par des espaces}
                    If P[i+3]^<>';' Then Comp_Err(2);
                    If Reserved(P[i+2]^) Then Comp_Err(3);
                    Writeln ('--> ',P[i+2]^);
                    CompString(OPEN_PROG);
                    CompChar(Chr(Length(P[i+2]^)));
                    CompString(P[i+2]^);
                    NextPass;
                    Exit;
                    End Else Comp_Err(1);
               End;
          End;
     Comp_Err(1);
     End;

{enregistre un nouveau label}
Procedure GetLabel;
Begin
     {v‚rifier si p[i+2]^ n'est pas un mot r‚serv‚}
     {v‚rifier si p[i+2]^ n'est pas un identificateur}
     If Reserved(P[i+2]^) Then Comp_Err(3);
     Inc(LabelN);
     If LabelN=MaxLabel+1 Then Comp_Err(4);
     GetMem(L[LabelN],3+Length(P[i+2]^)); {alloue un nouveau label}
     If L[LabelN]=Nil Then Comp_Err(9); {pas assez de m‚moire}
     L[LabelN]^.Nom:=P[i+2]^;
     L[LabelN]^.Val:=IP;
     Writeln (L[LabelN]^.Nom,' ',L[LabelN]^.Val);
     End;

{recherche les d‚clarations de labels}
Procedure LabDecl;
Begin
     Writeln ('Recherche des labels du programme');
     For I:=1 To MaxId-1 Do
     Begin
          If (P[i]^='PROCEDURE') and (P[i+2]^<>'') Then GetLabel;
          If (P[i]^='FUNCTION') and (P[i+2]^<>'') Then GetLabel;
          If (P[i]^='BEGIN') Then GetLabel;
          If (P[i]^='REPEAT') Then GetLabel;
          End;
     NextPass;
     End;

{compile une expression arithm‚tique}
Procedure Compile_Expr (Debut,Fin : Integer);
Begin
     Writeln ('COMP : EXPR');
     CompChar(EXPR);
     End;

{compile un for}
Procedure Compile_For;
Begin
     Writeln ('COMP : FOR');
     CompChar(FOR_INC);
     End;

{compile un if}
Procedure Compile_If;
Begin
     Writeln ('COMP : IF');
     CompChar(IF_THEN);
     End;

{compile une boucle repeat}
Procedure Compile_Repeat;
Begin
     Writeln ('COMP : REPEAT');
     CompChar(REPEAT_UN);
     End;

{compile une boucle while}
Procedure Compile_While;
Begin
     Writeln ('COMP : WHILE');
     CompChar(WHILE_DO);
     End;

{calcule le type d'une variable et le conserve en m‚moire}
Procedure Calc_Type;
Begin
     End;

{v‚rifie la syntaxe d'un identificateur et si il n'existe pas d‚ja}
Function  IsIdent (A:String) : Boolean;
Var X : Integer; {compteur}
Begin
     If Not (A[1] in ['A'..'Z','a'..'z']) Then Comp_Err(8);
     While X<VarN Do
     Begin
          If A=V[i]^.Nom Then Comp_Err(7);
          End;
     IsIdent:=True;
     End;

Procedure Compile_Vars(A:String; Cst:Boolean);
Begin
     Inc(VarN);
     If IsIdent(A) Then
     Begin
          GetMem(V[VarN],Length(A)+3);
          If V[VarN]=Nil Then Comp_Err(9);
          V[VarN]^.Nom:=A;
          V[VarN]^.Cst:=Cst;
          Write ('VAR : ',V[VarN]^.Nom);
          If V[VarN]^.Cst Then Writeln ('CONST') Else Writeln;
          End;
     End;

Procedure Scan2(A,B:String);
Begin
     While ((P[i]^<>A) and (P[i]^<>B) and (I<MaxId-1)) Do Inc(I);
     If I>=MaxId-1 Then Comp_Err(10);
     End;

Procedure Scan(A:String);
Begin
     While ((P[i]^<>A) and (I<MaxId-1)) Do Inc(I);
     If I>=MaxId-1 Then Comp_Err(11);
     End;

Procedure Analyse;
Begin
     Writeln ('analyse du programme');
     I:=1;
     Repeat
          If P[i]^='TYPE'   Then Calc_Type;
          If P[i]^='CONST'  Then
          Begin
               Scan2(':','=');
               Compile_Vars(P[i+1]^,True);
               End;
          If P[i]^='VAR'    Then
          Begin
               Scan(':');
               Compile_Vars(P[i+1]^,False);
               End;
          If P[i]^='FOR'    Then Compile_For;
          If P[i]^='IF'     Then Compile_If;
          If P[i]^='REPEAT' Then Compile_Repeat;
          If P[i]^='WHILE'  Then Compile_While;
          Inc(I);
          Until I>MaxId;
     NextPass;
     End;

{compilation du programme}
Procedure Compile;
Begin
     ProgDecl;
     LabDecl;
     Analyse;
     End;

Procedure OpenObject;
Begin
     If ParamCount<2 Then
     Begin
          Writeln ('nom de fichier objet manquant');
          Halt(1);
          End;
     Assign(G,ParamStr(2));
     Rewrite(G);
     End;

Procedure CloseObject;
Begin
     CompString(CLOSE_PROG);
     Close(G);
     End;

{programme principal}
Begin
     Banner;
     OpenObject;
     GetSource;
     Compile;
     CloseObject;
     Libere;
     End.
