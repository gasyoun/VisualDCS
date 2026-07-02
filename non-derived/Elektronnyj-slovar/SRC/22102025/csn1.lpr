program csn1;
uses sysutils;
type
  csn = record
         n : byte;
         A : byte;
         V : byte;
         I : byte;
         D : byte;
         Ab : byte;
         G : byte;
         L : byte;
         S : byte;
         Du : byte;
         p : byte;
  end;
var
  A : array[1..621445] of csn;
  X : csn;
  i,j,k : longint;
  f : text;
  f1 : file of csn;
  s,lx,st,vf1,vf2,cng,c,n,g,p1,p2 : string;
  f2 : text;
begin
  assign (f,'10.!');
  assign (f1,'csn.dig');
  reset(f);
  rewrite(f1);
  X.A:=0;  x.Ab:=0;
  x.D:=0;  x.Du:=0;
  x.G:=0;   x.I:=0;
  x.n:=0;   x.L:=0;
  x.p:=0;   x.S:=0;
  x.V:=0;

  for i := 1 to length(A) do
  A[i] := x;

  while not(eof(f)) do
begin
  readln(f,s);
  lx := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  st := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  p1 := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  p2 := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  vf1 := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  vf2 := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  cng := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  c := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  n := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  g := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));
  if strtoint(st) < length(a) then
  if (vf1 = '0') and (vf2='0') then
  begin

  case strtoint(c) of
  1 : inc(a[strtoint(st)].n);
  2 : inc(a[strtoint(st)].a);
  3 : inc(a[strtoint(st)].v);
  4 : inc(a[strtoint(st)].i);
  5 : inc(a[strtoint(st)].d);
  6 : inc(a[strtoint(st)].ab);
  7 : inc(a[strtoint(st)].g);
  8 : inc(a[strtoint(st)].l);
  end;


  case strtoint(n) of
  1 : inc(a[strtoint(st)].s);
  2 : inc(a[strtoint(st)].du);
  3 : inc(a[strtoint(st)].p);
  end;


end;
close(f1);
   assign(f2,'cases.txt');
   rewrite(f2);
   for i := 1 to length(a) do
   begin
     inc(x.n,a[i].n);
     inc(x.a,a[i].a);
     inc(x.v,a[i].v);
     inc(x.i,a[i].i);
     inc(x.d,a[i].d);
     inc(x.ab,a[i].ab);
     inc(x.g,a[i].g);
     inc(x.l,a[i].l);
     inc(x.s,a[i].s);
     inc(x.du,a[i].du);
     inc(x.p,a[i].p);
   end;
   writeln(f2, inttostr(x.n) +' ' +
             inttostr(x.a) +' ' +
             inttostr(x.v) +' ' +
             inttostr(x.i) +' ' +
             inttostr(x.d) +' ' +
             inttostr(x.ab) +' ' +
             inttostr(x.g) +' ' +
             inttostr(x.l) +' ' +
             inttostr(x.s) +' ' +
             inttostr(x.du) +' ' +
         inttostr(x.p) );
   close(f2);

end;





end.

