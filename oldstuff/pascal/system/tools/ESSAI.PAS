Program Essai_Tools;

Uses Crt,Tools;

Type           Check = Object
               Procedure CheckBanner;
               Procedure CheckMinitel;
               Procedure CheckHexa;
               Procedure CheckStrings;
               Function  Interp(X:Boolean):String;
               Procedure CheckMath;
               Procedure CheckEncryption;
               Procedure Directories;
               End;

Var
    C   : Char;
    Ban : Banner;
     Ch : Check;
    Stt : Word;
     Mn : SimpleMinitel;
     Hx : Hexa;
      I : Integer;
     ST : StrClass;
     MT : MathClass;
     EN : Encrypt;
     DI : DirectoryClass;

Procedure Check.CheckBanner;
Begin
     Clrscr;
     TextBackground(Black);
     Clrscr;
     Ban.BannerLN('Librairie orient‚e objet TOOLS',0,6,15,0,True);
     Ban.BannerLN('Copyright (c) 1991. Pascal Munerot',0,6,15,0,False);
     Writeln;
     Ban.Blink('essai clignotement',6,0,15,0,False);
     C:=Readkey;
     Ban.ClearWin(1,1,80,25);
     Ban.ColorWin(10,10,65,20,4);
     Ban.ColorWin(12,12,65,21,2);
     C:=ReadKey;
     Window(1,1,80,25);
     Ban.ColorWin(1,1,80,25,1);
     Ban.Value('MISE EN ','VALEUR',' D''UNE INFORMATION                                                ',15,1,15,4);
     End;

Procedure Accepte;
Label ABC;
Var S : Word;
Begin
ABC:
     Gotoxy (10,WhereY);
     S:=Mn.Status;
     WriteLN(Hi(S));
     If (WhereY=22) Then Gotoxy(10,1);
     Goto ABC;
     End;

Procedure Check.CheckMinitel;
Begin
     Mn.Choose(0);
     Stt:=Mn.InitMin;
     Mn.Cursor;
     Mn.Cls;
     Mn.EmitStrln('Essai librairie orientee objet TOOLS');
     Clrscr;
     For I:=1 To 100 Do
     Begin
          Accepte;
          End;
     End;

Procedure Check.CheckHexa;
Begin
     Clrscr;
     Writeln; Writeln;
     Hx.DispByte(255); Writeln;
     Hx.DispByte(32); Writeln;
     Hx.DispWord(2000); Writeln;
     Hx.DispPointer(1000,1000); Writeln;
     Writeln;
     Writeln(Hx.HexToByte('FF'));
     Writeln(Hx.HexToWord('0020'));
     End;

Procedure Check.CheckStrings;
Const Chaine = #9+'   essai ‚Š‡…';
      L : Liste = ('DE','FLUSHING','','','','','','','','');
Begin
     Clrscr;
     Writeln(St.UpcaseStr(St.SkipBlanks(Chaine)));
     Writeln(St.UpcaseSubStr (Chaine,'ess'));
     Writeln(St.LowCaseStr('ESSAI ‚‚'));
     Writeln(St.LowCaseSubStr('ESSAI','ESS'));
     Writeln(St.Flushing('ESSAI DE LA FONCTION FLUSHING',L));
     Writeln(St.FlushingN('ESSAI DE LA FONCTION FLUSHING',L,12));
     Writeln(St.Left(St.SkipBlanks(Chaine),3));
     Writeln(St.Right(St.SkipBlanks(Chaine),3));
     End;

Function  Check.Interp (X:Boolean):String;
Begin
     Case X of
          True : Interp:='True';
          False: Interp:='False';
          End;
     End;

Procedure Check.CheckMath;
Begin
     Clrscr;
     Writeln(Mt.Fact(10));
     Writeln(Mt.Power(-2,2));
     Writeln(Mt.Power(-2,3));
     Writeln(Mt.Power(2.1,3));
     Writeln;
     Writeln(Mt.DeltaNumber(1,-9,1));
     Writeln(Mt.DeltaFirstSol(1,-9,1));
     Writeln(Mt.DeltaSecondSol(1,-9,1));
     Writeln;
     Writeln(Mt.ArcSin(Sin(Pi)),  '   ',Pi);
     Writeln(Mt.ArcSin(Sin(2*Pi)),'   ',2*Pi);
     Writeln(Mt.ArcSin(Sin(-Pi)), '   ',-Pi);
     Writeln(Mt.ArcSin(0.1));
     Writeln;
     Writeln(Mt.ArcCos(Cos(0.1)));
     Writeln(Mt.ArcCos(Cos(0.2)));
     Writeln(Mt.ArcCos(Cos(0.3)));
     Writeln(Mt.ArcCos(Cos(0.4)));
     Writeln(Mt.ArcCos(Cos(0.5)));
     Writeln(Mt.ArcCos(Cos(0.6)));
     Writeln(Mt.ArcCos(Cos(Pi/3)));
     C:=Readkey;
     Clrscr;
     Writeln ('Nombres premiers : ');
     Writeln;
     Writeln ('1   --> ',Interp(Mt.PrimeNumber(1)));
     Writeln ('3   --> ',Interp(Mt.PrimeNumber(3)));
     Writeln ('4   --> ',Interp(Mt.PrimeNumber(4)));
     Writeln ('211 --> ',Interp(Mt.PrimeNumber(211)));
     Writeln; Writeln;
     Writeln ('Angles : ');
     Writeln;
     Writeln (Mt.DegToRad(180));
     Writeln (Mt.RadToDeg(Pi));
     End;

Procedure Check.CheckEncryption;
Var S:String;
Begin
     Clrscr;
     S:=En.EncryptXOR('BONJOUR','BONSOIR');
     Writeln(S);
     Writeln(En.EncryptXOR(S,'BONSOIR'));
     Writeln;

     S:=En.EncryptXORRND1('BONJOUR','BONSOIR',200);
     Writeln(S);
     Writeln(En.EncryptXORRND1(S,'BONSOIR',200));
     Writeln;

     S:=En.EncryptXORRND4('BONJOUR','BONSOIR',200,100,50,25);
     Writeln(S);
     Writeln(En.EncryptXORRND4(S,'BONSOIR',200,100,50,25));
     End;

Procedure Check.Directories;
Var    N : Integer;
Begin
     Clrscr;
     If (Di.ExistFile('a:\tools.tpu')=True) Then Writeln('Fichier trouv‚') Else
     Writeln('Fichier non trouv‚');

{$I-}
     ChDir('A:\');            MkDir('\prog');
     ChDir('\prog');          MkDir('compiler');
     ChDir('\prog\compiler'); MKDir('pascal');
     ChDir('\');
     Writeln; Writeln;

     Writeln ('\*.*');
     N:=Di.SubDirectories('*.*');
     If (N<>0) Then For I:=1 To N Do
                    Begin
                         Writeln(P[I]^);
                         FreeMem(P[I],8);
                         End;
     Writeln;

     Writeln('\prog\*.*');
     N:=Di.SubDirectories('\prog\*.*');
     If (N<>0) Then For I:=1 To N Do
                    Begin
                         Writeln(P[I]^);
                         FreeMem(P[I],8);
                         End;
     Writeln;

     Writeln('\prog\compiler\*.*');
     N:=Di.SubDirectories('\prog\compiler\*.*');
     If (N<>0) Then For I:=1 To N Do
                    Begin
                         Writeln(P[I]^);
                         FreeMem(P[I],8);
                         End;
     Writeln;

     RmDir('\prog\compiler\pascal');
     RmDir('\prog\compiler');
     RmDir('\prog\utilities');
     RmDir('\prog');
     ChDir('\');
     End;

Begin
     Clrscr;
     Ch.CheckBanner;      C:=Readkey;
{     Ch.CheckMinitel;}
{     Ch.CheckHexa;        C:=Readkey;
     Ch.CheckStrings;     C:=Readkey;
     Ch.CheckMath;        C:=Readkey;
     Ch.CheckEncryption;  C:=ReadKey;
     Ch.Directories;}
     End.
