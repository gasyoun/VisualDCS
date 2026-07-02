unit th2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm11 }

  TForm11 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form11: TForm11;

implementation

{$R *.lfm}

{ TForm11 }

procedure TForm11.FormCreate(Sender: TObject);
var a,s,d,f : word; s1,s2,s3,s4: string;
begin
  a := 11*100*2; str(a,s1);
  s := 11*7*100+4;
  d := 383; str(s,s2);str(d*2,s3);
  f:=1300*2+101;str(f,s4);
  edit1.Text:=s1+s2+inttostr(round(ln(1)))+s3+s4;
end;

procedure TForm11.Button1Click(Sender: TObject);
begin
  edit1.SelectAll;
  edit1.CopyToClipboard;
end;

end.

