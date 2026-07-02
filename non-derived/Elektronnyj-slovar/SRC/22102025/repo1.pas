unit Repo1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  ComCtrls, StdCtrls, ExtCtrls, HtmlView,shellapi;

type

  { TTz }

  TTz = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button9: TButton;
    hw1: THtmlViewer;
    Label1: TLabel;
    Memo1: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem100: TMenuItem;
    MenuItem101: TMenuItem;
    MenuItem102: TMenuItem;
    MenuItem103: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    PopupMenu3: TPopupMenu;
    Separator6: TMenuItem;
    Panel14: TPanel;
    Panel15: TPanel;
    Separator5: TMenuItem;
    Separator4: TMenuItem;
    MenuItem6: TMenuItem;
    Panel11: TPanel;
    Panel13: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    PopupMenu2: TPopupMenu;
    Separator3: TMenuItem;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem100Click(Sender: TObject);
    procedure MenuItem101Click(Sender: TObject);
    procedure MenuItem102Click(Sender: TObject);
    procedure MenuItem103Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid2Click(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
  private

  public
   procedure stat1;
   procedure stat2;
  end;

var
  Tz: TTz;
  repolim : dword = 65536;
implementation
uses depo1, poisk,tx1,clipbrd;
{$R *.lfm}
var Mz : boolean = true;
{ TTz }

procedure TTz.FormCreate(Sender: TObject);
begin
  if fileexists('sys\repository.sdm') then
  stringgrid1.loadfromCSVFile('sys\repository.sdm',#9,true);
  if fileexists('sys\repository2.sdm') then
  stringgrid2.loadfromCSVFile('sys\repository2.sdm',#9,true);
  stringgrid1.SelectedColor:=form1.StringGrid1.SelectedColor;
  stringgrid2.SelectedColor:=form1.StringGrid1.SelectedColor;
  savedialog1.InitialDir:='Reports';
  stringgrid2.Columns[5].Title.Caption:='Comments';
end;

procedure TTz.MenuItem100Click(Sender: TObject);
begin
  hw1.CopyToClipboard;
end;

procedure TTz.MenuItem101Click(Sender: TObject);
begin
  hw1.SelectAll;
end;

procedure TTz.MenuItem102Click(Sender: TObject);
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

procedure TTz.MenuItem103Click(Sender: TObject);
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

procedure TTz.MenuItem10Click(Sender: TObject);
var s : string;i : dword;
begin
    if stringgrid1.RowCount > 1 then
    begin
       s := stringgrid1.Cells[2,stringgrid1.Row];
       for i := 1 to stringgrid1.RowCount-1 do
       if stringgrid1.Cells[2,i] = s then stringgrid1.Cells[5,i] :=
       form1.SpeedButton21.Caption;
       stat1;
    end;
end;

procedure TTz.MenuItem12Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount-1 do
  if stringgrid1.Cells[4,i]='S' then stringgrid1.Cells[5,i] := form1.SpeedButton21.Caption
  else stringgrid1.Cells[5,i] := '';
  stat1;
end;

procedure TTz.MenuItem13Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount-1 do
  if stringgrid1.Cells[4,i]='E' then stringgrid1.Cells[5,i] := form1.SpeedButton21.Caption
  else stringgrid1.Cells[5,i] := '';
  stat1;

end;

procedure TTz.MenuItem14Click(Sender: TObject);
var i : dword;
begin
    if stringgrid2.RowCount > 1 then
    for i := 1 to stringgrid2.RowCount - 1 do
    if stringgrid2.Cells[6,i] <> '' then stringgrid2.Cells[6,i] := ''
    else stringgrid2.Cells[6,i] := form1.SpeedButton21.Caption;
    stat2;
end;

procedure TTz.MenuItem15Click(Sender: TObject);
var i : dword; s : string;
begin
 if stringgrid2.Row > 0 then
 begin
    s := stringgrid2.Cells[0,stringgrid2.Row];
    for i := 1 to stringgrid2.RowCount - 1 do
    if stringgrid2.Cells[0,i] = s then
    stringgrid2.Cells[6,i] := form1.SpeedButton21.Caption;
    stat2;
 end;
end;

procedure TTz.MenuItem16Click(Sender: TObject);
var i : dword; s : string;
begin
 if stringgrid2.Row > 0 then
 begin
    s := stringgrid2.Cells[1,stringgrid2.Row];
    for i := 1 to stringgrid2.RowCount - 1 do
    if stringgrid2.Cells[1,i] = s then
    stringgrid2.Cells[6,i] := form1.SpeedButton21.Caption;
    stat2;
 end;

end;

procedure TTz.MenuItem17Click(Sender: TObject);
var i : dword;
begin
   if stringgrid2.RowCount > 1 then
   for i := 1 to stringgrid2.RowCount - 1 do
   stringgrid2.Cells[6,i] := '';
   stat2;
end;

procedure TTz.MenuItem18Click(Sender: TObject);
var i : dword;
begin
    if stringgrid2.RowCount > 1 then
    for i := 1 to stringgrid2.RowCount - 1 do
    while ((i < stringgrid2.RowCount) and (stringgrid2.Cells[6,i] <> '')) do
    stringgrid2.DeleteRow(i);
    stat2;
end;

procedure TTz.MenuItem19Click(Sender: TObject);
begin
  if application.MessageBox('Are you sure you want to delete all?','Repository Clearing',52) = 6
  then stringgrid2.RowCount:=1;
  stat2;
end;


procedure TTz.FormActivate(Sender: TObject);
begin
   stat1; stat2;
end;

procedure TTz.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  stringgrid1.SaveToCSVFile(cdir+'\sys\repository.sdm',#9,true);
  stringgrid2.SaveToCSVFile(cdir+'\sys\repository2.sdm',#9,true);
end;


procedure TTz.Button5Click(Sender: TObject);
begin
  if memo1.Text <> '' then
  if stringgrid1.Row > 0 then
  stringgrid1.Cells[3,stringgrid1.Row] := memo1.lines.CommaText;
end;

procedure TTz.Button6Click(Sender: TObject);
begin
  if stringgrid2.Row > 0 then
  begin
    stringgrid2.Cells[5,stringgrid2.Row] := memo3.Lines.CommaText;
    form1.infx('Repository','Your comment applied.');
  end;
end;



procedure TTz.MenuItem1Click(Sender: TObject);
begin
  opendialog1.FilterIndex:=1;
  if opendialog1.Execute then
  stringgrid1.LoadFromCSVFile(opendialog1.FileName,#9,false);
  stat1;
end;

procedure TTz.MenuItem20Click(Sender: TObject);
begin
  if savedialog1.Execute then
  begin
     stringgrid2.SaveToCSVFile(savedialog1.FileName,#9);
    if form1.CheckBox7.Checked then
       shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
  end;
end;

procedure TTz.MenuItem22Click(Sender: TObject);
var i : dword; f : text;
begin
  if statusbar2.Panels[3].Text <> '0' then
  begin
    if savedialog1.Execute then
    begin
      assignfile(f,savedialog1.filename);rewrite(f);
      for i := 0 to stringgrid2.columns.Count-2 do
      write(f,stringgrid2.Columns[i].Title.Caption,#9);
      writeln(f,'');
      for i := 1 to stringgrid2.RowCount - 1 do
      if stringgrid2.cells[6,i] <> '' then
        writeln(f,
        stringgrid2.Cells[0,i],#9,
        stringgrid2.Cells[1,i],#9,
        stringgrid2.Cells[2,i],#9,
        stringgrid2.Cells[3,i],#9,
        stringgrid2.Cells[4,i],#9,
        stringgrid2.Cells[5,i]);
      closefile(f);
      if form1.CheckBox7.Checked then
         shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
    end;
  end
  else form1.infx('Repository','No records selected.');
end;

procedure TTz.MenuItem2Click(Sender: TObject);
begin
  if savedialog1.Execute then stringgrid1.SaveToCSVFile(savedialog1.filename,#9,false);
end;

procedure TTz.MenuItem3Click(Sender: TObject);
begin
  if application.MessageBox('Are you sure you vant to clear repository?','Repository will be cleaned',52) = 6 then
  begin
   stringgrid1.RowCount:=1;
   hw1.Clear;
   stat1;
  end;
end;

procedure TTz.MenuItem4Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  begin
     for i := 1 to stringgrid1.RowCount-1 do
     while ((i < stringgrid1.RowCount) and (stringgrid1.Cells[5,i] <> '')) do
     stringgrid1.DeleteRow(i);
     stat1;
  end;
end;

procedure TTz.MenuItem5Click(Sender: TObject);
var i : dword; f : text;  s : string;
begin
  if stringgrid1.RowCount > 1 then
  if savedialog1.execute then
  begin
    assignfile(f,savedialog1.FileName);rewrite(f);
    for i := 0 to 4 do
    write(f,stringgrid1.Columns[i].Title.Caption,#9);
    writeln(f,'');
    for i := 1 to stringgrid1.RowCount - 1 do
    if stringgrid1.Cells[5,i] <> '' then
    begin
    writeln(f,stringgrid1.Cells[0,i],#9,
              stringgrid1.Cells[1,i],#9,
              stringgrid1.Cells[2,i],#9,
              stringgrid1.Cells[3,i],#9,
              stringgrid1.Cells[4,i],#9);


    end;
    closefile(f);
    if form1.CheckBox7.Checked then
       shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
  end;
end;


procedure TTz.MenuItem6Click(Sender: TObject);
var  a : dword;
begin
  if stringgrid2.RowCount > 1 then
  for a := 1 to stringgrid2.RowCount - 1 do
  stringgrid2.Cells[6,a] := form1.speedbutton21.Caption;
  stat2;
end;

procedure TTz.MenuItem7Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount-1 do
  stringgrid1.Cells[5,i] := form1.SpeedButton21.Caption;
  stat1;
end;

procedure TTz.MenuItem8Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount-1 do
  stringgrid1.Cells[5,i] := '';
  stat1;
end;

procedure TTz.MenuItem9Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount - 1 do
  if stringgrid1.Cells[5,i] = '' then stringgrid1.Cells[5,i] := form1.SpeedButton21.Caption
  else stringgrid1.Cells[5,i] := '';
  stat1;
end;

procedure TTz.PageControl1Change(Sender: TObject);
begin

end;

procedure TTz.StringGrid1Click(Sender: TObject);
var s : string;
begin
if stringgrid1.RowCount > 1 then
begin
if stringgrid1.Col <> 5 then
begin
  s := '';
  hw1.Clear;
  if stringgrid1.Row > 0 then
  if stringgrid1.Cells[1,stringgrid1.Row] <> '' then
  begin
     form1.FillDlist(strtoint(stringgrid1.Cells[1,stringgrid1.Row]));
     s := form1.printdl1;
     hw1.LoadFromString(s);

     memo1.Clear;
     if stringgrid1.Cells[3,stringgrid1.Row] <> '' then
     begin
       s := stringgrid1.Cells[3,stringgrid1.Row];
       MZ := false;
       memo1.Lines.CommaText:=s;
     end;
  end;
end
else
begin
  if stringgrid1.Cells[5,stringgrid1.Row] = '' then
     stringgrid1.Cells[5,stringgrid1.Row] := form1.speedbutton21.caption
     else stringgrid1.Cells[5,stringgrid1.Row] := '';
  end;
end;
end;

procedure TTz.StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
begin
   if stringgrid1.RowCount > 1 then
   statusbar1.Panels[3].Text:=inttostr(stringgrid1.selection.Bottom - stringgrid1.Selection.Top+1)
   else
     statusbar1.Panels[3].Text:='0';
end;

procedure TTz.StringGrid2Click(Sender: TObject);
var s : string;
begin
  if stringgrid2.Row > 0 then
  begin
     if stringgrid2.Col = 6 then
     begin
       if stringgrid2.Cells[6,stringgrid2.Row] = '' then
       stringgrid2.Cells[6,stringgrid2.Row]:= form1.SpeedButton21.Caption else
       stringgrid2.Cells[6,stringgrid2.Row] := '';
       stat2;
     end
     else
     begin
        memo3.Clear;
        memo3.Lines.CommaText:=stringgrid2.Cells[5,stringgrid2.Row];
        s := stringgrid2.Cells[0,stringgrid2.Row] + #9 +
             stringgrid2.Cells[1,stringgrid2.Row] + ' ' +
             stringgrid2.Cells[2,stringgrid2.Row] + '. ' +
             stringgrid2.Cells[3,stringgrid2.Row] + ':'+#13+#10 +
             stringgrid2.Cells[4,stringgrid2.Row] + #13+#10;
             memo4.Text:= s;
     end;
   end;
end;

procedure TTz.StringGrid2DblClick(Sender: TObject);
var i,j,k : longint;
    s,s1,s2 : string;
begin
if stringgrid2.RowCount > 1 then
begin
    s := stringgrid2.Cells[1,stringgrid2.Row];
    s1 := stringgrid2.Cells[2,stringgrid2.Row];
    s2 := stringgrid2.Cells[3,stringgrid2.Row];

    for i := 1 to dcs1.ComboBox1.Items.Count - 1 do
    if dcs1.ComboBox1.Items[i] = s then
    begin
      dcs1.ComboBox1.ItemIndex:=i;
      dcs1.ComboBox1Change(sender);

      for j := 0 to dcs1.ComboBox2.Items.Count - 1 do
      if j < dcs1.ComboBox2.Items.Count then
      if pos(s1,dcs1.ComboBox2.Items[j]) = 1 then
      begin

         dcs1.ComboBox2.ItemIndex:=j;
         dcs1.ComboBox2Change(sender);
         for k := 0 to dcs1.listbox1.Items.Count - 1 do
         if s2 = dcs1.ListBox1.Items[k] then
         begin
//           GVerse := strtoint(listbox2.Items[stringgrid1.Row - 1]);
           dcs1.ListBox1.ItemIndex:=k;
           dcs1.ListBox1Click(sender);
//           dcs1.Button1Click(Sender);
//           showmessage('4');
           break;
         end;
         break;

      end;
      break;
    end;

    dcs1.Show;
end;

end;

procedure ttz.stat1;
var i,j : dword;
begin  j := 0;
  statusbar1.Panels[1].Text:= inttostr(stringgrid1.RowCount - 1);
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount - 1 do
  if stringgrid1.cells[5,i] <> '' then inc(j);
  statusbar1.Panels[3].Text:=inttostr(j);
end;

procedure ttz.stat2;
var i,j : dword;
begin j := 0;
  statusbar2.Panels[1].Text:=inttostr(stringgrid2.RowCount - 1);
  if stringgrid2.RowCount > 1 then
  for i := 1 to stringgrid2.RowCount - 1 do
  if stringgrid2.Cells[6,i] <> '' then inc(j);
  statusbar2.Panels[3].Text:=inttostr(j);
end;

end.

