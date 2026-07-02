unit acat;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  Grids, StdCtrls, Menus;

type

  { TForm9 }

  TForm9 = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure FormResize(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
  private

  public
    procedure catalog(i : byte);
  end;

var
  Form9: TForm9;

implementation
uses shellapi;
const pth : string = 'sys\xlsdata\share\';
var cx : array[1..5] of string = ('Авторская аналитика',
                                   'Онлайн ресурсы',
                                   'Книги',
                                   'Программы',
                                   'Источники');
  asd : byte;
{$R *.lfm}

procedure TForm9.StringGrid1Click(Sender: TObject);
begin
  if stringgrid1.RowCount > 1 then
  if stringgrid1.Cells[4,stringgrid1.Row] <> '' then
  memo1.Text:=stringgrid1.Cells[4,stringgrid1.Row];
//  shellexecute(0,'open',pchar(stringgrid1.Cells[4,stringgrid1.Row]),nil,nil,1);
end;

procedure TForm9.FormResize(Sender: TObject);
begin
  stringgrid1.Columns[0].Width:=form9.Width-
  stringgrid1.Columns[1].Width -
  stringgrid1.Columns[2].Width-
  stringgrid1.Columns[3].Width - 32;
end;

procedure TForm9.MenuItem1Click(Sender: TObject);
begin
  Showmessage('f you want to add your work or an online resource to the program database'+#13+#10+
  'please contact us.');
end;

procedure TForm9.StringGrid1DblClick(Sender: TObject);
begin
  if stringgrid1.RowCount > 1 then
  if stringgrid1.Cells[5,stringgrid1.Row] <> '' then
  begin
     case asd of
     1 :begin
        if fileexists(stringgrid1.Cells[5,stringgrid1.Row]) then
        shellexecute(0,'open',pchar(stringgrid1.Cells[5,stringgrid1.Row]),nil,nil,1)
        else shellexecute(0,'Explore',pchar(stringgrid1.Cells[5,stringgrid1.Row]),nil,nil,1);
     end;
     2 : shellexecute(0,'open',pchar(stringgrid1.Cells[5,stringgrid1.Row]),nil,nil,1);
     3 : shellexecute(0,'open',pchar(stringgrid1.Cells[5,stringgrid1.Row]),nil,nil,1);
     4 :  shellexecute(0,'open',pchar(stringgrid1.Cells[5,stringgrid1.Row]),nil,nil,1);
     end;
  end;
end;

procedure TForm9.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
  if key in [#13,#10] then
  stringgrid1dblclick(sender);
end;

procedure tform9.catalog(i : byte);
begin
  stringgrid1.LoadFromCSVFile(pth+'catalog'+inttostr(i)+'.sdm',#9);
  caption := cx[i];
  statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount-1);
  formresize(nil);
  asd := i;
end;

end.

