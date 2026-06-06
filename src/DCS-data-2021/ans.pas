unit ans;


interface
uses dts;
type
  tp = record
     id : integer;
     pid: integer;
     topic:string;
  end;
  tp2 = record
        tid, cid : integer;

  end;


var q : array[1..410] of string;
    sq : string;
    Cl: array[1..12114] of string;
    GX : wd;
    GCid: integer;
    i : integer;
    topics : Array[1..647] of tp;
    tpx    : array[1..6363] of tp2;
    txtt   : array[1..410] of string;
    MCMP : integer = 0;
    MMC1 : integer = 0;
    RealN: Array of integer;
    Flg  : integer = 0;
procedure PrepareText(cid : integer);
procedure CreateCp;
procedure AnalTC(id : boolean;z: dword);
Procedure AddGX;
procedure SetSQ;
implementation
uses sysutils;

var f0 : text;
    hn,ha,hp : csn;
    hv       : cs4;
procedure addv(var xx : cs4; xz : cs4);
var i : byte;
begin
  inc(xx.nud,xz.nud); inc(xx.nus,xz.nus); inc(xx.nup,xz.nup);
  inc(xx.pr1,xz.pr1); inc(xx.pr2,xz.pr2); inc(xx.pr3,xz.pr3);

  for i := 1 to 42 do
  inc(xx.vfx1[i],xz.vfx1[i]);

  for i := 1 to 42 do
  begin
    inc(xx.vfx.sg[i], xz.vfx.sg[i]);
    inc(xx.vfx.du[i], xz.vfx.du[i]);
    inc(xx.vfx.pl[i], xz.vfx.pl[i]);
    inc(xx.vfx.C[i], xz.vfx.C[i]);

  end;
end;

procedure AddXh(var xx: csn;xz : csn);
var i : byte;
begin
   inc(xx.A,xz.a); inc(xx.ab,xz.ab);
   inc(xx.v,xz.v); inc(xx.n,xz.n);
   inc(xx.d,xz.d); inc(xx.g,xz.g);
   inc(xx.l,xz.l); inc(xx.i,xz.i);

   inc(xx.du,xz.du); inc(xx.s,xz.s); inc(xx.p,xz.p);

   for i := 1 to 8 do
   begin
     inc(xx.sgc[i],xz.sgc[i]);
     inc(xx.plc[i],xz.plc[i]);
     inc(xx.duc[i],xz.duc[i]);
   end;

end;

Procedure AddGX;
var ss : string;
    i,j,k : integer;
begin
  GX := x;
  MCMP := 0;
  MMC1 := 0;
  for i := 0 to length(tc) - 1 do
  begin
//     for j := 1 to length(gx.ax2) do
//     inc(gx.ax2[j],tc[i].ax2[j]);
     for j := 1 to length(gx.lipi1) do
     inc(gx.lipi1[j],tc[i].lipi1[j]);

     inc(gx.nx,tc[i].nx);
     inc(gx.a1x,tc[i].a1x);
     inc(gx.px,tc[i].px);
     inc(gx.wc,tc[i].wc);
     inc(gx.vp,tc[i].vp);
     inc(gx.ind,tc[i].ind);
     inc(gx.cmc,tc[i].cmc);
     inc(gx.maxc,tc[i].maxc);


     inc(gx.vff, tc[i].vff);
     inc(gx.vfi, tc[i].vfi);
     addxh(gx.Adj,tc[i].Adj);
     addxh(gx.nn,tc[i].nn);
     addxh(gx.Prn,tc[i].prn);
     addv(gx.VF,tc[i].VF);

     if tc[i].maxC > 1 then inc(MMC1);
     inc(gx.Axara,tc[i].Axara);
     inc(gx.slb,tc[i].slb);
     if mcmp < tc[i].maxc then
     begin
        mcmp := tc[i].maxc;
        if length(tc) = length(realn) then
        Flg := RealN[i];
     end;
  end;



end;

procedure PrepareText(cid : integer);
var ss : string;
    i,j,k : integer;
begin
  k := 0;
  PrepareX;
  setlength(TC,0);
  setlength(RealN,0);

  s := cl[cid];
  if s <> '' then
  while s <> '' do
  begin
    ss := copy(s,1,pos(' ',s) - 1);
    delete(s,1,pos(' ',s));
    if ss <> '' then
    begin
       inc(k); setlength(tc,k);
               setlength(RealN,k);
       tc[k-1] := a[strtoint(ss)];
       RealN[k-1] := strtoint(ss);

    end;
  end;
//  Writeln(k);
  for i := 1 to length(cp) do if cid = cp[i].cid then Gcid := i;
end;
procedure createcp;
var   i,j,k : integer;
begin
   for i := 1 to length(q) do q[i] := '';
   for i := 1 to length(Cl) do Cl[i] := '';
//   assign(f0,'cpx.txt');
//   rewrite(f0);
   for i := 1 to length(TX) do
     for j  := 1 to length(cp) do
     if cp[j].tid = tx[i].tid then q[i] := q[i] + inttostr(cp[j].cid) + ' ';
//   for j := 1 to length(q) do writeln(f0,q[j]);
//   close(f0);

// assign(f0,'clx.txt');
//   rewrite(f0);

   for i := 1 to length(lx1) do
   if lx1[i] <= length(cl) then
   cl[lx1[i]] := cl[lx1[i]] + inttostr(i) + ' ';

//   for j := 1 to length(cl) do writeln(f0,cl[j]);
//   close(f0);

end;
procedure AnalTC(id : boolean;z : dword);
var ss : string;
    i,j,k : integer;
    dd,ds    : integer;
begin

    AddGX;

if length(Tc) > 0 then
begin
   if id then
    Write(f7,cp[gcid].name,':',inttostr(cp[gcid].ps),':',cp[gcid].d1,':',cp[gcid].d2,':',cp[gcid].dm)
   else
     begin
        Write(f7,Tx[z].tname,':',cp[gcid].d1,':',cp[gcid].d2,':',cp[gcid].dm);
{
        for dd := 1 to length(tpx) do
        if tpx[dd].cid = gcid then
        for ds := 1 to length(topics) do
        if topics[ds].id = tpx[dd].tid then
        txtt[z] := txtt[z] + '; '+
        topics[ds].topic;
}
     end;
    write(f7,':',gx.wc);

    if gx.wc > 0 then
    write(f7,':',gx.nx, ':',gx.nx/gx.wc*100:2:2,'%')
    else
      write(f7,':',gx.nx, ':',gx.nx,'%');

    if gx.wc > 0 then
    write(f7,':',gx.a1x, ':',gx.a1x/gx.wc*100:2:2,'%')
    else
      write(f7,':',gx.a1x, ':',gx.a1x,'%');

    if gx.wc > 0 then
    write(f7,':',gx.ind, ':',gx.ind/gx.wc*100:2:2,'%')
    else
      write(f7,':',gx.ind, ':',gx.ind,'%');
    if gx.wc > 0 then
    write(f7,':',gx.px, ':',gx.px/gx.wc*100:2:2,'%')
    else
      write(f7,':',gx.px, ':',gx.px,'%');
    if gx.wc > 0 then
    write(f7,':',gx.vfi+gx.vff, ':',(gx.vff+gx.vfi)/gx.wc*100:2:2,'%')
    else
      write(f7,':',gx.vfi+gx.vff, ':',(gx.vff+gx.vfi),'%');

    write(f7,':',gx.wc/length(tc):5:2);
    write(f7,':',gx.vp/length(tc):5:2);
    if gx.vff > 0 then
    write(f7,':',gx.vff, ':',gx.vff/(gx.vfi+gx.vff)*100:2:2,'%')
    else
      write(f7,':',gx.vff, ':','0%');

    if gx.vfi > 0 then
    write(f7,':',gx.vfi, ':',gx.vfi/(gx.vfi+gx.vff)*100:2:2,'%')
    else
     write(f7,':',gx.vfi, ':','0%');

    if gx.Nn.S+gx.Adj.S > 0 then
    write(f7,':',gx.Nn.S+gx.Adj.S,':',
    (gx.Nn.S+gx.Adj.S)/(gx.Nn.S+gx.Adj.S+ gx.Nn.du+gx.Adj.du+gx.Nn.p+gx.Adj.p)*100:2:2,'%')
    else
      write(f7,':',gx.Nn.S+gx.Adj.S,':','0%');

    if gx.Nn.du+gx.Adj.du > 0 then
    write(f7,':',gx.Nn.du+gx.Adj.du,':',
    (gx.Nn.du+gx.Adj.du)/(gx.Nn.S+gx.Adj.S+ gx.Nn.du+gx.Adj.du+gx.Nn.p+gx.Adj.p)*100:2:2,'%')
    else
      write(f7,':',gx.Nn.du+gx.Adj.du,':0%');
    if gx.Nn.p+gx.Adj.p > 0 then
    write(f7,':',gx.Nn.p+gx.Adj.p,':',
    (gx.Nn.p+gx.Adj.p)/(gx.Nn.S+gx.Adj.S+ gx.Nn.du+gx.Adj.du+gx.Nn.p+gx.Adj.p)*100:2:2,'%')
    else
    write(f7,':',gx.Nn.p+gx.Adj.p,':0%');

    if gx.Prn.S > 0 then
    Write(f7,':',gx.Prn.S,':',
    gx.Prn.S/(gx.Prn.s+gx.Prn.du+gx.Prn.p)*100:2:2,'%')
    else
      Write(f7,':',gx.Prn.S,':','0%');

    if gx.Prn.du > 0 then
    Write(f7,':',gx.Prn.du,':',
    gx.Prn.du/(gx.Prn.s+gx.Prn.du+gx.Prn.p)*100:2:2,'%')
    else
      Write(f7,':',gx.Prn.du,':','0%');

    if gx.Prn.p > 0 then
    Write(f7,':',gx.Prn.p,':',
    gx.Prn.p/(gx.Prn.s+gx.Prn.du+gx.Prn.p)*100:2:2,'%')
    else
      Write(f7,':',gx.Prn.p,':','0%');

    k:= gx.Nn.S+gx.adj.S+ gx.prn.S +
        gx.Nn.du+gx.adj.du+ gx.prn.du +
        gx.Nn.p+gx.adj.p+ gx.prn.p;
    Write(f7,':',gx.Nn.S+gx.adj.S+ gx.prn.S);
    if k > 0 then
    write(f7,':',(gx.Nn.S+gx.adj.S+ gx.prn.S)/k*100)
    else write(f7,':0');

    Write(f7,':',gx.Nn.du+gx.adj.du+ gx.prn.du);
    if k > 0 then
    write(f7,':',(gx.Nn.du+gx.adj.du+ gx.prn.du)/k*100)
    else write(f7,':0%');

    Write(f7,':',gx.Nn.p+gx.adj.p+ gx.prn.p);
    if k > 0 then
    write(f7,':',(gx.Nn.p+gx.adj.p+ gx.prn.p)/k*100)
    else write(f7,':0%');

    for i := 1 to 8 do
          write(f7,':',gx.nn.sgc[i]+gx.adj.sgc[i]+gx.prn.sgc[i]);

    for i := 1 to 8 do
    write(f7,':',gx.nn.duc[i]+gx.adj.duc[i]+gx.prn.duc[i]);
    for i := 1 to 8 do
      write(f7,':',gx.nn.plc[i]+gx.adj.plc[i]+gx.prn.plc[i]);


    write(f7,':',gx.cmc);
    write(f7,':',gx.cmc/length(TC):2:2);
    if mmc1 > 0 then
    Write(f7,':',gx.maxC/MMC1:2:2)
    else
      Write(f7,':',gx.maxC);
    write(f7,':', gx.Axara);
    write(f7,':',gx.Axara/length(tc):4:2);
    if gx.wc > 0 then
    Write(f7,':',gx.Axara/gx.wc:2:2)
    else
      Write(f7,':',gx.Axara);


    for i := 1 to 42 do
    write(f7,':',gx.VF.vfx.C[i]);
    {gx.VF.vfx.sg[i] + gx.VF.vfx.du[i] +gx.VF.vfx.pl[i]);}

    for i := 1 to 42 do
        write(f7,':',gx.VF.vfx1[i]);




    if gx.VF.nus <> 0 then
    Write(f7,':',gx.VF.nus,':',
    gx.VF.nus/(gx.VF.nus+gx.VF.nud+gx.VF.nup)*100:3:2,'%')
    else
     Write(f7,':',gx.VF.nus,':','0%');



    if gx.VF.nud > 0 then
    Write(f7,':',gx.VF.nud,':',
    gx.VF.nud/(gx.VF.nus+gx.VF.nud+gx.VF.nup)*100:3:2,'%')
    else
     Write(f7,':',gx.VF.nud,':','0%');

    if gx.VF.nup > 0 then
    Write(f7,':',gx.VF.nup,':',
    gx.VF.nup/(gx.VF.nus+gx.VF.nud+gx.VF.nup)*100:3:2,'%')
    else
     Write(f7,':',gx.VF.nup,':','0%');
    if  gx.VF.pr1 > 0 then
    write(f7,':',gx.Vf.pr1,':',
    gx.VF.pr1/(gx.VF.pr1+gx.VF.pr2+gx.VF.pr3)*100:3:2,'%')
    else
      write(f7,':',gx.Vf.pr1,':','0%');

    if gx.VF.pr2 > 0 then
    write(f7,':',gx.Vf.pr2,':',
    gx.VF.pr2/(gx.VF.pr1+gx.VF.pr2+gx.VF.pr3)*100:3:2,'%')
    else
       write(f7,':',gx.Vf.pr2,':','0%');

    if gx.VF.pr3 > 0 then
    write(f7,':',gx.Vf.pr3,':',
    gx.VF.pr3/(gx.VF.pr1+gx.VF.pr2+gx.VF.pr3)*100:3:2,'%:')
    else
      write(f7,':',gx.Vf.pr3,':','0%:');

    if length(TC) = length(RealN) then
    write(f7,mCmp,':',gx.slb,':')
    else
      write(f7,mCmp,':',gx.slb,':');
    for i := 1 to length(gx.lipi1) do
    if gx.slb > 0 then
    write(f7,gx.lipi1[i]/gx.slb*100:2:4,':')
    else
       write(f7,'0:');
{
    for i := 1 to length(ax2) do
    write(f7,gx.ax2[i],':');}
    write(f7,'jj');



end;


end;
procedure SetSQ;
begin
  sq :=
     'Chapter:Pos:Date1:Date2:Middle Date:'+
     'Total Stems:'+
     'Total nouns:%Total nouns:'+
     'Total Adjectives:%Total Adjectives:'+
     'Total ind.:%Total indicatives:'+
     'Total pronouns:%Total pronouns:'+
     'Total Verbal forms:%Total Verbal forms:'+
     'Middle stanza length:'+
     'Middle Verbal Position:'+
     'Total Verbal forms finite:%Total Verbal forms fnfinite:'+
     'Total Verbal forms infinite:%Total Verbal forms infinite:'+
     'Total Names Sg.:%Total Names Sg:'+
     'Total Names Du.:%Total Names Du.:'+
     'Total Names pl.:%Total Names pl.:'+
     'Total pronouns Sg.:%Total pronouns Sg.:'+
     'Total pronouns Du.:%Total pronouns Du.:'+
     'Total pronouns Pl.:%Total pronouns Pl.:'+
     'Total Names and Prn. Sg.:%Total Names and Prn. Sg.:'+
     'Total Names and Prn. Du.:%Total Names and Prn. Du.:'+
     'Total Names and Prn. Pl.:%Total Names and Prn. Pl.:'+
     'SG. Nom.:SG. Voc.:SG. Acc.:SG. Ins:SG. Dat:SG. Abl:SG. Gen:SG. Loc:'+
     'DU. Nom.:DU. Voc.:DU. Acc.:DU. Ins:DU. Dat:DU. Abl:DU. Gen:DU. Loc:'+
     'PL. Nom.:PL. Voc.:PL. Acc.:PL. Ins:PL. Dat:PL. Abl:PL. Gen:PL. Loc:'+
     'Total Composits:'+
     'Middle Composits count in stanza:'+
     'Middle MAX length of Composit:'+
     'Total sylables in the chapter:'+
     'Middle sylables in stanza:'+
    'Middle sylables in stem:';
     for i := 1 to 42 do
     sq := sq + 'FF. '+gettense(inttostr(i))+':';

     for i := 1 to 42 do
     sq := sq +  'IF.'+ gettense(inttostr(i)) + ':';

    sq := sq +
     'Finite Forms in Sg.:%Finite Forms in Sg.:'+
     'Finite Forms in Du.:%Finite Forms in Du.:'+
     'Finite Forms in Pl.:%Finite Forms in Pl.:'+
     'Total finite forms person 1:%Total finite forms person 1:'+
     'Total finite forms person 2:%Total finite forms person 2:'+
     'Total finite forms person 3:%Total finite forms person 3:MAX Composite Length:Total Letters:';
     for i := 1 to 50 do
     sq := sq + lipi[i]+'%:';
{     for i := 1 to 2500 do
     sq := sq + ax2[i]+'%:';
}
     assign(f7,'topics.txt');
     reset(f7);

     for i := 1 to 647 do
     begin
       readln(f7,s);
       if s <> '' then
       begin
       delete(s,1,1);
       topics[i].id:=strtoint(copy(s,1,pos(',',s)-1));
       delete(s,1,pos(',',s));
       topics[i].pid:=strtoint(copy(s,1,pos(',',s)-1));
       delete(s,1,pos(',',s));
       topics[i].topic:=s;
       end;
     end;
     close(f7);

     assign(f7,'4xx.txt');
     reset(f7);

     for i := 1 to 6363 do
     begin

       readln(f7,s);
       if s <> '' then
       begin
       delete(s,1,1);
       tpx[i].tid:=strtoint(copy(s,1,pos(',',s)-1));
       delete(s,1,pos(',',s));
       tpx[i].cid:=strtoint(s);

       end;
     end;
     close(f7);
end;
end.

