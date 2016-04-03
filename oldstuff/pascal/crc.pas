Program Calc_Crc;

Uses Crt,Dos;

Type   BufferPtr = ^Buffer;                {pointeur sur le buffer fichier}
       Buffer = array [1..65000] of char;

Var Buf     : BufferPtr;  {instanciation du buffer}
    F       : File;       {variable fichier}
    Fname   : String;     {nom du fichier}
    Lus     : Word;       {blockread : nombre d'octets lus = taille buffer}
    CRC1,
    CRC2,
    OLD1,
    OLD2,
    Fait,
    I       : Longint;

{message d'invite}
Procedure Banner;
Begin
     Clrscr;
     Writeln ('Calcul de CRC sur fichiers');
     Writeln ('Pascal Munerot');
     Writeln;
     End;

{abandon d'urgence du programme , lib‚ration du buffer fichier}
Procedure Abandon;
Begin
     Writeln ('Abandon du programme en cours ...');
     Dispose(Buf);
     Halt(1);
     End;

{lit le nom du fichier dont on doit calculer le CRC}
Procedure GetParams;
Begin
     If ParamCount<1 Then
     Begin
          Writeln ('vous avez omis le nom du fichier');
          Halt(1);
          End;
     Fname:=ParamStr(1);
     Writeln ('Fichier : < ',Fname,' >');
     Assign(F,Fname);
     {$i-}
     Reset(F,1);
     Writeln ('Taille  : < ',FileSize(F),' >');
     If IoResult<> 0 Then
     Begin
          Writeln ('erreur pendant l''ouverture du fichier ',fname);
          Writeln ('code d''erreur : ',DosError);
          Halt(1);
          End;
     End;

Function ToHex8 (X : LongInt) : String;
Const Thex :String = '0123456789ABCDEF';
Var   Fort,
      Faible : Byte;
Begin
     Fort:=X div 16;
     Faible:=X mod 16;
     ToHex8:=THex[ Fort +1 ]+THex [ Faible +1 ];
     End;

Function ToHex16 (X : LongInt) : String;
Var   Fort,
      Faible : Byte;
Begin
     Fort:=X div 256;
     Faible:=X mod 256;
     ToHex16:=ToHex8(Fort)+ToHex8(Faible);
     End;

Function ToHex32 (X : LongInt) : String;
Var   Fort,
      Faible : Word;
Begin
     Fort:=X div 65536;
     Faible:=X mod 65536;
     ToHex32:=ToHex16(Fort)+ToHex16(Faible);
     End;

{PROGRAMME PRINCIPAL}

Begin
     Assign(Input,''); Reset(Input);
     Assign(OutPut,''); Rewrite(OutPut);
     Banner;
     GetParams;
     New(Buf);
     CRC1:=0; CRC2:=0; OLD1:=0; OLD2:=0;
     Fait:=0;
     While Not Eof(F) Do
     Begin
          BlockRead(F,Buf^,65000,Lus);
          For I:=1 To Lus Do Inc(CRC1,Ord(Buf^[i]));
          I:=1;
          Repeat
               Inc(CRC2,Ord(Buf^[i]) or Ord(Buf^[i+1]));
               Inc(I);
          Until I>=Lus;
          OLD1:=OLD1 xor CRC1;
          OLD2:=OLD2 xor CRC2;
          End;
     Writeln ('CRC1    : ',ToHex32(OLD1));
     Writeln ('CRC2    : ',ToHex32(OLD2));
     Writeln ('CRC     : ',ToHex32(OLD1 or OLD2));
     Dispose(Buf);
     Close(F);
     End.