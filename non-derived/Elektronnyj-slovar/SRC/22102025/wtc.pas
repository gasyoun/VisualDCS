unit wTC;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls;

type

  { TWT1 }

  TWT1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    SaveDialog1: TSaveDialog;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private

  public
    procedure getwt(i : dword);
  end;

var
  WT1: TWT1;

implementation
uses poisk,tx1,shellapi,tcompare,lpak, wrf;
{$R *.lfm}

procedure TWT1.Button1Click(Sender: TObject);
var F : text; s : string; i : word;
begin
  if savedialog1.Execute then
  begin
    Assignfile(f,savedialog1.FileName);
    rewrite(f);
    s := caption;
    writeln(f,s);
    writeln(F,'Periods');
    for i := 0 to stringgrid4.RowCount - 1 do
    writeln(f,stringgrid4.Cells[0,i],#9,stringgrid4.Cells[1,i]);
    writeln(F,'Texts:');
    for i := 0 to stringgrid1.RowCount - 1 do
    writeln(f,stringgrid1.Cells[0,i],#9,stringgrid1.Cells[1,i],#9,stringgrid1.Cells[1,i]);

    closefile(F);

    if form1.CheckBox7.Checked then
      shellexecute(0,'open',pchar(savedialog1.FileName),'',nil,1);
  end;
end;

procedure TWT1.Button2Click(Sender: TObject);
begin
    shellexecute(0,'open',pchar('sys\xlsdata\frq\frequency table.xls'),'',nil,1);
end;

procedure TWT1.FormCreate(Sender: TObject);
var i : word;s : string;
begin
  stringgrid2.LoadFromCSVFile('sys\frq_P.csv',#9);
  stringgrid3.LoadFromCSVFile('sys\frq_T.txt',';');
  for i := 0 to stringgrid3.ColCount - 1 do
  begin
      s := stringgrid3.Cells[i,0]; delete(s,1,pos(' ',s));
           stringgrid3.Cells[i,0] := s;
  end;
end;

procedure TWT1.FormResize(Sender: TObject);
begin
  stringgrid1.Columns[0].Width:= round(stringgrid1.Width*0.65);
  stringgrid1.Columns[1].Width:= round(stringgrid1.Width*0.15);
  stringgrid1.Columns[2].Width:= round(stringgrid1.Width*0.15);
end;

procedure TWT1.StringGrid1DblClick(Sender: TObject);
begin
  if stringgrid1.Row > 0 then
  begin
    poisk.VVV:= Stringgrid1.Cells[0,stringgrid1.Row];
    form1.StringGrid1.Col:=5;
    form1.StringGrid1Click(sender);
    vvv := '';
    wr.statusbar1.Panels[1].TEXT := inttostr(wr.StringGrid1.RowCount-1);
    wr.statusbar1.Panels[3].TEXT := '1';
  end;

end;

procedure twt1.getwt(i : dword);
var a,c,d : byte; j,k,l : dword; s : string;
begin  c := 1;d :=1;
    stringgrid1.RowCount:=256;
    for a := 1 to 255 do
    for c := 0 to 2 do
    begin
      stringgrid1.Cells[c,a] := '';;
    end;
    d := 1;c:=1;

    for a := 1 to 255 do
    if a in xgd[i] then
    begin
      if a in [1..10] then
        begin
         stringgrid4.Cells[0,c] := form1.combobox6.Items[a];
         for j := 1 to stringgrid2.RowCount- 1 do
         if form1.StringGrid1.Cells[1,form1.StringGrid1.Row] =
         stringgrid2.Cells[a*2-2,j] then
         begin stringgrid4.Cells[1,c] := stringgrid2.Cells[a*2-1,j];break;end;
         inc(c);

        end
        else
        if a in [11..255] then
        begin
         stringgrid1.Cells[0,d] := form1.combobox6.Items[a];
         for j := 0 to stringgrid3.ColCount-1 do
         if stringgrid3.Cells[j,0]= form1.combobox6.Items[a] then break;
         for k := 1 to stringgrid3.RowCount-1 do
         if  form1.StringGrid1.Cells[1,form1.StringGrid1.Row] =
             stringgrid3.Cells[j,k] then
             begin
              stringgrid1.Cells[2,d] := stringgrid3.Cells[j+1,k];
              for l := 1 to ct.StringGrid1.RowCount - 1 do
              if  ct.StringGrid1.Cells[0,l] = stringgrid1.Cells[0,d] then
                begin
                 stringgrid1.Cells[1,d] := ct.StringGrid1.Cells[3,l];
                 if pos('-',stringgrid1.Cells[1,d]) = 0 then
                 while length(stringgrid1.Cells[1,d]) < 5 do
                 stringgrid1.Cells[1,d] := ' ' + stringgrid1.Cells[1,d]
                 else
                 begin
                   s := stringgrid1.Cells[1,d];
                   delete(s,1,1);
                   stringgrid1.Cells[1,d] := s;
                 while length(stringgrid1.Cells[1,d]) < 4 do
                 stringgrid1.Cells[1,d] := ' '+ stringgrid1.Cells[1,d];
                 stringgrid1.Cells[1,d] := '-' + stringgrid1.Cells[1,d];
                 end;
                 //end;
                 if  stringgrid1.Cells[1,d] = ' 2500' then
                     stringgrid1.Cells[1,d] := '?';
                end;
              break;
             end;
         inc(d);

      end;
    end;
    if c < d then c :=d;
    stringgrid1.RowCount:=c;
    caption := lp.stringGrid1.cells[x229,609] + ' "'+
    form1.StringGrid1.Cells[1,form1.StringGrid1.Row] +'"';
    for c := 1 to stringgrid4.RowCount - 1 do
    while length(stringgrid4.Cells[1,c]) < 6 do
    stringgrid4.Cells[1,c] := ' '+ stringgrid4.Cells[1,c];
    for c := 1 to stringgrid1.RowCount - 1 do
    while length(stringgrid1.Cells[1,c]) < 6 do
    stringgrid1.Cells[1,c] := ' '+ stringgrid1.Cells[1,c];
    for c := 1 to stringgrid1.RowCount - 1 do
    while length(stringgrid1.Cells[2,c]) < 6 do
    stringgrid1.Cells[2,c] := ' '+ stringgrid1.Cells[2,c];



end;

end.

