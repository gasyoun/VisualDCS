unit e2_1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
var i,j,k : dword; s,s1,s2:string;
    f : text;
begin
  if opendialog1.Execute then
  begin
    sysuem.assign(f,'_'+opendialog1.FileName);
    rewrite(f);
    stringgrid1.Clear;
    stringgrid1.LoadFromCSVFile(opendialog1.FileName,#9);
    for i := 0 to stringgrid1.ColCount-1 do
    begin
      s := '';s1 := '';s2 := '';k:=0;
      if i mod 3 = 0 then
      for j := 2 to stringgrid1.RowCount - 1 do
      if stringgrid1.Cells[i,j] <> '' then
      begin
         inc(k);
         if k < 11 then
         s := s + stringgrid1.Cells[i,j]+ ' ';
      end;
      if i mod 3 = 1 then  s1 := stringgrid1.Cells[i,0];
      if i mod 3 = 2 then
      begin
        s2 := stringgrid1.Cells[i,0];
        delete(s2,1,pos('=',s2));
        if pos('.',s2) > 0 then
        begin insert(',',s2,pos('.',s2)); delete(s2,pos('.',s2),1);end;
      end;
      writeln(s1,#9,s2,#9,s);
    end;
    closefile(f);
  end;
end;

end.

