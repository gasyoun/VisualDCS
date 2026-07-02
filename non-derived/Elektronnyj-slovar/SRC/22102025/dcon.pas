unit dcon;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, ExtCtrls, ComCtrls, Buttons;

type

  { Tdc }

  Tdc = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    Shape1: TShape;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    StatusBar1: TStatusBar;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);

    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    function slpi(s : string) : string;
  private
  public
      var
    MS1,MSC1,MS2,MSC2 : pchar;
      procedure preptext;
      function ConvertIS(s :String) : string;
      function Nodiacrit(s : string) : string;
  end;

var
  dc: Tdc;


implementation
uses poisk,tt1,params;
var
  f4 : system.text;
  f5 : system.text;
  f6 : system.text;

  mc1 : boolean = false;
  mc2 : boolean = false;
{$R *.lfm}

{ Tdc }



procedure Tdc.Panel1Click(Sender: TObject);
begin

end;

procedure Tdc.SpeedButton1Click(Sender: TObject);
begin
  shape1.Left:=speedbutton1.Left;
  shape1.width:=speedbutton1.width;
  panel1.Parent := panel4;
  panel6.Parent := panel4;
  panel7.Parent := panel5;
  panel7.Show;
end;

procedure Tdc.SpeedButton2Click(Sender: TObject);
begin
  form8.show;
  form8.BringToFront;
  form8.pagecontrol1.ActivePageindex := 3;
end;

procedure Tdc.SpeedButton3Click(Sender: TObject);
begin
    shape1.Left:=speedbutton3.Left;
    shape1.width:=speedbutton3.width;
    panel1.Parent := panel4;
    panel7.Parent := panel4;
    panel6.Parent:=panel5;
    panel6.Show;


end;

procedure Tdc.SpeedButton4Click(Sender: TObject);
begin
    shape1.Left:=speedbutton4.Left;
    shape1.width:=speedbutton4.width;
    panel6.Parent := panel4;
    panel7.Parent := panel4;
    panel1.Parent:=panel5;
    panel1.Show;


end;

procedure Tdc.SpeedButton5Click(Sender: TObject);
begin
    Form1.MenuItem68Click(Sender);

end;

procedure Tdc.SpeedButton6Click(Sender: TObject);
var ms : byte;
begin
  if mc1 or mc2 then
  begin
  if mc1 then
  begin
     ms := application.MessageBox(MS1,MSC1,43);
     case ms of
        6 :  if savedialog1.Execute then
             begin
                memo1.Lines.savetofile(savedialog1.FileName);
                memo1.Clear;mc1 := false;
        end;
        7 :begin memo1.Clear;mc1 := false;end;
    end;
  end;
  if mc2 then
  begin
     ms := application.MessageBox(MS2,MSC2,43);
     case ms of
        6 :  if savedialog1.Execute then
             begin
                memo2.Lines.savetofile(savedialog1.FileName);
                memo2.Clear;mc2 := false;

        end;
        7 :begin memo2.Clear;mc2 := false;end;
    end;
  end;

  end;
end;

procedure Tdc.Button1Click(Sender: TObject);
var s : string;
    a : longint;
    s1: string;
    i : longint;
    s2 : string;
    s3,s4 : string;
begin
if combobox1.ItemIndex in [0,2,3] then
begin
  s2 := '';
  s3 := '';
  s4 := '';
  s1 := '';
  s := '';
case combobox1.ItemIndex of
      0 : begin memo3.Text := memo1.Text; memo2.Text := ''; memo2.Hide;  end;
      1 : begin memo3.Text := memo2.Text; memo1.Hide;  end;
      2 : begin memo3.Text := memo1.Text; memo2.Text := '';  end;
      3 : begin memo3.Text := memo1.Text; memo2.Text := ''; memo2.Hide;  end;
   end;
  progressbar1.Show;
if memo3.Lines.Count > 0 then
for a := 0 to memo3.Lines.Count - 1 do
begin


  s := memo3.Lines.Strings[a];
if combobox1.ItemIndex <> 3 then
begin
  while s <> '' do
  begin
    if s[length(s)] <> ' ' then
    s := s + ' ';
    progressbar1.Position:= round(a/memo3.Lines.Count*100);
    i := 1;
    while (not(s[i] in sbl2 - ['0'..'9']) and (i < length(s))) do
    begin
      s1 := s1 + s[i];
      inc(i)
    end;
    with form1 do
    begin
       case dc.combobox1.ItemIndex of
             0 : s1 := convertd(convertx(s1));
             1 : s1 := convertd(convertx(s1));
             2 : begin s3 := convertd(convertx(s1)); s1 := convertx(s1); end;
             3 : s1 := convertx(s1);

    end;

    delete(s,1,i);
    s4 := s4 + s3;
    s2 := s2 + s1;
    if s2 <> '' then
    if s2[length(s2)] <> ' ' then s2 := s2 + ' ';
    if s4 <> '' then
    if s4[length(s4)] <> ' ' then s4 := s4 + ' ';
    if dc.combobox1.ItemIndex <> 3 then
    s1 := '';
    s3 := '';
    end;

end
end;

case combobox1.itemindex of
          0 : begin
                     memo2.Lines.Add(s2);
                     s2 := '';
          end;
          1 : begin  s2 := s2 + s1;
                     memo2.Lines.Add(s2);
                     s2 := '';
          end;
     2:
      begin
        memo2.Lines.Add(s4);
        memo2.Lines.Add(s2);
        s2 := '';
        s4 := ''
      end;
   3 : begin
          s1 := form1.convertx(s);
          while pos('^',s1) > 0 do delete(s1,pos('^',s1),1);
          memo2.Lines.Add(s1);
          s2 := '';
          s4 := '';
   end;
  end;
end;
     progressbar1.Hide;
     memo2.Show;
     memo1.Show;
end;
end;

procedure Tdc.Button2Click(Sender: TObject);
var j,p,a,i : longint;
    q : longint;
    s,s2,k : string;
    z1,z : boolean;
    flg : boolean;

begin

    rewrite(f4);
    rewrite(f5);
//    rewrite(f6);
if combobox2.ItemIndex = 0 then
begin
flg := false;
z1 := checkbox1.Checked;
checkbox1.Checked:=false;
listbox1.Clear;
listbox1.Sorted:=false;
if memo1.Text <> '' then
begin
  memo1.Hide;

  s := ' ';
  for j := 0 to memo1.lines.count - 1 do
  begin
    s := form1.convertx(memo1.Lines.Strings[j]);
    if s <> '' then
    begin
       k := '';
       z := false;

       if s <> '' then
       for i  := 1 to length (s) do
       begin
           if s = '' then break;
           for a := 1 to length(da) do
           begin
               p := pos(da[a].deva,s);
               if p = 1 then
               begin
                  if (pos('ai',s) <> 1) and (pos('au',s) <> 1) and
                     (pos('kh',s) <> 1) and (pos('gh',s) <> 1)  and
                     (pos('th',s) <> 1) and (pos('dh',s) <> 1)  and
                     (pos('ph',s) <> 1) and (pos('bh',s) <> 1)  and
                     (pos('ch',s) <> 1) and (pos('jh',s) <> 1)  and
                     (pos('ṭh',s) <> 1) and (pos('ḍh',s) <> 1)
                     then
                     begin
                      if a < 10 then  k := k +'0'+inttostr(a)
                      else k := k + inttostr(a);

                      delete(s,1,length(da[a].deva));
                      flg := true;
                     end
                 else
                 if a in [23,24,30,32,35,37,40,42,45,47,50,52,55,57,69..72]  then
                 begin
                     k := k + inttostr(a);
                     delete(s,1,length(da[a].deva));
                     flg := true;
                   end;
               end;

           end;
        end;
        if (k <> '')  then
        Writeln(f4,k);
//        listbox1.Items.Add(k);

        k := '';


    end;
  end;
system.Close(f4);
listbox1.Items.LoadFromFile('sys\tmp.s1');
system.Erase(f4);
memo1.Clear;
memo2.Clear;
listbox1.Sorted:=true;;

for j := 0 to listbox1.Items.Count - 1 do
begin
 s := listbox1.Items[j];
 k := '';

 for i := 1 to length(s) div 2 do
 if s <> '' then
 begin
    if length(s) >= 2 then
    begin
       q := strtoint(copy(s,1,2))       ;
       k := k +  da[q].deva;

       delete(s,1,2);

    end
    else s := '';
 end;
if k <> '' then
writeln(f5,k);


end;
system.Close(f5);
memo1.Lines.LoadFromFile('sys\tmp.s2');
erase(f5);
//for i := 0 to listbox1.Items.Count - 1 do
//memo1.Lines.Add(listbox1.Items[i]);
 memo1.Show;
//checkbox1.Checked:=z1;
//if z1 then button1click(sender);

end;
end
else
begin
  listbox1.Clear;
  memo1.Lines.SaveToFile('sys\tmp.s4');
  listbox1.Items.LoadFromFile('sys\tmp.s4');
{  for j := 0 to memo1.Lines.Count - 1 do
  begin
    listbox1.Items.Add(memo1.Lines.Strings[j]);
  end;
}
  listbox1.Sorted:=true;
  memo1.Lines.text := listbox1.Items.Text;
 end;
end;
procedure Tdc.Button3Click(Sender: TObject);
var s,s1 : string;
    i : longint;
    z : boolean;
begin
  progressbar1.Show;
  progressbar1.Max:=100;
  progressbar1.Min:=0;
  progressbar1.Step:=5;

  if memo1.text <> '' then
  begin
  if checkbox3.Checked then
     begin;
        preptext;
        memo1.Clear;
        memo1.Lines.LoadFromFile('sys\tmp.txt');
     end;

  end;
  progressbar1.Position:=20;

  s1 := '';

  z := checkbox1.Checked;
  memo4.Text:= '';
   checkbox1.Checked:=false;
   button2click(sender);
   progressbar1.Position:=40;
   memo4.Text:='';
   for i := 0 to memo1.Lines.Count - 1 do
   begin
//     progressbar1.Position:=round(i / memo1.Lines.Count)*100;
     if i > 0 then
     s := memo1.Lines.Strings[i-1]
     else
        s :=''; //memo1.Lines.Strings[i];
     s1 := memo1.Lines.Strings[i];
     if s <> s1 then memo4.Lines.Add(s1);
   end;
   progressbar1.Position:=100;
   memo1.Text:=memo4.Text;
   progressbar1.Hide;
end;

procedure Tdc.Button4Click(Sender: TObject);
var i : longint;
    s : string;
begin   s := '';
    memo2.Clear;
    for i := 0 to memo1.Lines.Count - 1 do
    s := s + convertis(memo1.Lines.Strings[i])+';' + #13+#10;

    memo2.Lines.Text:=s;
    statusbar1.Panels[3].Text:=inttostr(memo2.Lines.Count);
    ;
end;

procedure Tdc.Button5Click(Sender: TObject);
var i,j,k : longint; s,s1 : string;
begin s := ''; s1 := '';
    memo2.Clear;
    for i := 0 to memo1.Lines.Count - 1 do
    begin
      s := slpi(memo1.Lines.Strings[i]);

      s1 := s1 + s + #13+#10;
    end;
    memo2.Text:=s1;
end;

procedure Tdc.Button6Click(Sender: TObject);
var i : dword; s,s1 : string;
begin s1 := '';
  if memo1.Text <> '' then
  begin
    rewrite(f5);
    progressbar1.Show;progressbar1.Position:=0;
    progressbar1.Max:=100;
    for i := 0 to memo1.Lines.Count - 1 do
    begin
      s := nodiacrit(memo1.Lines.Strings[i]);
      writeln(f5,s);
      progressbar1.Position:=round(i/memo1.Lines.Count*100);
    end;
    closefile(f5);
    memo2.Lines.LoadFromFile('sys\tmp.s2');

    progressbar1.Hide;
    statusbar1.Panels[3].Text:=inttostr(memo2.Lines.Count);
  end;
end;

procedure Tdc.CheckBox2Change(Sender: TObject);
begin
end;




procedure Tdc.ComboBox1Change(Sender: TObject);
begin
if (checkbox1.Checked) and
   (combobox1.ItemIndex <> 1)
then button1click(sender);
end;

procedure Tdc.ComboBox1CloseUp(Sender: TObject);
begin

end;

procedure Tdc.FindDialog1Find(Sender: TObject);
begin
end;


procedure Tdc.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var msg,msg2 : string;
begin
end;

procedure Tdc.FormCreate(Sender: TObject);
begin
    MS1 := 'Сохранить данные окна ввода?';
    MS2 := 'Сохранить данные окна вывода?';
    MSC1 := 'Текст окна ввода изменён';
    MSC2 := 'Текст окна вывода изменён';

end;

procedure Tdc.FormResize(Sender: TObject);
begin
  groupbox1.Height:=height div 2 - 35;
  groupbox2.Height:=height div 2;

end;




procedure Tdc.Memo1Change(Sender: TObject);
begin
  if checkbox1.Checked then
  begin
    button1click(sender);
  end;
  statusbar1.Panels[1].Text:=inttostr(memo1.Lines.Count);
  statusbar1.Panels[3].Text:=inttostr(memo2.Lines.Count);
  mc1 := true;
end;

procedure Tdc.Memo2Change(Sender: TObject);
begin

  mc2 := true;
{
  if combobox1.itemindex = 1 then
  if checkbox1.Checked then
  begin
    button1click(sender);
  end;
  statusbar1.Panels[1].Text:=inttostr(memo1.Lines.Count);
  statusbar1.Panels[3].Text:=inttostr(memo2.Lines.Count);
}
end;






procedure Tdc.preptext;
var i : longint;
    j : longint;
    s : string;
    s1: string;
    f : system.Text;
begin
  system.assign(f,'sys\tmp.txt');
  rewrite(f);

  for i := 0 to memo1.lines.Count - 1 do
  if memo1.lines.strings[i] <> '' then
  begin
    s := memo1.lines.Strings[i];
    s1 := '';
    for j := 1 to length(s) do
    begin
      if s[j] in sbl - ['0'..'9'] then
      begin
        writeln(f,s1);
        s1 := '';
      end
      else s1 := s1 + s[j]
    end;
    if s1 <> '' then  writeln(f,s1);
  end;
  system.close(f);
end;
function TDC.ConvertIS(s :String) : string;
var s1 : string; i : byte; j : longint;
begin  s1 := '';
    for j := 1 to length(s) do
    begin
      if pos('au',s) = 1 then begin delete(s,1,2); s1 := s1 +'O'; end;
      if pos('ai',s) = 1 then begin delete(s,1,2); s1 := s1 +'E';  end;
      if pos('kh',s) = 1 then begin delete(s,1,2); s1 := s1 +'K'; end;
      if pos('gh',s) = 1 then begin delete(s,1,2); s1 :=s1 + 'G'; end;
      if pos('th',s) = 1 then begin delete(s,1,2); s1 :=s1 + 'T'; end;
      if pos('dh',s) = 1 then begin delete(s,1,2); s1 := s1 +'D'; end;
      if pos('ch',s) = 1 then begin delete(s,1,2); s1 := s1 +'C'; end;
      if pos('jh',s) = 1 then begin delete(s,1,2); s1 := s1 +'J'; end;
      if pos('ph',s) = 1 then begin delete(s,1,2); s1 := s1 +'P'; end;
      if pos('bh',s) = 1 then begin delete(s,1,2); s1 := s1 +'B'; end;
      if pos('ṭh',s) = 1 then begin delete(s,1,length('ṭh')); s1 := s1 +'W'; end;
      if pos('ḍh',s) = 1 then begin delete(s,1,length('ḍh')); s1 :=s1 + 'Q'; end;
      for i := 1 to Length(D) do
      if pos(d[i].deva,s) = 1 then
      begin s1 := s1 + d[i].slp1;
            delete(s,1,length(d[i].deva));
            break;
      end;

    end;
    if checkbox4.Checked then
    ConvertIS := s1 + ';'+inttostr(length(s1))
    else
       ConvertIS := s1;
end;
function TDC.slpi(s : string) : string;
var i,j,k : longint; s1 : string;
begin s1 := '';
      for j := 1 to length(s) do
      for k := 1 to 51 do
      if s[j] = d[k].slp1 then
      begin
         s1 := s1 + d[k].deva;
         break;
      end;
      slpi := s1;

end;
function TDC.Nodiacrit(s : string) : string;
var i,k : dword;
const X : array[1..17,1..2] of string =
  (('ā','a'),('ī','i'),('ū','u'),('ṛ','r'),('ṝ','r'),('ḷ','l'),('ḹ','l')
  ,('ṅ','n'),('ṇ','n'),('ñ','n'),('ṁ','m'),('m̩','n'),('ḥ','h'),('ṣ','sh')
  ,('ś','sh'),('ṭ','t'),('ḍ','d'));
begin
  if s <> '' then
  begin
     for i := 1 to length(X) do
     begin
      k := pos(x[i,1],s);
      while k  > 0 do
      begin
        insert(x[i,2],s,k); delete(s,pos(x[i,1],s),length(x[i,1]));
        k := pos(x[i,1],s);
      end;
     end;

  end;
  Nodiacrit := s;
end;



begin
      system.assign(f4,'sys\tmp.s1');
      system.assign(f5,'sys\tmp.s2');




end.

