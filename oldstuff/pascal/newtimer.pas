Program TimeManager;

Uses Crt,Dos;

Var  Timer    : Procedure;
     N,Iter   : Integer;
     X,Y      : Integer;
     I1,I2,I3 : Integer;

{$F+}

Procedure NewTimer; Interrupt;
Begin
     Sound(Random(3000));
     Delay (3); NoSound;
     Inline($9C);
     Timer;
     End;

{$F-}

Begin
     Clrscr;
     GetIntVec($8,@Timer);
     SetIntVec($8,Addr(NewTimer));
     Keep(0);
     End.

