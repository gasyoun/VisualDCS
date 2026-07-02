unit unit1x;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TF332 }

  TF332 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  F332: TF332;

implementation
uses poisk;
{$R *.lfm}

{ TF332 }

procedure TF332.Button1Click(Sender: TObject);
begin
   form1 := Tform1.Create(self);
end;

end.

