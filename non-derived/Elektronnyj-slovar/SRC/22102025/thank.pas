unit Thank;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm10 }

  TForm10 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form10: TForm10;

implementation
uses poisk,params;
{$R *.lfm}

{ TForm10 }

procedure TForm10.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var i : word;
begin
   form1.AlphaBlendValue:=255;
   assignfile(fstat,'sys\stt.dig');
   vstat.x:=1;
   for i := 1 to length(vstat.A) do
   begin
      vstat.A[i].c:=0;
      vstat.A[i].CName:='';
      vstat.l:=0;
   end;
   vstat.pw := '';
   rewrite(fstat);
   write(fstat,vstat);
   closefile(fstat);
end;

procedure TForm10.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm10.ComboBox1Change(Sender: TObject);
begin
  form8.ComboBox1.ItemIndex:=combobox1.ItemIndex;
  if combobox1.ItemIndex <> 0 then
  begin
     memo1.Hide;memo2.Show;
     label2.Caption:='Dear user!';
  end
  else
  begin
     memo2.Hide;memo1.Show;
     label2.Caption:='Уважаемые пользователь!';
  end;
end;

procedure TForm10.FormCreate(Sender: TObject);
begin
  if fileexists('sys\stt.dig') = false then
  begin
     form10.Show;
     form1.AlphaBlendvalue := 144;
     form10.FormStyle:=fsstayontop;
     form10.AlphaBlendValue:=255;
     combobox1.Items := form8.ComboBox1.Items;
     if combobox1.Items.Count > 0 then
     combobox1.ItemIndex:=0;
  end;
end;

end.

