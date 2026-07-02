unit trwin;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls, ExtDlgs, TAGraph, TASources, TATools, TASeries, TALegendPanel,
  TAFuncSeries, TARadialSeries;

type

  { TTr }

  TTr = class(TForm)
    Chart1: TChart;
    Chart1BarSeries1: TBarSeries;
    Chart1LineSeries1: TLineSeries;
    Chart1PolarSeries1: TPolarSeries;
    ls1: TListChartSource;
    ls2: TListChartSource;
    ls3: TListChartSource;
    ls4: TListChartSource;
    ls5: TListChartSource;
    ls6: TListChartSource;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);

  private

  public


  end;

var
  Tr: TTr;

implementation
uses dcon,poisk;
var i : dword=0;

{$R *.lfm}

{ TTr }





procedure TTr.FormActivate(Sender: TObject);
begin
//  form1.BitBtn9.show;
//  form1.BitBtn9.Caption:= caption;
end;

procedure TTr.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
//  form1.BitBtn9.Hide;
end;

procedure TTr.FormCreate(Sender: TObject);
begin

end;

procedure TTr.FormWindowStateChange(Sender: TObject);
begin
  if windowstate = wsminimized then
  begin
//    form1.BitBtn9.show;
//    form1.BitBtn9.Caption:= caption;
  end;
end;







end.

