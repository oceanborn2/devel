Program Magnet;

Uses Crt,Graph;

Const
     dt = 0.41888;
     x:real=-110;
     z:real=0;

Var
   Card,mode     : integer;
   ib,i,nb,_a    : integer;
   _i,_j         : integer;
   xp,yp,th      : integer;
   x2,y2         : integer;
   a,xc,zc       : array [1..5] of integer;
   al,_in        : array [1..5] of real;

   csDT,csIB     : array [1..16] of real;
   snDT,snIB     : array [1..16] of real;

   rx,ry,rz,r,r3 : real;
   lx,ly,lz      : real;
   dx,dz         : real;
   bx,bz,b       : real;

   ch            : char;

Procedure NbAimants;
Begin
     Clrscr;
     Writeln ('TP - Champs magn‚tiques ');
     Writeln;
     Write('nombre de bobines : ');
     readln(nb);
     if (nb<1) or (nb>5) then nbaimants;
     End;

Procedure PrendParams;
Begin
     For I:=1 to NB Do
     Begin
          Clrscr;
          Writeln ('Bobine n ø ',I);
          Writeln;
          Write   ('rayon entre 10 et 100                      : ');
          Readln (a[i]);
          Writeln;
          Write   ('position du centre en x entre 0 et 640     : ');
          Readln (zc[i]);
          Writeln;
          Write   ('position du centre en y entre -100 et 100  : ');
          Readln (xc[i]);
          Writeln;
          Writeln ('angle entre l''axe de la spire et l''axe des ');
          Writeln ('abcisses en degr‚s                         : ');
          Readln (_a);
          Al[i]:=((_A*Pi/180));
          Writeln;
          Writeln ('intensit‚ du courant entre 0 et 5          : ');
          Readln (_in[i]);
          Writeln;
          Clrscr;
          End;
     End;

Procedure PrepareCalcs;
Var B:Real;
Begin
     B:=0;
     For I:=1 To 16 Do
     Begin
          snDT[i]:=Sin(B);
          snIB[i]:=Sin(Al[i]);
          csDT[i]:=Cos(B);
          csIB[i]:=Cos(Al[i]);
          B:=B+DT;
          End;
     End;

Procedure Gosub1000;
Begin
     DX:=LY*RZ-LZ*RY;
     DZ:=LX*RY-LY*RX;
     End;

Procedure Gosub800;
Begin
     For TH:=1 To 15 Do
     Begin
          LX:=-A[ib] * snDT[th] * csIB[ib] * DT;
          LY:= A[ib] * csDT[th] * DT;
          LZ:=-A[ib] * snDT[th] * snIB[ib] * DT;
          RX:=X-(XC[ib] + A[ib] * csDT[th] * csIB[ib]);
          RY:=-A[ib] * snDT[th];
          RZ:=Z-(ZC[ib] + A[ib] * csDT[th] * snIB[ib]);
          Gosub1000;
          R:=Sqrt(RX * RX + RY * RY + RZ * RZ);
          R3:=R * R * R;
          BX:=BX+_IN[ib]*DX/R3;
          BZ:=BZ+_IN[ib]*DZ/R3;
          End;
     End;

Procedure Init;
Begin
     Card:=Detect;
     InitGraph(Card,Mode,'');
     SetBkColor(0);
     SetColor(1);
     ClearDevice;
     End;

Procedure DoMain;
Begin
     For _I:=1 To 21 Do
     Begin
          For _J:=1 To 63 Do
          Begin
               BX:=0; BZ:=0;
               For IB:=1 To NB Do Gosub800;
               XP:=Round(Z+10); YP:=Round(X+120);
               B:=Sqrt(BX * BX + BZ * BZ);
               If (B=0) then B:=B+0.1;
               If (B>0.1) then Begin BX:=(BX*0.1)/B; BZ:=(0.1*BZ/B); End;
               If (B<0.03) then Begin BX:=(BX*0.03)/B; BZ:=(0.03*BZ)/B; End;
               X2:=Round(XP + BZ * 100);
               Y2:=Round(YP + BX * 100);
               Line(XP,YP,X2,Y2);
{               Writeln ('B :',B);
               Writeln ('BZ:',BZ);
               Writeln ('BX:',BX);
               Writeln ('XP:',XP);
               Writeln ('YP:',YP);
               Writeln ('X2:',X2);
               Writeln ('Y2:',Y2);
               ch:=readkey;
               clrscr;
}               Z:=Z+10.1;
               End;
               Z:=0;
               X:=X+10.1;
          End;
     End;

Procedure ExitOnS;
Begin
     ch:=readkey;
     if ch<>'S' then ExitOnS;
     End;

Begin
     NbAimants;
     PrendParams;
     PrepareCalcs;
     Init;
     DoMain;
     ExitOnS;
     CloseGraph;
     End.


