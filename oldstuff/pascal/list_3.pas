Program Liste_Doublement_Chainee;

Uses Crt;

Type StrPtr = ^Str_Rec;
     Str_Rec = Record
                 Prev : StrPtr;
                 Next : StrPtr;
                 Data : String;
               End;

Var Debut,Fin,
    Interm1,Interm2  : StrPtr;
    A                : String;
    Ch               : Char;

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
     Writeln (MemAvail);
     Debut:=Nil;
     Interm1:=Nil;
     Interm2:=Nil;
     Fin:=Nil;

     New(Debut);

     A:=' ';
     Fin:=Debut;
     Fin^.Next:=Nil;
     Fin^.Prev:=Nil;
     While A<>'' Do
     Begin
          A:=ReadString;
          Fin^.Data:=A;
          Interm1:=Fin;
          New(Interm2);
          Fin^.Next:=Interm2;
          Fin:=Fin^.Next;
          Fin^.Prev:=Interm1;
          End;
          Fin^.Next:=Nil;

     Fin:=Debut;
     While Fin^.Next<>Nil Do
     Begin
          If Fin^.Data<>'' Then Writeln (Fin^.Data);
          Fin:=Fin^.Next;
          End;

     Writeln;
     Fin:=Fin^.Prev;
     While Fin^.Prev<>Nil Do
     Begin
          If Fin^.Data<>'' Then Writeln (Fin^.Data);
          Fin:=Fin^.Prev;
          End;
          If Fin^.Data<>'' Then Writeln (Fin^.Data);

     Fin:=Debut;
     While Fin^.Next<>Nil Do
     Begin
          Fin:=Fin^.Next;
          Dispose(Fin^.Prev);
          Dispose(Fin);
          End;
     Writeln (MemAvail);
     Ch:=readkey;
     End.