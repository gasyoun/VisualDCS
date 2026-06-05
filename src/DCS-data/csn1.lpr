program csn1;
uses sysutils, dts, ans;
var xa,xv : string;
    ik,w : dword;
    f8 : text;
    tn : string = '';
    i,j : dword;
begin

  SetX;

  while not(eof(f)) do
begin
  readln(f,s);

  GetS;
  if s <> '' then
  if strtoint(st) < length(a) then
  case getG(strtoint(lx)) of
       'n': begin
              filln;
              inc(a[strtoint(st)].nx);
       end;
       'adj':begin
              filladj;
             inc(a[strtoint(st)].a1x);
       end;
       'pron':begin
              fillpron;
              inc(a[strtoint(st)].px);
       end;
       'v' : fillv;
       'ind' : inc(a[strtoint(st)].ind);
       else
         inc(a[strtoint(st)].ind);
   end;
end;
 createcp;
 SetSQ;

 for ik := 1 to length(q) do
 if (q[ik] <> '') and (q[ik] <> ' ') then
 begin
   tn := tn + inttostr(ik) + ' ' + tx[ik].tname + #13+#10;

   Assign(f7,'TXT\'+inttostr(ik)+'.txt');
   Rewrite(f7);
   writeln(f7,sq);
   xa := q[ik];
   while xa <> '' do
   begin
    xv := copy(xa,1,pos(' ',xa) - 1);
    delete(xa,1,pos(' ',xa));
    if xv <> '' then
    begin
       preparetext(strtoint(xv));

       AnalTC(true,0);
       writeln(f7,'');
       Setlength(Xl,length(Xl)+length(TC));


       for w := 1 to length(tc)  do
       xl[length(xl)-length(tc)+w - 1] := Tc[w - 1];
    end;
    if xa = ' ' then xa := '';
   end;

   close(f7);
   Assign(f7,'texts.csv');
   append(f7);

   TC := Xl;
   AnalTC(false,ik);
   writeln(f7,'');

Setlength(DC,length(DC)+length(Xl));
for w := 1 to length(Xl)  do
DC[length(DC)-length(Xl)+w - 1] := Xl[w - 1];
Setlength(Xl,0);


   close(f7);

 end;
//Assign(f7,'All.txt');
//rewrite(f7);
//tc := DC;
//AnalTC(false,ik);
//close(f7);
//for i := 1 to length(a) do write(f1,a[i]);
close(f1);
  assign(f7,'Files.txt');
  rewrite(f7);
  write(f7,tn);
  close(f7);

  assign(f7,'texttop.txt');
  rewrite(f7);
  for i := 1 to length(q) do
  writeln(f7,tx[i].tname+';'+txtt[i]+';');
  close(f7);





close(EF);
end.


