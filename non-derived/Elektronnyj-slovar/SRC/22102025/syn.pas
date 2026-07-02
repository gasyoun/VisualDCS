unit syn;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ExtCtrls,
  StdCtrls, ComCtrls;

type

  { TForm4 }

  TForm4 = class(TForm)
    Edit1: TEdit;
    Memo1: TMemo;
    Panel2: TPanel;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid2Click(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
  private

  public
    procedure GetS2(s : string);
    procedure Gettrd(s : string);
  end;

var
  Form4: TForm4;
  var A : array of string;
implementation
uses poisk,reult1,depo1,df;
{$R *.lfm}

{ TForm4 }
procedure Tform4.GetS2(s : string);
var i,j : dword; s1,s2 : string;
begin
   if s <> '' then
   begin
     j  := 0;
     for i := 0 to stringgrid1.RowCount - 1 do
     if s = stringgrid1.Cells[1,i] then
     begin
       s1 := stringgrid1.Cells[2,i];
       delete(s1,1,1);
       setlength(ddl,50000);
       while s1 <> '' do
       begin
         s2 := copy(s1,1,pos(#9,s1)-1);delete(s1,1,pos(#9,s1));
         if s2 <> '' then
         begin
         form1.filldlist(strtoint(s2));
         dlist[1].ID:=strtoint(s2);
         dlist[1].wd:=depo.stringGrid1.cells[1,strtoint(s2)];
         ddl[j] := dlist;
         inc(j);
         end;
       end;
       Setlength(ddl,j);
       form1.SpeedButton27Click(nil);
       resform.Edit1.Text :=
       form4.Caption +' for the word "'+depo.Stringgrid1.cells[1,strtoint(s)]+'"';
       break;
     end;
   end;
end;

procedure TForm4.FormCreate(Sender: TObject);
var i : dword;
begin
  stringgrid1.ColCount:=3;
  stringgrid1.RowCount:=44684;
  stringgrid1.LoadFromCSVFile('sys\syn\sm\s2.csv','#');
end;

procedure TForm4.StringGrid2Click(Sender: TObject);
var i : dword; s : string;
begin memo1.Clear;
   for i := 0 to form3.stringgrid3.RowCount - 1 do
   if form3.stringgrid3.Cells[2,i] = stringgrid2.cells[0,stringgrid2.Row] then
   begin
     s := form3.stringgrid3.Cells[1,i];
     delete(s,1,1);

     while pos('#',s) > 0 do
     begin
       memo1.Lines.Add(
       copy(s,1,pos('#',s)-1));
       delete(s,1,pos('#',s));
     end;
   end;
   if memo1.Text <> '' then
   memo1.Text:='The Short definitions' +#13+#10+memo1.Text;
end;

procedure TForm4.StringGrid2DblClick(Sender: TObject);
begin
   if stringgrid1.Row > 0 then
   begin
     form4.GetS2(stringgrid2.cells[0,stringgrid2.Row]);
   end;

end;

procedure TForm4.Edit1Change(Sender: TObject);
begin
  Edit1.Text := form1.convertx(edit1.Text);
  Gettrd(edit1.Text);
  edit1.Selstart:= length(edit1.Text);
  edit1.setfocus;
end;

procedure Tform4.Gettrd(s : string);
var i,c : dword;
begin
  stringgrid2.RowCount:=stringgrid1.RowCount+1;
  if s <> '' then
  begin
    c := 1;
    for i := 0 to stringgrid1.RowCount - 1 do
    if pos(s,stringgrid1.Cells[0,i]) = 1 then
    begin
      stringgrid2.Cells[0,c] := stringgrid1.Cells[1,i];
      stringgrid2.Cells[1,c] := stringgrid1.Cells[0,i];
      inc(c);
    end;
    stringgrid2.RowCount:=c;
  end
  else
   for i := 0 to stringgrid1.RowCount - 1 do
   begin
     stringgrid2.Cells[0,i + 1] := stringgrid1.Cells[1,i];
     stringgrid2.Cells[1,i + 1] := stringgrid1.Cells[0,i];
   end;
  if stringgrid1.RowCount > 1 then stringgrid1.Row:=1;
   Statusbar1.Panels[1].Text:=inttostr(stringgrid2.RowCount);
end;

end.

