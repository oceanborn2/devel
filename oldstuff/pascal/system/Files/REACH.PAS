Program Reach;

Uses Crt,Dos;

Const Found   : Boolean = False;  {bool‚en : r‚pertoire trouv‚ ?}
      Several : Boolean = False;  {bool‚en : nom de r‚pertoire non unique}

Var F      : Text;
    Chemin : String;
    S      : String;
    V,
    Code,
    Nb     : Integer;
    Nom,
    Rep,
    Rac,
    Commande    : String;

Procedure Banner;
Begin
     Writeln; Writeln;
     Writeln ('Reach - Pascal Munerot - 1992');
     Writeln;
     Writeln ('Usage : ');
     Writeln;
     Writeln ('REACH <repertoire | raccourci>');
     Writeln;
     Writeln ('Utilisation non commerciale uniquement');
     Halt(1);
     End;

Function SkipBlanks (A: String) : String;
Var I : Integer;
Begin
     I:=Pos(#9,A);
     While I>0 Do
     Begin
          Delete(A,I,1);
          I:=Pos(#9,A);
          End;
     I:=Pos(' ',A);
     While I>0 Do
     Begin
          Delete(A,I,1);
          I:=Pos(' ',A);
          End;
     For I:=1 To Length(A) Do A[i]:=Upcase(A[i]);
     SkipBlanks:=A;
     End;

Begin
     {$i-}
     If (ParamCount <  1) Then Banner;
     If (ParamCount >= 1) Then
          Begin
            Commande:=ParamStr(2);
            Val(Commande,Nb,Code);
            If (Code = 0) Then Several:=True;
          End;
     If Not Several Then Nb:=1;
     Commande:=SkipBlanks(ParamStr(1));
     Assign (F,'REACH.DAT');
     Reset(F);
     Found:=False;
     While Not Eof (F) Do
     Begin
          Readln(F,S);        {lecture d'une ligne du fichier REACH.DAT}

          V:=Pos(',',S);      {acquisition du nom de l'application}
	  Nom:=Skipblanks(Copy(S,1,V-1));
          Delete(S,1,V);

	  V:=Pos(',',S);      {acquisition du r‚pertoire … positionner}
	  Rep:=SkipBlanks(Copy(S,1,V-1));
          Delete(S,1,V);

	  Rac:=SkipBlanks(S); {acquisition du nom raccourci}

          {si bon r‚pertoire, alors on effectue le changement de r‚pertoire}

          If (Commande = Rac) Then
                              Begin
                                Dec(Nb);
                                If (Nb = 0) Then
                                  Begin
                                    ChDir(Rep);
                                    Found:=True;
                                    End;
                              End;
          If (Commande = Rep) Then
                              Begin
                                Dec(Nb);
                                If (Nb = 0) Then
                                  Begin
                                    ChDir(Rep);
                                    Found:=True;
                                    End;
                              End;
          If (Commande = Nom) Then
                              Begin
                                Dec(Nb);
                                If (Nb = 0) Then
                                  Begin
                                    ChDir(Rep);
                                    Found:=True;
                                    End;
                              End;
          End;
        Close(F);
        End.
