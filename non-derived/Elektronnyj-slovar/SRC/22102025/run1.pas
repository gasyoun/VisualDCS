unit run1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, uGifViewer,shellapi,windows,variants;

type

  { TStarting }

  TStarting = class(TForm)
    GIFViewer1: TGIFViewer;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private

  public
  end;
var
  Starting: TStarting;

implementation
uses rdic2;
var
  i : word = 0;
{$R *.lfm}

{ TStarting }

procedure TStarting.Timer1Timer(Sender: TObject);
begin
   rdic2.run1;
   timer1.Enabled:=false;
   timer2.Enabled := true;
end;

procedure TStarting.FormActivate(Sender: TObject);
begin
  width := 512;height :=800;
  image1.Left:=0;
  image1.Top:=0;
  image1.Height:=800;
  image1.Width:=512;
  image1.Center:=true;
  image1.Transparent:=false;
  label1.Top:=781;
  label2.Top:=669;
  label3.Top:=744;
  progressbar1.top := 766;


end;

procedure TStarting.FormCreate(Sender: TObject);
begin
  width := 512;height :=800;
  image1.Left:=0;
  image1.Top:=0;
  image1.Height:=800;
  image1.Width:=512;
  image1.Center:=true;
  image1.Transparent:=false;
  label1.Top:=781;
  label2.Top:=669;
  label3.Top:=744;
  progressbar1.top := 766;

end;

procedure TStarting.Timer2Timer(Sender: TObject);
begin
  if finished = 1 then timer3.Enabled:=true;
  inc(i);
  label1.Caption:= 'Starting.. Please wait. ' + inttostr(i);
  //progressbar1.Position:=progressbar1.Position+10;

//  progressbar1.Brush.Canvas.TextOut(0,0,pchar(i));


end;

procedure TStarting.Timer3Timer(Sender: TObject);
begin
  alphablendvalue := alphablendvalue - 1;
  if alphablendvalue = 1 then close;
end;



end.

