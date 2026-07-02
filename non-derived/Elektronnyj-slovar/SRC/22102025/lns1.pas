unit lns1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls, Menus, ComCtrls, HtmlView;

type

  { TLns }

  TLns = class(TForm)
    Button1: TButton;
    Button4: TButton;
    hw1: THtmlViewer;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Memo2: TMemo;
    Memo3: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem100: TMenuItem;
    MenuItem101: TMenuItem;
    MenuItem102: TMenuItem;
    MenuItem103: TMenuItem;
    PopupMenu2: TPopupMenu;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure MenuItem100Click(Sender: TObject);
    procedure MenuItem101Click(Sender: TObject);
    procedure MenuItem102Click(Sender: TObject);
    procedure MenuItem103Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private

  public

  end;

var
  Lns: TLns;

implementation
uses tcf,tx1,sfo,poisk,gram,shellapi,repo1,clipbrd;
{$R *.lfm}

{ TLns }

procedure TLns.StringGrid1Click(Sender: TObject);
var i : longint;
    s,k : string;
begin
  if stringgrid1.RowCount = 1 then
  begin
    label1.Caption:='WordList';
    listbox1.Clear;
    hw1.Clear;
    memo2.Clear;
  end;

  if (stringgrid1.RowCount > 1) then
  begin
     if stringgrid1.Col= 5 then
     begin
       if stringgrid1.Cells[5,stringgrid1.Row] = '' then
          stringgrid1.Cells[5,stringgrid1.Row] := form1.SpeedButton21.Caption
          else stringgrid1.Cells[5,stringgrid1.Row] := '';
       formActivate(sender);
     end
  else
  begin
     k:='<b>'+stringgrid1.Cells[0,stringgrid1.Row]+' ' +
              stringgrid1.Cells[1,stringgrid1.Row] + '. ' +
              stringgrid1.Cells[2,stringgrid1.Row]+'</b><br> '+
              stringgrid1.Cells[4,stringgrid1.Row]+'<br>';
     if stringgrid1.Cells[3,stringgrid1.Row] <> '' then
     begin
       listbox1.Clear;
       s := stringgrid1.Cells[3,stringgrid1.Row];
       if s <> '' then delete(s,1,1);
       while s <> '' do
       begin
          listbox1.Items.Add(dcs1.getosn(copy(s,1,pos(',',s)-1)));
          delete(s,1,pos(',',s));
       end;
       label1.Caption:='WordList: '+inttostr(listbox1.Count)+' Stems';
       if listbox1.Items.Count > 0 then
       listbox1.ItemIndex:=0;
     end;
     s := '';
     for i := 0 to listbox1.Items.Count - 1 do
     if pos (' '+listbox1.Items[i]+' ',s) = 0 then s := s +
     ' ' + listbox1.Items[i]+' ';
     k := k + '<b>'+
     'WordList:</b><br>' + s;
     hw1.LoadFromString(k);
   end;
  end;
end;

procedure TLns.StringGrid1DblClick(Sender: TObject);
begin
  button4click(sender);
end;

procedure TLns.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if tts.Visible then
  tts.FormStyle := fsstayontop;
  form1.BitBtn3.Hide;
  form1.p18;
end;

procedure TLns.FormCreate(Sender: TObject);
begin
  stringgrid1.SelectedColor:=form1.StringGrid1.SelectedColor;;
end;

procedure TLns.FormShow(Sender: TObject);
begin
   form1.BitBtn3.Show;
   form1.BitBtn3.Caption:=caption;
   hw1.Font := form1.Memo1.Font;
   hw1.DefFontName := form1.Memo1.Font.Name;
end;

procedure TLns.FormWindowStateChange(Sender: TObject);
begin
  if windowstate= wsminimized then
  begin
    if tts.Visible then
    tts.FormStyle := fsstayontop;

     form1.BitBtn3.Show;
     form1.BitBtn3.Caption:=caption;
  end;
end;

procedure TLns.Button1Click(Sender: TObject);
var zz,xx : string;
    c : word;
begin
  xx := '';
  for c := 0 to memo2.lines.Count - 1 do
      xx := xx + memo2.Lines.Strings[c] + '<p>';
  zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
        '<font face="Mangal" size = "2">' +
        '<center><b>Text Feagment Search Results:  </b></center><left>';
zz := zz + xx + '<b><p><center>Texts:</center></b><p>';
zz := zz +'<table width = "100%" rules = "ALL" border = "2">';
for c := 0 to stringgrid1.rowcount - 1 do
begin
   xx := '<td width = "15%">'+stringgrid1.Cells[0,c]+'</td>' +
         '<td width = "15%">'+stringgrid1.Cells[1,c]+'</td>' +
         '<td width = "5%">'+stringgrid1.Cells[2,c]+'</td>' +
         '<td width = "65%">'+stringgrid1.Cells[4,c]+'</td><tr>';
   zz := zz + xx;
end;
   zz := zz + '</table></body></html>';

   memo3.Text:= zz;
   if nn.savedialog1.Execute then
   begin
      memo3.Lines.SaveToFile(nn.savedialog1.FileName);
      if form1.CheckBox7.Checked then
      shellexecute(0,'Open',pchar(nn.savedialog1.FileName),'',nil,1);
   end;
end;

procedure TLns.Button4Click(Sender: TObject);
var i,j,k : longint;
    s,s1,s2 : string;
begin
if stringgrid1.RowCount > 1 then
begin
    s := '"'+stringgrid1.Cells[0,stringgrid1.Row]+'"';
    s1 := stringgrid1.Cells[1,stringgrid1.Row];
    s2 := stringgrid1.Cells[2,stringgrid1.Row];
    for i := 0 to dcs1.ComboBox1.Items.Count - 1 do
    if dcs1.ComboBox1.Items[i] = s then
    begin
      dcs1.ComboBox1.ItemIndex:=i;
      dcs1.ComboBox1Change(sender);
      if dcs1.ComboBox2.Items.Count > 0 then
      for j := 0 to dcs1.ComboBox2.Items.Count - 1 do
      if dcs1.ComboBox2.Items[j] = s1 then
      begin
         dcs1.ComboBox2.ItemIndex:=j;
         dcs1.ComboBox2Change(sender);
         for k := 0 to dcs1.listbox1.Items.Count - 1 do
         if (s2 = copy(dcs1.ListBox1.Items[k],1,pos(' ',dcs1.ListBox1.Items[k]) - 1)) or
            (s2 = dcs1.ListBox1.Items[k]) then
         begin
           dcs1.ListBox1.ItemIndex:=k;
           dcs1.ListBox1Click(sender);
           break;
         end;
         break;
      end;
      break;
    end;
    if dcs1.WindowState=wsminimized then dcs1.WindowState:=wsnormal;;
    dcs1.Show;
    dcs1.BringToFront;
    dcs1.radiogroup1.ItemIndex:=1;
    dcs1.RadioGroup1Click(sender);

end;
end;

procedure TLns.FormActivate(Sender: TObject);
var i,j,k : dword;s,s1 : string;
begin j := 0; k := 0;
      statusbar1.Panels[3].Text:='0';
      statusbar1.Panels[5].Text:='0';
      statusbar1.Panels[1].Text:='0';
    if stringgrid1.RowCount > 1 then
    begin
      s1 := '';
      for i := 1 to stringgrid1.RowCount - 1 do
      begin
         s := '#'+stringgrid1.Cells[0,i]+'#';
         if pos(s,s1) = 0 then begin s1:= s1+s;inc(j);end;
         if stringgrid1.Cells[5,i] <> '' then inc(k);
      end;
      statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount - 1);
      statusbar1.Panels[3].Text:=inttostr(j);
      statusbar1.Panels[5].Text:=inttostr(k);
        if stringgrid1.RowCount = 1 then
        begin
          label1.Caption:='WordList';
          listbox1.Clear;
          hw1.Clear;memo2.Clear;
        end;
    end;
end;

procedure TLns.ListBox1Click(Sender: TObject);
var s : string;
begin
  if listbox1.ItemIndex > -1 then
  if listbox1.Items[listbox1.ItemIndex] <> '' then
  begin
    sf.findinfo(listbox1.Items[listbox1.ItemIndex],
    d[form1.GetletId(listbox1.Items[listbox1.ItemIndex])].beg,
    d[form1.GetletId(listbox1.Items[listbox1.ItemIndex])].ed,true,s);
    hw1.LoadFromString(s);
  end;

end;

procedure TLns.MenuItem100Click(Sender: TObject);
begin
  hw1.CopyToClipboard;
end;

procedure TLns.MenuItem101Click(Sender: TObject);
begin
  hw1.SelectAll;
end;

procedure TLns.MenuItem102Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw1.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.google.com/?sl=auto&tl=ru&text='+s+'&op=translate')
  ,nil,nil,1);


end;

procedure TLns.MenuItem103Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw1.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.yandex.ru/?source_lang=en&target_lang=ru&text='+s)
  ,nil,nil,1);




//https://translate.yandex.ru/?source_lang=en&target_lang=ru&text=hi

end;

procedure TLns.MenuItem10Click(Sender: TObject);
begin
  tz.Show;
  tz.PageControl1.ActivePageIndex:=1;
end;

procedure TLns.MenuItem1Click(Sender: TObject);
var i,j,k : dword;
begin j := 0;
    if statusbar1.Panels[5].Text <> '' then
    j := strtoint(statusbar1.Panels[5].Text);
    if j > 0 then
    if stringgrid1.RowCount > 1 then
    if tz.Stringgrid2.RowCount + j < repolim then
    begin
       k := tz.stringGrid2.RowCount;
       tz.Stringgrid2.RowCount := k + j;
       for i := 1 to stringgrid1.RowCount - 1 do
       if stringgrid1.cells[5,i] <> '' then
       begin
          tz.stringgrid2.cells[0,k] := datetimetostr(date)+ ' ' + timetostr(time);
          tz.stringgrid2.cells[1,k] := stringgrid1.Cells[0,i];
          tz.stringgrid2.cells[2,k] := stringgrid1.Cells[1,i];
          tz.stringgrid2.cells[3,k] := stringgrid1.Cells[2,i];
          tz.stringgrid2.cells[4,k] := stringgrid1.Cells[4,i];
          tz.stringgrid2.cells[5,k] := '';
          tz.stringgrid2.cells[6,k] := '';
          inc(k);
       end;
       form1.infx('Repository','Total records added: '+ inttostr(j));
    end
    else
    form1.infx('Repository','Not enough free place in the repository');
end;

procedure TLns.MenuItem2Click(Sender: TObject);
var i,k : dword;
begin
    if tz.Stringgrid2.RowCount + 1 < repolim then
    begin
       k := tz.stringGrid2.RowCount;
       tz.Stringgrid2.RowCount := k + 1;
       i := stringgrid1.Row;
       if i > 0 then
       begin
          tz.stringgrid2.cells[0,k] := datetimetostr(date) + ' ' + timetostr(time);
          tz.stringgrid2.cells[1,k] := stringgrid1.Cells[0,i];
          tz.stringgrid2.cells[2,k] := stringgrid1.Cells[1,i];
          tz.stringgrid2.cells[3,k] := stringgrid1.Cells[2,i];
          tz.stringgrid2.cells[4,k] := stringgrid1.Cells[4,i];
          tz.stringgrid2.cells[5,k] := '';
          tz.stringgrid2.cells[6,k] := '';
       end;
       form1.infx('Repository','Total records added: 1');
    end
    else
    form1.infx('Repository','Not enough free place in the repository');

end;

procedure TLns.MenuItem3Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount - 1 do
  stringgrid1.Cells[5,i] := form1.SpeedButton21.Caption;
  formactivate(sender);
end;

procedure TLns.MenuItem4Click(Sender: TObject);
var i : dword; s : string;
begin
  if stringgrid1.RowCount > 1 then
  begin
    s := stringgrid1.Cells[0,stringgrid1.Row];
    for i := 1 to stringgrid1.RowCount - 1 do
    if s = stringgrid1.cells[0,i] then stringgrid1.Cells[5,i] := form1.SpeedButton21.Caption;
  end;
  formactivate(sender);
end;

procedure TLns.MenuItem5Click(Sender: TObject);
var i : dword;
begin
   if stringgrid1.RowCount > 1 then
   for i := 1 to stringgrid1.RowCount - 1 do
   if stringgrid1.Cells[5,i] <> '' then stringgrid1.Cells[5,i] := ''
   else stringgrid1.Cells[5,i] := form1.SpeedButton21.Caption;
   formactivate(sender);
end;

procedure TLns.MenuItem6Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount - 1 do
  stringgrid1.Cells[5,i] := '';
  formactivate(sender);
end;

procedure TLns.MenuItem7Click(Sender: TObject);
var i,j : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount - 1 do
    if i <= stringgrid1.RowCount - 1 then
    while ((i <=stringgrid1.RowCount-1) and (stringgrid1.Cells[5,i] <> '')) do
    begin stringgrid1.DeleteRow(i);
       if i = stringgrid1.RowCount then break;
    end;
  formactivate(sender);
end;

procedure TLns.MenuItem8Click(Sender: TObject);
var i : dword; s : string;
begin
  if stringgrid1.RowCount > 1 then
  begin
    s := stringgrid1.Cells[0,stringgrid1.Row];
    for i := 1 to stringgrid1.RowCount - 1 do
    if s = stringgrid1.cells[0,i] then stringgrid1.Cells[5,i] := '';
  end;
  formactivate(sender);
end;

procedure TLns.MenuItem9Click(Sender: TObject);
begin
  if stringgrid1.Row > 0 then stringgrid1.DeleteRow(stringgrid1.Row);
  formactivate(sender);
end;


end.

