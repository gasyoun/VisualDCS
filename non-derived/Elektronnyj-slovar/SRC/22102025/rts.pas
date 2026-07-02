unit RTS;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ComCtrls;

type

  { TRoots }

  TRoots = class(TForm)
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Label1: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure CheckBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseEnter(Sender: TObject);
    procedure SpeedButton1MouseLeave(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton2MouseEnter(Sender: TObject);
    procedure SpeedButton2MouseLeave(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton3MouseEnter(Sender: TObject);
    procedure SpeedButton3MouseLeave(Sender: TObject);
  private

  public

  end;

var
  Roots: TRoots;

implementation
uses vd1;
{$R *.lfm}

{ TRoots }

procedure TRoots.SpeedButton3Click(Sender: TObject);
begin
  Edit1.Text:='';
  listbox1.Items := listbox2.Items;
  listbox1.ItemIndex:=0;
  statusbar1.Panels[1].Text:=inttostr(listbox1.Count);
end;

procedure TRoots.SpeedButton3MouseEnter(Sender: TObject);
begin
  speedbutton3.Transparent:= false;
end;

procedure TRoots.SpeedButton3MouseLeave(Sender: TObject);
begin
  speedbutton3.Transparent:= true;
end;

procedure TRoots.ListBox2Click(Sender: TObject);
begin
end;

procedure TRoots.SpeedButton1Click(Sender: TObject);
begin
  listbox1click(sender);
  hide;
end;

procedure TRoots.SpeedButton1MouseEnter(Sender: TObject);
begin
  speedbutton1.Transparent:= false;
end;

procedure TRoots.SpeedButton1MouseLeave(Sender: TObject);
begin
  speedbutton1.Transparent:= true;
end;

procedure TRoots.SpeedButton2Click(Sender: TObject);
begin
  hide;
end;

procedure TRoots.SpeedButton2MouseEnter(Sender: TObject);
begin
  speedbutton2.Transparent:= false;
end;

procedure TRoots.SpeedButton2MouseLeave(Sender: TObject);
begin
  speedbutton2.Transparent:= true;
end;

procedure TRoots.Edit1Change(Sender: TObject);
var i,x : word;
begin
  if edit1.Text <> '' then
  begin
    x := edit1.SelStart;
    edit1.Text:=verdir.convertx(edit1.Text);
    edit1.SetFocus;
    edit1.SelStart:=x;
  end;

      listbox1.Clear;
      if checkbox1.Checked then
      begin
         for i := 0 to listbox2.Count - 1 do
         if pos(edit1.Text,listbox2.Items[i]) = 1 then
         listbox1.Items.add(listbox2.Items[i]);
       end
      else
      begin
        for i := 0 to listbox3.Count - 1 do
        if pos(edit1.Text,listbox3.Items[i]) = 1 then
        listbox1.Items.add(listbox3.Items[i]);
      end;
       statusbar1.Panels[1].Text:=inttostr(listbox1.Count);

end;

procedure TRoots.CheckBox1Change(Sender: TObject);
begin
  if checkbox1.Checked then formcreate(sender)
  else
    begin
      listbox1.items.Text := listbox3.items.TEXt;
      statusbar1.Panels[1].Text:=inttostr(listbox3.Items.Count);
    end;
end;

procedure TRoots.FormCreate(Sender: TObject);
begin
  speedbutton3click(sender);
end;

procedure TRoots.Label1Click(Sender: TObject);
begin
  checkbox1.Checked:=not(checkbox1.Checked);
end;

procedure TRoots.ListBox1Click(Sender: TObject);
begin
  if listbox1.ItemIndex > -1 then
  begin
    verdir.Edit1.Text:=listbox1.Items[listbox1.ItemIndex];
    if verdir.CheckBox1.Checked= false then
    verdir.SpeedButton1Click(sender);


  end;
end;

end.

