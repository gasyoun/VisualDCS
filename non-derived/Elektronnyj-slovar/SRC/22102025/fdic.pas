unit fdic;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls, ComCtrls;

type

  { TForm5 }

  TForm5 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
  private

  public

  end;

var
  Form5: TForm5;

implementation
uses poisk,shellapi;
{$R *.lfm}

{ TForm5 }

procedure TForm5.Button1Click(Sender: TObject);
begin
  if savedialog1.Execute then
  begin
      stringgrid1.SaveToCSVFile(savedialog1.FileName,#9);
      if form1.checkbox7.checked then
      shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);

  end;
end;

procedure TForm5.StringGrid1Click(Sender: TObject);
begin
  if stringgrid1.Row > 0 then
  if strtoint(stringgrid1.Cells[3,stringgrid1.Row])  > 0 then
  begin
    memo1.Text:='';
    form1.FillDlist(strtoint(stringgrid1.Cells[3,stringgrid1.Row]));
    memo1.Text := form1.printdl1;
  end
  else memo1.Text:= 'Translation not found.';
end;

end.

