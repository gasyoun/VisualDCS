unit Tinfo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    ListBox1: TListBox;
    StatusBar1: TStatusBar;
    procedure ListBox1DblClick(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation
uses poisk;
{$R *.lfm}

{ TForm2 }

procedure TForm2.ListBox1DblClick(Sender: TObject);
var i : word;
begin
  if listbox1.Count > 0 then
  begin
    for i := 1 to form1.combobox6.items.count - 1 do
    if form1.ComboBox6.items[i]=listbox1.Items[listbox1.ItemIndex] then
    begin
      form1.ComboBox6.ItemIndex := i;
      form1.ComboBox6Change(sender);
    end;
  end;
end;

end.

