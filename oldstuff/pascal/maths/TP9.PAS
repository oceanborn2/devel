program MultiEgyptienne;

   (***********************************************************)
   (*Multiplication de 2 nombres en n'utilisant que l'addition*)
   (*et la  division.                                         *)
   (*Par mlle MERRIEN Sarah                          groupe G1*)
   (***********************************************************)

var bo:boolean;
    a,b,c,m:integer;

procedure Paire (a:integer;var bo:boolean);
begin
     if a mod 2 =0 then
                       bo:=true
     else
                       bo:=false;
end;

procedure Addition (a:integer;var b:integer);
begin
     b:=a+b;
end;

procedure Division (var b:integer);
begin
     b:=b div 2;
end;

procedure Echange (var a,b:integer);
begin
     if a<b then
               begin
                m:=a;
                a:=b;
                b:=a;
               end;
end;

begin   (*d‚but du prog principal*)
     c:=0;
     writeln('Entrer 2 nombres s‚par‚s d''un espace');
     readln(a,b);
     if a<b then Echange(a,b);
     while b<>1 do
                  begin
                    Paire(b,bo);
                    if not bo then
                                  begin
                                    b:=b-1;
                                    c:=c+a;
                                  end
                    else
                                  begin
                                    Division(b);
                                    m:=a;
                                    Addition(m,a);
                                  end;
                  end;
writeln('Le produit de vos 2 nombres est: ',a+c);
end.

