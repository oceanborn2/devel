Program Queens_Problem;
Uses Crt;
Const   MaxDVar = 16;
        MaxCStr = 256;
Type    TypeTag = (free,ground);
        Dvar    = Record
                  tag : typeTag;
                  Val : Integer;
                  min : Integer;
                  max : Integer;
                  bool : array [1..MaxDVar] of Boolean;
                  occur : integer;
                  cstr1 : array [1..MaxCStr] of Integer;
                  active : integer;
                  cstr2 : array [1..MaxDVar] of Integer;
                  End;
        Array_Of_Dvar = Array [1..MaxDVar] of Dvar;
        TypeCStr = (CStr_Dif0,CStr_DifC);
        Cstr = Record
               V1 : Integer;
               V2 : Integer;
               Cst : Integer;
               Val : Integer;
               Proc : TypeCStr;
               End;
        Array_Of_CStr = Array [1..MaxCStr] Of CStr;
Var     Further : Boolean;
        N       : Integer;
        Queens  : Array_Of_Dvar;
        NCstr   : Integer;
        Nb_Sol  : Integer;
        Constraint : Array_Of_CStr;
        Current_CStr : Integer;

Procedure Define_Var(N:Integer);
Var I,J : Integer;
Begin
     For I:=1 To N Do
      With Queens[I] Do
       Begin
        tag:=free;
        min:=1;
        max:=N;
        For J:=min to max Do
        Bool[J]:=True;
        occur:=0;
        active:=0;
       End;
     End;

Procedure Remove(Value,I : Integer);
Begin
 With Queens[I] Do
 If (Min<=Value) And (Value<=Max)
   Then
    If Bool[Value]
          Then
           Begin
             Bool[Value]:=False;
             inc(active);
             Cstr2[active]:=Current_CStr;
             Constraint[Current_CStr].Val:=Value;
             End;
   End;

Procedure Dif0(I1,I2:Integer);
Begin
  If (Queens[I1].Tag=Free) And (Queens[I2].Tag=Free)
    Then
     Begin
       Inc(NCstr);
       Constraint[NCstr].V1:=I1;
       Constraint[NCStr].V2:=I2;
       Constraint[NCstr].Proc:=CStr_Dif0;
       Inc(Queens[I1].Occur);
       Inc(Queens[I2].Occur);
       Queens[I1].CStr1[Queens[I1].Occur]:=NCstr;
       Queens[I2].CStr1[Queens[I2].Occur]:=NCstr;
       End
     Else
       If Queens[I2].Tag = Free
        Then Remove(Queens[I1].Val,I2)
        Else
         If Queens[I1].Tag=Free
          Then Remove(Queens[I2].Val,I1)
          Else
          If Queens[I1].Val=Queens[I2].Val
           Then Further:=False;
    End;

Procedure DifC(I1,I2,C:Integer);
Begin
 If (Queens[I1].Tag=Free) And (Queens[I2].Tag=Free)
  Then
   Begin
    Inc(NCStr);
    Constraint[NCstr].V1:=I1;
    Constraint[NCStr].V2:=I2;
    Constraint[NCStr].Cst:=C;
    Constraint[NCstr].Proc:=CStr_DifC;
    Inc(Queens[I1].Occur);
    Inc(Queens[I2].Occur);
    Queens[I1].CStr1[Queens[I1].Occur]:=NCstr;
    Queens[I2].CStr1[Queens[I2].Occur]:=NCstr;
    End
     Else
      If Queens[I2].Tag=Free
       Then Remove(Queens[I1].Val-C,I2)
       Else
        If Queens[I1].Tag=Free
          Then Remove(Queens[I2].Val+C,I1)
          Else
           If Queens[I1].Val=Queens[I2].Val+C
           Then Further:=False;
     End;

Procedure Set_Constraint(N:Integer);
Var I,J : Integer;
Begin
  For I:=1 To N Do
   For J:=I+1 To N Do
    Begin
     Dif0(I,J);
     DifC(I,J,J-I);
     DifC(I,J,I-J);
     End;
   End;

Procedure Wake_Up_Constraint(N:Integer);
Begin
     Current_CStr:=N;
     With Constraint[N] Do
      Case Proc Of
        CStr_Dif0 : Dif0(V1,V2);
        CStr_DifC : DifC(V1,V2,Cst);
        End;
   End;

Procedure Wake_Up_Constraints(Q:Integer);
Var I : Integer;
Begin
     For I:=1 To Queens[Q].Occur Do
     Wake_Up_Constraint(Queens[Q].CStr1[I]);
     End;

Procedure Update_Domain(CStr1,Q,V : Integer);
Var I,J : Integer;
Begin
     For I:=1 To Queens[Q].Active Do
      If Queens[Q].CStr2[I]=Cstr1
        Then
        With Queens[Q] Do
         Begin
          Dec(Active);
          For J:=I To Active Do
           CStr2[J]:=CStr2[J+1];
          Bool[V]:=True;
          Exit;
         End;
      End;

Procedure Update_Domains(Q:Integer);
Var I : Integer;
 Begin
  With Queens[Q] Do
   For I:=1 To Occur Do
    If Constraint[CStr1[I]].V2<>Q
     Then Update_Domain(CStr1[I],Constraint[CStr1[I]].V2,Constraint[
     Cstr1[I]].Val);
     End;

Procedure Assigne (Q:Integer);
Var I : Integer;
Begin
     With Queens[Q] Do
      Begin
       If Tag = Free
        Then I:=Min
        Else
         Begin
           Tag:=Free;
           I:=Val+1;
           Update_Domains(Q);
           End;
     While (Tag=Free) And (I<=Max) Do
      If Bool[I]
       Then
        Begin
         Tag:=Ground;
         Val:=I;
         Wake_Up_Constraints(Q);
         End
        Else Inc(I);
      Further:=(I<=Max);
      End;
     End;

Procedure Display_Sol(N:Integer);
Var I : Integer;
Begin
     Write('Solution ',Nb_Sol,': ');
     For I:=1 To N Do
       With Queens[I] Do
        Write(Val,' ');
        Writeln;
        End;

Procedure Generate_Value(N:Integer);
Var I : Integer;
Begin
 I:=1;
 While (I>0) Do
 Begin
   Assigne(I);
   If Further
    Then
     If I=N
      Then
       Begin
        Inc(Nb_Sol);
        Display_Sol(N);
        End
      Else Inc(I)
    Else
     Begin
      Dec(I);
      Further:=True;
      End;
    End;
End;

Procedure Solve_Pbm(N:Integer);
 Begin
  Define_Var(N);
  Set_Constraint(N);
  Generate_Value(N);
 End;

Begin
 Clrscr;
 Writeln('Problämes des 8 reines'); Writeln;
 NCstr:=0;
 Nb_Sol:=0;
 Write('Taille de l''Çchiquier : ');
 Readln(N);
 Solve_Pbm(N);
 Writeln ('Nombre de solutions : ',Nb_Sol,'. Taper RETURN');
 Readln;
 End.
