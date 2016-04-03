Unit ElTools;

Interface

Uses Crt;

Const
     NL=0;
     TL=1;
     MAX=0;
     MIN=1;
     FORM=2;
     NORMAL=3;
     Sortie:Boolean=False;

Type
         Calculator = Object
         M    : Array [1..26] of Extended;
      Answer  : Extended;        {registre de calcul courant}
         Code : Integer;     {code d'erreur ‚ventuel pour val}
         Fst  : Extended;        {Premier argument}
         Sec  : Extended;        {Seconde argument}
         Line : String;      {ligne}
         Procedure Spec;     {Touche sp‚ciale (raccourci clavier)}
         Procedure Screen;   {menu principal du module calculatrice}
         Procedure DoIt;     {mise en fonction de la calculatrice}
         Procedure GetOpt;   {lecture de l'op‚ration … effectuer}
         Procedure Display;  {affichage du r‚sultat de l'op‚ration courante}
         Procedure Add;
         Procedure Substract;
         Procedure Divide;
         Procedure Multiply;
         Procedure Opposite;
         Procedure Absol;
         Procedure Square;
         Procedure Root;
         Procedure Fln;
         Procedure Log;
         Procedure Puissance;
         Procedure Entire;
         Procedure Invert;
         Procedure Tangent;
         Procedure Cosine;
         Procedure Sinus;
         Procedure Exponent;
         Procedure Dixx;
         Procedure First;
         Procedure Second;
         Procedure PutInMemory;
         Procedure GetInMemory;
         Procedure Err;
         End;

Var
   S:String;
   ch:char;
   I,R,C,L,U,E,T,Q,Beta:Real;
   I2,R2,C2,L2,U2,E2,T2,Q2:Real;
   Equivalent:Real;
   Y,Z:Integer;

Procedure GK;
Function Log(A:Real):Real;
Procedure GetCharge;
Procedure GetCharge2;
Procedure GetTens;
Procedure GetTens2;
Procedure GetRes;
Procedure GetRes2;
Procedure GetInt;
Procedure GetInt2;
Procedure GetInd;
Procedure GetInd2;
Procedure GetCap;
Procedure GetCap2;
Procedure GetFem;
Procedure GetFem2;
Procedure GetPeriod;
Procedure GetPeriod2;
Procedure MakeEsc;
Procedure DivByZero;
Procedure Title(A:String);
Procedure SWriteln(A:String; I:Integer);
Procedure Unavailable;

Implementation

Procedure GK; Begin ch:=readkey; End;

Procedure Calculator.PutInMemory;
Var X : Integer;
Begin
     Ch:=Upcase(Readkey);
     If Not (Ch in ['A'..'Z']) then Ch:='A';
     X:=Ord(Ch)-64;
     M[X]:=Answer;
     Write ('EM : ',Ch,Answer,'                   ');
     End;

Procedure Calculator.GetInMemory;
Var X : Integer;
Begin
     Ch:=Upcase(Readkey);
     If Not (Ch in ['A'..'Z']) then Ch:='A';
     X:=Ord(Ch)-64;
     Answer:=M[X];
     Write ('DM : ',Ch,'   ',Answer,'                    ');
     End;

Procedure Calculator.First;
Begin
     Gotoxy(1,19);
     Write(' '); ClrEol; Write ('F> ');
     Readln(Line);
     If (Upcase(Line[1]) in ['A'..'Z']) then Begin
                            Fst:=M[Ord(Upcase(Line[1]))-64];
                            Exit; End;
     Val(Line,Fst,Code);
     End;

Procedure Calculator.Second;
Begin
     Gotoxy(1,20);
     Write(' '); ClrEol; Write ('S> ');
     Readln(Line);
     If (Upcase(Line[1]) in ['A'..'Z']) then Begin
                            Sec:=M[Ord(Upcase(Line[1]))-64];
                            Exit; End;
     Val(Line,Sec,Code);
     End;

Procedure Calculator.Add; Begin Answer:=Fst + Sec; End;

Procedure Calculator.Substract; Begin Answer:=Fst - Sec; End;

Procedure Calculator.Multiply;  Begin Answer:=Fst * Sec; End;

Procedure Calculator.Err;
Begin
     Gotoxy (1,22);
     Write('Calcul impossible');
     End;

Procedure Calculator.Divide;
Begin
     If (Sec=0) then Begin Err; Exit; End;
     Answer:=Fst / Sec;
     End;

Procedure Calculator.Opposite;  Begin Answer:=- Fst;    End;

Procedure Calculator.Absol;     Begin Answer:=Abs(Fst); End;

Procedure Calculator.Square;    Begin Answer:=Sqr(Fst); End;

Procedure Calculator.Root;
Begin
     If (Fst<0) then Begin Err; Exit; End;
     Answer:=Sqrt(Fst);
     End;

Procedure Calculator.Fln;
Begin
     If (Fst<=0) then Begin Err; Exit; End;
     Answer:=Ln(Fst);
     End;

Procedure Calculator.Exponent;
Begin
     Sec:=Exp(1);
     Puissance;
     End;

Procedure Calculator.Log;
Begin
     If (Fst<=0) then Begin Err; Exit; End;
     Answer:=Ln(Fst)/Ln(10);
     End;

Procedure Calculator.Dixx;
Begin
     Sec:=10;
     Puissance;
     End;

Procedure Calculator.Entire;    Begin Answer:=Round(Fst); End;

Procedure Calculator.Tangent;
Begin
     If (Cos(Fst)=0) then Begin Err; Exit; End;
     Answer:=Sin(Fst)/Cos(Fst);
     End;

Procedure Calculator.Cosine; Begin Answer:=Cos(Fst); End;

Procedure Calculator.Sinus;  Begin Answer:=Sin(Fst); End;

Procedure Calculator.Puissance;
Var X : Integer;
Begin
     Answer:=1;
     For X:=1 To Round(Fst) Do
     Begin
          Answer:= Sec * Answer;
          End;
     End;

Procedure Calculator.Invert;
Begin
     If (Fst=0) then Begin Err; Exit; End;
     Answer:=1/Fst;
     End;

Procedure Calculator.DoIt;
Begin
     GetOpt;
     If (Sortie=True) then exit;
     DoIt;
     End;

Procedure Calculator.Display;
Begin
     M[1]:=Answer;
     Write(Answer); Writeln('                            ');
     Write(' '); ClrEol;
     End;

Procedure Calculator.Spec;
Begin
     Ch:=readkey;
     Case ch of
          #59:Add;
          #60:Substract;
          #61:Multiply;
          #62:Divide;
          #63:Square;
          #64:Root;
          #65:Puissance;
          #66:Absol;
          #67:Opposite;
          #68:Entire;
          End;
     Display;
     End;

Procedure Calculator.GetOpt;
Var S:String;
Begin
     Gotoxy (1,21);
     ch:=upcase(readkey);
     Case ch of
          #0:Spec;
          #27:Begin Sortie:=True;  Exit; End;
          '+':Begin First; Second; Add;       Display; Exit; End;
          '-':Begin First; Second; Substract; Display; Exit; End;
          '/':Begin First; Second; Divide;    Display; Exit; End;
          '*':Begin First; Second; Multiply;  Display; Exit; End;
          'M':Begin PutInMemory; Exit; End;
          'G':Begin GetInMemory; Exit; End;
          End;
     If (Sortie=True) Then Exit;
     Write(ch);
     S:=Ch;
     Ch:=Upcase(readkey);
     Write(ch);
     S:=S+ch;
     If (Ch=#27) then Exit;
     If (S='OF') then Begin Sortie:=True; Exit;    End;
     If (S='CA') then Begin First; Square;       Display; End;
     If (S='RA') then Begin First; Root;         Display; End;
     If (S='TG') then Begin First; Tangent;      Display; End;
     If (S='CS') then Begin First; Cosine;       Display; End;
     If (S='SN') then Begin First; Sinus;        Display; End;
     If (S='LG') then Begin First; Log;          Display; End;
     If (S='LN') then Begin First; Fln;          Display; End;
     If (S='XY') then Begin First; Second;     Puissance; Display; End;
     If (S='OP') then Begin First; Opposite;     Display; End;
     If (S='EN') then Begin First; Entire;       Display; End;
     If (S='IN') then Begin First; Invert;       Display; End;
     If (S='PI') then Begin Answer:=Pi;          Display; End;
     If (S='RE') then Begin Answer:=0;           Display; End;
     If (S='EX') then Begin First; Exponent;     Display; End;
     If (S='10') then Begin First; Dixx;         Display; End;
     End;

Procedure Calculator.Screen;
Begin
     Clrscr;
     Sortie:=False;
     Title('Elektron. Calculatrice g‚n‚rale ');
     Writeln; Writeln;
     Writeln ('ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
     Writeln ('³ Mx       ³ Ecriture m‚moire   ³         ³                    ³');
     Writeln ('³ Gx       ³ Lecture  m‚moire   ³         ³                    ³');
     Writeln ('³ +   (F1) ³ Addition           ³ -   (F2)³ Soustraction       ³');
     Writeln ('³ *   (F3) ³ Multiplication     ³ /   (F4)³ Division           ³');
     Writeln ('³ CA  (F5) ³ Carr‚              ³ RA  (F6)³ Racine             ³');
     Writeln ('³ XY  (F7) ³ Puissance          ³ VA  (F8)³ Valeur absolue     ³');
     Writeln ('³ OP  (F9) ³ Changement de signe³ EN (F10)³ Valeur entiŠre     ³');
     Writeln ('³ LG       ³ Logarithme d‚cimal ³ LN      ³ Logarithme n‚p‚rien³');
     Writeln ('³ 10       ³ Dix Puissance X    ³ EX      ³ Exponentielle      ³');
     Writeln ('³ CS       ³ Cosinus            ³ SN      ³ Sinus              ³');
     Writeln ('³ TG       ³ Tangente           ³ IN      ³ Inversion          ³');
     Writeln ('³ RE       ³ Reset              ³ PI      ³ Valeur de Pi       ³');
     Writeln ('ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
     Writeln (' [esc]     Sortie');
     End;

Function Log(A:Real):Real;
Begin
     Log:=Ln(A)/Ln(10);
     End;

Procedure GetCharge;
Begin
     Write('Charge Q                   : ');
     Readln(Q);
     End;

Procedure GetCharge2;
Begin
     Write('Charge Q2                  : ');
     Readln(Q2);
     End;

Procedure GetTens;
Begin
     Write('Tension U (U1)             : ');
     Readln(U);
     End;

Procedure GetTens2;
Begin
     Write('Tension U2                 : ');
     Readln(U2);
     End;

Procedure GetRes;
Begin
     Write('R‚sistance R (R1)          : ');
     Readln(R);
     End;

Procedure GetRes2;
Begin
     Write('R‚sistance R2              : ');
     Readln(R2);
     End;

Procedure GetInt;
Begin
     Write('Intensit‚ I (I1)           : ');
     Readln(I);
     End;

Procedure GetInt2;
Begin
     Write('Intensit‚ I2               : ');
     Readln(I2);
     End;

Procedure GetFem;
Begin
     Write('FEM E (E1)                 : ');
     Readln(E);
     End;

Procedure GetFem2;
Begin
     Write('FEM E2                     : ');
     Readln(E2);
     End;

Procedure GetCap;
Begin
     Write('Capacit‚ C                 : ');
     Readln(C);
     End;

Procedure GetCap2;
Begin
     Write('Capacit‚ C2                : ');
     Readln(C2);
     End;

Procedure GetInd;
Begin
     Write('Inductance L               : ');
     Readln(L);
     End;

Procedure GetInd2;
Begin
     Write('Inductance L2              : ');
     Readln(L2);
     End;

Procedure GetPeriod;
Begin
     Write('P‚riode T                  : ');
     Readln(T);
     End;

Procedure GetPeriod2;
Begin
     Write('P‚riode T2                 : ');
     Readln(T2);
     End;

Procedure Title(A:String);
Begin
     TextColor(0); TextBackground(White); ClrEol;
     Writeln(A);
     TextColor(White); TextBackground(blue);
     End;

Procedure SWriteln(A:String; I:Integer);
Begin
     Writeln(A);
     If (I=NL) then Writeln;
     End;

Procedure MakeESC;
Begin
     SWriteln('[ESC] Menu principal',NL);
     End;

Procedure DivByZero;
Begin
     Writeln;
     SWriteln('Division par z‚ro',NL);
     GK;
     End;

Procedure UnAvailable;
Begin
     Writeln('Application non disponible');
     End;

     End.

