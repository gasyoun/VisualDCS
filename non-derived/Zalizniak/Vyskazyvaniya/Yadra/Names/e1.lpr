program e1;
uses sysutils;
var f,f1 : text;
  i,j,k : dword;
  x : real;
  s,s1,s2 : string;
begin
 assign(f,'1');reset(f);assign(f1,'__1');rewrite(f1);
 readln(f,s);
 while s <> '' do
 begin
   Delete(s,1,pos(#9,s));
   s1 := copy(s,1,pos(#9,s)-1);
   Delete(s,1,pos(#9,s));
   Delete(s,1,pos('=',s));
   s2 := copy(s,1,pos('%',s)-1);
   Delete(s,1,pos(#9,s));
   if pos('.',s2) > 0 then
   begin   insert(',',s2,pos('.',s2));delete(s2,pos('.',s2),1); end;
   if s1 <> '' then
   writeln(f1,s1,#9,s2);
   s1 := '';s2 := '';
   if pos(#9,s) = 0 then s := '';
 end;
 close(f);close(f1);
end.

