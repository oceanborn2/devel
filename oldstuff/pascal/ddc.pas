Program File_Destroyer;

Uses Crt,Dos;

Type
    Banner = Object
             Procedure Banner;
             End;

    Destroyer = Object
                Bloc:Integer;
                Ch:char;
                F:File;
                Taille:Longint;
                P:Pointer;
                DirInfo:SearchRec;
                Chemin:String;
                Procedure Init;
                Procedure Terminate;
                Procedure DoIt;
                Procedure Confirm;
                Procedure SearchFiles;
                Procedure GetPath;
                Procedure Destroy;
                End;

Var
   Ban : Banner;
   Dest: Destroyer;

Procedure Banner.Banner;
Begin
     Clrscr;
     Writeln ('DDC - SystŠme de destruction de donn‚es confidentielles');
     Writeln ('Copyright (c) 1991. Pascal Munerot');
     Writeln;
     End;

Procedure Destroyer.Init;
Begin
     Bloc:=0;
     GetMem(P,512);
     If (P=Nil) then Halt(1);
     Fillchar(P^,512,'ö');
     End;

Procedure Destroyer.GetPath;
Begin
     Write('Chemin : ');
     Readln(Chemin);
     End;

Procedure Destroyer.SearchFiles;
Begin
     FindFirst(Chemin,AnyFile,DirInfo);
     While DosError = 0 Do
     Begin
          Confirm;
          FindNext(DirInfo);
          End;
     End;

Procedure Destroyer.Terminate;
Begin
     If Taille<0 then Inc(Taille,512);
     BlockWrite(F,P^,Taille);
     Close(F);
     Gotoxy(1,3);
     Writeln('Destruction effective du fichier');
     Erase(F);
     End;

Procedure Destroyer.DoIt;
Begin
     Bloc:=0;
     Assign (F,DirInfo.Name);
     Reset(F,1);
     Taille:=FileSize(F);
     Close(F);
     Rewrite(F,1);
     While Taille <> 0 Do
     Begin
          If (Taille>=512) then Begin
                                Inc(Bloc);
                                Gotoxy (1,3);
                                Writeln ('Bloc : ',Bloc);
                                BlockWrite(F,P^,512);
                                End Else Begin
                                                       Terminate;
                                                       Exit;
                                                       End;
          Dec(Taille,512);
          End;
     End;

Procedure Destroyer.Confirm;
Begin
     Clrscr;
     Write('Fichier : ',DirInfo.Name);
     Gotoxy (50,1); Writeln('Taille : ',DirInfo.Size);
     Writeln ('Dois-je d‚truire ce fichier ? (O/N) ? ');
     ch:=readkey;
     case upcase(ch) of
          'O':DoIt;
          'N':;
          Else Confirm;
          End;
     End;

Procedure Destroyer.Destroy;
Begin
     GetPath;
     SearchFiles;
     End;

Begin
     Ban.Banner;
     Dest.Init;
     Dest.Destroy;
     End.
