Program Elektron;

Uses Crt,ElTools;

Const
     NL=0;
     TL=1;
     MAX=0;
     MIN=1;
     FORM=2;
     NORMAL=3;
     Sortie : Boolean = False;

Type

  Banner=Object
         Procedure Banner;
         End;

    Menu=Object
         Procedure Specials;
         Procedure Menu1;

         Procedure Pow_MenuPuissance;
         Procedure Pow_Eff;
         Procedure Pow_General;
         Procedure Pow_Gene1;
         Procedure Pow_Gene2;
         Procedure Pow_Dipole1;
         Procedure Pow_Dipole2;
         Procedure Pow_Rendement;

         Procedure Ten_MenuTension;
         Procedure Ten_Dipole1;
         Procedure Ten_Gene1;

         Procedure Int_MenuIntensite;
         Procedure Int_Condensateur;
         Procedure Int_Dipole1;

         Procedure Fre_MenuFrequence;
         Procedure Fre_Periode;
         Procedure Fre_Cond;
         Procedure Fre_RLC;
         Procedure Fre_Pulsat_RLC;

         Procedure Res_MenuResistance;
         Procedure Res_Equiv_Serie;
         Procedure Res_Equiv_Parral;

         Procedure Con_MenuConductance;
         Procedure Con_General;

         Procedure Cap_MenuCapacite;
         Procedure Cap_Equiv_Serie;
         Procedure Cap_Equiv_Parral;

         Procedure Cha_MenuCharge;
         Procedure Cha_Condensateur;

         Procedure Tra_MenuTransistor;
         Procedure Tra_Beta;
         Procedure Tra_IBase;
         Procedure Tra_ICollect;

         Procedure Trans_MenuTransfos;
         Procedure Trans_US;
         Procedure Trans_IS;
         End;

Var
   Ban : Banner;
   Men : Menu;
   Cal : Calculator;

Procedure Show(X:Real; S:String; A:Integer);
Var II:Integer;
Begin
     If (A=NORMAL) then Begin Write(X:5:2,' ',S); GK; Exit; End;
     If (A=FORM) then Begin Write(X); GK; Exit; End;
     If (A=MAX) then II:=10 Else II:=2;
     If (X=0) then Begin Write('0'); GK; Exit; End;
     If (Abs(X)>1E9)  then Begin Write(X/1E9:5:II,' G',S);  GK; Exit; End;
     If (Abs(X)>1E6)  then Begin Write(X/1E6:5:II,' M',S);  GK; Exit; End;
     If (Abs(X)>1E3)  then Begin Write(X/1E3:5:II,' K',S);  GK; Exit; End;
     If (Abs(X)<1E3)
     and (Abs(X)>1E-3)then Begin Write(X:5:II,' ',S);       GK; Exit; End;
     If (Abs(X)>1E-3) then Begin Write(X*1E3:5:II,' m'+S);  GK; Exit; End;
     If (Abs(X)>1E-6) then Begin Write(X*1E6:5:II,' æ',S);  GK; Exit; End;
     If (Abs(X)>1E-9) then Begin Write(X*1E9:5:II,' n',S);  GK; Exit; End;
     If (Abs(X)>1E-12)then Begin Write(X*1E12:5:II,' p',S); GK; Exit; End;
     If (Abs(X)>1E-15)then Begin Write(X*1E12:5:II,' p',S); GK; Exit; End;
     Write(X); GK;
     End;

Procedure CTitle(A:String);
Begin
     TextBackground(blue); Clrscr; Title(A);
     End;

Procedure Banner.Banner;
Begin
     TextBackground(Blue); TextColor(White);
     Clrscr;
     Title('Electronic Calculator ');
     Title('Copyright (c) 1990. Pascal Munerot');
     Delay(1000);
     End;

Procedure Menu.Specials;
Var X : Integer;
Begin
     If (Sortie=True) then exit;
     ch:=readkey;
     case ch of
          #59:Begin
                   For X:=1 To 26 Do Cal.M[X]:=0;
                   Cal.Screen; Cal.DoIt;
                   End;
          End;
     End;

Procedure Menu.Menu1;
Begin
     Clrscr;
     CTitle('Elektron . Copyright (c) 1990. Pascal Munerot');
     Title ('Menu principal'); Writeln;
     Writeln ('A. Puissance                 (en Watts    W)');
     Writeln ('B. Tension                   (en Volts    V)');
     Writeln ('C. Intensit‚                 (en AmpŠre   A)');
     Writeln ('D. Fr‚quence                 (en Hertz   Hz)');
     Writeln ('E. R‚sistance, imp‚dance     (en Ohms     ê)');
     Writeln ('F. Conductance               (en Siemens  S)');
     Writeln ('G. Capacit‚                  (en Farads   F)');
     Writeln ('H. Charge                    (en Coulombs C)');
     Writeln ('I. Choix d''un transistor');
    SWriteln ('J. Choix d''un transformateur ',NL);
     Writeln ('Q. Quitter');
     GK;
     case upcase(ch) of
          'A':Pow_MenuPuissance;
          'B':Ten_MenuTension;
          'C':Int_MenuIntensite;
          'D':Fre_MenuFrequence;
          'E':Res_MenuResistance;
          'F':Con_MenuConductance;
          'G':Cap_MenuCapacite;
          'H':Cha_MenuCharge;
          'I':Tra_MenuTransistor;
          'J':Trans_MenuTransfos;
          'Q':Halt(0);
          #0:Specials;
          Else Menu1;
          End;
     Menu1;
     End;

Procedure Menu.Ten_Dipole1;
Begin
     GetRes; GetInt;
     Show(R*I,'V',MIN);
     End;

Procedure Menu.Ten_Gene1;
Begin
     GetFem; GetRes; GetInt;
     Show(E-R*I,'V',MIN);
     End;

Procedure Menu.Ten_MenuTension;
Begin
     CTitle('Elektron. Module de calcul des tensions');
     Writeln;
     SWriteln('1. U = RI        Tension aux bornes d''un dip“le ohmique',NL);
     SWriteln('2. U = E-RI      Tension aux bornes d''un g‚n‚rateur',NL);
     MakeESC;
     Writeln;
     GK;
     Case ch of
          '1':Ten_Dipole1;
          '2':Ten_Gene1;
          #0:Specials;
          #27:Exit;
          Else Ten_MenuTension;
          End;
     If (ch=#27) then exit;
     Ten_MenuTension;
     End;

Procedure Menu.Int_Condensateur;
Begin
     GetCharge; GetPeriod;
     if (T=0) then Begin DivByZero; Exit; End;
     Show(Q/T,'A',MIN);
     End;

Procedure Menu.Int_Dipole1;
Begin
     GetTens; GetRes;
     If (R=0) then Begin DivByZero; Exit; End;
     Show(U/R,'A',MIN);
     End;

Procedure Menu.Int_MenuIntensite;
Begin
     CTitle('Elektron. Module de calcul des intensit‚s');
     Writeln;
     SWriteln('1. I = Q/T    Intensit‚ dans un condensateur',NL);
     SWriteln('2. I = U/R    Intensit‚ traversant une r‚sistance',NL);
     MakeESC;
     GK;
     case ch of
          '1':Int_Condensateur;
          '2':Int_Dipole1;
          #0:Specials;
          #27:Exit;
          Else Int_MenuIntensite;
          End;
     If (ch=#27) then Exit;
     Int_MenuIntensite;
     End;

Procedure Menu.Fre_MenuFrequence;
Begin
     CTitle('Elektron. Module de calcul des fr‚quences');
     Writeln;
     SWriteln('1. N  = 1/T             Fr‚quence selon une p‚riode donn‚e',NL);
     SWriteln('2. N  = I/C.U           Fr‚quence d''un condensateur',NL);
     SWriteln('3. N  = 1/2*PiûLC       Fr‚quence d''un circuit RLC',NL);
     SWriteln('4. W0 = 1/ûLC           Pulsation propre d''un circuit RLC',NL);
     MakeESC;
     GK;
     case ch of
          '1':Fre_Periode;
          '2':Fre_Cond;
          '3':Fre_RLC;
          '4':Fre_Pulsat_RLC;
          #0:Specials;
          #27:Exit;
          Else Fre_MenuFrequence;
          End;
     if (ch=#27) then exit;
     Fre_MenuFrequence;
     End;

Procedure Menu.Fre_RLC;
Begin
     GetRes; GetInd; GetCap;
     If (L*C=0) then Begin DivByZero; Exit; End;
     Show(1/(2*Pi*Sqrt(L*C)),'Hz',MIN);
     End;

Procedure Menu.Fre_Pulsat_RLC;
Begin
     GetInd; GetCap;
     If (L*C=0) then Begin DivByZero; Exit; End;
     Show(1/Sqrt(L*C),' rad.s-1',MIN);
     End;

Procedure Menu.Fre_Periode;
Begin
     GetPeriod;
     if (T=0) then Begin DivByZero; Exit; End;
     Show(1/T,'Hz',MIN);
     End;

Procedure Menu.Fre_Cond;
Begin
     GetInt; GetCap; GetTens;
     If ((C*U)=0) then Begin DivByZero; Exit; End;
     Show(I/(C*U),'Hz',MIN);
     End;

Function SVal(A:Integer):String;
Begin
     Str(A,S);
     Sval:=S;
     End;

Procedure Menu.Res_Equiv_Serie;
Begin
     Y:=0;
     Equivalent:=0;
     Clrscr;
     Writeln('Rentrez les valeurs des diff‚rentes r‚sistances, puis 0 pour terminer');
     For Z:=1 To 32767 do
     Begin
          Inc(Y);
          If (Y=10) then Y:=1;
          Gotoxy(1,Y+3); ClrEol;
          Write('R',Sval(Z),'  : ');
          Readln(R);
          if (R=0) then Begin Show(Equivalent,'ê',MIN);
                                                    Exit;
                                           {ALT234} End;
          Equivalent:=Equivalent+R;
          End;
     Show(Equivalent,'ê',MIN); {ALT234}
     End;

Procedure Menu.Res_Equiv_Parral;
Begin
     Y:=0;
     Equivalent:=0;
     Clrscr;
     Writeln('Rentrez les valeurs des diff‚rentes r‚sistances, puis 0 pour terminer');
     For Z:=1 To 32767 do
     Begin
          Inc(Y);
          If (Y=10) then Y:=1;
          Gotoxy(1,Y+3);
          Write('R',Sval(Z),'  : ');
          Readln(R);
          If (R=0) then if (Equivalent=0) then
                                          Begin DivByZero; Exit; End Else
                                          Begin Show(1/Equivalent,' ê',MIN);
                                          Exit; End;
     Equivalent:=Equivalent+(1/R);
     End;
     If (Equivalent=0) then Begin DivByZero; Exit; End;
     Show(1/Equivalent,' ê',MIN); {ALT234}
     End;

Procedure Menu.Res_MenuResistance;
Begin
     CTitle('Elektron. Module de calcul des r‚sistances et des imp‚dances');
     Writeln;
     SWriteln('1.   R = R1+...+Rn      R‚sistance ‚quivalente (s‚rie)',NL);
     SWriteln('2. 1/R = 1/R1+...+1/Rn  R‚sistance ‚quivalente (parrallŠle)',NL);
     MakeESC;
     GK;
     case ch of
          '1':Res_Equiv_Serie;
          '2':Res_Equiv_Parral;
          #0:Specials;
          #27:Exit;
          Else Res_MenuResistance;
          End;
     if (ch=#27) then exit;
     Res_MenuResistance;
     End;

Procedure Menu.Con_General;
Begin
     GetInt; GetTens;
     If (U=0) then Begin DivByZero; Exit; End;
     Show(I/U,'S',MIN);
     End;

Procedure Menu.Con_MenuConductance;
Begin
     CTitle('Elektron. Module de calcul des conductances');
     Writeln;
     SWriteln('1. S = I/U             Expression g‚n‚rale de la conductance',NL);
     MakeESC;
     GK;
     Case ch of
          '1':Con_General;
          #0:Specials;
          #27:Exit;
          Else Con_MenuConductance;
          End;
     if (ch=#27) then exit;
     Con_MenuConductance;
     End;

Procedure Menu.Pow_MenuPuissance;
Begin
     CTitle('Elektron. Module de calcul des puissances');
     Writeln;
     SWriteln('1. P = U.I        Expression g‚n‚rale de la puissance',NL);
      Writeln('2. P = R.I^2      Puissance d''un dip“le ohmique');
     SWriteln('3. P = U^2/R',NL);
      Writeln('4. P = E.I-R.I^2  Puissance d''un g‚n‚rateur');
     SWriteln('5. P = U/R(E-U)',NL);
     SWriteln('6. å = PE/PS      Rendement d''un circuit',NL);
     SWriteln('7. Peff = P/û2    Puissance efficace',NL);
     MakeESC;
     GK;
     case upcase(ch) of
          '1':Pow_General;
          '2':Pow_Dipole1;
          '3':Pow_Dipole2;
          '4':Pow_Gene1;
          '5':Pow_Gene2;
          '6':Pow_Rendement;
          '7':Pow_Eff;
          #0:Specials;
          #27:Exit;
          Else Pow_MenuPuissance;
          End;
     If (ch=#27) then exit;
     Pow_MenuPuissance;
     End;

Procedure Menu.Pow_Eff;
Begin
     Write('Puissance         : ');
     Readln(R);
     Show(R/Sqrt(2),'W',MIN);
     End;

Procedure Menu.Pow_General;
Begin
     GetTens; GetInt;
     Show(U*I,'W',MIN);
     End;

Procedure Menu.Pow_Gene1;
Begin
     GetFem; GetInt; GetRes;
     Show(E*I-R*I*I,'W',MIN);
     End;

Procedure Menu.Pow_Gene2;
Begin
     UnAvailable;
     GK;
     End;

Procedure Menu.Pow_Dipole1;
Begin
     GetInt; GetRes;
     Show(R*I*I,'W',MIN);
     End;

Procedure Menu.Pow_Dipole2;
Begin
     GetTens; GetRes;
     Show((U*U)/R,'W',MIN);
     End;

Procedure Menu.Pow_Rendement;
Begin
     Write('Puissance … l''entr‚e       : '); Readln(I);
     Write('Puissance … la sortie      : ');  Readln(R);
     Write('Rendement                  : ');
     If (I=0) then Begin DivByZero; Exit; End;
     Show((R/I)*100,'%',NORMAL); Writeln;
     Write('                           : ');
     If (R/I=0) then Begin Writeln('Log 0 --> Impossible'); GK; Exit; End;
     Show((10*log(R/I)),' DB',NORMAL);
     End;

Procedure Menu.Cap_Equiv_Parral;
Begin
     Clrscr;
     SWriteln('Condensateurs en parrallŠle',NL);
     Y:=0;
     Equivalent:=0;
     Writeln('Rentrez les valeurs des diff‚rentes capacit‚s, puis 0 pour terminer');
     For Z:=1 To 32767 do
     Begin
          Inc(Y);
          If (Y=10) then Y:=1;
          Gotoxy(1,Y+3); ClrEol;
          Write('C',Sval(Z),'  : ');
          Readln(C);
          if (C=0) then Begin Show(Equivalent,' F',MIN);
                                                    Exit;
                                                    End;
          Equivalent:=Equivalent+C;
          End;
     Show(Equivalent,' F',MIN);
     End;

Procedure Menu.Cap_Equiv_Serie;
Begin
     Y:=0;
     Equivalent:=0;
     Clrscr;
     SWriteln('Condensateurs en s‚rie',NL);
     Writeln('Rentrez les valeurs des diff‚rentes capacit‚s, puis 0 pour terminer');
     For Z:=1 To 32767 do
     Begin
          Inc(Y);
          If (Y=10) then Y:=1;
          Gotoxy(1,Y+3);
          Write('C',Sval(Z),'  : ');
          Readln(C);
          If (C=0) then if (Equivalent=0) then
                                          Begin DivByZero; Exit; End Else
                                          Begin Show(1/Equivalent,' F',MIN);
                                          Exit; End;
     Equivalent:=Equivalent+(1/C);
     End;
     If (Equivalent=0) then Begin DivByZero; Exit; End;
     Show(1/Equivalent,' F',MIN);
     End;

Procedure Menu.Cap_MenuCapacite;
Begin
     CTitle('Elektron. Module de calcul des capacit‚s');
     Writeln;
     SWriteln('1.   C = C1+...+Cn     Capacit‚ de condensateurs en parrallŠle',NL);
     SWriteln('2. 1/C = 1/C1+...+1/Cn Capacit‚ de condensateurs en s‚rie',NL);
     MakeESC;
     GK;
     case ch of
          '1':Cap_Equiv_Parral;
          '2':Cap_Equiv_Serie;
          #27:Exit;
          Else Cap_MenuCapacite;
          End;
     if (ch=#27) then exit;
     Cap_MenuCapacite;
     End;

Procedure Menu.Cha_MenuCharge;
Begin
     Ctitle('Elektron. Module de calcul des charges ‚lectroniques');
     Writeln;
     SWriteln('1. Q = I.T    Charge d''un condensateur',NL);
     MakeESC;
     GK;
     case ch of
          '1':Cha_Condensateur;
          #0:Specials;
          #27:Exit;
          Else Cha_MenuCharge;
          End;
     if (ch=#27) then exit;
     Cha_MenuCharge;
     End;

Procedure Menu.Cha_Condensateur;
Begin
     GetInt;
     GetPeriod;
     Show(I*T,'C',MIN);
     End;

Procedure Menu.Tra_Beta;
Begin
     Write('Valeur de I Collecteur        : ');
     Readln(Beta);
     Write('Valeur de I Base              : ');
     Readln(I2);
     If (I2=0) then Begin DivByZero; Exit; End;
     Show(Beta/I2,' = Beta',MAX);
     End;

Procedure Menu.Tra_IBase;
Begin
     Write('B‚ta                          : ');
     Readln(Beta);
     Write('Courant de collecteur requis  : ');
     Readln(I2);
     If (Beta=0) then Begin DivByZero; Exit; End;
     Show(I2/Beta,'A',MAX);
     End;

Procedure Menu.Tra_ICollect;
Begin
     Write('B‚ta                          : ');
     Readln(Beta);
     Write('Courant de base disponible    : ');
     Readln(I2);
     Show(Beta*I2,'A',MAX);
     End;

Procedure Menu.Tra_MenuTransistor;
Begin
     CTitle('Elektron. Module de dimensionnement des transistors');
     Writeln;
     SWriteln('1. Beta = Ic/Ib    b‚ta d''un transistor',NL);
     SWriteln('2. Ic   = Beta.Ib  courant de collecteur',NL);
     SWriteln('3. Ib   = Ic/Beta  courant de base n‚c‚ssaire',NL);
     MakeESC;
     GK;
     Case ch of
          '1':Tra_Beta;
          '2':Tra_ICollect;
          '3':Tra_IBase;
          #0:Specials;
          #27:Exit;
          Else Tra_MenuTransistor;
          End;
     If (ch=#27) then Exit;
     Tra_MenuTransistor;
     End;

Procedure Menu.Trans_MenuTransfos;
Begin
     Ctitle('Elektron. Module de dimensionnement des transformateurs');
     Writeln;
     SWriteln ('1. Us = (Up.Ip) / Is  Tension au secondaire',NL);
     SWriteln ('2. Is = (Up.Ip) / Us  Courant au secondaire',NL);
     SWriteln ('3. Up = (Us.Is) / Ip  Tension au primaire',NL);
     SWriteln ('4. Ip = (Us.Is) / Up  Courant au primaire',NL);
     SWriteln('',NL);
     SWriteln('les valeurs doivent ˆtre entr‚es dans l''ordre de la formule',NL);
     MakeEsc;
     GK;
     Case ch of
          '1':Trans_US;
          '2':Trans_IS;
          '3':Trans_US;
          '4':Trans_IS;
          #0:Specials;
          #27:Exit;
          Else Trans_MenuTransfos;
          End;
     If (ch=#27) then Exit;
     Trans_MenuTransfos;
     End;

Procedure Menu.Trans_US;
Begin
     GetTens; GetInt; GetInt2;
     If (I2=0) then Begin DivByZero; Exit; End;
     Show(U*I/I2,'V',MIN);
     End;

Procedure Menu.Trans_IS;
Begin
     GetTens; GetInt; GetTens2;
     If (U2=0) then Begin DivByZero; Exit; End;
     Show(U*I/U2,'A',MIN);
     End;

Begin
     Ban.Banner;
     Men.Menu1;
     End.

