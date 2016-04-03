Program Config_Files_Exchanger;

Uses Crt,Dos;

Type
    GfsTools = Object
               Option:String;
               Fich:String;
               F:Text;
               G:Text;
               DirInfo:SearchRec;
               Procedure Interp;
               Procedure Menu;
               Procedure UpString;
               Procedure DelAuto;
               Procedure DelConfig;
               Procedure InstallAuto;
               Procedure InstallConfig;
               End;

Var
    Gfs : GfsTools;
      I : Integer;
  Ligne :String;

Procedure GfsTools.Menu;
Begin
     Clrscr;
     Writeln ('GFS - Gestionnaire de fichiers systŠmes');
     Writeln ('Copyright (c) 1991. Pascal Munerot');
     Writeln;
     Writeln ('Syntaxe g‚n‚rale : ');
     Writeln ('GFS <Option> [<Nom de fichier>]');
     Writeln;
     Writeln ('La liste des options est la suivante (en majuscules) : ');
     Writeln;
     Writeln ('DC: D‚truire un fichier de configuration');
     Writeln ('IC: Installer le fichier de configuration');
     Writeln ('DA: D‚truire un fichier auto‚x‚cutable');
     Writeln ('IA: Installer le fichier auto‚x‚cutable');
     Writeln;
     Writeln('Si vous trouvez ce logiciel utile et que vous avez d‚cid‚ de ');
     Writeln('le conserver, veuillez envoyer 50 FF en chŠque … l''adresse suivante : ');
     Writeln('Pascal Munerot');
     Writeln('76690 Fontaine-Le-Bourg');
     Writeln('FRANCE');
     Writeln;
     Writeln('Ainsi, vous recevrez une licence et un droit pour la prochaine version');
     Writeln('qui vous sera exp‚di‚e gratuitement d‚s sa disponibilit‚');
     End;

Procedure GfsTools.UpString;
Begin
     For I:=1 To Length(Option) do
     Begin
          Option[I]:=Upcase(Option[I]);
          End;
     End;

Procedure GfsTools.Interp;
Begin
     If (ParamCount=0) then Gfs.Menu;
     Option:=ParamStr(1);
     UpString;
     If (Pos(Option,'DA')>0) then DelAuto;
     If (Pos(Option,'DC')>0) then DelConfig;
     If (ParamCount<2) then Halt(1);
     Fich:=ParamStr(2);
     If (Pos(Option,'IA')>0) then InstallAuto;
     If (Pos(Option,'IC')>0) then InstallConfig;
     End;

Procedure GfsTools.DelAuto;
Begin
     FindFirst('AUTOEXEC.BAT',0,DirInfo);
     If DosError <> 0 Then Halt(0);
     Assign (F,'AUTOEXEC.BAT');
     Erase(F);
     End;

Procedure GfsTools.DelConfig;
Begin
     FindFirst('CONFIG.SYS',0,DirInfo);
     If DosError <> 0 Then Halt(0);
     Assign (F,'CONFIG.SYS');
     Erase(F);
     End;

Procedure GfsTools.InstallAuto;
Begin
     Assign(F,'AUTOEXEC.BAT');
     Assign(G,Fich);
     Rewrite(F);
     Reset(G);
     While Not Eof(G) do
     Begin
          Readln(G,Ligne);
          Writeln(F,Ligne);
          End;
     Close(G);
     Close(F);
     End;

Procedure GfsTools.InstallConfig;
Begin
     Assign(F,'CONFIG.SYS');
     Assign(G,Fich);
     Rewrite(F);
     Reset(G);
     While Not Eof(G) do
     Begin
          Readln(G,Ligne);
          Writeln(F,Ligne);
          End;
     Close(G);
     Close(F);
     End;

Begin
     Gfs.Interp;
     End.
