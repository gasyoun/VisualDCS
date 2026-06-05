unit u1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var i,j : word;
begin
  stringgrid1.LoadFromCSVFile('texts.csv',':',true);
  stringgrid2.LoadFromCSVFile('ta.csv',';',true);

  stringgrid1.ColCount:= stringgrid1.ColCount + 1;
  for i := 1 to stringgrid1.RowCount-1 do
  for j := 1 to stringgrid2.RowCount - 1 do
  begin
    if stringgrid2.Cells[0,j] = stringgrid1.Cells[0,i] then
    stringgrid1.Cells[stringgrid1.ColCount-2,i] :=
    stringgrid2.Cells[1,j];
  end;
  stringgrid1.SaveToCSVFile('texts1.csv',':',true);
end;

end.

