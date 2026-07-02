unit tema1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, EditBtn, Buttons, CheckLst, Grids, Menus, Types;

type

  { Ttema }

  Ttema = class(TForm)
    Button10: TButton;
    Button7: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckListBox1: TCheckListBox;
    ComboBox1: TComboBox;
    ComboBox3: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Separator1: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem7: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel3: TPanel;
    PopupMenu1: TPopupMenu;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    SpeedButton8: TSpeedButton;
    StringGrid1: TStringGrid;
    procedure Button10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox3DblClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure StringGrid1EditButtonClick(Sender: TObject);
    procedure StringGrid1EditingDone(Sender: TObject);


  private

  public
    procedure bts;
    function list1(ch : boolean; s : string) : boolean;
    function list2(ch : boolean; s : string) : boolean;
    function list3(ch : boolean; s : string) : boolean;
    function findword(wd,s : string; ww : boolean) : boolean;
    procedure fillt;
    procedure fillreq;
  end;

var
  tema: Ttema;

implementation
uses poisk,reult1,depo1, depo2,clipbrd;
{$R *.lfm}

{ Ttema }
procedure Ttema.bts;
var i : word;
    s : string;
    z : boolean;
    x  : longint;
    q  : byte;
    j : longint;
    p  : longint;
begin  x := 0;
end;




procedure Ttema.Button1Click(Sender: TObject);
begin
  if listbox1.ItemIndex >= 0 then listbox1.DeleteSelected
end;

procedure Ttema.Button10Click(Sender: TObject);
begin
  opendialog1.InitialDir:=cdir+'\Requests\Examples';
  if opendialog1.Execute then
  begin
     stringgrid1.LoadFromCSVFile(opendialog1.FileName,#9,true,0,false);
  end;
end;

procedure Ttema.Button2Click(Sender: TObject);
begin
  listbox1.Clear;
end;

procedure Ttema.Button3Click(Sender: TObject);
begin
  if listbox2.ItemIndex >= 0 then
  listbox2.DeleteSelected;
end;

procedure Ttema.Button4Click(Sender: TObject);
begin
listbox2.Clear;
end;

procedure Ttema.Button5Click(Sender: TObject);
begin
  if listbox3.ItemIndex >=0 then
  listbox3.DeleteSelected;
end;

procedure Ttema.Button6Click(Sender: TObject);
begin
  Listbox3.Clear;
end;

procedure Ttema.Button7Click(Sender: TObject);
begin
  opendialog1.InitialDir:=cdir+'\Requests';
  if opendialog1.Execute then
  begin
     stringgrid1.LoadFromCSVFile(opendialog1.FileName,#9);
  end;

end;

procedure Ttema.Button8Click(Sender: TObject);
begin

end;

procedure Ttema.Button9Click(Sender: TObject);
begin
savedialog1.InitialDir:=cdir+'\Requests';
if savedialog1.Execute then
   stringgrid1.SaveToCSVFile(savedialog1.FileName,#9);
end;

procedure Ttema.CheckBox1Change(Sender: TObject);
begin
  checklistbox1.Checked[1] := checkbox1.Checked;
  if checkbox1.Checked = false then stringgrid1.Columns[0].Font.Color:=tema.color
  else
  stringgrid1.Columns[0].Font.Color:=tema.Font.color;
end;

procedure Ttema.CheckBox2Change(Sender: TObject);
begin
checklistbox1.Checked[2] := checkbox2.Checked;
  if checkbox2.Checked = false then stringgrid1.Columns[1].Font.Color:=tema.color
  else
  stringgrid1.Columns[1].Font.Color:=tema.Font.color;

end;

procedure Ttema.CheckBox3Change(Sender: TObject);
begin
checklistbox1.Checked[3] := checkbox3.Checked;
  if checkbox3.Checked = false then stringgrid1.Columns[2].Font.Color:=tema.color
  else
  stringgrid1.Columns[2].Font.Color:=tema.Font.color;

end;

procedure Ttema.CheckBox5Change(Sender: TObject);
begin
   checklistbox1.Checked[0] := checkbox5.Checked;
end;

procedure Ttema.CheckBox6Change(Sender: TObject);
begin
 checklistbox1.Checked[4] := checkbox6.Checked;
end;


procedure Ttema.CheckListBox1Click(Sender: TObject);
begin
   checklistbox1.Checked[checklistbox1.ItemIndex] :=
   not(checklistbox1.Checked[checklistbox1.ItemIndex]);
end;
procedure Ttema.CheckListBox1ClickCheck(Sender: TObject);
begin
  checklistbox1click(sender);

end;

procedure Ttema.ComboBox1Change(Sender: TObject);
begin
  form1.ComboBox3.ItemIndex:=combobox1.ItemIndex;
end;

procedure Ttema.ComboBox2Change(Sender: TObject);
begin
{
  case combobox2.ItemIndex of
        0 : listbox1.Items.Clear;
        1 : listbox1.Items := depo.Astr.Items;
        2 : listbox1.Items := depo.Mth.Items;
        3 : listbox1.Items := depo.phs.Items;
        4 : listbox1.Items := depo.Poet.Items;
        6 : BEGIN
              listbox1.Items := depo.PName.Items;
              CHECKBOX1.Checked:=TRUE;
              CHECKBOX2.Checked:=TRUE;;
        end;
        5 : listbox1.Items := depo.Medic.Items;
  end;
}
end;

procedure Ttema.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  stringgrid1.SaveToCSVFile('sys\rq.tmp',#9);
end;

procedure Ttema.FormCreate(Sender: TObject);
begin
  if fileexists('sys\rq.tmp') then
  begin
     stringgrid1.LoadFromCSVFile('sys\rq.tmp',#9);
     while stringgrid1.Columns.Count < 3 do
     stringgrid1.Columns.Add;
     while stringgrid1.Columns.Count > 3 do
     stringgrid1.Columns.Delete(0);


  end;
end;

procedure Ttema.ListBox1Click(Sender: TObject);
begin

end;

procedure Ttema.ListBox1DblClick(Sender: TObject);
begin
  if listbox1.ItemIndex > - 1 then
     listbox1.DeleteSelected;
end;

procedure Ttema.ListBox2DblClick(Sender: TObject);
begin
  if listbox2.ItemIndex > - 1 then
     listbox2.DeleteSelected;
end;

procedure Ttema.ListBox3DblClick(Sender: TObject);
begin
  if listbox3.ItemIndex > - 1 then
     listbox3.DeleteSelected;

end;

procedure Ttema.MenuItem1Click(Sender: TObject);
begin
  stringgrid1.Clear;
  stringgrid1.RowCount:=2;
end;

procedure Ttema.MenuItem2Click(Sender: TObject);
var i,j : word;
begin
    if stringgrid1.Row > 0 then
    begin
       memo1.Clear;
       i := stringgrid1.Col;
       stringgrid1.Cells[i,stringgrid1.Row] := '';
       for j := 1 to stringgrid1.RowCount-1 do
       if stringgrid1.Cells[i,j] <> '' then
       memo1.Lines.Add(stringgrid1.Cells[i,j]);
       for j := 1 to stringgrid1.RowCount-1 do stringgrid1.Cells[i,j] := '';
       for j := 0 to memo1.Lines.Count - 1 do
       stringgrid1.Cells[i,j+1] := memo1.Lines.Strings[j];
    end;
end;

procedure Ttema.MenuItem4Click(Sender: TObject);
var i : word;
begin
   for i := 1 to stringgrid1.RowCount - 1 do
   stringgrid1.Cells[stringgrid1.Col,i] := '';
end;

procedure Ttema.MenuItem5Click(Sender: TObject);
var i,j  : word;
    s : string;
begin
  s := '';
  i := stringgrid1.Col;
  for j := 1 to stringgrid1.RowCount - 1 do
  if stringgrid1.Cells[i,j] <> '' then
  s := s + stringgrid1.Cells[i,j] + #13+#10;
  Clipboard.AsText:=s;




end;

procedure Ttema.MenuItem7Click(Sender: TObject);
var i,j : word; s : string;
begin  s := clipboard.AsText;
       if s <> '' then
       begin
          i := stringgrid1.Col;
          memo1.Text:=s;
          if memo1.Lines.Count > stringgrid1.RowCount then
          stringgrid1.RowCount:=memo1.Lines.Count + 1;
          for j := 1 to stringgrid1.RowCount - 1 do
          stringgrid1.Cells[i,j] := '';
          for j := 0 to  memo1.Lines.Count - 1  do
          stringgrid1.Cells[i,j+1] := memo1.Lines.Strings[j];
       end;

end;

procedure Ttema.SpeedButton8Click(Sender: TObject);
var i : longint;
    s : string;
    j : longint;
    k : longint;
    d1,d2,d3, d4,c1,c2,c3,c4 : boolean;
    ccc : longint;
    m : longint;
begin
listbox1.Clear;listbox2.Clear;listbox3.Clear;
for i := 1 to stringgrid1.RowCount - 1 do
begin
  if stringgrid1.Cells[2,i] <> '' then listbox1.Items.Add(stringgrid1.Cells[2,i]);
  if stringgrid1.Cells[0,i] <> '' then listbox3.Items.Add(stringgrid1.Cells[0,i]);
  if stringgrid1.Cells[1,i] <> '' then listbox2.Items.Add(stringgrid1.Cells[1,i]);

end;
setlength(ddl,1);
if (listbox1.count <> 0) or
   (listbox2.Count <> 0)  or
   (listbox3.Count <> 0)
   then
begin
setlength(ddl,depo.stringgrid1.RowCount);
ccc := 0;
   resform.CheckListBox1.Clear;
   resform.CheckListBox2.Clear;
//   resform.Memo3.Clear;
if form1.ComboBox3.ItemIndex <> 1 then
begin
   m := depo.stringgrid1.RowCount - 1;
   end
   else
   begin
    m := dp.ListBox1.Count - 1;
   end;


   for i := 1 to m do
   begin
      progressbar1.Position:=round(i/m*100);
      d1:= false; d2:= false; d3 := false;d4 := false;

//      form1.getindexes(i);



if (checklistbox1.Checked[1] = false) or (listbox1.Count = 0 ) then d1 := true;
if (checklistbox1.Checked[2] = false) or (listbox3.Count = 0 )then d2 := true;
if (checklistbox1.Checked[3] = false) or (listbox2.Count = 0 )then d3 := true;

s := '';
     if form1.combobox3.ItemIndex = 1 then
     begin
        for j := Ewlidx[1,i] to Ewlidx[2,i] do
             s := s + ' '+dp.memo1.lines.strings[Edbidx[j]-1];
     end
     else
     for j := wlidx[1,i] to wlidx[2,i] do
          s := s + ' ' +depo.memo1.lines.strings[dbidx[j]-1];
//application.Title:=inttostr(length(s))+' '+ depo.ListBox2.Items[i];

                 if s <> '' then
                 begin
                 if d1 = false then
                    d1 := list1(checklistbox1.Checked[0],s);

                 if d1 and not(d2) then
                    d2 := list2(checklistbox1.Checked[0],s);


                 if d1 and d2 and not(d3) then
                    d3 := list3(checklistbox1.Checked[0],s);

               end;
               if d1 and d2 and d3 then d4 := true
               else d4 := false;

               if d4 then
               if s <> '' then
               begin
                 form1.FillDlist(i);
                 if form1.combobox3.ItemIndex <> 1 then
                 dlist[1].wd:=depo.stringgrid1.Cells[1,i]
                 else
                 dlist[1].wd:=dp.ListBox1.Items[i];
                 dlist[1].ID:=i;
                 ddl[ccc] := dlist;
                 inc(ccc);
               end;
   end;
   if ccc = 0 then
   begin
      ccc := 1;
      for i := 0 to length(dlist)  - 1 do dlist[i].DDesc:='';
      setlength(ddl,ccc);
      ddl[0] := dlist;
   end
   else
   setlength(ddl,ccc);
   progressbar1.Position:=0;
//   setlength(ddl,ccc);
   resform.StatusBar1.Panels[1].Text:=inttostr(resform.checklistbox2.count);
   form1.SpeedButton27Click(sender);

end

end;

procedure Ttema.StringGrid1Click(Sender: TObject);
begin
  if stringgrid1.Col = 0 then stringgrid1.Columns[0].Title.Font.Bold := true else stringgrid1.Columns[0].Title.Font.Bold := false;
  if stringgrid1.Col = 1 then stringgrid1.Columns[1].Title.Font.Bold := true else stringgrid1.Columns[1].Title.Font.Bold := false;
  if stringgrid1.Col = 2 then stringgrid1.Columns[2].Title.Font.Bold := true else stringgrid1.Columns[2].Title.Font.Bold := false;
end;

procedure Ttema.StringGrid1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  if mousepos.X <= stringgrid1.Width div 3 then stringgrid1.Col:=0;
  if (mousepos.X >  stringgrid1.Width div 3) and
     (mousepos.X <  (stringgrid1.Width div 3)*2) then stringgrid1.Col:=1;
  if mousepos.X >= (stringgrid1.Width div 3)*2 then stringgrid1.Col:=2;
  stringgrid1click(sender);

end;

procedure Ttema.StringGrid1EditButtonClick(Sender: TObject);
begin

end;

procedure Ttema.StringGrid1EditingDone(Sender: TObject);
begin
if checkbox4.Checked then
begin
   stringgrid1.Cells[stringgrid1.col,stringgrid1.row] :=
   form1.convertx(stringgrid1.Cells[stringgrid1.col,stringgrid1.row]);
end;

end;



function ttema.findword(wd,s : string; ww : boolean) : boolean;
var d : boolean;
    p : longint;
    z : boolean;
begin
if checklistbox1.Checked[4] = false then
begin
 wd := lowercase(wd);
 s  := lowercase(s);
end;
 p := 0; d := false;
if s <> '' then
begin
    if ww then  z := form1.isword(s,wd) else
    begin
      p := pos(wd,s);
      if p > 0 then z := true
      else z := false;
    end;
    findword :=z;
end
else findword := false;
end;
function Ttema.list1(ch : boolean; s : string) : boolean;
var
    i : longint;
    x : boolean;
begin
    x := false;
   if (listbox1.Count = 0)  then x := false
   else
      if   combobox3.ItemIndex = 0 then
      begin
        for i := 0 to listbox1.Items.Count - 1 do
        if findword(listbox1.Items[i],s,ch) then
        begin
             x := true;
             break;
        end;
      end
      else
      begin
        for i := 0 to listbox1.count - 1 do
          if findword(listbox1.Items[i],s,ch) = false then
          begin
             x := false;
             break;
        end
      end;
    list1 := not(x);;
end;
function Ttema.list2(ch : boolean; s : string) : boolean;
var z : boolean;
    i : longint;
begin
   z  := true;
   if (listbox3.Items.Count = 0) then z := true
   else
       for i := 0 to listbox3.Items.Count - 1 do
       if findword(listbox3.Items[i],s,ch) = false
       then
         begin
           z := false;
           break;
         end;

   list2 := z;
end;
function Ttema.list3(ch : boolean; s : string) : boolean;
var z : boolean;
    i : longint;
begin
z := false;
   if (listbox2.Count = 0) then z := true
   else
     for i := 0 to listbox2.Items.Count - 1 do
        if findword(listbox2.Items[i],s,ch) then
        begin
          z := true;
          break;
       end;
    list3 := z;
end;
procedure ttema.fillt;
begin
    stringgrid1.cells[0,0]:=listbox1.Items.CommaText;
    stringgrid1.cells[0,1]:=listbox2.Items.CommaText;
    stringgrid1.cells[0,2]:=listbox3.Items.CommaText;
    stringgrid1.Cells[0,3] := booltostr(checklistbox1.Checked[0]);
    stringgrid1.Cells[0,4] := booltostr(checklistbox1.Checked[1]);
    stringgrid1.Cells[0,5] := booltostr(checklistbox1.Checked[2]);
    stringgrid1.Cells[0,6] := booltostr(checklistbox1.Checked[3]);
    stringgrid1.Cells[0,7] := booltostr(checklistbox1.Checked[4]);
    stringgrid1.Cells[0,8] := inttostr(combobox1.ItemIndex) ;
    stringgrid1.Cells[0,9] := inttostr(combobox3.ItemIndex) ;

end;

procedure ttema.fillreq;
begin
  listbox1.Items.CommaText:=stringgrid1.cells[0,0];
  listbox2.Items.CommaText:=stringgrid1.cells[0,1];
  listbox3.Items.CommaText:=stringgrid1.cells[0,2];
  checklistbox1.Checked[0] := strtobool(stringgrid1.Cells[0,3]);

  checklistbox1.Checked[1] := strtobool(stringgrid1.Cells[0,4]);
  checklistbox1.Checked[2] := strtobool(stringgrid1.Cells[0,5]);
  checklistbox1.Checked[3] := strtobool(stringgrid1.Cells[0,6]);
  checklistbox1.Checked[4] := strtobool(stringgrid1.Cells[0,7]);
  combobox1.ItemIndex:=strtoint(stringgrid1.Cells[0,8]);
  combobox3.ItemIndex:=strtoint(stringgrid1.Cells[0,9]);

end;

end.

