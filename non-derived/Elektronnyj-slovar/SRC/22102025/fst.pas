unit Fst;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ComCtrls, Menus,
  StdCtrls, HtmlView;

type

  { TFSinta }

  TFSinta = class(TForm)
    GroupBox1: TGroupBox;
    hw: THtmlViewer;
    MenuItem201: TMenuItem;
    MenuItem202: TMenuItem;
    PopupMenu3: TPopupMenu;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MenuItem201Click(Sender: TObject);
    procedure MenuItem202Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
  private

  public

  end;

var
  FSinta: TFSinta;

implementation
uses sfo,poisk;
{$R *.lfm}

{ TFSinta }

procedure TFSinta.FormResize(Sender: TObject);
var i : byte;
begin
  StringGrid1.DefaultColWidth:= (stringgrid1.Width - 32) div stringgrid1.ColCount;
  for i := 0 to statusbar1.Panels.Count-1 do
  statusbar1.Panels[i].Width:=width div statusbar1.Panels.Count -statusbar1.Panels.Count;
end;

procedure TFSinta.FormCreate(Sender: TObject);
begin
  hw.LoadFromString('');
end;

procedure TFSinta.MenuItem201Click(Sender: TObject);
begin
  hw.CopyToClipboard;
end;

procedure TFSinta.MenuItem202Click(Sender: TObject);
begin
  hw.SelectAll;
end;

procedure TFSinta.StringGrid1Click(Sender: TObject);
var s : string;
begin
  if stringgrid1.Col mod 2 = 0 then
  if stringgrid1.Cells[stringgrid1.Col,stringgrid1.Row] <> '' then
  begin
    sf.findinfo(stringgrid1.Cells[stringgrid1.Col,stringgrid1.Row],
    d[form1.GetletId(stringgrid1.Cells[stringgrid1.Col,stringgrid1.Row])].beg,
    d[form1.GetletId(stringgrid1.Cells[stringgrid1.Col,stringgrid1.Row])].ed,true,s);
    hw.LoadFromString(s);
  end;
end;

end.

