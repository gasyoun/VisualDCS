unit depo1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids;

type

  { Tdepo }

  Tdepo = class(TForm)
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox6: TListBox;
    Memo1: TMemo;
    Memox: TMemo;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure memo1Click(Sender: TObject);
  private

  public

  end;

var
  depo: Tdepo;

implementation
uses poisk;
{$R *.lfm}

{ Tdepo }

procedure Tdepo.memo1Click(Sender: TObject);
begin

end;

procedure Tdepo.FormCreate(Sender: TObject);
begin


  if fileexists('sys\dic.sdm') then
  memo1.Lines.LoadFromFile('sys\dic.sdm')
  else
  begin
     application.MessageBox('The Dictionary DataBase not Found.','Crytical Error!',16);
     halt(1);
  end;
  stringgrid1.RowCount:=272158;
  stringgrid1.LoadFromCSVFile('sys\hdr.219',#9,true,0,false);


end;

procedure Tdepo.ListBox4Click(Sender: TObject);
begin

end;

end.

