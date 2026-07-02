unit ssv;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ExtDlgs, Buttons;

type

  { TRDR }

  TRDR = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label12MouseEnter(Sender: TObject);
    procedure Label12MouseLeave(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure Label13MouseEnter(Sender: TObject);
    procedure Label13MouseLeave(Sender: TObject);
    procedure Label14Click(Sender: TObject);
    procedure Label14MouseEnter(Sender: TObject);
    procedure Label14MouseLeave(Sender: TObject);
    procedure Label15Click(Sender: TObject);
    procedure Label15MouseEnter(Sender: TObject);
    procedure Label15MouseLeave(Sender: TObject);
    procedure Label16Click(Sender: TObject);
    procedure Label16MouseEnter(Sender: TObject);
    procedure Label16MouseLeave(Sender: TObject);
    procedure Label17Click(Sender: TObject);
    procedure Label17MouseEnter(Sender: TObject);
    procedure Label17MouseLeave(Sender: TObject);
    procedure Label18Click(Sender: TObject);



    procedure Label1Click(Sender: TObject);
    procedure Label1MouseEnter(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label2MouseEnter(Sender: TObject);
    procedure Label2MouseLeave(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label6MouseEnter(Sender: TObject);
    procedure Label6MouseLeave(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    function convertT(var s : String) : String;
    function slogi(s : string) : longint;
   public
     var
   R1  :    String;  //=  'Brief vowel';
   R2  :    String; // ='Long vowel';
   R3  :    String; // ='Long vowel before ligature';
   R4  :    String; // ='Long vowel before visarga, anusvara or anunasika';
   R5  :    String; // ='Long vovel before endinng aspirate in the pada';

  end;
txx = record
       ax : string;
       ll : real;
       rn : byte;
       r : string;
    end;
rdrec = record
       speed : word;
       tx    : word;
       cp    : word;
       st   : word;
       pd   : word;
       img  : string[255];
       tout : dword;
    end;
var
    RDR: TRDR;
    slk : dword = 0;

implementation
uses poisk,tx1,params;
{$R *.lfm}
var
      phr : array of txx;
  axa : txx;
  srcstring : string;
  sl : string =
    'agnimiille purohitam| yajnasya devaṁ ṛtvijam| hotaram ratnam dha tamam||';

  A : longint = 0;

k : string = '';
ttn : byte = 0;
T : longint = 1000;
prev : byte = 0;
p : word = 0;
s : string;
interval : real = 1;

rname : string = '';
c : longint = 0;
Tim: longint = 0;
tim2 : longint  = 0;
{ TRDR }
s5: string = '';
RF : file of rdrec;
     Rpos: rdrec;
procedure TRDR.Label3Click(Sender: TObject);
begin
  timer2.Enabled:=false;
  timer3.Enabled:=false;
  form1.BitBtn2.Hide;
  form1.p18;
  close;
end;

procedure TRDR.Label3MouseEnter(Sender: TObject);
begin
  label3.Color:=$00008D;
end;

procedure TRDR.Label3MouseLeave(Sender: TObject);
begin
  label3.Color:=clnone;
end;

procedure TRDR.Label4Click(Sender: TObject);
var z : longint;
    i : longint;
    g : string;
    g1: string;
    s98 : string;
begin
  tim := 0;
  tim2:= 0;
  timer2.Enabled:=false;;
  timer3.Enabled:=false;;
  label10.Caption:=' ';
  label4.Caption:='';
  label5.Caption:='';
  g := memo1.Lines.Strings[slk];
  label19.caption:=copy(label19.caption,1,pos('#',label19.caption));
  s98 := copy(g,1,pos('$',g)-1); delete(g,1,pos('$',g));
  label19.caption:=label19.caption + s98;
//  g1:= memo1.Lines.Strings[slk+1];
//  delete(g,1,pos(#32,g));
//  delete(g1,1,pos(#32,g1));
if checkbox1.Checked = false then
begin;
     g := form1.convertd(g);
//     g1 := form1.convertd(g1);
end;
  label7.Caption:=g;
//  label8.Caption:=g1;
label4.AutoSize:=false;
label5.AutoSize:=false;
label7.AutoSize:=false;
label8.AutoSize:=false;


  label7.Left:=50;//round(screen.Width/2 - label7.Width/2);
  label8.Left:=50;//round(screen.Width/2 - label7.Width/2);
  label4.Left:=label7.Left;
  label5.Left:= label8.Left;
  label4.Height:=image1.Height;
  label7.height:=image1.Height;;
  label5.Height:=image1.Height;;
  label8.Height:=image1.Height;;
  label4.Width:=image1.Width - 100;
  label5.Width:=image1.Width - 100;
  label7.Width:=image1.Width - 100;
  label8.Width:=image1.Width - 100;
  label4.Top:=image1.Top+25;
  label7.Top:=image1.Top+25;



  sl := memo1.Lines.Strings[slk];
  delete(sl,1,pos('$',sl));
//  label19.caption:= 'Ramayana, Balakanda. ' +copy(sl,1,pos(' ',sl) - 2) + ' (' + inttostr(slk div 2 + 1)+' / '+inttostr(memo1.Lines.Count div 2) +')';
//  delete(sl,1,pos(#32,sl));
  a := slogi(sl);
  for i := 0 to a - 1  do
  begin
    if phr[i].ll = 1 then phr[i].r:=R1;
    if phr[i].ll = 2 then phr[i].r:=R2;
    if (phr[i].ll = 1) and
//       (i < a - 2)     and
       (phr[i + 1].rn in [15..47]) and
       (phr[i + 2].rn in [15..46])
       then
       begin
          phr[i].ll:=2;
          phr[i].r:=R3;
       end;
       if (phr[i].ll >= 1) and
//          (i < a - 1)     and
          (phr[i+1].rn in [48,49,51]) then
          begin
            phr[i].ll:=2;
            phr[i].r:=R4;
          end;

       if (phr[i].ll = 1) and
          (i = a - 1)     and
          (phr[i+1].rn in [16,18,21,23,26,28,31,33,36,38] ) then
          begin
            phr[i].ll:=2;
            phr[i].r:=R5;
         end;
       tim := tim + round(phr[i].ll*t);
  end;
 label9.Caption := 'Estimated reading time: '+inttostr(round(tim/1000)) + ' secundes';
 label9.Left:= screen.Width - label9.Width - 30;

c := 0;
  timer2.Interval:=t;;
  timer2.Enabled:=true;;
//  timer3.Enabled:=true;
  label11.Transparent := true;
  label11.BringToFront;
end;

procedure TRDR.Label5Click(Sender: TObject);
begin
//  slogi(sl);
end;

procedure TRDR.Label6Click(Sender: TObject);
begin
  timer2.Enabled:=false;

  c := 0;
  if t >= 700 then t := t - 100;
  label4click(sender);
end;

procedure TRDR.Label6MouseEnter(Sender: TObject);
begin
  label6.Color:=$323232;
end;

procedure TRDR.Label6MouseLeave(Sender: TObject);
begin
  label6.Color:=clnone;
end;

procedure TRDR.Panel1Click(Sender: TObject);
begin

end;


procedure TRDR.SpeedButton1Click(Sender: TObject);
begin
  form8.Show;
  form8.PageControl1.ActivePage := form8.PageControl1.Pages[2];
  label15click(sender);
end;

procedure TRDR.Timer1Timer(Sender: TObject);
begin
  if form8.CheckBox11.Checked then
  begin
    if rdr.AlphaBlendValue < 255 then
    rdr.AlphaBlendValue:=   rdr.AlphaBlendValue + 1
    else timer1.Enabled:=false;
  end
  else
  AlphaBlendValue := 255;

end;

procedure TRDR.Timer2Timer(Sender: TObject);
var i : word;d : real;
begin
  if c <= A - 1 then
  begin
     if checkbox1.Checked = false then
     s5 := form1.convertd(form1.convertd(s5) + phr[c].ax);
     if checkbox1.Checked = false then
     begin
          label4.Caption:=s5
//          else label5.Caption:=s5;

     end;
     if checkbox1.Checked then
       label4.caption := (label4.caption + phr[c].ax);
//       else
//        label5.caption := (label5.caption + phr[c].ax);

     label11.caption := phr[c].r;
//     label11.Left:=width-label11.Width - 50;
     if phr[c].ll <> 0 then
     timer2.interval := round(t*phr[c].ll)
     else timer2.interval := 100;
     inc(c);
  end
  else
  begin
    c := 0;
    inc(slk);
    s5 := '';
    timer2.Enabled:=false;
    label4click(sender);
  end;
  d := 0;
  for i := c to length(phr) - 1 do
    d := d + phr[i].ll;

  label20.Caption:=inttostr(round(d)) + ' Sec';
end;
procedure TRDR.Timer3Timer(Sender: TObject);
var x : longint;
begin
  inc(tim2);
  x := round(int(tim/1000) - tim2);
  label10.Caption:=inttostr(x) + ' secundes left';
  label10.Left:= screen.Width - label10.Width - 30;
//  label10.Top:=label9.Top - 75;
end;

procedure TRDR.Label2Click(Sender: TObject);
begin
  checkbox1.Checked:=not(checkbox1.Checked);
  checkbox1change(sender);
end;

procedure TRDR.Label2MouseEnter(Sender: TObject);
begin
  label2.Color:=$323232;
end;

procedure TRDR.Label2MouseLeave(Sender: TObject);
begin
  label2.Color:=clnone;
end;

procedure TRDR.FormCreate(Sender: TObject);
begin
  R1  :='Краткая гласная';
  R2  :='Долгая гласная';
  R3  :='Долгая гласная перед лигатурой';
  R4  :='Долгая гласная перед висаргой или анусварой';
  R5  :='Долгая гласная перед предыхательной в конце строфы';

  slk := 0;
label11.Left:=30;

label11.Caption:='';
label4.Caption:='';
label5.Caption := '';
  label4.Left:=50;
  label4.Top:=50;

  label5.Left:=50;
  label5.Top:=100;
  label11.Top:= label5.Top + 50;
  label7.Left:=label4.Left;
  label7.Top:=label4.Top;

  label8.Left:=label5.Left;
  label8.Top:=label5.Top;

  label7.Caption:='';
  label8.Caption:='';
  label7.Transparent:=true;
  label8.Transparent:=true;
  label7.SendToBack;
  label8.SendToBack;
  label4.BringToFront;
  label5.BringToFront;
  checkbox1.BringToFront;

   label4.Width:= rdr.Width;
   label5.Width:= rdr.Width;
   label7.Width:= rdr.Width;
   label8.Width:= rdr.Width;

   label4.Height:=75;
   label5.Height:=75;
   label7.Height:=75;
   label8.Height:=75;
   label9.Transparent:=true;
   label10.Transparent:=true;;
   label9.Color := CLnone;
   label10.Color := CLnone;
   image1.Transparent:=true;
   image1.SendToBack;;
   label9.Top:= image1.Height - 200;
   label10.Top:= label9.Top - 100;
   ;
end;

procedure TRDR.FormShow(Sender: TObject);
var s : string;
begin
  form1.BitBtn2.Show;
  s := label19.Caption;
  delete(s,1,1); s := copy(s,1,pos('@',s)-1);
  if s = '' then s := 'Reading...';
  form1.BitBtn2.Caption:= s+'➤';

end;

procedure TRDR.Label12Click(Sender: TObject);
begin
  if pos('Clisck',label19.Caption) > 0 then
  label19.Caption:=copy(label19.Caption,1,pos('Clisck',label19.Caption)-1);
  label4click(sender);

end;

procedure TRDR.Label12MouseEnter(Sender: TObject);
begin
  label12.Color:=$323232;
end;

procedure TRDR.Label12MouseLeave(Sender: TObject);
begin
  label12.Color:=clnone;
end;

procedure TRDR.Label13Click(Sender: TObject);
begin
  if slk < memo1.Lines.Count  - 2 then
  if slk mod 2 = 0 then inc(slk,2)
  else
     inc(slk);
  c := 0;
  timer2.Enabled:=false;
  label4click(sender);
end;

procedure TRDR.Label13MouseEnter(Sender: TObject);
begin
  label13.Color:=$323232;
end;

procedure TRDR.Label13MouseLeave(Sender: TObject);
begin
  label13.Color:=clnone;
end;

procedure TRDR.Label14Click(Sender: TObject);
begin
  slk := 0;
  timer2.Enabled:=false;
  c := 0;
  label4click(sender);
end;

procedure TRDR.Label14MouseEnter(Sender: TObject);
begin
  label14.Color := $323232;
end;

procedure TRDR.Label14MouseLeave(Sender: TObject);
begin
  label14.Color := clnone;
end;

procedure TRDR.Label15Click(Sender: TObject);
begin
  timer2.Enabled:=false;
end;

procedure TRDR.Label15MouseEnter(Sender: TObject);
begin
  label15.Color:=$323232;
end;

procedure TRDR.Label15MouseLeave(Sender: TObject);
begin
  label15.Color:=clnone;
end;

procedure TRDR.Label16Click(Sender: TObject);
begin
  if slk > 1 then
  if slk mod 2 = 0 then dec(slk,2)
  else dec(slk);
  c := 0;
  timer2.Enabled:=false;
  label4click(sender);
end;

procedure TRDR.Label16MouseEnter(Sender: TObject);
begin
  label16.Color:= $323232;
end;

procedure TRDR.Label16MouseLeave(Sender: TObject);
begin
  label16.Color:= clnone;
end;

procedure TRDR.Label17Click(Sender: TObject);
begin
  checkbox2.Checked:=not(checkbox2.Checked);
  checkbox2change(sender);
end;

procedure TRDR.Label17MouseEnter(Sender: TObject);
begin
  label17.Color:=$323232;
end;

procedure TRDR.Label17MouseLeave(Sender: TObject);
begin
  label17.Color:=clnone;
end;

procedure TRDR.Label18Click(Sender: TObject);
var s : string;
begin
  timer2.Enabled:=false;
  timer3.Enabled:=false;
  hide;
  form1.Panel18.Show;
  form1.BitBtn2.Show;
  form1.p18;
  s := label19.Caption;
  delete(s,1,1); s := copy(s,1,pos('@',s)-1);
  form1.BitBtn2.Caption:= s+'➤';
end;




procedure TRDR.Label1Click(Sender: TObject);
begin
  timer2.Enabled:=false;
  c := 0;
  if t < 10000 then T := T + 100;
  label4click(sender);
end;

procedure TRDR.Label1MouseEnter(Sender: TObject);
begin
  label1.Color:=$323232;
end;

procedure TRDR.Label1MouseLeave(Sender: TObject);
begin
  label1.Color:=clnone;
end;

procedure TRDR.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  timer2.Enabled:=false;
  timer3.Enabled:=false;
  rewrite(RF);
  write(RF,rpos); closefile(RF);
end;

procedure TRDR.CheckBox1Change(Sender: TObject);
begin

  label4.Caption:='';
  label5.Caption:='';
  label7.Caption:='';
  label8.Caption:='';
  s5 := '';
  if slk mod 2 = 1 then
  dec(slk);
  label4click(sender);

end;

procedure TRDR.CheckBox2Change(Sender: TObject);
begin
  label11.Visible:=checkbox2.Checked;
end;

function TRDR.convertT(var s : string) : string;
var a : word;
    z : boolean;
begin
    k := '';
    z := false;
    for a := 1 to 65 do
    begin
      p := pos(d[a].deva,s);
      if p = 1 then
      begin
       if (pos('ai',s) <> 1) and (pos('au',s) <> 1) and
         (pos('kh',s) <> 1) and (pos('gh',s) <> 1)  and
         (pos('th',s) <> 1) and (pos('dh',s) <> 1)  and
         (pos('ph',s) <> 1) and (pos('bh',s) <> 1)  and
         (pos('ch',s) <> 1) and (pos('jh',s) <> 1)  and
         (pos('ṭh',s) <> 1) and (pos('ḍh',s) <> 1)
       then
       begin
              k := d[a].deva;
              Interval:=round(d[a].lng);
              delete(s,1,length(d[a].deva));
              ttn := a;
              break;
       end
      else
      begin
       k := d[a].deva;
       ttn := a;
       Interval:=round(d[a].lng);
       delete(s,1,length(d[a].deva));
       break;
      end;

      end;
      end;
      if (p = 0) and (a = 65) then
      begin
        k := ' ';
        delete(s,1,1);
        interval := 0.25;
        ttn := 0;
      end;


    if interval = 0 then interval := 0.001;
    convertT := k;
end;
function TRDR.slogi(s : string) : longint;
var a : byte;
    l : longint;
    s2: string;
    i,c : longint;
    z   : longint;
    x   : byte;
begin  l := 0;
    for i := 1 to length(s) do
    if s <> '' then
    begin
       inc(l);
       setlength(phr,l);
       phr[l - 1].ax:=convertT(s);
       if interval = 0 then interval := 0.25;
       phr[l - 1].ll:=interval;
       phr[l - 1].rn:= ttn;
    end;
    slogi := l;
end;


begin
 assignfile(RF,'sys\rdr.dat');
 if fileexists('sys\rdr.dat') then
 begin
   reset(rf);read(rf,rpos);closefile(RF);
 end
 else
 begin
  rpos.cp:=0;rpos.img:='';rpos.pd:=0;rpos.speed:=700;
  rpos.tout:=0;rpos.tx:=5;
 end;


end.

