unit dts;


interface
type
  tms = Array[1..42] of word;
  cs3 = record
         sg,du,pl,C : tms
        end;

  cs1 = array[1..8] of integer;

  cs2 = array[1..3] of integer;

  csn = record
         n : integer;
         A : integer;
         V : integer;
         I : integer;
         D : integer;
         Ab : integer;
         G : integer;
         L : integer;
         S : integer;
         Du : integer;
         p : integer;
         sgc : cs1;
         duc : cs1;
         plc : cs1;
         nc  : cs2;
         axc : cs2;
         vc  : cs2;
         ic  : cs2;
         dtc : cs2;
         abc : cs2;
         gc  : cs2;
         lc  : cs2;

  end;
  cs4 = record
         vfx : cs3;
         vfx1: array[1..42] of integer;
         pr1: integer;
         pr2: integer;
         pr3: integer;
         nus: integer;
         nud: integer;
         nup: integer;
  end;

  wd = record
          Nn : csn;
          Prn: csn;
          Adj:  csn;
          VF :  cs4;
          vfi: integer;
          ind : integer;
          vff : integer;
          nx,a1x,px : integer;
          wc,vp : integer;
          maxC  : integer;
          cmc   : integer;
          Axara : integer;
          lipi1 : Array[1..50] of integer;
//          ax2   : Array[1..25{00}] of integer;
          slb   : integer;
  end;
  CPX = record
          cid : integer;
          tid : integer;
          name: string[32];
          nrv : dword;
          ps : integer;
          d1  : integer;
          d2  : integer;
          dm  : integer;
        end;
  TxX = record
          tid : dword;
          tname : string[64];
        end;



var
  CP : Array[1..10764] of cpX;
  AX2: Array[1..2500] of string;
  lipi : array[1..50] of string[10];
  TX : Array[1..409] of TxX;
  LX1 : Array[1..621445] of integer;
  A : array[1..621445] of wd;
//  LEX : array[1..222344] of wd;
  o   : array[1..222344] of string;
  TC : array of wd;
  X : wd;
  XL: Array of Wd;
  DC: Array of Wd;
  f : text;
  f1,f5 : file of wd;

  s,lx,st,vf1,vf2,cng,c,n,g,p1,p2 : string;
  f2 : text;
  f15 : array[0..494876] of string;
  F12 : Array[0..56233] of string;
  f7 : text;
  f3,f4,f6 : text;
  s1,s2,s3 : string;
  fl,fc,ft : text;
  xh : csn;
  xhv: cs4;
  procedure SetX;
  procedure GetS;
  function GetG(z : integer) : string;
  procedure filln;
  procedure filladj;
  procedure fillpron;
  procedure fillv;
  procedure prepareX;
  Function GetAX(s : string; xx : integer) : integer;
  Function GetTense(s : string)  : string;
  var
  EF : text;
implementation
uses
   SysUtils,ans;





function GetG(z : integer) : string;
var a1 : string;
begin
    if z <=length(o) then
    a1 := o[z]
    else a1 := '';

    if a1 <> '' then
    begin
     delete(a1,1,pos(',',a1));
     delete(a1,1,pos(',',a1));
     a1 := copy(a1,1,pos(',',a1)-1);
     case a1 of
          'adj' :  GetG := a1;
          'ind' :  GetG := a1;
          'pron' :  GetG := a1;
          'nr'   :  GetG := 'n';
       else
         begin
              if (pos('P',a1) > 0) or (pos('Ā',a1) > 0)  then GetG := 'v'
              else GetG :='n';
         end;

     end;




    end
    else
    getG := '';
end;

procedure SetX;
type
   wx = record
           l : integer;
           p1: integer;
           p2: integer;
   end;

var ff : text; ww : wx;
    wc : integer;
    vp : integer;
    p2,p1,cmc : integer;
    sd : string;
    i,j,k : integer;
begin
  wc := 0;vp := 0;
  assign(f3,'15.1');
  assign(ff,'_7.txt');
  assign(f4,'12.1');
  assign(f6,'!!8.txt');
  reset(f3);
  reset(f6);
  reset(f4);
  for i := 0 to length(f15) -1 do readln(f3,f15[i]);
  for i := 0 to length(f12) -1 do readln(f4,f12[i]);
  for i := 1 to length(o) do
  readln(f6,o[i]);

  assign (f,'10.!');
  assign (f1,'csn.dig');
  reset(f);
  rewrite(f1);

  assign(ft,'1.txt');
  assign(fc,'2.txt');
  assign(fl,'!7.txt');
  reset(fl);
  for i := 1 to 621445 do
  begin
    readln(fl,s);
    if pos('VALUES',s) > 0 then
    Delete(s,1,pos('VALUES',s)+7);
    delete(s,1,pos(',',s));
    s := copy(s,1,pos(',',s) - 1);
    lx1[i] := strtoint(s);
  end;
reset(ft);
 for i := 1 to length(TX) do
 begin
   readln(ft,s);
   if s <> '' then
   begin
     tx[i].tid:=strtoint( copy(s,1,pos(',',s) - 1));
     delete(s,1,pos(',',s));
     tx[i].tname:=copy(s,1,pos(',',s) - 1);
   end;
 end;

 reset(fc);
 for i := 1 to length(cp) do
 begin
   readln(fc,s);
   if s <> '' then
   begin
   cp[i].cid:=strtoint(copy(s,1,pos(',',s)-1));
   delete(s,1,pos(',',s));

   cp[i].tid:=strtoint(copy(s,1,pos(',',s)-1));
   delete(s,1,pos(',',s));;

   delete(s,1,1);
   cp[i].name:= (copy(s,1,pos('"',s)-1));
   delete(s,1,pos('"',s)+1);

   cp[i].nrv:=strtoint(copy(s,1,pos(',',s)-1));
   delete(s,1,pos(',',s));;

   cp[i].ps:= strtoint(copy(s,1,pos(',',s)-1));
   delete(s,1,pos(',',s));
   cp[i].d1:=strtoint(copy(s,1,pos(',',s)-1));
   delete(s,1,pos(',',s));;

   cp[i].d2 :=strtoint(copy(s,1,pos(',',s)-1));
      delete(s,1,pos(',',s));
   cp[i].dm:=round((cp[i].d2+cp[i].d1)/2);

   end;
 end;

close(ft);
close(fl);
close(fc);
prepareX;
    for i := 1 to length(a) do a[i] := x;
    reset(ff);
    for i := 1 to length(a) do
    begin
       wc := 0;  p1 := 0;p2:=0;cmc :=0; sd :='';
       readln(ff,s);
       if s <> '' then
       while s <> '' do
       begin
         ww.l:= strtoint(copy(s,1,pos(',',s) - 1));
         delete(s,1,pos(',',s));

         ww.p1 := strtoint(copy(s,1,pos(',',s) - 1));
         delete(s,1,pos(',',s)) ;

         ww.p2 := strtoint(copy(s,1,pos(',',s) - 1));
         delete(s,1,pos(',',s));

         inc(wc);
         if getg(ww.l) = 'v' then vp := wc;
         if ww.p2 = 2 then inc(cmc);
         if ww.p1 <= wc then
         if p2 < ww.p2 then p2 := ww.p2;
         sd := sd + inttostr(ww.p1) + ' ';

       end;
       a[i].maxC:=p2;
       a[i].cmc:=cmc;
       a[i].vp := vp;
       a[i].wc := wc;
       wc := 0;
    end;
    assign(ft,'lt.txt');
    reset(ft);
    for i := 1 to length(lipi) do
    readln(ft,lipi[i]);
    close(ft);
    k := 0;
    for i := 1 to 50 do
    for j := 1 to 50 do
    begin
      inc(k);
      ax2[k] := lipi[i]+lipi[j];
    end;


    assign(fl,'7.txt');
    reset(fl);
    for i := 1 to length(a) do
    begin
      readln(fl,s);
      a[i].Axara:=getax(s,i);
    end;
    setSQ;
end;
procedure GetS;
begin
  if s <> '' then
  begin
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
  cng := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));



  c := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  n := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));

  g := copy(s,1,pos(',',s) - 1);
  delete(s,1,pos(',',s));
 End;
end;
procedure filln;
var cc : integer;
begin
    cc := strtoint(st);
    case strtoint(c) of
    1 : inc(a[cc].Nn.n);
    2 : inc(a[cc].Nn.v);
    3 : inc(a[cc].Nn.a);
    4 : inc(a[cc].Nn.i);
    5 : inc(a[cc].Nn.d);
    6 : inc(a[cc].Nn.ab);
    7 : inc(a[cc].Nn.g);
    8 : inc(a[cc].nn.l);
    else writeln(EF,c,lx,#9,c,#9,n,#9,g,#9,'N');
  end;

    case strtoint(n) of
    1 : inc(a[cc].Nn.s);
    2 : inc(a[cc].Nn.du);
    3 : inc(a[cc].Nn.p);
    else writeln(EF,c,lx,#9,c,#9,n,#9,g,#9,'N');
    end;
    case  strtoint(n) of
     1 :  inc(a[cc].Nn.sgc[strtoint(c)]);
     2 :  inc(a[cc].Nn.duc[strtoint(c)]);
     3 :  inc(a[cc].Nn.plc[strtoint(c)]);
     else writeln(EF,c,lx,#9,c,#9,n,#9,g,#9,'N');
    end;

end;
procedure filladj;
var cc : integer;
begin
  cc := strtoint(st);
      case strtoint(c) of
      1 : inc(a[cc].Adj.n);
      2 : inc(a[cc].Adj.v);
      3 : inc(a[cc].Adj.a);
      4 : inc(a[cc].Adj.i);
      5 : inc(a[cc].Adj.d);
      6 : inc(a[cc].Adj.ab);
      7 : inc(a[cc].Adj.g);
      8 : inc(a[cc].Adj.l);
      else writeln(EF,c,lx,#9,c,#9,n,#9,g,#9,'adj');
    end;
      case strtoint(n) of
      1 : inc(a[cc].Adj.s);
      2 : inc(a[cc].Adj.du);
      3 : inc(a[cc].Adj.p);
      else writeln(EF,c,lx,#9,c,#9,n,#9,g,#9,'adj');
    end;
      case  strtoint(n) of
       1 :  inc(a[cc].adj.sgc[strtoint(c)]);
       2 :  inc(a[cc].adj.duc[strtoint(c)]);
       3 :  inc(a[cc].adj.plc[strtoint(c)]);
       else writeln(EF,c,lx,#9,c,#9,n,#9,g,#9,'adj');
      end;

  end;
procedure fillpron;
var cc : integer;
begin
  cc := strtoint(st);
      case strtoint(c) of
      1 : inc(a[cc].Prn.n);
      2 : inc(a[cc].Prn.v);
      3 : inc(a[cc].Prn.a);
      4 : inc(a[cc].Prn.i);
      5 : inc(a[cc].Prn.d);
      6 : inc(a[cc].Prn.ab);
      7 : inc(a[cc].Prn.g);
      8 : inc(a[cc].Prn.l);
      else writeln(EF,c,lx,#9,c,#9,n,#9,g,#9,'pron');
    end;
      case strtoint(n) of
      1 : inc(a[cc].Prn.s);
      2 : inc(a[cc].Prn.du);
      3 : inc(a[cc].Prn.p);
      else writeln(EF,c,lx,#9,c,#9,n,#9,g,#9,'prn');
    end;
      case  strtoint(n) of
       1 :  inc(a[cc].prn.sgc[strtoint(c)]);
       2 :  inc(a[cc].prn.duc[strtoint(c)]);
       3 :  inc(a[cc].prn.plc[strtoint(c)]);
       else writeln(EF,c,lx,#9,c,#9,n,#9,g,#9,'pron');
      end;

  end;
procedure fillv;
var cc : integer;
begin
  cc := strtoint(st);
  if vf1 <> '0' then
  begin
   inc(a[cc].vff);
   s1 := f15[strtoint(vf1)];
   delete(s1,1,pos(',',s1));
   delete(s1,1,pos(',',s1));
   delete(s1,1,pos(',',s1));
   s2 := copy(s1,1,pos(',',s1)-1);
   delete(s1,1,pos(',',s1));
   delete(s1,pos(',',s1),1);
   delete(s1,pos(';',s1),1);
  if (s2 <> '') and (s2 <> '0') then
  begin
  inc(a[cc].VF.vfx.C[strtoint(s2)]);
{
  if strtoint(s1) in [1,2,3] then
    inc(a[cc].VF.vfx.sg[strtoint(s2)]);

    if strtoint(s1) in [4,5,6] then
    inc(a[cc].vf.vfx.du[strtoint(s2)]);

    if strtoint(s1) in [7,8,9] then
    inc(a[cc].VF.vfx.pl[strtoint(s2)]);
}
  end;
   case s1 of
        '1' : begin
                inc(a[cc].vf.pr1);
                inc(a[cc].vf.nus);
              end;
        '2' : begin
                inc(a[cc].vf.pr2);
                inc(a[cc].vf.nus);
              end;
        '3' : begin
                inc(a[cc].vf.pr3);
                inc(a[cc].vf.nus);
              end;
        '4' : begin
                inc(a[cc].vf.pr1);
                inc(a[cc].vf.nud);

              end;
        '5' : begin
                inc(a[cc].vf.pr2);
                inc(a[cc].vf.nud);
              end;
        '6' : begin
                inc(a[cc].vf.pr3);
                inc(a[cc].vf.nud);

              end;
        '7' : begin
                inc(a[cc].vf.pr1);
                inc(a[cc].vf.nup);

              end;
        '8' : begin
                inc(a[cc].vf.pr2);
                inc(a[cc].vf.nup);

               end;
        '9' : begin
                inc(a[cc].vf.pr1);
                inc(a[cc].vf.nup);

              end;

        end;
   end;


  if vf2 <> '0' then
  begin
       s1 := f12[strtoint(vf2)];
       if s1 <> '' then
       begin
         delete(s1,1,pos(',',s1));
         delete(s1,1,pos(',',s1));
         delete(s1,1,pos(',',s1));
         delete(s1,1,pos(',',s1));
         s2 := copy(s1,1,pos(',',s1) - 1);
         if (s2 <> '') and (s2 <> '0') then
         inc(a[cc].vf.vfx1[strtoint(s2)])

       end;
       inc(a[cc].vfi);
  end;
end;


procedure prepareX;
var  i,j,k : integer;
begin
 x.ind:=0; xh.Ab:=0;  xh.du :=0;
 x.vfi:=0; xh.D:=0;   xh.S:=0;
 x.vff:=0;  xh.I := 0;;xh.p:=0;
 x.Px := 0;xh.G:=0; x.maxC:=0;
 x.nx:=0; xh.L:=0;  x.cmc := 0;
 x.a1x:=0;xh.n:=0;
 xh.A:=0; xh.V:=0;

 for i := 1 to 3 do
 begin
   xh.axc[i] := 0;
   xh.abc[i] := 0;
   xh.nc[i] := 0;
   xh.vc[i] := 0;
   xh.gc[i] := 0;
   xh.lc[i] := 0;
   xh.dtc[i] := 0;
   xh.ic[i] := 0;
 end;
 for  i := 1 to 8 do
 begin
   xh.sgc[i] := 0; xh.duc[i] := 0; xh.plc[i] := 0;
 end;
 x.Nn := xh; x.Adj := xh; x.Prn := xh;

 xhv.nud:=0; xhv.nup:=0;xhv.nus:=0;
 xhv.pr1:=0;xhv.pr2:=0;xhv.pr3:=0;
 for i := 1 to 42 do
 begin
   xhv.vfx1[i] := 0;
   xhv.vfx.du[i] := 0;
   xhv.vfx.sg[i] := 0;
   xhv.vfx.pl[i] := 0;
   xhv.vfx.C[i] := 0;

 end;
 x.VF := xhv;
 x.wc:=0; x.vp := 0;x.cmc:=0;x.maxC:=0;
 x.axara := 0;
// for i := 1 to length(x.ax2) do
// x.ax2[i] := 0;
 for i := 1 to length(x.lipi1) do
 x.lipi1[i] := 0;
 x.slb:=0;
end;
Function GetAX(s : string;xx : integer) : integer;
var i,j,k : integer;
    d : string;
    q : string;
begin
   i := 0;
   d := s;
   q := s;
   if s <> '' then
   begin
     while pos('ai',s) > 0 do begin inc(i); delete(s,pos('ai',s),2);end;
     while pos('au',s) > 0 do begin inc(i); delete(s,pos('au',s),2);end;
     while pos('a',s) > 0 do begin inc(i); delete(s,pos('a',s),1); end;
     while pos('i',s) > 0 do begin inc(i); delete(s,pos('i',s),1); end;
     while pos('u',s) > 0 do begin inc(i); delete(s,pos('u',s),1); end;
     while pos('o',s) > 0 do begin inc(i); delete(s,pos('o',s),1); end;
     while pos('e',s) > 0 do begin inc(i); delete(s,pos('e',s),1); end;

     while pos('ī',s) > 0 do begin inc(i); delete(s,pos('ī',s),length('ī'));end;
     while pos('ū',s) > 0 do begin inc(i); delete(s,pos('ū',s),length('ū'));end;
     while pos('ṛ',s) > 0 do begin inc(i); delete(s,pos('ṛ',s),length('ṛ'));end;
     while pos('ṝ',s) > 0 do begin inc(i); delete(s,pos('ṝ',s),length('ṝ'));end;
     while pos('ḷ',s) > 0 do begin inc(i); delete(s,pos('ḷ',s),length('ḷ'));end;
     while pos('ḹ',s) > 0 do begin inc(i); delete(s,pos('ḹ',s),length('ḹ'));end;
     while pos('ā',s) > 0 do begin inc(i); delete(s,pos('ā',s),length('ā'));end;
   end;
   for j := 1 to length(lipi) do
   while pos(lipi[j],d) > 0 do
   begin
     inc(a[xx].lipi1[j]);
     delete(d,pos(lipi[j],d),length(lipi[j]));
   end;
{
   for k := 1 to length(ax2) do
   begin d := q;
   while pos(ax2[k],q) > 0 do
   begin
     inc(a[xx].ax2[k]);
     delete(q,pos(ax2[k],q),length(ax2[k]));
   end;
   q := d;
   end;
}
   for k := 1 to 50 do
   while pos(lipi[k],q) > 0 do
   begin
      inc(a[xx].slb);
      delete(q,pos(lipi[k],q),length(lipi[k]));
   end;
   GetAx := i;
end;

Function GetTense(s : string)  : string;
begin
   case s of
     '1' : GetTense :='Present Ind.';
     '2':GetTense := 'Pres. Potential';
     '3':GetTense := 'Pres. Imp.';
     '4':GetTense := 'Imperfect ind';
     '5':GetTense := 'Future Ind.';
     '6':GetTense := 'Future Cond.';
     '7':GetTense := 'Future. Ind. Peri.';
     '8':GetTense := 'Aorist Ind. Root.';
     '9':GetTense := 'Aorist Ind. Them.';
     '10':GetTense := 'Aorist Ind. Red.';
     '11':GetTense := 'Aorist Ind. S.';
     '12':GetTense := 'Aorist Ind. Is.';
     '13':GetTense := 'Aorist Ind. Sa.';

     '14':GetTense := 'Aorist Prec.';
     '15':GetTense := 'Perfect Ind.';
     '17':GetTense := '17';
     '16':GetTense := 'Perfect Ind. Peri.';

     '18':GetTense := '18';


     '19':GetTense := 'Past Passive Participle';
     '20':GetTense := 'Past Active Participle';
     '21':GetTense := 'Future passive particle';
     '22':GetTense := 'Infinitive';
     '23':GetTense := 'Absolutive';
     '24':GetTense := 'Present Passive';
     '25':GetTense := 'Pres. Sub.';
     '26':GetTense := 'Pres. Imperative Passive';
     '27':GetTense := 'Imperfect Ind. Passive ';
     '28':GetTense := 'Aorist Ind. Passive';
     '29': GetTense := 'Pres. Opt Passive';
     '30':GetTense := 'Aorist Jus.';
     '31':GetTense := '31';
     '32':GetTense := ' Aorist Jus./Sub./Opt/Perf_Opt';
     '33':GetTense := ' Aorist Imp.';
     '34':GetTense := '34?';

     '35': GetTense := 'Aorist Ind. Sis.';
     '36':GetTense := 'Perfect Sub';
     '37':GetTense := ' Perfect Jus.';


     '38':GetTense := ' Perfect Opt.';
     '39':GetTense := ' Perfect Imp';

     '40':GetTense := ' Present Jus.';
     '42':GetTense := ' Aorist Sub.';
     '41':GetTense := ' Plp. ind.';


   else GetTense := s;

   end;

end;

begin
  assign(EF,'ERRORS.txt');
  rewrite(ef);

end.


