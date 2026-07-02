unit help1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,lresources;

type

  { Thlp }

  Thlp = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
  private

  public

  end;

var
  hlp: Thlp;

implementation
uses shellapi;
{$R *.lfm}

{ Thlp }

procedure Thlp.ComboBox1Change(Sender: TObject);
begin

end;

procedure Thlp.Button1Click(Sender: TObject);
begin
  hlp.Hide;
end;

procedure Thlp.Label2Click(Sender: TObject);
begin
  shellexecute(handle,'open',pchar('iymagic@yandex.ru'),nil,nil,1);
end;

procedure Thlp.Label3Click(Sender: TObject);
begin
  shellexecute(handle,'open','mailto://iymagic@yandex.ru',nil,nil,1);
end;

procedure Thlp.Label7Click(Sender: TObject);
begin

end;

procedure Thlp.Memo2Change(Sender: TObject);
begin

end;

end.

