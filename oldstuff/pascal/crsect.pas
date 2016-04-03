Program CrSect;

Uses Crt,Disk;

Type

    Banner = Object
             Unite     : Byte;
             Constructor Banner;
             Destructor  Done;
             Procedure Mode;
             End;

    Buffer = Array [1..512*9] of Char;

    Crypte   = Object(Banner)
             P1 : Buffer;
             P2 : Buffer;
             P3 : Buffer;
             P4 : Buffer;
             Erreur : Integer;
             NbLu   : Integer;
             Code   : String;
             Constructor Init;
             Procedure DispParams(Fac : Integer; M : String; SecondOne : Boolean);
             Procedure DoIt;
             Destructor Done;
             End;

Var Ch : Char;
    I  : Integer;
    Cr : Crypte;

Constructor Banner.Banner;
Begin
     Clrscr;
     Writeln ('Encrypteur de disque(ttes) ');
     Writeln ('Pascal Munerot');
     End;

Destructor Banner.Done;
Begin
     End;

Procedure Banner.Mode;
Var S : String;
Begin
     Unite:=0;
     If ParamCount=0 Then
                     Begin
                          Write('Unit‚ : ');
                          Readln(Ch);
                     End
                     Else
                     Begin
                          S:=ParamStr(1);
                          Ch:=S[1];
                     End;
     Unite:=Ord(Upcase(Ch))-65;
     End;

Constructor Crypte.Init;
Begin
     Banner;
     Mode;
     DoIt;
     End;

Procedure Crypte.DispParams (Fac : Integer; M : String; SecondOne : Boolean);
Begin
     Gotoxy(1,7);
     Write(M+'Unite ');
     Writeln(Chr(65+Unite)+': ');
     If SecondOne Then
                      Writeln('Piste        : ',I+1)
                  Else
                      Writeln('Piste        : ',I);
     Writeln('Face         : ',Fac);
     Writeln('Lus/Ecrits   : ',NbLu);
     If Erreur<>0 Then Writeln ('Erreur d‚tect‚e : ');
     WriteError(Erreur);
     Writeln;
     End;

Procedure Crypte.DoIt;
Var J,K   : Integer;
    LCode : Integer;
Begin
     If ParamCount<2 Then
     Begin
          Writeln;
          Writeln ('Vous avez omis le code de cryptage / d‚cryptage');
          Halt(1);
          End Else Code:=ParamStr(2);
     Writeln ('Appuyez sur une touche pour commencer le cryptage');
     Ch:=Readkey;
     For I:=1 To 39 Do
     Begin
          Erreur:=ReadSectors(Unite,0,I,1,9,Seg(P1),Ofs(P1),NbLu);
          DispParams(0,'Lecture ',False);
          Erreur:=ReadSectors(Unite,1,I,1,9,Seg(P2),Ofs(P2),NbLu);
          DispParams(1,'Lecture ',False);
          Erreur:=ReadSectors(Unite,0,I+1,1,9,Seg(P3),Ofs(P3),NbLu);
          DispParams(0,'Lecture ',True);
          If I+1<=39 Then
          Begin
               Erreur:=ReadSectors(Unite,1,I+1,1,9,Seg(P4),Ofs(P4),NbLu);
               DispParams(1,'Lecture ',True);
               End;
          K:=0;
          LCode:=Length(Code);
          RandSeed:=Lcode + Ord(Code[1]);
          For J:=1 To 512*9 Do
          Begin
               Inc(K);
               P1[j]:=Chr(Ord(P1[j]) xor random(10) xor Ord(Code[k]));
               P2[j]:=Chr(Ord(P2[j]) xor random(10) xor Ord(Code[k]));
               P3[j]:=Chr(Ord(P3[j]) xor random(10) xor Ord(Code[k]));
               If I+1<=39 Then
               P4[j]:=Chr(Ord(P4[j]) xor random(10) xor Ord(Code[k]));
               Inc(K);
               If (K=Lcode+1) Then K:=0;
               End;
          Erreur:=WriteSectors(Unite,0,I,1,9,Seg(P1),Ofs(P1),NbLu);
          DispParams(0,'Ecriture ',False);
          Erreur:=WriteSectors(Unite,1,I,1,9,Seg(P2),Ofs(P2),NbLu);
          DispParams(1,'Ecriture ',False);
          Erreur:=WriteSectors(Unite,0,I+1,1,9,Seg(P3),Ofs(P3),NbLu);
          DispParams(0,'Ecriture ',True);
          If I+1<=39 Then
          Begin
               Erreur:=WriteSectors(Unite,1,I+1,1,9,Seg(P4),Ofs(P4),NbLu);
               DispParams(1,'Ecriture ',True);
               End;
          Inc(I);
          End;
     End;

Destructor Crypte.Done;
Begin
     End;

Begin
     Cr.Init;
     Cr.Done;
     End.
