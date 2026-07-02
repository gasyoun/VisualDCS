unit mainwin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ComCtrls, Grids;

type

  { TSD5 }

  TSD5 = class(TForm)
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseEnter(Sender: TObject);
    procedure SpeedButton1MouseLeave(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton8MouseEnter(Sender: TObject);
    procedure SpeedButton8MouseLeave(Sender: TObject);
  private

  public

  end;

var
  SD5: TSD5;

implementation

{$R *.lfm}

{ TSD5 }

procedure TSD5.SpeedButton1MouseEnter(Sender: TObject);
begin
  Speedbutton1.Transparent:=false;
end;

procedure TSD5.SpeedButton1Click(Sender: TObject);
begin
  panel5.Parent := panel1; panel5.Hide;
  panel4.Align:=alleft;
  panel4.Parent := panel3;panel4.Show;

end;

procedure TSD5.SpeedButton1MouseLeave(Sender: TObject);
begin
    Speedbutton1.Transparent:=true;
end;

procedure TSD5.SpeedButton8Click(Sender: TObject);
begin
  panel4.Parent := panel1; panel4.Hide;
  panel5.Align:=alleft;
  panel5.Parent := panel3;panel5.Show;

end;

procedure TSD5.SpeedButton8MouseEnter(Sender: TObject);
begin
  Speedbutton8.Transparent:=false;
end;

procedure TSD5.SpeedButton8MouseLeave(Sender: TObject);
begin
  Speedbutton8.Transparent:=true;
end;

end.

