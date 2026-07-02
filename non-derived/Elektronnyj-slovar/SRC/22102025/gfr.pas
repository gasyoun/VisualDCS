unit gfr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, ExtCtrls, ComCtrls;

type

  { Tgres }

  Tgres = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
  private
  public
  end;

var
  gres: Tgres;

implementation
uses gram;
{$R *.lfm}

{ Tgres }

procedure Tgres.Button1Click(Sender: TObject);
var zz : string;
    a  : longint;
begin
zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
      '<font face="Mangal" size = "2">' +
      '<center><b>Grammar tables Search Results:  </b></center><left>' +
      '<table width = "100%" rules = "ALL" border = "2">';

zz := zz + '<td width = "20%"><b>'+stringgrid1.Columns[0].Title.Caption+
      '</td><td width = "20%">'+stringgrid1.Columns[1].Title.Caption+
      '</td><td width = "20%">'+stringgrid1.Columns[2].Title.Caption+
      '</td><td width = "20%">'+stringgrid1.Columns[3].Title.Caption+
      '</td><td width = "20%">'+stringgrid1.Columns[4].Title.Caption+
      '</td><tr>';

    for a := 1 to stringgrid1.RowCount - 1 do
    begin
      zz := zz + '<td width = "20%"><b>'+stringgrid1.Cells[0,a]+
            '</td><td width = "20%">'+stringgrid1.Cells[1,a] +
            '</td><td width = "20%">'+stringgrid1.Cells[2,a] +
            '</td><td width = "20%">'+stringgrid1.Cells[3,a] +
            '</td><td width = "20%">'+stringgrid1.Cells[4,a] +
            '</td><tr>';
    end;
    zz := zz + '</table></body></html>';
    nn.memo1.Text:=zz;
    if nn.savedialog1.Execute then nn.memo1.Lines.SaveToFile(nn.savedialog1.FileName);
end;


procedure Tgres.StringGrid1Click(Sender: TObject);
begin
   statusbar1.Panels[3].Text  := stringgrid1.Cells[stringgrid1.Col,stringgrid1.Row];
end;



end.

