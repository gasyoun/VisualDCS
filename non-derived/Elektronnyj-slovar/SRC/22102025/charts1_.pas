unit charts1_;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql56conn, Forms, Controls, Graphics, Dialogs, StdCtrls,
  TAGraph, TASeries, TAStyles, TASources, TACustomSource;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    ListChartSource1: TListChartSource;
    procedure Button1Click(Sender: TObject);
    function ListChartSource1Compare(AItem1, AItem2: Pointer): Integer;
  private

  public

  end;

var
  Form1: TForm1;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  ListChartSource1.AddXYList(100,[1,2,35,4,5,6,7,8,9,64]);


end;

function TForm1.ListChartSource1Compare(AItem1, AItem2: Pointer): Integer;
begin

end;

end.

