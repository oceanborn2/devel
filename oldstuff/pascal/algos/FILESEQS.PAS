(* Utilisation des primitives des files sequentielles *)

Program file_seq;

Type element = char;
     ptr     = ^cellule;
     cellule = Record
                     elem : element;
                     suiv : ptr;
     End;
     fileseq = Record
                     debut : ptr;
                     acces : ptr;
     End;

Procedure Init(Var f : fileseq);
Begin
     new(f.debut);
     f.acces:=f.debut;
     f.acces^.suiv:=Nil;
End;

Function FinFile(f : fileseq) : Boolean;
Begin
     FinFile:=(f.acces=Nil);
End;

Procedure PremierFile(Var f : fileseq);
Begin
     f.acces:=f.debut;
End;

Procedure Mettre(x : element; Var f : fileseq);
Var tmp : ptr;
Begin
     f.acces^.elem:=x;
     new(f.acces^.suiv);
     f.acces:=f.acces^.suiv;
     f.acces^.suiv:=Nil;
End;

Function Prendre(Var f : fileseq) : element;
Begin
     prendre:=f.acces^.elem;
     f.acces:=f.acces^.suiv;
End;

Function consulter(f : fileseq) : element;
Begin
     consulter:=f.acces^.elem;
End;

(* Programme qui stock le code ascii puis le reecrit

Var  files : fileseq;
     i     : integer;

Begin
     init(files);
     for i:=0 to 255 do
                       mettre(chr(i),files);
     premierfile(files);
     for i:=0 to 255 do
                       Write(prendre(files)+'/',i,'/');
End.

*)

(* Programme qui concatene deux files sequentielles

Var  file1, file2, file3: fileseq;
     i: integer;

Begin
     Init(file1);
     Init(file2);
     Init(file3);
     For i:=0 to 127 do
                       mettre(chr(i),file1);
     For i:=128 to 255 do
                         mettre(chr(i),file2);
     premierfile(file1);
     premierfile(file2);
     For i:=0 to 255 do
                       If i<128 then mettre(prendre(file1),file3)
                       Else mettre(prendre(file2),file3);
     premierfile(file3);
     For i:=0 to 255 do
                       Write(prendre(file3)+'/',i,'/');
End.

*)

(* Programme permettant l'insertion d'une file dans une autre *)

Var file1, file2, file3 : fileseq;
    i: integer;

Begin
     Randomize;
     init(file1);
     init(file2);
     init(file3);
     For i:=0 to 100 do if (random(4)<2) then mettre(chr(i),file1);
     WriteLn('Fin de 1ø boucle');
     For i:=0 to 100 do if (random(4)<2) then mettre(chr(i),file2);
     WriteLn('Fin de 2ø boucle');
     premierfile(file1);
     premierfile(file2);
     While not(finfile(file1) and finfile(file2)) Do
        Begin
           Write('*');
           While (consulter(file1)<consulter(file2)) and not(finfile(file1)) Do
               mettre(prendre(file1),file3);
           While (consulter(file2)<consulter(file1)) and not(finfile(file2)) Do
               mettre(prendre(file2),file3);
        End;
     premierfile(file3);
     While not(finfile(file3)) Do
                                 Write(prendre(file3)+'/');
End.