unit ched1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Grids;

type

  { Tchd }

  Tchd = class(TForm)
    Button1: TButton;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    StatusBar3: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
  private

  public
    procedure chedx(k1,k2 : tstringgrid);
  end;

var
  chd: Tchd;


implementation
uses dmk1,kn;
{$R *.lfm}
var
Kk,kk1 : array[1..3] of tstringgrid;
procedure Tchd.ComboBox2Change(Sender: TObject);
var k : tstringgrid;
    c,i,j : word;
begin
   kkn.Button3Click(sender);
   stringgrid1 := kk[1]; stringgrid2:=kk[2];stringgrid3:=kk[3];

   if combobox2.ItemIndex <> 0 then
   for c := 1 to 3 do
   begin
     if c = 1 then k := kk[1];
     if c = 2 then k := kk[2];
     if c = 3 then k := kk[3];
     j := 1;

     for i := 1 to kk[c].RowCount - 1 do
     if combobox2.ItemIndex = 1 then
     begin
        if kk[c].Cells[3,i]='v' then
        begin
          k.Rows[j] := kk[c].Rows[i];
          inc(j);
       end
     end
     else
     if combobox2.ItemIndex = 2 then
     if kk[c].Cells[3,i]<>'v' then
     begin
       k.Rows[j] := kk[c].Rows[i];
       inc(j);
    end;
    k.RowCount:=j;
    case c of
    1 : stringgrid1 :=k;
    2 : stringgrid2 :=k;
    3 : stringgrid3 :=k;
   end;
   end
   else
   begin
      stringgrid1 := kk[1];
      stringgrid2 := kk[2];
      stringgrid3 := kk[3];
    end;
//   stringgrid1.Row:=0;   stringgrid2.Row:=0;   stringgrid3.Row:=0;
   statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount - 1);
   statusbar2.Panels[1].Text:=inttostr(stringgrid2.RowCount - 1);
   statusbar3.Panels[1].Text:=inttostr(stringgrid3.RowCount - 1);
   kk := kk1;
end;

procedure Tchd.Edit1Change(Sender: TObject);
var i : word;
begin
  edit1.Text := kkn.convertX(edit1.Text);
  if length(edit1.Text) > 0 then
  edit1.SelStart := length(edit1.text);
  for i := 0 to stringgrid1.RowCount - 1 do
  if pos(edit1.Text,stringgrid1.Cells[2,i]) = 1 then
  begin
     stringgrid1.Row:=i;
     break;
  end;
end;

procedure Tchd.Edit2Change(Sender: TObject);
var i : word;
begin
  edit2.Text := kkn.convertX(edit2.Text);
  if length(edit2.Text) > 0 then
  edit2.SelStart := length(edit2.text);
  for i := 0 to stringgrid2.RowCount - 1 do
  if pos(edit2.Text,stringgrid2.Cells[2,i]) = 1 then
  begin
     stringgrid2.Row:=i;
     break;
  end;


end;

procedure Tchd.Edit3Change(Sender: TObject);
  var i : word;
begin
  edit3.Text := kkn.convertX(edit3.Text);
  if length(edit3.Text) > 0 then
  edit3.SelStart := length(edit3.text);
  for i := 0 to stringgrid3.RowCount - 1 do
  if pos(edit3.Text,stringgrid3.Cells[2,i]) = 1 then
  begin
     stringgrid3.Row:=i;
     break;
  end;
end;




procedure Tchd.Button1Click(Sender: TObject);
begin
  Stringgrid1.SaveToCSVFile('Reports\Lost_Lex_'+kkn.ComboBox1.Text+'.txt',#9);
  Stringgrid2.SaveToCSVFile('Reports\X_Lex_'+kkn.ComboBox1.Text+'_'+kkn.ComboBox_.Text+'.txt',#9);
  Stringgrid3.SaveToCSVFile('Reports\New_Lex_'+kkn.ComboBox_.Text+'_R_'+kkn.ComboBox1.Text+'.txt',#9);
  Showmessage('The data saved to the folder  "Reports"');
end;

procedure tchd.chedx(k1,k2 : tstringgrid);
var c,a,i,j : word;
    s,s1 : string;
    z : boolean;
begin
    stringgrid1.RowCount:=7600;
    stringgrid2.RowCount:=7600;
    stringgrid3.RowCount:=7600;
if (kkn.ComboBox1.ItemIndex <> 0) then
    k1.RowCount:=ptk[kkn.combobox1.ItemIndex];

if (kkn.ComboBox_.ItemIndex <> 0) then
    k2.RowCount:=ptk[kkn.combobox_.ItemIndex];;
    c := 1;
    a := 1;

    for i := 0 to k1.RowCount - 1 do
    begin
      s := k1.Cells[0,i];s1 := k1.Cells[1,i];
      z := false;
      for j := 0 to k2.RowCount - 1 do
      if (s = k2.Cells[0,j]) and (s1 = k2.Cells[1,j]) then
      begin
        z := true;
        stringgrid2.Cells[2,c] := s;
        stringgrid2.Cells[3,c] := s1;
        stringgrid2.Cells[4,c] := inttostr(round((i+j)/2));
        inc(c);
        break;
      end;
      if z = false then
      begin
        stringgrid1.Cells[2,a] := s;
        stringgrid1.Cells[3,a] := s1;
        stringgrid1.Cells[4,a] := inttostr(i);
        inc(a);
      end;
    end;
    if z = false then dec(a);
    stringgrid1.RowCount:=a+1;
    stringgrid2.RowCount:=c+1;
    statusbar1.Panels[1].Text:=inttostr(a-1);
    statusbar2.Panels[1].Text:=inttostr(c-1);


    c := 1;
    a := 1;
    for i := 0 to k2.RowCount - 1 do
    begin
      s := k2.Cells[0,i];s1 := k2.Cells[1,i];
      z := false;
      for j := 0 to k1.RowCount - 1 do
      if (s = k1.Cells[0,j]) and (s1 = k1.Cells[1,j]) then
      begin
        z := true;
        break;
      end;
      if z = false then
      begin
        stringgrid3.Cells[2,a] := s;
        stringgrid3.Cells[3,a] := s1;
        stringgrid3.Cells[4,a] := inttostr(i);
        inc(a);
      end;
    end;
    if z = false then dec(a);
    stringgrid3.RowCount:=a+1;
    statusbar3.Panels[1].Text:=inttostr(a-1);

    statusbar1.Panels[3].Text:=inttostr(kkn.UpDown1.Position);
    statusbar2.Panels[3].Text:=inttostr(kkn.UpDown1.Position);
    statusbar3.Panels[3].Text:=inttostr(kkn.UpDown1.Position);



    kk[1] := stringgrid1;
    kk[2] := stringgrid2;
    kk[3] := stringgrid3;

    kk1 := kk;






end;

end.

