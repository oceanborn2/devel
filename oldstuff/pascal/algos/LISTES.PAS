Program Liste_Chainee_Simple;

Uses Crt;

Type

    StrPtr = ^Str_Rec;
    Str_Rec = Record
                    Data : String;
                    Next : StrPtr;
               End;

Var Debut,Fin,Interm : StrPtr;
    A                : String;

Function ReadString : String;
Var S : String;
Begin
     S:='';
     Writeln ('Entrez une chaine quelquonque : ');
     Readln(S);
     ReadString:=S;
     End;

Begin
     Clrscr;

     Debut:=Nil;
     Fin:=Nil;
     Interm:=Nil;

     New(Debut);
     Fin:=Debut;
     A:=' ';
     While A<>'' Do
     Begin
          A:=ReadString;
          New(Interm);
          Fin^.Data:=A;
          Fin^.Next:=Interm;
          Fin:=Fin^.Next;
          Fin^.Next:=Nil;
          End;

     Fin:=Debut;
     While Fin^.Next<>Nil Do
     Begin
          Writeln (Fin^.Data);
          Fin:=Fin^.Next;
          End;

     Fin:=Debut;
     While Fin^.Next<>Nil Do
     Begin
          Interm:=Fin;
          Dispose(Interm);
          Fin:=Fin^.Next;
          End;
     End.
