unit dF;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, Grids, ComCtrls, Menus, EditBtn;

type

  { TForm3 }

  TForm3 = class(TForm)
    SpeedButton4: TButton;
    SpeedButton5: TButton;
    SpeedButton2: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    Separator4: TMenuItem;
    PopupMenu2: TPopupMenu;
    Separator3: TMenuItem;
    Separator2: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Separator1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure getM;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton2MouseEnter(Sender: TObject);
    procedure SpeedButton2MouseLeave(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton4MouseEnter(Sender: TObject);
    procedure SpeedButton4MouseLeave(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton5MouseEnter(Sender: TObject);
    procedure SpeedButton5MouseLeave(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private

  public
   procedure gettrd(s : string);
   function chkdf(s,s1 : string; d1,d2,d3,d4 : boolean) : boolean;
  end;

var
  Form3: TForm3;

implementation
uses depo1,poisk,reult1;
{$R *.lfm}

{ TForm3 }

procedure TForm3.SpeedButton1Click(Sender: TObject);
var i,j : dword;
begin j := 0;
    Setlength(ddl,stringgrid3.RowCount);

    for i := 0 to stringgrid3.RowCount - 1 do
    if (stringgrid3.Cells[2,i] <> '')  and
       (pos('#'+stringgrid1.Cells[0,stringgrid1.Row]+'#',
       stringgrid3.Cells[1,i]) > 0) then
       begin
         form1.FillDlist(strtoint(stringgrid3.Cells[2,i]));
         dlist[1].ID:=strtoint(stringgrid3.Cells[2,i]);
         dlist[1].wd:= stringgrid3.Cells[0,i];

         ddl[j] := dlist;
         inc(j);
       end;
       setlength(ddl,j);
       form1.SpeedButton27click(sender);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  stringgrid3.ColCount:=3;
  stringgrid3.RowCount := 71240;
  stringgrid3.LoadFromCSVFile('sys\syn\sm\d.csv',#9);
  stringgrid4.ColCount:=2;
  stringgrid4.RowCount:=84835;
  stringgrid4.LoadFromCSVFile('sys\syn\sm\dfx.csv',#9);
end;

procedure TForm3.MenuItem10Click(Sender: TObject);
begin
  if stringgrid1.Row > 0 then
  begin
     stringgrid2.RowCount:=stringgrid2.RowCount +1;
     stringgrid2.Rows[stringgrid2.RowCount - 1] := stringgrid1.Rows[stringgrid1.Row];
  end;
end;

procedure TForm3.MenuItem11Click(Sender: TObject);
begin
  Speedbutton2click(sender);
end;

procedure TForm3.MenuItem12Click(Sender: TObject);
begin
  if stringgrid2.Row > 0 then
  stringgrid2.DeleteRow(stringgrid2.Row);
  statusbar1.Panels[5].Text:=inttostr(stringgrid2.RowCount-1);
end;

procedure TForm3.MenuItem13Click(Sender: TObject);
begin
  Speedbutton5click(sender);
end;

procedure TForm3.MenuItem14Click(Sender: TObject);
var i,j,k : dword; s,s1,s2 : string;
    f ,f1 : text; c,d : dword;
begin //assignfile(f,'sys\syn\s1.csv');reset(f);
      Application.Minimize;
      assignfile(f,'sys\syn\s1.txt');rewrite(f);
      for i := 0 to stringgrid4.RowCount - 1 do
      begin s := stringgrid4.Cells[0,i] +#9;
      for j := 0 to stringgrid3.RowCount-1 do
      if  pos('#'+stringgrid4.Cells[0,i]+'#',stringgrid3.Cells[1,j]) > 0 then
      s := s + stringgrid3.cells[2,j] + #9;
         while pos(#9+#9,s) > 0 do delete(s,
         pos(#9+#9,s),1);
         writeln(f,s);
      end;
      closefile(f);


      memo1.Lines.LoadFromFile('sys\syn\s1.txt');
      assignfile(f1,'sys\syn\s2.csv');rewrite(f1);
  for i := 0 to stringgrid3.RowCount - 1 do
  begin
    c := 0;
    d := 0;
    s := #9+stringgrid3.Cells[2,i] + #9;
    s2 := s;
    for j := 0 to memo1.Lines.Count - 1 do
    if pos(s,memo1.Lines.Strings[j]) > 0 then
       begin s1 := memo1.Lines.Strings[j];
             delete(s1,1,pos(#9,s1));
         s := s + s1 + #9;
         inc(c);
         while pos(#9,s1) > 0 do begin
           delete(s1,pos(#9,s1),1); inc(d);
         end;
       end;
    while pos(s2,s) > 0 do delete(s,pos(s2,s),length(s2)-1);
    if d > 1 then
    writeln(f1,depo.StringGrid1.Cells[1,
    strtoint(stringgrid3.Cells[2,i])],
    '#',stringgrid3.Cells[2,i],'#',s);
  end;
  closefile(f1);
  showmessage(' ');
end;

procedure TForm3.MenuItem1Click(Sender: TObject);
var i : dword;
begin
    for i := 1 to stringgrid1.RowCount - 1 do
    stringgrid1.Cells[2,i] := form1.SpeedButton21.Caption;
    statusbar1.Panels[3].Text:=inttostr(stringgrid1.RowCount - 1);
end;

procedure TForm3.MenuItem2Click(Sender: TObject);
var i: dword;s : string;
begin
    if stringgrid1.Row > 0 then
       begin
         s := stringgrid1.Cells[1,stringgrid1.Row];
         for i := 1 to stringgrid1.RowCount - 1 do
         if s = stringgrid1.Cells[1,i] then stringgrid1.Cells[2,i] :=
         form1.SpeedButton21.Caption;
         getM;
       end;
end;

procedure TForm3.MenuItem3Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount - 1 do
  if stringgrid1.Cells[2,i] = '' then
  stringgrid1.Cells[2,i] := form1.SpeedButton21.Caption else
    stringgrid1.Cells[2,i] := '';
  getM;
end;

procedure TForm3.MenuItem4Click(Sender: TObject);
var i : dword;
begin
   if stringgrid1.RowCount > 1 then
   for i := 1 to stringgrid1.RowCount - 1 do
   stringgrid1.Cells[2,i] := '';
   statusbar1.Panels[3].Text:='0';
end;

procedure TForm3.MenuItem5Click(Sender: TObject);
begin
  Speedbutton4click(sender);
end;

procedure TForm3.MenuItem6Click(Sender: TObject);
begin
  SpeedButton1Click(Sender);
end;

procedure TForm3.MenuItem9Click(Sender: TObject);
begin
  speedbutton5click(sender);
end;

procedure TForm3.Edit1Change(Sender: TObject);
var i : dword;
begin
  //if edit1.Text <> '' then
  begin
     Gettrd(Edit1.Text);
     statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount-1);
     statusbar1.Panels[3].Text:='0';
     for i := 1 to stringgrid1.RowCount - 1 do
     stringgrid1.Cells[2,i] := '';
  end;

end;

procedure TForm3.ComboBox1Change(Sender: TObject);
begin
  edit1change(sender);
  edit1.SetFocus;
end;

procedure tform3.gettrd(s : string);
var i,j : dword;d1,d2,d3,d4 : boolean;
begin j := 1; stringgrid1.RowCount:=stringgrid4.RowCount+1;
    d1 := true; d2:=d1;d3:=d1;d4:=d1;
    case combobox1.ItemIndex  of
         0 : d1 := false;
         1 : d2 := false;
         2 : d3 := false;
         3 : d4 := false;
    end;
    for i := 0 to stringgrid4.RowCount - 1 do
    if s <> '' then
    begin
       if chkdf(edit1.TEXT,stringgrid4.Cells[0,i],d1,d2,d3,d4) then
       begin
         stringgrid1.Cells[0,j] := stringgrid4.Cells[0,i];
         stringgrid1.Cells[1,j] := stringgrid4.Cells[1,i];
         inc(j);
       end;
    end
    else
       begin
         stringgrid1.Cells[0,j] := stringgrid4.Cells[0,i];
         stringgrid1.Cells[1,j] := stringgrid4.Cells[1,i];
         inc(j);
       end;
         stringgrid1.RowCount:=j;
end;
function tform3.chkdf(s,s1 : string; d1,d2,d3,d4 : boolean) : boolean;
var s2 : string; d5 : boolean;
begin            d5 := true;
    if d1 = false then
    if pos(s,s1) = 1 then d1 := true;

    if d2 = false then
    if pos(s + '|',s1+'|') > 0 then d2 := true;

    if d3 = false then
    if pos(s,s1) > 0 then d3 := true;

    if d4 =false then
    while s <> '' do
    begin
       if pos(' ',s) > 0 then
       begin
         s2 := copy(s,1,pos(' ',s)-1); delete(s,1,pos(' ',s));
       end
       else begin s2 := s; s := '';end;
       if pos(s2,s1) = 0 then
       begin
         d5 := false;
         break;
       end;
    end;
    if d5 then d4 := true;
    if d1 and d2 and d3 and d4 then chkdf := true
    else chkdf := false;
end;
procedure tform3.getM;
var i,j : dword;
begin j := 0;
  for i := 1 to stringgrid1.RowCount - 1 do
  if stringgrid1.Cells[2,i] <> '' then inc(j);
  statusbar1.Panels[3].Text:=inttostr(j);
end;

procedure TForm3.SpeedButton2Click(Sender: TObject);
var A : array of string; s : string;
    i,j,k,l,z : dword;
begin k := 0;  l := 65536;z:=0;
  if stringgrid2.RowCount > 1 then
  begin
  Setlength(A,0);
  k := 0;
  s := '';
  for i := 1 to stringgrid2.RowCount - 1 do
  if pos('#'+stringgrid2.Cells[0,i]+'#',s) = 0 then
  begin
    s := s + '#'+stringgrid2.Cells[0,i]+'#';
    inc(k);setlength(a,k);a[k-1] := stringgrid2.Cells[0,i];
  end;
  Setlength(ddl,l);
  for k := 0 to length(a) - 1 do
  begin
    s := '#'+a[k]+'#';
    for i := 0 to stringgrid3.RowCount - 1 do
    if  pos(s,stringgrid3.Cells[1,i]) > 0 then
    if stringgrid3.Cells[2,i] <> '' then
    begin
       j := strtoint(stringgrid3.Cells[2,i]);
       form1.filldlist(j);
       dlist[1].wd:=stringgrid3.Cells[0,i];
       dlist[1].ID:=j;
       ddl[z] := dlist;
       inc(z);
       if z = l then
       begin
         l  := l + 65536;
         setlength(ddl,l);
       end;
    end;
  end;
   setlength(ddl,z);
   if z > 0 then
   begin
      form1.SpeedButton27Click(sender);
      resform.edit1.Text:='';
      s := '';
      for i := 0 to length(a) - 1 do
      s := s + a[i]+'; ';
      resform.Edit1.Text:='The Words having folow definitions:<br>'+s;
   end
   else form1.infx('Definition Dictionary','No Results found for these definitions');
  end
  else form1.infx('Definitions Dictionary','No data for the request');

end;

procedure TForm3.SpeedButton2MouseEnter(Sender: TObject);
begin
//  speedbutton2.Transparent:=false;;
end;

procedure TForm3.SpeedButton2MouseLeave(Sender: TObject);
begin
//  speedbutton2.Transparent:=true;
end;

procedure TForm3.SpeedButton4Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount - 1 do
  if stringgrid1.Cells[2,i] <> '' then
  begin
    stringgrid2.RowCount:=stringgrid2.RowCount + 1;
    stringgrid2.Rows[stringgrid2.RowCount - 1] :=
    stringgrid1.Rows[i];
  end;
  statusbar1.Panels[5].Text:=inttostr(stringgrid2.RowCount -1);
end;

procedure TForm3.SpeedButton4MouseEnter(Sender: TObject);
begin
//  speedbutton4.Transparent:=false;;
end;

procedure TForm3.SpeedButton4MouseLeave(Sender: TObject);
begin
//  speedbutton4.Transparent:=true;
end;

procedure TForm3.SpeedButton5Click(Sender: TObject);
begin
  stringgrid2.RowCount:=1;
  Statusbar1.Panels[5].Text:='0';
end;

procedure TForm3.SpeedButton5MouseEnter(Sender: TObject);
begin
//  speedbutton5.Transparent:=false;;
end;

procedure TForm3.SpeedButton5MouseLeave(Sender: TObject);
begin
//  speedbutton5.Transparent:=true;
end;

procedure TForm3.StringGrid1Click(Sender: TObject);
begin
  if stringgrid1.Col=2 then
  if stringgrid1.Row > 0 then
  begin
    if stringgrid1.Cells[2,stringgrid1.Row] = '' then
       stringgrid1.Cells[2,stringgrid1.Row] := form1.SpeedButton21.Caption else
       stringgrid1.Cells[2,stringgrid1.Row] := '';;
       getM;
  end;
end;

procedure TForm3.StringGrid1DblClick(Sender: TObject);
begin
  SpeedButton1Click(Sender);
end;

end.


