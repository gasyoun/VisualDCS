unit ver1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  EditBtn, StdCtrls, Grids, Menus;

type

  { Tvr }

  Tvr = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    EditButton1: TEditButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure EditButton1ButtonClick(Sender: TObject);
    procedure EditButton1Change(Sender: TObject);
    procedure EditButton1KeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
  private

  public
      procedure showtable;
  end;

var
  vr: Tvr;

implementation
uses gdepo,poisk,gfr,gram,shellapi;
var ds : string;
{$R *.lfm}

{ Tvr }

procedure Tvr.ComboBox1Change(Sender: TObject);
begin
  ds := inttostr(combobox1.ItemIndex)+inttostr(combobox2.ItemIndex);
  showtable;
end;

procedure Tvr.ComboBox2Change(Sender: TObject);
begin
  ds := inttostr(combobox1.ItemIndex)+inttostr(combobox2.ItemIndex);
  showtable;
end;

procedure Tvr.EditButton1ButtonClick(Sender: TObject);
var a : word;
    z : word;
    q : word = 1;
    dx : string; df : string;
begin
    gres.StringGrid1.RowCount:=1;
    editbutton1.Text := form1.convertd(editbutton1.Text);
    for a := 0 to gd.StringGrid2.RowCount -1 do
    for z := 0 to 2 do
    if pos(editbutton1.Text, gd.stringgrid2.Cells[z,a]) > 1 then
        if pos(editbutton1.Text, gd.stringgrid2.Cells[z,a])  =
           length(gd.stringgrid2.Cells[z,a]) - length(editbutton1.Text) + 1
          then
    begin
      inc(q);
      case gd.StringGrid2.Cells[3,a][3] of
           '0' : dx := 'Par.';
           '1' : dx := 'Atm.';
           '2' : dx := 'Pass.';

      end;
      case z of
           0 : df := 'Sg.';
           1 : df := 'Du.';
           2 : df := 'Pl.';
      end;

      gres.StringGrid1.RowCount:=q;
      gres.StringGrid1.Cells[0,q-1] := combobox1.Items[strtoint(copy(gd.StringGrid2.Cells[3,a],1,1))];
      gres.StringGrid1.Cells[1,q-1] := combobox2.Items[strtoint(copy(gd.StringGrid2.Cells[3,a],2,1))] + ' '+dx;
      gres.StringGrid1.Cells[2,q-1] := inttostr(a mod 3 + 1);
      gres.StringGrid1.Cells[3,q-1] := df;
      gres.StringGrid1.Cells[4,q-1] := gd.StringGrid2.Cells[z,a];

    end;
    gres.StringGrid1.columns[0].Title.Caption := 'Class';
    gres.StringGrid1.columns[1].Title.Caption  := 'Time';
    gres.StringGrid1.columns[2].Title.Caption := 'Pers.';
    gres.StringGrid1.columns[3].Title.Caption  := 'Numbrt';
    gres.panel1.Caption:='Verbs Conyugations Ending by "'+ editbutton1.Text +'"' ;


    gres.StatusBar1.Panels[1].Text:=inttostr(gres.stringgrid1.RowCount - 1);

    gres.Show;
//    gres.BringToFront;
    vr.SendToBack;
end;

procedure Tvr.EditButton1Change(Sender: TObject);
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

procedure Tvr.EditButton1KeyPress(Sender: TObject; var Key: char);
begin
  if key in [#13,#10] then editbutton1buttonclick(sender);
end;

procedure Tvr.FormActivate(Sender: TObject);
begin
  combobox1change(sender);
  combobox2change(sender);

end;

procedure Tvr.Label4Click(Sender: TObject);
begin
// shellexecute(handle,'open',pchar(label2.Caption),nil,nil,1);
   shellexecute(handle,'open','https://sanskrit.inria.fr/DICO/grammar.html',nil,nil,1);
end;

procedure Tvr.MenuItem1Click(Sender: TObject);
var zz : string;
    a  : longint;
begin
zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
      '<font face="Mangal" size = "2">' +
      '<b>Verb_Class: '+combobox1.Text +'<p>' +
      'Time/inclination: ' + combobox2.Text + '<p></b>'+

      '<p><b>Parasmaipada</b><p>' +

      '<table width = "100%" rules = "ALL" border = "2">';

zz := zz + '<td width = "10%"><b>'+stringgrid1.cells[0,0] +
      '</td><td width = "30%">'+stringgrid1.Columns[0].Title.Caption+
      '</td><td width = "30%">'+stringgrid1.Columns[1].Title.Caption+
      '</td><td width = "30%">'+stringgrid1.Columns[2].Title.Caption+
      '</td><tr>';

    for a := 1 to stringgrid1.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid1.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid1.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid1.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid1.Cells[3,a] +
            '</td><tr>';
    end;

    zz := zz + '</table><p><b>Atmanepada</b><p>' +
    '<table width = "100%" rules = "ALL" border = "2">';



    zz := zz + '<td width = "10%"><b>'+stringgrid2.cells[0,0] +
          '</td><td width = "30%">'+stringgrid2.Columns[0].Title.Caption+
          '</td><td width = "30%">'+stringgrid2.Columns[1].Title.Caption+
          '</td><td width = "30%">'+stringgrid2.Columns[2].Title.Caption+
          '</td><tr>';


    for a := 1 to stringgrid2.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid2.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid2.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid2.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid2.Cells[3,a] +
            '</td><tr>';


    end;

    zz := zz + '</table><p><b>Passive<p></b>' +
    '<table width = "100%" rules = "ALL" border = "2">';

    zz := zz + '<td width = "10%"><b>'+stringgrid3.cells[0,0] +
          '</td><td width = "30%">'+stringgrid3.Columns[0].Title.Caption+
          '</td><td width = "30%">'+stringgrid3.Columns[1].Title.Caption+
          '</td><td width = "30%">'+stringgrid3.Columns[2].Title.Caption+
          '</td><tr>';



    for a := 1 to stringgrid3.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid3.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid3.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid3.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid3.Cells[3,a] +
            '</td><tr>';


    end;
    zz := zz + '</table></body></html>';
    nn.memo1.Text:=zz;
    if nn.savedialog1.Execute then
    begin
       nn.memo1.Lines.SaveToFile(nn.savedialog1.FileName);
       if form1.CheckBox7.Checked then
       shellexecute(0,'Open',pchar(nn.savedialog1.FileName),'',nil,1);
    end;




end;

procedure Tvr.MenuItem2Click(Sender: TObject);
var zz : string;
    a  : longint;
    x, y  : word;
begin
zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>';
y := 0;
for x := 0 to combobox1.Items.Count - 1 do

begin
      combobox1.ItemIndex:=x;
      combobox2.ItemIndex:=y;

      combobox1change(sender);
      combobox2change(sender);

      zz := zz +
      '<font face="Mangal" size = "2">' +
      '<b>Verb_Class: '+combobox1.Text +'<p>' +
      'Time/inclination: ' + combobox2.Text + '<p></b>'+

      '<p><b>Parasmaipada</b><p>' +

      '<table width = "100%" rules = "ALL" border = "2">';

zz := zz + '<td width = "10%"><b>'+stringgrid1.cells[0,0] +
      '</td><td width = "30%">'+stringgrid1.Columns[0].Title.Caption+
      '</td><td width = "30%">'+stringgrid1.Columns[1].Title.Caption+
      '</td><td width = "30%">'+stringgrid1.Columns[2].Title.Caption+
      '</td><tr>';

    for a := 1 to stringgrid1.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid1.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid1.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid1.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid1.Cells[3,a] +
            '</td><tr>';
    end;

    zz := zz + '</table><p><b>Atmanepada</b><p>' +
    '<table width = "100%" rules = "ALL" border = "2">';



    zz := zz + '<td width = "10%"><b>'+stringgrid2.cells[0,0] +
          '</td><td width = "30%">'+stringgrid2.Columns[0].Title.Caption+
          '</td><td width = "30%">'+stringgrid2.Columns[1].Title.Caption+
          '</td><td width = "30%">'+stringgrid2.Columns[2].Title.Caption+
          '</td><tr>';


    for a := 1 to stringgrid2.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid2.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid2.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid2.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid2.Cells[3,a] +
            '</td><tr>';


    end;

    zz := zz + '</table><p><b>Passive<p></b>' +
    '<table width = "100%" rules = "ALL" border = "2">';

    zz := zz + '<td width = "10%"><b>'+stringgrid3.cells[0,0] +
          '</td><td width = "30%">'+stringgrid3.Columns[0].Title.Caption+
          '</td><td width = "30%">'+stringgrid3.Columns[1].Title.Caption+
          '</td><td width = "30%">'+stringgrid3.Columns[2].Title.Caption+
          '</td><tr>';



    for a := 1 to stringgrid3.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid3.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid3.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid3.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid3.Cells[3,a] +
            '</td><tr>';


    end;
    zz := zz + '</table></body></html>';
end;
    nn.memo1.Text:=zz;
    if nn.savedialog1.Execute then
    begin
      nn.memo1.Lines.SaveToFile(nn.savedialog1.FileName);
      if form1.CheckBox7.Checked then
      shellexecute(0,'Open',pchar(nn.savedialog1.FileName),'',nil,1);
    end;






end;

procedure Tvr.MenuItem3Click(Sender: TObject);
var zz : string;
    a  : longint;
    x, y  : word;
begin
zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>';

x := 0;
for y := 0 to combobox2.Items.Count - 1 do
begin
      combobox1.ItemIndex:=x;
      combobox2.ItemIndex:=y;

      combobox1change(sender);
      combobox2change(sender);

      zz := zz +
      '<font face="Mangal" size = "2">' +
      '<b>Verb_Class: '+combobox1.Text +'<p>' +
      'Time/inclination: ' + combobox2.Text + '<p></b>'+

      '<p><b>Parasmaipada</b><p>' +

      '<table width = "100%" rules = "ALL" border = "2">';

zz := zz + '<td width = "10%"><b>'+stringgrid1.cells[0,0] +
      '</td><td width = "30%">'+stringgrid1.Columns[0].Title.Caption+
      '</td><td width = "30%">'+stringgrid1.Columns[1].Title.Caption+
      '</td><td width = "30%">'+stringgrid1.Columns[2].Title.Caption+
      '</td><tr>';

    for a := 1 to stringgrid1.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid1.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid1.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid1.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid1.Cells[3,a] +
            '</td><tr>';
    end;

    zz := zz + '</table><p><b>Atmanepada</b><p>' +
    '<table width = "100%" rules = "ALL" border = "2">';



    zz := zz + '<td width = "10%"><b>'+stringgrid2.cells[0,0] +
          '</td><td width = "30%">'+stringgrid2.Columns[0].Title.Caption+
          '</td><td width = "30%">'+stringgrid2.Columns[1].Title.Caption+
          '</td><td width = "30%">'+stringgrid2.Columns[2].Title.Caption+
          '</td><tr>';


    for a := 1 to stringgrid2.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid2.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid2.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid2.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid2.Cells[3,a] +
            '</td><tr>';


    end;

    zz := zz + '</table><p><b>Passive<p></b>' +
    '<table width = "100%" rules = "ALL" border = "2">';

    zz := zz + '<td width = "10%"><b>'+stringgrid3.cells[0,0] +
          '</td><td width = "30%">'+stringgrid3.Columns[0].Title.Caption+
          '</td><td width = "30%">'+stringgrid3.Columns[1].Title.Caption+
          '</td><td width = "30%">'+stringgrid3.Columns[2].Title.Caption+
          '</td><tr>';



    for a := 1 to stringgrid3.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid3.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid3.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid3.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid3.Cells[3,a] +
            '</td><tr>';


    end;
    zz := zz + '</table></body></html>';
end;
    nn.memo1.Text:=zz;
    if nn.savedialog1.Execute then
    begin
      nn.memo1.Lines.SaveToFile(nn.savedialog1.FileName);
      if form1.CheckBox7.Checked then
      shellexecute(0,'Open',pchar(nn.savedialog1.FileName),'',nil,1);
    end;






end;

procedure Tvr.MenuItem4Click(Sender: TObject);
var zz : string;
    a  : longint;
    x, y  : word;
begin
zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>';

for x := 0 to combobox1.Items.Count - 1 do
for y := 0 to combobox2.Items.Count - 1 do
begin
      combobox1.ItemIndex:=x;
      combobox2.ItemIndex:=y;

      combobox1change(sender);
      combobox2change(sender);

      zz := zz +
      '<font face="Mangal" size = "2">' +
      '<b>Verb_Class: '+combobox1.Text +'<p>' +
      'Time/inclination: ' + combobox2.Text + '<p></b>'+

      '<p><b>Parasmaipada</b><p>' +

      '<table width = "100%" rules = "ALL" border = "2">';

zz := zz + '<td width = "10%"><b>'+stringgrid1.cells[0,0] +
      '</td><td width = "30%">'+stringgrid1.Columns[0].Title.Caption+
      '</td><td width = "30%">'+stringgrid1.Columns[1].Title.Caption+
      '</td><td width = "30%">'+stringgrid1.Columns[2].Title.Caption+
      '</td><tr>';

    for a := 1 to stringgrid1.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid1.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid1.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid1.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid1.Cells[3,a] +
            '</td><tr>';
    end;

    zz := zz + '</table><p><b>Atmanepada</b><p>' +
    '<table width = "100%" rules = "ALL" border = "2">';



    zz := zz + '<td width = "10%"><b>'+stringgrid2.cells[0,0] +
          '</td><td width = "30%">'+stringgrid2.Columns[0].Title.Caption+
          '</td><td width = "30%">'+stringgrid2.Columns[1].Title.Caption+
          '</td><td width = "30%">'+stringgrid2.Columns[2].Title.Caption+
          '</td><tr>';


    for a := 1 to stringgrid2.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid2.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid2.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid2.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid2.Cells[3,a] +
            '</td><tr>';


    end;

    zz := zz + '</table><p><b>Passive<p></b>' +
    '<table width = "100%" rules = "ALL" border = "2">';

    zz := zz + '<td width = "10%"><b>'+stringgrid3.cells[0,0] +
          '</td><td width = "30%">'+stringgrid3.Columns[0].Title.Caption+
          '</td><td width = "30%">'+stringgrid3.Columns[1].Title.Caption+
          '</td><td width = "30%">'+stringgrid3.Columns[2].Title.Caption+
          '</td><tr>';



    for a := 1 to stringgrid3.RowCount - 1 do
    begin
      zz := zz + '<td width = "10%"><b>'+stringgrid3.Cells[0,a]+
            '</td><td width = "30%">'+stringgrid3.Cells[1,a] +
            '</td><td width = "30%">'+stringgrid3.Cells[2,a] +
            '</td><td width = "30%">'+stringgrid3.Cells[3,a] +
            '</td><tr>';


    end;
    zz := zz + '</table></body></html>';
end;
    nn.memo1.Text:=zz;
    if nn.savedialog1.Execute then
    begin
      nn.memo1.Lines.SaveToFile(nn.savedialog1.FileName);
      if form1.CheckBox7.Checked then
      shellexecute(0,'Open',pchar(nn.savedialog1.FileName),'',nil,1);
    end;





end;

procedure tvr.showtable;
var a,z : word;
begin
 stringgrid1.RowCount:=1;
 stringgrid2.RowCount:=1;
 stringgrid3.RowCount:=1;
 for z := 0 to gd.stringgrid2.rowcount - 1 do
 if pos(ds,gd.StringGrid2.Cells[3,z]) = 1 then
 begin

   if z < gd.StringGrid2.RowCount - 1 -2 then
   for a := 0 to 2 do
   if pos(ds,gd.StringGrid2.Cells[3,z+a]) = 1 then
   begin
       stringgrid1.RowCount:=4;
       stringgrid1.Cells[0,0] := 'Pers.';
       stringgrid1.Cells[0,1] := '1';
       stringgrid1.Cells[0,2] := '2';
       stringgrid1.Cells[0,3] := '3';

       stringgrid1.Cells[1,a+1] := gd.StringGrid2.Cells[0,z+a];
       stringgrid1.Cells[2,a+1] := gd.StringGrid2.Cells[1,z+a];
       stringgrid1.Cells[3,a+1] := gd.StringGrid2.Cells[2,z+a];
   end
   else
    stringgrid1.RowCount:=1;
   if z < gd.StringGrid2.RowCount - 1 -5 then
   for a := 3 to 5 do
   if pos(ds,gd.StringGrid2.Cells[3,z+a]) = 1 then
   begin
     stringgrid2.RowCount:=4;

     stringgrid2.Cells[0,0] := 'Pers.';
     stringgrid2.Cells[0,1] := '1';
     stringgrid2.Cells[0,2] := '2';
     stringgrid2.Cells[0,3] := '3';

       stringgrid2.Cells[1,a-2] := gd.StringGrid2.Cells[0,z+a];
       stringgrid2.Cells[2,a-2] := gd.StringGrid2.Cells[1,z+a];
       stringgrid2.Cells[3,a-2] := gd.StringGrid2.Cells[2,z+a];
   end
   else
    stringgrid2.RowCount:=1;
   if z < gd.StringGrid2.RowCount - 1 - 8 then
   for a := 6 to 8 do
      if pos(ds,gd.StringGrid2.Cells[3,z+a]) = 1 then
      begin
        stringgrid3.RowCount:=4;

        stringgrid3.Cells[0,0] := 'Pers.';
        stringgrid3.Cells[0,1] := '1';
        stringgrid3.Cells[0,2] := '2';
        stringgrid3.Cells[0,3] := '3';


          stringgrid3.Cells[1,a-5] := gd.StringGrid2.Cells[0,z+a];
          stringgrid3.Cells[2,a-5] := gd.StringGrid2.Cells[1,z+a];
          stringgrid3.Cells[3,a-5] := gd.StringGrid2.Cells[2,z+a];
      end
      else
      stringgrid3.RowCount:=1;
      break;

 end;

end;

end.

