unit dmk1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids;

type

  { Tdmk }

  Tdmk = class(TForm)
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    StringGrid6: TStringGrid;
    StringGrid7: TStringGrid;
    StringGrid8: TStringGrid;
    StringGrid0: TStringGrid;
    StringGrid9: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure fillptk(x : byte);
  end;
type
  paretoX = array[0..9] of word;
var
  dmk: Tdmk;
  ptk : paretoX;
implementation
uses kn;
{$R *.lfm}

{ Tdmk }

procedure Tdmk.FormCreate(Sender: TObject);
var i : word;
    j : real;
begin

  stringgrid1.LoadFromCSVFile('sys\kernels\1',';');
  stringgrid2.LoadFromCSVFile('sys\kernels\2',';');
  stringgrid3.LoadFromCSVFile('sys\kernels\3',';');
  stringgrid4.LoadFromCSVFile('sys\kernels\4',';');
  stringgrid5.LoadFromCSVFile('sys\kernels\5',';');
  stringgrid6.LoadFromCSVFile('sys\kernels\6',';');
  stringgrid7.LoadFromCSVFile('sys\kernels\7',';');
  stringgrid8.LoadFromCSVFile('sys\kernels\8',';');
  stringgrid0.LoadFromCSVFile('sys\kernels\0',';');
  stringgrid9.LoadFromCSVFile('sys\kernels\9',';');
  stringgrid0.ColCount:=4;
  stringgrid1.ColCount:=4;
  stringgrid2.ColCount:=4;
  stringgrid3.ColCount:=4;
  stringgrid4.ColCount:=4;
  stringgrid5.ColCount:=4;
  stringgrid6.ColCount:=4;
  stringgrid7.ColCount:=4;
  stringgrid8.ColCount:=4;
  stringgrid9.ColCount:=4;



  for i := 0 to 9 do ptk[i] := 0;
  fillptk(80);
  kkn.ComboBox1Change(sender);
  for i := 0 to stringgrid0.RowCount-1 do
  stringgrid0.Cells[3,i] := inttostr(i);

  for i := 0 to stringgrid1.RowCount-1 do
  stringgrid1.Cells[3,i] := inttostr(i);

  for i := 0 to stringgrid2.RowCount-1 do
  stringgrid2.Cells[3,i] := inttostr(i);

  for i := 0 to stringgrid3.RowCount-1 do
  stringgrid3.Cells[3,i] := inttostr(i);

  for i := 0 to stringgrid4.RowCount-1 do
  stringgrid4.Cells[3,i] := inttostr(i);

  for i := 0 to stringgrid5.RowCount-1 do
  stringgrid5.Cells[3,i] := inttostr(i);

  for i := 0 to stringgrid6.RowCount-1 do
  stringgrid6.Cells[3,i] := inttostr(i);

  for i := 0 to stringgrid7.RowCount-1 do
  stringgrid7.Cells[3,i] := inttostr(i);

  for i := 0 to stringgrid8.RowCount-1 do
  stringgrid8.Cells[3,i] := inttostr(i);

  for i := 0 to stringgrid9.RowCount-1 do
  stringgrid9.Cells[3,i] := inttostr(i);
end;
procedure tdmk.fillptk(x : byte);
var i : word;
    j : real;
    d : real;
begin
    d := x - 0.1;
    j := 0;

    ptk[0] := stringgrid0.RowCount;
{
    for i := 0 to stringgrid0.RowCount - 1 do
    if j < d then j  := j + strtofloat(stringgrid0.Cells[2,i])
    else
      begin
        ptk[0] := i;
        break;
      end;
}

      ptk[9] := stringgrid9.RowCount;



    j := 0;
    for i := 0 to stringgrid1.RowCount - 1 do
    if j < d then j  := j + strtofloat(stringgrid1.Cells[2,i])
    else
      begin
        ptk[1] := i;
        break;
      end;

    j := 0;
    for i := 0 to stringgrid2.RowCount - 1 do
    if j < d then j  := j + strtofloat(stringgrid2.Cells[2,i])
    else
      begin
        ptk[2] := i;
        break;
      end;

    j := 0;
    for i := 0 to stringgrid3.RowCount - 1 do
    if j < d then j  := j + strtofloat(stringgrid3.Cells[2,i])
    else
      begin
        ptk[3] := i;
        break;
      end;
    j := 0;
    for i := 0 to stringgrid4.RowCount - 1 do
    if j < d then j  := j + strtofloat(stringgrid4.Cells[2,i])
    else
      begin
        ptk[4] := i;
        break;
      end;
    j := 0;
    for i := 0 to stringgrid5.RowCount - 1 do
    if j < d then j  := j + strtofloat(stringgrid5.Cells[2,i])
    else
      begin
        ptk[5] := i;
        break;
      end;
    j := 0;
    for i := 0 to stringgrid6.RowCount - 1 do
    if j < d then j  := j + strtofloat(stringgrid6.Cells[2,i])
    else
      begin
        ptk[6] := i;
        break;
      end;
    j := 0;
    for i := 0 to stringgrid7.RowCount - 1 do
    if j < d then j  := j + strtofloat(stringgrid7.Cells[2,i])
    else
      begin
        ptk[7] := i;
        break;
      end;
    j := 0;
    for i := 0 to stringgrid8.RowCount - 1 do
    if j < d then j  := j + strtofloat(stringgrid8.Cells[2,i])
    else
      begin
        ptk[8] := i;
        break;
      end;
//     for i := 1 to 8 do
//     kkn.Memo1.Lines.Add(inttostr(ptk[i]));
end;

end.

