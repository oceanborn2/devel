Program IOCTL;

Uses Crt,Dos;


Var I  : Integer;
    Ch : Char;
    ST : String;

Procedure Receive (Var S : Char);
Var Regs : Registers;
Begin
     regs.ax:=$4402;
     regs.bx:=1;
     regs.cx:=1;
     regs.ds:=seg(S);
     regs.dx:=ofs(S)+1;
     intr($21,regs);
     Writeln (regs.flags);
     Writeln ('octets transmis : ',regs.ax);
     End;

Begin
     ST:='';
     For I:=1 To 4 DO
     Begin
           Ch:=Readkey;
           Receive(St[i]);
           End;
     Writeln(ST);
     End.
