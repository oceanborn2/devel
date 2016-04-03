Program Equat_ax_b;

Var A,B : Real;

Procedure Lit_AB; {lecture des paramŠtres}
Begin
     Write ('A = ');
     Readln(A);
     If A=0 Then Begin Writeln ('Fin d''‚x‚cution'); Exit; End;
                               {termine quand A = 0}
     Write ('B = ');
     Readln(B);        {lecture de B}
     Writeln;
     Writeln ('Solution : ',-B/A:5:2); {Affiche la solution}
     Lit_AB;
     End;

Begin  {point d'entr‚e du programme}
     Writeln ('R‚solution d''une ‚quation du type ax+b=0');
     Writeln;
     Lit_AB;
     End.
