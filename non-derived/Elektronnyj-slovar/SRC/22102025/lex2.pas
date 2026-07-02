unit lex2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, CheckLst,
  StdCtrls, Menus, ComCtrls;

type

  { TForm7 }

  TForm7 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckListBox1: TCheckListBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure CheckListBox1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
  private

  public

  end;
  chk1x = array[1..255] of boolean;
var
  Form7: TForm7;
  set_ : boolean = false;
  set1_ : chk1x;fchk : file of chk1x;
implementation
uses poisk,tx1,tinfo,tcompare;
{$R *.lfm}

{ TForm7 }

procedure TForm7.Button1Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox1.Count - 1 do
    if checklistbox1.Checked[i] then
       gdicid := gdicid + [i]
    else
      gdicid := gdicid - [i];
    set_ := true;
    form1.geytrd1(0);

end;

procedure TForm7.Button2Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox1.Count - 1 do
    if checklistbox1.Checked[i] then
       gdicid := gdicid + [i]
    else
      gdicid := gdicid - [i];
    set_ := false;
    form1.geytrd1(0);
end;

procedure TForm7.CheckListBox1Click(Sender: TObject);
var i,j : byte;
begin  j := 0;
    for i := 0 to checklistbox1.Count - 1 do
    if checklistbox1.Checked[i] then inc(j);
    statusbar1.Panels[1].Text:=inttostr(j);
end;

procedure TForm7.CheckListBox1ClickCheck(Sender: TObject);
var i,j : byte;
begin j := 0;
  for i := 0 to checklistbox1.Count - 1 do
  if checklistbox1.Checked[i] then inc(j);
  statusbar1.Panels[1].Text:=inttostr(j);

end;

procedure TForm7.CheckListBox1DblClick(Sender: TObject);
var i,j : longint; s : string;
    l1,l2 : integer;
begin

   if checklistbox1.ItemIndex > 10 then
   begin
     for i := 0 to DCS1.ComboBox1.Items.Count - 1 do
     if dcs1.ComboBox1.Items[i] = '"'+checklistbox1.items[checklistbox1.ItemIndex]+'"' then
     begin
       dcs1.ComboBox1.ItemIndex:=i;
       dcs1.show;
       dcs1.ComboBox1Change(sender);
       break;
     end;
   end
   else
   if checklistbox1.ItemIndex <> 0 then
   begin
     case checklistbox1.ItemIndex of
            1 : begin l1 := -2000; l2 := -300;end;
            2 : begin l1 := -300; l2 := 200;end;
            3 : begin l1 := 200; l2 := 1966;end;
            4 : begin l1 := -2000; l2 := -800;end;
            5 : begin l1 := -800; l2 := -300;end;
            6 : begin l1 := -300; l2 := 200;end;
            7 : begin l1 := 200; l2 := 700;end;
            8 : begin l1 := 700; l2 := 1200;end;
            9 : begin l1 := 1200; l2 := 1700;end;
            10 : begin l1 := 1700; l2 := 2000;end;

     end;
     form2.Show;
     form2.Caption:='Period: '+checklistbox1.items[checklistbox1.itemindex];
     form2.ListBox1.Clear;
     for i := 1 to ct.StringGrid1.RowCount - 1 do
     begin
       j := strtoint(ct.StringGrid1.Cells[3,i]);
       if (j >= l1)
 and (j <= l2) then
       form2.ListBox1.Items.Add(ct.StringGrid1.Cells[0,i]);
     end;
      form2.StatusBar1.Panels[1].Text:=inttostr(form2.listbox1.Count);
   end;


end;

procedure TForm7.FormCreate(Sender: TObject);
var i : byte;
begin assignfile(fchk,'sys\chk1.1');
  if fileexists('sys\chk1.1') then
  begin
    reset(fchk);
    read(fchk,set1_);
    for i := 0 to checklistbox1.Count - 1 do
    checklistbox1.Checked[i] := set1_[i+1];
    closefile(fchk);
  end;
end;

procedure TForm7.FormDeactivate(Sender: TObject);
var i : byte;
begin
  for i := 0 to checklistbox1.Count - 1 do
  set1_[i+1] := checklistbox1.Checked[i];
  rewrite(fchk);
  write(fchk,set1_);
  closefile(fchk);

end;

procedure TForm7.MenuItem1Click(Sender: TObject);
var i : byte;
begin
  for i := 0 to checklistbox1.Count - 1 do
  checklistbox1.Checked[i] := false;
  CheckListBox1Click(Sender);
end;

procedure TForm7.MenuItem2Click(Sender: TObject);
var i : byte;
begin
    for i := 1 to checklistbox1.Count - 1 do
    if checklistbox1.Checked[i] then checklistbox1.Checked[i] := false else
      checklistbox1.Checked[i] := true;
    CheckListBox1Click(Sender);
end;

procedure TForm7.MenuItem3Click(Sender: TObject);
var i : word;
begin
    for i := 10 to checklistbox1.Items.Count - 1 do
    checklistbox1.Checked[i] := true;
end;

end.

