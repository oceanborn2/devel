Program Profiler;

Uses Crt,Dos;

Var SauveHeure : DateTime;
    Command    : String;

Procedure Options;
Begin
     End;
Begin
     If ParamCount = 1 Then
     Begin
          Command:=ParamStr(1);
          If   (Command[1] = '-')
            or (Command[1] = '/') Then Options  {c'est une option}
                                  Else AssignFile; {c'est un fichier}
                                                   {… profiler}
          End;

     If ParamCount<1 Then
     Begin
          Writeln ('Profiler de programmes ‚x‚cutables');
          Writeln ('Pascal Munerot - 24/08/1992');
          Writeln ('veuillez pr‚ciser le nom du programme … chronom‚trer');
          Halt(1);
          End;
     End.
