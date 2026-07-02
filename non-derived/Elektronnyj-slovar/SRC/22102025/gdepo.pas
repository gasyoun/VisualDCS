unit gdepo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls;

type

  { Tgd }

  Tgd = class(TForm)
    Fitems: TListBox;
    ListBox1: TListBox;
    Memo1: TMemo;
    Mitems: TListBox;
    MM1: TListBox;
    NItems: TListBox;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure ListBox1Click(Sender: TObject);
    procedure NItemsClick(Sender: TObject);
  private

  public

  end;

var
  gd: Tgd;

implementation

{$R *.lfm}

{ Tgd }

procedure Tgd.ListBox1Click(Sender: TObject);
begin

end;

procedure Tgd.NItemsClick(Sender: TObject);
begin

end;

end.

