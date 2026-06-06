program pref;
uses sysutils;
var f,f1,f2 : text;
    lx : array[1..222342] of string;
    i,j : longint;
    s : string;
    lp,lc,vd,px : string;

begin
  assign(f,'!!8.csv');
  assign(f1,'9.txt');
  assign(f2,'!9.csv');
  reset(f);
  reset(f1);
  rewrite(f2);
  for i := 1 to length(lx) do readln(f,lx[i]);

  while not(eof(f1)) do
  begin
    readln(f1,s);
    lp := copy(s,1,pos(',',s)-1);
    delete(s,1,pos(',',s));

    lc := copy(s,1,pos(',',s)-1);
    delete(s,1,pos(',',s));

    vd := copy(s,1,pos(',',s)-1);
    delete(s,1,pos(',',s));

    px := s;

    lp := lx[strtoint(lp)];
    lc := lx[strtoint(lc)];

    delete(lp,1,pos(',',lp));
    lp := copy(lp,1,pos(',',lp)-1);
    delete(lc,1,pos(',',lc));
    lc := copy(lc,1,pos(',',lc)-1);

    s := lp+';'+lc+';'+vd+';'+px+';';
    writeln(f2,s);


  end;

    close(f2);
    close(f1);
    close(f);




end.

