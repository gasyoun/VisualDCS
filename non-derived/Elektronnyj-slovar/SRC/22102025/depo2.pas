unit depo2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids;

type

  { TDP }

  TDP = class(TForm)
    ListBox1: TListBox;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  DP: TDP;

implementation

{$R *.lfm}

{ TDP }

procedure TDP.FormCreate(Sender: TObject);
begin
  if fileexists('sys\dic2.sdm') then
  memo1.Lines.LoadFromFile('sys\dic2.sdm')
  else
    application.MessageBox('Could not open English-Sanskrit dictionary file','File not found!',16);
end;

end.

