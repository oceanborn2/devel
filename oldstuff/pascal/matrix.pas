{programme de r‚solution d'une matrice }
{m‚thode du pivot de gauss}
{Pascal Munerot - 01/11/1991 - Turbo Pascal 5.5}

Program Matrix;

Uses Crt,Dos,Printer;

Type LPtr = ^Ligne; {pointeur sur une ligne}
     Ligne = array [1..17] of Real; {structure d'une ligne}

Const Perm    : Boolean = False; {y a t'il eu une permutation }
      Prt     : Boolean = False; {impression ?}
      NewLine : Boolean = False; {sauter une ligne}

Var Taille  : Integer; {taille de la matrice}
    A       : array [1..16] of ^Ligne; {16 ‚quations maximum}
    S       : ^Ligne;
    Lig,Col : Integer; {lig < gauche du tableau, col > droite}
    I,J,K   : Integer;
    L,X     : Integer; {L : plus grande valeur en 1Šre colonne}
    P       : Pointer; {permutation de lignes}
    Ch      : Char;
    Max,Mem : Real;    {max : valeur max, mem : swapping}
    M       : Real;    {coefficient pour diviser la matrice}
    CptA    : Integer; {compteur d'affichage}

{tabulation de 15 caractŠres sur l'imprimante}
Procedure Tab15;
Begin
     Write(Lst,#28+#68+#1+#16+#31+#46+#61+#0);
     End;

Procedure ResetTab15;
Begin
     Write(Lst,#27+#82);
     End;

{message d'invite}
Procedure Banner;
Begin
     Clrscr;
     Writeln ('R‚solution de matrices');
     Writeln ('Pascal Munerot');
     Writeln;
     Writeln ('maximum : 16 ‚quations … 16 inconnues');
     Writeln ('          plus les constantes');
     Writeln;
     Writeln ('ne tenez pas compte des constantes dans la taille de la matrice');
     Writeln;
     Write ('entrez la taille de la matrice : ');
     Readln(Taille);
     If (Taille<2) Or (Taille>16) Then Banner;
     Writeln ('Voulez vous imprimer les r‚sultats (O pour imprimer) ? ');
     Ch:=Upcase(Readkey);
     If Ch='O' Then Begin Prt:=True; Tab15; End;
     End;

{libŠre la m‚moire de la matrice}
Procedure LibereMatrice;
Begin
     For Lig:=1 To Taille Do
     Begin
          If A[Lig]<>Nil Then Dispose(A[Lig]);
          End;
     Dispose(S);
     End;

{erreur en cours d'allocation de la m‚moire}
Procedure Echec;
Begin
     Writeln ('une erreur d''allocation de m‚moire vient de se produire');
     LibereMatrice;
     End;

{saisie une valeur}
Procedure Saisie;
Begin
     Write ('L',Lig,',C',Col,' = ');
     Readln(A[Lig]^[Col]);
     If (Lig=1) and (A[Lig]^[Col]=0) Then Begin Write(#7); Saisie; End;
     End;

{saisie de la matrice entiŠre}
Procedure LitMatrice;
Begin
     Clrscr;
     Writeln ('Initialisation et lecture de la matrice');
     Writeln;
     For Lig:=1 To Taille Do
     Begin
          A[Lig]:=Nil;
          New(A[Lig]);
          If A[Lig]=Nil Then Echec;
          End;
     S:=Nil;
     New(S); If S=Nil Then Echec;
     For Lig:=1 To Taille Do
     Begin
          Writeln;
          For Col:=1 To Taille+1 Do Saisie;
          End;
     End;

{affiche et / ou imprime la matrice}
Procedure AfficheMatrice (Eff : Boolean);
Begin
     If Eff Then Clrscr; {effacement s‚lectif de l'‚cran}
     If Prt Then Writeln (Lst,'');
     CptA:=-1;
     Gotoxy(1,2);
     For Lig:=1 To Taille Do {traite les lignes}
     Begin
          For Col:=1 To Taille+1 Do {traite les colonnes}
          Begin
               Inc(CptA);
               If CptA=5 Then Begin
                                   CptA:=0; Writeln;
                                   NewLine:=True;
                                   If Prt Then Writeln(Lst,'');
                                   End;
               Gotoxy(CptA*15,WhereY);
               Write ('L',Lig,'C',Col,' ',A[Lig]^[Col]:5:4,' ');
               {affiche le r‚sultat … l'‚cran}

               If Prt Then
               Begin  {‚dite les r‚sultats sur l'imprimante}
                    Write (Lst,'L',Lig,'C',Col,' ',A[Lig]^[Col]:5:4);
                    Write(Lst,#9);
                    End;
               End;

          If NewLine Then Begin {si nouvelle ligne alors, saute une ligne}
                               Writeln;
                               If Prt Then Writeln(Lst,'');
                               NewLine:=False;
                               End;
          CptA:=-1; Writeln;
          If Prt Then Writeln (Lst,''); {saut de ligne / imprimante}
          End;
     Ch:=Readkey;
     End;

{permute deux lignes de la matrice}
Procedure Permute;
Begin
     Perm:=True;
     Clrscr;
     Writeln ('L',j,' <--> L',l);
     If Prt Then Begin ResetTab15;
                       Writeln (Lst,'L',j,' <--> L',l);
                       Tab15;
                       End;
     For x:=1 To Taille+1 Do
     Begin
          Mem:=A[j]^[x];
          A[j]^[x]:=A[l]^[x];
          A[l]^[x]:=Mem;
          End;
     End;

{op‚ration sur les matrices}
Procedure MultiplieLJ_AjK;
Begin
     Gotoxy (1,1);
     Writeln ('L',k,' <-- L',k,' + L',j,' * ',M:5:3,'        ');
     If Prt Then Writeln (Lst,'L',k,' <-- L',k,' + L',j,' * ',M:5:3);
     For X:=1 To Taille+1 Do A[k]^[x]:=A[k]^[x]+A[j]^[x]*M;
     AfficheMatrice(False);
     End;

{cherche des lignes … permuter}
Procedure PermuterLignes;
Begin
     Max:=A[j]^[1];
     For i:=j to Taille Do
     Begin
          If Max < A[i]^[j] Then
          Begin
               l:=i; Max:=A[l]^[i];
               if l<>j Then Begin Permute;
                                  AfficheMatrice(False);
                                  End;
               End;
          End;
     End;

{traitement de la division par z‚ro}
Procedure DivByZero;
Begin
     Clrscr;
     Writeln ('division par z‚ro ...');
     Writeln ('abandon de la r‚solution de la matrice en cours');
     Writeln ('lib‚ration de la m‚moire allou‚e pour la matrice');
     LibereMatrice;
     Halt(1);
     End;

Procedure Resoudre(N:Integer);
Var Som : Real;
Begin
     Som:=A[n]^[Taille+1];
     For i:=n+1 To Taille Do Som:=Som - (A[n]^[i] * S^[i]);
     If A[n]^[n] = 0 Then DivByZero;
     S^[n]:=Som / A[n]^[n];
     If Prt Then Writeln (Lst,'Solution ',n,' --> ',S^[n]:5:3,'       ');
     Writeln ('Solution ',n,' --> ',S^[n]:5:3,'       ');
     End;

Procedure ResoudreEnSubst;
Begin
     If A[Taille]^[Taille]=0 Then DivByZero;
     S^[Taille]:=A[Taille]^[Taille+1] / A[Taille]^[Taille];
     For X:=Taille DownTo 1 Do Resoudre(X);
     Ch:=Readkey;
     End;

{r‚soud la matrice en m‚moire}
Procedure ResoudMatrice;
Begin
     Clrscr;
     Writeln ('MATRICE INITIALE');
     AfficheMatrice (False);
     For J:=1 To Taille Do
     Begin
          PermuterLignes;
          For K:=J+1 To Taille Do
          Begin
               If A[j]^[j] = 0 Then DivByZero;
               M:=-A[k]^[j] / A[j]^[j];
               MultiplieLJ_AjK;
               End;
          End; {fin du pivot}
     Clrscr;
     Writeln ('MATRICE FINALE');
     AfficheMatrice(False);
     Writeln('                                                                         ');
     If Prt Then Writeln (Lst,'');
     ResoudreEnSubst;
     End;

Begin
     Banner;
     LitMatrice;
     ResoudMatrice;
     LibereMatrice;
     If Prt Then ResetTab15;
     End.
