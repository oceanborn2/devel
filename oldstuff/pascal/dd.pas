Program Disk_Destroyer;

Uses Crt,Dos;

Type
    Banner = Object
             Procedure Banner;
             End;

    Destroyer = Object
                Total:Boolean;
                Taille:Longint;
                P:Pointer;
                F:File;
                Unite:char;
                Num:Word;
                ch:char;
                Bloc:Integer;
                DirInfo:SearchRec;
                Procedure DoItEntirely;
                Procedure DoItFree;
                Procedure Terminate;
                Procedure Mode;
                Procedure Confirm;
                Procedure Init;
                Procedure GetPath;
                Procedure DoIt;
                End;

Var
   Ban : Banner;
   Dest: Destroyer;

Procedure Banner.Banner;
Begin
     Clrscr;
     Writeln ('DD - SystŠme de destruction de donn‚es stock‚es sur disque');
     Writeln ('Copyright (c) 1991. Pascal Munerot');
     Writeln;
     End;

Procedure Destroyer.Init;
Begin
     total:=false;
     Bloc:=0;
     GetMem(P,32000);
     If (P=Nil) then Halt(1);
     Fillchar(P^,32000,'ö');
     End;

Procedure Destroyer.Confirm;
Begin
     Clrscr;
     Write('Disque : ',Upcase(Unite));
     Num:=Ord(Upcase(Unite))-64;
     If Not(Upcase(Unite) in ['A'..'Z']) then Begin
                                         Writeln ('Erreur ...');
                                         Halt(1);
                                         End;
     Write('     Total : ',DiskSize(Num));
     Writeln('     Libre : ',DiskFree(Num));
     Writeln ('Dois-je d‚truire le contenu de ce disque ? (O/N) ? ');
     ch:=readkey;
     case upcase(ch) of
          'O':;
          'N':Halt(0);
          Else Confirm;
          End;
     End;

Procedure Destroyer.Mode;
Begin
     Clrscr;
     Writeln('Destruction de la (T)otalit‚ du disque ou de l''(E)space libre ? ');
     ch:=readkey;
     case upcase(ch) of
          'T':total:=true;
          'E':total:=false;
          End;
     End;

Procedure Destroyer.DoItEntirely;
Begin
     Writeln('Effa‡age de la totalit‚ du disque');
     Writeln('Nombre de blocs … effacer : ',DiskSize(Num) div 32000);
     Writeln('Touche [ESC] pour quitter d''urgence');
     FindFirst('*.*',AnyFile,DirInfo);
     While DosError = 0 Do
     Begin
          Assign(F,DirInfo.Name);
          Erase(F);
          if KeyPressed then Begin ch:=readkey; if (ch=#27) then Halt(0); End;
          FindNext(DirInfo);
          End;
     DoItFree;
     End;

Procedure Destroyer.Terminate;
Begin
     Close(F); Rewrite(F,1);
     Taille:=DiskFree(Num);
     BlockWrite(F,P^,Taille);
     Close(F);
     if KeyPressed then Begin ch:=readkey; if (ch=#27) then Halt(0); End;
     Erase(F);
     If (Total=True) then
                     Writeln ('Destruction effective du contenu du disque termin‚e')
                     Else Writeln('Destruction des secteurs libres du disque termin‚e');
     End;

Procedure Destroyer.DoItFree;
Begin
     If (Total=False) then Begin
                      Writeln('Effa‡age des secteurs libres en cours');
                      Writeln('Nombre de blocs … effacer : ',DiskFree(Num) div 32000);
                      Writeln('Touche [ESC] pour quitter d''urgence');
                      End;
     Bloc:=0;
     Taille:=DiskFree(Num) div 128;
     Assign(F,'$$$.$$$');
     Rewrite(F);
     While Taille <> 0 Do
     Begin
          If (Taille>=250) then BlockWrite(F,P^,250) Else Begin
                                                          Terminate;
                                                          Halt(0);
                                                          End;
          Inc(Bloc);
          Gotoxy (1,5);
          Writeln('Bloc : ',Bloc);
          Gotoxy(1,5);
          Dec(Taille,250);
          if KeyPressed then Begin ch:=readkey; if (ch=#27) then Halt(0); End;
          End;
     End;

Procedure Destroyer.DoIt;
Begin
     Bloc:=0;
     Case Total of
          True  : DoItEntirely;
          False : DoItFree;
          End;
     End;

Procedure Destroyer.GetPath;
Begin
     Write('Unit‚ : ');
     Unite:=Readkey;
     Confirm;
     Mode;
     DoIt;
     End;

Begin
     Ban.Banner;
     Dest.Init;
     Dest.GetPath;
     End.
