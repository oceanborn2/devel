Program Rotations;

Uses Crt;

Const Essai : String = 'chaine … crypter';

Var A     : Byte;
    I,J,X : Integer;

Function ROL (B,C : Byte) : Byte; Inline ($59/$58/$D2/$C0/$30/$E4);
                                  {59    POP CX}
                                  {58    POP AX}
                                  {D2/C0 ROL AL,CL}
                                  {30/E4 XOR AH,AH}

Function ROR (B,C : Byte) : Byte; Inline ($59/$58/$D2/$C8/$30/$E4);
                                  {59    POP CX}
                                  {58    POP AX}
                                  {D2/C0 ROR AL,CL}
                                  {30/E4 XOR AH,AH}


Begin
     Clrscr;
     For I:=1 To Length(Essai) Do Write(Chr(Rol(Ord(Essai[i]),1 mod 8)));
     Writeln; Writeln;
     For I:=1 To Length(Essai) Do Write(Chr(Rol(Ord(Essai[i]),2 mod 8)));
     Writeln; Writeln;
     For I:=1 To Length(Essai) Do Write(Chr(Rol(Ord(Essai[i]),3 mod 8)));
     Writeln; Writeln;
     For I:=1 To Length(Essai) Do Write(Chr(Rol(Ord(Essai[i]),4 mod 8)));
     Writeln; Writeln;
     For I:=1 To Length(Essai) Do Write(Chr(Rol(Ord(Essai[i]),5 mod 8)));
     Writeln; Writeln;
     For I:=1 To Length(Essai) Do Write(Chr(Rol(Ord(Essai[i]),6 mod 8)));
     Writeln; Writeln;
     For I:=1 To Length(Essai) Do Write(Chr(Rol(Ord(Essai[i]),7 mod 8)));
     Writeln; Writeln;
     For I:=1 To Length(Essai) Do Write(Chr(Rol(Ord(Essai[i]),8 mod 8)));
     Writeln; Writeln;
     Writeln (Essai);
     For I:=1 To 32000 Do
     For J:=1 To Length(Essai) Do Essai[j]:=Chr(Rol(Ord(Essai[j]),I mod 256));
     Writeln; Writeln;
     Writeln (essai);
     End.
