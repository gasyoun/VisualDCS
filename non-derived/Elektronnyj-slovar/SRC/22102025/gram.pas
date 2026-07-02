unit gram;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, Grids, Menus, shellapi;

type

  { TNN }

  TNN = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    EditButton1: TEditButton;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    StringGrid1: TStringGrid;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure EditButton1ButtonClick(Sender: TObject);
    procedure EditButton1Change(Sender: TObject);
    procedure EditButton1KeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
  private

  public

  end;

var
  NN: TNN;

implementation
uses gdepo, poisk,gfr;
{$R *.lfm}

{ TNN }
var ds : string = '';
procedure TNN.ComboBox1Change(Sender: TObject);
begin
  case combobox1.ItemIndex of
       0 :   combobox2.Items := gd.fitems.items;
       1 :   combobox2.Items := gd.mitems.Items;
       2 :   combobox2.Items := gd.nitems.Items;
  end;
  if combobox1.ItemIndex > 2 then
  combobox2.Clear;
  if combobox2.Items.Count > 0 then
  Combobox2.ItemIndex:=0;
  if combobox1.ItemIndex = 0 then ds := '01';
  if combobox1.ItemIndex = 1 then ds := '00';
  if combobox1.ItemIndex = 2 then ds := '02';
//  if combobox1.ItemIndex  in [4..7] then ds := '2';
case combobox1.ItemIndex of
     3 : ds := '2319';
     4 : ds := '2320';
     5 : ds := '2021';
     6 : ds := '2121';
     7 : ds := '2221';

end;

  if (combobox2.ItemIndex > - 1) or
     (combobox1.ItemIndex > 2) then
     combobox2change(sender);

end;

procedure TNN.ComboBox2Change(Sender: TObject);
var a  : word;
    z  : byte;

begin
  for a := 1 to 3 do
  for z := 1 to 16 do
  stringgrid1.Cells[a,z] := '';

  if ds = '00' then
  case combobox2.ItemIndex of
       0 : ds := ds + '0';
       1 : ds := ds + '2';
       2 : ds := ds + '4';
       3 : ds := ds + '8';
       4 : ds := ds + '9';
       5 : ds := ds + '10';
       6 : ds := ds + '12';
       7 : ds := ds + '14';
       8 : ds := ds + '16';
       9 : ds :=  '2018';


  end;

  if ds = '01' then
  case combobox2.ItemIndex of
       0 : ds := ds + '1';
       1 : ds := ds + '2';
       2 : ds := ds + '3';
       3 : ds := ds + '4';
       4 : ds := ds + '6';
       5 : ds := ds + '7';
       6 : ds := ds + '11';
       7 : ds := '0131';
  end;

  if ds = '02' then
  case combobox2.ItemIndex of
       0 : ds := ds + '2';
       1 : ds := ds + '4';
       2 : ds := ds + '9';

  end;



  z := 1;
  for a := 0 to 231 do
  with gd.StringGrid1 do
  if cells[3,a] = ds then
  begin

    stringgrid1.Cells[1,z*2 -1] := form1.convertx(cells[0,a]);
    stringgrid1.Cells[2,z*2 -1] := form1.convertx(cells[1,a]);
    stringgrid1.Cells[3,z*2 -1] := form1.convertx(cells[2,a]);

    stringgrid1.Cells[1,z*2] := form1.convertd(form1.convertx(cells[0,a]));
    stringgrid1.Cells[2,z*2] := form1.convertd(form1.convertx(cells[1,a]));
    stringgrid1.Cells[3,z*2] := form1.convertd(form1.convertx(cells[2,a]));
    inc(z);
  end;
  if combobox1.ItemIndex = 0 then ds := '01';
  if combobox1.ItemIndex = 1 then ds := '00';
  if combobox1.ItemIndex = 2 then ds := '02';


end;

procedure TNN.EditButton1ButtonClick(Sender: TObject);
var a : word;
    w : word;
    e,q:word;
    n, r , c, p  : string;
    z : word;
    prev : word;
    msg1 : string;
begin z := 1;

  prev := combobox1.ItemIndex;
  if editbutton1.Text <> '' then
  begin
    gres.show;



    gres.stringgrid1.rowcount := z;
    for a := 0 to combobox1.Items.Count  - 1 do
    begin
      combobox1.ItemIndex:=a;
      combobox1Change(sender);
      for w := 0 to combobox2.Items.Count do
      begin
        combobox2.ItemIndex:=w;
        combobox2change(sender);
        for  e := 1 to 8 do
        for  q := 1 to 3 do
        if pos(editbutton1.Text, stringgrid1.Cells[q,e*2-1]) > 1 then
        if pos(editbutton1.Text, stringgrid1.Cells[q,e*2-1])  =
           length(stringgrid1.Cells[q,e*2-1]) - length(editbutton1.Text) + 1
          then

           begin
             inc(z);
             gres.stringgrid1.rowcount := z;
             case a of
                  0 : begin
                      n := 'Noun';
                      r := 'f.';
                  end;
                  1 : begin  n := 'Noun';
                             r := 'm.';

                  end;
                  2 :  begin n := 'Noun';
                             r := 'n.';

                  end;
                  3 :  begin
                          n := 'Pn.1st.';
                          r := '';
                  end;
                  4 :  begin
                          n := 'Pn.2d';
                          r := '';
                  end;
                  5 :  begin
                        n := 'Pn. 3rd';
                        r := 'm.';
                  end;

                  6 : begin
                     n := 'Pn. 3rd';
                        r := 'f.';
                  end;
                  7 :  begin
                     n := 'Pn. 3rd';
                        r := 'n.';
                  end;

             end;
             case q of
                  1 : c := 'Sg';
                  2 : c := 'Du';
                  3 : c := 'Pl';

             end;
             p := stringgrid1.Cells[0,e*2-1];
             gres.stringgrid1.cells[0,z-1] := n;
             gres.stringgrid1.cells[1,z-1] := '';
             gres.stringgrid1.cells[2,z-1] := c;
             gres.stringgrid1.cells[3,z-1] := p;
             gres.stringgrid1.cells[1,z-1] := r;
             gres.stringgrid1.cells[4,z-1] := stringgrid1.Cells[q,e*2-1];
           end;
      end;
    end;
  end;
  combobox1.ItemIndex:=prev;
  combobox1change(sender);
  gres.Panel1.Caption:=msg1 + ' "' + editbutton1.Text+ '"';
  gres.StatusBar1.Panels[1].Text:=inttostr(gres.stringgrid1.RowCount - 1);
end;

procedure TNN.EditButton1Change(Sender: TObject);
var a,w : word;
begin
a := editbutton1.SelStart;
w := length(editbutton1.Text);
editbutton1.Text := form1.convertx(editbutton1.Text);
if w = length(editbutton1.Text) then editbutton1.SelStart:=a
else
  editbutton1.SelStart:=
  a - (w - length(editbutton1.Text));

  editbutton1.SetFocus;

end;

procedure TNN.EditButton1KeyPress(Sender: TObject; var Key: char);
begin
  if key in [#13,#10] then editbutton1buttonclick(sender);
end;

procedure TNN.FormCreate(Sender: TObject);
begin
    savedialog1.InitialDir:=cdir+'\Reports';
end;

procedure TNN.MenuItem1Click(Sender: TObject);
var zz : string;
    a  : longint;
begin
zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
      '<font face="Mangal" size = "2">' +
      '<center><b>The grammar table:  </b></center><left>' +
      '<p>' + combobox1.Text + '<p>' + combobox2.Text + '<p>' +
      '<table width = "100%" rules = "ALL" border = "2">';

zz := zz + '<td width = "10%"><b>Case</td><td width = "30%">Single</td><td width = "30%">Dual</td><td width = "30%">Plural</td></b><tr>';
    for a := 1 to 16 do
    begin
      zz := zz +
      '<td width = "10">' + stringgrid1.Cells[0,a] + '</td>' +
      '<td width = "30">' + stringgrid1.Cells[1,a] + '</td>' +
      '<td width = "30">' + stringgrid1.Cells[2,a] + '</td>' +
      '<td width = "30">' + stringgrid1.Cells[3,a] + '</td>' + '<tr>';


    end;
    zz := zz + '</table></body></html>';
    memo1.Text:=zz;
    if savedialog1.Execute then
    begin
      memo1.Lines.SaveToFile(savedialog1.FileName);
      if form1.CheckBox7.Checked then
      shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
    end;


end;

procedure TNN.MenuItem2Click(Sender: TObject);
var zz : string;
    a  : longint;
    c,x,y: longint;

begin
zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
      '<font face="Mangal" size = "2">' +
      '<center><b>The grammar table:  </b></center><left>';


for x := 0 to combobox1.Items.Count - 1 do
begin
    combobox1.ItemIndex:=x;
    combobox1change(sender);
if combobox2.Items.Count > 0 then
   c := combobox2.Items.Count -  1
   else
     c := 0;

for y := 0 to c do
begin
   if c > 0 then
   begin
      combobox2.ItemIndex:=y;
      combobox2change(sender);

   end;

  zz := zz  +        '<p><b>' + combobox1.Text + '<p>' + combobox2.Text + '</b><p>' +
      '<table width = "100%" rules = "ALL" border = "2">';
     zz := zz + '<td width = "10%"><b>Case</td><td width = "30%">Single</td><td width = "30%">Dual</td><td width = "30%">Plural</td></b><tr>';
    for a := 1 to 16 do
    begin
      zz := zz +
      '<td width = "10">' + stringgrid1.Cells[0,a] + '</td>' +
      '<td width = "30">' + stringgrid1.Cells[1,a] + '</td>' +
      '<td width = "30">' + stringgrid1.Cells[2,a] + '</td>' +
      '<td width = "30">' + stringgrid1.Cells[3,a] + '</td>' + '<tr>';

    end;
    zz := zz + '</table><p>';
end;
end;
    zz := zz + '</body></HTML>';
    memo1.Text:=zz;
    if savedialog1.Execute then
    begin
      memo1.Lines.SaveToFile(savedialog1.FileName);
      if form1.CheckBox7.Checked then
      shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
    end;



end;

end.

