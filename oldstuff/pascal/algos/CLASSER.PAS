           (**************************)
           (*programme classer 3nbrs *)
           (*   ACHAACH FAOUZI       *)

program classer;

var A,B,C:integer;

BEGIN
clrscr;
write('entrer la valeur A: ');    readln(A);
write('entrer la valeur B: ');    readln(B);
write('entrer la valeur C: ');    readln(C);
clrscr;

if (A>B) and (A>C) then
               if B>C  then
                             write('le classement est:', A,'>',B,'>',C )
               else
                             write('le classement est:' ,A,'>',C,'>',B )
 else
               if B>A  then
                             if A>C  then

                              write('le classement est:' ,B,'>',A,'>',C )
                             else

                              write('le classement est:' ,B,'>',C,'>',A )
               else

               if (C>A)   then

                            if A>B  then
                            write('le classement est :' ,C,'>',A,'>',B)

                           else
                            write('le classement est :' ,C,'>',B,'>',A);

END.