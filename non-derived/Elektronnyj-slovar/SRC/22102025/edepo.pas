unit EDepo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, EditBtn, ComCtrls, Grids;

type

  { TED }

  TED = class(TForm)
    ComboBox1: TComboBox;
    EditButton1: TEditButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure EditButton1ButtonClick(Sender: TObject);
    procedure EditButton1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private

  public

  end;

var
  ED: TED;

implementation
uses reult1,sfo,poisk,depo1;
var lim : longint = 10000;
    bk : boolean = false;
{$R *.lfm}

{ TED }

procedure TED.FormCreate(Sender: TObject);
var a : longint;
begin
  StringGrid1.RowCount:=ListBox1.Items.Count;
  for a := 0 to ListBox1.Items.Count - 1 do
  begin
    StringGrid1.cells[0,a] := form1.convertd(ListBox1.Items[a]);
    StringGrid1.cells[1,a] := ListBox1.Items[a];
    StringGrid1.cells[2,a] := inttostr(a);
  end;
  statusbar1.Panels[1].Text:=inttostr(a);
  lim := listbox1.Items.Count;
end;

procedure TED.Memo2Change(Sender: TObject);
begin

end;

procedure TED.StringGrid1Click(Sender: TObject);
var s : string;
begin
  memo2.Clear;
  memo2.Text:=
  memo1.Lines.Strings[
  strtoint(stringgrid1.cells[2,stringgrid1.Row])];


end;

procedure TED.EditButton1Change(Sender: TObject);
var i,a,w : word; s : string;
begin
  a := editbutton1.SelStart;
  w := length(editbutton1.Text);
  Editbutton1.Text := form1.convertx(editbutton1.Text);


  if w = length(editbutton1.Text) then editbutton1.SelStart:=a
  else   editbutton1.SelStart:= a - (w - length(editbutton1.Text));
  editbutton1.SetFocus;
  stringgrid1.RowCount:= 1;
    if editbutton1.Text = '' then
    begin
       formcreate(sender);

    end;
    w := 1;
    s := form1.convertx(form1.getconv(editbutton1.Text));
    if s <> '' then
    for i := 1 to listbox1.items.count - 1 do
    if w < lim then
    case combobox1.ItemIndex of
             0 :
    begin
    if (pos(s,listbox1.Items[i]) = 1)
       then
          begin
             inc(w);
             stringgrid1.RowCount:=w;
             stringgrid1.Cells[0,w-1] := form1.convertd(listbox1.Items[i]);
             stringgrid1.Cells[1,w-1] := listbox1.Items[i];
             stringgrid1.Cells[2,w-1] := inttostr(i);
          end;
         end;
          1 :
          begin
          if (pos(s,listbox1.Items[i]) > 1)
             then
                begin
                   inc(w);
                   stringgrid1.RowCount:=w;
                   stringgrid1.Cells[0,w-1] := form1.convertd(listbox1.Items[i]);
                   stringgrid1.Cells[1,w-1] := listbox1.Items[i];
                   stringgrid1.Cells[2,w-1] := inttostr(i);

                end;

          end;
    end;
    statusbar1.Panels[1].Text:=inttostr(w - 1);
    bk := false;
end;


procedure TED.EditButton1ButtonClick(Sender: TObject);
begin
  bk := true;
  editbutton1change(sender);
end;


procedure TED.Button1Click(Sender: TObject);
var i : longint;
    s : string;
    j : longint;
    z : boolean;
begin
{
  z := false;
  s := '';
  resform.CheckListBox1.Clear;
  resform.CheckListBox2.Clear;
  resform.ListBox1.Clear;
  resform.ListBox2.Clear;
  s := stringgrid1.Cells[1,stringgrid1.Row];
  if pos(' ',s) > 0 then
     s := copy(s,1,pos(' ',s) - 1);
  if s <> '' then
begin
  i := form1.GetletId(s);

  for j := d[i].beg to d[i].ed do
  if s  = depo.listbox2.items[j] then
  begin
     resform.CheckListBox2.Items.Add(s);
     resform.ListBox2.Items.Add(inttostr(j));
     apte1 := true;
     monier:= true;
     mani := true;
     botlink := true;
     resform.StatusBar1.Panels[1].Text:='1';
     resform.StatusBar1.Panels[3].Text:='';
     resform.Show;
     z := true;
     break;
  end;
end;
  if z = false then
  showmessage('Could not find the word in other dictionaryes..')
}
end;


procedure TED.StringGrid1DblClick(Sender: TObject);
var d1,s,x,s1 : string;
    id    : byte;
    d2    : string;
begin
{
  d2 := '';
    s := stringgrid1.Cells[1,stringgrid1.Row];
    s1:= stringgrid1.Cells[0,stringgrid1.Row];
    x := memo1.Lines.Strings[strtoint(stringgrid1.Cells[2,stringgrid1.Row])];
    delete(x,1,pos('>#',x)+2);
    id := form1.getletid(s);
    if pos(' ',s) > 0 then
    d2 := copy(s,1,pos(' ',s) - 1)
    else d2 := s;
    if checkbox2.Checked then
    begin
       sf.findinfo(d2,d[id].beg,d[id].ed,d1);
       d1 := 'MONIER WILLIAMS' + #13+#10 + d1;
    end;

    resform.Show;
    resform.checkbox2change(sender);
{    resform.Memo2.Text:='PURANIC DICTIONARY' + #13+#10 +
    s1 + '   ' + s + #13+#10+
    x + #13+#10 + #13+#10+ d1;

    resform.CheckBox2.Checked:=true;
    }
}
end;

end.

