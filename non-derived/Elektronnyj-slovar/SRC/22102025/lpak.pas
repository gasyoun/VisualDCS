unit lpak;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls;

type

  { Tlp }

  Tlp = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
  private

  public

  end;

var
  lp: Tlp;
  x229 : word;

implementation
uses poisk, sh1,dcon,lex2,tema1, reult1,ssv,tx1,kn, ched1, lgg,
  vd1,Edepo,wrf,lns1,repo1,frs, syn, dF,tsn,wtc,keybrd,sfo,gfr,
  gram, ver1,omf, parals,sintagma1,help1,params,rts,stans,tcf,
  Tcompare,th2,fdic,krr;


{$R *.lfm}

{ Tlp }
var gid : word = 1;
procedure Tlp.FormCreate(Sender: TObject);
var i,j : word;f : text;
    s,s1 : string;
begin
  vr := tvr.Create(self);
  roots := Troots.Create(self);
  roots.Hide;
  vr.Hide;
  stringgrid1.RowCount:=900;
//  if fileexists('sys\face1.txt') then

//  stringgrid1.LoadFromCSVFile('sys\face1.txt',#9);
{  assignfile(f,'sys\face1.txt');
  reset(f);
  for i := 0 to 800 do
  begin
     j := 0;
     readln(f,s);
     while pos(#9,s) > 0 do
     begin
        if j > 4 then break;

        s1 := copy(s,1,pos(#9,s)-1);
        stringgrid1.Cells[j,i] := s1;
        delete(s,1,pos(#9,s));
        inc(j);
     end;
  end;

  closefile(f);

  rewrite(f);
  writeln(f,'ID',#9,'ID2',#9,'ID3',#9,'Russian',#9,'English',#9);
  for i := 1 to stringgrid1.RowCount - 1 do
  begin s := '';
  for j := 0 to 4 do
  s := s + stringgrid1.Cells[j,i] + #9;
     writeln(f,s);

  end;
  closefile(F);
  showmessage('');
}
  stringgrid1.loadfromcsvfile('sys\face1.txt',#9);
  while stringgrid1.Columns[stringgrid1.ColCount-1].Title.Caption ='Title' do
  stringgrid1.DeleteCol(stringgrid1.ColCount-1);
//  for i := 1 to stringgrid1.rowcount-1 do
//  begin
//     stringgrid1.cells[5,i] := inttostr(i);
//;
//  end;

end;

procedure Tlp.Memo2Change(Sender: TObject);
begin
  button5click(sender);
end;

procedure Tlp.StringGrid1Click(Sender: TObject);
begin
  memo1.Lines.Text:=stringgrid1.Cells[3,stringgrid1.Row];
  memo2.Lines.Text:=stringgrid1.Cells[stringgrid1.Col,stringgrid1.Row];
end;

procedure Tlp.Button1Click(Sender: TObject);
var i,j : word;
    s : string;
begin
   stringgrid1.RowCount:=900;


//MainWin
for i := 1 to stringgrid1.RowCount - 1 do
stringgrid1.Cells[0,i] := inttostr(i);
  for i := 1 to 240 do
  begin
    stringgrid1.Cells[0,i] := inttostr(i);
    stringgrid1.Cells[2,i] := inttostr(i);
    stringgrid1.Cells[1,i] := 'poisk';
  end;
//SearchHistory1
  for i := 241 to 250 do
  begin
    stringgrid1.Cells[0,i] := inttostr(i);
    stringgrid1.Cells[2,i] := inttostr(i-240);
    stringgrid1.Cells[1,i] := 'sh1';
  end;
//DevConverter
  for i := 251 to 287 do
  begin
    stringgrid1.Cells[0,i] := inttostr(i);
    stringgrid1.Cells[2,i] := inttostr(i-250);
    stringgrid1.Cells[1,i] := 'dcon';
  end;
//Lex2; Lex_Intersection/Unit
for i := 288 to 297 do
begin
  stringgrid1.Cells[0,i] := inttostr(i);
  stringgrid1.Cells[2,i] := inttostr(i-287);
  stringgrid1.Cells[1,i] := 'lex2';
end;

for i := 298 to 323 do
begin
  stringgrid1.Cells[0,i] := inttostr(i);
  stringgrid1.Cells[2,i] := inttostr(i-297);
  stringgrid1.Cells[1,i] := 'TEMA';
end;
for i := 363 to 389 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-362);
   stringgrid1.Cells[2,i] := 'TX1';
end;
for i := 350 to 362 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-349);
   stringgrid1.Cells[2,i] := 'SSV';
end;
for i := 324 to 349 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-323);
   stringgrid1.Cells[2,i] := 'Reult1';
end;
for i := 390 to 403 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-389);
   stringgrid1.Cells[2,i] := 'KN';
end;

for i := 404 to 416 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-403);
   stringgrid1.Cells[2,i] := 'ched';
end;

for i := 417 to 441 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-416);
   stringgrid1.Cells[2,i] := 'VD';
end;

for i := 442 to 445 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-441);
   stringgrid1.Cells[2,i] := 'EDepo';
end;

for i := 446 to 470 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-445);
   stringgrid1.Cells[2,i] := 'WRF';
end;
for i := 471 to 494 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-470);
   stringgrid1.Cells[2,i] := 'LNS';
end;

for i := 495 to 545 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-494);
   stringgrid1.Cells[2,i] := 'Repo';
end;
for i := 546 to 568 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-545);
   stringgrid1.Cells[2,i] := 'FRS';
end;
for i := 569 to 572 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-568);
   stringgrid1.Cells[2,i] := 'syn';
end;
for i := 573 to 602 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-572);
   stringgrid1.Cells[2,i] := 'dF';
end;
for i := 603 to 606 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-602);
   stringgrid1.Cells[2,i] := 'Sintagma';
end;
for i := 607 to 614 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-606);
   stringgrid1.Cells[2,i] := 'WTC';
end;

for i := 615 to 626 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-614);
   stringgrid1.Cells[2,i] := 'Keybrd';
end;
for i := 627 to 634 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-626);
   stringgrid1.Cells[2,i] := 'SFO';
end;
for i := 635 to 650 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-634);
   stringgrid1.Cells[2,i] := 'Liga';
end;

for i := 651 to 659 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-650);
   stringgrid1.Cells[2,i] := 'GFR';
end;
for i := 660 to 665 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-659);
   stringgrid1.Cells[2,i] := 'GRAM';
end;
for i := 671 to 679 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-670);
   stringgrid1.Cells[2,i] := 'OF1';
end;

for i := 680 to 694 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-679);
   stringgrid1.Cells[2,i] := 'PRL1';
end;

for i := 695 to 709 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-694);
   stringgrid1.Cells[2,i] := 'Sintagma1';
end;
for i := 710 to 716 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-709);
   stringgrid1.Cells[2,i] := 'hlp1';
end;

for i := 717 to 759 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-716);
   stringgrid1.Cells[2,i] := 'Params';
end;

for i := 760 to 765 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-759);
   stringgrid1.Cells[2,i] := 'Roots';
end;

for i := 766 to 773 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-765);
   stringgrid1.Cells[2,i] := 'STANZA';
end;
for i := 774 to 795 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-773);
   stringgrid1.Cells[2,i] := 'TTTS';
end;
for i := 796 to 799 do
begin
   stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[1,i] := inttostr(i-795);
   stringgrid1.Cells[2,i] := 'TC';
end;

  Stringgrid1.Cells[0,0] := 'ID';
  Stringgrid1.Cells[1,0] := 'UID';
  Stringgrid1.Cells[2,0] := 'inID';
  Stringgrid1.Cells[3,0] := 'RUS';
  Stringgrid1.Cells[4,0] := 'ENG';


  stringgrid1.cells[3,1] :=form1.ComboBox2.Items.CommaText;
  stringgrid1.cells[3,2] :=form1.ComboBox6.Items.CommaText;
  stringgrid1.cells[3,3] :=form1.Edit1.texthint;
  stringgrid1.cells[3,4] :=form1.Edit2.texthint;
  stringgrid1.cells[3,5] :=form1.Edit3.texthint;
  stringgrid1.cells[3,6] :=form1.SBClear.hint;
  stringgrid1.cells[3,7] :=form1.Image10.hint;
  stringgrid1.cells[3,8] :=form1.Image11.hint;
//  stringgrid1.cells[3,9] :=form1.Image2.hint;
  stringgrid1.cells[3,10] :=form1.Image3.hint;
  stringgrid1.cells[3,11] :=form1.Image4.hint;
  stringgrid1.cells[3,12] :=form1.Image5.hint;
  stringgrid1.cells[3,13] :=form1.Image6.hint;
  stringgrid1.cells[3,14] :=form1.Image7.hint;
  stringgrid1.cells[3,15] :=form1.Image8.hint;
  stringgrid1.cells[3,16] :=form1.Image9.hint;
  stringgrid1.cells[3,17] :=form1.Label1.caption;
  stringgrid1.cells[3,18] :=form1.spp1.Hint;
  stringgrid1.cells[3,19] :=form1.menuitem16.caption;
  stringgrid1.cells[3,20] :=form1.menuitem17.caption;;
  stringgrid1.cells[3,21] :=form1.spp6.Caption;
  stringgrid1.cells[3,22] :=form1.Label14.caption;
  stringgrid1.cells[3,23] :=form1.Label4.caption;
  stringgrid1.cells[3,24] :=form1.Label16.caption;
  stringgrid1.cells[3,25] :=form1.ncc1.caption;
  stringgrid1.cells[3,26] :=form1.Label18.caption;
  stringgrid1.cells[3,27] :=form1.ncc.Caption;
  stringgrid1.cells[3,28] :=form1.Label20.caption;
  stringgrid1.cells[3,29] :=form1.ORes.Caption;
  stringgrid1.cells[3,30] :=form1.Books.Caption;
  stringgrid1.cells[3,31] :=form1.SoftW.Caption;
  stringgrid1.cells[3,32] :=form1.spp3.caption;
  stringgrid1.cells[3,33] :=form1.spp4.caption;
  stringgrid1.cells[3,34] :=form1.spp6.caption;
  stringgrid1.cells[3,35] :=form1.spp5.caption;
  stringgrid1.cells[3,36] :=form1.menuitem18.caption;
  stringgrid1.cells[3,37] :=form1.menuitem19.caption;
  stringgrid1.cells[3,38] :=form1.Label3.caption;
  stringgrid1.cells[3,39] :=form1.Label30.caption;
  stringgrid1.cells[3,40] :=form1.Label31.caption;
  stringgrid1.cells[3,41] :=form1.Label32.caption;
  stringgrid1.cells[3,42] :=form1.Label33.caption;
  stringgrid1.cells[3,43] :=form1.Label34.caption;
  stringgrid1.cells[3,44] :=form1.spp2.Hint;
  stringgrid1.cells[3,45] :=dcs1.checkbox2.caption;
  stringgrid1.cells[3,46] :=form1.Label7.caption;
  stringgrid1.cells[3,47] :=form1.spr1.Hint;
  stringgrid1.cells[3,48] :=form1.checkbox2.caption;
  stringgrid1.cells[3,49] :=form1.MenuItem1.caption;
  stringgrid1.cells[3,50] :=form1.MenuItem11.caption;
  stringgrid1.cells[3,51] :=form1.MenuItem126.caption;
  stringgrid1.cells[3,52] :=form1.MenuItem156.caption;
  stringgrid1.cells[3,53] :=form1.MenuItem2.caption;
  stringgrid1.cells[3,54] :=form1.MenuItem23.caption;
  stringgrid1.cells[3,55] :=form1.MenuItem27.caption;
  stringgrid1.cells[3,56] :=form1.MenuItem3.caption;
  stringgrid1.cells[3,57] :=form1.MenuItem30.caption;
  stringgrid1.cells[3,58] :=form1.MenuItem31.caption;
  stringgrid1.cells[3,59] :=form1.MenuItem36.caption;
  stringgrid1.cells[3,60] :=form1.MenuItem37.caption;
  stringgrid1.cells[3,61] :=form1.MenuItem38.caption;
  stringgrid1.cells[3,62] :=form1.MenuItem39.caption;
  stringgrid1.cells[3,63] :=form1.MenuItem4.caption;
  stringgrid1.cells[3,64] :=form1.MenuItem40.caption;
  stringgrid1.cells[3,65] :=form1.MenuItem41.caption;
  stringgrid1.cells[3,66] :=form1.MenuItem42.caption;
  stringgrid1.cells[3,67] :='R63FES';
  stringgrid1.cells[3,68] :=form1.MenuItem56.caption;
  stringgrid1.cells[3,69] :=form1.MenuItem58.caption;
  stringgrid1.cells[3,70] :=form1.nounM.caption;
  stringgrid1.cells[3,71] :=form1.MenuItem60.caption;
  stringgrid1.cells[3,72] :=form1.MenuItem61.caption;
  stringgrid1.cells[3,73] :=form1.MenuItem62.caption;
  stringgrid1.cells[3,74] :=form1.MenuItem63.caption;
  stringgrid1.cells[3,75] :=form1.adjN.caption;
  stringgrid1.cells[3,76] :=form1.MenuItem65.caption;
  stringgrid1.cells[3,77] :=form1.MenuItem66.caption;
  stringgrid1.cells[3,78] :=form1.MenuItem67.caption;
  stringgrid1.cells[3,79] :=form1.MenuItem68.caption;
  stringgrid1.cells[3,80] :=form1.MenuItem69.caption;
  stringgrid1.cells[3,81] :=form1.MenuItem70.caption;
  stringgrid1.cells[3,82] :=form1.MenuItem71.caption;
  stringgrid1.cells[3,83] :=form1.MenuItem72.caption;
  stringgrid1.cells[3,84] :=form1.MenuItem73.caption;
  stringgrid1.cells[3,85] :=form1.MenuItem74.caption;
  stringgrid1.cells[3,86] :=form1.MenuItem75.caption;
  stringgrid1.cells[3,87] :=form1.MenuItem76.caption;
  stringgrid1.cells[3,88] :=form1.N1.caption;
  stringgrid1.cells[3,89] :=form1.N2.caption;
  stringgrid1.cells[3,90] :=form1.N3.caption;
  stringgrid1.cells[3,91] :=form1.OpenDialog1.Title;
  stringgrid1.cells[3,92] :='MirrorAFX';
  stringgrid1.cells[3,93] :=form1.SaveDialog1.Title;

  stringgrid1.cells[3,124] :=form1.SpeedButton12.caption;
  stringgrid1.cells[3,125] :=form1.SpeedButton13.caption;
  stringgrid1.cells[3,126] :=form1.SpeedButton14.caption;
  stringgrid1.cells[3,127] :=form1.SpeedButton15.caption;
  stringgrid1.cells[3,128] :=form1.SpeedButton16.caption;
  stringgrid1.cells[3,129] :=form1.checkbox3.Hint;
  stringgrid1.cells[3,130] :=form1.SpeedButton18.caption;
  stringgrid1.cells[3,131] :=form1.SpeedButton19.caption;
  stringgrid1.cells[3,132] :=form1.SpeedButton20.caption;
  stringgrid1.cells[3,133] :=form1.SpeedButton21.caption;
  stringgrid1.cells[3,134] :=form1.SpeedButton22.caption;
  stringgrid1.cells[3,135] :=form1.SpeedButton23.caption;
  stringgrid1.cells[3,136] :=form1.SpeedButton24.caption;
  stringgrid1.cells[3,137] :=form1.label5.caption;
  stringgrid1.cells[3,138] :=form1.SpeedButton26.caption;
  stringgrid1.cells[3,139] :=form1.SpeedButton27.caption;
  stringgrid1.cells[3,140] :=form1.SpeedButton28.caption;
  stringgrid1.cells[3,141] :=form1.SpeedButton29.caption;
  stringgrid1.cells[3,142] :=form1.SpeedButton30.caption;
  stringgrid1.cells[3,143] :=form1.SpeedButton31.caption;
  stringgrid1.cells[3,144] :=form1.SpeedButton32.caption;
  stringgrid1.cells[3,145] :=form1.SpeedButton33.caption;
  stringgrid1.cells[3,146] :=form1.SpeedButton34.caption;
  stringgrid1.cells[3,147] :=form1.SpeedButton35.caption;
  stringgrid1.cells[3,148] :=form1.SpeedButton36.caption;
  stringgrid1.cells[3,149] :=form1.SpeedButton37.caption;
  stringgrid1.cells[3,150] :=form1.SpeedButton38.caption;
  stringgrid1.cells[3,151] :=form1.SpeedButton39.caption;
  stringgrid1.cells[3,152] :=form1.SpeedButton4.caption;
  stringgrid1.cells[3,153] :=form1.SpeedButton40.caption;
  stringgrid1.cells[3,154] :=form1.SpeedButton41.caption;
  stringgrid1.cells[3,155] :=form1.SpeedButton42.caption;
  stringgrid1.cells[3,156] :=form1.SpeedButton43.caption;
  stringgrid1.cells[3,157] :=form1.SpeedButton44.caption;
  stringgrid1.cells[3,158] :=form1.SpeedButton45.caption;
  stringgrid1.cells[3,159] :=form1.SpeedButton48.caption;
  stringgrid1.cells[3,160] :=form1.SpeedButton49.caption;
  stringgrid1.cells[3,161] :=form1.SpeedButton50.caption;
  stringgrid1.cells[3,162] :=form1.SpeedButton51.caption;
  stringgrid1.cells[3,163] :=form1.SpeedButton52.caption;
  stringgrid1.cells[3,164] :=form1.SpeedButton53.caption;
  stringgrid1.cells[3,165] :=form1.SpeedButton54.caption;
  stringgrid1.cells[3,166] :=form1.SpeedButton55.caption;
  stringgrid1.cells[3,167] :=form1.SpeedButton56.caption;
  stringgrid1.cells[3,168] :=form1.SpeedButton57.caption;
  stringgrid1.cells[3,169] :=form1.SpeedButton58.caption;
  stringgrid1.cells[3,170] :=form1.SpeedButton59.caption;
  stringgrid1.cells[3,171] :=form1.SpeedButton60.caption;
  stringgrid1.cells[3,172] :=form1.SpeedButton61.caption;
  stringgrid1.cells[3,173] :=form1.SpeedButton62.caption;
  stringgrid1.cells[3,174] :=form1.SpeedButton63.caption;
  stringgrid1.cells[3,175] :=form1.SpeedButton64.caption;
  stringgrid1.cells[3,176] :=form1.SpeedButton65.caption;
  stringgrid1.cells[3,177] :=form1.SpeedButton9.caption;
  stringgrid1.cells[3,178] :=form1.SpeedButton12.hint;
  stringgrid1.cells[3,179] :=form1.SpeedButton13.hint;
  stringgrid1.cells[3,180] :=form1.SpeedButton14.hint;
  stringgrid1.cells[3,181] :=form1.SpeedButton15.hint;
  stringgrid1.cells[3,182] :=form1.SpeedButton16.hint;
  stringgrid1.cells[3,183] :=form1.checkbox3.Caption;
  stringgrid1.cells[3,184] :=form1.SpeedButton18.hint;
  stringgrid1.cells[3,185] :=form1.SpeedButton19.hint;
  stringgrid1.cells[3,186] :=form1.SpeedButton20.hint;
  stringgrid1.cells[3,187] :=form1.SpeedButton21.hint;
  stringgrid1.cells[3,188] :=form1.SpeedButton22.hint;
  stringgrid1.cells[3,189] :=form1.SpeedButton23.hint;
  stringgrid1.cells[3,190] :=form1.SpeedButton24.hint;
  stringgrid1.cells[3,191] :=form1.krl.hint;
  stringgrid1.cells[3,192] :=form1.SpeedButton26.hint;
  stringgrid1.cells[3,193] :=form1.SpeedButton27.hint;
  stringgrid1.cells[3,194] :=form1.SpeedButton28.hint;
  stringgrid1.cells[3,195] :=form1.SpeedButton29.hint;
  stringgrid1.cells[3,196] :=form1.SpeedButton30.hint;
  stringgrid1.cells[3,197] :=form1.SpeedButton31.hint;
  stringgrid1.cells[3,198] :=form1.SpeedButton32.hint;
  stringgrid1.cells[3,199] :=form1.SpeedButton33.hint;
  stringgrid1.cells[3,200] :=form1.SpeedButton34.hint;
  stringgrid1.cells[3,201] :=form1.SpeedButton35.hint;
  stringgrid1.cells[3,202] :=form1.SpeedButton36.hint;
  stringgrid1.cells[3,203] :=form1.SpeedButton37.hint;
  stringgrid1.cells[3,204] :=form1.SpeedButton38.hint;
  stringgrid1.cells[3,205] :=form1.SpeedButton39.hint;
  stringgrid1.cells[3,206] :=form1.SpeedButton4.hint;
  stringgrid1.cells[3,207] :=form1.SpeedButton40.hint;
  stringgrid1.cells[3,208] :=form1.SpeedButton41.hint;
  stringgrid1.cells[3,209] :=form1.SpeedButton42.hint;
  stringgrid1.cells[3,210] :=form1.SpeedButton43.hint;
  stringgrid1.cells[3,211] :=form1.SpeedButton44.hint;
  stringgrid1.cells[3,212] :=form1.SpeedButton45.hint;
  stringgrid1.cells[3,213] :=form1.SpeedButton48.hint;
  stringgrid1.cells[3,214] :=form1.SpeedButton49.hint;
  stringgrid1.cells[3,215] :=form1.SpeedButton50.hint;
  stringgrid1.cells[3,216] :=form1.SpeedButton51.hint;
  stringgrid1.cells[3,217] :=form1.SpeedButton52.hint;
  stringgrid1.cells[3,218] :=form1.SpeedButton53.hint;
  stringgrid1.cells[3,219] :=form1.SpeedButton54.hint;
  stringgrid1.cells[3,220] :=form1.SpeedButton55.hint;
  stringgrid1.cells[3,221] :=form1.SpeedButton56.hint;
  stringgrid1.cells[3,222] :=form1.SpeedButton57.hint;
  stringgrid1.cells[3,223] :=form1.SpeedButton58.hint;
  stringgrid1.cells[3,224] :=form1.SpeedButton59.hint;
  stringgrid1.cells[3,225] :=form1.SpeedButton60.hint;
  stringgrid1.cells[3,226] :=form1.SpeedButton61.hint;
  stringgrid1.cells[3,227] :=form1.SpeedButton62.hint;
  stringgrid1.cells[3,228] :=form1.SpeedButton63.hint;
  stringgrid1.cells[3,229] :=form1.SpeedButton64.hint;
  stringgrid1.cells[3,230] :=form1.SpeedButton65.hint;
  stringgrid1.cells[3,231] :=form1.SpeedButton9.hint;
  stringgrid1.cells[3,232] :=form1.StatusBarx2.panels[0].text;
  stringgrid1.cells[3,233] :=form1.StatusBarx2.panels[2].text;
  stringgrid1.cells[3,234] :=form1.StatusBarx2.panels[4].text;
  stringgrid1.cells[3,235] :=form1.StringGrid1.columns[4].title.caption;
  stringgrid1.cells[3,236] :=form1.StringGrid1.columns[5].title.caption;
  stringgrid1.cells[3,237] :=form1.StringGrid1.columns[6].title.caption;
  stringgrid1.cells[3,238] :=form1.StringGrid1.columns[7].title.caption;
  stringgrid1.cells[3,239] :=form1.StringGrid1.columns[8].title.caption;
  stringgrid1.cells[3,240] :=form1.StringGrid1.columns[9].title.caption;
//  Search History. SHIS. SH1
  stringgrid1.cells[3,241] := shis.Button1.Caption;
  stringgrid1.cells[3,242] := shis.Button2.Caption;
  stringgrid1.cells[3,243] := shis.Button3.Caption;
  stringgrid1.cells[3,244] := shis.Button4.Caption;
  stringgrid1.cells[3,248] := shis.SaveDialog1.title;
  stringgrid1.cells[3,249] := Shis.Caption;
  stringgrid1.cells[3,245] := shis.StatusBar1.Panels[0].Text;
  stringgrid1.cells[3,246] := shis.StatusBar1.Panels[2].Text;
  stringgrid1.cells[3,247] := shis.StringGrid1.Columns[2].Title.Caption;
  stringgrid1.cells[3,250] := shis.StringGrid1.Columns[3].Title.Caption;
//Converter
  stringgrid1.cells[3,251] := dc.Button1.Caption;
  stringgrid1.cells[3,252] := dc.Button2.Caption;
  stringgrid1.cells[3,253] := dc.Button3.Caption;
  stringgrid1.cells[3,254] := dc.Button4.Caption;
  stringgrid1.cells[3,255] := dc.Button5.Caption;
  stringgrid1.cells[3,256] := dc.groupbox1.caption;
  stringgrid1.cells[3,257] := dc.groupbox2.caption;
  stringgrid1.cells[3,258] := dc.label1.Caption;
  stringgrid1.cells[3,259] := dc.speedbutton1.caption;
  stringgrid1.cells[3,260] := dc.speedbutton2.caption;
  stringgrid1.cells[3,261] := dc.speedbutton3.caption;
  stringgrid1.cells[3,262] := dc.speedbutton4.caption;
  stringgrid1.cells[3,263] := dc.speedbutton5.caption;
  stringgrid1.cells[3,264] := dc.speedbutton6.caption;
  stringgrid1.cells[3,265] := '';
  stringgrid1.cells[3,266] := dc.speedbutton8.caption;
  stringgrid1.cells[3,267] := dc.speedbutton9.caption;
  stringgrid1.cells[3,268] := dc.speedbutton10.caption;
  stringgrid1.cells[3,269] := dc.speedbutton11.caption;
  stringgrid1.cells[3,270] := dc.Caption;
  stringgrid1.cells[3,271] := dc.StatusBar1.Panels[0].TEXt;
  stringgrid1.cells[3,272] := dc.StatusBar1.Panels[2].TEXt;
  stringgrid1.cells[3,273] := dc.speedbutton1.hint;
  stringgrid1.cells[3,274] := dc.speedbutton2.hint;
  stringgrid1.cells[3,275] := dc.speedbutton3.hint;
  stringgrid1.cells[3,276] := dc.speedbutton4.hint;
  stringgrid1.cells[3,277] := dc.speedbutton5.hint;
  stringgrid1.cells[3,278] := dc.speedbutton6.hint;
  stringgrid1.cells[3,279] := '';
  stringgrid1.cells[3,280] := dc.speedbutton8.hint;
  stringgrid1.cells[3,281] := dc.speedbutton9.hint;
  stringgrid1.cells[3,282] := dc.speedbutton10.hint;
  stringgrid1.cells[3,283] := dc.speedbutton11.hint;
  stringgrid1.cells[3,284] := dc.button6.Caption;
  stringgrid1.cells[3,285] := dc.MS2;
  stringgrid1.cells[3,286] := dc.MSC1;
  stringgrid1.cells[3,287] := dc.MSC2;
//Lex2_Form7
  stringgrid1.cells[3,288] := form7.Caption;
  stringgrid1.cells[3,289] := form7.Button1.Caption;
  stringgrid1.cells[3,290] := form7.Button2.Caption;
  stringgrid1.cells[3,291] := form7.Button1.hint;
  stringgrid1.cells[3,292] := form7.Button2.hint;
  stringgrid1.cells[3,293] := form7.checklistbox1.Hint;
  stringgrid1.cells[3,294] := form7.MenuItem1.Caption;
  stringgrid1.cells[3,295] := form7.MenuItem2.Caption;
  stringgrid1.cells[3,296] := form7.MenuItem3.Caption;
  stringgrid1.cells[3,297] := form7.StatusBar1.Panels[0].Text;
// TEMA1 298 323

  stringgrid1.cells[3,298] := tema.Button10.Caption;
  stringgrid1.cells[3,299] := tema.Button7.Caption;
  stringgrid1.cells[3,300] := tema.Button9.Caption;
  stringgrid1.cells[3,301] := tema.CheckBox1.Caption;
  stringgrid1.cells[3,302] := tema.CheckBox2.Caption;
  stringgrid1.cells[3,303] := tema.CheckBox3.Caption;
  stringgrid1.cells[3,304] := tema.CheckBox4.Caption;
  stringgrid1.cells[3,305] := tema.CheckBox5.Caption;
  stringgrid1.cells[3,306] := tema.CheckBox6.Caption;
  stringgrid1.cells[3,307] := tema.GroupBox1.Caption;
  stringgrid1.cells[3,308] := tema.GroupBox2.Caption;
  stringgrid1.cells[3,309] := tema.ComboBox1.Items.CommaText;
  stringgrid1.cells[3,310] := tema.Label1.Caption;
  stringgrid1.cells[3,311] := tema.Label2.Caption;
  stringgrid1.cells[3,312] := tema.Label3.Caption;
  stringgrid1.cells[3,313] := tema.Label4.Caption;
  stringgrid1.cells[3,314] := tema.MenuItem1.Caption;
  stringgrid1.cells[3,315] := tema.MenuItem2.Caption;
  stringgrid1.cells[3,316] := tema.MenuItem4.Caption;
  stringgrid1.cells[3,317] := tema.MenuItem5.Caption;
  stringgrid1.cells[3,318] := tema.MenuItem7.Caption;
  stringgrid1.cells[3,319] := tema.speedbutton8.Caption;
  stringgrid1.cells[3,320] := tema.stringgrid1.Columns[0].Title.Caption;
  stringgrid1.cells[3,321] := tema.stringgrid1.Columns[1].Title.Caption;
  stringgrid1.cells[3,322] := tema.stringgrid1.Columns[2].Title.Caption;
  stringgrid1.cells[3,323] := tema.Caption;
//RESFORM (Reult1.pas)


  stringgrid1.cells[3,324] := resform.checkbox1.caption;//Button1.Caption;
  stringgrid1.cells[3,325] := resform.CheckBox3.Caption;
  stringgrid1.cells[3,326] := resform.Caption;
  stringgrid1.cells[3,327] := resform.Edit1.TextHint;
  stringgrid1.cells[3,328] := resform.editbutton1.TextHint;
  stringgrid1.cells[3,329] := resform.edit2.TextHint;
  stringgrid1.cells[3,330] := resform.Label1.Caption;
//  stringgrid1.cells[3,331] := resform.Label2.Caption;
  stringgrid1.cells[3,332] :=   resform.MenuItem1.Caption;
  stringgrid1.cells[3,333] :=   resform.MenuItem2.Caption;
  stringgrid1.cells[3,334] :=   resform.MenuItem3.Caption;
  stringgrid1.cells[3,335] :=   resform.M95.Caption;
  stringgrid1.cells[3,336] :=   resform.MenuItem6.Caption;
  stringgrid1.cells[3,337] :=   resform.MenuItem9.Caption;
  stringgrid1.cells[3,338] :=   resform.MenuItem10.Caption;
  stringgrid1.cells[3,339] :=   resform.MenuItem11.Caption;
  stringgrid1.cells[3,340] :=   resform.MenuItem12.Caption;
  stringgrid1.cells[3,341] :=   resform.MenuItem13.Caption;
  stringgrid1.cells[3,342] :=   resform.MenuItem14.Caption;
  stringgrid1.cells[3,343] :=   dcs1.CheckBox4.Caption;
  stringgrid1.cells[3,344] :=   resform.MenuItem16.Caption;
  stringgrid1.cells[3,345] :=   resform.MenuItem17.Caption;
  stringgrid1.cells[3,346] :=   resform.MenuItem18.Caption;
  stringgrid1.cells[3,347] :=   resform.MenuItem19.Caption;
  stringgrid1.cells[3,348] :=   resform.statusbar1.Panels[0].text;
  stringgrid1.cells[3,349] :=   resform.m95.Hint;
//SSV


  stringgrid1.cells[3,350] := rdr.label1.hint;
  stringgrid1.cells[3,351] := rdr.label6.hint;
  stringgrid1.cells[3,352] := rdr.label12.hint;
  stringgrid1.cells[3,353] := rdr.label13.hint;
  stringgrid1.cells[3,354] := rdr.label14.hint;
  stringgrid1.cells[3,355] := rdr.label15.hint;

  stringgrid1.cells[3,356] := rdr.label6.hint;
  stringgrid1.cells[3,357] := rdr.speedbutton1.Hint;
  stringgrid1.cells[3,358] := rdr.r1;
  stringgrid1.cells[3,359] := rdr.r2;
  stringgrid1.cells[3,360] := rdr.r3;
  stringgrid1.cells[3,361] := rdr.r4;
  stringgrid1.cells[3,362] := rdr.r5;
//DCS

  stringgrid1.cells[3,363] :=  dcs1.Label1.Caption;
  stringgrid1.cells[3,364] :=  dcs1.Label2.Caption;
  stringgrid1.cells[3,365] :=  dcs1.Label3.Caption;
  stringgrid1.cells[3,366] :=  dcs1.Label4.Caption;
//  stringgrid1.cells[3,367] :=  dcs1.Label5.Caption;
  stringgrid1.cells[3,368] :=  dcs1.Label6.Caption;
  stringgrid1.cells[3,369] :=  dcs1.Label7.Caption;
  stringgrid1.cells[3,370] :=  dcs1.speedbutton1.Caption;
  stringgrid1.cells[3,371] :=  dcs1.speedbutton2.Caption;
  stringgrid1.cells[3,372] :=  dcs1.speedbutton3.Caption;
  stringgrid1.cells[3,373] :=  dcs1.speedbutton4.Caption;
  stringgrid1.cells[3,374] :=  dcs1.speedbutton5.Caption;
  stringgrid1.cells[3,375] :=  dcs1.speedbutton6.Caption;
  stringgrid1.cells[3,376] :=  dcs1.GroupBox1.Caption;
//  stringgrid1.cells[3,377] :=  dcs1.Image1.Hint;
//  stringgrid1.cells[3,378] :=  dcs1.Image1.Hint;
  stringgrid1.cells[3,379] :=  form1.krl.Caption;
  stringgrid1.cells[3,380] :=  dcs1.speedbutton8.Caption;
//  stringgrid1.cells[3,381] :=  dcs1.speedbutton9.Caption;
  stringgrid1.cells[3,382] :=  dcs1.speedbutton10.Caption;
  stringgrid1.cells[3,383] :=  dcs1.speedbutton11.hint;
  stringgrid1.cells[3,384] :=  dcs1.speedbutton12.Caption;
  stringgrid1.cells[3,385] :=  dcs1.speedbutton13.Caption;
  stringgrid1.cells[3,386] :=  dcs1.speedbutton14.Caption;
  stringgrid1.cells[3,387] :=  dcs1.StatusBar1.Panels[0].Text;
  stringgrid1.cells[3,388] :=  dcs1.StatusBar1.Panels[2].Text;
  stringgrid1.cells[3,389] :=  dcs1.Caption;
//KN
  stringgrid1.cells[3,390] := kkn.Label1.Caption;
  stringgrid1.cells[3,391] := kkn.Groupbox1.Caption;
  stringgrid1.cells[3,392] := kkn.Label3.Caption;
  stringgrid1.cells[3,393] := kkn.Label4.Caption;
  stringgrid1.cells[3,394] := kkn.combobox2.Items.CommaText;
  stringgrid1.cells[3,395] := kkn.Button5.Caption;
  stringgrid1.cells[3,396] := kkn.ComboBox1.Items.CommaText;
  stringgrid1.cells[3,397] := kkn.Button3.Caption;
  stringgrid1.cells[3,398] := kkn.Button2.Caption;
  stringgrid1.cells[3,399] := kkn.Button1.Caption;
  stringgrid1.cells[3,400] := kkn.Caption;
  stringgrid1.cells[3,401] := kkn.StatusBar1.Panels[0].Text;
  stringgrid1.cells[3,402] := kkn.StatusBar1.Panels[2].Text;
  stringgrid1.cells[3,403] := kkn.ComboBox_.Items.CommaText;
//Ched
   stringgrid1.cells[3,404] := chd.Button1.Caption;
   stringgrid1.cells[3,405] := chd.Label2.Caption;
   stringgrid1.cells[3,406] := chd.Label3.Caption;
   stringgrid1.cells[3,407] := chd.Label4.Caption;
   stringgrid1.cells[3,408] := chd.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,409] := chd.StatusBar1.Panels[2].Text;
   stringgrid1.cells[3,410] := chd.StatusBar2.Panels[0].Text;
   stringgrid1.cells[3,411] := chd.StatusBar2.Panels[2].Text;
   stringgrid1.cells[3,412] := chd.StatusBar3.Panels[0].Text;
   stringgrid1.cells[3,413] := chd.StatusBar3.Panels[2].Text;
   stringgrid1.cells[3,414] := chd.GroupBox1.Caption;
   stringgrid1.cells[3,415] := chd.caption;
   stringgrid1.cells[3,416] := chd.ComboBox2.Items.CommaText;
//VD1_Verdir
   stringgrid1.cells[3,417] := verdir.Edit1.TextHint;
   stringgrid1.cells[3,418] := verdir.label1.Caption;
   stringgrid1.cells[3,419] := verdir.label2.Caption;
   stringgrid1.cells[3,420] := verdir.label3.Caption;
   stringgrid1.cells[3,421] := verdir.label4.Caption;
   stringgrid1.cells[3,422] := verdir.label5.Caption;
   stringgrid1.cells[3,423] := verdir.label6.Caption;
   stringgrid1.cells[3,424] := verdir.label7.Caption;
   stringgrid1.cells[3,425] := verdir.SpeedButton1.Caption;
   stringgrid1.cells[3,426] := verdir.SpeedButton4.hint;
   stringgrid1.cells[3,427] := verdir.SpeedButton2.Caption;
   stringgrid1.cells[3,428] := verdir.Caption;
   stringgrid1.cells[3,429] := verdir.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,430] := verdir.StatusBar1.Panels[2].Text;
   stringgrid1.cells[3,431] := verdir.StringGrid2.Columns[0].Title.Caption;
   stringgrid1.cells[3,432] := verdir.StringGrid2.Columns[1].Title.Caption;
   stringgrid1.cells[3,433] := verdir.StringGrid2.Columns[2].Title.Caption;
   stringgrid1.cells[3,434] := verdir.StringGrid2.Columns[3].Title.Caption;
   stringgrid1.cells[3,435] := verdir.StringGrid2.Columns[4].Title.Caption;
   stringgrid1.cells[3,436] := verdir.StringGrid2.Columns[5].Title.Caption;
   stringgrid1.cells[3,437] := verdir.StringGrid2.Columns[6].Title.Caption;
   stringgrid1.cells[3,438] := verdir.StringGrid2.Columns[7].Title.Caption;
   stringgrid1.cells[3,439] := verdir.StringGrid2.Columns[8].Title.Caption;
   stringgrid1.cells[3,440] := verdir.StringGrid2.Columns[9].Title.Caption;
   stringgrid1.cells[3,441] := verdir.StringGrid2.Columns[10].Title.Caption;
//Edepo

   stringgrid1.cells[3,442] := ED.ComboBox1.Items.CommaText;
   stringgrid1.cells[3,443] := Ed.EditButton1.TextHint;
   stringgrid1.cells[3,444] := ed.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,445] := ed.Caption;
// WordReferences WRF
   stringgrid1.cells[3,446] :=  wr.Button1.Caption;
   stringgrid1.cells[3,447] :=  wr.Button2.Caption;
   stringgrid1.cells[3,448] :=  wr.Button3.Caption;
   stringgrid1.cells[3,449] :=  wr.Label1.Caption;
   stringgrid1.cells[3,450] :=  wr.Label2.Caption;
   stringgrid1.cells[3,451] :=  wr.Label3.Caption;
   stringgrid1.cells[3,452] :=  wr.MenuItem1.Caption;
   stringgrid1.cells[3,453] :=  wr.MenuItem2.Caption;
   stringgrid1.cells[3,454] :=  wr.MenuItem3.Caption;
   stringgrid1.cells[3,455] :=  wr.MenuItem4.Caption;
   stringgrid1.cells[3,456] :=  wr.MenuItem5.Caption;
   stringgrid1.cells[3,457] :=  wr.MenuItem6.Caption;
   stringgrid1.cells[3,458] :=  wr.MenuItem7.Caption;
   stringgrid1.cells[3,459] :=  wr.MenuItem8.Caption;
   stringgrid1.cells[3,460] :=  wr.MenuItem9.Caption;
   stringgrid1.cells[3,461] :=  wr.MenuItem10.Caption;
   stringgrid1.cells[3,462] :=  wr.caption;
   stringgrid1.cells[3,463] :=  wr.MenuItem12.Caption;
   stringgrid1.cells[3,464] :=  wr.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,465] :=  wr.StatusBar1.Panels[2].Text;
   stringgrid1.cells[3,466] :=  wr.StatusBar1.Panels[4].Text;
   stringgrid1.cells[3,467] :=  wr.StringGrid1.Columns[10].Title.Caption;
   stringgrid1.cells[3,468] :=  wr.StringGrid1.Columns[12].Title.Caption;
   stringgrid1.cells[3,469] :=  wr.StringGrid1.Columns[13].Title.Caption;
   stringgrid1.cells[3,470] :=  wr.StringGrid1.Columns[14].Title.Caption;
//LNS

   stringgrid1.cells[3,471] := lns.Button1.Caption;
   stringgrid1.cells[3,472] := lns.Button4.Caption;
   stringgrid1.cells[3,473] := lns.Label1.Caption;
   stringgrid1.cells[3,474] := lns.Label2.Caption;
   stringgrid1.cells[3,475] := lns.MenuItem1.Caption;
   stringgrid1.cells[3,476] := lns.MenuItem2.Caption;
   stringgrid1.cells[3,477] := lns.MenuItem3.Caption;
   stringgrid1.cells[3,478] := lns.MenuItem4.Caption;
   stringgrid1.cells[3,479] := lns.MenuItem5.Caption;
   stringgrid1.cells[3,480] := lns.MenuItem6.Caption;
   stringgrid1.cells[3,481] := lns.MenuItem7.Caption;
   stringgrid1.cells[3,482] := lns.MenuItem8.Caption;
   stringgrid1.cells[3,483] := lns.MenuItem9.Caption;
   stringgrid1.cells[3,484] := lns.MenuItem10.Caption;
   stringgrid1.cells[3,485] := lns.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,486] := lns.StatusBar1.Panels[2].Text;
   stringgrid1.cells[3,487] := lns.StatusBar1.Panels[4].Text;
   stringgrid1.cells[3,488] := lns.StringGrid1.Columns[0].Title.Caption;
   stringgrid1.cells[3,489] := lns.StringGrid1.Columns[1].Title.Caption;
   stringgrid1.cells[3,490] := lns.StringGrid1.Columns[3].Title.Caption;
   stringgrid1.cells[3,491] := lns.StringGrid1.Columns[4].Title.Caption;
   stringgrid1.cells[3,492] := lns.StringGrid1.Columns[5].Title.Caption;
   stringgrid1.cells[3,493] := lns.StringGrid1.Columns[2].Title.Caption;
   stringgrid1.cells[3,494] := lns.Caption;
// Repo1

   stringgrid1.cells[3,495] :=   tz.Button1.Caption;
   stringgrid1.cells[3,496] :=   tz.Button2.Caption;
   stringgrid1.cells[3,497] :=   tz.Button3.Caption;
   stringgrid1.cells[3,498] :=   tz.Button4.Caption;
   stringgrid1.cells[3,499] :=   tz.Button5.Caption;
   stringgrid1.cells[3,500] :=   tz.Button9.Caption;
   stringgrid1.cells[3,501] :=   tz.Label1.Caption;
   stringgrid1.cells[3,502] :=   tz.MenuItem1.Caption;
   stringgrid1.cells[3,503] :=   tz.MenuItem2.Caption;
   stringgrid1.cells[3,504] :=   tz.MenuItem3.Caption;
   stringgrid1.cells[3,505] :=   tz.MenuItem4.Caption;
   stringgrid1.cells[3,506] :=   tz.MenuItem5.Caption;
   stringgrid1.cells[3,507] :=   tz.MenuItem6.Caption;
   stringgrid1.cells[3,508] :=   tz.MenuItem7.Caption;
   stringgrid1.cells[3,509] :=   tz.MenuItem8.Caption;
   stringgrid1.cells[3,510] :=   tz.MenuItem9.Caption;
   stringgrid1.cells[3,511] :=   tz.MenuItem10.Caption;
   stringgrid1.cells[3,512] :=   tz.MenuItem11.Caption;
   stringgrid1.cells[3,513] :=   tz.MenuItem12.Caption;
   stringgrid1.cells[3,514] :=   tz.MenuItem13.Caption;
   stringgrid1.cells[3,515] :=   tz.MenuItem14.Caption;
   stringgrid1.cells[3,516] :=   tz.MenuItem15.Caption;
   stringgrid1.cells[3,517] :=   tz.MenuItem16.Caption;
   stringgrid1.cells[3,518] :=   tz.MenuItem17.Caption;
   stringgrid1.cells[3,519] :=   tz.MenuItem18.Caption;
   stringgrid1.cells[3,520] :=   tz.MenuItem19.Caption;
   stringgrid1.cells[3,521] :=   tz.MenuItem20.Caption;
   stringgrid1.cells[3,522] :=   tz.MenuItem21.Caption;
   stringgrid1.cells[3,523] :=   tz.MenuItem22.Caption;
   stringgrid1.cells[3,524] :=   tz.TabSheet1.Caption;
   stringgrid1.cells[3,525] :=   tz.TabSheet2.Caption;
   stringgrid1.cells[3,526] :=   tz.Panel14.Caption;
   stringgrid1.cells[3,527] :=   tz.Panel15.Caption;
   stringgrid1.cells[3,528] :=   tz.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,529] :=   tz.StatusBar1.Panels[2].Text;
   stringgrid1.cells[3,530] :=   tz.StatusBar2.Panels[0].Text;
   stringgrid1.cells[3,531] :=   tz.StatusBar2.Panels[2].Text;
   stringgrid1.cells[3,532] :=   tz.Caption;
   stringgrid1.cells[3,533] :=   tz.StringGrid1.Columns[0].Title.Caption;
   stringgrid1.cells[3,534] :=   tz.StringGrid1.Columns[1].Title.Caption;
   stringgrid1.cells[3,535] :=   tz.StringGrid1.Columns[2].Title.Caption;
   stringgrid1.cells[3,536] :=   tz.StringGrid1.Columns[3].Title.Caption;
   stringgrid1.cells[3,537] :=   tz.StringGrid1.Columns[4].Title.Caption;
   stringgrid1.cells[3,538] :=   tz.StringGrid1.Columns[5].Title.Caption;
   stringgrid1.cells[3,539] :=   tz.StringGrid2.Columns[0].Title.Caption;
   stringgrid1.cells[3,540] :=   tz.StringGrid2.Columns[1].Title.Caption;
   stringgrid1.cells[3,541] :=   tz.StringGrid2.Columns[2].Title.Caption;
   stringgrid1.cells[3,542] :=   tz.StringGrid2.Columns[3].Title.Caption;
   stringgrid1.cells[3,543] :=   tz.StringGrid2.Columns[4].Title.Caption;
   stringgrid1.cells[3,544] :=   tz.StringGrid2.Columns[5].Title.Caption;
   stringgrid1.cells[3,545] :=   tz.StringGrid2.Columns[6].Title.Caption;
//FRS
;
   stringgrid1.cells[3,546] :=  fr.Label4.Caption;
   stringgrid1.cells[3,547] :=  fr.Edit1.TextHint;
   stringgrid1.cells[3,548] :=  fr.Edit2.TextHint;
   stringgrid1.cells[3,549] :=  fr.SpeedButton1.Caption;
   stringgrid1.cells[3,550] :=  fr.SpeedButton2.Caption;
   stringgrid1.cells[3,551] :=  fr.Caption;
   stringgrid1.cells[3,552] :=  fr.MenuItem1.Caption;
   stringgrid1.cells[3,553] :=  fr.MenuItem2.Caption;
   stringgrid1.cells[3,554] :=  fr.MenuItem3.Caption;
   stringgrid1.cells[3,555] :=  fr.MenuItem4.Caption;
   stringgrid1.cells[3,556] :=  fr.MenuItem5.Caption;
   stringgrid1.cells[3,557] :=  fr.MenuItem6.Caption;
   stringgrid1.cells[3,558] :=  fr.MenuItem7.Caption;
   stringgrid1.cells[3,559] :=  fr.MenuItem8.Caption;
   stringgrid1.cells[3,560] :=  fr.MenuItem9.Caption;
   stringgrid1.cells[3,561] :=  fr.ComboBox1.Items.CommaText;
   stringgrid1.cells[3,562] :=  fr.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,563] :=  fr.StatusBar1.Panels[2].Text;
   stringgrid1.cells[3,564] :=  fr.StringGrid2.Columns[2].Title.Caption;
   stringgrid1.cells[3,565] :=  fr.StringGrid2.Columns[3].Title.Caption;
   stringgrid1.cells[3,566] :=  fr.StringGrid2.Columns[4].Title.Caption;
   stringgrid1.cells[3,567] :=  fr.StringGrid2.Columns[5].Title.Caption;
   stringgrid1.cells[3,568] :=  fr.StringGrid2.Columns[6].Title.Caption;
//syn
   stringgrid1.cells[3,569] :=  form4.Caption;
   stringgrid1.cells[3,570] :=  form4.Edit1.TextHint;
   stringgrid1.cells[3,571] :=  form4.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,572] :=  form4.StringGrid2.columns[0].Title.Caption;
//DF
   stringgrid1.cells[3,573] :=  form3.Caption;
   stringgrid1.cells[3,574] :=  form3.MenuItem1.Caption;
   stringgrid1.cells[3,575] :=  form3.MenuItem2.Caption;
   stringgrid1.cells[3,576] :=  form3.MenuItem3.Caption;
   stringgrid1.cells[3,577] :=  form3.MenuItem4.Caption;
   stringgrid1.cells[3,578] :=  form3.MenuItem5.Caption;
   stringgrid1.cells[3,579] :=  form3.MenuItem6.Caption;
   stringgrid1.cells[3,580] :=  form3.MenuItem7.Caption;
   stringgrid1.cells[3,581] :=  form3.MenuItem8.Caption;
   stringgrid1.cells[3,582] :=  form3.MenuItem9.Caption;
   stringgrid1.cells[3,583] :=  form3.MenuItem10.Caption;
   stringgrid1.cells[3,584] :=  form3.MenuItem11.Caption;
   stringgrid1.cells[3,585] :=  form3.MenuItem12.Caption;
   stringgrid1.cells[3,586] :=  form3.MenuItem13.Caption;
   stringgrid1.cells[3,587] :=  form3.MenuItem14.Caption;
   stringgrid1.cells[3,588] :=  form3.Panel4.Caption;
   stringgrid1.cells[3,589] :=  form3.SpeedButton2.Caption;
   stringgrid1.cells[3,590] :=  form3.SpeedButton4.Caption;
   stringgrid1.cells[3,591] :=  form3.SpeedButton5.Caption;
   stringgrid1.cells[3,592] :=  form3.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,593] :=  form3.StatusBar1.Panels[2].Text;
   stringgrid1.cells[3,594] :=  form3.StatusBar1.Panels[4].Text;
   stringgrid1.cells[3,595] :=  form3.StringGrid1.Columns[0].Title.Caption;
   stringgrid1.cells[3,596] :=  form3.StringGrid1.Columns[1].Title.Caption;
   stringgrid1.cells[3,597] :=  form3.StringGrid1.Columns[2].Title.Caption;
   stringgrid1.cells[3,598] :=  form3.StringGrid2.Columns[0].Title.Caption;
   stringgrid1.cells[3,599] :=  form3.StringGrid2.Columns[1].Title.Caption;
   stringgrid1.cells[3,600] :=  form3.StringGrid2.Columns[2].Title.Caption;
   stringgrid1.cells[3,601] :=  form3.Edit1.TextHint;
   stringgrid1.cells[3,602] :=  form3.ComboBox1.Items.CommaText;
//TSN
   stringgrid1.cells[3,603] := sinta.Caption;
   stringgrid1.cells[3,604] := sinta.Button1.Caption;
   stringgrid1.cells[3,605] := sinta.StringGrid1.Columns[0].Title.Caption;
   stringgrid1.cells[3,606] := sinta.StringGrid1.Columns[1].Title.Caption;
//WTC
   stringgrid1.cells[3,607] :=  wt1.Button1.Caption;
   stringgrid1.cells[3,608] :=  wt1.Button2.Caption;
   stringgrid1.cells[3,609] :=  wt1.Caption;
   stringgrid1.cells[3,610] :=  wt1.StringGrid4.cells[0,0];
   stringgrid1.cells[3,611] :=  wt1.StringGrid4.cells[1,0];
   stringgrid1.cells[3,612] :=  wt1.StringGrid1.Columns[0].Title.Caption;
   stringgrid1.cells[3,613] :=  wt1.StringGrid1.Columns[1].Title.Caption;
   stringgrid1.cells[3,614] :=  wt1.StringGrid1.Columns[2].Title.Caption;
//Keybrd
   stringgrid1.cells[3,615] :=  symba.Caption;
   stringgrid1.cells[3,616] :=  symba.CheckBox1.Caption;
   stringgrid1.cells[3,617] :=  symba.CheckBox2.Caption;
   stringgrid1.cells[3,618] :=  symba.CheckBox3.Caption;
   stringgrid1.cells[3,619] :=  symba.GroupBox1.Caption;
   stringgrid1.cells[3,620] :=  symba.MenuItem1.Caption;
   stringgrid1.cells[3,621] :=  symba.MenuItem2.Caption;
   stringgrid1.cells[3,622] :=  symba.MenuItem3.Caption;
   stringgrid1.cells[3,623] :=  symba.MenuItem4.Caption;
   stringgrid1.cells[3,624] :=  symba.MenuItem5.Caption;
   stringgrid1.cells[3,625] :=  symba.MenuItem6.Caption;
   stringgrid1.cells[3,626] :=  symba.MenuItem7.Caption;
//SFO

   stringgrid1.cells[3,627] :=  sf.Caption;
   stringgrid1.cells[3,628] :=  sf.Label4.Caption;
   stringgrid1.cells[3,629] :=  sf.Label5.Caption;
   stringgrid1.cells[3,630] :=  sf.Label6.Caption;
   stringgrid1.cells[3,631] :=  sf.Label7.Caption;
   stringgrid1.cells[3,632] :=  sf.Label8.Caption;
   stringgrid1.cells[3,633] :=  sf.Label9.Caption;
   stringgrid1.cells[3,634] :=  sf.Button1.Caption;
//LGG
   stringgrid1.cells[3,635] :=  liga.Caption;
   stringgrid1.cells[3,636] :=  liga.Edit1.TextHint;
   stringgrid1.cells[3,637] :=  liga.SpeedButton1.Caption;
   stringgrid1.cells[3,638] :=  liga.SpeedButton2.Caption;
   stringgrid1.cells[3,639] :=  liga.SpeedButton3.Caption;
   stringgrid1.cells[3,640] :=  liga.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,641] :=  liga.StatusBar2.Panels[0].Text;
   stringgrid1.cells[3,642] :=  liga.StatusBar3.Panels[0].Text;
   stringgrid1.cells[3,643] :=  liga.StatusBar4.Panels[0].Text;
   stringgrid1.cells[3,644] :=  liga.StatusBar5.Panels[0].Text;
   stringgrid1.cells[3,645] :=  liga.ComboBox1.Items.CommaText;
   stringgrid1.cells[3,646] :=  liga.TabSheet1.Caption;
   stringgrid1.cells[3,647] :=  liga.TabSheet2.Caption;
   stringgrid1.cells[3,648] :=  liga.TabSheet3.Caption;
   stringgrid1.cells[3,649] :=  liga.TabSheet4.Caption;
   stringgrid1.cells[3,650] :=  liga.TabSheet5.Caption;
//GFR/GRES

   stringgrid1.cells[3,651] :=  gres.Caption;
   stringgrid1.cells[3,652] :=  gres.Panel1.Caption;
   stringgrid1.cells[3,653] :=  gres.Button1.Caption;
   stringgrid1.cells[3,654] :=  gres.StringGrid1.Columns[0].Title.Caption;
   stringgrid1.cells[3,655] :=  gres.StringGrid1.Columns[1].Title.Caption;
   stringgrid1.cells[3,656] :=  gres.StringGrid1.Columns[2].Title.Caption;
   stringgrid1.cells[3,657] :=  gres.StringGrid1.Columns[3].Title.Caption;
   stringgrid1.cells[3,658] :=  gres.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,659] :=  gres.StatusBar1.Panels[1].Text;
//GRAM/NN
   stringgrid1.cells[3,660] :=  nn.Caption;
   stringgrid1.cells[3,661] :=  nn.EditButton1.TextHint;
   stringgrid1.cells[3,662] :=  nn.EditButton1.ButtonCaption;
   stringgrid1.cells[3,663] :=  nn.ComboBox1.Hint;
   stringgrid1.cells[3,664] :=  nn.ComboBox2.Hint;
   stringgrid1.cells[3,665] :=  nn.ComboBox1.Items.CommaText;
//VER

   stringgrid1.cells[3,666] := vr.Caption;

   stringgrid1.cells[3,667] := vr.ComboBox1.Hint;
   stringgrid1.cells[3,668] := vr.ComboBox2.Hint;
   stringgrid1.cells[3,669] := vr.editbutton1.TextHint;
   stringgrid1.cells[3,670] := vr.editbutton1.Button.Caption;
////////////////

///OF1

   stringgrid1.cells[3,671] :=  of1.Caption;
   stringgrid1.cells[3,672] :=  of1.Label4.Caption;
   stringgrid1.cells[3,673] :=  of1.StringGrid1.Columns[0].Title.Caption;
   stringgrid1.cells[3,674] :=  of1.StringGrid1.Columns[1].Title.Caption;
   stringgrid1.cells[3,675] :=  of1.StringGrid1.Columns[2].Title.Caption;
   stringgrid1.cells[3,676] :=  of1.StringGrid1.Columns[3].Title.Caption;
   stringgrid1.cells[3,677] :=  of1.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,678] :=  of1.MenuItem1.Caption;
   stringgrid1.cells[3,679] :=  of1.MenuItem2.Caption;
//Parals

   stringgrid1.cells[3,680] :=  prl.Caption;
   stringgrid1.cells[3,681] :=  prl.Button1.Caption;
   stringgrid1.cells[3,682] :=  prl.Button2.Caption;
   stringgrid1.cells[3,683] :=  prl.Button3.Caption;
   stringgrid1.cells[3,684] :=  prl.Button4.Caption;
   stringgrid1.cells[3,685] :=  prl.Button5.Caption;
   stringgrid1.cells[3,686] :=  prl.StringGrid1.Columns[1].Title.Caption;
   stringgrid1.cells[3,687] :=  prl.StringGrid1.Columns[3].Title.Caption;
   stringgrid1.cells[3,688] :=  prl.StringGrid3.Columns[1].Title.Caption;
   stringgrid1.cells[3,689] :=  prl.StringGrid3.Columns[3].Title.Caption;
   stringgrid1.cells[3,690] :=  prl.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,691] :=  prl.StatusBar1.Panels[2].Text;
   stringgrid1.cells[3,692] :=  prl.StatusBar2.Panels[0].Text;
   stringgrid1.cells[3,693] :=  prl.StatusBar2.Panels[2].Text;
   stringgrid1.cells[3,694] :=  prl.Label1.Caption;
//Sintagma1

   stringgrid1.cells[3,695] :=  sintagma.Caption;
   stringgrid1.cells[3,696] :=  sintagma.MenuItem1.Caption;
   stringgrid1.cells[3,697] :=  sintagma.MenuItem1.hint;
   stringgrid1.cells[3,698] :=  sintagma.MenuItem4.Caption;
   stringgrid1.cells[3,699] :=  sintagma.MenuItem5.Caption;
   stringgrid1.cells[3,700] :=  sintagma.Button1.Caption;
   stringgrid1.cells[3,701] :=  sintagma.Button2.Caption;
   stringgrid1.cells[3,702] :=  sintagma.Edit1.TextHint;
   stringgrid1.cells[3,703] :=  sintagma.Edit2.TextHint;
   stringgrid1.cells[3,704] :=  sintagma.Edit3.TextHint;
   stringgrid1.cells[3,705] :=  sintagma.Edit4.TextHint;
   stringgrid1.cells[3,706] :=  sintagma.Edit5.TextHint;
   stringgrid1.cells[3,707] :=  sintagma.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,708] :=  sintagma.StringGrid2.columns[3].Title.Caption;
   stringgrid1.cells[3,709] :=  sintagma.StringGrid2.columns[4].Title.Caption;
//hlp

   stringgrid1.cells[3,710] :=   hlp.Caption;
   stringgrid1.cells[3,711] :=   hlp.Label1.caption;
   stringgrid1.cells[3,712] :=   hlp.Label3.caption;
   stringgrid1.cells[3,713] :=   hlp.Label4.caption;
   stringgrid1.cells[3,714] :=   hlp.Label5.caption;
   stringgrid1.cells[3,715] :=   hlp.Memo1.Lines.CommaText;
   stringgrid1.cells[3,716] :=   hlp.Memo2.Lines.CommaText;
//params
   stringgrid1.cells[3,717] :=   form8.Caption;
   stringgrid1.cells[3,718] :=   form8.checkbox1.Caption;
   stringgrid1.cells[3,719] :=   form8.checkbox2.Caption;
   stringgrid1.cells[3,720] :=   form8.checkbox3.Caption;
   stringgrid1.cells[3,721] :=   form8.checkbox4.Caption;
   stringgrid1.cells[3,722] :=   form8.checkbox5.Caption;
   stringgrid1.cells[3,723] :=   form8.checkbox6.Caption;
   stringgrid1.cells[3,724] :=   form8.checkbox7.Caption;
   stringgrid1.cells[3,725] :=   form8.checkbox8.Caption;
   stringgrid1.cells[3,726] :=   form8.checkbox9.Caption;
   stringgrid1.cells[3,727] :=   form8.checkbox10.Caption;
   stringgrid1.cells[3,728] :=   form8.checkbox11.Caption;
   stringgrid1.cells[3,729] :=   form8.checkbox12.Caption;
   stringgrid1.cells[3,730] :=   form8.checkbox13.Caption;
   stringgrid1.cells[3,731] :=   form8.checkbox14.Caption;
   stringgrid1.cells[3,732] :=   form8.checkbox15.Caption;
   stringgrid1.cells[3,733] :=   form8.groupbox4.Caption;
   stringgrid1.cells[3,734] :=   form8.Label1.Caption;
   stringgrid1.cells[3,735] :=   form8.Label2.Caption;
   stringgrid1.cells[3,736] :=   form8.Label3.Caption;
   stringgrid1.cells[3,737] :=   form8.Label4.Caption;
   stringgrid1.cells[3,738] :=   form8.Label5.Caption;
   stringgrid1.cells[3,739] :=   form8.Label6.Caption;
   stringgrid1.cells[3,740] :=   form8.Button1.Caption;
   stringgrid1.cells[3,741] :=   form8.Button2.Caption;
   stringgrid1.cells[3,742] :=   form8.Button3.Caption;
   stringgrid1.cells[3,743] :=   form8.Button4.Caption;
//   stringgrid1.cells[3,744] :=   form8.Button5.Caption;
   stringgrid1.cells[3,745] :=   form8.Button6.Caption;
   stringgrid1.cells[3,746] :=   form8.Button7.Caption;
   stringgrid1.cells[3,747] :=   form8.Button8.Caption;
   stringgrid1.cells[3,748] :=   form8.Button9.Caption;
   stringgrid1.cells[3,749] :=   form8.Button10.Caption;
   stringgrid1.cells[3,750] :=   form8.Button11.Caption;
   stringgrid1.cells[3,751] :=   form8.StringGrid1.Columns[0].Title.Caption;
   stringgrid1.cells[3,752] :=   form8.StringGrid1.Columns[1].Title.Caption;
   stringgrid1.cells[3,753] :=   form8.StringGrid1.Columns[2].Title.Caption;

   stringgrid1.cells[3,755] :=   form8.TabSheet1.Caption;
   stringgrid1.cells[3,756] :=   form8.TabSheet2.Caption;
   stringgrid1.cells[3,757] :=   form8.TabSheet3.Caption;
   stringgrid1.cells[3,758] :=   form8.TabSheet4.Caption;
   stringgrid1.cells[3,759] :=   form8.groupbox3.Caption;
   stringgrid1.cells[3,754] :=   form8.button12.Caption;
// RTS
   stringgrid1.cells[3,760] :=   roots.Caption;
   stringgrid1.cells[3,761] :=   roots.Label1.Caption;
   stringgrid1.cells[3,762] :=   roots.SpeedButton1.Caption;
   stringgrid1.cells[3,763] :=   roots.SpeedButton2.Caption;
   stringgrid1.cells[3,764] :=   roots.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,765] :=   roots.Edit1.TextHint;
// STANSA
   stringgrid1.cells[3,766] := sta.Caption;
   stringgrid1.cells[3,767] := sta.Label1.Caption;
   stringgrid1.cells[3,768] := sta.Label2.Caption;
   stringgrid1.cells[3,769] := sta.Label3.Caption;
   stringgrid1.cells[3,770] := sta.StatusBar1.Panels[0].Text;
   stringgrid1.cells[3,771] := sta.StringGrid1.Columns[0].Title.Caption;
   stringgrid1.cells[3,772] := sta.StringGrid1.Columns[1].Title.Caption;
   stringgrid1.cells[3,773] := sta.StringGrid1.Columns[4].Title.Caption;
///OTher
   stringgrid1.cells[3,774] := resform.Mx1.Caption;
   stringgrid1.Cells[1,774] := '0';stringgrid1.Cells[2,774] := 'Resform';
//TTTS
   stringgrid1.Cells[3,775] := tts.Caption;
   stringgrid1.Cells[3,776] := tts.button1.Caption;
//   stringgrid1.Cells[3,777] := tts.button2.Caption;
//   stringgrid1.Cells[3,778] := tts.button3.Caption;
   stringgrid1.Cells[3,779] := tts.button4.Caption;
//   stringgrid1.Cells[3,780] := tts.button5.Caption;
//   stringgrid1.Cells[3,781] := tts.button6.Caption;
   stringgrid1.Cells[3,782] := tts.combobox1.Items.CommaText;
   stringgrid1.Cells[3,783] := tts.edit1.TextHint;
   stringgrid1.Cells[3,784] := tts.Label1.Caption;
//   stringgrid1.Cells[3,785] := tts.label2.Caption;
   stringgrid1.Cells[3,786] := tts.speedbutton1.Caption;
//   stringgrid1.Cells[3,787] := tts.tabsheet1.Caption;
//   stringgrid1.Cells[3,788] := tts.tabsheet2.Caption;
//   stringgrid1.Cells[3,789] := tts.tabsheet3.Caption;
   stringgrid1.Cells[3,790] := tts.stringgrid1.Columns[0].Title.Caption;
   stringgrid1.Cells[3,791] := tts.stringgrid1.Hint;
   stringgrid1.Cells[3,792] := tts.stringgrid2.Hint;
   stringgrid1.Cells[3,793] := tts.StringGrid3.Hint;
   stringgrid1.Cells[3,794] := tts.stringgrid2.Columns[0].Title.Caption;
   stringgrid1.Cells[3,795] := tts.stringgrid3.Columns[0].Title.Caption;
///TCompare
   stringgrid1.Cells[3,796] := Ct.caption;
//   stringgrid1.Cells[3,797] := ct.button1.caption;
   stringgrid1.Cells[3,798] := ct.StatusBar1.panels[0].TEXT;
   stringgrid1.Cells[3,799] := ct.StatusBar1.panels[2].TEXT;
//TH2
   stringgrid1.Cells[3,800] := form11.Caption;
   stringgrid1.Cells[3,801] := form11.Button1.Caption;

   stringgrid1.Cells[3,802] := dcs1.SpeedButton7.Caption;

//Fdic
   stringgrid1.Cells[3,803] := form5.Caption;
   stringgrid1.Cells[3,804] := form5.button1.Caption;
   stringgrid1.Cells[3,805] := form5.stringgrid1.Columns[0].Title.Caption;
   stringgrid1.Cells[3,806] := form5.stringgrid1.Columns[1].Title.Caption;
   stringgrid1.Cells[3,807] := form5.stringgrid1.Columns[2].Title.Caption;
   stringgrid1.Cells[3,808] := form5.stringgrid1.Columns[3].Title.Caption;
   stringgrid1.Cells[3,809] := form5.statusbar1.Panels[0].Text;

   stringgrid1.Cells[3,810] := resform.SAD1.Caption;
   stringgrid1.Cells[3,811] := sintagma.StringGrid2.columns[5].Title.Caption;
//KR
   stringgrid1.Cells[3,812] := kr.StringGrid1.columns[6].Title.Caption;
   stringgrid1.Cells[3,813] := kr.StringGrid1.columns[7].Title.Caption;
   stringgrid1.Cells[3,814] := kr.Caption;
   stringgrid1.Cells[3,815] := kr.button1.Caption;
   stringgrid1.Cells[3,816] := form1.ExTXT.Caption;
   stringgrid1.Cells[3,817] := kr.panel1.Caption;




  stringgrid1.SaveToCSVFile('sys\face1.txt',#9);
end;

procedure Tlp.Button2Click(Sender: TObject);
var i,j : word;
    s : string;
begin

   for i := 1 to stringgrid1.RowCount-1 do
   for j := 3 to stringgrid1.ColCount-1 do
   begin
      s := stringgrid1.Cells[j,i];
      while pos('||',s) > 0 do
      begin
         insert(#13+#10,s,pos('||',s));
         delete(s,pos('||',s),2);
      end;
      stringgrid1.Cells[j,i] := s;
   end;

   form1.ComboBox2.Items.CommaText := stringgrid1.cells[x229,1] ;
   form1.ComboBox6.Items.CommaText := stringgrid1.cells[x229,2] ;
   form1.Edit1.texthint := stringgrid1.cells[x229,3] ;
   form1.Edit2.texthint := stringgrid1.cells[x229,4] ;
   form1.Edit3.texthint := stringgrid1.cells[x229,5] ;
   form1.SBClear.hint := stringgrid1.cells[x229,6] ;
   form1.Image10.hint := stringgrid1.cells[x229,7] ;
   form1.Image11.hint := stringgrid1.cells[x229,8] ;
//   form1.Image2.hint := stringgrid1.cells[x229,9] ;
   form1.Image3.hint := stringgrid1.cells[x229,10] ;
   form1.Image4.hint := stringgrid1.cells[x229,11] ;
   form1.Image5.hint := stringgrid1.cells[x229,12] ;
   form1.Image6.hint := stringgrid1.cells[x229,13] ;
   form1.Image7.hint := stringgrid1.cells[x229,14] ;
   form1.Image8.hint := stringgrid1.cells[x229,15] ;
   form1.Image9.hint := stringgrid1.cells[x229,16] ;
   form1.Label1.caption := stringgrid1.cells[x229,17] ;
   form1.spp1.Hint := stringgrid1.cells[x229,18] ;
   form1.menuitem16.caption := stringgrid1.cells[x229,19] ;
   form1.menuitem17.caption := stringgrid1.cells[x229,20] ;
   form1.spp6.caption := stringgrid1.cells[x229,21] ;
   form1.Label14.caption := stringgrid1.cells[x229,22] ;
   form1.Label4.caption := stringgrid1.cells[x229,23] ;
   form1.Label16.caption := stringgrid1.cells[x229,24] ;
   form1.ncc1.caption := stringgrid1.cells[x229,25] ;
   form1.Label18.caption := stringgrid1.cells[x229,26] ;
   form1.ncc.Caption := stringgrid1.cells[x229,27] ;
   form1.Label20.caption := stringgrid1.cells[x229,28] ;
   form1.ORes.Caption := stringgrid1.cells[x229,29] ;
   form1.Books.Caption := stringgrid1.cells[x229,30] ;
   form1.SoftW.Caption := stringgrid1.cells[x229,31] ;
   form1.spp3.caption := stringgrid1.cells[x229,32] ;
   form1.spp4.caption := stringgrid1.cells[x229,33] ;
   form1.spp6.caption := stringgrid1.cells[x229,34] ;
   form1.spp5.caption := stringgrid1.cells[x229,35] ;
   form1.menuitem18.caption := stringgrid1.cells[x229,36] ;
   form1.menuitem19.caption := stringgrid1.cells[x229,37] ;
   form1.Label3.caption := stringgrid1.cells[x229,38] ;
   form1.Label30.caption := stringgrid1.cells[x229,39] ;
   form1.Label31.caption := stringgrid1.cells[x229,40] ;
   form1.Label32.caption := stringgrid1.cells[x229,41] ;
   form1.Label33.caption := stringgrid1.cells[x229,42] ;
   form1.Label34.caption := stringgrid1.cells[x229,43] ;
   form1.spp2.Hint := stringgrid1.cells[x229,44] ;
   dcs1.checkbox2.caption := stringgrid1.cells[x229,45] ;
   form1.Label7.caption := stringgrid1.cells[x229,46] ;
   form1.spr1.Hint := stringgrid1.cells[x229,47] ;
   form1.checkbox2.caption := stringgrid1.cells[x229,48] ;
   form1.MenuItem1.caption := stringgrid1.cells[x229,49] ;
   form1.MenuItem11.caption := stringgrid1.cells[x229,50] ;
   form1.MenuItem126.caption := stringgrid1.cells[x229,51] ;
   form1.MenuItem156.caption := stringgrid1.cells[x229,52] ;
   form1.MenuItem2.caption := stringgrid1.cells[x229,53] ;
   form1.MenuItem23.caption := stringgrid1.cells[x229,54] ;
   form1.MenuItem27.caption := stringgrid1.cells[x229,55] ;
   form1.MenuItem3.caption := stringgrid1.cells[x229,56] ;
   form1.MenuItem30.caption := stringgrid1.cells[x229,57] ;
   form1.MenuItem31.caption := stringgrid1.cells[x229,58] ;
   form1.MenuItem36.caption := stringgrid1.cells[x229,59] ;
   form1.MenuItem37.caption := stringgrid1.cells[x229,60] ;
   form1.MenuItem38.caption := stringgrid1.cells[x229,61] ;
   form1.MenuItem39.caption := stringgrid1.cells[x229,62] ;
   form1.MenuItem4.caption := stringgrid1.cells[x229,63] ;
   form1.MenuItem40.caption := stringgrid1.cells[x229,64] ;
   form1.MenuItem41.caption := stringgrid1.cells[x229,65] ;
   form1.MenuItem42.caption := stringgrid1.cells[x229,66] ;
//   'R63FES' := stringgrid1.cells[x229,67] ;
   form1.MenuItem56.caption := stringgrid1.cells[x229,68] ;
   form1.MenuItem58.caption := stringgrid1.cells[x229,69] ;
   form1.nounM.caption := stringgrid1.cells[x229,70] ;
   form1.MenuItem60.caption := stringgrid1.cells[x229,71] ;
   form1.MenuItem61.caption := stringgrid1.cells[x229,72] ;
   form1.MenuItem62.caption := stringgrid1.cells[x229,73] ;
   form1.MenuItem63.caption := stringgrid1.cells[x229,74] ;
   form1.adjN.caption := stringgrid1.cells[x229,75] ;
   form1.MenuItem65.caption := stringgrid1.cells[x229,76] ;
   form1.MenuItem66.caption := stringgrid1.cells[x229,77] ;
   form1.MenuItem67.caption := stringgrid1.cells[x229,78] ;
   form1.MenuItem68.caption := stringgrid1.cells[x229,79] ;
   form1.MenuItem69.caption := stringgrid1.cells[x229,80] ;
   form1.MenuItem70.caption := stringgrid1.cells[x229,81] ;
   form1.MenuItem71.caption := stringgrid1.cells[x229,82] ;
   form1.MenuItem72.caption := stringgrid1.cells[x229,83] ;
   form1.MenuItem73.caption := stringgrid1.cells[x229,84] ;
   form1.MenuItem74.caption := stringgrid1.cells[x229,85] ;
   form1.MenuItem75.caption := stringgrid1.cells[x229,86] ;
   form1.MenuItem76.caption := stringgrid1.cells[x229,87] ;
   form1.N1.caption := stringgrid1.cells[x229,88] ;
   form1.N2.caption := stringgrid1.cells[x229,89] ;
   form1.N3.caption := stringgrid1.cells[x229,90] ;
   form1.OpenDialog1.Title := stringgrid1.cells[x229,91] ;
//   'MirrorAFX' := stringgrid1.cells[x229,92] ;
   form1.SaveDialog1.Title := stringgrid1.cells[x229,93] ;
      ;
   form1.SpeedButton12.caption := stringgrid1.cells[x229,124] ;
   form1.SpeedButton13.caption := stringgrid1.cells[x229,125] ;
   form1.SpeedButton14.caption := stringgrid1.cells[x229,126] ;
   form1.SpeedButton15.caption := stringgrid1.cells[x229,127] ;
   form1.SpeedButton16.caption := stringgrid1.cells[x229,128] ;
   form1.checkbox3.Hint := stringgrid1.cells[x229,129] ;
   form1.SpeedButton18.caption := stringgrid1.cells[x229,130] ;
   form1.SpeedButton19.caption := stringgrid1.cells[x229,131] ;
   form1.SpeedButton20.caption := stringgrid1.cells[x229,132] ;
   form1.SpeedButton21.caption := stringgrid1.cells[x229,133] ;
   form1.SpeedButton22.caption := stringgrid1.cells[x229,134] ;
   form1.SpeedButton23.caption := stringgrid1.cells[x229,135] ;
   form1.SpeedButton24.caption := stringgrid1.cells[x229,136] ;
   form1.label5.caption := stringgrid1.cells[x229,137];
   form1.SpeedButton26.caption := stringgrid1.cells[x229,138] ;
   form1.SpeedButton27.caption := stringgrid1.cells[x229,139] ;
   form1.SpeedButton28.caption := stringgrid1.cells[x229,140] ;
   form1.SpeedButton29.caption := stringgrid1.cells[x229,141] ;
   form1.SpeedButton30.caption := stringgrid1.cells[x229,142] ;
   form1.SpeedButton31.caption := stringgrid1.cells[x229,143] ;
   form1.SpeedButton32.caption := stringgrid1.cells[x229,144] ;
   form1.SpeedButton33.caption := stringgrid1.cells[x229,145] ;
   form1.SpeedButton34.caption := stringgrid1.cells[x229,146] ;
   form1.SpeedButton35.caption := stringgrid1.cells[x229,147] ;
   form1.SpeedButton36.caption := stringgrid1.cells[x229,148] ;
   form1.SpeedButton37.caption := stringgrid1.cells[x229,149] ;
   form1.SpeedButton38.caption := stringgrid1.cells[x229,150] ;
   form1.SpeedButton39.caption := stringgrid1.cells[x229,151] ;
   form1.SpeedButton4.caption := stringgrid1.cells[x229,152] ;
   form1.SpeedButton40.caption := stringgrid1.cells[x229,153] ;
   form1.SpeedButton41.caption := stringgrid1.cells[x229,154] ;
   form1.SpeedButton42.caption := stringgrid1.cells[x229,155] ;
   form1.SpeedButton43.caption := stringgrid1.cells[x229,156] ;
   form1.SpeedButton44.caption := stringgrid1.cells[x229,157] ;
   form1.SpeedButton45.caption := stringgrid1.cells[x229,158] ;
   form1.SpeedButton48.caption := stringgrid1.cells[x229,159] ;
   form1.SpeedButton49.caption := stringgrid1.cells[x229,160] ;
   form1.SpeedButton50.caption := stringgrid1.cells[x229,161] ;
   form1.SpeedButton51.caption := stringgrid1.cells[x229,162] ;
   form1.SpeedButton52.caption := stringgrid1.cells[x229,163] ;
   form1.SpeedButton53.caption := stringgrid1.cells[x229,164] ;
   form1.SpeedButton54.caption := stringgrid1.cells[x229,165] ;
   form1.SpeedButton55.caption := stringgrid1.cells[x229,166] ;
   form1.SpeedButton56.caption := stringgrid1.cells[x229,167] ;
   form1.SpeedButton57.caption := stringgrid1.cells[x229,168] ;
   form1.SpeedButton58.caption := stringgrid1.cells[x229,169] ;
   form1.SpeedButton59.caption := stringgrid1.cells[x229,170] ;
   form1.SpeedButton60.caption := stringgrid1.cells[x229,171] ;
   form1.SpeedButton61.caption := stringgrid1.cells[x229,172] ;
   form1.SpeedButton62.caption := stringgrid1.cells[x229,173] ;
   form1.SpeedButton63.caption := stringgrid1.cells[x229,174] ;
   form1.SpeedButton64.caption := stringgrid1.cells[x229,175] ;
   form1.SpeedButton65.caption := stringgrid1.cells[x229,176] ;
   form1.SpeedButton9.caption := stringgrid1.cells[x229,177] ;
   form1.SpeedButton12.hint := stringgrid1.cells[x229,178] ;
   form1.SpeedButton13.hint := stringgrid1.cells[x229,179] ;
   form1.SpeedButton14.hint := stringgrid1.cells[x229,180] ;
   form1.SpeedButton15.hint := stringgrid1.cells[x229,181] ;
   form1.SpeedButton16.hint := stringgrid1.cells[x229,182] ;
   form1.checkbox3.Caption := stringgrid1.cells[x229,183] ;
   form1.SpeedButton18.hint := stringgrid1.cells[x229,184] ;
   form1.SpeedButton19.hint := stringgrid1.cells[x229,185] ;
   form1.SpeedButton20.hint := stringgrid1.cells[x229,186] ;
   form1.SpeedButton21.hint := stringgrid1.cells[x229,187] ;
   form1.SpeedButton22.hint := stringgrid1.cells[x229,188] ;
   form1.SpeedButton23.hint := stringgrid1.cells[x229,189] ;
   form1.SpeedButton24.hint := stringgrid1.cells[x229,190] ;
   form1.krl.hint := stringgrid1.cells[x229,191] ;
   form1.SpeedButton26.hint := stringgrid1.cells[x229,192] ;
   form1.SpeedButton27.hint := stringgrid1.cells[x229,193] ;
   form1.SpeedButton28.hint := stringgrid1.cells[x229,194] ;
   form1.SpeedButton29.hint := stringgrid1.cells[x229,195] ;
   form1.SpeedButton30.hint := stringgrid1.cells[x229,196] ;
   form1.SpeedButton31.hint := stringgrid1.cells[x229,197] ;
   form1.SpeedButton32.hint := stringgrid1.cells[x229,198] ;
   form1.SpeedButton33.hint := stringgrid1.cells[x229,199] ;
   form1.SpeedButton34.hint := stringgrid1.cells[x229,200] ;
   form1.SpeedButton35.hint := stringgrid1.cells[x229,201] ;
   form1.SpeedButton36.hint := stringgrid1.cells[x229,202] ;
   form1.SpeedButton37.hint := stringgrid1.cells[x229,203] ;
   form1.SpeedButton38.hint := stringgrid1.cells[x229,204] ;
   form1.SpeedButton39.hint := stringgrid1.cells[x229,205] ;
   form1.SpeedButton4.hint := stringgrid1.cells[x229,206] ;
   form1.SpeedButton40.hint := stringgrid1.cells[x229,207] ;
   form1.SpeedButton41.hint := stringgrid1.cells[x229,208] ;
   form1.SpeedButton42.hint := stringgrid1.cells[x229,209] ;
   form1.SpeedButton43.hint := stringgrid1.cells[x229,210] ;
   form1.SpeedButton44.hint := stringgrid1.cells[x229,211] ;
   form1.SpeedButton45.hint := stringgrid1.cells[x229,212] ;
   form1.SpeedButton48.hint := stringgrid1.cells[x229,213] ;
   form1.SpeedButton49.hint := stringgrid1.cells[x229,214] ;
   form1.SpeedButton50.hint := stringgrid1.cells[x229,215] ;
   form1.SpeedButton51.hint := stringgrid1.cells[x229,216] ;
   form1.SpeedButton52.hint := stringgrid1.cells[x229,217] ;
   form1.SpeedButton53.hint := stringgrid1.cells[x229,218] ;
   form1.SpeedButton54.hint := stringgrid1.cells[x229,219] ;
   form1.SpeedButton55.hint := stringgrid1.cells[x229,220] ;
   form1.SpeedButton56.hint := stringgrid1.cells[x229,221] ;
   form1.SpeedButton57.hint := stringgrid1.cells[x229,222] ;
   form1.SpeedButton58.hint := stringgrid1.cells[x229,223] ;
   form1.SpeedButton59.hint := stringgrid1.cells[x229,224] ;
   form1.SpeedButton60.hint := stringgrid1.cells[x229,225] ;
   form1.SpeedButton61.hint := stringgrid1.cells[x229,226] ;
   form1.SpeedButton62.hint := stringgrid1.cells[x229,227] ;
   form1.SpeedButton63.hint := stringgrid1.cells[x229,228] ;
   form1.SpeedButton64.hint := stringgrid1.cells[x229,229] ;
   form1.SpeedButton65.hint := stringgrid1.cells[x229,230] ;
   form1.SpeedButton9.hint := stringgrid1.cells[x229,231] ;
   form1.StatusBarx2.panels[0].text := stringgrid1.cells[x229,232] ;
//
form1.StatusBarx2.Panels[1].Text:= lp.StringGrid1.Cells[x229,232] + ' '+
   inttostr(form1.stringgrid1.RowCount - 1);
//

   form1.StatusBarx2.panels[2].text := stringgrid1.cells[x229,233] ;
   form1.StatusBarx2.panels[4].text := stringgrid1.cells[x229,234] ;
   form1.StringGrid1.columns[4].title.caption := stringgrid1.cells[x229,235] ;
   form1.StringGrid1.columns[5].title.caption := stringgrid1.cells[x229,236] ;
   form1.StringGrid1.columns[6].title.caption := stringgrid1.cells[x229,237] ;
   form1.StringGrid1.columns[7].title.caption := stringgrid1.cells[x229,238] ;
   form1.StringGrid1.columns[8].title.caption := stringgrid1.cells[x229,239] ;
   form1.StringGrid1.columns[9].title.caption := stringgrid1.cells[x229,240] ;
//   SH1 SHIS. History. ;
   shis.Button1.Caption := stringgrid1.cells[x229,241] ;
   shis.Button2.Caption := stringgrid1.cells[x229,242] ;
   shis.Button3.Caption := stringgrid1.cells[x229,243] ;
   shis.Button4.Caption := stringgrid1.cells[x229,244] ;
   shis.SaveDialog1.title := stringgrid1.cells[x229,248] ;
   Shis.Caption := stringgrid1.cells[x229,249] ;
   shis.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,245] ;
   shis.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,246] ;
   shis.StringGrid1.Columns[2].Title.Caption := stringgrid1.cells[x229,247] ;
   shis.StringGrid1.Columns[3].Title.Caption := stringgrid1.cells[x229,250] ;
      ;
   dc.Button1.Caption := stringgrid1.cells[x229,251] ;
   dc.Button2.Caption := stringgrid1.cells[x229,252] ;
   dc.Button3.Caption := stringgrid1.cells[x229,253] ;
   dc.Button4.Caption := stringgrid1.cells[x229,254] ;
   dc.Button5.Caption := stringgrid1.cells[x229,255] ;
   dc.groupbox1.caption := stringgrid1.cells[x229,256] ;
   dc.groupbox2.caption := stringgrid1.cells[x229,257] ;
   dc.label1.Caption := stringgrid1.cells[x229,258] ;
   dc.speedbutton1.caption := stringgrid1.cells[x229,259] ;
   dc.speedbutton2.caption := stringgrid1.cells[x229,260] ;
   dc.speedbutton3.caption := stringgrid1.cells[x229,261] ;
   dc.speedbutton4.caption := stringgrid1.cells[x229,262] ;
   dc.speedbutton5.caption := stringgrid1.cells[x229,263] ;
   dc.speedbutton6.caption := stringgrid1.cells[x229,264] ;
//   '' := stringgrid1.cells[x229,265] ;
   dc.speedbutton8.caption := stringgrid1.cells[x229,266] ;
   dc.speedbutton9.caption := stringgrid1.cells[x229,267] ;
   dc.speedbutton10.caption := stringgrid1.cells[x229,268] ;
   dc.speedbutton11.caption := stringgrid1.cells[x229,269] ;
   dc.Caption := stringgrid1.cells[x229,270] ;
   dc.StatusBar1.Panels[0].TEXt := stringgrid1.cells[x229,271] ;
   dc.StatusBar1.Panels[2].TEXt := stringgrid1.cells[x229,272] ;
   dc.speedbutton1.hint := stringgrid1.cells[x229,273] ;
   dc.speedbutton2.hint := stringgrid1.cells[x229,274] ;
   dc.speedbutton3.hint := stringgrid1.cells[x229,275] ;
   dc.speedbutton4.hint := stringgrid1.cells[x229,276] ;
   dc.speedbutton5.hint := stringgrid1.cells[x229,277] ;
   dc.speedbutton6.hint := stringgrid1.cells[x229,278] ;
//   '' := stringgrid1.cells[x229,279] ;
   dc.speedbutton8.hint := stringgrid1.cells[x229,280] ;
   dc.speedbutton9.hint := stringgrid1.cells[x229,281] ;
   dc.speedbutton10.hint := stringgrid1.cells[x229,282] ;
   dc.speedbutton11.hint := stringgrid1.cells[x229,283] ;
   dc.button6.Caption := stringgrid1.cells[x229,284];
//   dc.MS2 := stringgrid1.cells[x229,285] ;
//   dc.MSC1 := stringgrid1.cells[x229,286] ;
//   dc.MSC2 := stringgrid1.cells[x229,287] ;
      ;
   form7.Caption := stringgrid1.cells[x229,288] ;
   form7.Button1.Caption := stringgrid1.cells[x229,289] ;
   form7.Button2.Caption := stringgrid1.cells[x229,290] ;
   form7.Button1.hint := stringgrid1.cells[x229,291] ;
   form7.Button2.hint := stringgrid1.cells[x229,292] ;
   form7.checklistbox1.Hint := stringgrid1.cells[x229,293] ;
   form7.MenuItem1.Caption := stringgrid1.cells[x229,294] ;
   form7.MenuItem2.Caption := stringgrid1.cells[x229,295] ;
   form7.MenuItem3.Caption := stringgrid1.cells[x229,296] ;
   form7.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,297] ;
//   323 298 TEMA1 ;
      ;
   tema.Button10.Caption := stringgrid1.cells[x229,298] ;
   tema.Button7.Caption := stringgrid1.cells[x229,299] ;
   tema.Button9.Caption := stringgrid1.cells[x229,300] ;

   tema.CheckBox1.Caption := stringgrid1.cells[x229,301] ;
   tema.CheckBox2.Caption := stringgrid1.cells[x229,302] ;
   tema.CheckBox3.Caption := stringgrid1.cells[x229,303] ;
   tema.CheckBox4.Caption := stringgrid1.cells[x229,304] ;
   tema.CheckBox5.Caption := stringgrid1.cells[x229,305] ;
   tema.CheckBox6.Caption := stringgrid1.cells[x229,306] ;
   tema.GroupBox1.Caption := stringgrid1.cells[x229,307] ;
   tema.GroupBox2.Caption := stringgrid1.cells[x229,308] ;

   tema.ComboBox1.Items.CommaText := stringgrid1.cells[x229,309] ;
   tema.Label1.Caption := stringgrid1.cells[x229,310] ;
   tema.Label2.Caption := stringgrid1.cells[x229,311] ;
   tema.Label3.Caption := stringgrid1.cells[x229,312] ;
   tema.Label4.Caption := stringgrid1.cells[x229,313] ;
   tema.MenuItem1.Caption := stringgrid1.cells[x229,314] ;
   tema.MenuItem2.Caption := stringgrid1.cells[x229,315] ;
   tema.MenuItem4.Caption := stringgrid1.cells[x229,316] ;
   tema.MenuItem5.Caption := stringgrid1.cells[x229,317] ;
   tema.MenuItem7.Caption := stringgrid1.cells[x229,318] ;
   tema.speedbutton8.Caption := stringgrid1.cells[x229,319] ;

   tema.stringgrid1.Columns[0].Title.Caption := stringgrid1.cells[x229,320] ;
   tema.stringgrid1.Columns[1].Title.Caption := stringgrid1.cells[x229,321] ;
   tema.stringgrid1.Columns[2].Title.Caption := stringgrid1.cells[x229,322] ;
   tema.Caption := stringgrid1.cells[x229,323] ;
//     (Reult1.pas) ;
      ;


   resform.checkbox1.Caption := stringgrid1.cells[x229,324] ;
   resform.CheckBox3.Caption := stringgrid1.cells[x229,325] ;
   resform.Caption := stringgrid1.cells[x229,326] ;
   resform.Edit1.TextHint := stringgrid1.cells[x229,327] ;
   resform.editbutton1.TextHint := stringgrid1.cells[x229,328] ;
   resform.edit2.TextHint := stringgrid1.cells[x229,329] ;
   resform.Label1.Caption := stringgrid1.cells[x229,330] ;
//   resform.Label2.Caption := stringgrid1.cells[x229,331] ;
   resform.MenuItem1.Caption := stringgrid1.cells[x229,332] ;
   resform.MenuItem2.Caption := stringgrid1.cells[x229,333] ;
   resform.MenuItem3.Caption := stringgrid1.cells[x229,334] ;
   resform.M95.Caption := stringgrid1.cells[x229,335] ;
   resform.MenuItem6.Caption := stringgrid1.cells[x229,336] ;
   resform.MenuItem9.Caption := stringgrid1.cells[x229,337] ;
   resform.MenuItem10.Caption := stringgrid1.cells[x229,338] ;
   resform.MenuItem11.Caption := stringgrid1.cells[x229,339] ;
   resform.MenuItem12.Caption := stringgrid1.cells[x229,340] ;
   resform.MenuItem13.Caption := stringgrid1.cells[x229,341] ;
   resform.MenuItem14.Caption := stringgrid1.cells[x229,342] ;
   dcs1.CheckBox4.Caption := stringgrid1.cells[x229,343] ;
   resform.MenuItem16.Caption := stringgrid1.cells[x229,344] ;
   resform.MenuItem17.Caption := stringgrid1.cells[x229,345] ;
   resform.MenuItem18.Caption := stringgrid1.cells[x229,346] ;
   resform.MenuItem19.Caption := stringgrid1.cells[x229,347] ;
   resform.statusbar1.Panels[0].text := stringgrid1.cells[x229,348] ;
   resform.m95.Hint := stringgrid1.cells[x229,349] ;
      ;

      ;
      ;
   rdr.label1.hint := stringgrid1.cells[x229,350] ;
   rdr.label6.hint := stringgrid1.cells[x229,351] ;
   rdr.label12.hint := stringgrid1.cells[x229,352] ;
   rdr.label13.hint := stringgrid1.cells[x229,353] ;
   rdr.label14.hint := stringgrid1.cells[x229,354] ;
   rdr.label15.hint := stringgrid1.cells[x229,355] ;
      ;
   rdr.label6.hint := stringgrid1.cells[x229,356] ;
   rdr.speedbutton1.Hint := stringgrid1.cells[x229,357] ;
   rdr.r1 := stringgrid1.cells[x229,358] ;
   rdr.r2 := stringgrid1.cells[x229,359] ;
   rdr.r3 := stringgrid1.cells[x229,360] ;
   rdr.r4 := stringgrid1.cells[x229,361] ;
   rdr.r5 := stringgrid1.cells[x229,362] ;
      ;
      ;
   dcs1.Label1.Caption := ' '+stringgrid1.cells[x229,363] ;
   dcs1.Label2.Caption := ' '+stringgrid1.cells[x229,364] ;
   dcs1.Label3.Caption := ' '+stringgrid1.cells[x229,365] ;
   dcs1.Label4.Caption := ' '+stringgrid1.cells[x229,366] ;
//   dcs1.Label5.Caption := ' '+stringgrid1.cells[x229,367] ;
   dcs1.Label6.Caption := ' '+stringgrid1.cells[x229,368] ;
   dcs1.Label7.Caption := ' '+stringgrid1.cells[x229,369] ;
   dcs1.speedbutton1.Caption := stringgrid1.cells[x229,370] ;
   dcs1.speedbutton2.Caption := stringgrid1.cells[x229,371] ;
   dcs1.speedbutton3.Caption := stringgrid1.cells[x229,372] ;
   dcs1.speedbutton4.Caption := stringgrid1.cells[x229,373] ;
   dcs1.speedbutton5.Caption := stringgrid1.cells[x229,374] ;
   dcs1.speedbutton6.Caption := stringgrid1.cells[x229,375] ;
   dcs1.GroupBox1.Caption := stringgrid1.cells[x229,376] ;
   dcs1.gb1.Caption := stringgrid1.cells[x229,377] ;
//   dcs1.Image1.Hint := stringgrid1.cells[x229,378] ;
   form1.krl.Caption := stringgrid1.cells[x229,379] ;
   dcs1.speedbutton8.Caption := stringgrid1.cells[x229,380] ;
//   dcs1.speedbutton9.Caption := stringgrid1.cells[x229,381] ;
   dcs1.speedbutton10.Caption := stringgrid1.cells[x229,382] ;
   dcs1.speedbutton11.hint := stringgrid1.cells[x229,383] ;
   dcs1.speedbutton12.Caption := stringgrid1.cells[x229,384] ;
   dcs1.speedbutton13.Caption := stringgrid1.cells[x229,385] ;
   dcs1.speedbutton14.Caption := stringgrid1.cells[x229,386] ;
   dcs1.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,387] ;
   dcs1.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,388] ;
   dcs1.Caption := stringgrid1.cells[x229,389] ;

   kkn.Label1.Caption := stringgrid1.cells[x229,390] ;
   kkn.Groupbox1.Caption := stringgrid1.cells[x229,391] ;
   kkn.Label3.Caption := stringgrid1.cells[x229,392] ;
   kkn.Label4.Caption := stringgrid1.cells[x229,393] ;
   kkn.combobox2.Items.CommaText := stringgrid1.cells[x229,394] ;
   kkn.Button5.Caption := stringgrid1.cells[x229,395] ;
   kkn.ComboBox1.Items.CommaText := stringgrid1.cells[x229,396] ;
   kkn.Button3.Caption := stringgrid1.cells[x229,397] ;
   kkn.Button2.Caption := stringgrid1.cells[x229,398] ;
   kkn.Button1.Caption := stringgrid1.cells[x229,399] ;
   kkn.Caption := stringgrid1.cells[x229,400] ;
   kkn.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,401] ;
   kkn.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,402] ;
   kkn.ComboBox_.Items.CommaText := stringgrid1.cells[x229,403] ;
      ;

   chd.Button1.Caption := stringgrid1.cells[x229,404] ;
   chd.Label2.Caption := stringgrid1.cells[x229,405] ;
   chd.Label3.Caption := stringgrid1.cells[x229,406] ;
   chd.Label4.Caption := stringgrid1.cells[x229,407] ;
   chd.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,408] ;
   chd.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,409] ;
   chd.StatusBar2.Panels[0].Text := stringgrid1.cells[x229,410] ;
   chd.StatusBar2.Panels[2].Text := stringgrid1.cells[x229,411] ;
   chd.StatusBar3.Panels[0].Text := stringgrid1.cells[x229,412] ;
   chd.StatusBar3.Panels[2].Text := stringgrid1.cells[x229,413] ;
   chd.GroupBox1.Caption := stringgrid1.cells[x229,414] ;
   chd.caption := stringgrid1.cells[x229,415] ;
   chd.ComboBox2.Items.CommaText := stringgrid1.cells[x229,416] ;
      ;
   verdir.Edit1.TextHint := stringgrid1.cells[x229,417] ;
   verdir.label1.Caption := stringgrid1.cells[x229,418] ;
   verdir.label2.Caption := stringgrid1.cells[x229,419] ;
   verdir.label3.Caption := stringgrid1.cells[x229,420] ;
   verdir.label4.Caption := stringgrid1.cells[x229,421] ;
   verdir.label5.Caption := stringgrid1.cells[x229,422] ;
   verdir.label6.Caption := stringgrid1.cells[x229,423] ;
   verdir.label7.Caption := stringgrid1.cells[x229,424] ;
   verdir.SpeedButton1.Caption := stringgrid1.cells[x229,425] ;
   verdir.SpeedButton4.hint := stringgrid1.cells[x229,426] ;
   verdir.SpeedButton2.Caption := stringgrid1.cells[x229,427] ;
   verdir.Caption := stringgrid1.cells[x229,428] ;
   verdir.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,429] ;
   verdir.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,430] ;
   verdir.StringGrid2.Columns[0].Title.Caption := stringgrid1.cells[x229,431] ;
   verdir.StringGrid2.Columns[1].Title.Caption := stringgrid1.cells[x229,432] ;
   verdir.StringGrid2.Columns[2].Title.Caption := stringgrid1.cells[x229,433] ;
   verdir.StringGrid2.Columns[3].Title.Caption := stringgrid1.cells[x229,434] ;
   verdir.StringGrid2.Columns[4].Title.Caption := stringgrid1.cells[x229,435] ;
   verdir.StringGrid2.Columns[5].Title.Caption := stringgrid1.cells[x229,436] ;
   verdir.StringGrid2.Columns[6].Title.Caption := stringgrid1.cells[x229,437] ;
   verdir.StringGrid2.Columns[7].Title.Caption := stringgrid1.cells[x229,438] ;
   verdir.StringGrid2.Columns[8].Title.Caption := stringgrid1.cells[x229,439] ;
   verdir.StringGrid2.Columns[9].Title.Caption := stringgrid1.cells[x229,440] ;
   verdir.StringGrid2.Columns[10].Title.Caption := stringgrid1.cells[x229,441] ;
      ;
      ;
   ED.ComboBox1.Items.CommaText := stringgrid1.cells[x229,442] ;
   Ed.EditButton1.TextHint := stringgrid1.cells[x229,443] ;
   ed.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,444] ;
   ed.Caption := stringgrid1.cells[x229,445] ;
//    WRF WordReferences ;
   wr.Button1.Caption := stringgrid1.cells[x229,446] ;
   wr.Button2.Caption := stringgrid1.cells[x229,447] ;
   wr.Button3.Caption := stringgrid1.cells[x229,448] ;
   wr.Label1.Caption := stringgrid1.cells[x229,449] ;
   wr.Label2.Caption := stringgrid1.cells[x229,450] ;
   wr.Label3.Caption := stringgrid1.cells[x229,451] ;
   wr.MenuItem1.Caption := stringgrid1.cells[x229,452] ;
   wr.MenuItem2.Caption := stringgrid1.cells[x229,453] ;
   wr.MenuItem3.Caption := stringgrid1.cells[x229,454] ;
   wr.MenuItem4.Caption := stringgrid1.cells[x229,455] ;
   wr.MenuItem5.Caption := stringgrid1.cells[x229,456] ;
   wr.MenuItem6.Caption := stringgrid1.cells[x229,457] ;
   wr.MenuItem7.Caption := stringgrid1.cells[x229,458] ;
   wr.MenuItem8.Caption := stringgrid1.cells[x229,459] ;
   wr.MenuItem9.Caption := stringgrid1.cells[x229,460] ;
   wr.MenuItem10.Caption := stringgrid1.cells[x229,461] ;
   wr.Caption := stringgrid1.cells[x229,462] ;
   wr.MenuItem12.Caption := stringgrid1.cells[x229,463] ;
   wr.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,464] ;
   wr.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,465] ;
   wr.StatusBar1.Panels[4].Text := stringgrid1.cells[x229,466] ;
   wr.StringGrid1.Columns[10].Title.Caption := stringgrid1.cells[x229,467] ;
   wr.StringGrid1.Columns[12].Title.Caption := stringgrid1.cells[x229,468] ;
   wr.StringGrid1.Columns[13].Title.Caption := stringgrid1.cells[x229,469] ;
   wr.StringGrid1.Columns[14].Title.Caption := stringgrid1.cells[x229,470] ;
      ;
      ;
   lns.Button1.Caption := stringgrid1.cells[x229,471] ;
   lns.Button4.Caption := stringgrid1.cells[x229,472] ;
   lns.Label1.Caption := stringgrid1.cells[x229,473] ;
   lns.Label2.Caption := stringgrid1.cells[x229,474] ;
   lns.MenuItem1.Caption := stringgrid1.cells[x229,475] ;
   lns.MenuItem2.Caption := stringgrid1.cells[x229,476] ;
   lns.MenuItem3.Caption := stringgrid1.cells[x229,477] ;
   lns.MenuItem4.Caption := stringgrid1.cells[x229,478] ;
   lns.MenuItem5.Caption := stringgrid1.cells[x229,479] ;
   lns.MenuItem6.Caption := stringgrid1.cells[x229,480] ;
   lns.MenuItem7.Caption := stringgrid1.cells[x229,481] ;
   lns.MenuItem8.Caption := stringgrid1.cells[x229,482] ;
   lns.MenuItem9.Caption := stringgrid1.cells[x229,483] ;
   lns.MenuItem10.Caption := stringgrid1.cells[x229,484] ;
   lns.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,485] ;
   lns.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,486] ;
   lns.StatusBar1.Panels[4].Text := stringgrid1.cells[x229,487] ;
   lns.StringGrid1.Columns[0].Title.Caption := stringgrid1.cells[x229,488] ;
   lns.StringGrid1.Columns[1].Title.Caption := stringgrid1.cells[x229,489] ;
   lns.StringGrid1.Columns[3].Title.Caption := stringgrid1.cells[x229,490] ;
   lns.StringGrid1.Columns[4].Title.Caption := stringgrid1.cells[x229,491] ;
   lns.StringGrid1.Columns[5].Title.Caption := stringgrid1.cells[x229,492] ;
   lns.StringGrid1.Columns[2].Title.Caption := stringgrid1.cells[x229,493] ;
   lns.Caption := stringgrid1.cells[x229,494] ;
//     Repo1 ;
      ;
   tz.Button1.Caption := stringgrid1.cells[x229,495] ;
   tz.Button2.Caption := stringgrid1.cells[x229,496] ;
   tz.Button3.Caption := stringgrid1.cells[x229,497] ;
   tz.Button4.Caption := stringgrid1.cells[x229,498] ;
   tz.Button5.Caption := stringgrid1.cells[x229,499] ;
   tz.Button9.Caption := stringgrid1.cells[x229,500] ;
   tz.Label1.Caption := stringgrid1.cells[x229,501] ;
   tz.MenuItem1.Caption := stringgrid1.cells[x229,502] ;
   tz.MenuItem2.Caption := stringgrid1.cells[x229,503] ;
   tz.MenuItem3.Caption := stringgrid1.cells[x229,504] ;
   tz.MenuItem4.Caption := stringgrid1.cells[x229,505] ;
   tz.MenuItem5.Caption := stringgrid1.cells[x229,506] ;
   tz.MenuItem6.Caption := stringgrid1.cells[x229,507] ;
   tz.MenuItem7.Caption := stringgrid1.cells[x229,508] ;
   tz.MenuItem8.Caption := stringgrid1.cells[x229,509] ;
   tz.MenuItem9.Caption := stringgrid1.cells[x229,510] ;
   tz.MenuItem10.Caption := stringgrid1.cells[x229,511] ;
   tz.MenuItem11.Caption := stringgrid1.cells[x229,512] ;
   tz.MenuItem12.Caption := stringgrid1.cells[x229,513] ;
   tz.MenuItem13.Caption := stringgrid1.cells[x229,514] ;
   tz.MenuItem14.Caption := stringgrid1.cells[x229,515] ;
   tz.MenuItem15.Caption := stringgrid1.cells[x229,516] ;
   tz.MenuItem16.Caption := stringgrid1.cells[x229,517] ;
   tz.MenuItem17.Caption := stringgrid1.cells[x229,518] ;
   tz.MenuItem18.Caption := stringgrid1.cells[x229,519] ;
   tz.MenuItem19.Caption := stringgrid1.cells[x229,520] ;
   tz.MenuItem20.Caption := stringgrid1.cells[x229,521] ;
   tz.MenuItem21.Caption := stringgrid1.cells[x229,522] ;
   tz.MenuItem22.Caption := stringgrid1.cells[x229,523] ;
   tz.TabSheet1.Caption := stringgrid1.cells[x229,524] ;
   tz.TabSheet2.Caption := stringgrid1.cells[x229,525] ;
   tz.Panel14.Caption := stringgrid1.cells[x229,526] ;
   tz.Panel15.Caption := stringgrid1.cells[x229,527] ;
   tz.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,528] ;
   tz.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,529] ;
   tz.StatusBar2.Panels[0].Text := stringgrid1.cells[x229,530] ;
   tz.StatusBar2.Panels[2].Text := stringgrid1.cells[x229,531] ;
   tz.Caption := stringgrid1.cells[x229,532] ;
   tz.StringGrid1.Columns[0].Title.Caption := stringgrid1.cells[x229,533] ;
   tz.StringGrid1.Columns[1].Title.Caption := stringgrid1.cells[x229,534] ;
   tz.StringGrid1.Columns[2].Title.Caption := stringgrid1.cells[x229,535] ;
   tz.StringGrid1.Columns[3].Title.Caption := stringgrid1.cells[x229,536] ;
   tz.StringGrid1.Columns[4].Title.Caption := stringgrid1.cells[x229,537] ;
   tz.StringGrid1.Columns[5].Title.Caption := stringgrid1.cells[x229,538] ;
   tz.StringGrid2.Columns[0].Title.Caption := stringgrid1.cells[x229,539] ;
   tz.StringGrid2.Columns[1].Title.Caption := stringgrid1.cells[x229,540] ;
   tz.StringGrid2.Columns[2].Title.Caption := stringgrid1.cells[x229,541] ;
   tz.StringGrid2.Columns[3].Title.Caption := stringgrid1.cells[x229,542] ;
   tz.StringGrid2.Columns[4].Title.Caption := stringgrid1.cells[x229,543] ;
   tz.StringGrid2.Columns[5].Title.Caption := stringgrid1.cells[x229,544] ;
   tz.StringGrid2.Columns[6].Title.Caption := stringgrid1.cells[x229,545] ;
      ;
      ;
   fr.Label4.Caption := stringgrid1.cells[x229,546] ;
   fr.Edit1.TextHint := stringgrid1.cells[x229,547] ;
   fr.Edit2.TextHint := stringgrid1.cells[x229,548] ;
   fr.SpeedButton1.Caption := stringgrid1.cells[x229,549] ;
   fr.SpeedButton2.Caption := stringgrid1.cells[x229,550] ;
   fr.Caption := stringgrid1.cells[x229,551] ;
   fr.MenuItem1.Caption := stringgrid1.cells[x229,552] ;
   fr.MenuItem2.Caption := stringgrid1.cells[x229,553] ;
   fr.MenuItem3.Caption := stringgrid1.cells[x229,554] ;
   fr.MenuItem4.Caption := stringgrid1.cells[x229,555] ;
   fr.MenuItem5.Caption := stringgrid1.cells[x229,556] ;
   fr.MenuItem6.Caption := stringgrid1.cells[x229,557] ;
   fr.MenuItem7.Caption := stringgrid1.cells[x229,558] ;
   fr.MenuItem8.Caption := stringgrid1.cells[x229,559] ;
   fr.MenuItem9.Caption := stringgrid1.cells[x229,560] ;
   fr.ComboBox1.Items.CommaText := stringgrid1.cells[x229,561] ;
   fr.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,562] ;
   fr.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,563] ;
   fr.StringGrid2.Columns[2].Title.Caption := stringgrid1.cells[x229,564] ;
   fr.StringGrid2.Columns[3].Title.Caption := stringgrid1.cells[x229,565] ;
   fr.StringGrid2.Columns[4].Title.Caption := stringgrid1.cells[x229,566] ;
   fr.StringGrid2.Columns[5].Title.Caption := stringgrid1.cells[x229,567] ;
   fr.StringGrid2.Columns[6].Title.Caption := stringgrid1.cells[x229,568] ;
      ;
   form4.Caption := stringgrid1.cells[x229,569] ;
   form4.Edit1.TextHint := stringgrid1.cells[x229,570] ;
   form4.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,571] ;
   form4.StringGrid2.columns[0].Title.Caption := stringgrid1.cells[x229,572] ;
      ;
   form3.Caption := stringgrid1.cells[x229,573] ;
   form3.MenuItem1.Caption := stringgrid1.cells[x229,574] ;
   form3.MenuItem2.Caption := stringgrid1.cells[x229,575] ;
   form3.MenuItem3.Caption := stringgrid1.cells[x229,576] ;
   form3.MenuItem4.Caption := stringgrid1.cells[x229,577] ;
   form3.MenuItem5.Caption := stringgrid1.cells[x229,578] ;
   form3.MenuItem6.Caption := stringgrid1.cells[x229,579] ;
   form3.MenuItem7.Caption := stringgrid1.cells[x229,580] ;
   form3.MenuItem8.Caption := stringgrid1.cells[x229,581] ;
   form3.MenuItem9.Caption := stringgrid1.cells[x229,582] ;
   form3.MenuItem10.Caption := stringgrid1.cells[x229,583] ;
   form3.MenuItem11.Caption := stringgrid1.cells[x229,584] ;
   form3.MenuItem12.Caption := stringgrid1.cells[x229,585] ;
   form3.MenuItem13.Caption := stringgrid1.cells[x229,586] ;
   form3.MenuItem14.Caption := stringgrid1.cells[x229,587] ;
   form3.Panel4.Caption := stringgrid1.cells[x229,588] ;
   form3.SpeedButton2.Caption := stringgrid1.cells[x229,589] ;
   form3.SpeedButton4.Caption := stringgrid1.cells[x229,590] ;
   form3.SpeedButton5.Caption := stringgrid1.cells[x229,591] ;
   form3.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,592] ;
   form3.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,593] ;
   form3.StatusBar1.Panels[4].Text := stringgrid1.cells[x229,594] ;
   form3.StringGrid1.Columns[0].Title.Caption := stringgrid1.cells[x229,595] ;
   form3.StringGrid1.Columns[1].Title.Caption := stringgrid1.cells[x229,596] ;
   form3.StringGrid1.Columns[2].Title.Caption := stringgrid1.cells[x229,597] ;
   form3.StringGrid2.Columns[0].Title.Caption := stringgrid1.cells[x229,598] ;
   form3.StringGrid2.Columns[1].Title.Caption := stringgrid1.cells[x229,599] ;
   form3.StringGrid2.Columns[2].Title.Caption := stringgrid1.cells[x229,600] ;
   form3.Edit1.TextHint := stringgrid1.cells[x229,601] ;
   form3.ComboBox1.Items.CommaText := stringgrid1.cells[x229,602] ;
      ;
   sinta.Caption := stringgrid1.cells[x229,603] ;
   sinta.Button1.Caption := stringgrid1.cells[x229,604] ;
   sinta.StringGrid1.Columns[0].Title.Caption := stringgrid1.cells[x229,605] ;
   sinta.StringGrid1.Columns[1].Title.Caption := stringgrid1.cells[x229,606] ;
      ;
   wt1.Button1.Caption := stringgrid1.cells[x229,607] ;
   wt1.Button2.Caption := stringgrid1.cells[x229,608] ;
   wt1.Caption := stringgrid1.cells[x229,609] ;
   wt1.StringGrid4.cells[0,0] := stringgrid1.cells[x229,610] ;
   wt1.StringGrid4.cells[1,0] := stringgrid1.cells[x229,611] ;
   wt1.StringGrid1.Columns[0].Title.Caption := stringgrid1.cells[x229,612] ;
   wt1.StringGrid1.Columns[1].Title.Caption := stringgrid1.cells[x229,613] ;
   wt1.StringGrid1.Columns[2].Title.Caption := stringgrid1.cells[x229,614] ;
      ;
   symba.Caption := stringgrid1.cells[x229,615] ;
   symba.CheckBox1.Caption := stringgrid1.cells[x229,616] ;
   symba.CheckBox2.Caption := stringgrid1.cells[x229,617] ;
   symba.CheckBox3.Caption := stringgrid1.cells[x229,618] ;
   symba.GroupBox1.Caption := stringgrid1.cells[x229,619] ;
   symba.MenuItem1.Caption := stringgrid1.cells[x229,620] ;
   symba.MenuItem2.Caption := stringgrid1.cells[x229,621] ;
   symba.MenuItem3.Caption := stringgrid1.cells[x229,622] ;
   symba.MenuItem4.Caption := stringgrid1.cells[x229,623] ;
   symba.MenuItem5.Caption := stringgrid1.cells[x229,624] ;
   symba.MenuItem6.Caption := stringgrid1.cells[x229,625] ;
   symba.MenuItem7.Caption := stringgrid1.cells[x229,626] ;
      ;
      ;
   sf.Caption := stringgrid1.cells[x229,627] ;
   sf.Label4.Caption := stringgrid1.cells[x229,628] ;
   sf.Label5.Caption := stringgrid1.cells[x229,629] ;
   sf.Label6.Caption := stringgrid1.cells[x229,630] ;
   sf.Label7.Caption := stringgrid1.cells[x229,631] ;
   sf.Label8.Caption := stringgrid1.cells[x229,632] ;
   sf.Label9.Caption := stringgrid1.cells[x229,633] ;
   sf.Button1.Caption := stringgrid1.cells[x229,634] ;
      ;
   liga.Caption := stringgrid1.cells[x229,635] ;
   liga.Edit1.TextHint := stringgrid1.cells[x229,636] ;
   liga.SpeedButton1.Caption := stringgrid1.cells[x229,637] ;
   liga.SpeedButton2.Caption := stringgrid1.cells[x229,638] ;
   liga.SpeedButton3.Caption := stringgrid1.cells[x229,639] ;
   liga.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,640] ;
   liga.StatusBar2.Panels[0].Text := stringgrid1.cells[x229,641] ;
   liga.StatusBar3.Panels[0].Text := stringgrid1.cells[x229,642] ;
   liga.StatusBar4.Panels[0].Text := stringgrid1.cells[x229,643] ;
   liga.StatusBar5.Panels[0].Text := stringgrid1.cells[x229,644] ;
   liga.ComboBox1.Items.CommaText := stringgrid1.cells[x229,645] ;
   liga.TabSheet1.Caption := stringgrid1.cells[x229,646] ;
   liga.TabSheet2.Caption := stringgrid1.cells[x229,647] ;
   liga.TabSheet3.Caption := stringgrid1.cells[x229,648] ;
   liga.TabSheet4.Caption := stringgrid1.cells[x229,649] ;
   liga.TabSheet5.Caption := stringgrid1.cells[x229,650] ;
      ;

      ;
   gres.Caption := stringgrid1.cells[x229,651] ;
   gres.Panel1.Caption := stringgrid1.cells[x229,652] ;
   gres.Button1.Caption := stringgrid1.cells[x229,653] ;
   gres.StringGrid1.Columns[0].Title.Caption := stringgrid1.cells[x229,654] ;
   gres.StringGrid1.Columns[1].Title.Caption := stringgrid1.cells[x229,655] ;
   gres.StringGrid1.Columns[2].Title.Caption := stringgrid1.cells[x229,656] ;
   gres.StringGrid1.Columns[3].Title.Caption := stringgrid1.cells[x229,657] ;
   gres.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,658] ;
   gres.StatusBar1.Panels[1].Text := stringgrid1.cells[x229,659] ;
      ;
   nn.Caption := stringgrid1.cells[x229,660] ;
   nn.EditButton1.TextHint := stringgrid1.cells[x229,661] ;
   nn.EditButton1.ButtonCaption := stringgrid1.cells[x229,662] ;
   nn.ComboBox1.Hint := stringgrid1.cells[x229,663] ;
   nn.ComboBox2.Hint := stringgrid1.cells[x229,664] ;
   nn.ComboBox1.Items.CommaText := stringgrid1.cells[x229,665] ;
      ;
      ;
   vr.Caption := stringgrid1.cells[x229,666] ;
      ;
   vr.ComboBox1.Hint := stringgrid1.cells[x229,667] ;
   vr.ComboBox2.Hint := stringgrid1.cells[x229,668] ;
   vr.editbutton1.TextHint := stringgrid1.cells[x229,669] ;
   vr.editbutton1.Button.Caption := stringgrid1.cells[x229,670] ;
      ;
      ;
      ;
      ;
   of1.Caption := stringgrid1.cells[x229,671] ;
   of1.Label4.Caption := stringgrid1.cells[x229,672] ;
   of1.StringGrid1.Columns[0].Title.Caption := stringgrid1.cells[x229,673] ;
   of1.StringGrid1.Columns[1].Title.Caption := stringgrid1.cells[x229,674] ;
   of1.StringGrid1.Columns[2].Title.Caption := stringgrid1.cells[x229,675] ;
   of1.StringGrid1.Columns[3].Title.Caption := stringgrid1.cells[x229,676] ;
   of1.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,677] ;
   of1.MenuItem1.Caption := stringgrid1.cells[x229,678] ;
   of1.MenuItem2.Caption := stringgrid1.cells[x229,679] ;
      ;
      ;
   prl.Caption := stringgrid1.cells[x229,680] ;
   prl.Button1.Caption := stringgrid1.cells[x229,681] ;
   prl.Button2.Caption := stringgrid1.cells[x229,682] ;
   prl.Button3.Caption := stringgrid1.cells[x229,683] ;
   prl.Button4.Caption := stringgrid1.cells[x229,684] ;
   prl.Button5.Caption := stringgrid1.cells[x229,685] ;
   prl.StringGrid1.Columns[1].Title.Caption := stringgrid1.cells[x229,686] ;
   prl.StringGrid1.Columns[3].Title.Caption := stringgrid1.cells[x229,687] ;
   prl.StringGrid3.Columns[1].Title.Caption := stringgrid1.cells[x229,688] ;
   prl.StringGrid3.Columns[3].Title.Caption := stringgrid1.cells[x229,689] ;
   prl.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,690] ;
   prl.StatusBar1.Panels[2].Text := stringgrid1.cells[x229,691] ;
   prl.StatusBar2.Panels[0].Text := stringgrid1.cells[x229,692] ;
   prl.StatusBar2.Panels[2].Text := stringgrid1.cells[x229,693] ;
   prl.Label1.Caption := stringgrid1.cells[x229,694] ;
      ;
      ;
   sintagma.Caption := stringgrid1.cells[x229,695] ;
   sintagma.MenuItem1.Caption := stringgrid1.cells[x229,696] ;
   sintagma.MenuItem1.hint := stringgrid1.cells[x229,697] ;
   sintagma.MenuItem4.Caption := stringgrid1.cells[x229,698] ;
   sintagma.MenuItem5.Caption := stringgrid1.cells[x229,699] ;
   sintagma.Button1.Caption := stringgrid1.cells[x229,700] ;
   sintagma.Button2.Caption := stringgrid1.cells[x229,701] ;
   sintagma.Edit1.TextHint := stringgrid1.cells[x229,702] ;
   sintagma.Edit2.TextHint := stringgrid1.cells[x229,703] ;
   sintagma.Edit3.TextHint := stringgrid1.cells[x229,704] ;
   sintagma.Edit4.TextHint := stringgrid1.cells[x229,705] ;
   sintagma.Edit5.TextHint := stringgrid1.cells[x229,706] ;
   sintagma.StatusBar1.Panels[0].Text := stringgrid1.cells[x229,707] ;
   sintagma.StringGrid2.columns[3].Title.Caption := stringgrid1.cells[x229,708] ;
   sintagma.StringGrid2.columns[4].Title.Caption := stringgrid1.cells[x229,709] ;
      ;
      ;
   hlp.Caption := stringgrid1.cells[x229,710] ;
   hlp.Label1.caption := stringgrid1.cells[x229,711] ;
   hlp.Label3.caption := stringgrid1.cells[x229,712] ;
   hlp.Label4.caption := stringgrid1.cells[x229,713] ;
   hlp.Label5.caption := stringgrid1.cells[x229,714] ;
   hlp.Memo1.Lines.CommaText := stringgrid1.cells[x229,715] ;
   hlp.Memo2.Lines.CommaText := stringgrid1.cells[x229,716] ;

   form8.Caption := stringgrid1.cells[x229,717] ;
   form8.checkbox1.Caption := stringgrid1.cells[x229,718] ;
   form8.checkbox2.Caption := stringgrid1.cells[x229,719] ;
   form8.checkbox3.Caption := stringgrid1.cells[x229,720] ;
   form8.checkbox4.Caption := stringgrid1.cells[x229,721] ;
   form8.checkbox5.Caption := stringgrid1.cells[x229,722] ;
   form8.checkbox6.Caption := stringgrid1.cells[x229,723] ;
   form8.checkbox7.Caption := stringgrid1.cells[x229,724] ;
   form8.checkbox8.Caption := stringgrid1.cells[x229,725] ;
   form8.checkbox9.Caption := stringgrid1.cells[x229,726] ;
   form8.checkbox10.Caption := stringgrid1.cells[x229,727] ;
   form8.checkbox11.Caption := stringgrid1.cells[x229,728] ;
   form8.checkbox12.Caption := stringgrid1.cells[x229,729] ;
   form8.checkbox13.Caption := stringgrid1.cells[x229,730] ;
   form8.checkbox14.Caption := stringgrid1.cells[x229,731] ;
   form8.checkbox15.Caption := stringgrid1.cells[x229,732] ;
   form8.groupbox4.Caption := stringgrid1.cells[x229,733] ;
   form8.Label1.Caption := stringgrid1.cells[x229,734] ;
   form8.Label2.Caption := stringgrid1.cells[x229,735] ;
   form8.Label3.Caption := stringgrid1.cells[x229,736] ;
   form8.Label4.Caption := stringgrid1.cells[x229,737] ;
   form8.Label5.Caption := stringgrid1.cells[x229,738] ;
   form8.Label6.Caption := stringgrid1.cells[x229,739] ;
   form8.Button1.Caption := stringgrid1.cells[x229,740] ;
   form8.Button2.Caption := stringgrid1.cells[x229,741] ;
   form8.Button3.Caption := stringgrid1.cells[x229,742] ;
   form8.Button4.Caption := stringgrid1.cells[x229,743] ;
//   form8.Button5.Caption := stringgrid1.cells[x229,744] ;
   form8.Button6.Caption := stringgrid1.cells[x229,745] ;
   form8.Button7.Caption := stringgrid1.cells[x229,746] ;
   form8.Button8.Caption := stringgrid1.cells[x229,747] ;
   form8.Button9.Caption := stringgrid1.cells[x229,748] ;
   form8.Button10.Caption := stringgrid1.cells[x229,749] ;
   form8.Button11.Caption := stringgrid1.cells[x229,750] ;
   form8.StringGrid1.Columns[0].Title.Caption := stringgrid1.cells[x229,751] ;
   form8.StringGrid1.Columns[1].Title.Caption := stringgrid1.cells[x229,752] ;
   form8.StringGrid1.Columns[2].Title.Caption := stringgrid1.cells[x229,753] ;
   form8.button12.Caption := stringgrid1.cells[x229,754] ;
   form8.TabSheet1.Caption := stringgrid1.cells[x229,755] ;
   form8.TabSheet2.Caption := stringgrid1.cells[x229,756] ;
   form8.TabSheet3.Caption := stringgrid1.cells[x229,757] ;
   form8.TabSheet4.Caption := stringgrid1.cells[x229,758] ;
   form8.groupbox3.Caption := stringgrid1.cells[x229,759] ;

   roots.Caption :=   stringgrid1.cells[x229,760];
   roots.Label1.Caption  := stringgrid1.cells[x229,761];
   roots.speedbutton1.Caption := stringgrid1.cells[x229,762];
   roots.speedbutton2.Caption := stringgrid1.cells[x229,763];
   roots.statusbar1.Panels[0].Text  := stringgrid1.cells[x229,764];
   roots.edit1.TextHint  := stringgrid1.cells[x229,765];

   sta.Caption := stringgrid1.Cells[x229,766];
     dcs1.Label8.Caption:=stringgrid1.Cells[x229,766];;
   sta.Label1.Caption := stringgrid1.Cells[x229,767];
   sta.Label2.Caption := stringgrid1.Cells[x229,768];
   sta.Label3.Caption := stringgrid1.Cells[x229,769];
   sta.StatusBar1.Panels[0].Text := stringgrid1.Cells[x229,770];
   sta.StringGrid1.Columns[0].Title.Caption := stringgrid1.Cells[x229,771];
     dcs1.StringGrid1.Columns[0].Title.Caption := stringgrid1.Cells[x229,771];
   sta.StringGrid1.Columns[1].Title.Caption := stringgrid1.Cells[x229,772];
     dcs1.StringGrid1.Columns[1].Title.Caption := stringgrid1.Cells[x229,772];
   sta.StringGrid1.Columns[4].Title.Caption := stringgrid1.Cells[x229,773];
     dcs1.StringGrid1.Columns[4].Title.Caption := stringgrid1.Cells[x229,773];
// OTher
   resform.Mx1.Caption:=stringgrid1.Cells[x229,774];
//TTTS

   tts.Caption := stringgrid1.Cells[x229,775];
   tts.button1.Caption := stringgrid1.Cells[x229,776];
   tts.Groupbox2.Caption := stringgrid1.Cells[x229,777];
   tts.Groupbox3.Caption := stringgrid1.Cells[x229,778];
   tts.button4.Caption := stringgrid1.Cells[x229,779];
   tts.combobox1.Items.CommaText := stringgrid1.Cells[x229,782];
   tts.edit1.TextHint := stringgrid1.Cells[x229,783];
   tts.Label1.Caption := stringgrid1.Cells[x229,784];
   tts.groupbox3.Caption := stringgrid1.Cells[x229,785];
   tts.speedbutton1.Caption := stringgrid1.Cells[x229,786];
//popup1
   tts.Menuitem9.Caption := stringgrid1.Cells[x229,780];
   tts.Menuitem8.Caption := stringgrid1.Cells[x229,781];
   tts.Menuitem7.Caption := stringgrid1.Cells[x229,787];
   tts.Menuitem2.Caption := stringgrid1.Cells[x229,788];
   tts.Menuitem1.Caption := stringgrid1.Cells[x229,789];
//Popup2
   tts.Menuitem12.Caption := stringgrid1.Cells[x229,780];
   tts.Menuitem11.Caption := stringgrid1.Cells[x229,781];
   tts.Menuitem10.Caption := stringgrid1.Cells[x229,787];
   tts.Menuitem3.Caption := stringgrid1.Cells[x229,788];
   tts.Menuitem4.Caption := stringgrid1.Cells[x229,789];
//Popup3
   tts.Menuitem15.Caption := stringgrid1.Cells[x229,780];
   tts.Menuitem14.Caption := stringgrid1.Cells[x229,781];
   tts.Menuitem13.Caption := stringgrid1.Cells[x229,787];
   tts.Menuitem5.Caption := stringgrid1.Cells[x229,788];
   tts.Menuitem6.Caption := stringgrid1.Cells[x229,789];
//Popup2
   tts.stringgrid1.Columns[0].Title.Caption := stringgrid1.Cells[x229,790];
   tts.stringgrid1.Hint := stringgrid1.Cells[x229,791];
   tts.stringgrid2.Hint := stringgrid1.Cells[x229,792];
   tts.StringGrid3.Hint := stringgrid1.Cells[x229,793];
   tts.stringgrid2.Columns[0].Title.Caption := stringgrid1.Cells[x229,794];
//TC
   ct.Caption:= stringgrid1.Cells[x229,796];
//   ct.button1.Caption:= stringgrid1.Cells[x229,797];
   ct.statusbar1.Panels[0].Text := stringgrid1.Cells[x229,798];
   ct.statusbar1.Panels[2].Text := stringgrid1.Cells[x229,799];

   th2.form11.Caption:=stringgrid1.Cells[x229,800];
   th2.form11.button1.Caption:=stringgrid1.Cells[x229,801];

   dcs1.SpeedButton7.Caption := stringgrid1.Cells[x229,802];

   fdic.form5.Caption:= stringgrid1.Cells[x229,803];;
   fdic.form5.Button1.Caption:= stringgrid1.Cells[x229,804];
   fdic.form5.StringGrid1.Columns[0].Title.Caption:= stringgrid1.Cells[x229,805];
   fdic.form5.StringGrid1.Columns[1].Title.Caption:= stringgrid1.Cells[x229,806];
   fdic.form5.StringGrid1.Columns[2].Title.Caption:= stringgrid1.Cells[x229,807];
   fdic.form5.StringGrid1.Columns[3].Title.Caption:= stringgrid1.Cells[x229,808];
   fdic.form5.StatusBar1.Panels[0].Text:= stringgrid1.Cells[x229,809];

   resform.SAD1.Caption := stringgrid1.Cells[x229,810];
   sintagma.StringGrid2.columns[5].Title.Caption := stringgrid1.Cells[x229,811];

   kr.StringGrid1.columns[1].Title.Caption := stringgrid1.Cells[x229,812];
   kr.StringGrid1.columns[2].Title.Caption := stringgrid1.Cells[x229,813];
   kr.Caption := stringgrid1.Cells[x229,814];

   kr.button1.Caption:= stringgrid1.Cells[x229,815];
   form1.Extxt.Caption := stringgrid1.Cells[x229,816];


   kr.panel1.Caption:= stringgrid1.Cells[x229,817];
end;

procedure Tlp.Button3Click(Sender: TObject);
var i : word; s : string;
begin
   for i := 1 to stringgrid1.RowCount - 1 do
   begin
      s := stringgrid1.Cells[3,i];
      while pos(#13,s) > 0 do
      begin
          insert('|',s,pos(#13,s));
          delete(s,pos(#13,s),1);
      end;
      while pos(#10,s) > 0 do
      begin
          insert('|',s,pos(#10,s));
          delete(s,pos(#10,s),1);
      end;
      stringgrid1.Cells[3,i] := s;
   end;
   stringgrid1.SaveToCSVFile('sys\face12.txt',#9);


end;

procedure Tlp.Button4Click(Sender: TObject);
begin
   stringgrid1.SaveToCSVFile('sys\face1.txt',#9);
end;

procedure Tlp.Button5Click(Sender: TObject);
var i : word; s,s1 : string;
begin
  stringgrid1.Cells[stringgrid1.Col,stringgrid1.Row] := memo2.Text;
  if stringgrid1.Col <> 3 then
  begin
    s := memo2.Text;
    s1 := stringgrid1.Cells[3,stringgrid1.Row];
    for i := 1 to stringgrid1.RowCount-1 do
    if stringgrid1.Cells[3,i]=s1 then
    stringgrid1.Cells[stringgrid1.Col,i] := s;
  end;
end;

end.

