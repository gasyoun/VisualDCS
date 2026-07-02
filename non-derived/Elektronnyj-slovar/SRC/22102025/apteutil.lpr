program apteutil;
uses sysutils;
var F,f1 : system.TEXt;
    s,s2 : string;
    a,i : longint;

begin
   i := 0;
   a := 0;
   system.Assign(F,'apteh.txt');
   system.Assign(F1,'index.apt');
   s2 := '';s := '';
   system.Reset(F);
   system.Rewrite(F1);
   while not(eof(f)) do
   begin
     readln(F,s);
     if s[1] <> s2 then
     begin
       inc(a);
       writeln(f1,inttostr(a));
     end;
     s2 := s[1];

   end;
   system.Close(f1);
   system.Close(f);

end.

