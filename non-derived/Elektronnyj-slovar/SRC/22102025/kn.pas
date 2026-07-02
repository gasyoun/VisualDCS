unit kn;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Grids, Menus, ExtDlgs, HtmlView, TAGraph, TASources, TATools,
  TASeries, TALegendPanel, TACustomSource;

type

  { Tkkn }

  Tkkn = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button400: TButton;
    Button5: TButton;
    Chart1: TChart;
    Chart1BarSeries1: TBarSeries;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Chart1LineSeries3: TLineSeries;
    Chart1LineSeries4: TLineSeries;
    Chart1LineSeries5: TLineSeries;
    Chart1LineSeries6: TLineSeries;
    Chart1PieSeries1: TPieSeries;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox_: TComboBox;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    hw: THtmlViewer;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    ls3: TListChartSource;
    ls1: TListChartSource;
    ls2: TListChartSource;
    ls4: TListChartSource;
    ls5: TListChartSource;
    ls6: TListChartSource;
    ls7: TListChartSource;
    ls8: TListChartSource;
    ls9: TListChartSource;
    Memo2: TMemo;
    Memo3: TMemo;
    MenuItem1: TMenuItem;
    MenuItem111: TMenuItem;
    MenuItem110: TMenuItem;
    Separator3: TMenuItem;
    MenuItem210: TMenuItem;
    MenuItem202: TMenuItem;
    MenuItem201: TMenuItem;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    SavePictureDialog1: TSavePictureDialog;
    Separator2: TMenuItem;
    MenuItem200: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Separator1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    UpDown1: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button400Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox_Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    function ls3Compare(AItem1, AItem2: Pointer): Integer;
    procedure MenuItem110Click(Sender: TObject);
    procedure MenuItem111Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem200Click(Sender: TObject);
    procedure MenuItem201Click(Sender: TObject);
    procedure MenuItem202Click(Sender: TObject);
    procedure MenuItem210Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
  private

  public
    procedure fillg(i : byte);
    procedure fillg2;
    function ch1(s : string) : boolean;
    procedure fillsinta(f: string; i : word);
    Function ConvertX(s : string) : string;
    function Gm(s : string; i : byte) : string;
    procedure getsinvec(i : longint);
    function  cmpvec(j : byte) : string;
    Function fillvec(v : byte) : string;
    function getG(stem,g : string) : boolean;
    procedure BGraph;
    procedure selg(c : char;z : boolean);
    procedure GetFate;
    procedure Getintersec;
  end;
gg = record
   frq : longint;
   stm : string;
   g   : string;
   end;
var
  kkn: Tkkn;
  gv : array[1..9457]  of gg;
  gn : array[1..79405] of gg;
  vr : array[1..9131] of string;
implementation
uses dmk1,ched1,trwin,shellapi,clipbrd,sfo,poisk,FSt,tsn,sintagma1;
const
  lm : array[0..9] of word =
    (7532,13438,7855,33057,29325,37035,23980,5567,21206,440);
  var sgt : string = '';

      sgt2 : longint;
      ddd4 : boolean = false;
{$R *.lfm}

{ Tkkn }

procedure Tkkn.Button1Click(Sender: TObject);
var Button: TUDBtnType;
begin
  updown1.Position:=10;
  updown1click(sender,button);
end;

procedure Tkkn.Button2Click(Sender: TObject);
var Button: TUDBtnType;
begin
  updown1.Position:=80;
  updown1click(sender,button);
end;

procedure Tkkn.Button3Click(Sender: TObject);
var k1,k2 : tstringgrid;
begin
  case combobox1.ItemIndex of
       1 : k1 := dmk.StringGrid1;
       0 : k1 := dmk.StringGrid0;
       9 : k1 := dmk.StringGrid9;
       2 : k1 := dmk.StringGrid2;
       3 : k1 := dmk.StringGrid3;
       4 : k1 := dmk.StringGrid4;
       5 : k1 := dmk.StringGrid5;
       6 : k1 := dmk.StringGrid6;
       7 : k1 := dmk.StringGrid7;
       8 : k1 := dmk.StringGrid8;


  end;
  case combobox_.ItemIndex of
       1 : k2 := dmk.StringGrid1;
       2 : k2 := dmk.StringGrid2;
       3 : k2 := dmk.StringGrid3;
       4 : k2 := dmk.StringGrid4;
       5 : k2 := dmk.StringGrid5;
       6 : k2 := dmk.StringGrid6;
       7 : k2 := dmk.StringGrid7;
       8 : k2 := dmk.StringGrid8;

  end;
  chd.Caption:='Пересечение ядер "'+combobox1.Text+'" и "'+combobox_.Text+'"';
  chd.Show;
  chd.StringGrid1.SelectedColor:=stringgrid1.SelectedColor;
  chd.StringGrid2.SelectedColor:=stringgrid1.SelectedColor;
  chd.StringGrid3.SelectedColor:=stringgrid1.SelectedColor;
  chd.chedx(k1,k2);
end;

procedure Tkkn.Button400Click(Sender: TObject);
begin
 GetIntersec;
end;

procedure Tkkn.Button4Click(Sender: TObject);
var i,j,q,w,e,r,t,y,u,o : word;
    mf : real;
    z : byte;
    s : string;
begin
  q := 0; w := 0; e := 0; r := 0;
  t := 0; y := 0; u := 0; o := 0;

  chd.StringGrid1.Clear;
  chd.StringGrid2.Clear;
  chd.StringGrid3.Clear;

  with dmk do
  for i := 0 to dmk.StringGrid0.RowCount - 1 do
  begin
    mf := 0; z := 0;
    for j := 0 to stringgrid1.RowCount - 1 do
    if (stringgrid0.Cells[0,i] = stringgrid1.Cells[0,j]) and
       (stringgrid0.Cells[1,i] = stringgrid1.Cells[1,j]) then
       begin
         inc(z);
//         mf := mf + strtofloat(stringgrid1.Cells[2,j]);
         q := j + 1;
         break;
       end;

    for j := 0 to stringgrid2.RowCount - 1 do
    if (stringgrid0.Cells[0,i] = stringgrid2.Cells[0,j]) and
       (stringgrid0.Cells[1,i] = stringgrid2.Cells[1,j]) then
       begin
         inc(z);
//         mf := mf + strtofloat(stringgrid2.Cells[2,j]);
         w := j + 1;
         break;
       end;

    for j := 0 to stringgrid3.RowCount - 1 do
    if (stringgrid0.Cells[0,i] = stringgrid3.Cells[0,j]) and
       (stringgrid0.Cells[1,i] = stringgrid3.Cells[1,j]) then
       begin
         inc(z);
//         mf := mf + strtofloat(stringgrid3.Cells[2,j]);
         e := j + 1;
         break;
       end;
    for j := 0 to stringgrid4.RowCount - 1 do
    if (stringgrid0.Cells[0,i] = stringgrid4.Cells[0,j]) and
       (stringgrid0.Cells[1,i] = stringgrid4.Cells[1,j]) then
       begin
         inc(z);
//         mf := mf + strtofloat(stringgrid4.Cells[2,j]);
         r := j + 1;
         break;
       end;

    for j := 0 to stringgrid5.RowCount - 1 do
    if (stringgrid0.Cells[0,i] = stringgrid5.Cells[0,j]) and
       (stringgrid0.Cells[1,i] = stringgrid5.Cells[1,j]) then
       begin
         inc(z);
//         mf := mf + strtofloat(stringgrid5.Cells[2,j]);
         t := j + 1;
         break;
       end;

    for j := 0 to stringgrid6.RowCount - 1 do
    if (stringgrid0.Cells[0,i] = stringgrid6.Cells[0,j]) and
       (stringgrid0.Cells[1,i] = stringgrid6.Cells[1,j]) then
       begin
         inc(z);
//         mf := mf + strtofloat(stringgrid6.Cells[2,j]);
         y := j + 1;
         break;
       end;

    for j := 0 to stringgrid7.RowCount - 1 do
    if (stringgrid0.Cells[0,i] = stringgrid7.Cells[0,j]) and
       (stringgrid0.Cells[1,i] = stringgrid7.Cells[1,j]) then
       begin
         inc(z);
//         mf := mf + strtofloat(stringgrid7.Cells[2,j]);
         u := j + 1;
         break;
       end;
    for j := 0 to stringgrid8.RowCount - 1 do
    if (stringgrid0.Cells[0,i] = stringgrid8.Cells[0,j]) and
       (stringgrid0.Cells[1,i] = stringgrid8.Cells[1,j]) then
       begin
         inc(z);
         mf := mf + strtofloat(stringgrid8.Cells[2,j]);
         o := j + 1;
         break;
       end;
       if z = 8 then
          begin
            mf := (q + w+e+r+t+y+u+o)/8;
            str(mf:4:2,s);
//            kkn.Memo1.Lines.Add(stringgrid0.Cells[0,i]+';'+stringgrid0.Cells[1,i]+';'+s);

          end;

  end;

  Showmessage('Готово');
end;

procedure Tkkn.Button5Click(Sender: TObject);
var i,j,k : word;
    f : text;
    s,s1,s2 : string;
begin
{
     k := stringgrid1.Row;
     combobox1Change(sender);
     stringgrid1.Row:=k;
     s := '';
     for i := 0 to memo1.Lines.Count - 1 do
     begin
        s := s + memo1.Lines.strings[i] +#13+#10;
     end;
     stringgrid1.Row:=k;
     stringgrid1click(sender);
     memo1.Text := s + memo1.Text;
     memo1.Lines.SaveToFile('Reports\'+combobox1.Text+'.txt');
     stringgrid1.SaveToCSVFile('Reports\Lemma_'+combobox1.Text+'.txt',#9);
     stringgrid2.SaveToCSVFile('Reports\sint_'+stringgrid1.Cells[2,k]+'.txt',#9);
     Showmessage('The data saved to the folder  "Reports"')

}
end;

procedure Tkkn.Button6Click(Sender: TObject);
var i,j,k : longint;
    s,s1,s2 : string;
    f : text;
    z : boolean;
begin
    assignfile(f,'_.txt');
    rewrite(f);
    for i := 0 to stringgrid1.RowCount - 1 do
    begin s := stringgrid1.Cells[2,i]+';';z := false;
          s1 := stringgrid1.Cells[2,i];
          s2 := stringgrid1.Cells[3,i];
    with dmk do
    begin
      for j := 0 to stringgrid1.RowCount-1 do
      if  (s1 = stringgrid1.Cells[0,j]) and (s2 = stringgrid1.Cells[1,j])
         then z:= true;
      if z then s := s + '1;' else s := s + '0;';
      z := false;


      for j := 0 to stringgrid2.RowCount-1 do
      if  (s1 = stringgrid2.Cells[0,j]) and (s2 = stringgrid2.Cells[1,j])
         then z:= true;
      if z then s := s + '1;' else s := s + '0;';
      z := false;

      for j := 0 to stringgrid3.RowCount-1 do
      if  (s1 = stringgrid3.Cells[0,j]) and (s2 = stringgrid3.Cells[1,j])
         then z:= true;
      if z then s := s + '1;' else s := s + '0;';
      z := false;

      for j := 0 to stringgrid4.RowCount-1 do
      if  (s1 = stringgrid4.Cells[0,j]) and (s2 = stringgrid4.Cells[1,j])
         then z:= true;
      if z then s := s + '1;' else s := s + '0;';
      z := false;

      for j := 0 to stringgrid5.RowCount-1 do
      if  (s1 = stringgrid5.Cells[0,j]) and (s2 = stringgrid5.Cells[1,j])
         then z:= true;
      if z then s := s + '1;' else s := s + '0;';
      z := false;

      for j := 0 to stringgrid6.RowCount-1 do
      if  (s1 = stringgrid6.Cells[0,j]) and (s2 = stringgrid6.Cells[1,j])
         then z:= true;
      if z then s := s + '1;' else s := s + '0;';
      z := false;

      for j := 0 to stringgrid7.RowCount-1 do
      if  (s1 = stringgrid7.Cells[0,j]) and (s2 = stringgrid7.Cells[1,j])
         then z:= true;
      if z then s := s + '1;' else s := s + '0;';
      z := false;

      for j := 0 to stringgrid8.RowCount-1 do
      if  (s1 = stringgrid8.Cells[0,j]) and (s2 = stringgrid8.Cells[1,j])
         then z:= true;
      if z then s := s + '1;' else s := s + '0;';
      z := false;

    end;
    writeln(f,s);
    end;
    closefile(f);
end;

procedure Tkkn.Button7Click(Sender: TObject);
var f : text;
    i : longint;
    j : byte;
    s : string;
begin  assignfile(f,'12345.txt');
       rewrite(f);
  for j := 1 to 8 do
  begin
    memo3.Lines.LoadFromFile('sys\sintagma\'+inttostr(j));


  for i := 0 to memo3.Lines.Count - 1 do
  begin
    s := memo3.Lines.Strings[i];
    getsinvec(i);
    writeln(f,copy(s,1,pos(';',s)),cmpvec(j));
  end;
  end;

  closefile(f);
  showmessage('');
end;

procedure Tkkn.ComboBox1Change(Sender: TObject);
var i : dword;
begin
 if ddd4 then
 if combobox1.ItemIndex in [0..9] then
 fillg(combobox1.ItemIndex);
 for i := 1 to stringgrid1.RowCount - 1 do
 stringgrid1.Cells[6,i] := '0';
end;

procedure Tkkn.ComboBox2Change(Sender: TObject);
begin
  combobox1change(sender);
end;

procedure Tkkn.ComboBox_Change(Sender: TObject);
begin
  if combobox_.ItemIndex=0 then
     combobox_.ItemIndex := 1;
end;

procedure Tkkn.Edit1Change(Sender: TObject);
var i,j : word;
    s : string;
    s1: string;
begin
 s := convertX(edit1.Text);
  if s <> '' then
  begin s1 := '';

  for i := 0 to stringgrid1.RowCount - 1 do
      if s[1] <> '-' then
      begin
        if pos(s,stringgrid1.Cells[2,i]) = 1 then
        begin
          stringgrid1.Row:=i;
          edit1.SelStart:=length(s);
          break;
      end;

  Edit1.Text:=s;

  end
  else
  begin
    if pos(copy(s,2,length(s)-1)+' ',stringgrid1.Cells[2,i]+' ') > 0 then
    s1 := s1 + stringgrid1.Cells[2,i] + #9+ stringgrid1.Cells[3,i] +#9+stringgrid1.Cells[4,i] +#13+#10;
  end;
  edit1.SetFocus;
  if s1 <> '' then
//  Showmessage(s1);
  clipboard.AsText:= s1;
  end;

end;

procedure Tkkn.FormActivate(Sender: TObject);
begin
 hw.Font := form1.Memo1.Font;
 hw.DefFontName:= form1.Memo1.Font.Name;
end;

procedure Tkkn.FormCreate(Sender: TObject);
var i : byte;
    j : longint;
    f : text; s : string;s1 : string;
begin
  dmk1.dmk :=tdmk.Create(self);
//  dmk.FormCreate(sender);;
  ched1.chd :=tchd.Create(self);

   assignfile(f,'sys\dcs\8v.csv'); reset(f);
   for j := 1 to length(gv) do
   begin
    readln(f,s);
    s1 := copy(s,1,pos(#9,s)-1); delete(s,1,pos(#9,s));
    gv[j].frq:= strtoint(s1);
        s1 := copy(s,1,pos(#9,s)-1); delete(s,1,pos(#9,s));
        gv[j].stm:=s1;
        gv[j].g:=s;

   end;
   closefile(f);
   assignfile(f,'sys\dcs\8n.csv'); reset(f);
   for j := 1 to length(gn) do
   begin
    readln(f,s); s1 := copy(s,1,pos(#9,s)-1); delete(s,1,pos(#9,s));
    gn[j].frq:= strtoint(s1);
        s1 := copy(s,1,pos(#9,s)-1); delete(s,1,pos(#9,s));
        gn[j].stm:=s1;
        gn[j].g:=s;
   end;
   closefile(f);
   for i := 0 to 15 do
         if i mod 2 = 0 then
         stringgrid2.columns[i].Title.Caption  := 'Cr. ' + inttostr(i div 2 + 1)
         else
           stringgrid2.columns[i].Title.Caption  := 'Count';
  memo3.Lines.LoadFromFile('sys\sintagma\1');
  ddd4 := true;
end;

procedure Tkkn.FormResize(Sender: TObject);
begin
  hw.Left:=1;hw.Top:=1;hw.Height:=groupbox2.Height-2;
  hw.Width:=groupbox2.Width-2;
end;

function Tkkn.ls3Compare(AItem1, AItem2: Pointer): Integer;
begin

end;

procedure Tkkn.MenuItem110Click(Sender: TObject);
begin
  chart1.CopyToClipboardBitmap;
end;

procedure Tkkn.MenuItem111Click(Sender: TObject);
begin
  if savepicturedialog1.Execute then
  chart1.SaveToBitmapFile(savepicturedialog1.FileName);
end;

procedure Tkkn.MenuItem1Click(Sender: TObject);
begin
  GetFate;
  chart1.Legend.Visible:=true;
end;

procedure Tkkn.MenuItem200Click(Sender: TObject);
var i : dword;s : string;
begin
  IF STRINGGRID1.Row > 0 THEN
  begin
  fsinta.Show;
  fsinta.StringGrid1.RowCount:=stringgrid2.RowCount+2;
  for i := 2 to stringgrid2.RowCount - 1 do
  fsinta.StringGrid1.Rows[i] := stringgrid2.Rows[i];
  for i := 0 to fsinta.StringGrid1.ColCount - 1 do
  if i mod 2 = 0 then
  begin
     fsinta.StringGrid1.Cells[i,0] := 'Ядро№ '+inttostr(i div 2 +1);
     fsinta.StringGrid1.Cells[i,1] := 'Лемма';
  end
  else
  begin
    fsinta.StringGrid1.Cells[i,0] := '';
    fsinta.StringGrid1.Cells[i,1] := 'Сочетаний';

  end;

  s := stringgrid2.Cells[0,1] + '; ' + stringgrid2.Cells[1,1];
  fsinta.StatusBar1.Panels[0].Text := s;
  s := stringgrid2.Cells[2,1] + '; ' + stringgrid2.Cells[3,1];
  fsinta.StatusBar1.Panels[1].Text := s;
  s := stringgrid2.Cells[4,1] + '; ' + stringgrid2.Cells[5,1];
  fsinta.StatusBar1.Panels[2].Text := s;

  s := stringgrid2.Cells[6,1] + '; ' + stringgrid2.Cells[7,1];
  fsinta.StatusBar1.Panels[3].Text := s;
  s := stringgrid2.Cells[8,1] + '; ' + stringgrid2.Cells[9,1];
  fsinta.StatusBar1.Panels[4].Text := s;

  s := stringgrid2.Cells[10,1] + '; ' + stringgrid2.Cells[11,1];
  fsinta.StatusBar1.Panels[5].Text := s;

  s := stringgrid2.Cells[12,1] + '; ' + stringgrid2.Cells[13,1];
  fsinta.StatusBar1.Panels[6].Text := s;

fsinta.Caption:='Сочетаемость слова "'+ stringgrid1.Cells[2,stringgrid1.Row]+'" '+
'в различных исторических периодах';
  end;
end;

procedure Tkkn.MenuItem201Click(Sender: TObject);
begin
  hw.CopyToClipboard;
end;

procedure Tkkn.MenuItem202Click(Sender: TObject);
begin
  hw.SelectAll;
end;

procedure Tkkn.MenuItem210Click(Sender: TObject);
begin
 if stringgrid1.Row > 0 then
 begin
   sintagma.Show;
   sintagma.WindowState:=wsnormal;
   sintagma.Edit1.Text:= stringgrid1.Cells[2,stringgrid1.Row];
   sintagma.Button3Click(sender);
 end;

end;

procedure Tkkn.MenuItem2Click(Sender: TObject);
var i,j,k : longint;
    s : string;
    s1: string;
    z : boolean;
    F : text;
begin
  application.Minimize;
  assignfile(f,memo3.lines.Strings[0]);
  rewrite(f);
//  for k := 1 to stringgrid1.RowCount - 1 do
for k := strtoint(memo3.Lines.Strings[1]) to strtoint(memo3.Lines.Strings[2]) do
  begin
   stringgrid1.Row:=k;
   s := '';
   j := stringgrid1.Row;;
   for i := 0 to 6 do
   begin
     s := s + fillvec(i) + #13+#10;
     stringgrid1.Row:=j;
   end;
   Writeln(f,s);


   s := '';
  end;
  closefile(f);
end;

procedure Tkkn.MenuItem3Click(Sender: TObject);
var s : string;
begin
  if stringgrid1.Row > 0 then
  begin
    s := form1.GetLxID(stringgrid1.Cells[2,stringgrid1.Row]);
    if s <> '' then
    begin
       form1.GetSinta(s,true);
       if sinta.caption <> '' then
          Sinta.Show;

    end;
  end;
end;

procedure Tkkn.MenuItem4Click(Sender: TObject);
begin
  SelG('1',true);
end;

procedure Tkkn.MenuItem5Click(Sender: TObject);
begin
  SelG('0',false);
end;

procedure Tkkn.MenuItem6Click(Sender: TObject);
begin
  SelG('0',true);
end;

procedure Tkkn.MenuItem7Click(Sender: TObject);
begin
 ls4.Clear;
 GetIntersec;
 chart1.Legend.Visible:=false;
 chart1.title.TEXT.Text := 'Лексика ядра "'+combobox1.Items[combobox1.ItemIndex]+'" в других ядрах';
end;

procedure Tkkn.MenuItem8Click(Sender: TObject);
begin
   CHART1.Legend.Visible:=FALSE;

   ls1.Clear;ls2.Clear;
   ls3.Clear;ls4.Clear;
   ls5.Clear;ls6.Clear;
   ls7.Clear;ls8.Clear;
   ls9.Clear;
   Chart1.Title.Text.Text:='Сравнение размеров лексических ядер';
   ls4.clear;
   ls4.Add(1,dmk.StringGrid1.RowCount,combobox1.Items[1]);
   ls4.Add(2,dmk.StringGrid2.RowCount,combobox1.Items[2]);
   ls4.Add(3,dmk.StringGrid3.RowCount,combobox1.Items[3]);
   ls4.Add(4,dmk.StringGrid4.RowCount,combobox1.Items[4]);
   ls4.Add(5,dmk.StringGrid5.RowCount,combobox1.Items[5]);
   ls4.Add(6,dmk.StringGrid6.RowCount,combobox1.Items[6]);
   ls4.Add(7,dmk.StringGrid7.RowCount,combobox1.Items[7]);
   chart1.AxisList[0].marks.Source := ls1;
   chart1.AxisList[0].marks.Range.Max := 100;
   chart1.AxisList[0].Title.Caption:='';

end;

procedure Tkkn.MenuItem9Click(Sender: TObject);
begin

end;

procedure Tkkn.Panel1Click(Sender: TObject);
var i,j, k,c: dword;
    s : string;
    f : text; A : Array[1..49] of string;
begin
 EXIT;
 assignfile(f,'input\e.txt');reset(f);
  for i := 1 to 49 do readln(f,A[i]);

  for j := 0 to combobox1.Items.Count - 1 do
  begin
    stringgrid3.Clear;
    stringgrid3.RowCount:=8000;stringgrid3.ColCount:=49*3;
    combobox1.ItemIndex:=j;
    combobox1change(sender);

  for i := 1 to 49 do
  begin
    stringgrid3.Cells[i*3-3,0] := combobox1.Text;

    c := 2;
    for k := 1 to stringgrid1.RowCount - 1 do
    if pos(A[i]+' ',stringgrid1.Cells[2,k]+' ') > 0 then
    begin
      stringgrid3.Cells[i*3-3,c] := stringgrid1.Cells[2,k];
      stringgrid3.Cells[i*3-2,c] := stringgrid1.Cells[3,k];
      stringgrid3.Cells[i*3-1,c] := stringgrid1.Cells[4,k];
      inc(c);
      stringgrid3.Cells[i*3-2,0] := A[i];
      str((c-2)/(stringgrid1.RowCount-1)*100:2:2,s);
      stringgrid3.Cells[i*3-1,0] := inttostr(c-2)+'='+s+'%'; ;
      stringgrid3.Cells[i*3-3,1] := 'Lemma';
      stringgrid3.Cells[i*3-2,1] := 'Type';
      stringgrid3.Cells[i*3-1,1] := 'Rank';
      stringgrid1.Cells[2,k] := '';
    end;
   end;

  i := 0;
  repeat
    if stringgrid3.Cells[i,2] = '' then
    stringgrid3.DeleteCol(i) else inc(i);
  until i = stringgrid3.ColCount;
//  Showmessage(inttostr(i));
  Stringgrid3.SaveToCSVFile('input\'+combobox1.Text+'.csv',#9);

  end;
end;

procedure Tkkn.StringGrid1Click(Sender: TObject);
var i : word;
    s : string;
    s1: string;
    j,c : word;
begin
if stringgrid1.Col = 6 then
begin
CHART1.Legend.Visible:=FALSE;
ls1.Clear;ls2.Clear;
ls3.Clear;ls4.Clear;
ls5.Clear;ls6.Clear;
ls7.Clear;ls8.Clear;
ls9.Clear;
 if stringgrid1.Cells[6,stringgrid1.Row] = '0' then
    stringgrid1.Cells[6,stringgrid1.Row] := '1' else
    stringgrid1.Cells[6,stringgrid1.Row] := '0';

end
else
begin
hw.Top:=1;hw.Left:=1;hw.Width:=groupbox2.Width -2;
hw.Height:=groupbox2.Height - 2;
sf.findinfo(stringgrid1.Cells[2,stringgrid1.Row],
d[form1.GetletId(stringgrid1.Cells[2,stringgrid1.Row])].beg,
d[form1.GetletId(stringgrid1.Cells[2,stringgrid1.Row])].ed,true,s);
hw.LoadFromString(s);

   ls1.Clear; ls5.Clear;ls9.Clear;
   ls2.Clear; ls6.Clear;
   ls3.Clear; ls7.Clear;
   ls4.Clear; ls8.Clear;
   chart1lineseries1.Legend.visible := true;
   chart1barseries1.Legend.Visible:=false;
   chart1pieseries1.Legend.Visible:=false;
   chart1lineseries2.Legend.visible := false;
   chart1lineseries3.Legend.visible := false;
   chart1lineseries4.Legend.visible := false;
   chart1lineseries5.Legend.visible := false;
   chart1lineseries6.Legend.visible := false;

   chart1.Legend.GroupTitles.Clear;
   chart1.Legend.GroupTitles.Add(stringgrid1.Cells[2,stringgrid1.Row]);
   chart1lineseries1.Legend.GroupIndex:=0;
   chart1lineseries1.legend.UserItemsCount:=1;
   chart1.legend.ColumnCount:=1;

   for i := 1 to 7 do
   ls2.Add(i,0,combobox1.Items[i]);
   s := stringgrid1.Cells[2,stringgrid1.Row];
   s1:= stringgrid1.Cells[3,stringgrid1.Row];
   stringgrid2.Clear;
   stringgrid2.RowCount:=8000;


   for i := 0 to dmk.StringGrid1.RowCount - 1 do
   if  (dmk.StringGrid1.Cells[0,i]=s)
    and (dmk.StringGrid1.Cells[1,i]=s1)
   then
   begin
      ls1.Add(1,strtofloat(dmk.StringGrid1.Cells[2,i]),s);
      fillSinta('1',i);
      break;
   end;

   for i := 0 to dmk.StringGrid2.RowCount - 1 do
   if (dmk.StringGrid2.Cells[0,i]=s)
      and (dmk.StringGrid2.Cells[1,i]=s1)
    then
    begin
      ls1.Add(2,strtofloat(dmk.StringGrid2.Cells[2,i]),s);
      fillSinta('2',i);
      break;
    end;

   for i := 0 to dmk.StringGrid3.RowCount - 1 do
   if (dmk.StringGrid3.Cells[0,i]=s)
      and (dmk.StringGrid3.Cells[1,i]=s1)
      then
   begin
     ls1.Add(3,strtofloat(dmk.StringGrid3.Cells[2,i]),s);
     fillSinta('3',i);
     break;
   end;

   for i := 0 to dmk.StringGrid4.RowCount - 1 do
   if (dmk.StringGrid4.Cells[0,i]=s)
       and (dmk.StringGrid4.Cells[1,i]=s1)
       then
       begin
          ls1.Add(4,strtofloat(dmk.StringGrid4.Cells[2,i]),s);
          fillSinta('4',i);
          break;
       end;

   for i := 0 to dmk.StringGrid5.RowCount - 1 do
   if (dmk.StringGrid5.Cells[0,i]=s)
       and (dmk.StringGrid5.Cells[1,i]=s1)
       then
       begin
         ls1.Add(5,strtofloat(dmk.StringGrid5.Cells[2,i]),s);
         fillSinta('5',i);
         break;
       end;

   for i := 0 to dmk.StringGrid6.RowCount - 1 do
   if (dmk.StringGrid6.Cells[0,i]=s)
       and (dmk.StringGrid6.Cells[1,i]=s1)
       then
   begin
        ls1.Add(6,strtofloat(dmk.StringGrid6.Cells[2,i]),s);
        fillSinta('6',i);
        break;
   end;

   for i := 0 to dmk.StringGrid7.RowCount - 1 do
   if (dmk.StringGrid7.Cells[0,i]=s)
       and (dmk.StringGrid7.Cells[1,i]=s1)
       then
   begin
      ls1.Add(7,strtofloat(dmk.StringGrid7.Cells[2,i]),s);
      fillSinta('7',i);
      break;
   end;

   for i := 0 to dmk.StringGrid8.RowCount - 1 do
   if (dmk.StringGrid8.Cells[0,i]=s)
       and (dmk.StringGrid8.Cells[1,i]=s1)
       then
    begin

       fillSinta('8',i);
       break;
    end;

{
   for i := 0 to dmk.StringGrid0.RowCount - 1 do
   if  (dmk.StringGrid0.Cells[0,i]=s)
    and (dmk.StringGrid0.Cells[1,i]=s1)
   then
   begin
      memo1.Lines.Add(combobox1.Items[0] + #9+ dmk.StringGrid0.Cells[2,i]+#9+inttostr(i+1));
   end;

   for i := 0 to dmk.StringGrid9.RowCount - 1 do
   if  (dmk.StringGrid9.Cells[0,i]=s)
    and (dmk.StringGrid9.Cells[1,i]=s1)
   then
   begin
      memo1.Lines.Add(combobox1.Items[9] + #9+ dmk.StringGrid9.Cells[2,i]+#9+inttostr(i+1));

   end;

}

   BGraph;
end;
end;

procedure Tkkn.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin

  dmk.fillptk(updown1.Position);
  combobox1change(sender);
  label3.Caption:='Покрытие: '+inttostr(updown1.Position)+'%';
end;
procedure Tkkn.fillg(i : byte);
var j,k : word;
    s : string;
    c : word;
begin
 stringgrid1.Clear;
    c := 0;
    stringgrid1.RowCount:=ptk[i] + 2;

    case i of
         0 :   for j := 0 to dmk.StringGrid0.RowCount - 1 do//             ptk[i] do
               if ch1(dmk.StringGrid0.Cells[1,j]) then
               begin
                 inc(c);
                 stringgrid1.Cells[2,c] := dmk.StringGrid0.Cells[0,j];
                 stringgrid1.Cells[3,c] := dmk.StringGrid0.Cells[1,j];
                 stringgrid1.Cells[4,c] := dmk.StringGrid0.Cells[2,j];
                 stringgrid1.Cells[0,c] := dmk.StringGrid0.Cells[3,j];

               end;

         1 :   for j := 0 to ptk[i] do
               if ch1(dmk.StringGrid1.Cells[1,j]) then
               begin
                 inc(c);
                 stringgrid1.Cells[2,c] := dmk.StringGrid1.Cells[0,j];
                 stringgrid1.Cells[3,c] := dmk.StringGrid1.Cells[1,j];
                 stringgrid1.Cells[4,c] := dmk.StringGrid1.Cells[2,j];
                 stringgrid1.Cells[5,c] := Gm(dmk.StringGrid1.Cells[2,j],i);
                 stringgrid1.Cells[0,c] := dmk.StringGrid1.Cells[3,j];

               end;
         2 :   for j := 0 to ptk[i] do
               if ch1(dmk.StringGrid2.Cells[1,j]) then
               begin
                 inc(c);
                 stringgrid1.Cells[2,c] := dmk.StringGrid2.Cells[0,j];
                 stringgrid1.Cells[3,c] := dmk.StringGrid2.Cells[1,j];
                 stringgrid1.Cells[4,c] := dmk.StringGrid2.Cells[2,j];
                 stringgrid1.Cells[5,c] := Gm(dmk.StringGrid2.Cells[2,j],i);
                 stringgrid1.Cells[0,c] := dmk.StringGrid2.Cells[3,j];
               end;
         3 :   for j := 0 to ptk[i] do
               if ch1(dmk.StringGrid3.Cells[1,j]) then
               begin
                 inc(c);
                 stringgrid1.Cells[2,c] := dmk.StringGrid3.Cells[0,j];
                 stringgrid1.Cells[3,c] := dmk.StringGrid3.Cells[1,j];
                 stringgrid1.Cells[4,c] := dmk.StringGrid3.Cells[2,j];
                 stringgrid1.Cells[5,c] := Gm(dmk.StringGrid3.Cells[2,j],i);
                 stringgrid1.Cells[0,c] := dmk.StringGrid3.Cells[3,j];
               end;
         4 :   for j := 0 to ptk[i] do
               if ch1(dmk.StringGrid4.Cells[1,j]) then
               begin
                 inc(c);
                 stringgrid1.Cells[2,c] := dmk.StringGrid4.Cells[0,j];
                 stringgrid1.Cells[3,c] := dmk.StringGrid4.Cells[1,j];
                 stringgrid1.Cells[4,c] := dmk.StringGrid4.Cells[2,j];
                 stringgrid1.Cells[5,c] := Gm(dmk.StringGrid4.Cells[2,j],i);
                 stringgrid1.Cells[0,c] := dmk.StringGrid4.Cells[3,j];
               end;
         5 :   for j := 0 to ptk[i] do
               if ch1(dmk.StringGrid5.Cells[1,j]) then
               begin
                 inc(c);
                 stringgrid1.Cells[2,c] := dmk.StringGrid5.Cells[0,j];
                 stringgrid1.Cells[3,c] := dmk.StringGrid5.Cells[1,j];
                 stringgrid1.Cells[4,c] := dmk.StringGrid5.Cells[2,j];
                 stringgrid1.Cells[5,c] := Gm(dmk.StringGrid5.Cells[2,j],i);
                 stringgrid1.Cells[0,c] := dmk.StringGrid5.Cells[3,j];
               end;
         6 :   for j := 0 to ptk[i] do
               if ch1(dmk.StringGrid6.Cells[1,j]) then
               begin
                 inc(c);
                 stringgrid1.Cells[2,c] := dmk.StringGrid6.Cells[0,j];
                 stringgrid1.Cells[3,c] := dmk.StringGrid6.Cells[1,j];
                 stringgrid1.Cells[4,c] := dmk.StringGrid6.Cells[2,j];
                 stringgrid1.Cells[5,c] := Gm(dmk.StringGrid6.Cells[2,j],i);
                 stringgrid1.Cells[0,c] := dmk.StringGrid6.Cells[3,j];
               end;
         7 :   for j := 0 to ptk[i] do
               if ch1(dmk.StringGrid7.Cells[1,j]) then
               begin
                 inc(c);
                 stringgrid1.Cells[2,c] := dmk.StringGrid7.Cells[0,j];
                 stringgrid1.Cells[3,c] := dmk.StringGrid7.Cells[1,j];
                 stringgrid1.Cells[4,c] := dmk.StringGrid7.Cells[2,j];
                 stringgrid1.Cells[5,c] := Gm(dmk.StringGrid7.Cells[2,j],i);
                 stringgrid1.Cells[0,c] := dmk.StringGrid7.Cells[3,j];
               end;
         8 :   for j := 0 to ptk[i] do
               if ch1(dmk.StringGrid8.Cells[1,j]) then
               begin
                 inc(c);
                 stringgrid1.Cells[2,c] := dmk.StringGrid8.Cells[0,j];
                 stringgrid1.Cells[3,c] := dmk.StringGrid8.Cells[1,j];
                 stringgrid1.Cells[4,c] := dmk.StringGrid8.Cells[2,j];
                 stringgrid1.Cells[5,c] := Gm(dmk.StringGrid8.Cells[2,j],i);
                 stringgrid1.Cells[0,c] := dmk.StringGrid8.Cells[3,j];
               end;
         9 :   for j := 0 to dmk.StringGrid9.RowCount - 1 do//;//ptk[i] do
               if ch1(dmk.StringGrid9.Cells[1,j]) then
               begin
                 inc(c);
                 stringgrid1.Cells[2,c] := dmk.StringGrid9.Cells[0,j];
                 stringgrid1.Cells[3,c] := dmk.StringGrid9.Cells[1,j];
                 stringgrid1.Cells[0,c] := dmk.StringGrid9.Cells[2,j];
               end;
    end;
    stringgrid1.RowCount:=c;
    statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount - 1);
    statusbar1.Panels[3].Text:=inttostr(updown1.Position)+'%';

//    memo1.Lines.LoadFromFile('sys\tx\'+inttostr(i));
    s := 'INFORMATION OF CORE AND PERIOD' +#13+#10;
    s := s  + 'Core: '+#9+'"'+combobox1.Text+'"'+  #13+#10;
    s := s + 'Total lemmas in period: ' + #9+inttostr(lm[i]) + #13+#10;
    s := s + 'Pareto coverage: '+#9+inttostr(updown1.Position) + '% ('+ inttostr(ptk[i]) +' of lemmas)'#13+#10;
    s := s + 'Selected core size is: ~' +#9+ inttostr(round(ptk[i]/lm[i]*100)) + '%' + #13+#10;

    j := 0;
    for k := 1 to stringgrid1.RowCount - 1 do
          if stringgrid1.Cells[3,k] = 'v' then inc(j);
    s := s + 'Total verbs: '+ inttostr(j) + ' (' +inttostr(round(j/ptk[i]*100)) + '% of core)' + #13+#10;
    s := s + 'Total names: '+ inttostr(ptk[i]-j) + ' (' +inttostr(round((ptk[i]-j)/ptk[i]*100)) + '% of core)'+#13+#10;
//    s := s + 'SANSKRIT TEXTS IN USE: (total: '+inttostr(memo1.Lines.Count)+')'+#13+#10;
//    MEMO1.Text:= s + memo1.Text;


end;
procedure Tkkn.fillg2;
begin

end;
function Tkkn.ch1(s : string) : boolean;
var z : boolean;
begin
   z := false;
   case combobox2.ItemIndex of
        0 : z := true;
        1 : if s = 'v' then z := true else z := false;
        2 : if s <>'v' then z := true else z := false;
   end;

   ch1 := z;
end;
procedure tkkn.fillsinta(f : string; i : word);
var s,s1 : string;
    c : word;
    j : word;
begin
   c := 2;
   j := strtoint(f);
   memo2.Lines.LoadFromFile('sys\sintagma\'+f);
   s := memo2.Lines.Strings[i];
   s1 := copy(s,1,pos(';',s) - 1);
   delete(s,1,pos(';',s));


s1 := copy(s,1,pos(';',s) - 1);
   delete(s,1,pos(';',s));
   stringgrid2.Cells[(j)*2 - 2,1] := s1 + ' cmb.';
   s1 := copy(s,1,pos(';',s) - 1);
   delete(s,1,pos(';',s));
   stringgrid2.Cells[j*2 - 1,1] := s1 + ' осн.';
   c := 2;
   while s <> '' do
   begin
     if stringgrid2.rowcount < c - 1 then stringgrid2.RowCount:=c + 3;
     s1 := copy(s,1,pos(';',s) - 1);
     delete(s,1,pos(';',s));
     stringgrid2.Cells[j*2-2,c] := s1;
     s1 := copy(s,1,pos(';',s) - 1);
     delete(s,1,pos(';',s));
     stringgrid2.Cells[j*2-1,c] := s1;
     inc(c)
   end;

end;
function Tkkn.convertx(s : string) : string;
var i : byte;
   xc : word;
   zz : boolean;
begin
   zz := false;
   while pos('дж',s) > 0 do
   begin
      insert('j',s,pos('дж',s));
      delete(s,pos('дж',s),length('дж'));
   end;
   while pos('дЖ',s) > 0 do
   begin
      insert('j',s,pos('дЖ',s));
      delete(s,pos('дЖ',s),length('дЖ'));
   end;

   while pos('ж',s) > 0 do
   begin
      insert('j',s,pos('ж',s));
      delete(s,pos('ж',s),length('ж'));
   end;



   for xc := 1 to length(s) do
   begin
    i :=  pos('R^i',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ṛ',s,i);
    end;
    i :=  pos('R^I',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ṝ',s,i);
    end;
    i :=  pos('RR',s);
    if i > 0 then
    begin
      delete(s,i,2);
      insert('ṝ',s,i);
    end;
    i :=  pos('ṛṛ',s);
    if i > 0 then
    begin
      delete(s,i,length('ṛṛ'));
      insert('ṝ',s,i);
    end;



    i :=  pos('R',s);
    if i > 0 then
    begin
      delete(s,i,1);
      insert('ṛ',s,i);
    end;


    i :=  pos('L^i',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ḷ',s,i);
    end;
    i :=  pos('L^I',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ḹ',s,i);
    end;

    i :=  pos('lṛ',s);
    if i > 0 then
    begin
      delete(s,i,length('lṛ'));
      insert('ḷ',s,i);
    end;

    i :=  pos('ḷṛ',s);
    if i > 0 then
    begin
      delete(s,i,length('ḷṛ'));
      insert('ḹ',s,i);
    end;

    i :=  pos('lṝ',s);
    if i > 0 then
    begin
      delete(s,i,length('lṝ'));
      insert('ḹ',s,i);
    end;


     i :=  pos('A',s);
     if i > 0 then
     begin
       delete(s,i,1);

       insert('ā', s,i);
     end;
     i :=  pos('aa',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ā',s,i);
     end;
     i :=  pos('U',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ū',s,i);
     end;
     i :=  pos('uu',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ū',s,i);
     end;
     i :=  pos('I',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ī',s,i);
     end;
     i :=  pos('ii',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ī',s,i);
     end;
     i :=  pos('^N',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ṅ',s,i);
     end;
     i :=  pos('~N',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ṅ',s,i);
     end;
     i :=  pos('G',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṅ',s,i);
     end;
     i :=  pos('~n',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ñ',s,i);
     end;
     i :=  pos('J',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ñ',s,i);
     end;

     i :=  pos('N',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṇ',s,i);
     end;
     i :=  pos('T',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṭ',s,i);
     end;
     i :=  pos('D',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ḍ',s,i);
     end;
     i :=  pos('Sh',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ṣ',s,i);
     end;
     i :=  pos('S',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṣ',s,i);
     end;
     i :=  pos('sh',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ś',s,i);
     end;

     i :=  pos('z',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ś',s,i);
     end;

     i :=  pos('x',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('kṣ',s,i);
     end;
     i :=  pos('M',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṁ',s,i);
     end;
     i :=  pos('H',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ḥ',s,i);
     end;
end;
    ConvertX := s;
End;
function Tkkn.Gm(s : string; i : byte) : string;
var d : string;
    c : real;
begin
    c := strtofloat(s);
    c := c/100;
    c:= c*lm[i];
    c := 1000000/lm[i]*c;
    d := inttostr(round(c));
    Gm := d;
end;
procedure Tkkn.getsinvec(i : longint);
var s : string;
begin
//   listbox1.Clear;
   sgt := '';
   sgt2 := 0;
   s := memo3.Lines.Strings[i];
   delete(s,1,pos(';',s));
   delete(s,1,pos(';',s));
   delete(s,1,pos(';',s));
   while pos(';',s) <> 0 do
   begin
     sgt := sgt + ','+ copy(s,1,pos(';',s)-1) + ',';
     inc(sgt2);
     delete(s,1,pos(';',s));
     delete(s,1,pos(';',s));

   end;
end;

function  Tkkn.cmpvec(j : byte) : string;
var s : string;
    i,k,l : longint;
begin
    s := '';k:= 0; l := 0;
    for i := 2 to stringgrid2.RowCount-1 do
    begin
       if pos(','+stringgrid2.Cells[(j-1)*2,i]+',',sgt) > 0  then inc(k);
       if stringgrid2.Cells[(j-1)*2,i] <> '' then inc(l)
       else break;
    end;
    if l > 0 then
       cmpvec := inttostr(l)+';'+inttostr(k)+';'+inttostr(sgt2) + ';'+inttostr(round(k/l*100))+';'+inttostr(j);

end;
function tkkn.fillvec(v : byte) : string;
var i,j : longint;
    s : string; g : string;
    s1,sx: string;
    z : boolean;
    c : word;
begin
    c:= 0;
    z := true;
    s1 := ';'+stringgrid1.Cells[2,stringgrid1.Row] + ';';
    g := stringgrid1.Cells[3,stringgrid1.Row];// + ';';
    while z <> false do
    begin
      z := false;
      s := stringgrid2.Cells[v*2,2];
      if pos(';'+s+';',s1) <> 0 then
      for j := 3 to stringgrid2.RowCount - 1 do
      if stringgrid2.Cells[v*2,j] = '' then break else
      if (getG(stringgrid2.Cells[v*2,j],'v') = false) then
      if  (pos(';'+stringgrid2.Cells[v*2,j]+';',s1) = 0) and
          (getG(stringgrid2.Cells[v*2,j],'v') = false)then
      begin
         s := stringgrid2.Cells[v*2,j];
         break;
      end;
//      if getG(s,g)  then


      s1 := s1 + s + ';';

      for i := 1 to stringgrid1.RowCount - 1 do
      if s = stringgrid1.Cells[2,i] then
      begin
        stringgrid1.Row:=i;
        stringgrid1click(nil);
        z := true;
        break;
    end;
      if (i = stringgrid1.RowCount - 1) and
         (z = false) then z := false;
    end;
    delete(s1,1,1);


fillvec := s1;

end;
function tkkn.getG(stem,g : string) : boolean;
var i : longint; z : boolean;
begin z := false;

      if g = 'v' then
      begin
        for i :=  1 to length(gv) do
        if stem = gv[i].stm then
           begin
//             if g = gv[i].g then z := true;
             z := true;

//             showmessage(stem+#13+#10 + g);
             break;
           end;
      end
      else
      begin
//      z := true;
      for i :=  1 to length(gn) do
      if stem = gn[i].stm then
         begin
           if g = gn[i].g then z := true;
           break;
         end;
       end;

      getG := z;
end;
procedure Tkkn.BGraph;
begin
 chart1.AxisList[0].Visible:=True;
 chart1.AxisList[0].marks.Source := ls1;
 chart1.AxisList[0].marks.Range.Max := 2;
 chart1.AxisList[0].marks.Range.min := 0;
 chart1.AxisList[0].Title.Caption:='%Покрытия словоупотреблений';
end;
procedure Tkkn.selg(c : char;z : boolean);
var i : dword;
begin
   for i := 1 to stringgrid1.RowCount - 1 do
   if z then stringgrid1.Cells[6,i] := c else
   begin
     if stringgrid1.Cells[6,i] = '0' then
     stringgrid1.Cells[6,i] := '1' else
     stringgrid1.Cells[6,i] := '0';
   end;
end;
procedure TKkn.GetFate;
var i,j,k : dword;s,s1 : string; c : byte;
begin

  ls1.Clear;
  ls5.Clear;ls6.Clear;ls7.Clear;ls8.Clear;ls9.Clear;
  c :=0;

  chart1lineseries1.Legend.visible := false;
  chart1barseries1.Legend.Visible:=false;
  chart1pieseries1.Legend.Visible:=false;
  chart1lineseries2.Legend.visible := false;
  chart1lineseries3.Legend.visible := false;
  chart1lineseries4.Legend.visible := false;
  chart1lineseries5.Legend.visible := false;
  chart1lineseries6.Legend.visible := false;
  chart1.Legend.GroupTitles.Clear;
  chart1.Legend.GroupTitles.add('Дегенда');

for j := 1 to stringgrid1.RowCount - 1 do
if stringgrid1.Cells[6,j] = '1' then
if c < 6 then
begin
  chart1.Legend.GroupTitles.Add(stringgrid1.Cells[2,j]);



  s := stringgrid1.Cells[2,j];
  s1:= stringgrid1.Cells[3,j];
  k := j*random(432000);

  for i := 0 to dmk.StringGrid1.RowCount - 1 do
  if  (dmk.StringGrid1.Cells[0,i]=s)
   and (dmk.StringGrid1.Cells[1,i]=s1)
  then begin
    case c of
         0 : ls1.Add(1,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
         1 : ls5.Add(1,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
         2 : ls6.Add(1,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
         3 : ls7.Add(1,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
         4 : ls8.Add(1,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
         5 : ls9.Add(1,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);

    end;
    break;
  end;

  for i := 0 to dmk.StringGrid2.RowCount - 1 do
  if (dmk.StringGrid2.Cells[0,i]=s)
     and (dmk.StringGrid2.Cells[1,i]=s1)
   then
   begin
     case c of
          0 : ls1.Add(2,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          1 : ls5.Add(2,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          2 : ls6.Add(2,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          3 : ls7.Add(2,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          4 : ls8.Add(2,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          5 : ls9.Add(2,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
     end;
     break;
   end;

  for i := 0 to dmk.StringGrid3.RowCount - 1 do
  if (dmk.StringGrid3.Cells[0,i]=s)
     and (dmk.StringGrid3.Cells[1,i]=s1)
     then
     begin
     case c of
          0 : ls1.Add(3,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          1 : ls5.Add(3,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          2 : ls6.Add(3,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          3 : ls7.Add(3,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          4 : ls8.Add(3,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          5 : ls9.Add(3,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
        end;
       break;
     end;

  for i := 0 to dmk.StringGrid4.RowCount - 1 do
  if (dmk.StringGrid4.Cells[0,i]=s)
      and (dmk.StringGrid4.Cells[1,i]=s1)
      then
      begin
      case c of
           0 : ls1.Add(4,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           1 : ls5.Add(4,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           2 : ls6.Add(4,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           3 : ls7.Add(4,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           4 : ls8.Add(4,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           5 : ls9.Add(4,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
         end;
         break;
      end;

  for i := 0 to dmk.StringGrid5.RowCount - 1 do
  if (dmk.StringGrid5.Cells[0,i]=s)
      and (dmk.StringGrid5.Cells[1,i]=s1)
      then
      begin
      case c of
           0 : ls1.Add(5,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           1 : ls5.Add(5,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           2 : ls6.Add(5,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           3 : ls7.Add(5,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           4 : ls8.Add(5,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           5 : ls9.Add(5,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          end;
         break;
      end;

  for i := 0 to dmk.StringGrid6.RowCount - 1 do
  if (dmk.StringGrid6.Cells[0,i]=s)
      and (dmk.StringGrid6.Cells[1,i]=s1)
      then
      begin
      case c of
           0 : ls1.Add(6,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           1 : ls5.Add(6,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           2 : ls6.Add(6,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           3 : ls7.Add(6,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           4 : ls8.Add(6,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           5 : ls9.Add(6,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
          end;
         break;
      end;

  for i := 0 to dmk.StringGrid7.RowCount - 1 do
  if (dmk.StringGrid7.Cells[0,i]=s)
      and (dmk.StringGrid7.Cells[1,i]=s1)
      then
      begin
      case c of
           0 : ls1.Add(7,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           1 : ls5.Add(7,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           2 : ls6.Add(7,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           3 : ls7.Add(7,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           4 : ls8.Add(7,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
           5 : ls9.Add(7,strtofloat(dmk.StringGrid1.Cells[2,i]),s,k);
         end;
        break;
      end;
{
  for i := 0 to dmk.StringGrid8.RowCount - 1 do
  if (dmk.StringGrid8.Cells[0,i]=s)
      and (dmk.StringGrid8.Cells[1,i]=s1)
      then  memo1.Lines.Add(s + #9+ dmk.StringGrid8.Cells[2,i]+#9+inttostr(i+1));
}
{
  for i := 0 to dmk.StringGrid0.RowCount - 1 do
  if  (dmk.StringGrid0.Cells[0,i]=s)
   and (dmk.StringGrid0.Cells[1,i]=s1)
  then memo1.Lines.Add(combobox1.Items[0] + #9+ dmk.StringGrid0.Cells[2,i]+#9+inttostr(i+1));

  for i := 0 to dmk.StringGrid9.RowCount - 1 do
  if  (dmk.StringGrid9.Cells[0,i]=s)
   and (dmk.StringGrid9.Cells[1,i]=s1)
  then memo1.Lines.Add(s + #9+ dmk.StringGrid9.Cells[2,i]+#9+inttostr(i+1));
}
inc(c);

end;
//  BGraph;
 ls2.clear;
for i := 1 to 7 do
ls2.add(i,0,combobox1.Items[i]);

 chart1.AxisList[0].Visible:=True;
 chart1.AxisList[0].marks.Source := ls1;
 chart1.AxisList[0].marks.Range.Max := 2;
 chart1.AxisList[0].marks.Range.min := 0;
 chart1.AxisList[0].Title.Caption:='%Покрытия словоупотреблений';

if c > 0 then chart1lineseries1.Legend.Visible:=true;
if ls5.Count > 0 then chart1lineseries2.Legend.Visible:=true;
if ls6.Count > 0 then chart1lineseries3.Legend.Visible:=true;
if ls7.Count > 0 then chart1lineseries4.Legend.Visible:=true;
if ls8.Count > 0 then chart1lineseries5.Legend.Visible:=true;
if ls9.Count > 0 then chart1lineseries6.Legend.Visible:=true;

if c > 0 then chart1lineseries1.Legend.GroupIndex:=1;
if ls5.Count > 0 then chart1lineseries2.Legend.GroupIndex:=2;
if ls6.Count > 0 then chart1lineseries3.Legend.GroupIndex:=3;
if ls7.Count > 0 then chart1lineseries4.Legend.GroupIndex:=4;
if ls8.Count > 0 then chart1lineseries5.Legend.GroupIndex:=5;
if ls9.Count > 0 then chart1lineseries6.Legend.GroupIndex:=6;



end;
procedure TKKn.GetIntersec;
var i,j,k1,k2,k3,k4,k5,k6,k7 : dword;
    s,s1 : string;
begin
 ls3.Clear;k1 := 0;k2 := 0;k3 := 0;k4 := 0;k5 := 0; k6 := 0;k7 := 0;
 ls2.Clear;ls1.Clear;
 if combobox1.ItemIndex in [1..7] then;
 for i := 1 to stringgrid1.RowCount - 1 do
 begin
   s  := stringgrid1.Cells[2,i];
   s1 := stringgrid1.Cells[3,i];
   if combobox1.ItemIndex <> 1 then
   for j := 0 to dmk.StringGrid1.RowCount - 1 do
   if (dmk.StringGrid1.Cells[0,j]=s) and
      (dmk.StringGrid1.Cells[1,j]=s1) then
       begin
          inc(k1); break;
       end;

   if combobox1.ItemIndex <> 2 then
   for j := 0 to dmk.StringGrid2.RowCount - 1 do
   if (dmk.StringGrid2.Cells[0,j]=s) and
      (dmk.StringGrid2.Cells[1,j]=s1) then
       begin
          inc(k2); break;
       end;
   if combobox1.ItemIndex <> 3 then
   for j := 0 to dmk.StringGrid3.RowCount - 1 do
   if (dmk.StringGrid3.Cells[0,j]=s) and
      (dmk.StringGrid3.Cells[1,j]=s1) then
       begin
          inc(k3); break;
       end;

   if combobox1.ItemIndex <> 4 then
   for j := 0 to dmk.StringGrid4.RowCount - 1 do
   if (dmk.StringGrid4.Cells[0,j]=s) and
      (dmk.StringGrid4.Cells[1,j]=s1) then
       begin
          inc(k4); break;
       end;

   if combobox1.ItemIndex <> 5 then
   for j := 0 to dmk.StringGrid5.RowCount - 1 do
   if (dmk.StringGrid5.Cells[0,j]=s) and
      (dmk.StringGrid5.Cells[1,j]=s1) then
       begin
          inc(k5); break;
       end;

   if combobox1.ItemIndex <> 6 then
   for j := 0 to dmk.StringGrid6.RowCount - 1 do
   if (dmk.StringGrid6.Cells[0,j]=s) and
      (dmk.StringGrid6.Cells[1,j]=s1) then
       begin
          inc(k6); break;
       end;

   if combobox1.ItemIndex <> 7 then
   for j := 0 to dmk.StringGrid7.RowCount - 1 do
   if (dmk.StringGrid7.Cells[0,j]=s) and
      (dmk.StringGrid7.Cells[1,j]=s1) then
       begin
          inc(k7); break;
       end;
 end;
 k1 := round(k1/stringgrid1.RowCount*100);
 k2 := round(k2/stringgrid1.RowCount *100);
 k3 := round(k3/stringgrid1.RowCount *100);
 k4 := round(k4/stringgrid1.RowCount *100);
 k5 := round(k5/stringgrid1.RowCount *100);
 k6 := round(k6/stringgrid1.RowCount *100);
 k7 := round(k7/stringgrid1.RowCount *100);
 if k1 <> 0 then
 ls3.Add(1,k1,inttostr(k1)+'%',$8d0000);
 if k2 <> 0 then
 ls3.Add(2,k2,inttostr(k2)+'%',$008d00);
 if k3 <> 0 then
 ls3.Add(3,k3,inttostr(k3)+'%',$00008d);
 if k4 <> 0 then
 ls3.Add(4,k4,inttostr(k4)+'%',$8d8d00);
 if k5 <> 0 then
 ls3.Add(5,k5,inttostr(k5)+'%',$8d008d);
 if k6 <> 0 then
 ls3.Add(6,k6,inttostr(k6)+'%',$8d8d8d);
 if k7 <> 0 then
 ls3.Add(7,k7,inttostr(k7)+'%',$008d8d);
;
 chart1.AxisList[0].marks.Source := ls3;
 chart1.AxisList[0].marks.Range.Max := 100;
 chart1.AxisList[0].marks.Range.min := 0;
 chart1.AxisList[0].Title.Caption:='%Общей лексики';

 for i := 1 to 7 do
 if i <> combobox1.ItemIndex then
 ls2.Add(i,0,combobox1.Items[i]);
end;

end.

