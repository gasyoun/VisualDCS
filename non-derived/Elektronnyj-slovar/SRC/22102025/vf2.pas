unit vf2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Grids, ExtCtrls, Buttons,shellapi;

type

  { TVForms }

  TVForms = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    ListBox1: TListBox;
    Panel8: TPanel;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    StatusBar5: TStatusBar;
    StatusBar6: TStatusBar;
    StringGrid5: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseEnter(Sender: TObject);
    procedure SpeedButton1MouseLeave(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid2Click(Sender: TObject);
  private

  public

  end;

var
  VForms: TVForms;
  ids : string;
implementation
uses poisk,wrf,tx1;
{$R *.lfm}

{ TVForms }

procedure TVForms.StringGrid1Click(Sender: TObject);
begin
{
  if stringgrid1.RowCount > 1 then
  begin
  if stringgrid1.Cells[6,stringgrid1.Row] = '' then
     stringgrid1.Cells[6,stringgrid1.Row] := '0';
     if stringgrid1.Cells[5,stringgrid1.Row] = '' then
     stringgrid1.Cells[5,stringgrid1.Row] := '0';

  form1.GetExam(stringgrid1.Cells[6,stringgrid1.Row]+' ', strtoint(stringgrid1.Cells[5,stringgrid1.Row]),0,0,0,0);
  wr.Visible:=VerbalEx;
  wr.Caption:=
  'Word Reference for: "'+stringgrid1.Cells[0,stringgrid1.Row]+'". Total Examples: '+inttostr(wr.StringGrid1.RowCount - 1);
  end;
}
end;

procedure TVForms.Button1Click(Sender: TObject);
var f : system.Text;
    fc,i,j : longint;
    s1,s2,s3,s : string;

begin
{
  if savedialog1.Execute then
  begin
     assignfile(f,savedialog1.FileName); rewrite(f);
     writeln(f,caption);
     writeln(f,'Verbal forms finite (total found: ',statusbar1.Panels[1].Text,')');
     s := '';
     for i := 0 to stringgrid1.RowCount - 1 do
     begin
        for j := 0 to stringgrid1.ColCount - 1 do
        if stringgrid1.Columns[j].Visible then s := s + stringgrid1.Cells[j,i] + #9;
        writeln(f,s);
        s := '';
     end;
     writeln(f,'');
     writeln(f,'Verbal forms infinite (total found: ',statusbar2.Panels[1].Text,')');
     s := '';
     for i := 0 to stringgrid2.RowCount - 1 do
     begin
        for j := 0 to stringgrid2.ColCount - 1 do
        if stringgrid2.Columns[j].Visible then s := s + stringgrid2.Cells[j,i] + #9;
        writeln(f,s);
        s := '';
     end;
     closefile(f);
     if form1.CheckBox7.Checked then
     shellexecute(0,'open',pchar(savedialog1.FileName),'',nil,1)
  end;
}
end;

procedure TVForms.Button2Click(Sender: TObject);
begin
  if ids[length(ids)] <> ' ' then ids := ids + ' ';
  form1.GetExam(ids,0,0,combobox1.ItemIndex,combobox2.ItemIndex,combobox3.ItemIndex);
  wr.Show;
end;

procedure TVForms.ComboBox4Change(Sender: TObject);
begin
  if (combobox4.Items.Count > 0) and
     (combobox4.Items.Count = listbox1.Items.Count) then
  if combobox4.ItemIndex > - 1
  then
  ids := listbox1.Items[combobox4.ItemIndex];
end;

procedure TVForms.FormCreate(Sender: TObject);
var i : byte;
begin
{  combobox4.Clear;
  for i := 0 to 42 do
  combobox4.items.add(wr.GetTense(inttostr(i)));
  combobox4.ItemIndex := 0;
}
end;

procedure TVForms.Panel2Click(Sender: TObject);
begin

end;

procedure TVForms.SpeedButton1Click(Sender: TObject);
begin
  button2click(sender);
end;

procedure TVForms.SpeedButton1MouseEnter(Sender: TObject);
begin
  speedbutton1.Transparent:=false;
end;

procedure TVForms.SpeedButton1MouseLeave(Sender: TObject);
begin
  Speedbutton1.Transparent:=true;
end;

procedure TVForms.StringGrid2Click(Sender: TObject);
begin
{  if stringgrid2.RowCount > 1 then
  begin
  if stringgrid2.Cells[4,stringgrid2.Row] = '' then
     stringgrid2.Cells[4,stringgrid2.Row] := '0';
   if stringgrid2.Cells[3,stringgrid2.Row] = '' then
     stringgrid2.Cells[3,stringgrid2.Row] := '0';

  ;
  form1.GetExam(stringgrid2.Cells[4,stringgrid2.Row]+' ',0, strtoint(stringgrid2.Cells[3,stringgrid2.Row]),0,0,0);
  wr.Visible:=VerbalEx;
  wr.Caption:=
  'Word Reference for: "'+stringgrid2.Cells[0,stringgrid2.Row]+'". Total Examples: '+inttostr(wr.StringGrid1.RowCount - 1);


  end;
  }
end;

end.

