unit wcard1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids;

type

  { TWCard }

  TWCard = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
  private

  public

  end;

var
  WCard: TWCard;

implementation

{$R *.lfm}

end.

