Program Fichiers_Textes;

Uses Crt,Dos;

Type  FileR = Record
              Inutile : array [1..12] of byte;
              End;

Const MD : Array [0..3] of String[6]=('CLOSED','INPUT','OUTPUT','INOUT');
Var F : Text;
    C : Char;
    I : Integer;

{$R-,S-}

Procedure Status;
Begin
     Writeln('MODE     : ',MD[TextRec(F).Mode xor $D7B0]);
     Writeln('HANDLE   : ',TextRec(F).Handle);
     Writeln('BUFSIZE  : ',TextRec(F).BufSize);
     Writeln('NAME     : ',TextRec(F).Name);
     Write  ('USERDATA : ');
     For I:=1 To 16 Do Write(TextRec(F).UserData[i]);
     Writeln;
     Writeln('BUFPOS   : ',TextRec(F).BufPos);
     Writeln('BUFEND   : ',TextRec(F).BufEnd);
     Writeln; Writeln; C:=Readkey;
     End;

Begin
     Clrscr;
     Assign (F,'essai.dat');
     Writeln ('Etat du fichier avant ouverture ');
     Status;

     Rewrite(F);
     Writeln ('Etat du fichier apräs ouverture ');
     Status;

     Writeln (F,'chaine de caractäres quelquonque pour voir ce qu''il');
     Writeln (F,'ce passe pendant une Çcriture sur disque');
     Status;

     Close(F);
     Writeln ('Etat du fichier apräs fermeture ');
     Status;
     End.
