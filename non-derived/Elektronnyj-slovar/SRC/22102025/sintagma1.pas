unit sintagma1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, Menus, ComCtrls, HtmlView;

type

  { Tsintagma }

  Tsintagma = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    GroupBox1: TGroupBox;
    hw: THtmlViewer;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    PopupMenu2: TPopupMenu;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    Separator1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure StringGrid2Click(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
    function gettrd(s:string;s1,s2,s3,s4 : dword): boolean;
  private

  public
    procedure load1;
    function chkv(i : dword) : byte;
  end;

var
  sintagma: Tsintagma;

implementation
uses poisk,tsn,shellapi,tx1,sfo,depo1,clipbrd;
type sinx = record b,e : dword;end;
var  idx : array[1..47] of sinx;
procedure Tsintagma.FormCreate(Sender: TObject);
var i,j,a : dword;s : string;
    f : text;
begin
  stringgrid1.LoadFromCSVFile('sys\T\111H.csv',#9);
  memo1.lines.loadfromfile('sys\T\111.csv');
  stringgrid2.RowCount:=stringgrid1.RowCount + 1;
  sintagma.hw.LoadFromString('');
{  for i := 1 to length(idx) do
  begin
    idx[i].b:=0;idx[i].e:=0;
  end;
  s := ' ';
  a := 1;
  idx[1].b:=0;

  for  i := 0 to stringgrid1.RowCount - 1 do
  if pos(listbox2.Items[a-1],stringgrid1.cells[2,i]) = 1 then
  begin
     idx[a].b:=  i;
     idx[a-1].e:=i - 1;
     if a > 49 then break;
     inc(a);
  end;
  idx[49].e:=stringgrid1.RowCount - 1;
}
end;

procedure Tsintagma.MenuItem1Click(Sender: TObject);
var  q,i,j,k,l1,l2,l3 : dword; s,s1,v1,v2,vh,res : string;
     f : text;

begin l1 :=0;
if savedialog1.Execute then
begin
  progressbar1.Show;
  assignfile(f,savedialog1.FileName);rewrite(f);
  stringgrid2dblclick(sender);
  sinta.Hide;

  listbox1.Items := sinta.StringGrid1.Cols[2];
  j := stringgrid2.Row;
  l1 := sinta.StringGrid1.RowCount - 1;
  writeln(f,'Stem;SintagmaticStems;Vector');
  write(f,stringgrid2.Cells[2,stringgrid2.Row],';',l1,';');
  for i := 0 to listbox1.Items.Count - 1 do
  write(f,dcs1.getosn(listbox1.Items[i]),#9);
  writeln(f,'');

  writeln(f,'Comparable sintagmatic vectors:');
  for i  := 0 to stringgrid1.RowCount - 1 do
  if stringgrid1.Cells[2,i] <> stringgrid2.Cells[2,j] then
  begin
    l2 := strtoint(stringgrid1.Cells[5,i]);
    l3 := abs(l1-l2);
//    if l3 < 176 then

    begin
    k := chkv(i);
    if  k >= 60 then
    begin
      s1 := '';
      s1 := '';
      s := memo1.Lines.Strings[i];
      delete(s,1,pos(#32,s));
      s1 := s1 + copy(s,1,pos(#32,s));
      delete(s,1,pos(#32,s));
      s1 := s1 + copy(s,1,pos(#32,s));
      delete(s,1,pos(#32,s));
      s1 := s1 + copy(s,1,pos(#32,s));
      delete(s,1,pos(#32,s));
      s1 := s1 + copy(s,1,pos(#32,s));
      delete(s,1,pos(#32,s));
      s1 := s1 + copy(s,1,pos(#32,s));
      delete(s,1,pos(#32,s));
      q := 6;
      while s <> '' do
      begin
        if q mod 2 = 0 then
        s1 := s1 + dcs1.getosn(copy(s,1,pos(#32,s)-1)) + #32 else
        s1 := s1 + copy(s,1,pos(#32,s));

        delete(s,1,pos(#32,s));
        inc(q);
      end;
    writeln(f,k,#9,s1);
    end;

    end;
    progressbar1.Position:=round(i/stringgrid1.RowCount*100);
   end;

    closefile(f);
    progressbar1.Hide;
    if form1.CheckBox7.Checked then
       shellexecute(0,'open',pchar(savedialog1.FileName),nil,nil,1);;


end;

end;

procedure Tsintagma.MenuItem2Click(Sender: TObject);
begin
  hw.CopyToClipboard;
end;

procedure Tsintagma.MenuItem3Click(Sender: TObject);
begin
  hw.SelectAll;
end;

procedure Tsintagma.MenuItem4Click(Sender: TObject);
begin
  sintagma.StringGrid2DblClick(sender);
end;

procedure Tsintagma.MenuItem5Click(Sender: TObject);
begin
  sintagma.Button1Click(sender);
end;

procedure Tsintagma.MenuItem6Click(Sender: TObject);
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

procedure Tsintagma.MenuItem7Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.yandex.ru/?source_lang=en&target_lang=ru&text='+s)
  ,nil,nil,1);




//https://translate.yandex.ru/?source_lang=en&target_lang=ru&text=hi

end;

procedure Tsintagma.Button3Click(Sender: TObject);
begin
  if edit2.Text = '' then edit2.Text:='0';
  if edit3.Text = '' then edit3.Text:='0';
  if edit4.Text = '' then edit4.Text:='0';
  if edit5.Text = '' then edit5.Text:='0';

  gettrd(edit1.Text,strtoint(edit2.Text),strtoint(edit3.Text),strtoint(edit4.Text),strtoint(edit5.Text));


end;

procedure Tsintagma.Button4Click(Sender: TObject);
var i : dword;
begin
  for i := 0 to stringgrid1.RowCount - 1 do
  stringgrid1.Cells[2,i] := stringgrid1.Cells[2,i] + '.';
  stringgrid1.SaveToCSVFile('sys\t\111H.csv',#9);
end;

procedure Tsintagma.ComboBox1Change(Sender: TObject);
begin
 case combobox1.ItemIndex of
 1 : combobox1.Hint:='Any side';
 2 : combobox1.Hint:='Left side';
 3 : combobox1.Hint:='Right side';
 else combobox1.Hint:=combobox1.text;
 end;
 button3click(sender);
end;

procedure Tsintagma.Button1Click(Sender: TObject);
begin
  if savedialog1.Execute then
  begin
     stringgrid2.SaveToCSVFile(savedialog1.FileName,#9);
     if form1.CheckBox7.Checked then
     shellexecute(0,'open',pchar(savedialog1.FileName),nil,nil,1);
  end;
end;

procedure Tsintagma.Button2Click(Sender: TObject);
var s,s1 : string; i,j : dword; f : text;
begin
  if savedialog1.Execute then
  begin
    assignfile(f,savedialog1.FileName);
    rewrite(f);
    for i := 0 to memo1.Lines.Count - 1 do
     begin
        s1 := '';
        s := memo1.Lines.Strings[i];
        delete(s,1,pos(#32,s));
        s1 := s1 + copy(s,1,pos(#32,s));
        delete(s,1,pos(#32,s));
        s1 := s1 + copy(s,1,pos(#32,s));
        delete(s,1,pos(#32,s));
        s1 := s1 + copy(s,1,pos(#32,s));
        delete(s,1,pos(#32,s));
        s1 := s1 + copy(s,1,pos(#32,s));
        delete(s,1,pos(#32,s));
        s1 := s1 + copy(s,1,pos(#32,s));
        delete(s,1,pos(#32,s));
        j := 6;
        while s <> '' do
        begin
          if j mod 2 = 0 then
          s1 := s1 + dcs1.getosn(copy(s,1,pos(#32,s)-1)) + #32 else
          s1 := s1 + copy(s,1,pos(#32,s));

          delete(s,1,pos(#32,s));
          inc(j);
        end;
        writeln(f,s1);




     end;
     closefile(f);
     if form1.CheckBox7.Checked then
        shellexecute(0,'open',pchar(savedialog1.FileName),nil,nil,1);;

  end;
end;

procedure Tsintagma.Edit1Change(Sender: TObject);
begin
  if edit1.Text='' then load1
  else
    begin
      edit1.Text:=form1.convertx(edit1.Text);
      edit1.SelStart:=length(edit1.Text);
//      button3click(sender);
      edit1.SetFocus;
    end;

end;

procedure Tsintagma.Edit2Change(Sender: TObject);
begin
  if edit2.Text = '' then edit2.Text:='0';
end;



procedure Tsintagma.Edit3Change(Sender: TObject);
begin
  if edit3.Text = '' then edit3.Text:='0';
end;

procedure Tsintagma.Edit4Change(Sender: TObject);
begin
  if edit4.Text = '' then edit4.Text:='0';
end;

procedure Tsintagma.Edit5Change(Sender: TObject);
begin
    if edit5.Text = '' then edit5.Text:='0';
end;


procedure Tsintagma.StringGrid2Click(Sender: TObject);
var s1 : string;
begin
 if stringgrid2.Row > 0 then
 begin
   s1 := copy(stringgrid2.Cells[2,stringgrid2.Row],1,pos(' ',
   stringgrid2.Cells[2,stringgrid2.Row])-1);
   sf.findinfo(s1, d[form1.GetletId(s1)].beg,
                   d[form1.GetletId(s1)].ed,true,s1);
//   memo2.Lines.Add(stringgrid2.Cells[2,stringgrid2.Row] + ' ' + s);
     hw.LoadFromString(s1);
 end;
end;


procedure Tsintagma.StringGrid2DblClick(Sender: TObject);
var s : string; i : byte;
begin
  form1.GetSinta(stringgrid2.Cells[0,stringgrid2.Row],true);
  s := stringgrid2.Cells[3,stringgrid2.Row];
  for i := 0 to combobox1.Items.Count - 1 do
  if combobox1.Items[i] = s then break;
  if sinta.caption <> '' then
  begin
     sinta.ComboBox2.ItemIndex:=i;
     sinta.ComboBox2Change(sender);
     Sinta.Show;
  end;

end;

procedure tsintagma.load1;
var i : dword;
begin
  stringgrid2.RowCount:=stringgrid1.RowCount + 1;
 for i := 0 to stringgrid1.RowCount- 1 do
 stringgrid2.Rows[i+1] := stringgrid1.Rows[i];
 statusbar1.Panels[1].Text:=inttostr(stringgrid2.RowCount-1);
end;
function tsintagma.gettrd(s:string;s1,s2,s3,s4 : dword): boolean;
var d1,d2,d3,d4,d5, d6  : boolean;
    i,j,b,e : dword;

begin j := 0;b := 0; e := 0;
 b := 0; e := stringgrid1.RowCount - 1;
{  if edit1.Text = '' then
    begin
      b := 0; e := stringgrid1.RowCount - 1;
    end
    else
    begin
      for j := 0 to listbox2.Items.Count - 1 do
      if pos(listbox2.Items[j],edit1.Text) = 1 then
      begin
         b := idx[j].b;
         e := idx[j].e;
      end;
      j :=0;
    end;
}
b := 0; e := stringgrid1.RowCount - 1;
    if s = '' then d1 := true else d1 := false;
    if s1 = 0 then d2 := true else d2 := false;
    if s2 = 0 then d3 := true else d3 := false;
    if s3 = 0 then d4 := true else d4 := false;
    if s4 = 0 then d5 := true else d5 := false;
    if combobox1.ItemIndex=0 then d6 := true else d6 := false;
    stringgrid2.Clear;
    stringgrid2.RowCount:=stringgrid1.RowCount + 1;
    for i := b to e do
    begin
      if d1 = false then if pos(s,stringgrid1.cells[2,i]) = 1 then d1 := true;
      if d2 = false then if (strtoint(stringgrid1.cells[4,i]) >= s1 )then  d2 := true;
      if d3 = false then if (strtoint(stringgrid1.cells[4,i]) <= s2 )then d3 := true;
      if d4 = false then if (strtoint(stringgrid1.cells[5,i]) >= s3 ) then d4 := true;
      if d5 = false then if (strtoint(stringgrid1.cells[5,i]) <= s4 ) then d5 := true;
      if d6 = false then if (combobox1.Text = stringgrid1.Cells[3,i]) or (combobox1.ItemIndex = 0) then d6 := true;
      if d1 and d2 and d3 and d4 and d5 and d6 then
      begin
        inc(j);
        stringgrid2.rows[j] := stringgrid1.rows[i];
    end;
      if s = '' then d1 := true else d1 := false;
      if s1 = 0 then d2 := true else d2 := false;
      if s2 = 0 then d3 := true else d3 := false;
      if s3 = 0 then d4 := true else d4 := false;
      if s4 = 0 then d5 := true else d5 := false;
      if combobox1.ItemIndex = 0 then d6 := true else d6 := false;
    end;
    stringgrid2.RowCount :=j +1;
//    showmessage(inttostr(stringgrid2.RowCount - 1));
    if j > 0 then gettrd := true;

    statusbar1.Panels[1].Text:=inttostr(stringgrid2.RowCount-1);
end;
function Tsintagma.chkv(i : dword) : byte;
var j,k : word;
begin  k := 0;
    for j := 1 to listbox1.items.Count - 1 do
    if pos(' '+listbox1.items[j]+' ',memo1.Lines.Strings[i]) > 0
       then inc(k);
//    showmessage(inttostr(i) +#32 + inttostr(j)+#32+inttostr(round(k/strtoint(stringgrid1.Cells[3,i])*100)));
//    if abs(i - j)/i*100 < 10 then
    chkv := round(k/(listbox1.Items.Count-1)*100);
//    else chkv := 0;

end;

{$R *.lfm}

end.

