unit lgg;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Grids, StdCtrls, Buttons;

type

  { Tliga }

  Tliga = class(TForm)
    ComboBox1: TComboBox;
    Edit1: TEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    StatusBar3: TStatusBar;
    StatusBar4: TStatusBar;
    StatusBar5: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseEnter(Sender: TObject);
    procedure SpeedButton1MouseLeave(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton2MouseEnter(Sender: TObject);
    procedure SpeedButton2MouseLeave(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton3MouseEnter(Sender: TObject);
    procedure SpeedButton3MouseLeave(Sender: TObject);
  private

  public

  end;

var
  liga: Tliga;

implementation
uses poisk,shellapi;
{$R *.lfm}

{ Tliga }

procedure Tliga.FormCreate(Sender: TObject);
var i : word;
begin
  stringgrid1.LoadFromCSVFile('sys\xlsdata\liga\2.csv',#9,TRUE);
  stringgrid2.LoadFromCSVFile('sys\xlsdata\liga\3.csv',#9,TRUE);
  stringgrid3.LoadFromCSVFile('sys\xlsdata\liga\4.csv',#9,TRUE);
  stringgrid4.LoadFromCSVFile('sys\xlsdata\liga\5.csv',#9,TRUE);
  stringgrid1.Columns[1].Title.Font := stringgrid1.Columns[0].Title.Font;
  stringgrid1.Columns[2].Title.Font := stringgrid1.Columns[0].Title.Font;
  stringgrid1.Columns[3].Title.Font := stringgrid1.Columns[0].Title.Font;
  stringgrid1.Columns[4].Title.Font := stringgrid1.Columns[0].Title.Font;
  stringgrid1.Columns[1].Title.color := stringgrid1.Columns[0].Title.color;
  stringgrid1.Columns[2].Title.color := stringgrid1.Columns[0].Title.color;
  stringgrid1.Columns[3].Title.color := stringgrid1.Columns[0].Title.color;
  stringgrid1.Columns[4].Title.color := stringgrid1.Columns[0].Title.color;
  stringgrid2.Options:= stringgrid1.Options;
  stringgrid3.Options:= stringgrid1.Options;
  stringgrid4.Options:= stringgrid1.Options;



   for i := 5 to stringgrid1.Columns.Count - 1 do
   if i mod 2 = 1 then
   begin
      stringgrid1.Columns[i].Width:=150;
      stringgrid1.Columns[i].Title.Caption:='Text Name';
      stringgrid1.Columns[i].Title.Alignment:=stringgrid1.Columns[0].Title.Alignment;
      stringgrid1.Columns[i].Alignment:=stringgrid1.Columns[0].Alignment;
      stringgrid1.Columns[i].Title.Font := stringgrid1.Columns[0].Title.Font;
      stringgrid1.Columns[i].Title.color := stringgrid1.Columns[0].Title.color;
   end
   else
   begin
     stringgrid1.Columns[i].Width:=75;
     stringgrid1.Columns[i].Title.Caption:='Total';
     stringgrid1.Columns[i].Title.Alignment:=stringgrid1.Columns[2].Title.Alignment;
     stringgrid1.Columns[i].Alignment:=stringgrid1.Columns[2].Alignment;
     stringgrid1.Columns[i].Title.Font := stringgrid1.Columns[0].Title.Font;
     stringgrid1.Columns[i].Title.color := stringgrid1.Columns[0].Title.color;
   end;
   for i := 0 to stringgrid1.Columns.Count - 1 do
   begin
   if i < stringgrid2.Columns.Count then
   begin;
     stringgrid2.Columns[i].Title.Font := stringgrid1.Columns[0].Title.Font;
     stringgrid2.Columns[i].Title.color := stringgrid1.Columns[0].Title.color;
     stringgrid2.Columns[i].Title.Alignment := stringgrid1.Columns[i].Title.alignment;
     stringgrid2.Columns[i].Alignment := stringgrid1.Columns[i].Alignment;
     stringgrid2.Columns[i].Width:=stringgrid1.Columns[i].Width;
     stringgrid2.Columns[i].Title.Caption:=stringgrid1.Columns[i].Title.Caption;
   end;
   if i < stringgrid3.Columns.Count then
   begin
     stringgrid3.Columns[i].Title.Font := stringgrid1.Columns[0].Title.Font;
     stringgrid3.Columns[i].Title.color := stringgrid1.Columns[0].Title.color;
     stringgrid3.Columns[i].Title.Alignment := stringgrid1.Columns[i].Title.alignment;
     stringgrid3.Columns[i].Alignment := stringgrid1.Columns[i].Alignment;
     stringgrid3.Columns[i].Width:=stringgrid1.Columns[i].Width;
     stringgrid3.Columns[i].Title.Caption:=stringgrid1.Columns[i].Title.Caption;
   end;
   if i < stringgrid4.Columns.Count then
   begin
     stringgrid4.Columns[i].Title.Caption:=stringgrid1.Columns[i].Title.Caption;
     stringgrid4.Columns[i].Title.Font := stringgrid1.Columns[0].Title.Font;
     stringgrid4.Columns[i].Title.color := stringgrid1.Columns[0].Title.color;
     stringgrid4.Columns[i].Title.Alignment := stringgrid1.Columns[i].Title.alignment;
     stringgrid4.Columns[i].Alignment := stringgrid1.Columns[i].Alignment;
     stringgrid4.Columns[i].Width:=stringgrid1.Columns[i].Width
   end;
   if i < stringgrid5.Columns.Count then
   begin
     stringgrid5.Columns[i].Title.Font := stringgrid1.Columns[0].Title.Font;
     stringgrid5.Columns[i].Title.color := stringgrid1.Columns[0].Title.color;
     stringgrid5.Columns[i].Title.Alignment := stringgrid1.Columns[i].Title.alignment;
     stringgrid5.Columns[i].Alignment := stringgrid1.Columns[i].Alignment;
     stringgrid5.Columns[i].Title.Caption:=stringgrid1.Columns[i].Title.Caption;
     stringgrid5.Columns[i].Width:=stringgrid1.Columns[i].Width;
   end;

   end;
   statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount - 1);
   statusbar2.Panels[1].Text:=inttostr(stringgrid2.RowCount - 1);
   statusbar3.Panels[1].Text:=inttostr(stringgrid3.RowCount - 1);
   statusbar4.Panels[1].Text:=inttostr(stringgrid4.RowCount - 1);
   stringgrid1.SelectedColor:=speedbutton1.Color;
   stringgrid2.SelectedColor:=speedbutton1.Color;
   stringgrid3.SelectedColor:=speedbutton1.Color;
   stringgrid4.SelectedColor:=speedbutton1.Color;
   stringgrid5.SelectedColor:=speedbutton1.Color;
end;

procedure Tliga.Edit1Change(Sender: TObject);
begin
  edit1.Text:=form1.convertx(edit1.Text);
  edit1.SelStart:=length(edit1.text);
  edit1.SetFocus;
end;

procedure Tliga.SpeedButton1Click(Sender: TObject);
var i,j : word;
    d1,d2,d3,d4 : boolean;
begin
  j := 1;
  d1 := true; d2 := d1; d3 := d1;d4 := d1;
  stringgrid5.RowCount:=1;
  case combobox1.ItemIndex of
        0 : d1 := false;
        1 : d2 := false;
        2 : d3 := false;
        3 : d4 := false;
    end;
  for i := 1 to stringgrid1.RowCount - 1 do
  begin
     if (pos(edit1.Text,stringgrid1.Cells[0,i]) = 1) or
        (pos(edit1.Text,stringgrid1.Cells[1,i]) = 1) then d1 := true;

     if (pos(edit1.Text,stringgrid1.Cells[0,i]) > 0) or
        (pos(edit1.Text,stringgrid1.Cells[1,i]) > 0) then d2 := true;

     if (pos(edit1.Text+' ',stringgrid1.Cells[0,i]+' ') > 0) or
        (pos(edit1.Text+' ',stringgrid1.Cells[1,i]+' ') > 0) then d3 := true;

     if (edit1.Text = stringgrid1.Cells[0,i]) or
        (edit1.Text = stringgrid1.Cells[1,i]) then d4 := true;
     if d1 and d2 and d3 and d4 then
     begin
       stringgrid5.RowCount:= stringgrid5.RowCount + 1;
       stringgrid5.Rows[j] := stringgrid1.Rows[i];
       inc(j);
       case combobox1.ItemIndex of
             0 : d1 := false;
             1 : d2 := false;
             2 : d3 := false;
             3 : d4 := false;
         end;

     end;
  end;
  d1 := true; d2 := d1; d3 := d1;d4 := d1;
  case combobox1.ItemIndex of
        0 : d1 := false;
        1 : d2 := false;
        2 : d3 := false;
        3 : d4 := false;
    end;
  for i := 1 to stringgrid2.RowCount - 1 do
  begin
     if (pos(edit1.Text,stringgrid2.Cells[0,i]) = 1) or
        (pos(edit1.Text,stringgrid2.Cells[1,i]) = 1) then d1 := true;

     if (pos(edit1.Text,stringgrid2.Cells[0,i]) > 0) or
        (pos(edit1.Text,stringgrid2.Cells[1,i]) > 0) then d2 := true;

     if (pos(edit1.Text+' ',stringgrid2.Cells[0,i]+' ') > 0) or
        (pos(edit1.Text+' ',stringgrid2.Cells[1,i]+' ') > 0) then d3 := true;

     if (edit1.Text = stringgrid2.Cells[0,i]) or
        (edit1.Text = stringgrid2.Cells[1,i]) then d4 := true;
     if d1 and d2 and d3 and d4 then
     begin
       stringgrid5.RowCount:= stringgrid5.RowCount + 1;
       stringgrid5.Rows[j] := stringgrid2.Rows[i];
       inc(j);
       case combobox1.ItemIndex of
             0 : d1 := false;
             1 : d2 := false;
             2 : d3 := false;
             3 : d4 := false;
         end;

     end;
  end;
  d1 := true; d2 := d1; d3 := d1;d4 := d1;
  case combobox1.ItemIndex of
        0 : d1 := false;
        1 : d2 := false;
        2 : d3 := false;
        3 : d4 := false;
    end;
  for i := 1 to stringgrid3.RowCount - 1 do
  begin
     if (pos(edit1.Text,stringgrid3.Cells[0,i]) = 1) or
        (pos(edit1.Text,stringgrid3.Cells[1,i]) = 1) then d1 := true;

     if (pos(edit1.Text,stringgrid3.Cells[0,i]) > 0) or
        (pos(edit1.Text,stringgrid3.Cells[1,i]) > 0) then d2 := true;

     if (pos(edit1.Text+' ',stringgrid3.Cells[0,i]+' ') > 0) or
        (pos(edit1.Text+' ',stringgrid3.Cells[1,i]+' ') > 0) then d3 := true;

     if (edit1.Text = stringgrid3.Cells[0,i]) or
        (edit1.Text = stringgrid3.Cells[1,i]) then d4 := true;
     if d1 and d2 and d3 and d4 then
     begin
       stringgrid5.RowCount:= stringgrid5.RowCount + 1;
       stringgrid5.Rows[j] := stringgrid3.Rows[i];
       inc(j);
       case combobox1.ItemIndex of
             0 : d1 := false;
             1 : d2 := false;
             2 : d3 := false;
             3 : d4 := false;
         end;

     end;
  end;
  d1 := true; d2 := d1; d3 := d1;d4 := d1;
  case combobox1.ItemIndex of
        0 : d1 := false;
        1 : d2 := false;
        2 : d3 := false;
        3 : d4 := false;
    end;
  for i := 1 to stringgrid4.RowCount - 1 do
  begin
     if (pos(edit1.Text,stringgrid4.Cells[0,i]) = 1) or
        (pos(edit1.Text,stringgrid4.Cells[1,i]) = 1) then d1 := true;

     if (pos(edit1.Text,stringgrid4.Cells[0,i]) > 0) or
        (pos(edit1.Text,stringgrid4.Cells[1,i]) > 0) then d2 := true;

     if (pos(edit1.Text+' ',stringgrid4.Cells[0,i]+' ') > 0) or
        (pos(edit1.Text+' ',stringgrid4.Cells[1,i]+' ') > 0) then d3 := true;

     if (edit1.Text = stringgrid4.Cells[0,i]) or
        (edit1.Text = stringgrid4.Cells[1,i]) then d4 := true;
     if d1 and d2 and d3 and d4 then
     begin
       stringgrid5.RowCount:= stringgrid5.RowCount + 1;
       stringgrid5.Rows[j] := stringgrid4.Rows[i];
       inc(j);
       case combobox1.ItemIndex of
             0 : d1 := false;
             1 : d2 := false;
             2 : d3 := false;
             3 : d4 := false;
         end;

     end;
  end;
  pagecontrol1.ActivePage := tabsheet5;
  statusbar5.Panels[1].Text := inttostr(j - 1);
end;

procedure Tliga.SpeedButton1MouseEnter(Sender: TObject);
begin
  speedbutton1.Transparent:=false;
end;

procedure Tliga.SpeedButton1MouseLeave(Sender: TObject);
begin
  speedbutton1.Transparent:=true;
end;

procedure Tliga.SpeedButton2Click(Sender: TObject);
var i,j : word;
    f : text;
begin
    if savedialog1.Execute then
    begin
      assignfile(f,savedialog1.FileName);rewrite(f);
      for i := 0 to stringgrid1.Columns.Count - 1 do
      write(f,stringgrid1.Columns[i].Title.Caption,#9);
      writeln(f,'');
      writeln(f,tabsheet1.Caption);
      for i := 1 to stringgrid1.RowCount - 1 do
      begin
         for j := 0 to stringgrid1.Columns.Count - 1 do
         write(f,stringgrid1.cells[j,i],#9);
         writeln(f,'');
      end;
      writeln(f,'');
      writeln(f,tabsheet2.Caption);

      for i := 1 to stringgrid2.RowCount - 1 do
      begin
         for j := 0 to stringgrid2.Columns.Count - 1 do
         write(f,stringgrid2.cells[j,i],#9);
         writeln(f,'');
      end;
      writeln(f,'');
      writeln(f,tabsheet3.Caption);
      for i := 1 to stringgrid3.RowCount - 1 do
      begin
         for j := 0 to stringgrid3.Columns.Count - 1 do
         write(f,stringgrid3.cells[j,i],#9);
         writeln(f,'');
      end;

      writeln(f,'');
      writeln(f,tabsheet4.Caption);
      for i := 1 to stringgrid4.RowCount - 1 do
      begin
         for j := 0 to stringgrid4.Columns.Count - 1 do
         write(f,stringgrid4.cells[j,i],#9);
         writeln(f,'');
      end;
      closefile(f);
      if form1.checkbox7.checked then
      shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);

    end;
end;

procedure Tliga.SpeedButton2MouseEnter(Sender: TObject);
begin
  speedbutton2.Transparent:=false;
end;

procedure Tliga.SpeedButton2MouseLeave(Sender: TObject);
begin
  speedbutton2.Transparent:=true;
end;

procedure Tliga.SpeedButton3Click(Sender: TObject);
begin
  if savedialog1.Execute then
  begin
    stringgrid5.SaveToCSVFile(savedialog1.FileName,#9,true);
    if form1.CheckBox7.Checked then
    shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
  end;
end;

procedure Tliga.SpeedButton3MouseEnter(Sender: TObject);
begin
  speedbutton3.Transparent:=false;
end;

procedure Tliga.SpeedButton3MouseLeave(Sender: TObject);
begin
  speedbutton3.Transparent:=true;
end;

end.

