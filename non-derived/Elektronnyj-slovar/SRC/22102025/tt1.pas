unit tt1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids;

type

  { Ttt }

  Ttt = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  tt: Ttt;

implementation
uses shellapi,poisk;
{$R *.lfm}

{ Ttt }

procedure Ttt.Button1Click(Sender: TObject);
var zz : string;
    i  : longint;
begin
  zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
        '<font face="Mangal" size = "4">' +
        '<center><b>Transliteration table</center></font>';
   zz := zz + '<Table width = "77%" align = "center">'+
   '<td width = "11%" align = "center">' + stringgrid1.columns[0].Title.Caption + '</td>' +
   '<td width = "11%" align = "center">' + stringgrid1.columns[1].Title.Caption+ '</td>' +
   '<td width = "11%" align = "center">' + stringgrid1.columns[2].Title.Caption+ '</td>' +
   '<td width = "11%" align = "center">' + stringgrid1.columns[3].Title.Caption + '</td>' +
   '<td width = "11%" align = "center">' + stringgrid1.columns[4].Title.Caption+ '</td>' +
   '<td width = "11%" align = "center">' + stringgrid1.columns[5].Title.Caption+ '</td>' +
   '<td width = "11%" align = "center">' + stringgrid1.columns[6].Title.Caption + '</td><tr>';     ;

   for i := 1 to stringgrid1.RowCount - 1 do
   begin
     zz := zz +
     '<td width = "11%" align = "center">' + stringgrid1.Cells[0,i] + '</td>' +
     '<td width = "11%" align = "center">' + stringgrid1.Cells[1,i] + '</td>' +
     '<td width = "11%" align = "center">' + stringgrid1.Cells[2,i] + '</td>' +
     '<td width = "11%" align = "center">' + stringgrid1.Cells[3,i] + '</td>' +
     '<td width = "11%" align = "center">' + stringgrid1.Cells[4,i] + '</td>' +
     '<td width = "11%" align = "center">' + stringgrid1.Cells[5,i] + '</td>' +
     '<td width = "11%" align = "center">' + stringgrid1.Cells[6,i] + '</td><tr>';     ;
  end;
   zz := zz + '</table></body></html>';
   memo1.Lines.Text:=zz;
   memo1.Lines.SaveToFile(cdir+'\reports\itr.htm');
  if form1.CheckBox7.Checked then
  shellexecute(0,'Open',pchar(cdir+'\reports\itr.htm'),'',nil,1);
end;

end.

