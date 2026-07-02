unit ds1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, CheckLst,
  StdCtrls;

type

  { TDSet }

  TDSet = class(TForm)
    Button110: TButton;
    CheckListBox1: TCheckListBox;
    CheckListBox2: TCheckListBox;
    Label4: TLabel;
    Label6: TLabel;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel8: TPanel;
    procedure Button110Click(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure CheckListBox2Click(Sender: TObject);
  private

  public

  end;

var
  DSet: TDSet;

implementation
uses poisk;
{$R *.lfm}

{ TDSet }

procedure TDSet.Button110Click(Sender: TObject);
var i : byte;
begin
  Hide;
  with form1 do
begin

  for i := 1 to 9 do
  dlist[i].en:= checklistbox1.Checked[i - 1];

  for i := 10 to 12 do
  dlist[i].en:= checklistbox2.Checked[i - 10];

if (stringgrid1.Row>0) and (stringgrid1.RowCount > 1) then
  memo1.Text := printdl1;;
 end;
end;

procedure TDSet.CheckListBox1Click(Sender: TObject);
begin
  with form1 do
  begin
  if checklistbox1.ItemIndex > 8 then
    memo2.Text:=dlist[checklistbox1.ItemIndex + 4].dname +#13+#10+
    dlist[checklistbox1.ItemIndex+4].Dlink
  else
    memo2.Text:=dlist[checklistbox1.itemindex+1].DName +#13+#10+dlist[checklistbox1.itemindex+1].Dlink;
  end;

end;

procedure TDSet.CheckListBox2Click(Sender: TObject);
begin
      memo2.Text:=dlist[checklistbox2.itemindex+10].DName +#13+#10+dlist[checklistbox2.itemindex+10].DDesc;

end;

end.

