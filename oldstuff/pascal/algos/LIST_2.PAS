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

     Debut:=Nil;
     Fin:=Nil;
     Interm:=Nil;

     New(Debut);
     Fin:=Debut;
     A:=' ';

     {lecture des donn‚es}
     While A<>'' Do
     Begin
          A:=ReadString;
          New(Interm);
          Fin^.Data:=A;
          Fin^.Next:=Interm;
          Fin:=Fin^.Next;
          Fin^.Next:=Nil;
          End;

     {affichage de la liste}
     Fin:=Debut;
     While Fin^.Next<>Nil Do
     Begin
          Writeln (Fin^.Data);
          Fin:=Fin^.Next;
          End;

     {destruction de le pen}
     Fin:=Debut;
     While Fin^.Next<>Nil Do
     Begin
          If Fin^.Next^.Data='le pen' Then
          Begin
               Dispose(Fin^.Next);
               Fin^.Next:=Fin^.Next^.Next;
               End Else Fin:=Fin^.Next;
          End;

     {affichage de la liste}
     Fin:=Debut;
     While Fin^.Next<>Nil Do
     Begin
          Writeln (Fin^.Data);
          Fin:=Fin^.Next;
          End;

     {restauration de la m‚moire}
     Fin:=Debut;
     While Fin^.Next<>Nil Do
     Begin
          Interm:=Fin;
          Dispose(Interm);
          Fin:=Fin^.Next;
          End;
     End.
