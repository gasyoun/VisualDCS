unit grmx;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids;

type

  { Twc }

  Twc = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure prep1;
    procedure fill1(s1 : string; n : word);
    procedure mx;
    procedure fx;
    procedure nx;
    procedure clx(s,s1,s2 : string);
  private

  public

  end;

var
  wc: Twc;

implementation
uses depo2,poisk,gdepo;
{$R *.lfm}

{ Twc }

procedure Twc.Button1Click(Sender: TObject);
begin
  wc.Hide;
end;

procedure Twc.Button2Click(Sender: TObject);
var k,k1 : string;
begin
  k := form1.Stringgrid1.Cells[4,form1.Stringgrid1.Row];
  if pos('m.',form1.Stringgrid1.Cells[4,form1.Stringgrid1.Row]) > 0 then mx;
  if pos('f.',form1.Stringgrid1.Cells[4,form1.Stringgrid1.Row]) > 0 then fx;
  if pos('n.',form1.Stringgrid1.Cells[4,form1.Stringgrid1.Row]) > 0 then nx;
  if pos('cl.',form1.Stringgrid1.Cells[4,form1.Stringgrid1.Row]) > 0 then
  begin
    delete(k,1,pos('cl.',k) + 2);
    k1 := copy(k,1,pos('.',k));

    delete(k,1,pos('.',k));
    clx(form1.Stringgrid1.Cells[1,form1.Stringgrid1.Row],k1,k);

  end;

end;

procedure Twc.ComboBox1Change(Sender: TObject);
begin
  case combobox1.ItemIndex of
  0 : begin
         label3.Caption:='Conjugation Class';
         combobox2.ItemIndex:=5;
         combobox3.Show;
         label4.Show;;
      end;
  1 : begin
        label3.Caption:='Noun Kind';
        combobox2.ItemIndex:=0;
        combobox3.Hide;
        label4.Hide;
      end;
  2 : begin
        combobox3.Hide;
        label4.Hide;
        combobox2.ItemIndex:=15;
        label3.Caption:='Partic';
      end;
  3 : begin
        combobox3.Hide;
        label4.Hide;
        combobox2.ItemIndex:=1;
        label3.Caption:='Pron.';
      end;
  4 : begin
        combobox3.Hide;
        label4.Hide;
        combobox2.ItemIndex:=15;
        label3.Caption:='Other..';
      end;

  end;
end;

procedure Twc.ComboBox2Change(Sender: TObject);
begin
  if combobox2.ItemIndex in [5..14] then
  begin
    combobox1.ItemIndex:=0;
    combobox3.Show;
    label4.Show;

  end
  else
  begin
    combobox3.hide;
    label4.Hide;
    if combobox1.ItemIndex = 0 then
    combobox1.ItemIndex:=1;
  end;
end;
procedure twc.prep1;
begin
  stringgrid1.ColCount:=4;
  stringgrid1.RowCount:=9;
  stringgrid1.Defaultcolwidth := (stringgrid1.Width - 30) div 4;
  stringgrid1.Cells[0,0] := 'Case';
  stringgrid1.Cells[1,0] := 'Single';
  stringgrid1.Cells[2,0] := 'Dual';
  stringgrid1.Cells[3,0] := 'Plural';
  stringgrid1.Cells[0,1] := 'Nom.';
  stringgrid1.Cells[0,2] := 'Voc.';
  stringgrid1.Cells[0,3] := 'Acc.';
  stringgrid1.Cells[0,4] := 'Ins.';
  stringgrid1.Cells[0,5] := 'Dat.';
  stringgrid1.Cells[0,6] := 'Abl';
  stringgrid1.Cells[0,7] := 'Gen.';
  stringgrid1.Cells[0,8] := 'Loc.';
end;
procedure twc.fill1(s1 : string; n : word);
var i,j : byte;
    c : byte;
    f : string;
begin
  f := '';
  c := 0;
  case n of
       0 : c := 3;
       8 : c := 3;
       16 : c := 4;
       24 : c := 6;
       32 : c := 4;
       40 : c := 1;
       48 : c := 5;
       56 : c := 5;
       64 : c := 5;


  end;
  for i := 0 to 2 do
  for j := 0 to 7 do
  begin
    f := gd.Stringgrid1.Cells[i,j+n];
    delete(f,1,c);
    depo2.DP.StringGrid1.Cells[i,j] := f;
  end;


  for i :=   1 to 3 do
  for j := 1 to 8 do
  stringgrid1.Cells[i,j] :=form1.convertx(s1 + dp.stringgrid1 .Cells   [i - 1,j - 1]);
end;
procedure twc.mx;
var s1 : string;
    i,j : byte;
begin
  s1 := form1.stringgrid1.cells[1,form1.Stringgrid1.Row];
  s1 := s1 + ' ';
  if (pos('a ',s1) > 0) or
     (pos('aḥ ',s1) > 0)
  then
    begin
      prep1;
      delete(s1,pos('a ',s1),2);
      if pos('aḥ ',s1) > 0 then delete(s1,pos('aḥ ',s1),length('aḥ '));

      fill1(s1,0);
    end;
    if (pos('i ',s1) > 0) or
     (pos('iḥ ',s1) > 0)
  then
    begin
      prep1;
      delete(s1,pos('i ',s1),2);
      if pos('iḥ ',s1) > 0 then delete(s1,pos('iḥ ',s1),length('iḥ '));

      fill1(s1,8);
    end;
    if (pos('u ',s1) > 0) or
     (pos('uḥ ',s1) > 0)
  then
    begin
      prep1;
      delete(s1,pos('u ',s1),2);
      if pos('uḥ ',s1) > 0 then delete(s1,pos('uḥ ',s1),length('uḥ '));

      fill1(s1,16);
    end;

end;

procedure twc.fx;
begin

end;

procedure twc.nx;
begin

end;
procedure twc.clx(s,s1,s2 : string);
begin
  showmessage(s+' '+s1+' '+s2);
end;

end.

