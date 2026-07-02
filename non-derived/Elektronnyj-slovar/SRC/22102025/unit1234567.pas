unit unit1234567;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, MPlayerCtrl, RichMemo;

type

  { TForm1 }

  TForm1 = class(TForm)
    MPlayerControl1: TMPlayerControl;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure MPlayerControl1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  if opendialog1.Execute then
  begin
    mplayercontrol1.Filename:=opendialog1.FileName;
    mplayercontrol1.FindMPlayerPath;
//    mplayercontrol1.MPlayerPath := 'wmplayer';
    mplayercontrol1.Play;
  end;

end;

procedure TForm1.MPlayerControl1Click(Sender: TObject);
begin

end;

end.

