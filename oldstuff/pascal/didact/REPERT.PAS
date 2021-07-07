Program Repertoire;

Uses Crt,Printer;

Const Prt    : Boolean = False;

Var F        : Text;
    Critere  : String;
    Ch       : Char;
    I        : Integer;
    S        : String;
    Sens     : Integer;

Procedure Imprimante;
Begin
     Ch:=Upcase(Readkey);
     Case Ch of
          'O':Prt:=True;
          'N':Prt:=False;
          Else Imprimante;
          End;
     End;

Procedure PrendSens;
Begin
     Writeln;
     Write ('1. Sens Anglais / Francais .  2. Sens Francais / Anglais ');
     Readln(Sens);
     End;

Procedure Banner;
Begin
     Clrscr;
     Writeln ('Logiciel de gestion de rÇpertoire');
     Writeln;
     Writeln ('Voulez vous imprimez le texte sur imprimante (O/N) ? ');
     Imprimante;
     PrendSens;
     End;

Procedure Ecriture;
Begin
     If (Prt=True) Then Writeln (Lst,S);
     Writeln (S);
     End;

Procedure AF;
Begin
     If (Length(Critere)=1) Then If (Critere[1]=Upcase(S[1])) Then Begin Ecriture; Exit; End;
     If (Length(Critere)=2) Then If (Critere[1]=Upcase(S[1]))
                            And (Critere[2]=Upcase(S[2]))     Then Begin Ecriture; Exit; End;
     If (Length(Critere)=3) Then If (Critere[1]=Upcase(S[1]))
                            And (Critere[2]=Upcase(S[2]))
                            And (Critere[3]=Upcase(S[3]))     Then Begin Ecriture; Exit; End;
     End;

Procedure FA;
Var Posit : Integer;
    Tamp  : String;
Begin
     Posit:=Pos(':',S);
     If (Posit=0) Then Begin Writeln ('Caractäre : attendu en ligne : ',S); Halt(1); End;
     Tamp:=S;
     Delete (Tamp,1,Posit);
     While ((Tamp[1]=#9) or (Tamp[1]=' ')) Do Delete(Tamp,1,1);
     For I:=1 To Length(Tamp) Do
     Begin
          Tamp[i]:=Upcase(Tamp[i]);
          If (Tamp[i]='ä') or (Tamp[i]='Ç') Then Tamp[i]:='E';
          If (Tamp[i]='Ö') or (Tamp[i]='Ñ') Then Tamp[i]:='A';
          If (Tamp[i]='á') Then Tamp[i]:='C';
          End;
     If (Length(Critere)=1) Then If (Critere[1]=Upcase(Tamp[1])) Then Begin Ecriture; Exit; End;
     If (Length(Critere)=2) Then If (Critere[1]=Upcase(Tamp[1]))
                            And (Critere[2]=Upcase(Tamp[2]))     Then Begin Ecriture; Exit; End;
     If (Length(Critere)=3) Then If (Critere[1]=Upcase(Tamp[1]))
                            And (Critere[2]=Upcase(Tamp[2]))
                            And (Critere[3]=Upcase(Tamp[3]))     Then Begin Ecriture; Exit; End;
     End;

Procedure Lit;
Begin
     S:='';
     Assign (F,'Anglais.doc');
     Reset(F);
     While Not Eof(F) Do
     Begin
          Readln (F,S);
          Case Sens of
               1 : AF;
               2 : FA;
          End;
     End;
     Close(F);
     End;

Procedure Select;
Begin
     Write ('Critäre de recherche : ');
     Readln (critere);
     Writeln;
     If (Critere='') Then Halt(0);
     For I:=1 To Length(Critere) Do
     Begin
          Critere[i]:=Upcase(Critere[i]);
          If (Critere[i]='ä') or (Critere[i]='Ç') Then Critere[i]:='E';
          If (Critere[i]='Ö') or (Critere[i]='Ñ') Then Critere[i]:='A';
          If (Critere[i]='á') Then Critere[i]:='C';
          End;
     If (Prt=True) Then Begin Writeln (Lst,Critere+':'); Writeln (Lst,''); End;
     Writeln;
     Lit;
     Writeln; Writeln; If (Prt=True) Then Writeln (Lst,'');
     Select;
     End;


Begin
     Banner;
     Select;
     End.
