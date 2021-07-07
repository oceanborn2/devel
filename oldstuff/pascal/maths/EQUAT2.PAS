Program Equat_ax2_bx_c;

Uses Crt;

Var A,B,C,D : Real;

Procedure Lit_ABC; {lecture des paramŠtres}
Begin
     Write ('A = ');
     Readln(A);
     If A=0 Then Begin
                       Writeln ('Fin d''‚x‚cution');
                       Exit;
                       End; {termine si a = 0}
     Write ('B = ');
     Readln(B);        {lecture de B}
     Write ('C = ');
     Readln(C);        {lecture de C}
     Writeln;
     D:=Sqr(B)-4*A*C;
     If D<0 Then Begin
                      Writeln ('Pas de solutions r‚elles');
                      Writeln;
                      End;
     If D>=0 Then Begin
                      Writeln ('Deux solutions : ');
                      Writeln ('x1= ',(-B-Sqrt(D))/2*A:5:2);
                      Writeln ('x2= ',(-B+Sqrt(D))/2*A:5:2);
                      End;
     Lit_ABC;
     End;

Begin  {point d'entr‚e du programme}
     Clrscr;
     Writeln ('R‚solution d''une ‚quation du type ax^2+bx+c=0');
     Writeln;
     Lit_ABC;
     End.
