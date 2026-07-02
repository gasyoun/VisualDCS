unit ngh;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, EditBtn, ComCtrls, Grids, Menus;

type

  { Tng }

  Tng = class(TForm)
    ComboBox1: TComboBox;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
  private

  public

  end;

var
  ng: Tng;

implementation
uses poisk;
{$R *.lfm}

{ Tng }

procedure Tng.FormCreate(Sender: TObject);
var i : word;
    s : string;
begin
    stringgrid2.RowCount:=memo1.Lines.Count;
    stringgrid1.RowCount:=stringgrid2.RowCount+1;
    for i := 0 to memo1.Lines.Count - 1 do
    begin
      s := memo1.Lines.Strings[i];
      stringgrid2.Cells[0,i] := copy(s,1,pos('_',s)-1);
      delete(s,1,pos('_',s));
      stringgrid2.Cells[1,i] := form1.convertd(form1.convertx(s));
      stringgrid2.Cells[2,i] := form1.convertx(s);
      stringgrid1.Cells[0,i+1] := stringgrid2.Cells[1,i];
      stringgrid1.Cells[1,i+1] := stringgrid2.Cells[2,i];
      stringgrid1.Cells[2,i+1] := stringgrid2.Cells[0,i];
    end;
    statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount-1);
end;

procedure Tng.MenuItem1Click(Sender: TObject);
begin

end;

procedure Tng.StringGrid1Click(Sender: TObject);
var syn : string;
    gr  : string;
    i   : longint;
    j   : longint;
begin

    syn := '';
    label2.Caption:=stringgrid1.Cells[0,stringgrid1.Row] +  ' - ' + stringgrid1.Cells[1,stringgrid1.Row];
    memo2.Clear;
if combobox1.ItemIndex > 0 then
begin
    memo2.Lines.Add('Group Name: ' + combobox1.Text);
    memo2.Lines.Add('Synonims for ' + stringgrid1.Cells[0,stringgrid1.Row] +  ' - ' + stringgrid1.Cells[1,stringgrid1.Row]+':');
    for i := 1 to stringgrid1.RowCount - 1 do
    if i <> stringgrid1.Row then
    begin
      if stringgrid1.columns[0].Visible then
      syn := syn + stringgrid1.cells[0,i] + '  ';

      if stringgrid1.columns[1].Visible then
      syn := syn + stringgrid1.cells[1,i] + '  ';

    end;
    memo2.Lines.Add(syn);
end;
    gr := '';
    for i := 0 to stringgrid2.RowCount - 1 do
    begin
      if pos(stringgrid1.Cells[1,stringgrid1.Row],stringgrid2.Cells[2,i]) = 1 then
      begin
         gr := gr + combobox1.Items[strtoint(stringgrid2.Cells[0,i])] + #13+#10;
      end;
    end;
    if gr <> '' then
    begin
       memo2.Lines.Add('This Word has bounds with the folowing groups:');
       memo2.Lines.Add(gr);
    end;
    if combobox1.ItemIndex <> 0 then
    begin
       memo2.Lines.Add('The group "'+combobox1.text+'" has bounds with folowing groups:');
       gr := '';
       for j := 1 to stringgrid1.rowcount - 1 do
       for i := 0 to stringgrid2.RowCount - 1 do
       begin
         if pos(stringgrid1.Cells[1,j],stringgrid2.Cells[2,i]) = 1 then
         begin
            if pos(combobox1.Items[strtoint(stringgrid2.Cells[0,i])],gr) = 0 then
            gr := gr + combobox1.Items[strtoint(stringgrid2.Cells[0,i])] + #13+#10;
         end;
       end;
       memo2.Lines.Add(gr);
    end;
end;

procedure Tng.ComboBox1Change(Sender: TObject);
var i : longint;
    j : longint;
begin
    stringgrid1.RowCount:=1;
    if combobox1.ItemIndex= 0 then formcreate(sender)
    else
      for i := 0 to stringgrid2.RowCount - 1 do
      if inttostr(combobox1.ItemIndex) = stringgrid2.Cells[0,i] then
      begin
        stringgrid1.RowCount:=stringgrid1.RowCount + 1;
        j := stringgrid1.RowCount - 1;
        stringgrid1.Cells[0,j] := stringgrid2.Cells[1,i];
        stringgrid1.Cells[1,j] := stringgrid2.Cells[2,i];
        stringgrid1.Cells[2,j] := stringgrid2.Cells[0,i];
      end;
    statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount-1);
end;

procedure Tng.Edit2Change(Sender: TObject);
var id1 : byte;
    a,w : word;
begin
   a := edit2.SelStart;
   w := length(edit2.Text);
   Edit2.Text := form1.convertx(edit2.Text);
   if w = length(edit2.Text) then edit2.SelStart:=a
   else   edit2.SelStart:= a - (w - length(edit2.Text));
   edit2.SetFocus;
if combobox1.ItemIndex = 0 then
begin
   stringgrid1.RowCount:=1;
   for w := 0 to stringgrid2.RowCount - 1 do
   if (pos(edit2.Text,stringgrid2.Cells[1,w]) =1) or
      (pos(edit2.Text,stringgrid2.Cells[2,w]) =1) then
      begin
        stringgrid1.RowCount:=
        stringgrid1.RowCount + 1;
        stringgrid1.Cells[0,stringgrid1.RowCount - 1] :=
        stringgrid2.Cells[1,w];
        stringgrid1.Cells[1,stringgrid1.RowCount - 1] :=
        stringgrid2.Cells[2,w];
        stringgrid1.Cells[2,stringgrid1.RowCount - 1] :=
        stringgrid2.Cells[0,w];
      end;
  end
else
  for w := 1 to stringgrid1.RowCount - 1 do
  if  (pos(edit2.Text,stringgrid1.Cells[0,w]) =1) or
      (pos(edit2.Text,stringgrid1.Cells[1,w]) =1) then
      begin
        stringgrid1.Row:=w;
        break;;
      end;
      statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount-1);
end;

end.

