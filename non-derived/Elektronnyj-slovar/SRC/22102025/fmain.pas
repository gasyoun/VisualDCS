unit fmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, ExtDlgs, AnimatedGif, MemBitmap;

type

  { Tfgif }

  Tfgif = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    ComboBox_Mode: TComboBox;
    Edit_ZoomFactor: TEdit;
    IdleTimer1: TIdleTimer;
    Label1: TLabel;
    Label2: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPaintBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ComboBox_ModeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1Paint(Sender: TObject);
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IdleTimer1Timer(Sender: TObject);
  private
    procedure AddImage(filename: string; zoom: single);
    function GetSelf: TCustomControl;
  public
    { public declarations }
    gif: array[1..1000] of record
                      image: TAnimatedGif;
                      r: TRect;
                    end;
    background: TMemBitmap;
    drawTool: (dtNone, dtBrush, dtEraser);
    prevPos: TPoint;
    procedure UpdateBackground;
    procedure ResetAnimCanvas;
    //property Panel1: TCustomControl read GetSelf;
  end; 

var
  fgif: Tfgif;

const
   BrushSize = 7;
   EraserSize = 16;

implementation

{ Tfgif }

procedure Tfgif.AddImage(filename: string; zoom: single);
var w,h: integer;
begin
//     setlength(gif,length(gif)+1);
//  setlength(gif,1);
     with gif[1]  {high(gif)]} do
     begin
      image :=   TAnimatedGif.Create(nil);
      image.LoadFromLazarusResource('a');

//       image := TAnimatedGif.Create(filename);
//       image.EraseColor := self.Color;
//       w := round(image.width *zoom);
//       h := round(image.height *zoom);
//       r.left := random(panel1.width- w);
//       r.top := random(panel1.height- h);
//       r.right := r.left + w;
//       r.bottom := r.top + h;
     end;
     if Combobox_Mode.ItemIndex= -1 then
     begin
       Combobox_Mode.ItemIndex := integer(gif[high(gif)].image.BackgroundMode);
     end else
       gif[high(gif)].image.BackgroundMode := TGifBackgroundMode(Combobox_Mode.ItemIndex);
     ResetAnimCanvas;

end;

function Tfgif.GetSelf: TCustomControl;
begin
  result := self;
end;

procedure Tfgif.FormCreate(Sender: TObject);
var m: TGifBackgroundMode;
begin
  randomize;
  background := TMemBitmap.Create(0,0);
  for m := low(TGifBackgroundMode) to high(TGifBackgroundMode) do
    ComboBox_Mode.Items.Add(GifBackgroundModeStr[m]);
end;

procedure Tfgif.Button1Click(Sender: TObject);
var i: integer;
begin
   for i := 0 to high(gif) do
     gif[i].image.pause;
end;

procedure Tfgif.Button2Click(Sender: TObject);
var i: integer;
begin
   for i := 0 to high(gif) do
     gif[i].image.resume;
end;

procedure Tfgif.Button3Click(Sender: TObject);
var i: integer;
begin
   for i := 0 to high(gif) do
     gif[i].image.CurrentImage:= gif[i].image.CurrentImage-1;
end;

procedure Tfgif.Button4Click(Sender: TObject);
var i: integer;
begin
   for i := 0 to high(gif) do
     gif[i].image.CurrentImage:= gif[i].image.CurrentImage+1;
end;

procedure Tfgif.Button5Click(Sender: TObject);
var zoom: single; pos_error: integer;
begin
//  if OpenPictureDialog1.Execute then
  begin
//    val(Edit_ZoomFactor.Text,zoom,pos_error);
//    if pos_error <> 0 then zoom := 1;
    AddImage('a',10);
  end;
end;

procedure Tfgif.Button6Click(Sender: TObject);
begin
  if length(gif) > 0 then
  begin
     with gif[high(gif)] do
       image.Hide(Canvas,r);
     gif[high(gif)].image.free;
//     setlength(gif,length(gif)-1);
  end;
end;

procedure Tfgif.Button7Click(Sender: TObject);
begin
  ResetAnimCanvas;
end;

procedure Tfgif.ComboBox_ModeChange(Sender: TObject);
var i: integer;
begin
  for i := 0 to high(gif) do gif[i].image.BackgroundMode:= TGifBackgroundMode(Combobox_Mode.ItemIndex);
end;

procedure Tfgif.FormDestroy(Sender: TObject);
var i: integer;
begin
  for i := 0 to high(gif) do gif[i].image.free;
  background.freeReference;
end;

procedure Tfgif.Panel1Click(Sender: TObject);
begin

end;

procedure Tfgif.Panel1Paint(Sender: TObject);
var i: integer;
begin
  UpdateBackground;
  background.Draw(panel1.Canvas,ClientRect);
  for i := 0 to high(gif) do
    with gif[i] do panel1.Canvas.StretchDraw(r,image);
  IdleTimer1.Enabled:= true;
end;

procedure Tfgif.PanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (drawTool = dtNone) and (Button = mbLeft) then
  begin
       drawTool := dtBrush;
       prevPos := point(X,Y);
       panel1.Canvas.Pen.Width := BrushSize*2;
       panel1.Canvas.Pen.Color := clBlack;

       panel1.Canvas.Pen.Style := psClear;
       panel1.Canvas.Brush.Style := bsSolid;
       panel1.Canvas.Brush.Color := clBlack;
       panel1.Canvas.Ellipse(X-BrushSize,Y-BrushSize,X+BrushSize,y+BrushSize);
  end else
  if (drawTool = dtNone) and (Button = mbRight) then
  begin
       drawTool := dtEraser;
       prevPos := point(X,Y);
       panel1.Canvas.Pen.Width := EraserSize*2;
       panel1.Canvas.Pen.Color := clWhite;

       panel1.Canvas.Pen.Style := psClear;
       panel1.Canvas.Brush.Style := bsSolid;
       panel1.Canvas.Brush.Color := clWhite;
       panel1.Canvas.Rectangle(X-EraserSize,Y-EraserSize,X+EraserSize,y+EraserSize);
  end;
end;

procedure Tfgif.PanelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
     case drawTool of
     dtBrush:
       begin
         panel1.Canvas.Pen.Style := psSolid;
         panel1.Canvas.MoveTo(prevPos.X,prevPos.Y);
         panel1.Canvas.LineTo(X,Y);
         prevPos := point(X,Y);
       end;
     dtEraser:
       begin
         panel1.Canvas.Pen.Style := psClear;
         panel1.Canvas.Brush.Style := bsSolid;
         panel1.Canvas.Rectangle(X-EraserSize,Y-EraserSize,X+EraserSize,y+EraserSize);
         panel1.Canvas.Pen.Style := psSolid;
         panel1.Canvas.MoveTo(prevPos.X,prevPos.Y);
         panel1.Canvas.LineTo(X,Y);
         prevPos := point(X,Y);
       end;
     end;
end;

procedure Tfgif.PanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if (drawTool = dtBrush) and (Button = mbLeft) then drawTool := dtNone;
     if (drawTool = dtEraser) and (Button = mbRight) then drawTool := dtNone;
end;

procedure Tfgif.IdleTimer1Timer(Sender: TObject);
var i: integer;
begin
  IdleTimer1.Enabled:= false;
  for i := 0 to high(gif) do
   with gif[i] do
   begin
      image.Update(panel1.Canvas,r);
   end;
  IdleTimer1.Enabled:= true;
end;

procedure Tfgif.UpdateBackground;
var xb,yb,w,h,x,y: integer;
    p : PMemPixel;
    i: integer;
begin
  w := panel1.Width;
  h := panel1.Height;
  if (background.Width <> w) or (background.Height <> h) then
  begin
    background.SetSize(w,h);

    for yb := 0 to h-1 do
    begin
     p := background.Scanline[yb];
     for xb := 0 to w-1 do
     begin
       p^:= MemPixel(255- xb*32 div w,255- xb*32 div w,255,255);
       inc(p);
     end;
    end;

    for i := 1 to w*h div 20000 do
    begin
      x := random(w+100)-50;
      y := random(h+100)-50;
      background.FillRect(x,y,x+random(200),y+random(200),MemPixel(random(255),random(255),random(255),32),dmDrawWithTransparency );
      background.Rectangle(random(w),random(h),random(w+1),random(h+1),MemPixel(random(255),random(255),random(255),32),dmDrawWithTransparency);
    end;

    background.InvalidateBitmap;
  end;
end;

procedure Tfgif.ResetAnimCanvas;
begin
  IdleTimer1.Enabled:= false;
  Panel1Paint(self);
end;

initialization
  {$I fmain.lrs}
  {$I gf.lrs}

end.

