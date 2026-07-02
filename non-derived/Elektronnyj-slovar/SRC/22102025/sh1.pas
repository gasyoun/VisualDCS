unit sh1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Grids, ComCtrls;

type

  { Tshis }

  Tshis = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);

  private

  public

  end;

var
  shis: Tshis;
  sclk: boolean = true;
implementation
uses poisk,shellapi;
{$R *.lfm}
var s : string = '';
{ Tshis }

procedure Tshis.Button2Click(Sender: TObject);
begin
  Stringgrid1.RowCount:=1;
  StringGrid1Selection(sender,0,0);
end;

procedure Tshis.Button1Click(Sender: TObject);
begin

  IF stringgrid1.Row >  0 then
  begin
//    if stringgrid1.Cells[4,stringgrid1.Row] = '0' then
//    form1.ComboBox3.ItemIndex:=0 else form1.ComboBox3.ItemIndex:=1;
//    form1.ComboBox3Change(sender);
    form1.Edit2.Text:= stringgrid1.Cells[1,stringgrid1.Row];
    if form1.CheckBox1.Checked = false then
    form1.Button1Click(sender);
    form1.StringGrid1.Col:=1;
    hisid := stringgrid1.Row;
    form1.StringGrid1Click(sender);
  end;
  close;
end;

procedure Tshis.Button3Click(Sender: TObject);
   var i,j : dword;
begin
   for i := stringgrid1.SelectedRangeCount downto 1 do
   begin
     for j := stringgrid1.selectedrange[i].bottom downto stringgrid1.selectedrange[i].top do
     if j > 0 then
     begin
       sclk := false;
       stringgrid1.DeleteRow(j);
     end;
   end;
   StringGrid1Selection(sender,0,0);
end;

procedure Tshis.Button4Click(Sender: TObject);
begin
  s := '';
  if savedialog1.Execute then s := savedialog1.FileName;
  if s <> '' then
  begin
    stringgrid1.SaveToCSVFile(s,#9);

    StringGrid1Selection(sender,0,0);
    if form1.CheckBox7.Checked then
      shellexecute(0,'open',pchar(s),'',nil,1);
  end;
end;

procedure Tshis.Button5Click(Sender: TObject);
begin
  savedialog1.FileName:=s;
  if savedialog1.Execute then
  begin
    stringgrid1.SaveToCSVFile(savedialog1.FileName,#9);
    s := savedialog1.FileName;
    caption := 'Translation history ('+Extractfilename(s)+')';
  end;
end;


procedure Tshis.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  stringgrid1.SaveToCSVFile(cdir+'\sys\history.sdm',#9)

end;

procedure Tshis.FormCreate(Sender: TObject);
begin
  if fileexists(cdir+'\sys\history.sdm') then
     stringgrid1.LoadFromCSVFile(cdir+'\sys\history.sdm',#9);
  stringgrid1.Columns[2].Title.Caption:='Ранг';
  stringgrid1.Columns[3].Title.Caption:='Порядок';
end;

procedure Tshis.ListBox2Click(Sender: TObject);
begin

end;

procedure Tshis.StringGrid1Click(Sender: TObject);
var s : string;
begin
  s := '';
  if shis.Visible then
  IF stringgrid1.Row >  0 then
  begin s := stringgrid1.Cells[1,stringgrid1.Row];
    if (stringgrid1.Cells[0,stringgrid1.Row] = '') and
        (form1.Combobox3.ItemIndex = 0) then
        begin
          form1.Edit2.TextHint:='';
          form1.SBClearClick(sender);
          form1.Edit2.Text:= s;
          form1.Button1Click(sender);
        end
    else
    begin
    if (stringgrid1.Cells[0,stringgrid1.Row] <> '') and
        (form1.Combobox3.ItemIndex = 1) then
        begin
          s := stringgrid1.Cells[1,stringgrid1.Row];
          form1.SBClearClick(sender);
          form1.Edit2.Text:= s;
          form1.Button1Click(sender);
        end
    else
    if (stringgrid1.Cells[0,stringgrid1.Row] <> '') and
       (form1.Combobox3.ItemIndex = 0) then
        begin
          s := stringgrid1.Cells[1,stringgrid1.Row];
          form1.Edit2.Text:= s;
          form1.Button1Click(sender);
        end
    else
    if (stringgrid1.Cells[0,stringgrid1.Row] = '') and
       (form1.Combobox3.ItemIndex = 1) then
        begin
          s := stringgrid1.Cells[1,stringgrid1.Row];
          form1.Edit2.Text:= s;
          form1.Button1Click(sender);
        end;
    end;
    hisid := stringgrid1.Row;
  end;


end;

procedure Tshis.StringGrid1DblClick(Sender: TObject);
begin
  button1click(sender);
end;

procedure Tshis.StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
var t : trect;
    i,j,k : dword;
begin
    statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount - 1);
    j := 0;
    if stringgrid1.RowCount > 1 then
    begin
       for i := 1 to stringgrid1.RowCount - 1 do
       inc(j,strtoint(stringgrid1.Cells[2,i]));
       statusbar1.Panels[3].Text:=inttostr(j);
       k := 0;
{
       for i := 1 to stringgrid1.SelectedRangeCount - 1 do
       begin
         t := stringgrid1.SelectedRange[i];
         for j := t.Top to t.Bottom do inc(k);
       end;
}
//         statusbar1.Panels[5].Text:=inttostr(k+1);
    end
    else
    begin
      statusbar1.Panels[3].Text:='0';
//      statusbar1.Panels[5].Text:='1';
    end;
end;



end.

