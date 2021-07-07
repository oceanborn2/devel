Program Solde_Rip;

Uses Crt,Dos,Printer;

Var Prt : Boolean;
    Fil : Boolean;
    Ch  : Char;
    F,G : Text;
    S   : String;
    Code,
    Posit : Integer;
    Solde,
    Debit,
    Credit : Real;

Procedure Banner;
Begin
     Solde:=0;
     Debit:=0;
     Credit:=0;
     Clrscr;
     Writeln ('RIP _ Calcul du solde d''un CCP');
     Writeln ('(C) 1991. Pascal Munerot');
     Writeln;
     End;

Procedure GetPrint;
Begin
     Write ('Impression des donn‚es (O/N) ? ');
     Ch:=Readkey;
     Prt:=False;
     If Upcase(Ch)='O' Then Prt:=True;
     Writeln(CH); Writeln;
     End;

Procedure GetFile;
Begin
     Write ('Sauvegarde des r‚sultats dans le fichier RIP.SLD (O/N) ? ');
     Ch:=Readkey;
     Fil:=False;
     If Upcase(Ch)='O' Then Fil:=True;
     Writeln(CH); Writeln;
     If Fil=True Then Begin
                      Assign (G,'RIP.SLD');
                      {$i-}
                      DosError:=0;
                      Rewrite(G);
                      {$i+}
                      If DosError<>0 Then
                      Begin
                           Writeln ('Erreur en fichier de sortie');
                           Writeln ('Celui-ci ne sera pas ouvert');
                           End;
                      End;
     End;

Function  SkipBlanks(A:String):String;
Begin
     While ((A[1]=#9) or (A[1]=' ')) Do Delete(A,1,1);
     SkipBlanks:=A;
     End;

Procedure LoadFile;
Var SX : String;
Begin
     Assign (F,'RIP.DOC');
{$i-}
     DosError:=0;
     Reset(F);
{$i+}
     If DosError<>0 Then Begin Writeln ('Erreur en fichier ...'); Halt(1); End;
     GetPrint;
     GetFile;
     Readln(F,S);
     While Not Eof (F) Do
     Begin
          Readln (F,S);
          S:=SkipBlanks(S);

          Posit:=Pos('_',S);    {LECTURE DE LA DATE}
          SX:=Copy (S,1,Posit);
          Delete(S,1,Posit);
          S:=SkipBlanks(S);
          Write (SX+' ');
          If Fil=True Then Write(G,SX+' ');
          If Prt=True Then Write(Lst,SX+' ');

          Posit:=Pos('_',S);
          SX:=Copy (S,1,Posit);
          Delete(S,1,Posit);
          S:=SkipBlanks(S);
          Write (SX+' ');
          If Fil=True Then Write(G,SX+' ');
          If Prt=True Then Write(Lst,SX+' ');

          Posit:=Pos('_',S);
          SX:=Copy(S,1,Posit-1);
          SX:=SkipBlanks(SX);
          Delete(SX,Length(SX),1);
          Val(SX,Debit,Code);
          Delete(S,1,Posit);
          S:=SkipBlanks(S);

          SX:=S;
          Val(SX,Credit,Code);
          Solde:=Solde+Credit-Debit;
          Writeln ('   ',Solde:3:2);
          If Fil=True Then Writeln (G,'    ',Solde:3:2);
          If Prt=True Then Writeln (Lst,'    ',Solde:3:2);
          End;
     Close(F);
     If (Fil=True) And (DosError=0) Then Close(G);
     End;

Begin
     Banner;
     LoadFile;
     End.