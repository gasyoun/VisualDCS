unit Eda1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, ComCtrls, Menus,windows,messages,variants;

type

  { TEDA }

  TEDA = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
  private

  public

  end;

var
  EDA: TEDA;
  FL : boolean = true;
implementation
uses poisk,depo1,depo2;
var mz : boolean = false;
    maxE, maxD : longint;
{$R *.lfm}

{ TEDA }

procedure TEDA.ComboBox1Change(Sender: TObject);
var s : string;
    i : longint;
begin

if mz then

mz := false;
begin
    i := 0;s := '';
    if combobox1.TEXT <> '' then
    i := strtoint(combobox1.TEXT) - 1;
    if form1.combobox3.ItemIndex <> 1 then
    s := depo.memo1.lines.strings[i]
    else
        s := dp.memo1.lines.strings[i];
    i := 14;
    if s <> '' then
    for i := 1 to length(dlist) do
    if s[1] = dlist[i].DSign then
    break;
    label1.Caption:=dlist[i].DName + ' /'+dlist[i].DSign;
    if s <> '' then delete(s,1,1);
    form1.convertres(s);
    memo1.TEXT := s;
end;
mz := false;
statusbar2.Panels[1].Text:=inttostr(combobox1.Items.Count);
end;

procedure TEDA.ComboBox1Click(Sender: TObject);
begin
if mz then
begin
  if combobox1.Items.Count > 0 then
  if application.MessageBox('The article text has been changed. Do You want to save it?','Confirm',36) = idyes then
  Button1click(sender);
  mz := false;
end;
end;

procedure TEDA.Edit1Change(Sender: TObject);
var i : longint;
begin
if edit1.Text <> '' then
begin
  edit1.Text := form1.convertx(edit1.Text);
  edit1.SelStart:= length(edit1.Text);
  edit1.SetFocus;
  for i := 1 to stringgrid1.RowCount - 1 do
  if pos(edit1.Text,stringgrid1.Cells[0,i]) = 1 then
  begin
    stringgrid1.Row:=i;
    break;
  end;
end;
end;

procedure TEDA.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if mz then combobox1click(sender);
end;

procedure TEDA.FormCreate(Sender: TObject);
var i : longint;
begin
   While depo.Memo1.Lines.Count < 700000 do depo.Memo1.Lines.Add('');
   While dp.Memo1.Lines.Count < 100000 do dp.Memo1.Lines.Add('');

   if fileexists('sys\dicx1.sdm') then
   begin
     stringgrid2.LoadFromCSVFile('sys\dicx1.sdm','_',false);

     for i := 0 to stringgrid2.RowCount - 1 do
     if stringgrid2.Cells[0,i] <> '' then
     begin
     if stringgrid2.Cells[2,i] = '1' then
     dp.Memo1.Lines.Strings[strtoint(stringgrid2.Cells[0,i])-1] := stringgrid2.Cells[1,i]
     else
         depo.Memo1.Lines.Strings[strtoint(stringgrid2.Cells[0,i]) - 1] := stringgrid2.Cells[1,i]
     end;
     if fileexists('sys\id1.sdm') then
     depo.ListBox3.Items.LoadFromFile('sys\id1.sdm');
     if fileexists('sys\id21.sdm') then
     dp.ListBox2.Items.LoadFromFile('sys\id1.sdm');

   end;

end;

procedure TEDA.Memo1Change(Sender: TObject);
begin
  mz := true;
end;

procedure TEDA.MenuItem1Click(Sender: TObject);
var k,i,j : longint;
    s : string;
    s1: String;
begin
    s := '';
    k := strtoint(stringgrid1.Cells[1,stringgrid1.Row]);
    for i := 1 to depo.Memo1.Lines.Count - 1  do
    begin
        s1 := copy(depo.Memo1.Lines.Strings[i],1,pos(' ',depo.Memo1.Lines.Strings[i]) - 1);
        delete(s1,1,1);
        if s1 =  stringgrid1.Cells[0,stringgrid1.Row] then
        s := s + inttostr(i+1) + ' ';
    end;
    if s <> '' then
    depo.ListBox3.Items[k] := s;
    combobox1.Clear;
    stringgrid1click(sender);
end;

procedure TEDA.Button1Click(Sender: TObject);
var i : longint;
    s : string;
    z : boolean;
    d,x : longint;
    s2  : string;
begin
   mz := false;
   z := false;
   s := memo1.Text;
   while pos(#13,s) > 0 do
   begin
     insert('|',s,pos(#13,s));
     delete(s,pos(#13,s),1);
   end;
   while pos(#10,s) > 0 do
   begin
     insert('|',s,pos(#10,s));
     delete(s,pos(#10,s),1);
   end;
   s := copy(label1.Caption,pos('/',label1.Caption)+1,1) + stringgrid1.Cells[0,stringgrid1.Row] +
   ' [Edited at '+ datetostr(date) + ' ] ||'+s;
   if stringgrid2.RowCount > 0 then
   for i := 0 to stringgrid2.RowCount - 1 do
   if stringgrid2.Cells[0,i] = combobox1.Text then
   begin
     stringgrid2.Cells[1,i] := s;
     z := true;
   end;
   if z = false then
   begin
     stringgrid2.RowCount:= stringgrid2.RowCount + 1;
     stringgrid2.Cells[0,i] := combobox1.Text;
     stringgrid2.Cells[1,i] := s;
     stringgrid2.Cells[2,i] := inttostr(form1.ComboBox3.ItemIndex);
   end;
    stringgrid2.SaveToCSVFile('sys\dicx1.sdm','_',true);
    for i := 0 to stringgrid2.RowCount - 1 do
    if stringgrid2.Cells[0,i] <> '' then
    if stringgrid2.Cells[2,i] = '1' then
    begin
       dp.Memo1.Lines.Strings[strtoint(stringgrid2.Cells[0,i])-1] := stringgrid2.Cells[1,i];
       s2 := '';
       for d := 0 to combobox1.Items.Count - 1 do
       s2 := s2 + combobox1.Items[d]+ ' ';
       dp.ListBox2.Items[strtoint(stringgrid1.Cells[1,stringgrid1.Row])] := s2;
    end
    else
    begin
        depo.Memo1.Lines.Strings[strtoint(stringgrid2.Cells[0,i])-1] := stringgrid2.Cells[1,i];
        s2 := '';
        for d := 0 to combobox1.Items.Count - 1 do
        s2 := s2 + combobox1.Items[d]+ ' ';
        depo.ListBox3.Items[strtoint(stringgrid1.Cells[1,stringgrid1.Row])] := s2;
    end;
    stringgrid1.Cells[2,stringgrid1.Row] := combobox1.Items.CommaText;
end;

procedure TEDA.Button2Click(Sender: TObject);
begin
  if application.MessageBox('Are You sure you want to delete this article?','Confirm',36) = idyes then
  if combobox1.items.Count > 0 then
  begin
     combobox1.Items.Delete(combobox1.ItemIndex);
     combobox1.Itemindex := combobox1.Items.Count - 1;
     if combobox1.ItemIndex > - 1 then
     combobox1change(sender);
     button1click(sender);
  end;
end;

procedure TEDA.Button3Click(Sender: TObject);
var i : longint;
begin
    memo1.ReadOnly:=false;
    button1.Enabled:=true;;
    combobox1click(sender);
    if form1.ComboBox3.ItemIndex = 1 then
    begin
      for i := 70000 to 100000 do
      if dp.Memo1.Lines.Strings[i] = '' then
      break;
      maxE := i;
      if i < 100000 then
      begin
        dp.Memo1.Lines.Strings[i] := stringgrid1.Cells[0,stringgrid1.Row] + ' ';
        combobox1.Items.Add(inttostr(maxE));
        combobox1.ItemIndex := combobox1.items.Count - 1;
        combobox1change(sender);
        stringgrid1.Cells[2,stringgrid1.Row] := combobox1.Items.CommaText;
      end
      else Showmessage('Can not add an article. There is not a free slot');
    end
    else
    begin
      for i := 600000 to 700000 do
      if depo.Memo1.Lines.Strings[i] = '' then
      break;
      maxD := i;
      if i < 700000 then
      begin
         depo.Memo1.Lines.Strings[i] := stringgrid1.Cells[0,stringgrid1.Row] + ' ';
         combobox1.Items.Add(inttostr(maxD - 1));
         combobox1.ItemIndex := combobox1.items.Count - 1;
         combobox1change(sender);
         stringgrid1.Cells[2,stringgrid1.Row] := combobox1.Items.CommaText;
      end
      else Showmessage('Can not add an article. There is not a free slot');
    end;

end;

procedure TEDA.Button4Click(Sender: TObject);
begin
  if Application.MessageBox('Do You really want to DISCARD ALL CHANGES? your data will be saved to [sys\id1.sdb; sys\id2.sdb; dicx1.sdb]','Confirm',36) = idyes then
  begin
    stringgrid2.SaveToCSVFile('sys\dicx1.sdb');
    dp.listbox2.items.SaveToFile('sys\id1.sdb');
    depo.listbox2.items.SaveToFile('sys\id2.sdb');

    deletefile(pchar(getcurrentdir+'\sys\dicx1.sdm'));
    deletefile(pchar(getcurrentdir+'\sys\id1.sdm'));
    deletefile(pchar(getcurrentdir+'\sys\id2.sdm'));

    ShowMessage('The programme  will be restarted!');
    FL := false;
    halt(1);

  end;
end;

procedure TEDA.StringGrid1Click(Sender: TObject);
begin
if stringgrid1.Cells[2,stringgrid1.Row] <> '' then
begin
if mz then combobox1change(sender);
  combobox1.Clear;;
  combobox1.Items.CommaText:=stringgrid1.Cells[2,stringgrid1.Row];
  combobox1.ItemIndex:=0;
  combobox1change(sender);
end
else
begin
 memo1.Clear;;
 combobox1.Clear;
 label1.Caption:='/U';
 memo1.ReadOnly:=true;
 memo1.Text :='Add an Article';
 button1.Enabled:=false;
end;
end;

end.

