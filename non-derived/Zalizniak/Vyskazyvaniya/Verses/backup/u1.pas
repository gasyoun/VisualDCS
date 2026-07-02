unit u1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
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
  Stringgrid1.LoadFromCSVFile('RV',#9);
end;

procedure TForm1.Button1Click(Sender: TObject);
var f,f1,f2,f3,f4 : text;i : dword;
begin Assignfile(f,'beg'); rewrite(f);
      Assignfile(f1,'end'); rewrite(f1);
      Assignfile(f2,'lns'); rewrite(f2);
      Assignfile(f3,'ye'); rewrite(f3);
      Assignfile(f4,'Yb'); rewrite(f4);
      for i := 0 to stringgrid1.RowCount - 1 do
      begin
        if i mod 2 = 1 then
           begin
             writeln(f1,stringgrid1.Cells[4,i]);
             if pos('1010 ',stringgrid1.Cells[4,i]+' ') > 0
             then writeln(f3,stringgrid1.Cells[4,i]);
           end
           else
           begin
             writeln(f,COPY(stringgrid1.Cells[4,i],1,8));
             if pos('1010',stringgrid1.Cells[4,i]) = 1
             then writeln(f4,stringgrid1.Cells[4,i]);
           end;
        writeln(f2,stringgrid1.Cells[4,i]);

      end;
      closefile(f);closefile(f1);closefile(f2);
      closefile(f3);closefile(f4);
      showmessage('done');
end;

end.

