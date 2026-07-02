unit tcompare;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls, ComCtrls, CheckLst, Menus;

type

  { TCT }

  TCT = class(TForm)
    Button1: TButton;
    BT2: TButton;
    Save1: TButton;
    Button24: TButton;
    Button4: TButton;
    Button6: TButton;
    CheckListBox1: TCheckListBox;
    CheckListBox10: TCheckListBox;
    CheckListBox2: TCheckListBox;
    CheckListBox3: TCheckListBox;
    CheckListBox4: TCheckListBox;
    CheckListBox7: TCheckListBox;
    CheckListBox8: TCheckListBox;
    CheckListBox9: TCheckListBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    Separator6: TMenuItem;
    PopupMenu5: TPopupMenu;
    PopupMenu6: TPopupMenu;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Separator5: TMenuItem;
    PopupMenu4: TPopupMenu;
    Separator4: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    Separator3: TMenuItem;
    Separator2: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Separator1: TMenuItem;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    procedure BT2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
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
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem31Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem34Click(Sender: TObject);
    procedure MenuItem35Click(Sender: TObject);
    procedure MenuItem36Click(Sender: TObject);
    procedure MenuItem37Click(Sender: TObject);
    procedure MenuItem38Click(Sender: TObject);
    procedure MenuItem39Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem40Click(Sender: TObject);
    procedure MenuItem41Click(Sender: TObject);
    procedure MenuItem42Click(Sender: TObject);
    procedure MenuItem43Click(Sender: TObject);
    procedure MenuItem44Click(Sender: TObject);
    procedure MenuItem45Click(Sender: TObject);
    procedure MenuItem46Click(Sender: TObject);
    procedure MenuItem47Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Separator2Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure StringGrid2AfterSelection(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid2CheckboxToggled(Sender: TObject; aCol, aRow: Integer;
      aState: TCheckboxState);
    procedure StringGrid2Click(Sender: TObject);
  private

  public
   procedure BGraph;
   procedure Getdist;
   Function GMD(s : string) : integer;
   procedure prep;
  end;
type DateRec = record
           D1,D2 : longint; Dc : boolean;
           end;
  ParamRec = Record
             Name : string;
             P    : Real;
             Norm : real;
             nld  : boolean;
             en   : boolean;
  end;
  PArray = Array[0..220] of paramrec;
  RS = record
     Name : string;
     p    : real;
  end;
var
  CT: TCT;
  AAA : array[0..248] of PArray;
  AA,AX  : PArray;
  Epoh : array of daterec;
  REsAX : Array[1..250] of RS;
implementation
uses poisk,shellapi,trwin;
{$R *.lfm}
Var T1 : boolean = true;
    R : dword = 1;
    AQ : Array[1..7,1..50] of byte;
    A1,A2,A3,A4,A5,A6,A7 : PArray;
{ TCT }

procedure TCT.Button1Click(Sender: TObject);
var i,j,k : dword;
begin
progressbar1.Position:=0;
  j := checklistbox1.ItemIndex;
  for i := 0 to checklistbox1.Items.Count - 1 do
  if checklistbox1.Checked[i] then
  begin
     progressbar1.Position:=round(i/checklistbox1.Count*100);
    checklistbox1.ItemIndex:=i;
    button2click(sender);
    AA[0].en := checklistbox1.Checked[i];
    AAA[i] := AA;
  end;
  checklistbox1.ItemIndex:=j;
  button2click(sender);
  AA[0].en := checklistbox1.Checked[j];

Stringgrid3.Clear;
stringgrid3.RowCount:=70000;
Stringgrid3.ColCount:=5;
Stringgrid3.Cells[0,0] :='Средняя дата';
Stringgrid3.Cells[1,0] :='Текст 1';
Stringgrid3.Cells[2,0] :='Средняя дата';
Stringgrid3.Cells[3,0] :='Текст 2';
Stringgrid3.Cells[4,0] :='Коэффициент близости';
R := 1;
  Getdist;
;
stringgrid3.RowCount:=R;

  pagecontrol1.ActivePageIndex:=5;
  progressbar1.Position:=0;
  progressbar2.Position:=0;

  for i := 1 to stringgrid3.RowCount - 1 do
  while length(stringgrid3.Cells[4,i]) < 10 do
  stringgrid3.Cells[4,i] := ' '+stringgrid3.Cells[4,i];
end;

procedure TCT.BT2Click(Sender: TObject);
var i,j,x1,x2,x3,x4,x5,x6,x7 : word;
begin x1 := 0;x2 := 0;x3 := 0;x4 := 0;x5 := 0;x6 := 0;x7 := 0;
    for i := 0 to length(AX) - 1 do
    begin
      A1[i].en:=false;A2[i].en:=false;A3[i].en:=false;
      A4[i].en:=false;A5[i].en:=false;A6[i].en:=false;
      A7[i].en:=false;
    end;
    with Tr do
    begin
      ls1.Clear;ls2.Clear;ls3.Clear;ls4.Clear;
      ls5.Clear;ls6.Clear;
    end;
    Stringgrid1.LoadFromCSVFile('sys\T\texts.csv',#9);
    checklistbox1.Clear;
    for i := 1 to stringgrid1.RowCount - 1 do
    begin
      checklistbox1.Items.Add(stringgrid1.Cells[0,i]);
      checklistbox1.Checked[i-1] := true;
    end;
    for i := 0 to checklistbox1.Items.Count - 1 do
    begin
      checklistbox1.ItemIndex:=i;
      button2click(sender);
      AA[0].en:=true;
      AAA[i] := AA;
    end;
    for i := 0 to length(AAA) do
    begin
      if AAA[i,0].P <= -800 then
      begin inc(x1);
        for j := 4 to length(AA) do
        if AAA[i,j].en then
        begin    A1[j].P:= (A1[j].P + AAA[i,j].P);
                 A1[j].en:=true;
                 A1[j].Name:=AAA[i,j].Name;
        end;
      end;
      if (AAA[i,0].P >= -800) and (AAA[i,0].P <= -300) then
      begin inc(x2);
        for j := 4 to length(AA) do
        if AAA[i,j].en then
        begin A2[j].P:= (A2[j].P + AAA[i,j].P);
              A2[j].en:=true;
              A2[j].Name:=AAA[i,j].Name;
        end;
      end;
      if (AAA[i,0].P >= -300) and (AAA[i,0].P <= 200) then
      begin inc(x3);
        for j := 4 to length(AA) do
        if AAA[i,j].en then
        begin
           A3[j].P:= (A3[j].P + AAA[i,j].P);
           A3[j].en:=true;
           A3[j].Name:=AAA[i,j].Name;
        end;
      end;
      if (AAA[i,0].P >= 200) and (AAA[i,0].P <= 700) then
      begin inc(x4);
        for j := 4 to length(AA) do
        if AAA[i,j].en then
        begin A4[j].P:= (A4[j].P + AAA[i,j].P);
              A4[j].en:=true;
              A4[j].Name:=AAA[i,j].Name;
        end;
      end;
      if (AAA[i,0].P >= 700) and (AAA[i,0].P <= 1200) then
      begin inc(x5);
        for j := 4 to length(AA) do
        if AAA[i,j].en then
        begin A5[j].P:= (A5[j].P + AAA[i,j].P);
              A5[j].en:=true;
              A5[j].Name:=AAA[i,j].Name;
        end;
      end;
      if (AAA[i,0].P >= 1200) and (AAA[i,0].P <= 1700) then
      begin inc(x6);
        for j := 4 to length(AA) do
        if AAA[i,j].en then
        begin A6[j].P:= (A6[j].P + AAA[i,j].P);
              A6[j].en:=true;
              A6[j].Name:=AAA[i,j].Name;
        end;
      end;
      if (AAA[i,0].P >= 1700) and (AAA[i,0].P <= 1960) then
      begin inc(x7);
        for j := 4 to length(AA) do
        if AAA[i,j].en then
        begin
           A7[j].P:= (A7[j].P + AAA[i,j].P);
           A7[j].en:=true;
           A7[j].Name:=AAA[i,j].Name;
        end;
      end;
    end;
    Stringgrid3.ColCount:=8;
    Stringgrid3.Cells[0,0] := 'Средн.Парам.';
    Stringgrid3.Cells[1,0] := 'до -800 г.';
    Stringgrid3.Cells[2,0] := '-800_-300';
    Stringgrid3.Cells[3,0] := '-300_200';
    Stringgrid3.Cells[4,0] := '200_700';
    Stringgrid3.Cells[5,0] := '700_1200';
    Stringgrid3.Cells[6,0] := '1200_1700';
    Stringgrid3.Cells[7,0] := '1700_1956';
    R := 2;
    For i := 4 to length(AA) do
    if A1[i].en then
    begin
      Stringgrid3.RowCount:=R;
      stringgrid3.Cells[0,R-1] := A1[i].name;
      stringgrid3.Cells[1,R-1] := floattostr(A1[i].P/x1);
      stringgrid3.Cells[2,R-1] := floattostr(A2[i].P/x2);
      stringgrid3.Cells[3,R-1] := floattostr(A3[i].P/x3);
      stringgrid3.Cells[4,R-1] := floattostr(A4[i].P/X4);
      stringgrid3.Cells[5,R-1] := floattostr(A5[i].P/X5);
      stringgrid3.Cells[6,R-1] := floattostr(A6[i].P/X6);
      stringgrid3.Cells[7,R-1] := floattostr(A7[i].P/X7);
      inc(R);
    end;
    pagecontrol1.ActivePageIndex:=5;
end;

procedure TCT.Button24Click(Sender: TObject);
begin
  if checklistbox1.ItemIndex > - 1 then
  begin;

     Button2click(sender);
     BGraph;
  end;
  progressbar1.Position:=0;
  progressbar2.Position:=0;
end;

procedure TCT.Button2Click(Sender: TObject);
var i,j,k,l : dword;
begin
  progressbar2.Position:=0;
  for j := 0 to length(aa)-1 do
  begin
    aa[j].en:=false;aa[j].P:=0;aa[j].nld:=false;aa[j].Name:='';aa[j].Norm:=0;
  end;

    for l := 1 to stringgrid1.RowCount - 1 do
    if stringgrid1.Cells[0,l] = checklistbox1.Items[checklistbox1.ItemIndex] then break;

//    for i := 4 to stringgrid1.ColCount - 1 do
    begin
      AA[0].Name:=checklistbox1.Items[checklistbox1.ItemIndex];
      AA[0].P:=GMD(checklistbox1.Items[checklistbox1.ItemIndex]);
      for j := 0 to checklistbox10.Count - 1 do
      if checklistbox10.Checked[j] then
      begin
         k := aq[7,j+1];
         AA[k].en:=true; aa[k].Name:=checklistbox10.Items[j];
         AA[k].nld:=true;AA[k].P:=strtofloat(stringgrid1.Cells[k,l]);
      end;
progressbar2.Position:=20;
      for j := 0 to checklistbox9.Count - 1 do
      if checklistbox9.Checked[j] then
      begin
         k := aq[6,j+1];
         AA[k].en:=true; aa[k].Name:=checklistbox9.Items[j];
         AA[k].nld:=true;AA[k].P:=strtofloat(stringgrid1.Cells[k,l]);
      end;
      progressbar2.Position:=30;

      for j := 0 to checklistbox2.Count - 1 do
      if checklistbox2.Checked[j] then
      begin
         k := aq[1,j+1];
         AA[k].en:=true; aa[k].Name:=checklistbox2.Items[j];
          AA[k].nld:=false;
          if strtofloat(stringgrid1.Cells[13,l]) > 0 then
          AA[k].P:=strtofloat(stringgrid1.Cells[k,l])/strtofloat(stringgrid1.Cells[13,l])*100
          else AA[k].P:=0;
      end;
      progressbar2.Position:=40;

      for j := 0 to checklistbox3.Count - 1 do
      if checklistbox3.Checked[j] then
      begin
         k := aq[2,j+1];
         AA[k].en:=true; aa[k].Name:=checklistbox3.Items[j];
         AA[k].nld:=false;
         if strtofloat(stringgrid1.Cells[13,l]) > 0 then
         AA[k].P:=strtofloat(stringgrid1.Cells[k,l])/strtofloat(stringgrid1.Cells[13,l])*100
         else AA[k].p := 0;
      end;
      progressbar2.Position:=60;

      for j := 0 to checklistbox4.Count - 1 do
      if checklistbox4.Checked[j] then
      begin
         k := aq[3,j+1];
         AA[k].en:=true; aa[k].Name:=checklistbox4.Items[j];
         AA[k].nld:=false;
         if (strtofloat(stringgrid1.Cells[5,l])+
         strtofloat(stringgrid1.Cells[7,l])+
         strtofloat(stringgrid1.Cells[11,l])) > 0 then
         AA[k].P:=strtofloat(stringgrid1.Cells[k,l])/
         (strtofloat(stringgrid1.Cells[5,l])+
         strtofloat(stringgrid1.Cells[7,l])+
         strtofloat(stringgrid1.Cells[11,l]))*100
         else AA[k].P:=0;
      end;
   progressbar2.Position:=80;
      for j := 0 to checklistbox7.Count - 1 do
      if checklistbox7.Checked[j] then
      begin
         k := aq[4,j+1];
         AA[k].en:=true; aa[k].Name:=checklistbox7.Items[j];
         AA[k].nld:=false;AA[k].P:=strtofloat(stringgrid1.Cells[k,l])
      end;
    end;
///Pressed
progressbar2.Position:=100;
end;

procedure TCT.Button4Click(Sender: TObject);
var i,j,k : dword;
    x : text;

begin assignfile(x,'sys\testAAA.csv');rewrite(x);
progressbar1.Position:=0;
  for i := 0 to checklistbox1.Items.Count - 1 do
  if checklistbox1.Checked[i] then
  begin
     progressbar1.Position:=round(i/checklistbox1.Count*100);
    checklistbox1.ItemIndex:=i;
    button2click(sender);
    AA[0].en := checklistbox1.Checked[i];
    AAA[i] := AA;
  end;
Stringgrid3.Clear;
stringgrid3.RowCount:=70000;
Stringgrid3.ColCount:=5;
Stringgrid3.Cells[0,0] :='Средняя дата';
Stringgrid3.Cells[1,0] :='Текст 1';
Stringgrid3.Cells[2,0] :='Средняя дата';
Stringgrid3.Cells[3,0] :='Текст 2';
Stringgrid3.Cells[4,0] :='Коэффициент близости';

R := 1;
for i := 0 to length(aaa) do
if AAA[i,0].en then
begin
  AA := AAA[i];
  Getdist;

end;
stringgrid3.RowCount:=R;
for i := 1 to stringgrid3.RowCount - 1 do
while length(stringgrid3.Cells[4,i]) < 10 do
stringgrid3.Cells[4,i] := ' '+stringgrid3.Cells[4,i];
  for i := 0 to length(aaa) do
  if AAA[i,0].en then
  begin
     for j := 0 to length(AAA[i]) do
     if aaA[i,j].en then
     write(x,aaa[i,j].name,#9,aaa[i,j].P:2:5,#9);
     writeln(x,'');
  end;
  closefile(x);
  pagecontrol1.ActivePageIndex:=5;
  progressbar1.Position:=0;
  progressbar2.Position:=0;
end;

procedure TCT.Button6Click(Sender: TObject);
var i,j : dword; d1,d2,d3,d4 : longint; z : boolean;
    zzz : boolean;
begin  Setlength(Epoh,stringgrid2.RowCount);

  if length(epoh) = 1 then
  begin
     epoh[0].D1:=-2600;epoh[0].D2:=2600;
     epoh[0].Dc:=true;
  end;
  zzz := false;
  for i := 1 to stringgrid2.RowCount-1 do
  if stringgrid2.Cells[3,i] = '1' then zzz := true;
  if zzz then
  begin

  checklistbox1.Clear;
  for i := 1 to stringgrid1.RowCount - 1 do
  begin
    d1 := strtoint(stringgrid1.Cells[1,i]);
    d2 := strtoint(stringgrid1.Cells[2,i]);
    z := false;
    for j := 1 to stringgrid2.RowCount - 1 do
    if stringgrid2.Cells[3,j] = '1' then
    begin
      d3 := strtoint(stringgrid2.Cells[1,j]);
      d4 := strtoint(stringgrid2.Cells[2,j]);
      if (d1 >= d3) and (d2 <= d4) then z := true;
    end;
  if z then
     checklistbox1.Items.Add(stringgrid1.Cells[0,i]);
  end;
  if checklistbox1.Items.Count > 0 then
  for i := 0 to checklistbox1.Items.Count- 1 do
  begin
     checklistbox1.checked[i] := true;
  end;
  Statusbar2.Panels[1].Text:=inttostr(checklistbox1.Items.Count);
  checklistbox1ClickCheck(Sender);

  end;
end;

procedure TCT.CheckBox2Change(Sender: TObject);
begin

end;

procedure TCT.CheckListBox1ClickCheck(Sender: TObject);
var i,j : dword;
begin
    j := 0;
    for i := 0 to checklistbox1.Count - 1 do
    if checklistbox1.Checked[i] then inc(j);
    statusbar2.Panels[3].Text:=inttostr(j);
end;

procedure TCT.FormActivate(Sender: TObject);
  var i,j : word; s,s1 : string;k:real;
  begin
end;

procedure TCT.FormCreate(Sender: TObject);
begin

end;

procedure TCT.MenuItem10Click(Sender: TObject);
Var i : word;
begin
  for i := 1 to stringgrid2.RowCount - 1 do
  if stringgrid2.Cells[3,i] = '1' then
  stringgrid2.Cells[3,i] := '0' else
  stringgrid2.Cells[3,i] := '1';
end;

procedure TCT.MenuItem11Click(Sender: TObject);
begin
  Checklistbox1.CheckAll(cbunchecked);
  checklistbox1ClickCheck(Sender);
end;

procedure TCT.MenuItem12Click(Sender: TObject);
var i : dword;
begin
    for i := 0 to checklistbox1.Count - 1 do
    checklistbox1.Checked[i] :=
    not(checklistbox1.Checked[i]);
    checklistbox1ClickCheck(Sender);
end;

procedure TCT.MenuItem13Click(Sender: TObject);
var i : byte;
begin
  for i := 0 to checklistbox9.Count-1 do
  checklistbox9.Checked[i] := true;
end;

procedure TCT.MenuItem14Click(Sender: TObject);
var i : byte;
begin
  for i := 0 to 15 do
  checklistbox9.Checked[i] := true;

end;

procedure TCT.MenuItem15Click(Sender: TObject);
var i : byte;
begin
  for i := 16 to checklistbox9.Count-1 do
  checklistbox9.Checked[i] := true;

end;

procedure TCT.MenuItem16Click(Sender: TObject);
var i : byte;
begin
  for i := 16 to 20 do
  checklistbox9.Checked[i] := true;

end;

procedure TCT.MenuItem17Click(Sender: TObject);
var i : byte;
begin
  for i := 21 to 25 do
  checklistbox9.Checked[i] := true;

end;

procedure TCT.MenuItem18Click(Sender: TObject);
var i : byte;
begin
  for i := 26 to 30 do
  checklistbox9.Checked[i] := true;

end;

procedure TCT.MenuItem19Click(Sender: TObject);
var i : byte;
begin
  for i := 31 to 35 do
  checklistbox9.Checked[i] := true;

end;

procedure TCT.MenuItem1Click(Sender: TObject);
begin
  stringgrid2.Cells[1,stringgrid2.Row] := '-2500';
  stringgrid2.Cells[2,stringgrid2.Row] := '2500';
  stringgrid2.Cells[3,stringgrid2.Row] := '1';

end;

procedure TCT.MenuItem20Click(Sender: TObject);
var i : byte;
begin
  for i := 36 to 40 do
  checklistbox9.Checked[i] := true;

end;

procedure TCT.MenuItem21Click(Sender: TObject);
var i : byte;
begin
  for i := 16 to 40 do
  if pos('h',checklistbox9.Items[i]) > 1 then
  checklistbox9.Checked[i] := true;

end;

procedure TCT.MenuItem22Click(Sender: TObject);
begin
  Checklistbox9.Checked[25] := true;
  Checklistbox9.Checked[30] := true;
  Checklistbox9.Checked[35] := true;
  Checklistbox9.Checked[40] := true;
  Checklistbox9.Checked[20] := true;

end;

procedure TCT.MenuItem23Click(Sender: TObject);
var i : byte;
begin
  for i := 0 to checklistbox9.Count-1 do
  checklistbox9.Checked[i] := false;

end;

procedure TCT.MenuItem24Click(Sender: TObject);
var i : byte;
begin
  for i := 0 to checklistbox9.Count-1 do
  checklistbox9.Checked[i] := not(checklistbox9.Checked[i]);

end;

procedure TCT.MenuItem25Click(Sender: TObject);
var i : byte;
begin
 case  pagecontrol2.ActivePageIndex of
 0 : for i := 0 to checklistbox2.items.Count - 1 do checklistbox2.Checked[i] := true;
 1 : for i := 0 to checklistbox3.items.Count - 1 do checklistbox3.Checked[i] := true;
 end;
end;

procedure TCT.MenuItem26Click(Sender: TObject);
var i : byte;
begin
 case  pagecontrol2.ActivePageIndex of
 0 : for i := 0 to checklistbox2.items.Count - 1 do checklistbox2.Checked[i] := false;
 1 : for i := 0 to checklistbox3.items.Count - 1 do checklistbox3.Checked[i] := false;
 end;


end;

procedure TCT.MenuItem27Click(Sender: TObject);
var i : byte;
begin
 case  pagecontrol2.ActivePageIndex of
 0 : for i := 0 to checklistbox2.items.Count - 1 do checklistbox2.Checked[i]
 :=  not(checklistbox2.Checked[i]);
 1 : for i := 0 to checklistbox3.items.Count - 1 do checklistbox3.Checked[i]
    := not(checklistbox3.Checked[i]);
 end;


end;

procedure TCT.MenuItem28Click(Sender: TObject);
var i : byte;
begin
 case  pagecontrol2.ActivePageIndex of
 0 : for i := 0 to checklistbox2.items.Count - 1 do
     if (pos('past',lowercase(checklistbox2.items[i])) > 0) or
        (pos('aor',lowercase(checklistbox2.items[i])) > 0) or
        (pos('perf',lowercase(checklistbox2.items[i])) > 0)  then
     checklistbox2.Checked[i] := true;
 1 : for i := 0 to checklistbox3.items.Count - 1 do
     if (pos('past',lowercase(checklistbox3.items[i])) > 0) or
        (pos('aor',lowercase(checklistbox3.items[i])) > 0) or
        (pos('perf',lowercase(checklistbox3.items[i])) > 0) then
     checklistbox3.Checked[i] := true;
 end;


end;

procedure TCT.MenuItem29Click(Sender: TObject);
var i : byte;
begin
 case  pagecontrol2.ActivePageIndex of
 0 : for i := 0 to checklistbox2.items.Count - 1 do
     if (pos('pres',lowercase(checklistbox2.items[i])) > 0) then checklistbox2.Checked[i] :=true;
 1 : for i := 0 to checklistbox3.items.Count - 1 do
     if (pos('pres',lowercase(checklistbox3.items[i])) > 0) then
     checklistbox3.Checked[i] := true;
 end;

end;

procedure TCT.MenuItem2Click(Sender: TObject);
begin
  stringgrid2.Cells[1,stringgrid2.Row] := '-500';
  stringgrid2.Cells[2,stringgrid2.Row] := '500';
  stringgrid2.Cells[3,stringgrid2.Row] := '1';
end;

procedure TCT.MenuItem30Click(Sender: TObject);
var i : byte;
begin
 case  pagecontrol2.ActivePageIndex of
 0 : for i := 0 to checklistbox2.items.Count - 1 do
     if (pos('fut',lowercase(checklistbox2.items[i])) > 0) then checklistbox2.Checked[i] :=true;
 1 : for i := 0 to checklistbox3.items.Count - 1 do
     if (pos('fut',lowercase(checklistbox3.items[i])) > 0) then
     checklistbox3.Checked[i] := true;
 end;


end;

procedure TCT.MenuItem31Click(Sender: TObject);
var i : byte;
begin
  case pagecontrol1.ActivePageIndex of
  3 :  for i := 0 to checklistbox7.Count-1 do checklistbox7.Checked[i] := true;
  4 :  for i := 0 to checklistbox10.Count-1 do checklistbox10.Checked[i] := true;
  end;
end;

procedure TCT.MenuItem32Click(Sender: TObject);
var i : byte;
begin
  case pagecontrol1.ActivePageIndex of
  3 :  for i := 0 to checklistbox7.Count-1 do checklistbox7.Checked[i] := false;
  4 :  for i := 0 to checklistbox10.Count-1 do checklistbox10.Checked[i] := false;
  end;

end;

procedure TCT.MenuItem33Click(Sender: TObject);
var i : byte;
begin
  case pagecontrol1.ActivePageIndex of
  3 :  for i := 0 to checklistbox7.Count-1 do checklistbox7.Checked[i] := not(checklistbox7.Checked[i]);
  4 :  for i := 0 to checklistbox10.Count-1 do checklistbox10.Checked[i] := not(checklistbox10.Checked[i]);
  end;

end;

procedure TCT.MenuItem34Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    checklistbox4.Checked[i] := true;
end;

procedure TCT.MenuItem35Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    checklistbox4.Checked[i] := false;

end;

procedure TCT.MenuItem36Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    checklistbox4.Checked[i] := not(checklistbox4.Checked[i]);

end;

procedure TCT.MenuItem37Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('sg',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;
end;

procedure TCT.MenuItem38Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('du',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;

end;

procedure TCT.MenuItem39Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('pl',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;

end;

procedure TCT.MenuItem3Click(Sender: TObject);
begin
  stringgrid2.Cells[1,stringgrid2.Row] := '-2500';
  stringgrid2.Cells[2,stringgrid2.Row] := '500';
  stringgrid2.Cells[3,stringgrid2.Row] := '1';
end;

procedure TCT.MenuItem40Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('nom',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;

end;

procedure TCT.MenuItem41Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('acc',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;

end;

procedure TCT.MenuItem42Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('voc',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;

end;

procedure TCT.MenuItem43Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('ins',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;

end;

procedure TCT.MenuItem44Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('dat',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;

end;

procedure TCT.MenuItem45Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('abl',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;

end;

procedure TCT.MenuItem46Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('gen',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;

end;

procedure TCT.MenuItem47Click(Sender: TObject);
var i : byte;
begin
    for i := 0 to checklistbox4.Count - 1 do
    if pos('loc',lowercase(checklistbox4.items[i])) > 0 then
    checklistbox4.Checked[i] := true;
end;

procedure TCT.MenuItem4Click(Sender: TObject);
begin
  stringgrid2.Cells[1,stringgrid2.Row] := '500';
  stringgrid2.Cells[2,stringgrid2.Row] := '2025';
  stringgrid2.Cells[3,stringgrid2.Row] := '1';
end;

procedure TCT.MenuItem5Click(Sender: TObject);
begin
  stringgrid2.Cells[1,stringgrid2.Row] := '2500';
  stringgrid2.Cells[2,stringgrid2.Row] := '2500';
  stringgrid2.Cells[3,stringgrid2.Row] := '1';
end;

procedure TCT.MenuItem6Click(Sender: TObject);
begin
  checklistbox1.CheckAll(cbchecked);
  checklistbox1ClickCheck(Sender);
end;

procedure TCT.MenuItem8Click(Sender: TObject);
Var i : word;
begin
  for i := 1 to stringgrid2.RowCount - 1 do
  stringgrid2.Cells[3,i] := '1';
end;

procedure TCT.MenuItem9Click(Sender: TObject);
Var i : word;
begin
  for i := 1 to stringgrid2.RowCount - 1 do
  stringgrid2.Cells[3,i] := '0';

end;

procedure TCT.Save1Click(Sender: TObject);
begin
  stringgrid3.CopyToClipboard(false);
end;

procedure TCT.Separator2Click(Sender: TObject);
begin
  stringgrid2.RowCount:=
  stringgrid2.RowCount + 1;
end;

procedure TCT.MenuItem7Click(Sender: TObject);
begin
  if stringgrid2.Row > 1 then
  stringgrid2.DeleteRow(stringgrid2.Row);
end;

procedure TCT.PageControl1Change(Sender: TObject);
begin

end;

procedure TCT.StringGrid2AfterSelection(Sender: TObject; aCol, aRow: Integer);
begin
{  if acol = 1 then
  epoh[arow].D1:=strtoint(stringgrid2.Cells[1,arow]);
  if acol = 2 then
  epoh[arow].D2:=strtoint(stringgrid2.Cells[2,arow]);
}
end;

procedure TCT.StringGrid2CheckboxToggled(Sender: TObject; aCol, aRow: Integer;
  aState: TCheckboxState);
begin
  if astate = cbchecked then epoh[aRow].Dc:=true else epoh[arow].Dc := false;

end;

procedure TCT.StringGrid2Click(Sender: TObject);
begin

end;
procedure TCT.BGraph;
var i,j,max : dword;
begin  j := 0;max := 0;
  tr := ttr.Create(self);
  tr.Show;
  for i := 0 to length(AA) - 1 do
  if aa[i].en then
  begin inc(j);
    tr.ls1.Add(j,aa[i].P,aa[i].Name,j*$333355);
    if max < aa[i].P then max := round(aa[i].P);
  end;
  tr.Chart1.AxisList[0].Range.Max := max;
  tr.Chart1.Title.Text.Text:='Свойства текста: '+ checklistbox1.Items[checklistbox1.ItemIndex];

end;
procedure tct.Getdist;
var i,j,k,l : dword; p,p1 : real;s:string;
begin
    s := '';
    for i := 1 to length(ResAX) do resAx[i].Name:='';

    for i := 0 to length(AAA) do
    if AAA[i,0].en then
    if aaa[0,i].Name <> AA[0].Name then
    begin
       for j := 0 to length(AAA[i]) do
       if AAA[i,j].en then
          p1 := p1 + sqr(abs(aaa[i,j].p - aa[j].P));
       p1 := sqrt(p1);
       if AAA[i,0].Name <> AA[0].Name then
       begin
          Stringgrid3.Cells[0,r] := inttostr(round(AA[0].p));
          Stringgrid3.Cells[1,r] := AA[0].Name;
          Stringgrid3.Cells[2,r] := inttostr(round(AAA[i,0].p));
          Stringgrid3.Cells[3,r] := AAA[i,0].Name;
          str(p1:7:2,s);
          Stringgrid3.Cells[4,r] := s;
          inc(R);
       end;
       p1 := 0;
    end;
end;
Function TCT.GMD(s : string) : integer;
var i : word;
begin
    for i := 1 to stringgrid1.RowCount - 1 do
    if s = stringgrid1.Cells[0,i] then break;
    GMD :=  strtoint(stringgrid1.Cells[3,i]);
end;
procedure tct.prep;
var i,j : word; s : string;
begin
  for i := 4 to stringgrid1.ColCount-1 do
  for j:=1 to stringgrid1.RowCount-1 do
  begin
    s := stringgrid1.Cells[i,j];
    while pos(' ',s) > 0 do delete(s,pos(' ',s),1);
    if s = '' then s :='0';
    if pos('%',s) > 0 then
    delete(s,pos('%',s),1);
    if pos('.',s) > 0 then
    begin
      insert(',',s,pos('.',s));
      delete(s,pos('.',s),1);
    end;
    stringgrid1.Cells[i,j] := s;
  end;

  checklistbox1.Clear; checklistbox9.Clear;
  checklistbox10.Clear;checklistbox2.Clear;
  checklistbox3.Clear;checklistbox4.Clear;
  checklistbox7.Clear;
  for i := 3 to stringgrid1.ColCount - 1 do
  begin
    s := stringgrid1.columns[i].Title.Caption;
    if pos('FF',s) > 0 then
    begin checklistbox2.items.Add(s);
          AQ[1,checklistbox2.Count] := i
    end;
    if pos('IF',s) > 0 then
    begin checklistbox3.items.add(s);
          AQ[2,checklistbox3.Count] := i
    end;
    if i in [167..216] then
    begin checklistbox9.Items.Add(s);
          AQ[6,checklistbox9.Count] := i
    end;
    if i in [39..62] then
    begin checklistbox4.Items.Add(s);
          AQ[3,checklistbox4.Count] := i
    end;
    if (pos('Всего',s) = 1) or
       (pos('Mi',s) = 1)    or
       (pos('To',s) = 1) or
       (pos('Ср',s) = 1) then
       begin checklistbox7.Items.Add(s);
             AQ[4,checklistbox7.Count] := i
       end;
  end;
  for i := 1 to stringgrid1.RowCount - 1 do
  begin
     checklistbox1.Items.Add(stringgrid1.Cells[0,i]);
  end;
  for i := 0 to checklistbox1.Items.Count- 1 do
  begin
     checklistbox1.checked[i] := true;
  end;
  Statusbar2.Panels[1].Text:=inttostr(checklistbox1.Items.Count);
  checklistbox1ClickCheck(nil);
  setlength(epoh,2);

  checklistbox10.Clear;
  for i := 4 to 166 do
  if pos('%',stringgrid1.columns[i].Title.Caption) > 0 then
  begin  checklistbox10.Items.Add(stringgrid1.columns[i].Title.Caption);
         AQ[7,checklistbox10.Count] := i
  end;

end;

end.

