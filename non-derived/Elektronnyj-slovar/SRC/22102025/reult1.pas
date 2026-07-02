unit reult1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, Grids, ExtCtrls, ComCtrls, CheckLst, Menus, Buttons, HtmlView,
  shellapi, Types;

type

  { Tresform }

  Tresform = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox4: TCheckBox;
    Edit2: TEdit;
    hw: THtmlViewer;
    MenuItem104: TMenuItem;
    MenuItem105: TMenuItem;
    MenuItem107: TMenuItem;
    MenuItem108: TMenuItem;
    PopupMenu3: TPopupMenu;
    ProgressBar1: TProgressBar;
    SAD1: TCheckBox;
    MenuItem19: TCheckBox;
    M95: TCheckBox;
    CheckBox3: TCheckBox;
    CheckListBox1: TCheckListBox;
    CheckListBox2: TCheckListBox;
    Edit1: TEdit;
    EditButton1: TEditButton;
    Label1: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Memo2: TMemo;
    Memo4: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Mx1: TMenuItem;
    Separator4: TMenuItem;
    Separator3: TMenuItem;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure CheckListBox2Click(Sender: TObject);
    procedure CheckListBox2DblClick(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure EditButton1ButtonClick(Sender: TObject);
    procedure EditButton1Change(Sender: TObject);
    procedure EditButton2ButtonClick(Sender: TObject);
    procedure EditButton2Change(Sender: TObject);
    procedure EditButton2KeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Memo3Change(Sender: TObject);
    procedure MenuItem104Click(Sender: TObject);
    procedure MenuItem105Click(Sender: TObject);
    procedure MenuItem107Click(Sender: TObject);
    procedure MenuItem108Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);

    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure Mx1Click(Sender: TObject);
    procedure ProgressBar1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure SAD1Change(Sender: TObject);
    procedure SAD1Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton34Click(Sender: TObject);
    procedure SpeedButton35Click(Sender: TObject);
    procedure SpeedButton36Click(Sender: TObject);
    procedure SpeedButton37Click(Sender: TObject);
    procedure SpeedButton38Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
  private

  public
   procedure simpleview;
  end;
TA = record
       c2 : boolean;
       c1 : set of byte;
       end;

var
  resform: Tresform;
  canc : boolean = false;
  CAr : array of TA;
  monier, apte1, botlink, mani : boolean;

implementation
uses depo1, poisk,repo1,tema1,lazutf8,wrf,clipbrd;
type
sss = record
       p1 : array of dword;
       p2 : dword;
    end;
var
  sps : sss;
{$R *.lfm}

{ Tresform }

procedure Tresform.Button2Click(Sender: TObject);
begin
    if edit2.Text <> '' then
    begin
       if hw.FindEx(edit2.Text,checkbox4.Checked,true) = false then
       edit2.Color:=$8F8FFF else edit2.Color:=clwhite;
    end
    else
    begin
       edit2.Color:= clwhite;
    end;
end;

procedure Tresform.Button3Click(Sender: TObject);
begin
  Editbutton2change(sender)
end;

procedure Tresform.CheckBox1Change(Sender: TObject);
begin
  if checkbox1.Checked then button1click(sender);
end;

procedure Tresform.CheckBox2Change(Sender: TObject);
begin


  {  if checkbox2.Checked then
  begin
    memo3.Hide;
    groupbox1.Hide;
    panel1.show;
    button1.Show;
  end
  else
  begin
//    panel1.hide;
    button1.Hide;
    memo3.show;
    groupbox1.show;

  end;

}
end;

procedure Tresform.CheckBox3Change(Sender: TObject);
begin
  edit2change(sender);
end;

procedure Tresform.CheckBox4Change(Sender: TObject);
begin

end;

procedure Tresform.CheckListBox1Click(Sender: TObject);
var a : longint;
    s : string;
begin
  if checklistbox1.ItemIndex > - 1 then
  begin
    hw.DefFontName:=form1.Memo1.Font.Name;
    hw.DefFontSize:=form1.Memo1.Font.Size;
    dlist := ddl[checklistbox2.ItemIndex];
    for a := 1 to length(dlist) do dlist[a].en:=false;

    dlist[dar[checklistbox1.ItemIndex + 1]].en:=true;

    s := form1.printdl1;
    hw.LoadFromString(s);

  end;
end;

procedure Tresform.CheckListBox1ClickCheck(Sender: TObject);
begin

    if checklistbox1.Checked[checklistbox1.ItemIndex] then
    car[checklistbox2.ItemIndex].c1:=car[checklistbox2.ItemIndex].c1 + [checklistbox1.ItemIndex]
    else
    car[checklistbox2.ItemIndex].c1:=car[checklistbox2.ItemIndex].c1 - [checklistbox1.ItemIndex];
    if checkbox1.Checked then button1click(sender);

end;

procedure Tresform.CheckListBox2Click(Sender: TObject);
var i : longint;
    k  : longint;
    s : string;
begin
    checklistbox1.Clear;
    hw.Clear;
    if checklistbox2.Items.Count > 0 then
    if length(ddl) = checklistbox2.Items.Count then
    begin
    k := checklistbox2.ItemIndex;
    if k > - 1 then
    for i := 1 to length(dlist) - 1 do
    begin
        if ddl[k,dar[i]].df > 0 then
       checklistbox1.Items.Add('●'+ddl[k,dar[i]].SN)
       else checklistbox1.Items.Add(ddl[k,dar[i]].SN);
       if checklistbox1.Count - 1 in car[k].c1 then
       checklistbox1.Checked[checklistbox1.Count - 1] := true;
    end;
      if sad1.Checked then
      begin
        s := '';
        for i := 0 to checklistbox1.Items.Count - 1 do
        if ddl[k,dar[i]].df > 0 then
        s := s + '<b>'+ddl[k,dar[i]].DName+'</b><br>'+
        form1.convertres(ddl[k,dar[i]].DDesc) + '<p>';
        hw.DefFontName:=form1.Memo1.Font.Name;
        hw.DefFontSize:=form1.Memo1.Font.Size;
        hw.LoadFromString(s);
      end;
      end;

end;

procedure Tresform.CheckListBox2DblClick(Sender: TObject);
begin
  mx1click(sender);
  form1.BringToFront;
{
  if checklistbox2.Items.Count > 0 then
  begin
  form1.GetExam(depo.StringGrid1.Cells[3,ddl[checklistbox2.ItemIndex,1].ID],0,0,0,0,0);
//  showmessage(depo.StringGrid1.Cells[3,ddl[checklistbox2.ItemIndex,1].ID])
  wr.Show;
  wr.Caption:= checklistbox2.Items[checklistbox2.ItemIndex];
  end;
}
end;

procedure Tresform.Edit2Change(Sender: TObject);
begin
  Editbutton2change(sender)
end;

procedure Tresform.EditButton1ButtonClick(Sender: TObject);
var a : longint;
begin
  if checklistbox1.Items.Count > 0 then
  begin
    editbutton1.TextHint:=form1.convertx(Editbutton1.TextHint);
    for a := 0 to checklistbox1.Items.Count - 1 do
    if pos(editbutton1.Text, checklistbox1.Items[a]) = 1 then
    begin
       checklistbox1.ItemIndex:=a;
       break;
    end;
    editbutton1.SetFocus;
  end;
end;

procedure Tresform.EditButton1Change(Sender: TObject);
var a : longint;
    z : longint;
begin
  if checklistbox2.Items.Count > 0 then
begin
  z := editbutton1.selstart;
  a := length(editbutton1.Text);
  editbutton1.Text:=form1.convertx(Editbutton1.Text);
  if length(editbutton1.Text) = a then editbutton1.SelStart:=z
  else
  editbutton1.SelStart:= z - (length(editbutton1.text) - a);
  for a := 0 to checklistbox2.Items.Count - 1 do
  if pos(editbutton1.Text, checklistbox2.Items[a]) = 1 then
  begin
     checklistbox2.ItemIndex:=a;
     break;
  end;
  editbutton1.SetFocus;
end;
end;

procedure Tresform.EditButton2ButtonClick(Sender: TObject);
begin
     EditButton2Change(Sender);
end;

procedure Tresform.EditButton2Change(Sender: TObject);
begin
  if checkbox3.Checked then
  begin
    edit2.Text:=form1.convertx(edit2.Text);
    edit2.SelStart:=length(edit2.Text);
//    edit2.SetFocus;
  end;
if edit2.Text <> '' then
begin
   if hw.FindEx(edit2.text,checkbox4.Checked,false) = false then
   if hw.FindEx(edit2.Text,checkbox4.Checked,true) = false then
   edit2.Color:=$8F8FFF else edit2.Color:=clwhite;
end
else
begin
   edit2.Color:= clwhite;
end;

end;

procedure Tresform.EditButton2KeyPress(Sender: TObject; var Key: char);
begin
  if key in [#13,#10] then
  editbutton2buttonclick(sender);
end;



procedure Tresform.FormActivate(Sender: TObject);
begin

end;

procedure Tresform.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  form1.BitBtn1.Hide;
  form1.p18;
end;

procedure Tresform.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
{  if canc = false  then
  if memo2.Text <> '' then
  if application.MessageBox('Do you want to save the search results?','Closing the window',52) <> 7 then
  begin
    if savedialog1.Execute then
       resform.Memo2.Lines.SaveToFile(savedialog1.FileName)
    else canclose := false;
  end
  else
  hide;
  canc := false;
}
end;

procedure Tresform.FormCreate(Sender: TObject);
begin
  savedialog1.InitialDir:=cdir+'\Reports';
{  if checklistbox1.Items.Count > 0 then
  begin
    if checklistbox1.ItemIndex < 0 then checklistbox1.ItemIndex:=0;
    checklistbox1click(sender);
  end;
  updown1.Position:=memo3.Font.Size;
}
end;

procedure Tresform.FormShow(Sender: TObject);
begin
   form1.BitBtn1.Caption:=caption;
   form1.bitbtn1.Show;
end;

procedure Tresform.FormWindowStateChange(Sender: TObject);
var i,j : shortint;
begin
  if windowState = wsminimized then
  begin
    form1.BitBtn1.Caption:=caption;
    form1.bitbtn1.Show;
    form1.p18;
  end;
end;

procedure Tresform.Label2Click(Sender: TObject);
begin
  sps.p2:=1;
  editbutton2buttonclick(sender);
end;

procedure Tresform.Memo3Change(Sender: TObject);
begin

end;

procedure Tresform.MenuItem104Click(Sender: TObject);
begin
  hw.SelectAll;
end;

procedure Tresform.MenuItem105Click(Sender: TObject);
begin
  hw.CopyToClipboard;
end;

procedure Tresform.MenuItem107Click(Sender: TObject);
     var s,s2 : string;
         i : dword;
     begin  s2 := '';
       hw.CopyToClipboard;
       s := clipboard.AsText;
       for i := 1 to length(s) do
       s2 := s2 + '%'+inttostr(ord(s[i])-12);
       shellexecute(0,'open',
       pchar('https://translate.google.com/?sl=auto&tl=ru&text='+s+'&op=translate')
       ,nil,nil,1);
end;

procedure Tresform.MenuItem108Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.yandex.ru/?source_lang=en&target_lang=ru&text='+s)
  ,nil,nil,1);




end;

procedure Tresform.MenuItem10Click(Sender: TObject);
var i : longint;
begin
  if checklistbox2.Items.Count > 0 then
  for i := 0 to checklistbox2.Items.Count - 1 do
  checklistbox2.Checked[i] := false;
end;

procedure Tresform.MenuItem11Click(Sender: TObject);
var i : longint;
begin
  if checklistbox2.Items.Count > 0 then
  for i := 0 to checklistbox2.Items.Count - 1 do
  checklistbox2.Checked[i] := not(checklistbox2.Checked[i]);
end;

procedure Tresform.MenuItem15Click(Sender: TObject);
var s : string;
    i : longint;
    j : longint;
begin
    checklistbox2.Hide;
    checklistbox1.Hide;
    if checklistbox2.Count > 0 then
    for i := 0 to checklistbox2.Count - 1 do
    begin
        s := s + #13+#10+checklistbox2.Items[i]+#13+#10;
        checklistbox2.ItemIndex:=i;
        if checklistbox2.Checked[i] then
        begin
          checklistbox2click(sender);

          if (car[i].c1 <> []) and (checklistbox1.Count > 0) then
             for j := 0 to checklistbox1.Count - 1 do
             if checklistbox1.Checked[j] then
             begin
               checklistbox1.ItemIndex:=j;
               checklistbox1click(sender);
//               if memo3.Text <> '' then
//               s := s  + memo3.Text + #13+#10;
//               if (memo3.Text <> '') and
//                  (m95.Checked) then break;

             end;
        end;
    end;
    if s  <> '' then
    if savedialog1.Execute then
    begin
      memo2.Text:=edit1.Text + #13+#10+ s;
      memo2.Lines.SaveToFile(savedialog1.FileName);
      if form1.CheckBox7.Checked then
      shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
    end;

    checklistbox2.show;
    checklistbox1.show;
end;

procedure Tresform.MenuItem17Click(Sender: TObject);
var i : longint;
begin
  memo2.Clear;
  if edit1.Text <> '' then
  memo2.lines.Add(edit1.Text);
  if checklistbox2.Items.Count > 0 then
  for i := 0 to checklistbox2.Count - 1 do
  if checklistbox2.Checked[i] then memo2.lines.Add(checklistbox2.Items[i]);
  if memo2.Text <> '' then
  if savedialog1.Execute then memo2.Lines.SaveToFile(savedialog1.FileName);

end;

procedure Tresform.MenuItem18Click(Sender: TObject);
var i : longint;
    s : string;
begin s := '';
  memo2.Clear;
  if checklistbox2.Items.Count > 0 then
  for i := 0 to checklistbox2.Count - 1 do
  if checklistbox2.Checked[i] then s := s + checklistbox2.Items[i] +#13+#10;
  if s <> '' then
  begin
     clipboard.AsText := s;
  end;

end;

procedure Tresform.MenuItem19Click(Sender: TObject);
begin
  menuitem19.Checked:=not(menuitem19.Checked);
end;


procedure Tresform.MenuItem1Click(Sender: TObject);
var a : longint;
begin
  if checklistbox1.Items.Count > 0 then
  for a := 0 to checklistbox1.Items.Count - 1 do
  begin
     checklistbox1.Checked[a] := true;
     car[checklistbox2.ItemIndex].c1:= car[checklistbox2.ItemIndex].c1 + [a];
  end;
  if checkbox1.Checked then button1click(sender);
end;

procedure Tresform.MenuItem2Click(Sender: TObject);
var a : longint;
begin
  if checklistbox1.Items.Count > 0 then
  begin
    for a := 0 to checklistbox1.items.count -1 do
    checklistbox1.Checked[a] := false;
    car[checklistbox2.ItemIndex].c1 := [];
  end;
  if checkbox1.Checked then button1click(sender);
end;

procedure Tresform.MenuItem3Click(Sender: TObject);
var a : longint;
begin
  if checklistbox1.Items.Count > 0 then
  for a := 0 to checklistbox1.items.count -1 do
  if  checklistbox1.Checked[a] then
  begin
    checklistbox1.Checked[a] := false;
    car[checklistbox2.ItemIndex].c1 := car[checklistbox2.ItemIndex].c1 - [a];
  end
  else
    begin
       checklistbox1.Checked[a] := true;
       car[checklistbox2.ItemIndex].c1 := car[checklistbox2.ItemIndex].c1 + [a];
    end;
  if checkbox1.Checked then button1click(sender);
end;

procedure Tresform.MenuItem4Click(Sender: TObject);
var a : dword;
    c : dword;
    x : dword;
begin c := 0;
    a := tz.stringGrid1.RowCount;
    for x := 0 to checklistbox2.Items.Count - 1 do
    if checklistbox2.Checked[x] then inc(c);
    if c + tz.StringGrid1.RowCount > repolim then
    showmessage(
    'Too many words adding to repository. You can add '+
    inttostr(repolim - tz.StringGrid1.RowCount)+
    ' words only.')
    else
    begin
    c := 0;
    tz.StringGrid1.RowCount:=tz.StringGrid1.RowCount + checklistbox2.Items.Count;
    if checklistbox2.Items.Count > 0 then
    for x := 0 to checklistbox2.Items.Count - 1 do
    if checklistbox2.Checked[x] then
    begin
       tz.StringGrid1.Cells[0,a+c] := checklistbox2.Items[x];
       tz.StringGrid1.Cells[1,a+c] := inttostr(ddl[x,1].ID);
       tz.StringGrid1.Cells[2,a+c] :=    datetimetostr(date);
       tz.StringGrid1.Cells[3,a+c] := '';
       tz.StringGrid1.Cells[4,a+c] := 'S';
       tz.StringGrid1.Cells[5,a+c] := '';
       inc(c);
    end;
    form1.infx('Repository','Added: '+inttostr(c) + ' words.');
   end;
end;

procedure Tresform.MenuItem5Click(Sender: TObject);
var zz : string;
    a : longint;
    q : longint;
    i,j : longint;
    s : string;
    s1: string;
    m4 : string;
    W  : string;
begin
  m4 := '';
  savedialog1.FilterIndex:=2;
  savedialog1.FileName:='result.htm';
  if savedialog1.Execute then
begin
panel4.Hide;
  checklistbox2.Hide;
  checklistbox1.Hide;
  progressbar1.Show;
  progressbar1.Max:=100;
  zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
        '<font face="Mangal" size = "2">' +
        '<center><b>'+
        edit1.Text+'</b></center><left>';
  if menuitem19.Checked then
  begin
    zz := zz + '<center><b><font size = "2">CONTENTS</center></font></b><left>';

    for i := 0 to checklistbox2.Items.Count - 1 do
    begin
      s1 :=  '<a name = "1'+checklistbox2.Items[i] + '"></A>' +
      '<a href = "#'+checklistbox2.Items[i] + '">' + form1.convertd(checklistbox2.Items[i]) + '</A>   ';
      zz := zz + s1;
    end;
    zz := zz + '<p>';
  end;

  zz := zz +  '<table width = "100%" rules = "ALL" border = "2">';
  memo4.Clear;
  if checklistbox2.Items.Count > 0 then
  for   i := 0 to checklistbox2.Count - 1 do
  if checklistbox2.Checked[i] then
  begin
    s := '';
    if menuitem19.Checked then
    begin
       s1 := '<TD Width = "20%" valign="top">' +
       '<A name="'+checklistbox2.Items[i] + '"></A>'+
       '<A href="#1'+checklistbox2.Items[i] + '">'+form1.convertd(checklistbox2.Items[i])  + ' - ' + checklistbox2.Items[i]+'</A></TD>';
    end
    else
    s1 := '<TD Width = "20%" valign="top">' + form1.convertd(checklistbox2.Items[i])  + ' - ' + checklistbox2.Items[i]+'</TD>';
    progressbar1.Position:=(i div checklistbox2.Count)*100;
    checklistbox2.ItemIndex:=i;
    checklistbox2click(sender);
    W := '';
    for j := 0 to checklistbox1.Items.Count - 1 do
    if (checklistbox1.Checked[j]) and
       (ddl[i,dar[j+1]].df > 0) then
    begin
      w := w + '<b>'+ddl[i,dar[j+1]].DName + '</b><br>'+
      form1.convertres(ddl[i,dar[j+1]].DDesc) + '<p>';
      if m95.Checked then break
    end;

    s := s1 + '<TD width = "80%">' + w + '</TD><TR>';
    m4 := m4 + s;
   end;



     memo4.Text:=zz + m4 + '</Table></body></html>';

     memo4.Lines.SaveToFile(savedialog1.FileName);
     if form1.CheckBox7.Checked then
     shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
     progressbar1.Hide;
     checklistbox2.Show;
     checklistbox1.Show;
     panel4.Show;


end
end;

procedure Tresform.MenuItem6Click(Sender: TObject);
var a,i : longint;
    s : string;
begin
  if checklistbox1.Items.Count > 0 then
  begin
     memo4.Clear;
     a := checklistbox2.ItemIndex;
     if a > -1 then
     for  i := 0 to checklistbox1.Items.Count - 1 do
     if (checklistbox1.Checked[i]) and
        (ddl[a,dar[i+1]].df > 0) then
     begin
       s := s + '<b>'+ddl[a,dar[i+1]].DName + '</b><br>'+
       form1.convertres(ddl[a,dar[i+1]].DDesc) + '<p>';
     end;
     memo4.Text:='<html><body>'+s+'</body></html>';
     if memo4.Lines.Count > 0 then
     begin
        savedialog1.FilterIndex:=2;
        savedialog1.FileName:='result.htm';
        if savedialog1.Execute then
        begin
           memo4.Lines.SaveToFile(savedialog1.FileName);
           shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
        end;
     end
     else
     Showmessage('No data to save.')
  end;
end;

procedure Tresform.MenuItem7Click(Sender: TObject);
begin
  Tz.show;
end;

procedure Tresform.MenuItem8Click(Sender: TObject);
var i : word;
begin
  if checklistbox2.Itemindex > - 1 then
  begin
    tz.StringGrid1.RowCount:= tz.StringGrid1.RowCount + 1;
    tz.StringGrid1.Cells[0,tz.StringGrid1.RowCount - 1] := checklistbox2.Items[checklistbox2.ItemIndex];
    tz.StringGrid1.Cells[1,tz.StringGrid1.RowCount - 1] := inttostr(ddl[checklistbox2.ItemIndex,1].ID);
    tz.StringGrid1.Cells[2,tz.StringGrid1.RowCount - 1] :=    datetimetostr(date);
    tz.StringGrid1.Cells[3,tz.StringGrid1.RowCount - 1] := '';
    tz.StringGrid1.Cells[4,tz.StringGrid1.RowCount - 1] := 'S';
    tz.StringGrid1.Cells[5,tz.StringGrid1.RowCount - 1] := '';
    form1.infx('Repository','Added: '+
    checklistbox2.Items[checklistbox2.ItemIndex]+#13+#10+
    'Total words in Repository: '+inttostr(tz.StringGrid1.RowCount - 1));
  end;
end;

procedure Tresform.MenuItem9Click(Sender: TObject);
var i : longint;
begin
    if checklistbox2.Items.Count > 0 then
    for i := 0 to checklistbox2.Items.Count - 1 do
    checklistbox2.Checked[i] := true;
end;

procedure Tresform.Mx1Click(Sender: TObject);
var i,j : dword;
begin
if checklistbox2.items.count > 0 then
begin
if Sender = mx1 then
begin
  j := 1;
  form1.Stringgrid1.RowCount := checklistbox2.items.Count+1;
  for i := 0 to checklistbox2.items.Count - 1 do
  if (checklistbox2.checked[i]) and
     (checklistbox2.Items[i] <> '')
  then
  begin
    form1.StringGrid1.Rows[j] := depo.StringGrid1.Rows[
    ddl[i,1].ID];
    inc(j);
  end;
  end
else
begin
  j := 1;
  form1.Stringgrid1.RowCount := checklistbox2.items.Count+1;
  begin
    form1.StringGrid1.Rows[j] := depo.StringGrid1.Rows[
    ddl[checklistbox2.ItemIndex,1].ID];
    inc(j);
  end;

end;
  form1.StringGrid1.RowCount:=j;
  form1.StatusBarx2.Panels[1].Text:=inttostr(j-1);
  form1.StatusBarx2.Panels[3].Text:= '0';
  form1.StatusBarx2.Panels[5].Text:= '';
  end;
end;

procedure Tresform.ProgressBar1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure Tresform.SAD1Change(Sender: TObject);
begin
  if sad1.Checked then
  if checklistbox2.ItemIndex > - 1 then
  checklistbox2click(sender);
end;

procedure Tresform.SAD1Click(Sender: TObject);
begin
  sad1.Checked:=not(sad1.Checked);
end;

procedure Tresform.SpeedButton19Click(Sender: TObject);
begin
  Tz.Show;
  tz.PageControl1.ActivePageIndex:=0;
end;

procedure Tresform.SpeedButton1Click(Sender: TObject);
begin
  MenuItem5Click(Sender);
end;

procedure Tresform.SpeedButton34Click(Sender: TObject);
begin
  popupmenu2.PopUp;
end;

procedure Tresform.SpeedButton35Click(Sender: TObject);
begin
  popupmenu1.PopUp;
end;

procedure Tresform.SpeedButton36Click(Sender: TObject);
var i : longint;
    k : longint;
    k1 : longint;
begin

  k := checklistbox2.ItemIndex;
  k1:= checklistbox1.ItemIndex;
  setlength(car,checklistbox2.Count);
  if (k = -1) and (checklistbox2.Count > 0) then k := 0;
  panel4.Hide;
  if checklistbox2.Count > 0 then
  for i := 0 to checklistbox2.count - 1 do
  begin
    checklistbox2.Checked[i] := true;
    car[i].c2:=true;
    car[i].c1:=[0..255];
//    MenuItem1Click(Sender);
  end;
  if k > - 1 then
  begin
     checklistbox2.ItemIndex:=k;
     checklistbox1.ItemIndex:=k1;
  end;
  if k1 > - 1 then
  begin
     checklistbox2click(sender);
     checklistbox1click(sender);

  end;



  panel4.Show;
end;

procedure Tresform.SpeedButton37Click(Sender: TObject);
var i : longint;
    k : longint;
begin
  k := checklistbox2.ItemIndex;
  if checklistbox2.Count > 0 then
  for i := 0 to checklistbox2.Items.Count - 1  do
  begin
    checklistbox2.Checked[i] := false;
    car[i].c2:=false;
    car[i].c1 := [];
  end;
  if k > - 1 then
  begin
     checklistbox2.ItemIndex:=k;
     checklistbox2click(sender);
  end;
end;

procedure Tresform.SpeedButton38Click(Sender: TObject);
begin
  resform.simpleview;

  hide;
end;

procedure Tresform.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
{  if updown1.Position < 12 then updown1.Position:=12;
  if checkbox2.Checked then
  memo2.Font.Size:=updown1.Position;
  if memo3.Visible then
  memo3.Font.Size:=updown1.Position;
  }
end;

procedure Tresform.Button1Click(Sender: TObject);
var i : longint;
begin
     if checklistbox2.Count > 0 then
     if checklistbox2.ItemIndex > - 1 then
     begin
        for i :=0 to checklistbox2.Count - 1 do
        begin
         car[i].c1 := car[checklistbox2.ItemIndex].c1;
        end;

     end;
  ;
end;
procedure tresform.simpleview;
var s,s1 : string;
    i : longint;
    j : longint;
    sender : tobject;
    k,k1:longint;
    c : longint;
begin
    s := '';
    c := 0;
    k := checklistbox2.ItemIndex;
    k1 := checklistbox1.ItemIndex;
    hide;

    form1.ProgressBar1.Show;
    form1.ProgressBar1.Max:=checklistbox2.Count - 1;
    if checklistbox2.Count > 0 then
begin
    for i := 0 to checklistbox2.Count - 1 do
    begin
        form1.ProgressBar1.Position:=i;
        checklistbox2.ItemIndex:=i;
        if checklistbox2.Checked[i] then
        begin
          s := s + checklistbox2.Items[i] + ' - ' +
          form1.convertd(checklistbox2.Items[i])
          + #13+#10;
          checklistbox2click(sender);
          if (car[i].c1 <> []) and (checklistbox1.Count > 0) then
             for j := 0 to checklistbox1.Count - 1 do
             if checklistbox1.Checked[j] then
             begin
               checklistbox1.ItemIndex:=j;
               checklistbox1click(sender);
//               if memo3.Text <> '' then
               begin
//                 s1 := form1.convertd (copy(checklistbox1.Items[j],1,pos(' ',checklistbox1.Items[j])));

//                s := s +  checklistbox1.Items[j] + #13+#10 +
//                memo3.Text + #13+#10;
                 inc(c);
               end;

             end;
        end;
     end;
     if k > - 1 then
     begin
        checklistbox2.ItemIndex:=k;
        checklistbox2click(sender);
     end;
     if k1 > -1 then
     begin
        checklistbox1.ItemIndex:=k1;
        checklistbox1click(sender);

     end;
    end;
    if s <> '' then form1.Memo1.Text:=s;
    form1.ProgressBar1.Hide;


    form1.Memo1.Show;
    form1.statusbarx2.Panels[1].Text:=inttostr(c);

end;

end.

