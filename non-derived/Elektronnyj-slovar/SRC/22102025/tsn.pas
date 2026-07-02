unit TsN;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids, Menus,
  ExtCtrls, ComCtrls, HtmlView;

type

  { TSinta }

  TSinta = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    hw: THtmlViewer;
    ListBox1: TListBox;
    ListBox2: TListBox;
    MenuItem100: TMenuItem;
    MenuItem101: TMenuItem;
    MenuItem102: TMenuItem;
    MenuItem103: TMenuItem;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MenuItem100Click(Sender: TObject);
    procedure MenuItem101Click(Sender: TObject);
    procedure MenuItem102Click(Sender: TObject);
    procedure MenuItem103Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    function sort1(s : string) : string;
  private

  public
    procedure nulstg;
    procedure  GetSent(sid,st : string; var sl, sr,ss : string; var sd : longint; var TN : string);
  end;
//type
//stg1 = record
//           c : dword;
//           p : real;
//end;

//stg = record
//           id : dword;
//           l  : array[1..222342] of stg1;
//           R  : array[1..222342] of stg1;
//     end;
var
  Sinta: TSinta;

implementation
uses poisk, shellapi, sfo,tx1,sintagma1,clipbrd;
{$R *.lfm}
type
   st1 = record
     l : string;
     c : dword;
   end;

//var
//A :  stg;
//F : file of stg;
{ TSinta }

procedure TSinta.MenuItem2Click(Sender: TObject);
begin
  hide;
end;

procedure TSinta.StringGrid1Click(Sender: TObject);
var s : string;
begin  s := '';
  sf.findinfo(copy(
  stringgrid1.Cells[0,stringgrid1.Row],1,pos(' ',stringgrid1.Cells[0,stringgrid1.Row]) - 1)
  ,
  d[form1.GetletId(stringgrid1.Cells[0,stringgrid1.Row])].beg,
  d[form1.GetletId(stringgrid1.Cells[0,stringgrid1.Row])].ed,true,s);
    hw.loadfromstring(s);

end;

procedure TSinta.MenuItem1Click(Sender: TObject);
var f : system.text;
    s : string;
    i : word;
begin
    if savedialog1.Execute then
    begin
      system.assign(f,savedialog1.FileName);
      rewrite(f);
      s := caption;
      writeln(f,s);
      for i := 0 to stringgrid1.RowCount - 1 do
      writeln(f,stringgrid1.Cells[0,i],#9,stringgrid1.cells[1,i]);
      system.Close(f);
      if form1.CheckBox7.Checked then
        shellexecute(handle,'open',pchar(savedialog1.FileName),nil,nil,1);
    end;
end;

procedure TSinta.Button1Click(Sender: TObject);
begin
  MenuItem1Click(Sender);
end;

procedure TSinta.Button2Click(Sender: TObject);
var s,s1,s2,s3,s4,s5,ss,SR,SL : string;  i,j,k,l,r,q,w,e : dword;
    F : text;
    sd : longint;
    TN : String;
    Gl,GR, GAll,
    t1l,t1r,t1a,
    t2l,t2r,t2a,
    t3l,t3r,t3a,
    t4l,t4r,t4a,
    t5l,t5r,t5a,
    t6l,t6r,t6a,
    t7l,t7r,t7a,
    t8l,t8r,t8a : string;


begin

//Syntagmatic Table count!
    assignfile(F,'_____.csv');
    rewrite(f);
    application.Minimize;
    for i := 1 to length(o) do
    if o[i].stem <> '' then
    if (o[i].gr <> 'ind') and (o[i].gr <> 'pron') then
    begin
       Application.Title := inttostr(i);
       s := dcs1.ListBox4.Items[i];
       Gall := '';
       Gl := '';GR := '';
       t1a :=''; t1l := '';t1r := '';
       t2a :=''; t2l := '';t2r := '';
       t3a :=''; t3l := '';t3r := '';
       t4a :=''; t4l := '';t4r := '';
       t5a :=''; t5l := '';t5r := '';
       t6a :=''; t6l := '';t6r := '';
       t7a :=''; t7l := '';t7r := '';
       t8a :=''; t8l := '';t8r := '';

       while s <> '' do
       begin
          s1 := copy(s,1,pos(' ',s)-1); delete(s,1,pos(' ',s));
          GetSent(s1,inttostr(i),sl, sr,ss,sd,tn);

          gall := gall+ss;
          gl := gl+sl;
          gr := gr + sr;
          if sd <= -800 then
          begin
            t1a := t1a + ss;
            t1l := t1l + sl;
            t1r := t1r + sr;
          end;
          if (sd >= -800) and  (sd <= -300) then
          begin
            t2a := t2a + ss;
            t2l := t2l + sl;
            t2r := t2r + sr;
          end;
          if (sd >= -300) and  (sd <=200) then
          begin
            t3a := t3a + ss;
            t3l := t3l + sl;
            t3r := t3r + sr;
          end;
          if (sd >= 200) and  (sd <=700) then
          begin
            t4a := t4a + ss;
            t4l := t4l + sl;
            t4r := t4r + sr;
          end;
          if (sd >= 700) and  (sd <=1200) then
          begin
            t5a := t5a + ss;
            t5l := t5l + sl;
            t5r := t5r + sr;
          end;
          if (sd >= 1200) and  (sd <=1700) then
          begin
            t6a := t6a + ss;
            t6l := t6l + sl;
            t6r := t6r + sr;
          end;
          if (sd >= 1700) and  (sd <=2000) then
          begin
            t7a := t7a + ss;
            t7l := t7l + sl;
            t7r := t7r + sr;
          end;
          if (sd = 2500)  then
          begin
            t8a := t8a + ss;
            t8l := t8l + sl;
            t8r := t8r + sr;
          end;





       end;
       if gall <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'A',#9,sort1(gall));
       if gl <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'L',#9,sort1(gl));
       if gr <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'R',#9,sort1(gR));
//1

       if t1a <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'<-800A',#9,sort1(t1a));
       if t1l <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'<-800L',#9,sort1(t1l));
       if t1r <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'<-800R',#9,sort1(t1r));
//2
       if t2a <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'-800_-300A',#9,sort1(t2a));
       if t2l <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'-800_-300L',#9,sort1(t2l));
       if t2r <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'-800_-300R',#9,sort1(t2r));
//3
       if t3a <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'-300_200A',#9,sort1(t3a));
       if t3l <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'-300_200L',#9,sort1(t3l));
       if t3r <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'-300_200R',#9,sort1(t3r));
//4
       if t4a <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'200-700A',#9,sort1(t4a));
       if t4l <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'200-700L',#9,sort1(t4l));
       if t4r <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'200-700R',#9,sort1(t4r));
//5
       if t5a <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'700-1200A',#9,sort1(t5a));
       if t5l <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'700-1200L',#9,sort1(t5l));
       if t5r <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'700-1200R',#9,sort1(t5r));
//6
       if t6a <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'1200-1700A',#9,sort1(t6a));
       if t6l <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'1200-1700L',#9,sort1(t6l));
       if t6r <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'1200-1700R',#9,sort1(t6r));
//7
       if t7a <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'1700-2000A',#9,sort1(t7a));
       if t7l <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'1700-2000L',#9,sort1(t7l));
       if t7r <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'1700-2000R',#9,sort1(t7r));
//8
       if t8a <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'NoDateA',#9,sort1(t8a));
       if t8l <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'NoDateL',#9,sort1(t8l));
       if t8r <> '' then
       writeln(f,i,#9,form1.convertd(o[i].stem),#9,o[i].stem,#9,'NoDateR',#9,sort1(t8r));



       gall := '';gl := '';gr := '';
       t1a :=''; t1l := '';t1r := '';
       t2a :=''; t2l := '';t2r := '';
       t3a :=''; t3l := '';t3r := '';
       t4a :=''; t4l := '';t4r := '';
       t5a :=''; t5l := '';t5r := '';
       t6a :=''; t6l := '';t6r := '';
       t7a :=''; t7l := '';t7r := '';
       t8a :=''; t8l := '';t8r := '';

    end;


    closefile(f);
    showmessage('');

end;

procedure TSinta.ComboBox1Change(Sender: TObject);
var i,j,k,l : dword; s,s1 : string;
    A : Array of st1;
    z : st1;
begin
  stringgrid1.Clear;
  stringgrid1.RowCount:=1;
  j := 1; k := 0; l := 1;
  for i := 0 to sintagma.stringGrid1.RowCount - 1 do
  if (listbox1.Items[combobox1.ItemIndex]=sintagma.Stringgrid1.cells[0,i]) and
  (sintagma.StringGrid1.Cells[3,i] = combobox2.Text)
  then
  begin

    j := j + strtoint(sintagma.Stringgrid1.cells[4,i]);
    stringgrid1.RowCount:=j;
    s := sintagma.MEMO1.lines.strings[strtoint(
    sintagma.StringGrid1.Cells[6,i])];
    Delete(s,1,pos(' ',s));
    Delete(s,1,pos(' ',s));
    Delete(s,1,pos(' ',s));
    Delete(s,1,pos(' ',s));
    Delete(s,1,pos(' ',s));
    Delete(s,1,pos(' ',s));
    while s  <> '' do
    begin
      stringgrid1.Cells[0,l] := o[strtoint(copy(s,1,pos(#32,s)-1))].stem +' '+
      o[strtoint(copy(s,1,pos(#32,s)-1))].gr;
      stringgrid1.Cells[2,l] := copy(s,1,pos(#32,s)-1);
      delete(s,1,pos(#32,s));
      stringgrid1.Cells[1,l] := copy(s,1,pos(#32,s)-1);
      delete(s,1,pos(#32,s));
      inc(k,strtoint(stringgrid1.Cells[1,l]));
      inc(l);
    end;
  end;
     statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount-1);
     statusbar1.Panels[3].Text:=inttostr(k);


end;

procedure TSinta.ComboBox2Change(Sender: TObject);
begin
  combobox1change(sender);
end;

procedure TSinta.FormActivate(Sender: TObject);
begin
  hw.Font := form1.Memo1.Font;
  hw.DefFontName:= form1.Memo1.Font.Name;
end;

procedure TSinta.MenuItem100Click(Sender: TObject);
begin
  hw.CopyToClipboard;
end;

procedure TSinta.MenuItem101Click(Sender: TObject);
begin
  hw.SelectAll;
end;

procedure TSinta.MenuItem102Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.google.com/?sl=auto&tl=ru&text='+s+'&op=translate')
  ,nil,nil,1);


end;

procedure TSinta.MenuItem103Click(Sender: TObject);
  var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.google.com/?sl=auto&tl=ru&text='+s+'&op=translate')
  ,nil,nil,1);

end;



procedure tsinta.nulstg;
//var i : dword;
begin
{    a.id:=0;
    for i := 1 to length(A.l) do
    begin
      a.l[i].p:=0; a.l[i].c:=0;
      a.R[i].p:=0;a.r[i].c:=0;
    end;
}
end;
procedure  tsinta.GetSent(sid,st : string; var sl, sr,ss : string; var sd : longint; var TN : string);
var i,j,k,l,q,w,e : longint;
    x1,s2,s3 : string;
begin
  j := strtoint(sid);
  x1 := dcs1.ListBox5.Items[j];
  listbox2.Clear;
  delete(x1,1,pos(',',x1));
  x1 := copy(x1,1,pos(',',x1)-1);
  j := strtoint(x1);
  for i := 0 to length(snt[j]) -1 do
  if st = snt[j,i].osn then listbox2.Items.Add(inttostr(i));
  sL := '';sR := '';ss := '';
  if listbox2.Items.Count > 0 then
  for l := 0 to listbox2.Items.Count - 1 do
  begin
     k := strtoint(listbox2.Items[l]);
     if k > 0 then
     for q := k-1 downto 0 do
     if strtoint(snt[j,q].osn) <= length(o) then
     begin
       if (o[strtoint(snt[j,q].osn)].gr <> 'ind') and
          (o[strtoint(snt[j,q].osn)].gr <> 'nr') and
          (o[strtoint(snt[j,q].osn)].gr <> 'pron') then
          begin
             sl := sl + snt[j,q].osn + ' ';
             break;
          end;
       end;
       if k < length(snt[j])-1 then
       for q := k+1 to length(snt[j])-1 do
       if strtoint(snt[j,q].osn) <= length(o) then
       begin
         if (o[strtoint(snt[j,q].osn)].gr <> 'ind') and
            (o[strtoint(snt[j,q].osn)].gr <> 'nr') and
            (o[strtoint(snt[j,q].osn)].gr <> 'pron') then
            begin
               sr := sr + snt[j,q].osn + ' ';
               break;
            end;
      end;
     end;
     I := STRTOINT(
     cp[strtoint(lx[j].cid)].d1);
     k := STRTOINT(
     cp[strtoint(lx[j].cid)].d2);
     sd := (i + k) div 2;
     tn := tx[strtoint(cp[strtoint(lx[j].cid)].tid)].id;
  ss := sl + sr;
//  if sd < -800 then showmessage('');


end;
function Tsinta.sort1(s : string) : string;
type rec1 = record
     l : string;
     c : dword;
     end;
var A : Array[1..15000] of rec1; a1:rec1;
    s1,s2 : string;
    i,j,k : dword;
begin j := 1;s2 := ' ';
    s1 := '';s2 := ' ';
    while s <> '' do
    begin
      s1:= copy(s,1,pos(' ',s)-1);delete(s,1,pos(' ',s));
      if pos (' '+s1+' ',s2) = 0 then
      begin
        s2 := s2 + s1+' ';
        a[j].l:= s1;a[j].c:=1;
        inc(j);
      end
      else
      begin
        for i := 1 to j-1 do
        if s1 = a[i].l then
        begin
          inc(a[i].c); break;
        end;
      end;
    end;
    if j > 2 then
    for i := 1 to j -1 do
    for k := 1 to j - 2 do
    if a[k].c < a[k+1].c then
    begin
      a1 := a[k]; a[k] := a[k+1];a[k+1]:=a1;
    end;
    s := '';
    k := 0;
    for i := 1 to j -1 do inc(k,a[i].c);
    s := inttostr(j-1)+#9+inttostr(k)+#9;
    for i := 1 to j - 1 do
    s := s + a[i].l+ #9+inttostr(a[i].c)+#9;



    sort1 := s;
end;

end.

