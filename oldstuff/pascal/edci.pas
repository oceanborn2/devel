Program EDCI; {Enhanced Dos Command Interpreter}

Uses Crt,Dos,WinExt;

Const

     MMenu : Array [1..2] of Integer=(1,1);

     MaxFM = 5;
     MaxSM = 7;

     MFM : Integer=1;
     MSM : Integer=1;

     FM : Array [1..MaxFM] of String[10] = ('File','Calendar','Calculator','Notebook','Dos');
     SM : Array [1..MaxSM] of String[10] = ('Dir','Type','Copy','Delete','Execute','Media','Screen');

Type

    Banner = Object
             Procedure Banner;
             End;

    FileOb = Object
             Procedure DirectoryFile;
             Procedure TypeFile;
             Procedure CopyFile;
             Procedure DeleteFile;
             Procedure Execute;
             Procedure Media;
             Procedure Screen;
             End;

    Menu =   Object
             Procedure Main_Right;
             Procedure Main_Left;
             Procedure Main_Specials;
             Procedure Main_Interp;
             Procedure Main_ChoiceMade;

             Procedure File_Right;
             Procedure File_Left;
             Procedure File_Specials;
             Procedure File_Interp;
             Procedure File_ChoiceMade;
             Procedure File_Desk;

             Procedure Init;
             Procedure Calendar_Desk;
             Procedure Calculator_Desk;
             Procedure NoteBook_Desk;
             End;

    Init =   Object
             Procedure Init;
             End;

Var
    MenuPtr   : ^Menu;
    BannerPtr : ^Banner;
    FilePtr   : ^FileOb;
    Runner    : Init;

            I : Integer;
           CH : Char;

    DirInfo   : SearchRec;

Procedure Banner.Banner;
Begin
     Clrscr;
     Writeln ('Enhanced Dos Command Interpreter');
     Writeln ('(C) 1991. Pascal Munerot');
     Writeln;
     Writeln ('This program is a resident program which is able to');
     Writeln ('give you access to a lot of commands under a program');
     Writeln ('which is already running. It''s the main goal of this ');
     Writeln ('software');
     Writeln;
     Writeln ('It uses a menu to allow you enter the commands');
     Writeln;
     Writeln ('Its first possibilities are to manipulate files more easily');
     Writeln ('than the standard DOS interpreter');
     End;

Procedure Menu.File_Left;
Begin
     TextColor(Black); TextBackground(White);
     Gotoxy ((MSM-1)*10+2,1); Write(SM[MSM]);
     TextColor(Red); Gotoxy ((MSM-1)*10+2,1);
     Write(SM[MSM,1]);
     Dec(MSM);
     If (MSM<1) Then MSM:=MaxSM;
     TextColor(White); TextBackground(Blue);
     Gotoxy ((MSM-1)*10+2,1); Write(SM[MSM]);
     End;

Procedure Menu.File_Right;
Begin
     TextColor(Black); TextBackground(White);
     Gotoxy ((MSM-1)*10+2,1); Write(SM[MSM]);
     TextColor(Red); Gotoxy ((MSM-1)*10+2,1);
     Write(SM[MSM,1]);
     Inc(MSM);
     If (MSM>MaxSM) Then MSM:=1;
     TextColor(White); TextBackground(Blue);
     Gotoxy ((MSM-1)*10+2,1); Write(SM[MSM]);
     End;

Procedure Menu.File_Specials;
Begin
     Ch:=Readkey;
     Case Ch of
          #77 : File_Right;
          #75 : File_Left;
          End;
     End;

Procedure Menu.File_Interp;
Begin
     Ch:=Upcase(Readkey);
     Case CH of
          #0  : File_Specials;
          #13 : File_ChoiceMade;
          #27 : Begin CloseWindow; Exit; End;
          End;
     File_Interp;
     End;

Procedure FileOb.DirectoryFile;
Begin
     End;

Procedure FileOb.TypeFile;
Begin
     End;

Procedure FileOb.CopyFile;
Begin
     End;

Procedure FileOb.DeleteFile;
Begin
     End;

Procedure FileOb.Execute;
Begin
     End;

Procedure FileOb.Media;
Begin
     End;

Procedure FileOb.Screen;
Begin
     End;

Procedure Menu.File_ChoiceMade;
Begin
     Case MSM of
          1 : FilePtr^.DirectoryFile;
          2 : FilePtr^.TypeFile;
          3 : FilePtr^.CopyFile;
          4 : FilePtr^.DeleteFile;
          5 : FilePtr^.Execute;
          6 : FilePtr^.Media;
          7 : FilePtr^.Screen;
      End;
     End;

Procedure Menu.File_Desk;            {M1}
Begin
     OpenWindow(1,4,80,6,' File Section ',2,2);
     TextColor(Black);
     TextBackground(White); Clrscr;
     For I:=1 To MaxSM Do Begin Gotoxy ((I-1)*10+2,1); Write(SM[i]); End;
     TextColor(Red);
     For I:=1 To MaxSM Do Begin Gotoxy ((I-1)*10+2,1); Write(SM[i,1]); End;
     TextBackground(Blue); TextColor(White);
     Gotoxy((MSM-1)*10+2,1); Write(SM[MSM]);
     TextBackground(Black); TextColor(White);
     File_Interp;
     Ch:=Readkey;
     End;

Procedure Menu.Calendar_Desk;         {M2}
Begin
     OpenWindow(1,4,80,24,' Calendar Section ',2,2);
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Menu.Calculator_Desk;       {M3}
Begin
     OpenWindow(1,4,80,24,' Calculator Section ',2,2);
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Menu.NoteBook_Desk;         {M4}
Begin
     OpenWindow(1,4,80,24,' NoteBook Section ',2,2);
     Ch:=Readkey;
     CloseWindow;
     End;

Procedure Menu.Main_ChoiceMade;
Begin
     Case MFM of
          1 : File_Desk;
          2 : Calendar_Desk;
          3 : Calculator_Desk;
          4 : NoteBook_Desk;
      MaxFM : Begin CloseWindow; Dispose(MenuPtr); Halt(0); End;
      End;
     End;

Procedure Menu.Main_Left;
Begin
     TextColor(Black); TextBackground(White);
     Gotoxy ((MFM-1)*15+2,1); Write(FM[MFM]);
     TextColor(Red); Gotoxy ((MFM-1)*15+2,1);
     Write(FM[MFM,1]);
     Dec(MFM);
     If (MFM<1) Then MFM:=MaxFM;
     TextColor(White); TextBackground(Blue);
     Gotoxy ((MFM-1)*15+2,1); Write(FM[MFM]);
     End;

Procedure Menu.Main_Right;
Begin
     TextColor(Black); TextBackground(White);
     Gotoxy ((MFM-1)*15+2,1); Write(FM[MFM]);
     TextColor(Red); Gotoxy ((MFM-1)*15+2,1);
     Write(FM[MFM,1]);
     Inc(MFM);
     If (MFM>MaxFM) Then MFM:=1;
     TextColor(White); TextBackground(Blue);
     Gotoxy ((MFM-1)*15+2,1); Write(FM[MFM]);
     End;

Procedure Menu.Main_Specials;
Begin
     Ch:=Readkey;
     Case Ch of
          #77 : Main_Right;
          #75 : Main_Left;
          End;
     End;

Procedure Menu.Main_Interp;
Begin
     Ch:=Upcase(Readkey);
     Case CH of
          #0  : Main_Specials;
          #13 : Main_ChoiceMade;
          #27 : Begin CloseWindow; Exit; End;
          End;
     Main_Interp;
     End;

Procedure Menu.Init;
Begin
     TextBackground(Black); TextColor(White);
     TopWindow:=Nil;
     OpenWindow(1,1,80,3,' E D C I - (C) 1991. Pascal Munerot ',2,2);
     TextColor(Black);
     TextBackground(White); Clrscr;
     For I:=1 To MaxFM Do Begin Gotoxy ((I-1)*15+2,1); Write(FM[i]); End;
     TextColor(Red);
     For I:=1 To MaxFM Do Begin Gotoxy ((I-1)*15+2,1); Write(FM[i,1]); End;
     TextBackground(Blue); TextColor(White);
     Gotoxy((MFM-1)*10+2,1); Write(FM[MFM]);
     TextBackground(Black); TextColor(White);
     Main_Interp;
     End;

Procedure Init.Init;
Begin
     TextColor(White);
     TextBackground(Black);
     New(MenuPtr);
     MenuPtr^.Init;
     Dispose(MenuPtr);
     End;


Begin
     Runner.Init;
     End.
