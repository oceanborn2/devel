PROGRAM SCROLL;

Uses Crt;

Const Max : Integer = 0;

Type StPtr = ^String;

Var L    : Array [1..512] of StPtr;
    I    : Integer;
    F    : Text;
    S    : String;

Procedure FreeAll;
Begin
     For I:=1 To Max Do
     Begin
          If L[i]<>Nil Then Freemem(L[i],Length(L[i]^)+2);
          L[i]:=Nil;
          End;
     End;

Procedure Alloc;
Begin
     Inc(Max);
     L[Max]:=Nil;
     GetMem(L[Max],Length(S)+2);
     If L[Max]=Nil Then Begin Writeln ('erreur m‚moire'); Freeall; Halt(1); End;
     L[Max]^:=S;
     End;

Procedure OpenFile;
Begin
     S:='';
     Assign (F,'a:scroll.pas');
     Reset(F);
     While Not Eof (F) Do
     Begin
          Readln(F,S);
          Alloc;
          End;
     Close(F);
     End;

Procedure ShowFile;
Begin
     For I:=1 To Max Do Writeln (L[i]^);
     End;

Begin
     Clrscr;
     OpenFile;
     ShowFile;
     FreeAll;
     End.
