unit tcf;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Grids, Buttons, Menus;

type

  { TTTS }

  TTTS = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    Separator3: TMenuItem;
    Separator2: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Separator1: TMenuItem;
    Panel4: TPanel;
    SpeedButton1: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PageControl1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseEnter(Sender: TObject);
    procedure SpeedButton1MouseLeave(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure StringGrid2Click(Sender: TObject);
    procedure StringGrid2DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure StringGrid2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure StringGrid2KeyPress(Sender: TObject; var Key: char);
    procedure StringGrid3Click(Sender: TObject);
    procedure StringGrid3DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure StringGrid3DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure StringGrid3KeyPress(Sender: TObject; var Key: char);
    procedure StringGrid3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public
    function get1(s : string; i : integer) : boolean;
    function aGet(i : dword) : boolean;
    function oGet(i : dword) : boolean;
    function nGet(i : dword) : boolean;
    function CLm(s : string) : string;
  end;

var
  TTS: TTTS;

implementation
uses poisk,lns1,tx1;
{$R *.lfm}

{ TTTS }

procedure TTTS.PageControl1Change(Sender: TObject);
begin

end;

procedure TTTS.Button2Click(Sender: TObject);
begin
{
  case pagecontrol1.TabIndex of
  0 : begin
        stringgrid1.RowCount:=1;
        Tabsheet1.Caption:='"AND" List ('+inttostr(stringgrid1.RowCount - 1)+')';

      end;
  1 : begin
        stringgrid2.RowCount:=1;
        Tabsheet2.Caption:='"OR" List ('+inttostr(stringgrid2.RowCount - 1)+')';
      End;
  2 : Begin
        stringgrid3.RowCount:=1;
        Tabsheet3.Caption:='"NOT" List ('+inttostr(stringgrid3.RowCount - 1)+')';
      End;
  end;
}
end;

procedure TTTS.Button1Click(Sender: TObject);
var i,j,k : integer;
    s,sx : string;
    F : system.text;
    z : boolean;
    jf: integer;
    l : word;
    d1,d2,d3 : boolean;

begin sx := '';

// button6click(sender);
// button5click(sender);
   l := 0;
   jf := 0;
   lns.ListBox2.clear;
   lns.hw1.Clear;
   lns.Memo2.Clear;
   lns.memo3.Clear;
   lns.StringGrid1.RowCount:=621446;;
   listbox1.Clear;
   listbox2.Clear;
   listbox3.Clear;
   if stringgrid1.RowCount > 1 then
   begin s := '';
     for i := 1 to stringgrid1.RowCount - 1 do
     if stringgrid1.Cells[2,i] = '1' then
     s := s + stringgrid1.Cells[0,i]+ ' ';
     if s <> '' then
     begin
       form1.getindexes(s);
       listbox2.items.Text:=form1.ListBox1.Items.Text;
     end;

   end;
   if stringgrid2.RowCount > 1 then
   begin s := '';
     for i := 1 to stringgrid2.RowCount - 1 do
     if stringgrid2.Cells[2,i] = '1' then
     s := s + stringgrid2.Cells[0,i]+' ';
     if s <> '' then
     begin
       form1.getindexes(s);
       listbox3.items.Text:=form1.ListBox1.Items.Text;
     end;
   end;
   if stringgrid3.RowCount > 1 then
   begin s := '';
     for i := 1 to stringgrid3.RowCount - 1 do
     if stringgrid3.Cells[2,i] = '1' then
     s := s + stringgrid3.Cells[0,i]+' ';
     if s <> '' then
     begin
        form1.getindexes(s);
        listbox1.items.Text:=form1.ListBox1.Items.Text;
     end;
   end;

 j := 0;
 For i := 0 to stringgrid4.RowCount - 1 do
 begin
   d1 := false; d2 := false; d3 := false;
   d3 := nGet(i);
//   if d3 then showmessage('NOT!');
   if d3 then d1 := aGet(i);
//   if D1 then showmessage('and');
   if d1 then d2 := oGet(i);
//   if d2 then showmessage('OR');
   if d1 and d2 and d3 then
   begin
     inc(j);
     lns.StringGrid1.Rows[j] := stringgrid4.Rows[i];
   end;
 end;
lns.StringGrid1.RowCount:=j+1;

  tts.FormStyle := fsnormal;
  lns.Show;
//lns.Memo2.Text:= 'Исключения: ' + stringgrid3.;
Exit;
if stringgrid1.RowCount > 1 then
begin

  l := 0;
  jf := 0;
  lns.ListBox2.clear;
  lns.hw1.Clear;
  lns.Memo2.Clear;
  lns.memo3.Clear;
  lns.StringGrid1.RowCount:=621446;;
  for i := 0 to stringgrid4.RowCount - 1 do
  begin
        l := 0;
  for j := 1 to stringgrid1.RowCount - 1 do
  if pos('NOT',stringgrid1.Cells[0,j]) = 0 then
  begin
    if get1(stringgrid1.Cells[1,j],i) = true then inc(l)
  end
  else
  begin
   if get1(stringgrid1.Cells[1,j],i) = false then
   begin
     inc(l)
   end;  ;
   end;
       if l = stringgrid1.RowCount - 1 then
       begin
         lns.ListBox2.Items.Add(inttostr(i));
         inc(jf);
         lns.StringGrid1.Rows[jf] := stringgrid4.Rows[i];
       end;
  end;
  lns.StringGrid1.RowCount:=jf+1;
  if jf > 0 then
  begin
    tts.FormStyle:=fsnormal;
    sx := 'Total Text fragments found: ' + inttostr(lns.StringGrid1.RowCount - 1) +#13+#10;
    sx := sx + 'Request: ';
    for i := 1 to stringgrid1.RowCount - 1 do
    begin
      sx := sx + stringgrid1.Cells[0,i]+'&';
    end;
    lns.Memo2.Text := sx;
    lns.Memo2.SelStart:=0;
    if lns.WindowState = wsminimized then
    lns.WindowState:=wsnormal;
    lns.Show;
    lns.BringToFront;
  end
  else
  ShowMessage('Not found in current DCS Data');
end
else
showmessage('the "AND" List is EMTY. Please add items to this list.');
end;

procedure TTTS.Button3Click(Sender: TObject);
begin
{
  case pagecontrol1.TabIndex of
  0 : if stringgrid1.Row > 0 then
      begin
        stringgrid1.DeleteRow(stringgrid1.row);
        Tabsheet1.Caption:='"AND" List ('+inttostr(stringgrid1.RowCount - 1)+')';

      end;
  1 :if stringgrid2.Row > 0 then
    begin
        stringgrid2.DeleteRow(stringgrid2.row);
        Tabsheet2.Caption:='"OR" List ('+inttostr(stringgrid2.RowCount - 1)+')';
      end;
  2 :if stringgrid3.Row > 0 then
    begin
        stringgrid3.DeleteRow(stringgrid3.row);
        Tabsheet3.Caption:='"NOT" List ('+inttostr(stringgrid3.RowCount - 1)+')';
      End;
  end;
}
end;

procedure TTTS.Button4Click(Sender: TObject);
begin
      stringgrid1.RowCount:=1;
      stringgrid2.RowCount:=1;
      stringgrid3.RowCount:=1;

end;

procedure TTTS.Button5Click(Sender: TObject);
var xx,zz : integer;
    s,s1 : string;
begin
    xx := stringgrid1.RowCount;
    inc(xx);
    stringgrid1.RowCount:=xx;
    s := '';s1 :='';
    zz := 0;
    if stringgrid2.RowCount > 2 then
    for zz := 1 to stringgrid2.RowCount - 2 do
    begin
       s := s + stringgrid2.Cells[1,zz];
       s1 := s1 + stringgrid2.Cells[0,zz] + ' OR ';
    end;
    s := s + stringgrid2.Cells[1,zz +1];
    s1 := s1 + stringgrid2.Cells[0,zz+1] + '';
    stringgrid1.Cells[0,xx - 1] :='('+s1+')';
    stringgrid1.Cells[1,xx - 1] :=s;

    Stringgrid2.RowCount:=1;

end;

procedure TTTS.Button6Click(Sender: TObject);
var xx,zz : integer;
    s,s1 : string;
begin
    xx := stringgrid1.RowCount;
    inc(xx);
    stringgrid1.RowCount:=xx;
    s := '';s1 :='';
    zz := 0;
    if stringgrid3.RowCount > 2 then
    for zz := 1 to stringgrid3.RowCount - 2 do
    begin
       s := s + stringgrid3.Cells[1,zz];
       s1 := s1 + stringgrid3.Cells[0,zz] + ' ';
    end;
    s := s + stringgrid3.Cells[1,zz +1];
    s1 := s1 + stringgrid3.Cells[0,zz+1] + '';
    stringgrid1.Cells[0,xx - 1] :='NOT('+s1+')';
    stringgrid1.Cells[1,xx - 1] :=s;

    Stringgrid3.RowCount:=1;


end;

procedure TTTS.Edit1Change(Sender: TObject);
begin
  edit1.Text:=form1.convertx((edit1.Text));
  edit1.SelStart:=length(edit1.Text);
  edit1.SetFocus;
end;

procedure TTTS.FormActivate(Sender: TObject);
begin
//  stringgrid1.Columns[0].Width:=250;
end;

procedure TTTS.FormCreate(Sender: TObject);
var i : longint;
    s : string;
begin
  if fileexists('sys\t\0.csv') then
  begin
    Stringgrid4.LoadFromCSVFile('sys\t\0.csv',';');
    for i := 0 to stringgrid4.RowCount - 1 do
    begin
       s := ','+stringgrid4.Cells[3,i];
       stringgrid4.Cells[3,i] := s;

    end;
  end
 else
   Showmessage('NO important file!');
end;

procedure TTTS.Label2Click(Sender: TObject);
var i,j,k,l,x : longint;

    s,s1,s2 : string;
    A : Array of longint;
begin
{
    formstyle := fsnormal;
    form1.WindowState:= wsminimized;
    hide;
    s2 :=',';
    for i :=0to stringgrid4.RowCount - 1 do
    begin
      s := stringgrid4.Cells[3,i];
      delete(s,1,1);
      k := 0;
      while s <> '' do
      begin
         s1 := copy(s,1,pos(',',s));
         delete(s,1,pos(',',s));
         if pos(','+s1+',',s2) = 0 then
         begin
           s2 := s2 +s1;
           inc(k);
         end;
      end;
      setlength(A,k);
      delete(s2,1,1);
      for j := 0 to k - 1 do
      if s2 <> '' then
      begin

        s1 := copy(s2,1,pos(',',s2) - 1);
        delete(s2,1,pos(',',s2));
        if s1 <> '' then
        a[j] := strtoint(s1)
        else a[j] :=0;
      end;
      for j := 0 to k - 1 do
      for x := 0 to k - 2 do
          if a[x] > a[x+1] then
      begin
        l := a[x]; a[x] := a[x+1]; a[x+1] := l;
      end;
      s2 := ',';
      for j  := 0 to length(a) - 1 do
      s2 := s2 + inttostr(a[j])+',';
      stringgrid4.Cells[3,i] := s2;

    end;

    stringgrid4.SaveToCSVFile('sys\t\_0_.txt',';');
}
end;

procedure TTTS.MenuItem10Click(Sender: TObject);
var i : dword;
begin
  if stringgrid2.RowCount > 1 then
  for i := 1 to stringgrid2.RowCount - 1 do
  if stringgrid2.Cells[2,i] = '1' then stringgrid2.Cells[2,i] := '0'
  else stringgrid2.Cells[2,i] := '1';

end;

procedure TTTS.MenuItem11Click(Sender: TObject);
var i : dword;
begin
    if stringgrid2.RowCount > 1 then
    for i := 1 to stringgrid2.RowCount - 1 do stringgrid2.Cells[2,i] := '0';

end;

procedure TTTS.MenuItem12Click(Sender: TObject);
var i : dword;
begin
    if stringgrid2.RowCount > 1 then
    for i := 1 to stringgrid2.RowCount - 1 do stringgrid2.Cells[2,i] := '1';

end;

procedure TTTS.MenuItem13Click(Sender: TObject);
var i : dword;
begin
  if stringgrid3.RowCount > 1 then
  for i := 1 to stringgrid3.RowCount - 1 do
  if stringgrid3.Cells[2,i] = '1' then stringgrid3.Cells[2,i] := '0'
  else stringgrid3.Cells[2,i] := '1';

end;

procedure TTTS.MenuItem14Click(Sender: TObject);
var i : dword;
begin
    if stringgrid3.RowCount > 1 then
    for i := 1 to stringgrid3.RowCount - 1 do stringgrid3.Cells[2,i] := '0';

end;

procedure TTTS.MenuItem15Click(Sender: TObject);
var i : dword;
begin
    if stringgrid3.RowCount > 1 then
    for i := 1 to stringgrid3.RowCount - 1 do stringgrid3.Cells[2,i] := '1';

end;

procedure TTTS.MenuItem1Click(Sender: TObject);
begin
  if stringgrid1.Row > 0 then
  stringgrid1.DeleteRow(stringgrid1.Row);
end;

procedure TTTS.MenuItem2Click(Sender: TObject);
begin
  stringgrid1.Clear;
  stringgrid1.RowCount:=1;
end;

procedure TTTS.MenuItem3Click(Sender: TObject);
begin
  if stringgrid2.Row > 0 then
  stringgrid2.DeleteRow(stringgrid2.Row);
end;

procedure TTTS.MenuItem4Click(Sender: TObject);
begin
  Stringgrid2.Clear;
  stringgrid2.RowCount:=1;
end;

procedure TTTS.MenuItem5Click(Sender: TObject);
begin
  if stringgrid3.Row > 0 then
  stringgrid3.DeleteRow(stringgrid3.Row);
end;

procedure TTTS.MenuItem6Click(Sender: TObject);
begin
  Stringgrid3.Clear;
  stringgrid3.RowCount:=1;
end;

procedure TTTS.MenuItem7Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount - 1 do
  if stringgrid1.Cells[2,i] = '1' then stringgrid1.Cells[2,i] := '0'
  else stringgrid1.Cells[2,i] := '1';
end;

procedure TTTS.MenuItem8Click(Sender: TObject);
var i : dword;
begin
    if stringgrid1.RowCount > 1 then
    for i := 1 to stringgrid1.RowCount - 1 do stringgrid1.Cells[2,i] := '0';

end;

procedure TTTS.MenuItem9Click(Sender: TObject);
var i : dword;
begin
    if stringgrid1.RowCount > 1 then
    for i := 1 to stringgrid1.RowCount - 1 do stringgrid1.Cells[2,i] := '1';
end;

procedure TTTS.PageControl1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin


end;

procedure TTTS.PageControl1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin

end;

procedure TTTS.SpeedButton1Click(Sender: TObject);
var i : dword; x : dword;s,s1 : string;z : dword;
    q : boolean;
begin x := 1;
{for i := 0 to stringgrid4.RowCount - 1 do
if stringgrid4.Cells[3,i] <> '' then
begin
  s := stringgrid4.Cells[3,i];
  s1 := '';
  stringgrid4.Cells[3,i] := ' ';
  delete(s,1,1);
  while s <> '' do
  begin
  s1 := copy(s,1,pos(',',s)-1);
  delete(s,1,pos(',',s));
  if s1 <> '' then
  if strtoint(s1) < length(O) then
  begin
  stringgrid4.Cells[3,i] := stringgrid4.Cells[3,i]+
  o[strtoint(s1)].stem+' ';
  end;
  end;
end;
stringgrid4.SaveToCSVFile('00000.csv',#9);
 showmessage('done');
exit;
}
  q := false;
  lns.ListBox2.clear;
  lns.ListBox1.clear;
  lns.hw1.Clear;
  lns.Memo2.Clear;
  lns.memo3.Clear;
  lns.StringGrid1.Clear;
  lns.StringGrid1.RowCount:=645221;
  s := {form1.convertx(form1.Getconv(}edit1.Text{))};


if combobox1.ItemIndex = 1 then
   for i := 0 to stringgrid4.RowCount - 1 do
   if pos(s,stringgrid4.Cells[4,i]) > 0 then
   begin
    lns.StringGrid1.Rows[x] := stringgrid4.Rows[i];
    inc(x);
   end;
if combobox1.ItemIndex = 0 then
   for i := 0 to stringgrid4.RowCount - 1 do
   begin
     if form1.isword(stringgrid4.Cells[4,i],s) then q := true;
{
   z := pos(s,stringgrid4.Cells[4,i]);
   if z > 0 then
   begin
      if s = stringgrid4.Cells[4,i] then q := true;

      if q = false then
      if (z = 1) and (stringgrid4.Cells[4,i][z+length(s)] in sbl) then q := true;

      if q = false then
      if (z > 1) and (z + length(stringgrid4.Cells[4,i]) - 1  = length(s)) then q := true;

      if q = false then
      if (stringgrid4.Cells[4,i][z-1] in sbl) and
         (stringgrid4.Cells[4,i][z+length(s)] in sbl) then q := true;

}
      if q then
      begin
       lns.StringGrid1.Rows[x] := stringgrid4.Rows[i];
       inc(x);
       q := false;
      end;
   end;



   lns.StringGrid1.RowCount:=x;
   lns.Memo2.Text:='Your request: '+edit1.Text;
   lns.Memo2.SelStart:=0;
   lns.Show;
end;

procedure TTTS.SpeedButton1MouseEnter(Sender: TObject);
begin
//  speedbutton1.Transparent:=false;
end;

procedure TTTS.SpeedButton1MouseLeave(Sender: TObject);
begin
//  Speedbutton1.Transparent:=true;
end;

procedure TTTS.StringGrid1Click(Sender: TObject);
begin
  if stringgrid1.Row > 0 then
  if stringgrid1.col = 2 then
  if stringgrid1.Cells[2,stringgrid1.Row] = '0' then
     stringgrid1.Cells[2,stringgrid1.Row] := '1' else
       stringgrid1.Cells[2,stringgrid1.Row] := '0';
end;

procedure TTTS.StringGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if source = Form1.StringGrid1 then
  begin
     if form1.StringGrid1.Row > 0 then
        if form1.StringGrid1.Cells[3,form1.StringGrid1.Row] <> '' then
        begin
          Stringgrid1.RowCount:= stringgrid1.RowCount+1;
          StringGrid1.Cells[0,stringgrid1.RowCount-1] := form1.StringGrid1.Cells[1,form1.StringGrid1.Row];
          StringGrid1.Cells[1,stringgrid1.RowCount-1] := form1.StringGrid1.Cells[3,form1.StringGrid1.Row];
          Stringgrid1.Cells[2,stringgrid1.RowCount-1] := '1';
        end;
  end;
  if source = Stringgrid2 then
  if stringgrid2.Row > 0 then
    begin
       stringgrid1.RowCount:=stringgrid1.RowCount + 1;
       stringgrid1.Rows[stringgrid1.RowCount-1] :=
       stringgrid2.Rows[stringgrid2.Row];
       stringgrid2.DeleteRow(stringgrid2.row);
    end;
  if source = Stringgrid3 then
  if stringgrid3.Row > 0 then
    begin
       stringgrid1.RowCount:=stringgrid1.RowCount + 1;
       stringgrid1.Rows[stringgrid1.RowCount-1] :=
       stringgrid3.Rows[stringgrid3.Row];
       stringgrid3.DeleteRow(stringgrid3.row);
    end;
  tts.SetFocus;
end;

procedure TTTS.StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
//  Accept := Source = form1.StringGrid1;
end;

procedure TTTS.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
  if key = #46 then button3click(sender);
end;

procedure TTTS.StringGrid2Click(Sender: TObject);
begin
  if stringgrid2.Row > 0 then
  if stringgrid2.col = 2 then
  if stringgrid2.Cells[2,stringgrid2.Row] = '0' then
     stringgrid2.Cells[2,stringgrid2.Row] := '1' else
       stringgrid2.Cells[2,stringgrid2.Row] := '0';
end;

procedure TTTS.StringGrid2DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if source = form1.StringGrid1 then
  if form1.StringGrid1.Row > 0 then
    if form1.StringGrid1.Cells[3,form1.StringGrid1.Row] <> '' then
    begin
      Stringgrid2.RowCount:= stringgrid2.RowCount+1;
      StringGrid2.Cells[0,stringgrid2.RowCount-1] := form1.StringGrid1.Cells[1,form1.StringGrid1.Row];
      StringGrid2.Cells[1,stringgrid2.RowCount-1] := form1.StringGrid1.Cells[3,form1.StringGrid1.Row];
      Stringgrid2.Cells[2,stringgrid2.RowCount-1] := '1';
    end;
  if source = Stringgrid1 then
  if stringgrid1.Row > 0 then
    begin
       stringgrid2.RowCount:=stringgrid2.RowCount + 1;
       stringgrid2.Rows[stringgrid2.RowCount-1] :=
       stringgrid1.Rows[stringgrid1.Row];
       stringgrid1.DeleteRow(stringgrid1.row);
    end;
  if source = Stringgrid3 then
  if stringgrid3.Row > 0 then
    begin
       stringgrid2.RowCount:=stringgrid2.RowCount + 1;
       stringgrid2.Rows[stringgrid2.RowCount-1] :=
       stringgrid3.Rows[stringgrid3.Row];
       stringgrid3.DeleteRow(stringgrid3.row);
    end;
  tts.SetFocus;
end;

procedure TTTS.StringGrid2DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
//  Accept := Source = form1.StringGrid1;
end;

procedure TTTS.StringGrid2KeyPress(Sender: TObject; var Key: char);
begin
  if key = #46 then button3click(sender);
end;

procedure TTTS.StringGrid3Click(Sender: TObject);
begin
  if stringgrid3.Row > 0 then
  if stringgrid3.col = 2 then
  if stringgrid3.Cells[2,stringgrid3.Row] = '0' then
     stringgrid3.Cells[2,stringgrid3.Row] := '1' else
       stringgrid3.Cells[2,stringgrid3.Row] := '0';
end;

procedure TTTS.StringGrid3DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if source = form1.StringGrid1 then
  if form1.StringGrid1.Row > 0 then
    if form1.StringGrid1.Cells[3,form1.StringGrid1.Row] <> '' then
    begin
      Stringgrid3.RowCount:= stringgrid3.RowCount+1;
      StringGrid3.Cells[0,stringgrid3.RowCount-1] := form1.StringGrid1.Cells[1,form1.StringGrid1.Row];
      StringGrid3.Cells[1,stringgrid3.RowCount-1] := form1.StringGrid1.Cells[3,form1.StringGrid1.Row];
      Stringgrid3.Cells[2,stringgrid3.RowCount-1] := '1';
   end;
  if source = Stringgrid1 then
  if stringgrid1.Row > 0 then
    begin
       stringgrid3.RowCount:=stringgrid3.RowCount + 1;
       stringgrid3.Rows[stringgrid3.RowCount-1] :=
       stringgrid1.Rows[stringgrid1.Row];
       stringgrid1.DeleteRow(stringgrid1.row);
    end;
  if source = Stringgrid2 then
  if stringgrid2.Row > 0 then
    begin
       stringgrid3.RowCount:=stringgrid3.RowCount + 1;
       stringgrid3.Rows[stringgrid3.RowCount-1] :=
       stringgrid2.Rows[stringgrid2.Row];
       stringgrid2.DeleteRow(stringgrid2.row);
    end;

  tts.SetFocus;

end;

procedure TTTS.StringGrid3DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
//  Accept := Source = form1.StringGrid1;
end;

procedure TTTS.StringGrid3KeyPress(Sender: TObject; var Key: char);
begin
  if key = #46 then button3click(sender);
end;

procedure TTTS.StringGrid3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;
function ttts.get1(s : string; i : integer) : boolean;
var z : boolean;
    a : byte;
    x,d : string;
begin
  listbox1.Clear;
  if pos(' ',s) <> 0 then
  while s <> '' do
  begin
    x := copy(s,1,pos(' ',s)-1);
    delete(s,1,pos(' ',s));
    listbox1.items.Add(x);
  end;

  z := false;
  for a := 0 to listbox1.Items.Count - 1 do
  if pos(','+listbox1.Items[a]+',',stringgrid4.Cells[3,i]) > 0 then
  z := true;
  get1 := z;
end;

function ttts.aGet(i : dword) : boolean;
var j : dword; z : boolean;
begin z := true;
      if listbox2.Items.Count > 0 then
      for j := 0 to listbox2.Items.Count - 1 do
      if (listbox2.Items[j] <> '') and
         (listbox2.Items[j] <> ' ') then
      if pos(','+listbox2.Items[j]+',',clm(stringgrid4.Cells[3,i])) = 0 then
      begin
        z := false;
        break;
      end;
      aGet := z;
end;
function ttts.oGet(i : dword) : boolean;
var j : dword; z : boolean;
begin z := false;
      if listbox3.Items.Count > 0 then
      begin
      for j := 0 to listbox3.Items.Count - 1 do
      if (listbox3.Items[j] <> '') and
         (listbox3.Items[j] <> ' ') then
      if pos(','+listbox3.Items[j]+',',clm(stringgrid4.Cells[3,i])) > 0 then
      begin
        z := true;
        break;
      end;
      end
      else z := true;

      oGet := z;
end;
function ttts.nGet(i : dword) : boolean;
var j : dword; z : boolean;
begin z := true;
      if listbox1.Items.Count > 0 then
      for j := 0 to listbox1.Items.Count - 1 do
      if (listbox1.Items[j] <> '') and
         (listbox1.Items[j] <> ' ') then
      if pos(','+listbox1.Items[j]+',',clm(stringgrid4.Cells[3,i])) > 0 then
      begin
        z := false;
        break;
      end;
      nGet := z;
end;
function TTTS.CLm(s : string) : string;
var s2,s3 : string; k : dword;
begin s2 := ',';
  if pos(',',s) = 1 then delete(s,1,1);
   while s <> '' do
   begin
   s3 := copy(s,1,pos(',',s)-1);
   if s3 <> '' then
   begin
    k := strtoint(s3);
    if k <= length(o) then
    s2 := s2 + o[k].stem + ',';
    end;
    delete(s,1,pos(',',s));
    if s3 = '' then s := '';
   end;
   Clm := s2;
end;

end.

