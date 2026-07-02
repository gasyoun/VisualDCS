unit frs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, ComCtrls, Buttons, Menus;

type

  { TFR }

  TFR = class(TForm)
    SpeedButton2: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel4: TPanel;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PopupMenu1: TPopupMenu;
    SpeedButton1: TButton;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);

    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseEnter(Sender: TObject);
    procedure SpeedButton1MouseLeave(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton2MouseEnter(Sender: TObject);
    procedure SpeedButton2MouseLeave(Sender: TObject);
    procedure StringGrid2Click(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
  private
      function chkwd(s : string; i : dword; fs : byte; d1,d2,d3,d4,d5 : boolean) : boolean;
      function chkwd2(s : string; i : dword;  d1,d2,d3,d4,d5 : boolean) : boolean;
  public

  end;

var
  FR: TFR;

implementation
uses poisk, shellapi,clipbrd,depo1,wrf;
{$R *.lfm}

{ TFR }

procedure TFR.FormCreate(Sender: TObject);
var f : text;
begin
  stringgrid1.LoadFromCSVFile('sys\forms.txt',#9);
  memo1.Lines.LoadFromFile('sys\index.frm');
  listbox1.Items.LoadFromFile('sys\stems1.txt');
  listbox3.Items.LoadFromFile('sys\stemsv.txt');
  stringgrid1.SelectedColor:=form1.stringGrid1.SelectedColor;
end;

procedure TFR.FormShow(Sender: TObject);
begin
  form1.BitBtn7.Caption:=caption;
  form1.BitBtn7.Show;
end;

procedure TFR.FormWindowStateChange(Sender: TObject);
begin
  if fr.windowstate = wsminimized then
  begin
     form1.Panel18.Show;
     form1.BitBtn7.Caption:=caption;
     form1.BitBtn7.Show;
  end;
end;

procedure TFR.Label4Click(Sender: TObject);
begin
  shellexecute(0,'Open','https://sanskrit.inria.fr/DICO/grammar.html','',nil,1);
end;

procedure TFR.MenuItem1Click(Sender: TObject);
var i : dword;
begin
  if stringgrid2.RowCount > 1 then
  for i := 1 to stringgrid2.RowCount - 1 do
     stringgrid2.Cells[6,i] := '✓';
  statusbar1.Panels[5].Text:=inttostr(stringgrid2.RowCount - 1);
end;

procedure TFR.MenuItem2Click(Sender: TObject);
var i,j : dword;
begin j := 0;
   if stringgrid2.RowCount > 1 then
   for i := 1 to stringgrid2.RowCount - 1 do
      if stringgrid2.Cells[6,i] <> '' then stringgrid2.Cells[6,i] := ''
      else
         begin
          stringgrid2.Cells[6,i] := '✓';
          inc(j);
         end;
   statusbar1.Panels[5].text := inttostr(j);
end;

procedure TFR.MenuItem3Click(Sender: TObject);
var i : dword;
begin
   if stringgrid2.RowCount > 1 then
   for i := 1 to stringgrid2.RowCount - 1 do
      stringgrid2.Cells[6,i] := '';
   statusbar1.Panels[5].Text:='0';

end;

procedure TFR.MenuItem4Click(Sender: TObject);
var i,j : dword; s : string;
begin  j := strtoint(statusbar1.Panels[5].Text);
       if stringgrid2.Row > 0 then
       begin
          s := stringgrid2.Cells[2,stringgrid2.Row];
          for i := 1 to stringgrid2.rowcount - 1 do
             if s = stringgrid2.Cells[2,i] then
             if stringgrid2.Cells[6,i] = '' then
             begin
                inc(j); stringgrid2.Cells[6,i] := '✓';
             end;
       end;
     statusbar1.Panels[5].Text:=inttostr(j);
end;

procedure TFR.MenuItem5Click(Sender: TObject);
var i,j : dword; s : string;
begin  j := strtoint(statusbar1.Panels[5].Text);
       if stringgrid2.Row > 0 then
       begin
          s := stringgrid2.Cells[1,stringgrid2.Row];
          for i := 1 to stringgrid2.rowcount - 1 do
             if s = stringgrid2.Cells[1,i] then
             if stringgrid2.Cells[6,i] = '' then
             begin
                inc(j); stringgrid2.Cells[6,i] := '✓';
             end;
       end;
     statusbar1.Panels[5].Text:=inttostr(j);


end;

procedure TFR.MenuItem6Click(Sender: TObject);
var i,j : dword; s : string;
begin  j := strtoint(statusbar1.Panels[5].Text);
       if stringgrid2.Row > 0 then
       begin
          s := stringgrid2.Cells[3,stringgrid2.Row];
          for i := 1 to stringgrid2.rowcount - 1 do
             if s = stringgrid2.Cells[3,i] then
             if stringgrid2.Cells[6,i] = '' then
             begin
                inc(j); stringgrid2.Cells[6,i] := '✓';
             end;
       end;
     statusbar1.Panels[5].Text:=inttostr(j);


end;

procedure TFR.MenuItem7Click(Sender: TObject);
var i,j : dword; s : string;
begin  j := strtoint(statusbar1.Panels[5].Text);
       if stringgrid2.Row > 0 then
       begin
          s := stringgrid2.Cells[4,stringgrid2.Row];
          for i := 1 to stringgrid2.rowcount - 1 do
             if s = stringgrid2.Cells[4,i] then
             if stringgrid2.Cells[6,i] = '' then
             begin
                inc(j); stringgrid2.Cells[6,i] := '✓';
             end;
       end;
     statusbar1.Panels[5].Text:=inttostr(j);


end;

procedure TFR.MenuItem8Click(Sender: TObject);
var i : dword;
begin
   if stringgrid2.RowCount > 1 then
   for i := 1 to stringgrid2.RowCount - 1 do
      if i < stringgrid2.RowCount then
      while ((i < stringgrid2.RowCount) and (stringgrid2.cells[6,i] <> '')) do stringgrid2.DeleteRow(i);
   statusbar1.Panels[1].Text:=inttostr(stringgrid2.RowCount - 1);
   statusbar1.Panels[5].Text:='0';
end;


procedure TFR.MenuItem9Click(Sender: TObject);
var s : string; i : dword;
begin
    if statusbar1.Panels[5].Text <> '0' then
    begin
       s := '';
       s := stringgrid2.Columns[0].Title.Caption+#9+
       stringgrid2.Columns[1].Title.Caption+#9+
       stringgrid2.Columns[2].Title.Caption+#9+
       stringgrid2.Columns[3].Title.Caption+#9+
       stringgrid2.Columns[4].Title.Caption+#9 + #13+#10;
       for i := 1 to stringgrid2.RowCount - 1 do
       if stringgrid2.Cells[6,i] <> '' then
          s := s +  stringgrid2.cells[0,i]+#9+
                    stringgrid2.cells[1,i]+#9+
                    stringgrid2.cells[2,i]+#9+
                    stringgrid2.cells[3,i]+#9+
                    stringgrid2.cells[4,i] + #13+#10;

         Clipboard.AsText:=s;
    end
    else
       form1.infx('Grammar forms directory','No records selected for save.');
end;

procedure TFR.Panel2Click(Sender: TObject);
begin

end;

procedure TFR.Edit1Change(Sender: TObject);
var a,w : word;
begin
   a := edit1.SelStart;
   w := length(edit1.Text);
   Edit1.Text := form1.convertx(edit1.Text);
   if w = length(edit1.Text) then edit1.SelStart:=a
   else   edit1.SelStart:= a - (w - length(edit1.Text)) + 1;
   edit1.SetFocus;
   edit1.SetFocus;
end;

procedure TFR.Edit2Change(Sender: TObject);
var a,w : word;
begin
   a := edit2.SelStart;
   w := length(edit2.Text);
   Edit2.Text := form1.convertx(edit2.Text);
   if w = length(edit2.Text) then edit2.SelStart:=a
   else   edit2.SelStart:= a - (w - length(edit2.Text)) + 1;
   edit2.SetFocus;
   Speedbutton2click(sender);


end;

procedure TFR.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  form1.BitBtn7.Hide;
  form1.p18;
end;

procedure TFR.SpeedButton1Click(Sender: TObject);
var i,j : dword;
  d1,d2,d3,d4,d5 : boolean;
  s : string;
begin
  if combobox2.ItemIndex = 0 then d1 := true else d1 := false;
  if combobox1.ItemIndex = 0 then d2 := false else d2 := true;
  if combobox1.ItemIndex = 1 then d3 := false else d3 := true;
  if combobox1.ItemIndex = 2 then d4 := false else d4 := true;
  if combobox1.ItemIndex = 3 then d5 := false else d5 := true;
  s := form1.Getconv(edit1.Text);
  j := 1; stringgrid2.RowCount:=stringgrid1.RowCount+1;
  progressbar1.Show;
  for i := 0 to stringgrid1.RowCount - 1 do
  begin
  progressbar1.Position:=round(i/stringgrid1.RowCount*100);
  if (chkwd(s,i,1,d1,d2,d3,d4,d5))
     then
  begin
    stringgrid2.Rows[j] := stringgrid1.Rows[i];
    inc(j);
  end;

  end;
  progressbar1.Hide;
  stringgrid2.RowCount:=j;
  if j > 1 then MenuItem3Click(Sender);
  statusbar1.Panels[1].Text:=inttostr(stringgrid2.RowCount - 1);
end;

procedure TFR.SpeedButton1MouseEnter(Sender: TObject);
begin
//  Speedbutton1.Transparent:=false;
end;

procedure TFR.SpeedButton1MouseLeave(Sender: TObject);
begin
//  Speedbutton1.Transparent:=true;
end;

procedure TFR.SpeedButton2Click(Sender: TObject);
var i,j,k : dword;
  d1,d2,d3,d4,d5 : boolean;
  s,s1,s2 : string;
begin  k := 0;
  if combobox2.ItemIndex = 0 then d1 := true else d1 := false;
  if combobox1.ItemIndex = 0 then d2 := false else d2 := true;
  if combobox1.ItemIndex = 1 then d3 := false else d3 := true;
  if combobox1.ItemIndex = 2 then d4 := false else d4 := true;
  if combobox1.ItemIndex = 3 then d5 := false else d5 := true;
  s := form1.Getconv(edit2.Text);
  j := 1; stringgrid2.RowCount:=stringgrid1.RowCount+1;
  if edit2.Text <> '' then
  for i := 0 to listbox1.Items.Count - 1 do
  if chkwd2(s,i,true,d2,d3,d4,d5) then
  begin
     s1:= memo1.Lines.Strings[i];
     while s1 <> '' do
     begin
       s2  := copy(s1,1,pos(' ',s1)-1);delete(s1,1,pos(' ',s1));
       k := strtoint(s2)-1;
      if chkwd(s,k,2,d1,d2,d3,d4,d5) then
      begin
       stringgrid2.Rows[j] := stringgrid1.Rows[k];
       inc(j);
      end;
     end;
   end;
  stringgrid2.RowCount:=j;
  if j > 1 then MenuItem3Click(Sender);
//  break;

  statusbar1.Panels[1].Text:=inttostr(stringgrid2.RowCount - 1);
end;

procedure TFR.SpeedButton2MouseEnter(Sender: TObject);
begin
//  Speedbutton2.Transparent:=false;
end;

procedure TFR.SpeedButton2MouseLeave(Sender: TObject);
begin
//  Speedbutton2.Transparent:=true;
end;

procedure TFR.StringGrid2Click(Sender: TObject);
var i : dword;
begin   i := strtoint(statusbar1.Panels[5].Text);
  if (stringgrid2.Row > 0) and (stringgrid2.Col = 6) then
  if stringgrid2.Cells[6,stringgrid2.Row] <> '' then
  begin
    stringgrid2.Cells[6,stringgrid2.Row]  := ''; dec(i);
  end
  else begin
       stringgrid2.Cells[6,stringgrid2.Row] := '✓';
       inc(i);
  end;
  statusbar1.Panels[5].Text:= inttostr(i);;
end;

procedure TFR.StringGrid2DblClick(Sender: TObject);
var i : dword;  z : boolean;
begin  z := false;
 if stringgrid2.RowCount > 1 then
 begin
   case stringgrid2.Col of
           0 :;
           1 :;
           2 :begin
               for i := 0 to depo.Stringgrid1.RowCount - 1 do
               if stringgrid2.Cells[2,stringgrid2.Row] =
                  depo.Stringgrid1.cells[1,i] then begin z := true; break; end;
              if z  then
              begin
                form1.getexam(depo.Stringgrid1.cells[3,i],0,0,0,0,0);
                wr.show;
                wr.Caption:='Examples for using a word: "'+stringgrid2.Cells[2,stringgrid2.Row]+'"';
              end;




           end;
           3 :;
   end;
 end;
end;

function TFR.chkwd(s : string; i : dword; fs : byte; d1,d2,d3,d4,d5 : boolean) : boolean;
var    s1 : string;
begin
  if checkbox1.Checked then
    s1 := stringgrid1.Cells[fs+5,i]
  else
  s1 := stringgrid1.Cells[fs,i];
  if d1 = false then if stringgrid1.Cells[4,i] = combobox2.Text then d1 := true;
  if s <> '' then
  begin
  if d2 = false then
  if pos(s,s1) = 1 then d2 := true;

  if d3 = false then
    if pos(s+' ',s1+' ') > 0 then d3 := true;
  if d4 = false then
    if pos(s,s1) > 0 then d4 := true;

  if d5 = false then
    if s = s1  then d5 := true;
  end
  else begin d2 := true;d3:=d2;d4:=d3;d5:=d4;end;
  if d1 and d2 and d3 and d4 and d5 then chkwd := true else chkwd := false;

end;
function TFR.chkwd2(s : string; i : dword;  d1,d2,d3,d4,d5 : boolean) : boolean;
var    s1 : string;
begin
  if checkbox1.Checked then
  s1 := listbox3.Items[i] else
  s1 := listbox1.Items[i];
  d1 := true;

  if d2 = false then
  if pos(s,s1) = 1 then d2 := true;

  if d3 = false then
    if pos(s+' ',s1+' ') > 0 then d3 := true;
  if d4 = false then
    if pos(s,s1) > 0 then d4 := true;

  if d5 = false then
    if s = s1  then d5 := true;

  if d1 and d2 and d3 and d4 and d5 then chkwd2 := true else chkwd2 := false;

end;

end.

