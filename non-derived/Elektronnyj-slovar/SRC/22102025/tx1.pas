unit tx1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, ComCtrls, Menus, Buttons, HtmlView;

type

  { TDCS1 }

  TDCS1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    GB1: TGroupBox;
    hw1: THtmlViewer;
    Label6: TLabel;
    Label7: TLabel;
    Groupbox1: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    listbox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox5: TListBox;
    ListBox6: TListBox;
    ListBox7: TListBox;
    ListBox8: TListBox;
    ListBox9: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    PopupMenu1: TPopupMenu;
    ProgressBar1: TProgressBar;
    RadioGroup1: TRadioGroup;
    SaveDialog1: TSaveDialog;
    SBClear: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpX: TSpeedButton;
    SpeedButton8: TSpeedButton;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);

    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure listbox1CloseUp(Sender: TObject);
    procedure ListBox7Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure Panel11Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SBClearClick(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton10MouseEnter(Sender: TObject);
    procedure SpeedButton10MouseLeave(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton11MouseEnter(Sender: TObject);
    procedure SpeedButton11MouseLeave(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton12MouseEnter(Sender: TObject);
    procedure SpeedButton12MouseLeave(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton13MouseEnter(Sender: TObject);
    procedure SpeedButton13MouseLeave(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton14MouseEnter(Sender: TObject);
    procedure SpeedButton14MouseLeave(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseEnter(Sender: TObject);
    procedure SpeedButton1MouseLeave(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton2MouseEnter(Sender: TObject);
    procedure SpeedButton2MouseLeave(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton3MouseEnter(Sender: TObject);
    procedure SpeedButton3MouseLeave(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton4MouseEnter(Sender: TObject);
    procedure SpeedButton4MouseLeave(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton5MouseEnter(Sender: TObject);
    procedure SpeedButton5MouseLeave(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton6MouseEnter(Sender: TObject);
    procedure SpeedButton6MouseLeave(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpXClick(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1ColRowMoved(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1HeaderSizing(Sender: TObject; const IsColumn: boolean;
      const aIndex, aSize: Integer);
    procedure StringGrid1Resize(Sender: TObject);
  private

  public
    procedure fillcp;
    procedure fillslk;
    function getosn(s : string) : string;
    function GetGV(i,j,k : longint) : longint;
    procedure GetV1(i,j,k : longint);
    procedure ChkLine(i : longint;g : boolean);
    function GetCM(s : string) : word;
    function cmpas(a,s : string) : word;
    function PSl(s : string; i : longint) : string;
    function GetGr(i : string) : string;
    function FindS(s : string; i,j : word) : string;
    procedure initGRA;
    procedure FillSTA;
    function GetVerType(id : string; var cl : byte;var tp,vc : string) : string;
    procedure sgnt;
  end;
type tpos = record
      tid : word;
      cid : word;
      sid : longint;
      end;
  strec = record
        osn : string;
        p1  : string;
        p2  : string;

  end;
  strec1 = array of strec;

  Txrec = record
        id : string;
        tn : string;
        a  : string;
        dt : string;
  end;
  cprec = record
        id : string;
        tid: string;
        cn : string;
        nrv: string;
        ps : string;
        d1 : string;
        d2 : string;
  end;
  lrec = record
        id : string;
        cid: string;
        ln : string;
        st : string;
        pd : string;
  end;
type //ddk = array[1..621445,1..84] of byte;
     GR = record
           m : longint;
           mn : longint;
           mnf : longint;
           mf : longint;
           f : longint;
           fn : longint;
           pr : longint;
           adj : longint;
           n : longint;
           v : longint;
           ds : longint;
           dn : longint;
           ind : longint;
           dj1: longint;
           dj2: longint;
           nr : longint;
         end;
     TAdp = record
           filename : string;
           tname    : string;
     end;
TPosx = record
       cp : word;
       ln : word;
       vrs: word;
       stm: boolean;
      end;
      tps = array[1..516] of tposx;
      orec = record
             stem : string[64];
             gr   : string[16];
             DcId : dword;
      end;

var
  Ofile : file of Orec;
  txPos : tps;
  fps  : file of tps;
  adaT : array[1..246] of Tadp;
  GRA : GR;
  GVerse : longint = 0;
  CVerse : longint = 0;
  c3 : boolean = true;
  c1 : boolean = true;
  DCS1: TDCS1;
  TX : array[1..516] of txrec;
  CP : array[1..12766] of cprec;
  cp1: Array of cprec;
  lx1: Array of lrec;
  gtid : string = '';
  gcid : string = '';
  lx : Array[1..621445] of lrec;
  snt : array[1..621445] of strec1;
  O : Array[1..222342] of orec;
  OD: Array[1..222342] of string;
//  Axa : ddk;
  Textid1 : word = 1;
implementation
uses poisk,tcf,wrf,shellapi,dcon,tema1,fdic, lpak,sfo,
  depo1,tcompare,unt,STANS,rusk,parals,repo1,ssv,params,clipbrd;
var cc3 : boolean = true;
    ch : boolean = false;
{$R *.lfm}

{ TDCS1 }

procedure TDCS1.FormCreate(Sender: TObject);
var f,f1,f2,f3,f6 : system.text;
     s,s1,s2,s3,s4 : string;
     i,j,k,a : longint;
     stg : strec;
     fc : system.Text;
//     ff : file of ddk;
    c8 : word;
begin
  gb1.BorderWidth:=0;

  cc3 := false;
  assignfile(fps,'sys\4.0\txpos.dig');
  if fileexists('sys\4.0\txpos.dig') then
  begin
    reset(fps);
    read(fps,txpos);
    closefile(fps);
  end
  else
  begin
    for i := 1 to length(txpos) do
    begin
      txpos[i].cp:=0;
      txpos[i].ln := 0;
      txpos[i].stm:=false;
      txpos[i].vrs:=0;
    end;

  end;
  assignfile(f,'sys\TANS\files.txt');reset(f);
  for i := 1 to length(adat) do
  begin
    readln(f,s);
    adat[i].filename:='sys\TANS\'+copy(s,1,pos(' ',s)-1)+'.csf';
    delete(s,1,pos(' ',s));
    adat[i].tname:=s;
  end;
  closefile(f);
 stringgrid3.RowCount:=412;
 stringgrid3.ColCount:=17;
 Stringgrid3.LoadFromCSVFile('sys\T\1.csv',',',true);
listbox4.Items.LoadFromFile('sys\t\WR.!');
listbox5.Items.LoadFromFile('sys\t\10.!');
listbox7.Items.LoadFromFile('sys\t\12.1');
listbox6.Items.LoadFromFile('sys\t\15.1');
listbox8.Items.LoadFromFile('sys\t\8.1');
//system.Assign(ff,'sys\T\621445.dig');
//reset(ff);
//read(ff,axa);
//system.Close(ff);
   system.assign(ofile,'sys\4.0\stdic.dig');
     system.assign(f3,'sys\t\_7.txt');
     reset(f3);
     system.assign(f2,'sys\t\!7.txt');
     reset(f2);
     system.assign(f,'sys\t\1.txt');
     reset(f);

     system.assign(f1,'sys\t\2.txt');
     reset(f1);
     k := 1;
     Reset(Ofile);
     for i := 1 to length(o) do read(ofile,o[i]);
     closefile(ofile);
     for i := 1 to length(snt) do
     begin
        k := 1;
        readln(f3,s);
        if s <> '' then
//        for c8 := 1 to length(s) do if s[c8] = ',' then inc(k);
//        k := (k div 3);
//      Setlength(snt[i],k);
        k := 1;
        while s <> '' do
        begin
          stg.osn:=copy(s,1,pos(',',s) - 1);
          delete(s,1,pos(',',s));

          stg.p1:=copy(s,1,pos(',',s) - 1);
          delete(s,1,pos(',',s));

          stg.p2:=copy(s,1,pos(',',s) - 1);
          delete(s,1,pos(',',s));
                    setlength(snt[i],k);
          snt[i,k-1] := stg;
          inc(k);
          if s = ',' then s := '';;

          if s = '' then
          if k > 2 then
          begin
            dec(k);
{
            for a := 0 to k - 1 do
             for j := 0 to k - 2 do
             if strtoint(snt[i,j].osn) >  strtoint(snt[i,j+1].osn) then
             begin
                stg := snt[i,j]; snt[i,j] := snt[i,j+1]; snt[i,j+1] := stg;
             end;
}
          end;

        end;

     end;
     for i := 1 to length(lx) do
     begin
        readln(f2,s);
        if pos('VALUES',s) > 0 then
        delete(s,1,pos('VALUES',s)+6);
        lx[i].id := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));

        lx[i].cid := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s)+1);

        lx[i].ln := copy(s,1,pos('",',s)-1);
        delete(s,1,pos(',',s));

        lx[i].st := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));
        lx[i].pd := s;

     end;
     for i := 1 to length(cp) do
     begin
        readln(f1,s);

        if s  <> '' then
        if pos('VALUES',s) > 0 then
        delete(s,1,pos('VALUES',s) +5)
        else
        begin
        a := strtoint(copy(s,1,pos(',',s)-1));
        if a > length(cp) then showmessage(inttostr(a));
        cp[a].id := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));

        cp[a].tid := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));

        cp[a].cn := copy(s,2,pos('",',s)-2);
        delete(s,1,pos('",',s)+1);

        cp[a].nrv := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));

        cp[a].ps := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));

        cp[a].d1 := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));

        cp[a].d2 := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));
        end;
     end;
{
     for i := 1 to length(cp) do
     if cp[i].cn <> '' then
     writeln(fc,cp[i].cn+'_'+cp[i].ps);
     system.Close(fc);
}
     for i := 1 to length(TX) do
     begin
        Readln(f,s);
        if s <> '' then
        begin
        a := strtoint(copy(s,1,pos(',',s) - 1));
        tx[a].id:=copy(s,1,pos(',',s) - 1);
        delete(s,1,pos(',',s));

        tx[a].tn:=copy(s,1,pos(',',s) - 1);
        delete(s,1,pos(',',s));
        if copy(s,1,pos(',',s) - 1) <> 'NULL' then
        begin
          tx[a].a:=copy(s,2,pos('",',s) - 2);
          delete(s,1,pos('",',s));
//          combobox3.Items.Add(tx[i].a);
        end
        else tx[a].a:='';
//        listbox10.Items.Add(tx[a].tn);
       end;
     end;
     for i := 0 to combobox1.Items.Count - 1 do
     if pos('"',combobox1.Items[i]) <> 1 then
     combobox1.Items[i] := '"'+
     combobox1.Items[i] + '"';
     combobox1.ItemIndex:=0;
     Combobox1change(sender);

//       showmessage('DCS DATA loaded'+#13+#10+ 'Click "OK"');
     if combobox3.Items.Count > 0 then combobox3.ItemIndex:=0;
     if fileexists('sys\4.0\fvrtexts.txt') then
     combobox3.Items.LoadFromFile('sys\4.0\fvrtexts.txt');

     if combobox3.Items.Count > 0 then
        combobox3.ItemIndex:=0;

      cc3 := true;
      combobox1change(sender);

end;

procedure TDCS1.FormResize(Sender: TObject);
begin
  memo2.Height:= panel2.Height div 2 - 50;
end;

procedure TDCS1.FormShow(Sender: TObject);
begin
  form1.BitBtn4.Show;
  form1.BitBtn4.Caption:=caption;

end;

procedure TDCS1.FormWindowStateChange(Sender: TObject);
var s : string;
begin
  if windowState = wsminimized then
  begin
    form1.BitBtn4.Show;
    form1.BitBtn4.Caption:=caption;
  end;
end;

procedure TDCS1.Image1Click(Sender: TObject);
begin
  if listbox1.ItemIndex > 0 then
  begin
    listbox1.itemindex := listbox1.itemindex - 1;
    listbox1click(sender);
  if checkbox4.Checked then speedbutton3click(sender);;
  if CheckBox2.checked then
  begin
     txpos[combobox1.ItemIndex + 1].stm:=checkbox1.Checked;
     txpos[combobox1.ItemIndex + 1].vrs:=radiogroup1.ItemIndex;
     txpos[combobox1.ItemIndex + 1].cp:=combobox2.ItemIndex;
     txpos[combobox1.ItemIndex + 1].ln:=listbox1.ItemIndex;
  end;

  end;
end;

procedure TDCS1.Image2Click(Sender: TObject);
begin
  if listbox1.ItemIndex < listbox1.Items.Count - 1 then
  begin
    listbox1.itemindex := listbox1.itemindex + 1;
    listbox1click(sender);
  if checkbox4.Checked then speedbutton3click(sender);;
  if CheckBox2.checked then
  begin
     txpos[combobox1.ItemIndex + 1].stm:=checkbox1.Checked;
     txpos[combobox1.ItemIndex + 1].vrs:=radiogroup1.ItemIndex;
     txpos[combobox1.ItemIndex + 1].cp:=combobox2.ItemIndex;
     txpos[combobox1.ItemIndex + 1].ln:=listbox1.ItemIndex;
  end;

  end;

end;

procedure TDCS1.Label8Click(Sender: TObject);
begin
  memo1.Lines.LoadFromFile('Readme.txt');
end;

procedure TDCS1.ListBox1Click(Sender: TObject);
var s : string;
    i : longint;
    q,w : string;
begin
  ch := true;
  memo1.Clear;
  memo2.Clear;

  if listbox1.items.Count > 0 then
  begin
  if checkbox1.Checked then
  begin
    q := '';
    if radiogroup1.ItemIndex = 1 then
    s :=
    tts.StringGrid4.Cells[3,getGV(combobox1.ItemIndex,combobox2.ItemIndex,listbox1.ItemIndex)]
    else
    begin
       s := '';
       if length(snt[strtoint(lx1[listbox1.ItemIndex].id)])  > 0 then
       for i  := 0 to length(snt[strtoint(lx1[listbox1.ItemIndex].id)]) - 1 do
       s := s + snt[strtoint(lx1[listbox1.ItemIndex].id),i].osn + ',';
    end;


    if s <> '' then
    while s <> '' do
    begin
       w := copy(s,1,pos(',',s) - 1);
       delete(s,1,pos(',',s));
       w := getosn(w);
       q := q + w + ' ';
    end;
  end;
   if radiogroup1.ItemIndex = 0 then
   begin
      memo1.Lines.Add(lx1[listbox1.ItemIndex].ln);
      if checkbox1.Checked then
      memo2.Lines.Add(q);
      memo1.SelStart:=0;
      memo2.SelStart:=0;
   end
   else
   begin
     memo1.Lines.Add(tts.StringGrid4.Cells[4,getGV(combobox1.ItemIndex,combobox2.ItemIndex,listbox1.ItemIndex)]);
      if checkbox1.Checked then
      memo2.Lines.Add(q);
     memo1.SelStart:=0;
     memo2.SelStart:=0;

   end;

  end;
  ;
end;

procedure TDCS1.listbox1CloseUp(Sender: TObject);
begin
  if CheckBox2.checked then
  begin
     txpos[combobox1.ItemIndex + 1].stm:=checkbox1.Checked;
     txpos[combobox1.ItemIndex + 1].vrs:=radiogroup1.ItemIndex;
     txpos[combobox1.ItemIndex + 1].cp:=combobox2.ItemIndex;
     txpos[combobox1.ItemIndex + 1].ln:=listbox1.ItemIndex;
  end;
  if checkbox4.Checked then speedbutton3click(sender);;

end;

procedure TDCS1.ListBox7Click(Sender: TObject);
begin

end;

procedure TDCS1.Memo1Change(Sender: TObject);
begin
  memo2.Font := memo1.Font;
  memo2.Visible:=checkbox1.Checked;
end;

procedure TDCS1.Memo2Change(Sender: TObject);
begin

end;

procedure TDCS1.MenuItem12Click(Sender: TObject);
{type xd4 = array[1..84] of byte;
var i,j,k,l,m : longint;
    x,z,fn,zz : string;
    xd5 : array of xd4;
    xd6 : Array[1..84] of longint;
    f : system.TEXt;
    Wct: longint;
    mx,mn,md : longint;
    c1 : longint;
    sg : string;
    vp : longint;
    inx : word;
}
begin
//  ct.StringGrid1.LoadFromCSVFile('sys\t\texts.csv',':',true);
ct.Show;;
{
//panel6.Show;
//label3.Show;
//progressbar1.Max:=combobox1.Items.Count;
//progressbar1.Step:=2;
//progressbar1.Show;
textid1 := 0;
for inx := 0 to combobox1.Items.Count - 1 do
begin
   combobox1.ItemIndex:=inx;
   combobox1change(sender);
if combobox2.Items.Count > 0 then
begin;
//     progressbar1.Position:=inx;
     inc(textid1);
     ct.StringGrid1.RowCount:=textid1 + 1;

    initgra;  vp := 0;
    mx := 0;  mn := 0; md := 0;
    wct := 0;
    z := fn;

    k := 1; l := 0; m := 0;
    x := '';
    for i  := 1 to length(snt) do
    if tx[strtoint(cp[strtoint(lx[i].cid)].tid)].tn = combobox1.Text then
    begin
      setlength(xd5,k);
      xd5[k - 1] := axa[i];
      inc(k);
      inc(wct,length(snt[i]));
      m := k - 1;
      if length(snt[i]) = 0 then inc(l);
      if length(snt[i]) > 0 then
      for c1 := 0 to length(snt[i]) -1 do
      begin
        sg := dcs1.GetGr(snt[i,c1].osn);
        case sg of
             'f' : inc(gra.f);
             'fn' : inc(gra.fn);
             'm' : inc(gra.m);
             'mn' : inc(gra.mn);
             'mf' : inc(gra.mf);
             'mfn' : inc(gra.mnf);

             'djan' : inc(gra.dj1);
             'adj' : inc(gra.adj);
             'v' : begin
                    inc(gra.v);
                    inc(vp,c1);
             end;
             'ind' : inc(gra.ind);
             'pron' : inc(gra.pr);
             'nr' : inc(gra.nr);
             'djma' : inc(gra.dj2);
             'n'    : inc(gra.n);
        end;
      end;
    end;
    for k := 1 to 84 do xd6[k] := 0;
    j := 0;
    for i := 0 to length(xd5) - 1 do
    for k := 1 to 84 do
    begin
       inc(xd6[k],xd5[i,k]);
       inc(j,xd5[i,k]);
    end;


if j > 0 then
begin
    x := '';
       CT.StringGrid1.Cells[0,textid1] := combobox1.Text;
       CT.StringGrid1.Cells[1,textid1] := floattostr((100 - l/m*100))+'%';
       CT.StringGrid1.Cells[2,textid1] := floattostr(wct);
       ct.StringGrid1.Cells[3,textid1] :=     floattostr(((gra.m+gra.mn+gra.f+gra.fn+gra.mn+gra.mf+gra.mnf + gra.n)/wct*100)) + '%';
       ct.StringGrid1.Cells[4,textid1] := floattostr((gra.adj/wct*100)) +'%';
       ct.StringGrid1.Cells[5,textid1] := floattostr((gra.pr/wct*100)) +'%';
       ct.StringGrid1.Cells[6,textid1] := floattostr((gra.ind/wct*100)) +'%';
       ct.StringGrid1.Cells[7,textid1] :=floattostr((gra.dj1/wct*100)) +'%';
       ct.StringGrid1.Cells[8,textid1] := floattostr((gra.dj2/wct*100)) +'%';
    if gra.v > 0 then
       ct.StringGrid1.Cells[10,textid1] := floattostr((vp/gra.v))
    else ct.StringGrid1.Cells[10,textid1] := '0';
    ct.StringGrid1.Cells[9,textid1] := floattostr((j/wct*100))+'%';
    ct.StringGrid1.Cells[11,textid1] := floattostr((wct/m));


    for i := 12 to 54 do
    ct.StringGrid1.columns[i].Title.Caption:= wr.GetTense(inttostr(i - 11));

    for i  := 1 to 42 do
    begin
       str((xd6[i] + xd6[i+42])/j*100:3:2,z);
       ct.StringGrid1.Cells[i+11,textid1] := z+'%';
    end;
   end;
  end;
end;
// panel6.Hide;
 ct.Show;
 }
end;

procedure TDCS1.MenuItem13Click(Sender: TObject);
var i,j,k : dword;
    q : dword;

    s,s1,s2 : string;
    xdc : dword;
    f : text;
//    X : Array[1..222342] of word;
    f1 : text;
    x1,x2,x3 : longint;
begin ;
  for i := 1 to length(xgd) do xgd[i] := [0];

  for q := 0 to combobox1.Items.Count - 1 do
  begin
  for i  := 1 to 621445 do
  begin
     if tx[strtoint(cp[strtoint(lx[i].cid)].tid)].tn = combobox1.Items[q] then
     begin
      if length(snt[i]) > 0 then
      for j :=0 to length(snt[i]) - 1 do
      if (snt[i,j].osn <> '') then
      begin
          k := strtoint(snt[i,j].osn);
          if k <= length(o) then
          if (o[k].DcId > 0) and (o[k].DcId <= length(xgd)) then
          xgd[o[k].DcId] := xgd[o[k].DcId] + [q+11];
      end;
  end;

  end;
//   Writeln(f1,'Stem',#9,'Gramm.',#9,'FRQ','AlphabetID');
//   for k := 1 to length(X) do if x[k] <> 0 then
//   if getosn(inttostr(k)) <> '' then
//   writeln(f1,o[k].stem,#9,o[k].gr,#9,x[k],#9,o[k].DcId);
//   closefile(f1);
//   shellexecute(0,'Open',pchar('sys\wlst.txt'),'',nil,1)
     application.Title:=inttostr(q);
   end;
   for i := 1 to length(snt) do
   if length(snt[i]) > 0then
   for j := 0 to length(snt[i]) - 1 do
   begin k := strtoint(snt[i][j].osn);
   x1 :=  strtoint(cp[strtoint(lx[i].cid)].d1);
   x2 :=  strtoint(cp[strtoint(lx[i].cid)].d2);
   x3 := round((x1+x2)/2);
   if ((k > 0) and (k <= length(o))) then
   if o[k].DcId > 0 then
   begin
     if x3 <= -800 then xgd[o[k].DcId] :=  xgd[o[k].DcId] + [4];
     if (x3 >= -800) and (x3 <= -300) then xgd[o[k].DcId] :=  xgd[o[k].DcId] + [5];
     if (x3 >= -300) and (x3 <= 200) then xgd[o[k].DcId] :=  xgd[o[k].DcId] + [6];
     if (x3 >= 200) and (x3 <= 700) then xgd[o[k].DcId] :=  xgd[o[k].DcId] + [7];
     if (x3 >= 700) and (x3 <= 1200) then xgd[o[k].DcId] :=  xgd[o[k].DcId] + [8];
     if (x3 >= 1200) and (x3 <= 1700) then xgd[o[k].DcId] :=  xgd[o[k].DcId] + [9];
     if (x3 >= 1700) and (x3 <= 2000) then xgd[o[k].DcId] :=  xgd[o[k].DcId] + [10];

     if (x3 <= -300)  then xgd[o[k].DcId] :=  xgd[o[k].DcId] + [1];
     if (x3 >= -300) and (x3 <= 500) then xgd[o[k].DcId] :=  xgd[o[k].DcId] + [2];
     if (x3 >= 700) and (x3 <= 2000) then xgd[o[k].DcId] :=  xgd[o[k].DcId] + [3];



   end;

   end;

  rewrite(FG);
  for i := 1 to length(xgd) do write(fg,xgd[i]);closefile(fg);
  Showmessage('done');
end;

procedure TDCS1.MenuItem14Click(Sender: TObject);
var i,j,k,l : longint;
    s,s1 : string;
    datax : array of longint;
begin
//  panel6.Show;
//  label3.Show;
  s := ',';k := 0;s1 := '';
// progressbar2.show;
// progressbar2.Max:=2;
// progressbar2.Min:=0;
// progressbar2.Position:=0;
// progressbar1.Show;
// progressbar1.Min:=0;
// progressbar1.Max:=length(snt);
// progressbar1.Step:=1000;
 dc.CheckBox1.Checked:=false;
 for i  := 1 to length(snt) do
 begin
//    progressbar1.Position:=i;
    if tx[strtoint(cp[strtoint(lx[i].cid)].tid)].tn = combobox1.Text then
    begin
     for j :=0 to length(snt[i]) - 1 do
     if pos(','+snt[i,j].osn +',',s) = 0 then
     begin
        s := s + snt[i,j].osn +',';
        inc(k);
     end;
 end;
 end;
 setlength(ddl,k);
if k > 0 then
begin
 setlength(datax,k);
 delete(s,1,1);
 l := 0;

 if k > 0 then

 for i := 0 to k - 1 do
 if (s <> '') and (s <> ',') and (s <> ' ') then
 if strtoint(copy(s,1,pos(',',s)-1)) <= length(od) then
 begin
  if od[strtoint(copy(s,1,pos(',',s)-1))] <> '' then
   datax[i] := strtoint(od[strtoint(copy(s,1,pos(',',s)-1))]);
   delete(s,1,pos(',',s));
 end
 else    delete(s,1,pos(',',s));

 if k > 1 then
 for i := 0 to k - 1 do
 for j := 0 to k -2 do
 if datax[j] > datax[j + 1] then
 begin
    l := datax[j]; datax[j] := datax[j+1]; datax[j+1] := l;
 end;
 l := 0;

 for i := 0 to length(datax) - 1 do
 if datax[i] <> 0 then
 begin
    form1.FillDlist(datax[i]);
    dlist[1].wd := depo.stringgrid1.cells[1,datax[i]];
    ddl[l] :=  dlist;
    inc(l);
 end;
 setlength(ddl,l);

 form1.SpeedButton27Click(sender);
 end
else
   showmessage('The text declared in DCS but does not marked');
end;

procedure TDCS1.MenuItem15Click(Sender: TObject);
var s,s1,s2 : string;
    i,j : longint;
    f   : system.TEXT;
    stp : longint;
    mnt : longint;
    tstp,tmnt : longint;
begin
    tstp := 0;
    tmnt := 0;
    system.Assign(f,'Reports\tans.txt');
    rewrite(f);
    listbox9.Clear;
    for i := 0 to combobox2.Items.Count - 1 do
    begin  mnt := 0;
      listbox9.Clear;
      combobox2.ItemIndex:=i;
      combobox2change(sender);
      stp := listbox1.Items.Count;
      for j := 0 to listbox1.items.Count - 1 do
      if listbox1.Items[j] <> '' then
      begin
        s := listbox1.Items[j];
        if pos(' ',s) > 0 then
        s := ' '+copy(s,1,pos(' ',s))
        else s := ' '+s+' ';
        if pos(s,listbox9.Items.Text) = 0 then
        listbox9.Items.Add(s);
      end;
      mnt := listbox9.Items.Count;
      writeln(f,combobox2.Text,';',stp,';',mnt,';');
      inc(tstp,stp);
      inc(tmnt,mnt);

    end;
    writeln(f,tstp,'  ',tmnt);
    system.Close(f);
    Showmessage('Done')
end;

procedure TDCS1.MenuItem16Click(Sender: TObject);
var i,j : word;
begin
  for i := 1 to stringgrid3.RowCount-1 do
  if combobox1.Text=stringgrid3.Cells[0,i] then
  begin
     memo1.Clear;
     for j := 0 to stringgrid3.ColCount - 1 do
     memo1.Lines.Add(stringgrid3.Cells[j,0] + ': ' + stringgrid3.Cells[j,i]);
     break;
  end;
  memo1.SelStart:=0;
  memo1.SetFocus;
end;

procedure TDCS1.MenuItem17Click(Sender: TObject);
begin
  un := tun.Create(self);
  un.Show;
  un.Edit1.Text:='';
  un.Edit2.Text:='';
  un.Button1.Enabled:=false;

end;

procedure TDCS1.MenuItem18Click(Sender: TObject);
var i : word;
    s : string;
    z : boolean;
begin z := false;
    s := combobox1.Text;
    for i := 1 to length(adat) do
    if s = adat[i].tname then
    begin
      z := true;
      ct.StringGrid1.RowCount:=1;
      CT.StringGrid1.LoadFromCSVFile(adat[i].filename,':',true);
      ct.StringGrid1.DeleteCol(1);
      ct.Show;
//      Showmessage(adat[i].filename);
      break;
    end;
    if z = false then
    form1.infx('DCS DATA INFO','The text declared in DCS but does not marked');
end;

procedure TDCS1.MenuItem1Click(Sender: TObject);
begin
  hw1.CopyToClipboard;
end;

procedure TDCS1.MenuItem22Click(Sender: TObject);
var f : system.TEXT;
    i,j : longint;
    s : string;
begin
if savedialog1.Execute then
begin
    system.Assign(f,savedialog1.FileName);
    rewrite(f);
    for i := 0 to combobox2.Items.Count - 1 do
    begin
      combobox2.ItemIndex:=i;
      combobox2Change(sender);
      for j := 0 to listbox1.Items.Count - 1 do
      begin
        listbox1.ItemIndex:=j;
        listbox1click(sender);
        s := combobox2.Items[i]+#9+listbox1.Items[j]+#9 +
        memo1.lines.CommaText+#9+memo2.lines.CommaText;
        if pos(': ',s) > 0 then delete(s,pos(': ',s)+1,1);
        writeln(f,s);

      end;
    end;
    system.Close(f);
    if form1.CheckBox7.Checked then
    shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);

end;

end;

procedure TDCS1.MenuItem23Click(Sender: TObject);
var i : word;
begin
    for i := combobox1.ItemIndex to combobox1.Items.Count - 1 do
    begin
      combobox1.ItemIndex:=i;
      combobox1change(sender);
      if combobox2.items.Count > 0 then
      begin
        combobox2.ItemIndex:=0;
        combobox2change(sender);
        if listbox1.Items.Count > 0 then
        button3click(sender);
      end;
    end;
end;

procedure TDCS1.MenuItem24Click(Sender: TObject);
var i,j,k,l,m : longint;
    s,s1,s2,s3 : string;
    F : text;
begin  system.Assign(f,'Reports\Amara.txt'); rewrite(f);
       for i := 0 to combobox1.Items.Count - 1 do
       begin
         combobox1.ItemIndex:=i;
         combobox1Change(sender);
         if combobox2.Items.Count > 0  then
         for j := 0 to combobox2.Items.Count - 1 do
         begin
            combobox2.ItemIndex:=j;
            combobox2change(sender);
            if listbox1.Items.Count > 0 then
            begin
               s := '';   s2 := ',';                     s2 := ',';
               for m := 0 to listbox1.Items.Count - 1 do
               if listbox1.Items[m] <> '' then
               begin
                  s1 := copy(listbox1.Items[m],1,pos(' ',listbox1.Items[m]));

               for k := m to listbox1.Items.Count - 1 do
               begin
                 if pos(s1,listbox1.Items[k]) = 1 then
                 begin
                    if pos('|',lx1[k].ln) = 0 then
                    s := s +lx1[k].ln+ ' | ' else s := s +lx1[k].ln + ' ';;
                    listbox1.Items[k] := '';
                    if length(snt[strtoint(lx1[k].id)]) > 0 then
                    for l := 0 to length(snt[strtoint(lx1[k].id)]) - 1 do
                    s2 := s2 + snt[strtoint(lx1[k].id),l].osn + ',';
                    if s2 = ',' then s2 := '';
                 end;
               end;
//                  if s2 <> '' then
                  begin
                     s3 := combobox2.Text;
                     delete(s3,1,pos(':',s3)+1);
                     writeln(f,combobox1.Text,';',combobox2.Text,';',
                     copy(s1,1,pos(' ',s1)-1),';',s2,';',s,';',s3);
                     s2 := ''; s3 := '';s := ''; s1 := '';

                  end;

               end;

            end;
         end;
       end;

       system.Close(f);
end;

procedure TDCS1.MenuItem2Click(Sender: TObject);
begin
  hw1.SelectAll
end;

procedure TDCS1.MenuItem3Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw1.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.google.com/?sl=auto&tl=ru&text='+s+'&op=translate')
  ,nil,nil,1);

end;

procedure TDCS1.MenuItem4Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw1.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.yandex.ru/?source_lang=en&target_lang=ru&text='+s)
  ,nil,nil,1);




//https://translate.yandex.ru/?source_lang=en&target_lang=ru&text=hi


end;


procedure TDCS1.MenuItem6Click(Sender: TObject);
begin
  Hide;
end;

procedure TDCS1.MenuItem7Click(Sender: TObject);
begin
  Button1click(sender);
end;

procedure TDCS1.MenuItem8Click(Sender: TObject);
begin
  button3click(sender);
end;

procedure TDCS1.MenuItem9Click(Sender: TObject);
var i : integer;
    s : string;
begin

  label9.Caption:= combobox1.Text + ' '+ combobox2.Text + ' '+
  listbox1.Items[listbox1.ItemIndex];
  sta.ListBox1.Clear;
  StringGrid1.RowCount:=1;
  progressbar1.Position := 45;
  if radiogroup1.ItemIndex=0 then
  begin
   sta.ListBox1.Items.Add(lx1[listbox1.ItemIndex].id);
   sta.Memo1.Lines.Add(lx1[listbox1.ItemIndex].ln);
  end
  else
  begin
   s := listbox1.Items[listbox1.ItemIndex];
   s := copy(s,1,pos(' ',s));
   for i := 0 to listbox1.Items.Count - 1 do
   if pos(s,listbox1.Items[i]) = 1 then
   begin
    sta.listbox1.Items.Add(lx1[i].id);
    sta.Memo1.Lines.Add(lx1[i].ln);
   end;
   progressbar1.Position:=60;
   sta.Memo2.Text:=sta.ListBox1.Items.Text;
   sta.Memo1.SelStart:=0;
  end;
  Fillsta;

  if StringGrid1.RowCount > 1 then
  begin
     StringGrid1.Row:=1;

  end
  else
     Showmessage('No DCS data for this phrase.');


progressbar1.Hide;
end;

procedure TDCS1.Panel11Click(Sender: TObject);
begin

end;

procedure TDCS1.Panel3Click(Sender: TObject);
begin

end;

procedure TDCS1.RadioGroup1Click(Sender: TObject);
begin
  listbox1click(sender);
end;

procedure TDCS1.SBClearClick(Sender: TObject);
begin
  panel11.Hide;
  if (panel10.Visible = false) then
     panel3.Align:=alclient
     else
     begin
       panel3.Align:=altop;
       panel10.Align:=alclient;
     end;
     formactivate(sender);

end;

procedure TDCS1.SpeedButton10Click(Sender: TObject);
var i : word;
begin
    for i := 1 to prl.combobox1.items.Count-1 do
    if combobox1.Text = prl.combobox1.Items[i] then
    begin
      prl.ComboBox1.ItemIndex:=i;
      prl.ComboBox1Change(sender);
      prl.WindowState := wsnormal;
      prl.Show;
      prl.BringToFront;
      break;
    end;
end;

procedure TDCS1.SpeedButton10MouseEnter(Sender: TObject);
begin
  Speedbutton10.Color := $000080FF;
end;

procedure TDCS1.SpeedButton10MouseLeave(Sender: TObject);
begin
  Speedbutton10.Color := clgreen;
end;

procedure TDCS1.SpeedButton11Click(Sender: TObject);
begin
  if application.MessageBox('Do you really want to clear your Favorites list?','Clearing the list',52) = 6 then
  Combobox3.Clear;
end;

procedure TDCS1.SpeedButton11MouseEnter(Sender: TObject);
begin
    Speedbutton11.Color := $000080FF;
end;

procedure TDCS1.SpeedButton11MouseLeave(Sender: TObject);
begin
  Speedbutton11.Color := clgreen;
end;

procedure TDCS1.SpeedButton12Click(Sender: TObject);
var x : dword;
begin
  if memo1.Text <> '' then
  if tz.StringGrid2.RowCount < repolim then
  begin
    x := tz.StringGrid2.RowCount;
    tz.StringGrid2.RowCount := x + 1;
    tz.StringGrid2.Cells[0,x] := datetimetostr(date)+ ' ' + timetostr(time);
    tz.StringGrid2.Cells[1,x] := combobox1.Text;
    tz.StringGrid2.Cells[2,x] := copy(combobox2.Text,1,pos(':',combobox2.Text)-1);
    tz.StringGrid2.Cells[3,x] := listbox1.Items[listbox1.ItemIndex];
    tz.StringGrid2.Cells[4,x] := memo1.Lines.CommaText;
    tz.StringGrid2.Cells[5,x] := '';
    tz.StringGrid2.Cells[6,x] := '';
    form1.infx('Repository','Phrase has been added');
  end
  else
  form1.infx('Repository','Not anough place in the repository');
end;

procedure TDCS1.SpeedButton12MouseEnter(Sender: TObject);
begin
  speedbutton12.color := $000080FF;;
end;

procedure TDCS1.SpeedButton12MouseLeave(Sender: TObject);
begin
  speedbutton12.color := clgreen;;
end;

procedure TDCS1.SpeedButton13Click(Sender: TObject);
begin
  tz.Show;
  tz.PageControl1.ActivePageindex := 1;
end;

procedure TDCS1.SpeedButton13MouseEnter(Sender: TObject);
begin
  speedbutton13.color := $000080FF;;
end;

procedure TDCS1.SpeedButton13MouseLeave(Sender: TObject);
begin
  speedbutton13.color := clgreen;
end;

procedure TDCS1.SpeedButton14Click(Sender: TObject);
var i : word;
begin
  vstat.A[30].CName:=speedbutton14.Caption;
  inc(vstat.A[30].c);
  if rdr.WindowState = wsminimized then rdr.WindowState:=wsnormal;
  rdr.BringToFront;
  Rdr.Top:=0;
  rdr.Left:=0;
  rdr.Width:=screen.Width;
  rdr.Height:=screen.Height;
  rdr.Show;
  rdr.Memo1.Clear;
  if length(lx1) > 0 then
  for i := 0 to length(lx1) - 1 do
  rdr.Memo1.Lines.Add(
  lx1[i].st + ' '+ lx1[i].pd +'$'+lx1[i].ln);
  if listbox1.ItemIndex > - 1 then
  begin
     slk := listbox1.ItemIndex;
     rdr.label19.Caption:=combobox1.Text + ' '+ combobox2.Text + '#'+ listbox1.Items[listbox1.ItemIndex];
  end;

  rdr.Timer1.Enabled:=true;;
  rdr.label19.Caption:= rdr.label19.Caption +' Click ➤ to start reading';
  rdr.label4.Caption:='';rdr.label5.Caption:='';
  rdr.Label5.Caption:='';
  rdr.Label7.Caption:='';
  rdr.Label4.Caption:='';
  rdr.Label8.Caption:='';
end;

procedure TDCS1.SpeedButton14MouseEnter(Sender: TObject);
begin
  speedbutton14.color:=$000080FF;;
end;

procedure TDCS1.SpeedButton14MouseLeave(Sender: TObject);
begin
  Speedbutton14.color := $00404000;
end;

procedure TDCS1.SpeedButton1Click(Sender: TObject);
begin
  MenuItem16Click(Sender);
end;

procedure TDCS1.SpeedButton1MouseEnter(Sender: TObject);
begin
  Speedbutton1.Color := $000080FF;
end;

procedure TDCS1.SpeedButton1MouseLeave(Sender: TObject);
begin
  Speedbutton1.Color := clgreen;
end;

procedure TDCS1.SpeedButton2Click(Sender: TObject);
begin
  MenuItem18Click(Sender);
  Ct.Show;
  CT.BT2.Enabled := false;
//  CT.StringGrid1.LoadFromCSVFile('sys\t\texts.csv',#9,true);
  CT.prep;
//  CT.Caption:='Подробный анализ корпуса';
  ct.BringToFront;
  tCompare.CT.Caption:=combobox1.text;
  if ct.WindowState=wsminimized then
  ct.WindowState:= wsnormal;
  ct.BringToFront;
end;

procedure TDCS1.SpeedButton2MouseEnter(Sender: TObject);
begin
  Speedbutton2.Color := $000080FF;
end;

procedure TDCS1.SpeedButton2MouseLeave(Sender: TObject);
begin
  Speedbutton2.Color := clgreen;
end;

procedure TDCS1.SpeedButton3Click(Sender: TObject);
var i : byte;
begin
  cursor := crhourglass;
  memo1.cursor := crhourglass;
  memo1.cursor := crhourglass;
  gb1.cursor := crhourglass;

  hw1.Clear;
  hw1.DefFontName:=form1.Memo1.Font.Name;
  hw1.DefFontSize:=form1.Memo1.Font.Size;
  hw1.Font := form1.hw1.Font;
  panel10.Align:=altop;
  if panel3.Align=alclient then panel3.Align:=altop;
  panel11.Show;  hw1.clear;stringgrid1.Clear;
  formActivate(sender);
  stringgrid1.RowCount:=1;
  progressbar1.Show;
  progressbar1.Position:=35;
  MenuItem9Click(Sender);
  progressbar1.Position:=100;
  progressbar1.Hide;

  hw1.DefFontName:=form1.hw1.DefFontName;
  hw1.DefFontSize:=form1.hw1.DefFontSize;
  form1.bitbtn4click(sender);
  sgnt;
  formactivate(sender);
  cursor := crdefault;
  memo1.cursor := crdefault;
    memo1.cursor := crdefault;
    gb1.cursor := crdefault;
  end;

procedure TDCS1.SpeedButton3MouseEnter(Sender: TObject);
begin
  Speedbutton3.Color := $000080FF;
end;

procedure TDCS1.SpeedButton3MouseLeave(Sender: TObject);
begin
  Speedbutton3.Color := clgreen;
end;

procedure TDCS1.SpeedButton4Click(Sender: TObject);
var i : dword; s : string;
begin
 if form5.WindowState=wsminimized then
    form5.WindowState:=wsnormal;
 form5.Show;
 form5.BringToFront;
 form5.StringGrid1.LoadFromCSVFile('sys\xlsdata\FDic\'+inttostr(combobox1.ItemIndex)+'.txt',#9,false,2,true);
 form5.StatusBar1.Panels[1].TEXT := inttostr(form5.StringGrid1.RowCount -1);
 form5.Caption:= lp.stringGrid1.cells[x229,803]+combobox1.Text;
 with form5 do
 for i := 1 to stringgrid1.RowCount-1 do
 begin
  s := stringgrid1.Cells[2,i];
  while length(s) < 5 do s := '0'+s;
  stringgrid1.Cells[2,i] := s;
  s := stringgrid1.Cells[3,i];
  while length(s) < 6 do s := '0'+s;
  stringgrid1.Cells[3,i] := s;

 end;
// shellexecute(0,'Open',pchar('sys\xlsdara\FDic\'+combobox1.ItemIndex+'.txt'),'',nil,1)
//  MenuItem13Click(Sender);
end;

procedure TDCS1.SpeedButton4MouseEnter(Sender: TObject);
begin
  Speedbutton4.Color := $000080FF;
end;

procedure TDCS1.SpeedButton4MouseLeave(Sender: TObject);
begin
  Speedbutton4.Color := clgreen;
end;

procedure TDCS1.SpeedButton5Click(Sender: TObject);
begin
  MenuItem14Click(Sender);
end;

procedure TDCS1.SpeedButton5MouseEnter(Sender: TObject);
begin
  Speedbutton5.Color := $000080FF;
end;

procedure TDCS1.SpeedButton5MouseLeave(Sender: TObject);
begin
  Speedbutton5.Color := clgreen;
end;

procedure TDCS1.SpeedButton6Click(Sender: TObject);
begin
  Ct.Show;
  CT.BT2.Enabled := true;
  CT.StringGrid1.LoadFromCSVFile('sys\t\texts.csv',#9,true);
  CT.prep;
  CT.Caption:='Подробный анализ корпуса';
  ct.BringToFront;
end;

procedure TDCS1.SpeedButton6MouseEnter(Sender: TObject);
begin
    Speedbutton6.Color := $000080FF;
end;

procedure TDCS1.SpeedButton6MouseLeave(Sender: TObject);
begin
  Speedbutton6.Color := clgreen;
end;

procedure TDCS1.SpeedButton7Click(Sender: TObject);
var i,j : dword; s,s1,s2, Filename,g : string; F : text;
begin
 //  MenuItem17Click(Sender);
 //   ParalPrint
 j := 0;
if savedialog1.Execute then
begin
 Filename := savedialog1.FileName;;
 Assignfile(F,filename);rewrite(f);
 progressbar1.Show;
 progressbar1.Position:=0;
 s := combobox1.Text;
 while pos('"',s) > 0 do delete(s,pos('"',s),1);
 with tts do
 for i := 0 to stringgrid4.RowCount - 1 do
 if s = stringgrid4.Cells[0,i] then
 begin
   s1 := stringgrid4.Cells[1,i];
   s2 := copy(s1,1,pos(':',s1)-1);
   delete(s1,1,pos(':',s1)); while pos(' ',s1) > 0 do delete(s1,pos(' ',s1),1);
   while length(s1) < 4 do s1 := '0'+s1;
   writeln(f,s,#9,s2,#9,s1,#9,stringgrid4.Cells[2,i],#9,
   stringgrid4.Cells[3,i],#9,stringgrid4.Cells[4,i]);
   inc(j);
 end;

 closefile(f);
 if j > 1000 then
 if application.MessageBox('It takes some time. Continue','Very big text',36) <> 6 then exit;
 progressbar1.Position:=20;
 if j > 0 then
 begin
   stringgrid3.Clear;stringgrid3.ColCount:=0;
   dcs1.StringGrid3.LoadFromCSVFile(filename,#9);
//   stringgrid3.SortColRow(true,2);
   s := ',';j := 0;
   for i := 0 to stringgrid3.RowCount - 1 do
   begin
    s1 := stringgrid3.Cells[4,i];
    delete(s1,1,1);
    while s1 <> '' do
    begin
     s2 := copy(s1,1,pos(',',s1)-1);
     delete(s1,1,pos(',',s1));
     if pos(','+s2+',',s) = 0 then
     begin
       s := s +s2+',';
       inc(j);
     end;

    end;
   end;
   progressbar1.Position:=50;
   rewrite(f);
   writeln(F,Combobox1.Text,#9,#9,#9);
   Writeln(f,'देवनागरी',#9,'IAST',#9,'Gramm',#9,'Frequency',#9,'Pointer');
   delete(s,1,1);
   while s <> '' do
   begin
      s1 := copy(s,1,pos(',',s));
      s1 := ',' +s1;
      delete(s,1,pos(',',s));
      s2 := s1; while pos(',',s2) > 0 do delete(s2,pos(',',s2),1);
      j := 0;
      s2 := '';
      for i := 0 to stringgrid3.RowCount - 1 do
      if pos(s1,stringgrid3.Cells[4,i]) > 0 then
      begin
        s2 := s2 + stringgrid3.Cells[1,i] + ', '+ stringgrid3.Cells[3,i]+ '; ';
        inc(j);
      end;
      s2 := inttostr(j) + #9+s2;
      while pos(',',s1) > 0 do delete(s1,pos(',',s1),1);
      if s1 <> '' then g := getgr(s1) else g := '';
      if s1 <> '' then s1 := getosn(s1);
      if s1 <> '' then
      writeln(f,form1.convertd(s1),#9,s1,#9,g,#9,s2);
   end;
   closefile(f);
   progressbar1.Position:=100;
   progressbar1.Hide;
   if form1.CheckBox7.Checked then
   shellexecute(0,'Open',pchar(filename),'',nil,1);

 end;
 end;





end;

procedure TDCS1.SpeedButton8Click(Sender: TObject);
begin
  MenuItem22Click(Sender);
end;

procedure TDCS1.SpeedButton9Click(Sender: TObject);
begin
  MenuItem24Click(Sender);
end;

procedure TDCS1.SpXClick(Sender: TObject);
begin
  form8.Show;
  form8.PageControl1.ActivePageIndex:=2;
end;

procedure TDCS1.StringGrid1Click(Sender: TObject);
var s : string;
begin
  sf.findinfo(stringgrid1.Cells[0,stringgrid1.Row],
  d[form1.GetletId(stringgrid1.Cells[0,stringgrid1.Row])].beg,
  d[form1.GetletId(stringgrid1.Cells[0,stringgrid1.Row])].ed,true,s);
  hw1.LoadFromString(s);


end;

procedure TDCS1.StringGrid1ColRowMoved(Sender: TObject; IsColumn: Boolean;
  sIndex, tIndex: Integer);
begin
  sgnt;
  showmessage('');
end;

procedure TDCS1.StringGrid1DblClick(Sender: TObject);
begin
form1.GetExam(stringgrid1.Cells[5,stringgrid1.Row]+' ',0,0,0,0,0);
wr.Caption:= lp.StringGrid1.Cells[x229,462] + ' "'+
stringgrid1.Cells[0,stringgrid1.Row] + '"';
if wr.WindowState = wsminimized then
wr.WindowState:= wsnormal;
wr.Show;
wr.BringToFront;


end;

procedure TDCS1.StringGrid1HeaderSizing(Sender: TObject;
  const IsColumn: boolean; const aIndex, aSize: Integer);
begin
    sgnt;
end;

procedure TDCS1.StringGrid1Resize(Sender: TObject);
begin
  sgnt;
end;

procedure TDCS1.ComboBox1Change(Sender: TObject);
var i,j : longint;
    s : string;
begin
if cc3 then
begin

    listbox1.Clear; combobox2.Clear;
    c3 := false;
    memo1.Clear;memo2.Clear;
    if c1 then
    for i := 1 to length(tx) do
    if combobox1.Text = tx[i].tn then
    begin
      gtid := tx[i].id;
      fillcp;
      if combobox2.items.Count > 0 then
      combobox2change(sender);

      break;
    end;
    c3 := true;

   statusbar1.Panels[1].Text:=inttostr(combobox2.Items.Count);
   statusbar1.Panels[3].Text:='0';//inttostr(combobox2.Items.Count);

    if combobox2.Items.Count > 0 then
    begin
       combobox2.ItemIndex:=txpos[combobox1.ItemIndex + 1].cp;
       combobox2change(sender);
       if listbox1.Items.Count > 0 then
       listbox1.ItemIndex:=txpos[combobox1.ItemIndex+1].ln;
       radiogroup1.ItemIndex:=txpos[combobox1.ItemIndex + 1].vrs;
       checkbox1.Checked:=txpos[combobox1.ItemIndex + 1].stm;
       listbox1click(sender);
       statusbar1.Panels[3].Text:=inttostr(listbox1.Items.Count);
       cc3 := false;
       if checkbox3.Checked then
     begin
       if combobox1.Items.Count > 0 then
       for i := 0 to combobox3.Items.Count - 1 do
       if combobox3.Items[i] = combobox1.Text then
       begin
         combobox3.Items.Delete(i);
         break;
       end;
       combobox3.Items.Insert(0,combobox1.TEXT);
       if combobox3.Items.Count > 25 then
       combobox3.Items.Delete(25);
       combobox3.ItemIndex:=0;
    end;
       cc3 := true;

    end;
end;
statusbar1.Panels[3].Text:=inttostr(listbox1.Items.Count);
end;

procedure TDCS1.Button1Click(Sender: TObject);
var f : text; i,j : word;s : string;
{var k : longint;
    i,j,a,q,w : longint;
    s : string;
    s1: string;
    s4,s5,s9: string;
    p : word;
    d7,d5 : integer;
    ss : string;
    s3,s6 : string;
    e : word;
}
begin
   if stringgrid1.RowCount > 1 then
   if savedialog1.Execute then
   begin
    assignfile(f,savedialog1.FileName);
    rewrite(f);
    writeln(f,label8.Caption);
    writeln(f,memo1.Text);
    writeln(f,'Wordlist:');
    writeln(f,memo2.Text);
    writeln(f,'Analysis');
    writeln(f,'Lemma',#9,'Type',#9,'Gramm. form');

    for i := 1 to stringgrid1.RowCount - 1 do
    begin s := '';
       for j := 0 to stringgrid1.ColCount-1 do
       if j in [0,1,4] then
       s := s + stringgrid1.Cells[j,i] + #9;
       if pos(#9+'!',s+'!') > 0 then delete(s,pos(#9+'!',s+'!'),1);
       writeln(f,s);
    end;
    closefile(f);
    if form1.CheckBox7.Checked then
    shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1)

   end;

{
if radiogroup1.ItemIndex=0 then
begin
   k :=1;  d5 := 0;d7:=0;p:=0;
   s4 := '';
   s := ',';
    for w := 0 to length(snt[strtoint(lx1[listbox1.ItemIndex].id)]) - 1 do
    if snt[strtoint(lx1[listbox1.ItemIndex].id),w].osn <> '' then
    if pos(','+snt[strtoint(lx1[listbox1.ItemIndex].id),w].osn+',',s) = 0 then
    begin
      s := s + snt[strtoint(lx1[listbox1.ItemIndex].id),w].osn + ',';
      inc(d5);
    end;
    s3 := combobox1.Text + ' '+combobox2.Text+' '+listbox1.Items[listbox1.ItemIndex];
stringgrid1.RowCount:=97000;
    for i := 0 to length(lx) - 1 do
    begin
      s1 := ',';
       p := 0;
       d7 := 0;

       for a := 0 to length(snt[i]) - 1 do
       if  snt[i,a].osn <> '' then
       if pos(','+snt[i,a].osn+',',s1) = 0 then
       begin
         s1 := s1 + snt[i,a].osn + ',';
         inc(d7);
         if pos(','+snt[i,a].osn+',',s) > 0 then
         inc(p)
         else s4 := snt[i,a].osn;
       end;
       s9 := '';
       if (d5> 0) and  (d7 > 0)then
       begin
       if lx[i].st ='' then lx[i].st := '0';

       if (tx[strtoint(cp[strtoint(lx[i].cid)].tid)].tn +' '+cp[strtoint(lx[i].cid)].cn + ': '+ cp[strtoint(lx[i].cid)].ps+ ' '+ lx[i].st + ' '+lx[i].pd) <> s3
           then
       if (d5 = d7) and (p = d7) then
       begin
         inc(k);
         stringgrid1.Cells[0,k-1] := tx[strtoint(cp[strtoint(lx[i].cid)].tid)].tn +' '+cp[strtoint(lx[i].cid)].cn + ': '+ cp[strtoint(lx[i].cid)].ps+ ' '+ lx[i].st + ' '+lx[i].pd;
         stringgrid1.Cells[1,k-1] := lx[i].ln;
         stringgrid1.Cells[2,k-1] := 'GOOD';
         stringgrid1.Cells[3,k-1] := '';
       end
       else
       begin
         if abs(d5 - d7) = 1 then
         if  (p >= d7 - 1) or
             (p >= d5 - 1)
         then
         begin
            s5 := s;
            s4 := '+ '+ getosn(s4);
            while s5 <> ''  do
            begin
               s6 :=  copy(s5,1,pos(',',s5));
               if pos(s6,s1) = 0 then
               begin
                 s9 := '- '+getosn(s6);
                 s5 := '';
                 break;
               end
               else delete(s5,pos(s6,s5),length(s6));
            end;


              inc(k);
              stringgrid1.Cells[0,k-1] := tx[strtoint(cp[strtoint(lx[i].cid)].tid)].tn +' '+cp[strtoint(lx[i].cid)].cn  + ': '+ cp[strtoint(lx[i].cid)].ps+ ' ' +lx[i].st + ' '+lx[i].pd;
              stringgrid1.Cells[1,k-1] := lx[i].ln;
              stringgrid1.Cells[2,k-1] := 'PARTLY';
              stringgrid1.Cells[3,k-1] := s4+' '+s9;
            end;
       end;

       end;

       end;

    stringgrid1.RowCount:=k;
if (Stringgrid1.rowcount = 1) or
   (stringgrid1.Cells[0,1] = '') then
   begin

//     button2.Hide
   end
   else
    begin

//      button2.Show;
    end;

end
else
begin
  Chkline(GetGV(combobox1.ItemIndex,combobox2.ItemIndex,listbox1.ItemIndex),true);
end;

statusbar1.Panels[5].Text:=inttostr(stringgrid1.RowCount - 1);
}
end;

procedure TDCS1.Button3Click(Sender: TObject);
begin
{var f4 : system.Text;
    s,s1,s2 : string;
    i,j,k : longint;
    count : integer;
    Countx: longint;
    Countz: longint;
    Filename : string;

begin
CountX := 0;
Countz := 0;
{if listbox1.ItemIndex > combobox5.ItemIndex then
begin
  count := listbox1.ItemIndex;
  listbox1.ItemIndex:=combobox5.ItemIndex;
  combobox5.ItemIndex:=count;
end;
}
//if Application.MessageBox('This operation may takes alot of time.  Continue?','NOTIFICATION',36) = 6 then
begin

//    FileName:='PARA\'+inttostr(combobox1.ItemIndex)+'_'+listbox1.Text+'--'+combobox5.Text+'.csv';
    Application.Title:=FileName;
if radiogroup1.ItemIndex = 0 then
begin;
if combobox2.items.Count > 0 then

begin
//if savedialog1.Execute then
begin
//  panel6.Show;
//  progressbar1.Show;
//  progressbar2.Show;

  system.Assign(f4,FileName);
  rewrite(f4);
    count := 0;
//    WindowState := wsminimized;
//    progressbar2.Position := 0;
//    progressbar2.Max:=combobox5.ItemIndex;
//    progressbar2.Min:=listbox1.ItemIndex;
    for i := listbox1.ItemIndex to combobox5.itemindex do
    begin

//     progressbar1.Position:=(i);
     combobox2.ItemIndex:=i;
     combobox2change(sender);
//     progressbar1.position := 0;
     for j := 0 to listbox1.Items.Count - 1 do
     begin
      inc(countz);
//       progressbar1.Max:=listbox1.Count - 1;
//       progressbar1.Position:=j;

       listbox1.ItemIndex:=j;
       listbox1click(sender);
       button1click(sender);
       s := combobox2.Text + ';'+listbox1.Items[j] +';'+ memo1.lines.Strings[0]+';';
       s1 := '';s2 := '';
       for k := 1 to stringgrid1.RowCount - 1 do
       if stringgrid1.Cells[2,k] = 'GOOD' then
       s1 := s1 + stringgrid1.Cells[0,k]+';'+stringgrid1.Cells[1,k]+';'+stringgrid1.Cells[2,k]+';'+stringgrid1.Cells[3,k]+';'
       else s2 := s2 + stringgrid1.Cells[0,k]+';'+stringgrid1.Cells[1,k]+';'+stringgrid1.Cells[2,k]+';'+stringgrid1.Cells[3,k]+';';

       if (s1 <> '') or (s2 <> '') then inc(countx);
       writeln(f4,s+s1+s2);

       s := '';

       end;
     end;



    system.Close(f4);
    Application.Title := 'DONE! Data saved to '+FileName;

//    WindowState := wsnormal;

//    panel6.hide;
    statusbar1.Panels[1].Text:=inttostr(countz);
//    un.Edit1.Text:=savedialog1.FileName;
//    un.Edit2.Text:='';
//    un.Edit3.Text := combobox1.Text;
//    un.Button1.Enabled:=false;
//    un.Show;
//    un.edit2.SetFocus;
end;
end
else
   //Showmessage('There is no text for analisyng');
end
else
begin
//   if Execute then
   begin
    system.Assign(f4,FileName);
    rewrite(f4);

    GetV1(combobox1.ItemIndex,listbox1.ItemIndex,combobox5.ItemIndex);
//    application.Minimize;
//    panel6.Show;
//    progressbar1.Hide;
//    progressbar2.Show;
//    progressbar2.Min:=0;
//    progressbar2.Max:=stringgrid2.RowCount - 1;
//    progressbar2.Step:=10;
    if stringgrid2.RowCount > 0 then
    for i := 0 to stringgrid2.RowCount - 1 do
    begin
//      progressbar2.Position:=i;
      if pos('|',stringgrid2.Cells[4,i]) > 0 then
         s := Psl(stringgrid2.Cells[4,i],i)
         else if stringgrid2.Cells[4,i] <> '' then
              s :=
              stringgrid2.Cells[1,i] + ';'+
                stringgrid2.Cells[2,i] +' 1'+
                 ';'+stringgrid2.Cells[4,i]+'|;';


      ChkLine(i,false);
      s1 := ''; s2 := '';
      if stringgrid1.RowCount > 1 then
      for k := 1 to stringgrid1.RowCount - 1 do
      if stringgrid1.Cells[0,k] <> '' then
      begin
         if stringgrid1.Cells[2,k] = 'GOOD' then
            s1 := s1 + stringgrid1.Cells[0,k]+';'+stringgrid1.Cells[1,k]+';'+stringgrid1.Cells[2,k]+';'+stringgrid1.Cells[3,k]+';'
        else s2 := s2 + stringgrid1.Cells[0,k]+';'+stringgrid1.Cells[1,k]+';'+stringgrid1.Cells[2,k]+';'+stringgrid1.Cells[3,k]+';';
      end;
      if (s1 <> '') or (s2 <> '') then inc(countx);
      writeln(f4,s+s1+s2);

    end;

   end;
   system.Close(f4);
   Application.Title := 'Done! The Result file name is '+FileName;
//   panel6.Hide;
//   WindowState := wsnormal;
   statusbar1.Panels[1].Text:= inttostr(stringgrid2.RowCount);
end;
statusbar1.Panels[5].Text:=inttostr(countX);
statusbar1.Panels[3].Text:=inttostr(combobox5.ItemIndex - listbox1.ItemIndex + 1);



End;
}
end;

procedure TDCS1.Button4Click(Sender: TObject);
var i,j,k,w : integer;
    f : {array of} system.TextFile;
    s,s1 : string;
begin
WindowState := wsminimized;
//    setlength(f,combobox1.items.Count);
  system.Assign(f,'sys\t\0.csv');
  System.rewrite(f);

    for i := 0 to combobox1.Items.Count - 1 do
    begin
      combobox1.ItemIndex:=i;
      combobox1change(sender);
      s := '';




      for j := 0 to combobox2.Items.Count - 1 do
      begin
        combobox2.ItemIndex:=j;
        combobox2change(sender);
        s := '';
        s1 := '';
        for k := 0 to listbox1.Items.Count - 1 do
        begin
          listbox1.ItemIndex:=k;
          listbox1click(sender);

      for w := 0 to length(snt[strtoint(lx1[listbox1.ItemIndex].id)]) - 1 do
      if snt[strtoint(lx1[listbox1.ItemIndex].id),w].osn <> '' then
      if pos(','+snt[strtoint(lx1[listbox1.ItemIndex].id),w].osn+',',s) = 0 then
      begin
        s := s + snt[strtoint(lx1[listbox1.ItemIndex].id),w].osn + ',';
      end;
      s1 := s1 + memo1.lines.Strings[0];
      if pos('||',memo1.Text) > 0 then
      begin
      s := combobox1.items[i] + ';'+combobox2.Items[j] + ';' +
        copy(listbox1.items[k],1,pos(' ',listbox1.items[k]) - 1) + ';' + s+';'+s1;
        writeln(f,s);
        s := '';
        s1 := '';
      end;





      end;
        if s <> '' then
        begin
        s := combobox1.items[i] + ';'+combobox2.Items[j] + ';' +
          copy(listbox1.items[k],1,pos(' ',listbox1.items[k]) - 1) + ';' + s+';'+s1;
           writeln(f,s);
          s := '';
          s1 := '';
        end;
      end;

    end;
    system.Close(f);

end;

procedure TDCS1.CheckBox1Change(Sender: TObject);
begin
  hw1.DefFontName:=form1.hw1.DefFontName;
  hw1.DefFontSize:=form1.hw1.DefFontSize;
  listbox1click(sender);

  panel10.Visible:=checkbox1.Checked;;
  if (panel3.Align= alclient) and checkbox1.Checked then
      panel3.Align:=altop;
  if panel11.Visible then panel10.Align:=altop else
  panel10.Align:=alclient;
  memo2.Visible:= checkbox1.Checked;;
  if (panel10.Visible = false) and
     (panel11.Visible = false) then
     panel3.Align:=alclient
     else panel3.Align:=altop;
end;

procedure TDCS1.CheckBox4Change(Sender: TObject);
begin
  panel3.Align:=altop;
  if checkbox4.Checked then
  speedbutton3click(sender);
end;

procedure TDCS1.ComboBox2Change(Sender: TObject);
var i : longint;
begin
  if combobox2.Text <> '' then
  begin
  gcid := cp1[combobox2.ItemIndex].id;
  fillslk;
  memo1.Clear;
  if listbox1.ItemIndex < 0 then
  listbox1.ItemIndex:=0;
  if listbox1.Items.Count > 0 then
     listbox1click(sender);
  if checkbox4.Checked then speedbutton3click(sender);;

   end;
  statusbar1.Panels[3].Text:=inttostr(listbox1.Items.Count);

end;

procedure TDCS1.ComboBox3Change(Sender: TObject);
var i : word;
begin
    if cc3 then
    begin
    if combobox3.ItemIndex > - 1 then
    for i := 0  to combobox1.Items.Count - 1 do
    if combobox1.items[i] = combobox3.Text then
    begin
      combobox1.ItemIndex:=i;
      combobox1change(sender);
      break;
    end;
       combobox2.ItemIndex:=txpos[combobox1.ItemIndex+1].cp;
       combobox2change(sender);
       listbox1.ItemIndex:=txpos[combobox1.ItemIndex+1].ln;;
       listbox1click(sender);
//       showmessage(inttostr(txpos[combobox1.ItemIndex].cp));
    end
//    else cc3 := true;
end;

procedure TDCS1.ComboBox4Change(Sender: TObject);
begin

end;

procedure TDCS1.FormActivate(Sender: TObject);
begin
  memo2.Font := memo1.Font;
//  memo3.Font := memo1.Font;
 if panel11.Visible then
 begin
   if panel3.Visible then
   begin;
     panel10.Height:= panel2.Height div 4;
     panel3.Height:= panel2.Height div 4;
   end
   else
     panel10.Height := panel2.Height div 2;;
 end
 else
 begin
   if panel3.Visible then
   begin
     panel10.Height:=panel2.Height div 2 - 6;
     panel3.Height:=panel2.Height div 2 - 6;
   end
   else panel10.Height:=panel2.Height - 6;
end;

end;

procedure TDCS1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var ftt : tpos;
    fpos: file of tpos;
    i : byte;
begin
    form1.BitBtn4.Hide;
    form1.p18;
    ftt.sid:=listbox1.ItemIndex;
    ftt.cid:=combobox2.ItemIndex;
    ftt.tid:=combobox1.ItemIndex;
    rewrite(fps);
    write(fps,txpos);
    closefile(fps);
    combobox3.Items.SaveToFile('sys\4.0\fvrtexts.txt');

end;

procedure TDCS1.fillcp;
var i,k,j : dword;
    ct : cprec;
begin
   k := 0;
   setlength(cp1,0);

   for i := 1 to length(cp) do
   if cp[i].tid = gtid then
   begin
      inc(k);
      setlength(cp1,k);
      cp1[k-1] := cp[i];
   end;
   if k > 1 then
   for i := 0 to k - 1 do
   for j := 0 to k - 2 do
   if strtoint(cp1[j].ps)  > strtoint(cp1[j+1].ps) then
   begin
     ct := cp1[j]; cp1[j]:= cp1[j+1]; cp1[j+1] := ct;
   end;
   if length(cp1) > 0 then
   for i := 0 to length(cp1) - 1 do
   begin
      combobox2.Items.Add(cp1[i].cn+': ' + cp1[i].ps);

   end;

   if combobox2.items.Count > 0 then combobox2.ItemIndex:=0;
end;
procedure TDCS1.fillslk;
var i : longint;
    k : longint;
    l : lrec;
begin
   k := 0;
   setlength(lx1,0);
   listbox1.clear;
   for i := 1 to length(lx) do
   if lx[i].cid = gcid then
   begin
      inc(k);
      setlength(lx1,k);
      lx1[k-1] := lx[i];
      if lx1[k-1].st = '' then lx1[k-1].st := '0';
   end;
{
   for i := 0 to length(lx1) - 1 do
   for k := 0 to length(lx1) - 2 do
   if strtoint(lx1[k].st)  > strtoint(lx1[k+1].st) then
   begin
     l := lx1[k]; lx1[k]:= lx1[k+1]; lx1[k+1] := l;
   end;
}
   for i := 0 to length(lx1) - 1 do
   listbox1.items.Add(lx1[i].st + ' '+lx1[i].pd);
   if listbox1.items.Count > 0 then listbox1.ItemIndex:=0;

end;
function TDCS1.getosn(s : string) : string;
var x,z : dword;
    a : string;
begin
  a := '';

  if s <> '' then
  begin
  delete(s,pos(',',s),1);
  delete(s,pos(',',s),1);
    val(s,x,z);
    if (z = 0) and (x > 0) and (x <= length(o)) then
    begin
      a := o[x].stem;

    end;
  end;
  getosn := a;
end;
function TDCS1.GetGV(i,j,k : longint) : longint;
var s,s1,s2 : String;
begin
  s := combobox1.items[i];
  s1:= combobox2.items[j];
  s2:= listbox1.items[k];
  while pos('"',s) > 0 do delete(s,pos('"',s),1);
  s2 := copy(s2,1,pos(' ',s2)-1);

  for i := 0 to tts.StringGrid4.RowCount - 1 do
  if (s = tts.StringGrid4.Cells[0,i]) and
     (s1 = tts.StringGrid4.Cells[1,i]) and
     (s2 = tts.StringGrid4.Cells[2,i]) then
     break;
     CVerse := i;
     GetGV := i;
end;
procedure tdcs1.GetV1(i,j,k : longint);
var a : longint;
    s,s1 : string;
    z : longint;
begin
    s := '';
    s1 := '';
    for a := j to k do
    s := s + '!'+combobox2.Items[a]+'!';
    s1 := combobox1.Items[i];
    while pos('"',s1) > 0 do delete(s1,pos('"',s1),1);
    z := 0;
    Stringgrid2.RowCount:= tts.StringGrid4.RowCount;
    for a := 0 to tts.StringGrid4.RowCount - 1 do
    if tts.StringGrid4.Cells[0,a] = s1 then
    if pos('!'+tts.StringGrid4.Cells[1,a]+'!',s) > 0 then
    begin
      stringgrid2.Rows[z] := tts.StringGrid4.Rows[a];
      inc(z);
    end;
    Stringgrid2.RowCount:=z;
end;
procedure tdcs1.ChkLine(i : longint;g : boolean);
{
var s,s1,s2,s3,s4,s5,s6 : string;
    j,k,l,m,a : longint;
    c,v : word;
}
begin
{
  if g then
  begin
     s := tts.StringGrid4.Cells[3,i];
     s4:= tts.StringGrid4.Cells[0,i]+
          tts.StringGrid4.Cells[1,i]+
          tts.StringGrid4.Cells[2,i];
     end
     else
        begin
            s := stringgrid2.Cells[3,i] ;
            s4:= StringGrid2.Cells[0,i]+
                 StringGrid2.Cells[1,i]+
                 StringGrid2.Cells[2,i];

        end;
  l := getcm(s);

  v := 1;
  stringgrid1.RowCount:=9700;

  for j := 0 to tts.StringGrid4.RowCount - 1 do
  begin
    k := 0;
    s1 := tts.stringgrid4.cells[3,j];
    m := getcm(s1);
    if s4 <>
         tts.StringGrid4.Cells[0,j]+
         tts.StringGrid4.Cells[1,j]+
         tts.StringGrid4.Cells[2,j] then
    if (l > 2) and (abs(l - m) < 3) then
    begin
       delete(s1,1,1);
       s5 := s;
       while (s1 <> '') do
       begin
         s2 := copy(s1,1,pos(',',s1) - 1);
         delete(s1,1,pos(',',s1));
         if (pos(','+s2+',',s) > 0) and (s2 <> '')  then
         begin
            inc(k);
            Delete(s5,pos(','+s2+',',s5),length(','+s2));
         end
         else
         s6 := s2;
       end;
    if k > l -2 then
    begin
     s3 := tts.StringGrid4.Cells[0,j] + ' ' +
           tts.StringGrid4.Cells[1,j] + ' ' +
           tts.StringGrid4.Cells[2,j] ;

     stringgrid1.Cells[0,v] := s3;
     stringgrid1.Cells[1,v] := tts.StringGrid4.Cells[4,j];
     if l = k then
        stringgrid1.Cells[2,v] := 'GOOD'
     else
     begin
       stringgrid1.Cells[2,v] := 'PARTLY';
       if s5 <> '' then while pos(',',s5) > 0 do delete(s5,pos(',',s5),1);
       if s6 <> '' then while pos(',',s6) > 0 do delete(s6,pos(',',s6),1);
       if s5 <> '' then s5 := getosn(s5);
       if s6 <> '' then s6 := getosn(s6);


       stringgrid1.Cells[3,v] := '+ ' + s5 + ' - ' + s6;


     end;

     inc(v);
    end;

    end;
  end;
  stringgrid1.RowCount:=v;
}
end;
function Tdcs1.GetCM(s : string) : word;
var i : word;
begin
   i := 0;
   while pos(',',s) > 0 do
   begin
     delete(s,pos(',',s),1);
     inc(i)
   end;
   if s = '' then i := 0;
   if i > 1 then dec(i);
   getCM := i;

end;
function TDCS1.PSl(s : string; i : longint) : string;
var a : word;
    s2,s3 : string;
begin
    s3 := ''; a := 0;s2 :='';

    while pos('||',s) <> 0 do
    if s <> '' then
    if pos('|',s) < pos('||',s) then
    begin
     if s <> '' then
     begin
     inc(a);
     s2 := copy(s,1,pos('|',s));
     delete(s,1,pos('|',s));
     if s2 <> '' then
     s3 := s3 + stringgrid2.Cells[1,i] + ';'+
                stringgrid2.Cells[2,i] +' '+
                inttostr(a) +';'+s2+';'+#13+#10;

      end;
    end
    else
    if s <> '' then
    begin
      inc(a);
      s3 := s3 + stringgrid2.Cells[1,i] + ';'+
                stringgrid2.Cells[2,i] +' '+
                inttostr(a) +';'+s+';';
      s := '';
    end;
    PSl := s3;
end;
function Tdcs1.GetGr(i : string) : string;
var c : longint;
    s : string;
begin
  if i <> '' then
  begin
    c := strtoint(i);
    if c <= length(o) then
    begin
     s := o[c].gr;
    if (pos('Ā',s) > 0) or
       (pos('P',s) > 0)
         then s := 'v';
    GetGr := s;
  end
  else
    GetGr := '';


  end
  else
    GetGr := '';
end;
procedure Tdcs1.initGRA;
begin
    gra.adj:=0;
    gra.n:=0;
    gra.dj1:=0;
    gra.dj2:=0;
    gra.dn:=0;
    gra.ds:=0;
    gra.f:=0;
    gra.fn:=0;
    gra.ind:=0;
    gra.m:=0;
    gra.mf:=0;
    gra.mn:=0;
    gra.mnf:=0;
    gra.nr:=0;
    gra.pr:=0;
    gra.v:=0;
end;
procedure TDCS1.FillSTA;
var i,j,k,jj : longint;
    s,s1,s2,s3,s4,s5 : string;
    id,lx,st,p1,p2,vf,vi,op,cn,c,n,g : string;
begin
    if sta.listbox1.items.Count > 0 then
    begin
    for i := 0 to sta.listbox1.items.Count - 1 do
    begin
     j := stringGrid1.RowCount;
     stringGrid1.RowCount :=
     stringGrid1.RowCount + length(snt[strtoint(sta.listbox1.items[i])]);
     for k := 0 to length(snt[strtoint(sta.listbox1.items[i])]) - 1 do
     begin
       stringGrid1.cells[0,j+k] := getosn(snt[strtoint(sta.listbox1.items[i]),k].osn);
       stringGrid1.cells[1,j+k] := getGr(snt[strtoint(sta.listbox1.items[i]),k].osn);
       stringGrid1.cells[5,j+k] := (snt[strtoint(sta.listbox1.items[i]),k].osn);
       stringGrid1.cells[6,j+k] := (snt[strtoint(sta.listbox1.items[i]),k].p1);
       stringGrid1.cells[7,j+k] := (snt[strtoint(sta.listbox1.items[i]),k].p2);

     end;
    end;
      for i := 0 to sta.ListBox1.Items.Count - 1 do
      begin
         for j := 1 to listbox5.items.Count - 1 do
         begin
           s := listbox5.Items[j];
           if s <> '' then
           begin
             lx := copy(s,1,pos(',',s)-1);
             delete(s,1,pos(',',s));

             st := copy(s,1,pos(',',s)-1);
             delete(s,1,pos(',',s));

             p1 := copy(s,1,pos(',',s)-1);
             delete(s,1,pos(',',s));

             p2 := copy(s,1,pos(',',s)-1);
             delete(s,1,pos(',',s));

             vf := copy(s,1,pos(',',s)-1);
             delete(s,1,pos(',',s));

             vi := copy(s,1,pos(',',s)-1);
             delete(s,1,pos(',',s));

             op := copy(s,1,pos(',',s)-1);
             delete(s,1,pos(',',s));


             cn := copy(s,1,pos(',',s)-1);
             delete(s,1,pos(',',s));
             c := copy(s,1,pos(',',s)-1);
             delete(s,1,pos(',',s));

             n := copy(s,1,pos(',',s)-1);
             delete(s,1,pos(',',s));

             g := s;

             if st = sta.ListBox1.Items[i] then
             for k := 1 to StringGrid1.RowCount - 1 do
             if (lx = StringGrid1.Cells[5,k]) and
                (p1 = StringGrid1.Cells[6,k]) and
                (p2 = StringGrid1.Cells[7,k]) then
                begin
                 StringGrid1.Cells[2,k] := vf;
                 StringGrid1.Cells[3,k] := vi;
                 if vf+vi = '00' then
                 StringGrid1.Cells[4,k] := wr.GetCase(c)+' '+ wr.GetNum(n) + ' '+ wr.GetGender(g)
                 else
                 begin
                 s := '';s1 := '';s4 :=''; s5 := '';
                 if (stringgrid1.Cells[2,k] <> '0') then
                 begin
                 s1 := dcs1.listbox6.items[strtoint(Stringgrid1.Cells[2,k])];
                   delete(s1,1,pos(',',s1));
                   delete(s1,1,pos(',',s1));
                   s2 := copy(s1,1,pos(',',s1) - 1);
                   delete(s1,1,pos(',',s1));
                   s3 := copy(s1,1,pos(',',s1) - 1);
                   delete(s1,1,pos(',',s1));

                   s4 := copy(s1,1,pos(',',s1) - 1);
                   if s4 <> '' then
                   jj := strtoint(s4)
                   else jj :=0;
                   s5 := inttostr(jj mod 3);
                   if s5 = '0' then s5 := '3';
                   if jj in [1..3] then s4 := 'Sg.';
                   if jj in [4..6] then s4 := 'Du.';
                   if jj in [7..9] then s4 := 'Pl';
                   s := 'Finite: Form: ' + s2 +'; ' +
                        'Tense:' + wr.GetTense(s3) +'; Person: '+s4 +'; Number: '+ s5;
                     StringGrid1.Cells[4,k] := s;
                 end;
                 s2:='';     s3:='';     s4:='';     s5:='';
                 if (stringgrid1.Cells[3,k] <> '0') then
                 begin
                   s1 := dcs1.listbox7.items[strtoint(Stringgrid1.Cells[3,k])];
                   delete(s1,1,pos(',',s1));
                   delete(s1,1,pos(',',s1));
                   s2 := copy(s1,1,pos(',',s1) - 1);
                   delete(s1,1,pos(',',s1));
                   s3 := copy(s1,1,pos(',',s1) - 1);
                   delete(s1,1,pos(',',s1));
                   s4 := copy(s1,1,pos(',',s1) - 1);
                   delete(s1,1,pos(',',s1));
                   s5 := s1;
                   s := s + 'Infinite: Form: ' + s2 +'; Stem:' + s3 +
                        'Tense:' + wr.GetTense(s4);// +'; Noun Category: '+s5 +#13+#10;
                   StringGrid1.Cells[4,k] := s;
                 end;
                 end;

                end;



           end;

         end;
      end;
    end;
end;
function TDCS1.FindS(s : string; i,j : word) : string;
var c : word;
    a,x: string;
begin x := '';
  while pos(' ',s) > 0 do delete(s,pos(' ',s),1);
  for c := 0 to rk.StringGrid4.RowCount - 1 do
  begin
    a := rk.StringGrid4.Cells[1,c];
    if i = 0 then
      a := copy(a,1,pos('|',a) - 1)
    else
     begin
         delete(a,1,pos('| ',a)+1);
         a := copy(a,1,pos('|',a) - 1);
     end;
     while pos(' ',a) > 0 do delete(a,pos(' ',a),1);
     if CmpAS(a,s) > 97 then
     x := x + rk.StringGrid4.Cells[0,c] + ' #'+inttostr(i)+'#'+a+'#'+s;
    end;
   Finds := x;
end;
function TDcs1.cmpas(a,s : string) : word;
var d,x : word;
begin d := 1; x := 0;
   if a = s then cmpas := 100
   else
   if abs(length(s) - length(a)) < 5 then
   for  d  := 1 to length(s) do
   begin
     if pos(s[d],a) > 0 then inc(x);
   end;
   if d <> 0 then
   cmpas := round(x/d*100);
end;
function TDCS1.GetVerType(id : string; var cl : byte;var tp,vc : string) : string;
var i : integer;
    s,s1,s2 : string;
begin   s := '';
    tp := 'Verb'; cl := 0; vc := '';
    if (id <> '') and (id <> ' ') then
    begin
    s1 := o[strtoint(id)].gr;
    if pos('Denom',s1) > 0 then tp := 'Denom.';
    if pos('Desid',s1) > 0 then tp := 'Desid.';
    if pos('Int',s1) > 0 then tp := 'Int.';

      if pos('P.',s1) > 0 then vc := 'P.';
      if pos('Ā.',s1) > 0 then vc := 'Ā';
      if pos('10.',s1) > 0 then cl := 10
      else
      begin
        if s1[1] in ['1'..'9'] then cl := strtoint(s1[1]);
      end;


      s := tp + #9 + inttostr(cl) + #9 + vc
    end;
    GetVerType := s;
end;
procedure tdcs1.sgnt;
var i,j : dword;
begin j := 0;
   for i := 0 to stringgrid1.Columns.Count - 1 do
   if stringgrid1.Columns[i].Visible then inc(j,stringgrid1.Columns[i].Width);
   stringgrid1.Width:=j+32;
end;

end.

