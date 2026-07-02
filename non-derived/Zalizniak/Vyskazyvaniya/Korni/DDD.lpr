program DDD;
var f,f1,f2 : text;
    A : array[1..55034] of string;
    i,j : dword; s,s1 : string;
begin assign(f,'d1.txt');
      assign(f1,'rt.txt');
      assign(f2,'nopref.txt');
      reset(f);
      reset(f1);
      rewrite(f2);
      for i := 1 to length(a) do readln(f,a[i]);
      while not(eof(f1)) do
      begin
        readln(f1,s);
        s1 := '';
        for i := 1 to length(a) do
        if pos(s+#9,a[i]) = 1 then
        begin
          delete(a[i],1,pos(#9,a[i])); s1 := s1 + a[i] + #32;
        end;
        if s1 <> '' then writeln(f2,s,#9,s1);
      end;
      close(f2);


end.

