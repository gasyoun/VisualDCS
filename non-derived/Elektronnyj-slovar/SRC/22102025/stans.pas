unit StAns;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  ComCtrls;

type

  { TSTA }

  TSTA = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private

  public

  end;

var
  STA: TSTA;

implementation
uses sfo,poisk,wrf,lpak;
{$R *.lfm}

{ TSTA }

procedure TSTA.StringGrid1Click(Sender: TObject);
var s : string;
begin
  sf.findinfo(stringgrid1.Cells[0,stringgrid1.Row],
  d[form1.GetletId(stringgrid1.Cells[0,stringgrid1.Row])].beg,
  d[form1.GetletId(stringgrid1.Cells[0,stringgrid1.Row])].ed,true,s);
  memo2.Text:=s;

end;

procedure TSTA.StringGrid1DblClick(Sender: TObject);
begin
   form1.GetExam(stringgrid1.Cells[5,stringgrid1.Row]+' ',0,0,0,0,0);
   wr.Caption:= lp.StringGrid1.Cells[x229,462] + ' "'+
   stringgrid1.Cells[0,stringgrid1.Row] + '"';
   if wr.WindowState = wsminimized then
   wr.WindowState:= wsnormal;
   wr.Show;
   wr.BringToFront;
end;

procedure TSTA.FormResize(Sender: TObject);
var i : byte;
begin
   for i := 0 to stringgrid1.ColCount-1 do
   if stringgrid1.Columns[i].Visible then
   stringgrid1.AutoSizeColumn(i);
end;

procedure TSTA.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  form1.BitBtn8.Hide;
end;

procedure TSTA.FormDblClick(Sender: TObject);
begin

end;

procedure TSTA.FormShow(Sender: TObject);
begin
  form1.bitbtn8.caption := caption;
  form1.bitbtn8.show;
end;

procedure TSTA.FormWindowStateChange(Sender: TObject);
begin
  if windowstate = wsminimized then
  begin
//    form1.bitbtn8.caption := caption;
//    form1.bitbtn8.show;
  end;
end;

end.

