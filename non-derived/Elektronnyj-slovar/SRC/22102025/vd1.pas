unit vd1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, Buttons, ComCtrls;

type

  { Tverdir }

  Tverdir = class(TForm)
    SpeedButton2: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton4: TSpeedButton;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ComboBox10Change(Sender: TObject);
    procedure ComboBox11Change(Sender: TObject);
    procedure ComboBox12CloseUp(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure ComboBox8Change(Sender: TObject);
    procedure ComboBox9Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseEnter(Sender: TObject);
    procedure SpeedButton1MouseLeave(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton2MouseEnter(Sender: TObject);
    procedure SpeedButton2MouseLeave(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton4MouseEnter(Sender: TObject);
    procedure SpeedButton4MouseLeave(Sender: TObject);
    procedure StringGrid2Click(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
  private

  public
     function convertX(s : string) : string;
     function getpl(s : string) : word;
     function getpf(s : string) : string;
  end;

type
  sid1 = record
       deva    : string;
       lipi    : string;
       beg     : longint;
       ed      : longint;
       Sd      : string;
       itr     : string[3];
       itr2    : string[3];
       itr3    : string;
       itr4v   : string;
       slp1    : char;
       lng     : real;
       snd     : string;
       gf      : string;
   end;
var
  verdir: Tverdir;
  lim : word = 55032;


implementation
uses rts,poisk,wrf,tx1,lns1,vpref,shellapi;
{$R *.lfm}

{ Tverdir }
var
    d : array[1..72] of sid1;
    x1 : byte = 0;
    x2 : byte = 4;

procedure Tverdir.FormCreate(Sender: TObject);
var i : word;
    j : byte;
    s : string;
begin
  stringgrid1.ColCount:=11;
  stringgrid1.RowCount:=55035;

for i := 0 to memo1.Lines.Count - 1 do
begin
    s := memo1.Lines.Strings[i];
    for j := 0 to 9 do
    begin
      stringgrid1.Cells[j,i] := copy(s,1,pos(';',s)-1);
      delete(s,1,pos(';',s));
    end;
    stringgrid1.Cells[10,i] := s;
end;

//  Stringgrid1.LoadFromCSVFile('sys\vdb2.csv',';');
  speedbutton1click(sender);
  d[1].deva := 'a';
  d[1].itr4v:='а';
  d[1].beg:= 1;
  d[1].ed:=24709;
  d[1].lipi:='अ';
  d[1].Sd:='';
  d[1].itr:='a';
  d[1].lng:= 1;
  d[1].snd:='a.wav';
  d[1].itr2:='a';
  d[1].itr3:='а';
  d[1].slp1:='a';

  d[2].deva := 'ā';
  d[2].itr4v:='а';
  d[2].beg:=  24710;
  d[2].ed:= 30756;
  d[2].lipi:='आ';
  d[2].Sd:='ा';
  d[2].itr:='A';
  d[2].lng:= 2;
  d[2].snd:='a1.wav';
  d[2].itr2:='aa';
  d[2].itr3:='А';
  d[2].slp1:='A';

  d[3].deva := 'i';
  d[3].itr4v:='и';
  d[3].beg:=  30757;
  d[3].ed:= 26737;
  d[3].lipi:='इ';
  d[3].Sd:='ि';
  d[3].itr:='i';
  d[3].lng:= 1;
  d[3].snd:='i.wav';
  d[3].itr2:='i';
  d[3].itr3:='и';
  d[3].slp1:='i';

  d[4].deva := 'ī';
  d[4].itr4v:='и';
  d[4].beg:= 26738;
  d[4].ed:= 26999;
  d[4].lipi:='ई';
  d[4].Sd:='ी';
  d[4].itr:='I';
  d[4].lng:= 2;
  d[4].snd:='ii.wav';
  d[4].itr2:='ii';
  d[4].itr3:='И';
  d[4].slp1:='I';

  d[5].deva := 'u';
  d[5].itr4v:='у';
  d[5].beg := 27000;
  d[5].ed:= 33138;
  d[5].lipi:='उ';
  d[5].Sd:='ु';
  d[5].itr:='u';
  d[5].lng:= 1;
  d[5].snd:='u.wav';
  d[5].itr2:='u';
  d[5].itr3:='у';
  d[5].slp1:='u';

  d[6].deva := 'ū';
  d[6].itr4v:='у';
  d[6].beg:= 33139;
  d[6].ed:= 33535;
  d[6].lipi:='ऊ';
  d[6].Sd:='ू';
  d[6].itr:='U';
  d[6].lng:= 2;
  d[6].snd:='u2.wav';
  d[6].itr2:='uu';
  d[6].itr3:='У';
  d[6].slp1:='U';

  d[11].deva := 'e';
  d[11].itr4v:='е';
  d[11].beg:=  34127;
  d[11].ed:= 34976;
  d[11].lipi:='ए';
  d[11].Sd:='े';
  d[11].itr:='e';
  d[11].lng:= 2;
  d[11].snd:='e.wav';
  d[11].itr2:='e';
  d[11].itr3:='е';
  d[11].slp1:='e';

  d[12].deva := 'o';
  d[12].itr4v:='о';
  d[12].beg:=  34977;
  d[12].ed:= 35178;
  d[12].lipi:='ओ';
  d[12].Sd:='ो';
  d[12].itr:='o';
  d[12].lng:= 2;
  d[12].snd:='o.wav';
  d[12].itr2:='o';
  d[12].itr3:='о';
  d[12].slp1:='o';

  d[13].deva := 'ai';
  d[13].itr4v:='ай';
  d[13].beg:=  35179;
  d[13].ed:= 35462;
  d[13].lipi:='ऐ';
  d[13].Sd:='ै';
  d[13].itr:='ai';
  d[13].lng:= 2;
  d[13].snd:='ai.wav';
  d[13].itr2:='ai';
  d[13].itr3:='аи';
  d[13].slp1:='E';

  d[14].deva := 'au';
  d[14].itr4v:='ау';
  d[14].beg  :=  35463;
  d[14].ed   := 35972;
  d[14].lipi:='औ';
  d[14].Sd:='ौ';
  d[14].itr:='au';
  d[14].lng:= 2;
  d[14].snd:='au.wav';
  d[14].itr2:='au';
  d[14].itr3:='ау';
  d[14].slp1:='O';

  d[7].deva := 'ṛ';
  d[7].itr4v:='ри';
  d[7].beg  :=  33536;
  d[7].ed   := 34117;
  d[7].lipi:='ऋ';
  d[7].Sd:='ृ';
  d[7].itr:='R^i';
  d[7].lng:= 1;
  d[7].snd:='r1.wav';
  d[7].itr2:='R';
  d[7].itr3:='Р';
  d[7].slp1:='f';

  d[8].deva := 'ṝ';
  d[8].itr4v:='ри';
  d[8].beg  :=  34118;
  d[8].ed   := 34119;
  d[8].lipi:='ॠ';
  d[8].Sd:='ॄ';
  d[8].itr:='R^I';
  d[8].lng:= 2;
  d[8].snd:='r2.wav';
  d[8].itr2:='RR';
  d[8].itr3:='Ъ';
  d[8].slp1:='F';

  d[9].deva := 'ḷ';
  d[9].itr4v:='ли';
  d[9].beg  :=  34120;
  d[9].ed   := 34125;
  d[9].lipi:='ऌ';
  d[9].Sd:='ॢ';
  d[9].itr:='L^i';
  d[9].lng:= 1;
  d[9].snd:='l1.wav';
  d[9].itr2:='LR';
  d[9].itr3:='лР';
  d[9].slp1:='x';


  d[10].deva := 'ḹ';
  d[10].itr4v:='ли';
  d[10].beg  :=  34126;
  d[10].ed   := 34126;
  d[10].lipi:='ॡ';
  d[10].Sd:='ॣ';
  d[10].itr:='L^I';
  d[10].lng:= 2;
  d[10].snd:='l2.wav';
  d[10].itr2:='LRR';
  d[10].itr3:='лЪ';
  d[10].slp1:='X';

  d[15].deva := 'k';
  d[15].itr4v:='к';
  d[15].beg  :=  35976;
  d[15].ed   := 50413;
  d[15].lipi:='क';
  d[15].Sd:='';
  d[15].itr:='k';
  d[15].lng:= 0.25;
  d[15].snd:='ka.wav';
  d[15].itr2:='k';
  d[15].itr3:='к';
  d[15].slp1:='k';

  d[16].deva := 'kh';
  d[16].itr4v:='кх';
  d[16].beg  :=  50414;
  d[16].ed   := 51592;
  d[16].lipi:='ख';
  d[16].itr:='kh';
  d[16].lng:= 0.5;
  d[16].snd:='kha.wav';
  d[16].itr2:='kh';
  d[16].itr3:='кх';
  d[16].slp1:='K';

  d[17].deva := 'g';
  d[17].itr4v:='г';
  d[17].beg  :=  51593;
  d[17].ed   := 56817;
  d[17].lipi:='ग';
  d[17].itr:='g';
  d[17].lng:= 0.25;
  d[17].snd:='ga.wav';
  d[17].itr2:='g';
  d[17].itr3:='г';
  d[17].slp1:='g';

  d[18].deva := 'gh';
  d[18].itr4v:='гх';
  d[18].beg  :=  56818;
  d[18].ed   := 57623;
  d[18].lipi:='घ';
  d[18].itr:='gh';
  d[18].lng:= 0.5;
  d[18].snd:='gha.wav';
  d[18].itr2:='gh';
  d[18].itr3:='гх';
  d[18].slp1:='G';

  d[19].deva := 'ṅ';
  d[19].itr4v:='н';
  d[19].beg  := 57624;
  d[19].ed   := 57628;
  d[19].lipi:='ङ';
  d[19].itr:='~N';
  d[19].lng:= 0.25;
  d[19].snd:='nga.wav';
  d[19].itr2:='G';
  d[19].itr3:='Г';
  d[19].slp1:='N';

  d[20].deva := 'ṭ';
  d[20].itr4v:='т';
  d[20].beg  := 57629;
  d[20].ed   := 57776;
  d[20].lipi:='ट';
  d[20].itr:='T';
  d[20].lng:= 0.25;
  d[20].snd:='ta1.wav';
  d[20].itr2:='T';
  d[20].itr3:='Т';
  d[20].slp1:='w';


  d[21].deva := 'ṭh';
  d[21].itr4v:='тх';
  d[21].beg  := 57777;
  d[21].ed   := 57797;
  d[21].lipi:='ठ';
  d[21].itr:='Th';
  d[21].lng:= 0.5;
  d[21].snd:='tha1.wav';
  d[21].itr2:='Th';
  d[21].itr3:='Тх';
  d[21].slp1:='W';


  d[22].deva := 'ḍ';
  d[22].itr4v:='д';
  d[22].beg  := 57798;
  d[22].ed   := 57963;
  d[22].lipi:='ड';
  d[22].itr:='D';
  d[22].lng:= 0.25;
  d[22].snd:='da1.wav';
  d[22].itr2:='D';
  d[22].itr3:='Д';
  d[22].slp1:='q';

  d[23].deva := 'ḍh';
  d[23].itr4v:='дх';
  d[23].beg  := 57964;
  d[23].ed   := 58004;
  d[23].lipi:='ढ';
  d[23].itr:='Dh';
  d[23].lng:= 0.5;
  d[23].snd:='dha1.wav';
  d[23].itr2:='Dh';
  d[23].itr3:='Дх';
  d[23].slp1:='Q';


  d[24].deva := 'ṇ';
  d[24].itr4v:='н';
  d[24].beg  := 58005;
  d[24].ed   := 58016;
  d[24].lipi:='ण';
  d[24].itr:='N';
  d[24].lng:= 0.25;
  d[24].snd:='na.wav';
  d[24].itr2:='N';
  d[24].itr3:='Н';
  d[24].slp1:='R';

  d[25].deva := 'c';
  d[25].itr4v:='ч';
  d[25].beg  := 58017;
  d[25].ed   := 61956;
  d[25].lipi:='च';
  d[25].itr:='c';
  d[25].lng:= 0.25;
  d[25].snd:='ca.wav';
  d[25].itr2:='c';
  d[25].itr3:='ч';
  d[25].slp1:='c';

  d[26].deva := 'ch';
  d[26].itr4v:='чх';
  d[26].beg  := 61957;
  d[26].ed   := 62537;
  d[26].lipi:='छ';
  d[26].itr:='Ch';
  d[26].lng:= 0.5;
  d[26].snd:='cha.wav';
  d[26].itr2:='ch';
  d[26].itr3:='чх';
  d[26].slp1:='C';

  d[27].deva := 'j';
  d[27].itr4v:='дж';
  d[27].beg  := 62538;
  d[27].ed   := 66186;
  d[27].lipi:='ज';
  d[27].itr:='j';
  d[27].lng:= 0.25;
  d[27].snd:='ja.wav';
  d[27].itr2:='j';
  d[27].itr3:='Ж';
  d[27].slp1:='j';

  d[28].deva := 'jh';
  d[28].itr4v:='джх';
  d[28].beg  := 66187;
  d[28].ed   := 66390;
  d[28].lipi:='झ';
  d[28].itr:='jh';
  d[28].lng:= 0.5;
  d[28].snd:='jha.wav';
  d[28].itr2:='jh';
  d[28].itr3:='Жх';
  d[28].slp1:='J';

  d[29].deva := 'ñ';
  d[29].itr4v:='н';
  d[29].beg  := 66391;
  d[29].ed   := 66393;
  d[29].lipi:='ञ';
  d[29].itr:='~n';
  d[29].lng:= 0.25;
  d[29].snd:='~na.wav';
  d[29].itr2:='J';
  d[29].itr3:='Ь';
  d[29].slp1:='Y';

  d[30].deva := 't';
  d[30].itr4v:='т';
  d[30].beg  := 66394;
  d[30].ed   := 72283;
  d[30].lipi:='त';
  d[30].itr:='t';
  d[30].lng:= 0.25;
  d[30].snd:='ta.wav';
  d[30].itr2:='t';
  d[30].itr3:='т';
  d[30].slp1:='t';

  d[31].deva := 'th';
  d[31].itr4v:='тх';
  d[31].beg  := 72284;
  d[31].ed   := 72313;
  d[31].lipi:='थ';
  d[31].itr:='th';
  d[31].lng:= 0.5;
  d[31].snd:='tha.wav';
  d[31].itr2:='th';
  d[31].itr3:='тх';
  d[31].slp1:='T';

  d[32].deva := 'd';
  d[32].itr4v:='д';
  d[32].beg  := 72314;
  d[32].ed   := 80441;
  d[32].lipi:='द';
  d[32].itr:='d';
  d[32].lng:= 0.25;
  d[32].snd:='da.wav';
  d[32].itr2:='d';
  d[32].itr3:='д';
  d[32].slp1:='d';

  d[33].deva := 'dh';
  d[33].itr4v:='дх';
  d[33].beg  := 80442;
  d[33].ed   := 82940;
  d[33].lipi:='ध';
  d[33].itr:='dh';
  d[33].lng:= 0.5;
  d[33].snd:='dha.wav';
  d[33].itr2:='dh';
  d[33].itr3:='дх';
  d[33].slp1:='D';

  d[34].deva := 'n';
  d[34].itr4v:='н';
  d[34].beg  := 82941;
  d[34].ed   := 91405;
  d[34].lipi:='न';
  d[34].itr:='n';
  d[34].lng:= 0.25;
  d[34].snd:='n1.wav';
  d[34].itr2:='n';
  d[34].itr3:='н';
  d[34].slp1:='n';

  d[35].deva := 'p';
  d[35].itr4v:='пх';
  d[35].beg  := 91406;
  d[35].ed   := 113723;
  d[35].lipi:='प';
  d[35].itr:='p';
  d[35].lng:= 0.25;
  d[35].snd:='pa.wav';
  d[35].itr2:='p';
  d[35].itr3:='п';
  d[35].slp1:='p';

  d[36].deva := 'ph';
  d[36].itr4v:='пх';
  d[36].beg  := 113724;
  d[36].ed   := 114310;
  d[36].lipi:='फ';
  d[36].itr:='ph';
  d[36].lng:= 0.5;
  d[36].snd:='pha.wav';
  d[36].itr2:='ph';
  d[36].itr3:='пх';
  d[36].slp1:='P';

  d[37].deva := 'b';
  d[37].itr4v:='б';
  d[37].beg  := 114311;
  d[37].ed   := 118443;
  d[37].lipi:='ब';
  d[37].itr:='b';
  d[37].lng:= 0.25;
  d[37].snd:='ba.wav';
  d[37].itr2:='b';
  d[37].itr3:='б';
  d[37].slp1:='b';

  d[38].deva := 'bh';
  d[38].itr4v:='бх';
  d[38].beg  := 118444;
  d[38].ed   := 123231;
  d[38].lipi:='भ';
  d[38].itr:='bh';
  d[38].lng:= 0.5;
  d[38].snd:='bha.wav';
  d[38].itr2:='bh';
  d[38].itr3:='бх';
  d[38].slp1:='B';

  d[39].deva := 'm';
  d[39].itr4v:='м';
  d[39].beg  := 123232;
  d[39].ed   := 134759;
  d[39].lipi:='म';
  d[39].itr:='m';
  d[39].lng:= 0.25;
  d[39].snd:='ma.wav';
  d[39].itr2:='m';
  d[39].itr3:='м';
  d[39].slp1:='m';

  d[40].deva := 'y';
  d[40].itr4v:='й';
  d[40].beg  := 134760;
  d[40].ed   := 138155;
  d[40].lipi:='य';
  d[40].itr:='y';
  d[40].lng:= 0.25;
  d[40].snd:='ya.wav';
  d[40].itr2:='y';
  d[40].itr3:='й';
  d[40].slp1:='y';

  d[41].deva := 'r';
  d[41].itr4v:='р';
  d[41].beg  := 138156;
  d[41].ed   := 143517;
  d[41].lipi:='र';
  d[41].itr:='r';
  d[41].lng:= 0.25;
  d[41].snd:='ra.wav';
  d[41].itr2:='r';
  d[41].itr3:='р';
  d[41].slp1:='r';

  d[42].deva := 'l';
  d[42].itr4v:='л';
  d[42].beg  := 143518;
  d[42].ed   := 146484;
  d[42].lipi:='ल';
  d[42].itr:='l';
  d[42].lng:= 0.25;
  d[42].snd:='la.wav';
  d[42].itr2:='l';
  d[42].itr3:='л';
  d[42].slp1:='l';

  d[43].deva := 'v';
  d[43].itr4v:='в';
  d[43].beg  := 146485;
  d[43].ed   := 165477;
  d[43].lipi:='व';
  d[43].itr:='v';
  d[43].lng:= 0.25;
  d[43].snd:='va.wav';
  d[43].itr2:='v';
  d[43].itr3:='в';
  d[43].slp1:='v';

  d[44].deva := 'ṣ';
  d[44].itr4v:='ш';
  d[44].beg  := 165478;
  d[44].ed   := 166063;
  d[44].lipi:='ष';
  d[44].itr:='S';
  d[44].lng:= 0.25;
  d[44].snd:='sh.wav';
  d[44].itr2:='Sh';
  d[44].itr3:='Ш';
  d[44].slp1:='z';

  d[45].deva := 'ś';
  d[45].itr4v:='ш';
  d[45].beg  := 166064;
  d[45].ed   := 176545;
  d[45].lipi:='श';
  d[45].itr:='sh';
  d[45].lng:= 0.25;
  d[45].snd:='sha.wav';
  d[45].itr2:='z';
  d[45].itr3:='ш';
  d[45].slp1:='S';

  d[46].deva := 's';
  d[46].itr4v:='с';
  d[46].beg  := 176546;
  d[46].ed   := 201633;
  d[46].lipi:='स';
  d[46].itr:='s';
  d[46].lng:= 0.25;
  d[46].snd:='sa.wav';
  d[46].itr2:='s';
  d[46].itr3:='с';
  d[46].slp1:='s';

  d[47].deva := 'h';
  d[47].itr4v := 'х';
  d[47].beg  := 201634;
  d[47].ed   := 205626;
  d[47].lipi:='ह';
  d[47].itr:='h';
  d[47].lng:= 0.25;
  d[47].snd:='ha.wav';
  d[47].itr2:='h';
  d[47].itr3:='х';
  d[47].slp1:='h';

  d[48].deva := 'ṁ';
  d[48].itr4v := 'м';
  d[48].beg  := 0;
  d[48].ed   := 0;
  d[48].lipi:='ं';
  d[48].Sd:='ं';;
  d[48].itr:='M';
  d[48].lng:= 0.25;
  d[48].snd:='';
  d[48].itr3:='М';
  d[48].slp1:='M';

  d[49].deva := 'ḥ';
  d[49].itr4v := 'х';
  d[49].Sd:='ः';
  d[49].beg  := 0;
  d[49].ed   := 0;
  d[49].lipi:='ः';
  d[49].itr:='H';
  d[49].lng:= 0.25;
  d[49].snd:='';
  d[49].itr3:='Х';
  d[49].slp1:='H';

  d[50].lipi:='्';
  d[50].deva:='';
  d[50].beg:=0;
  d[50].ed:=0;
  d[50].itr:='';
  d[50].lng:= 0.25;
  d[50].snd:='';
  d[50].slp1:=#0;

  d[51].lipi:='ँ';
  d[51].itr4v := 'н';
  d[51].deva:='m̩';
  d[51].beg:=0;
  d[51].ed:=0;
  d[51].itr:='^M';
  d[51].lng:= 0.25;
  d[51].snd:='';
  d[51].slp1:='M';

  d[52].lipi:='०';
  d[52].deva:='0';
  d[52].itr:='0';
  d[52].lng:= 0.25;

  d[53].lipi:='१';
  d[53].deva:='1';
  d[53].itr:='1';
  d[53].lng:= 0.25;

  d[54].lipi:='२';
  d[54].deva:='2';
  d[54].itr:='2';
  d[54].lng:= 0.25;

  d[55].lipi:='३';
  d[55].deva:='3';
  d[55].itr:='3';
  d[55].lng:= 0.25;

  d[56].lipi:='४';
  d[56].deva:='4';
  d[56].itr:='4';
  d[56].lng:= 0.25;

  d[57].lipi:='५';
  d[57].deva:='5';
  d[57].itr:='5';
  d[57].lng:= 0.25;

  d[58].lipi:='६';
  d[58].deva:='6';
  d[58].itr:='6';
  d[58].lng:= 0.25;

  d[59].lipi:='७';
  d[59].deva:='7';
  d[59].itr:='7';
  d[59].lng:= 0.25;

  d[60].lipi:='८';
  d[60].deva:='8';
  d[60].itr:='8';
  d[60].lng:= 0.25;

  d[61].lipi:='९';
  d[61].deva:='9';
  d[61].itr:='9';
  d[61].lng:= 0.25;

  d[62].lipi:='ऽ';
  d[62].deva:='.';
  d[62].itr:='.';
  d[62].lng:= 0.25;

  d[63].lipi:=#32;
  d[63].deva:=#32;
  d[63].itr:=#32;
  d[63].lng:= 0.25;

  d[64].lipi:='|';
  d[64].deva:='|';
  d[64].itr:='|';
  d[64].lng:= 0.25;

  d[65].lipi:='||';
  d[65].deva:='||';
  d[65].itr:='||';
  d[65].itr:='||';
  d[65].lng:= 0.25;

  d[66].lipi:='ॐ';
  d[66].deva:='O';
  d[66].itr:='OM';
  d[66].itr3:='ОМ';
  d[66].lng:= 2;

  d[67].lipi:='॑';
  d[67].deva:='';
  d[67].itr:='';
  d[67].lng:= 1;

  d[68].lipi:='॒';
  d[68].deva:='';
  d[68].itr:='';
  d[68].lng:= 1;

  d[69].lipi:='-';//'ꣳ';
  d[69].deva:='-';//'ꣳ';

  d[69].beg:=0;
  d[69].ed:=0;
  d[69].deva:='';
  d[69].itr:='';
  d[69].lng:= 1;

  d[70].lipi:='ळ';
  d[70].deva:='L.';
  d[70].beg:=0;
  d[70].ed:=0;
  d[70].itr:='L.';
  d[70].lng:=0.25;
  d[70].itr3:='Л';

  d[72].lipi:=')';
  d[72].deva:=')';
  d[72].itr:=')';
  d[72].lng:= 1;

  d[71].lipi:='(';
  d[71].deva:='(';
  d[71].beg:=0;
  d[71].ed:=0;



  d[71].lipi:='';
  d[71].deva:='';
  d[71].beg:=0;
  d[71].ed:=0;

  d[71].itr:='';
  d[71].lng:= 1;

{
  stringgrid1.ColCount:=stringgrid1.ColCount + 1;
  for i := 0 to stringgrid1.RowCount - 1 do
  stringgrid1.Cells[stringgrid1.ColCount-1,i] := inttostr(i+1);
  stringgrid1.SaveToCSVFile('vdb2.txt',';');
}
end;

procedure Tverdir.FormShow(Sender: TObject);
begin
  form1.bitbtn6.Caption := caption;
  form1.bitbtn6.show;
end;

procedure Tverdir.FormWindowStateChange(Sender: TObject);
begin
  if windowstate = wsminimized then
  begin
     form1.Panel18.Visible:=true;;
     form1.bitbtn6.Caption := caption;
     form1.bitbtn6.show;
//     form1.p18;
  end;
end;

procedure Tverdir.Label9Click(Sender: TObject);
begin
  checkbox1.Checked:=not(checkbox1.Checked);
  checkbox1change(sender);
end;

procedure Tverdir.SpeedButton1Click(Sender: TObject);
var i,j,k : word;
    c : dword;
    s : string;
    d1,d2,d3,d4,d5,d6,d7,d8,d9,d10 : boolean;
begin j := 1;
    c := 0;
    stringgrid2.Color:=clgray;;
    d1 := false;
    d2 := d1;d3 := d1;d4 := d1;d5 := d1;d6 := d1;
    d7 := d1;d8 := d1;d9 := d1;d10 := d1;
    stringgrid2.Clear;
    stringgrid2.RowCount:=stringgrid1.RowCount;
    s := edit1.Text;

    for i := 0 to stringgrid1.RowCount - 1 do
    begin
      if s = '' then d1 := true
      else
       case combobox8.ItemIndex of
       0 :   if (pos(s,stringgrid1.Cells[x1,i]) = 1) or
                (pos(s,stringgrid1.Cells[x2,i]) = 1) then d1 := true;
       1 :       if (pos(s+' ',stringgrid1.Cells[x1,i]+' ' ) > 0) or
                (pos(s+' ',stringgrid1.Cells[x2,i]+' ') > 0)
            then
            begin d1 := true;  end;


       3 :     if (pos(s,stringgrid1.Cells[x1,i])  > 0) or
                  (pos(s,stringgrid1.Cells[x2,i]) >  0) then d1 := true;

       2 :   if (s =stringgrid1.Cells[x1,i]) or (s=stringgrid1.Cells[x2,i])  then d1 := true;
      end;
      if (combobox1.ItemIndex = 0) or
         (stringgrid1.Cells[1,i] = combobox1.Text) then d2 := true;
      if (combobox2.ItemIndex = 0) or
         (stringgrid1.Cells[2,i] = combobox2.Text) then d3 := true;
      if (combobox3.ItemIndex = 0) or
         (stringgrid1.Cells[3,i] = combobox3.Text) then d4 := true;
      if (combobox4.ItemIndex = 0) or
         (stringgrid1.Cells[7,i] = combobox4.Text) then d5 := true;
      if (combobox5.ItemIndex = 0) or
         (stringgrid1.Cells[5,i] = combobox5.Text) then d6 := true;
      if (combobox6.ItemIndex = 0) or
         (stringgrid1.Cells[6,i] = combobox6.Text) then d7 := true;

      if d1 and d2 and d3 and d4 and d5 and d6 and d7 then
      begin
         stringgrid2.Rows[j] := stringgrid1.Rows[i];
         inc(j);
         if combobox10.ItemIndex=0 then break;
         if j > lim then break;
      end;
      d1 := false;
      d2 := d1;d3 := d1;d4 := d1;d5 := d1;d6 := d1;
      d7 := d1;d8 := d1;d9 := d1;d10 := d1;

    end;
    stringgrid2.RowCount:=j;
    statusbar1.Panels[1].Text:=inttostr(stringgrid2.RowCount - 1);
    stringgrid2.Color:=clwhite;
    if stringgrid2.RowCount > 1 then;
    for j := 1 to stringgrid2.RowCount - 1 do
    if stringgrid2.Cells[8,j] <> '' then inc(c,strtoint(stringgrid2.Cells[8,j]));
    statusbar1.Panels[3].Text:=inttostr(c);
    stringgrid2.Color:=clwhite;
    if stringgrid2.RowCount > 1 then
    for j := 1 to stringgrid2.RowCount - 1 do
    begin
      s := stringgrid2.Cells[8,j];
      while length(s) < 5 do s := ' '+s;
      stringgrid2.Cells[8,j] := s;
    end;
end;

procedure Tverdir.SpeedButton1MouseEnter(Sender: TObject);
begin
  speedbutton1.Transparent:=false;
end;

procedure Tverdir.SpeedButton1MouseLeave(Sender: TObject);
begin
  speedbutton1.Transparent:=true;
end;

procedure Tverdir.SpeedButton2Click(Sender: TObject);
begin
  if savedialog1.Execute then
  begin
     stringgrid2.SaveToCSVFile(savedialog1.FileName,#9,true,true);
   if form1.checkbox7.checked then
   shellexecute(0,'open',pchar(savedialog1.FileName),nil,nil,1);
  end;
end;

procedure Tverdir.SpeedButton2MouseEnter(Sender: TObject);
begin
//  speedbutton2.Transparent:=false;
end;

procedure Tverdir.SpeedButton2MouseLeave(Sender: TObject);
begin
//  speedbutton2.Transparent:=true;
end;

procedure Tverdir.SpeedButton3Click(Sender: TObject);
var f: text;
    s,s1 : string;
    i,j : word;
begin
    savedialog1.FilterIndex:=2;
    if savedialog1.Execute then
    begin
       assignfile(f,savedialog1.FileName)
//       rewrite(f);
       //s := '<>';
//       writeln(f,s,'Request:')
    end;
end;

procedure Tverdir.SpeedButton4Click(Sender: TObject);
begin
  roots := troots.Create(self);
  roots.Show;
  roots.Top:=top+clientheight-height + 114;
  roots.Left:=left+184;
end;

procedure Tverdir.SpeedButton4MouseEnter(Sender: TObject);
begin
  speedbutton4.Transparent:=false;
end;

procedure Tverdir.SpeedButton4MouseLeave(Sender: TObject);
begin
  speedbutton4.Transparent:=true;
end;

procedure Tverdir.StringGrid2Click(Sender: TObject);
begin
  if stringgrid2.Row > 0 then
  getpl(stringgrid2.Cells[0,stringgrid2.Row]);
end;

procedure Tverdir.StringGrid2DblClick(Sender: TObject);
var i,j,k : dword; s,s1 : string;
begin
  if stringgrid2.Row > 0 then
  begin
    k := 1;
    lns.StringGrid1.RowCount:=13000;
    j  := strtoint(stringgrid2.Cells[10,stringgrid2.Row]);
    s := memo2.Lines.Strings[j];
    if s <> '' then
    while s <> '' do
    begin
     s1 := copy(s,1,pos(' ',s)-1); delete(s,1,pos(' ',s));
     i := strtoint(s1);

     s1 := tx[strtoint(cp[strtoint(lx[i].cid)].tid)].tn;
     while pos('"',s1) > 0 do delete(s1,pos('"',s1),1);
     lns.StringGrid1.Cells[0,k] := s1;
     lns.StringGrid1.Cells[1,k] := cp[strtoint(lx[i].cid)].cn+': '+
     cp[strtoint(lx[i].cid)].ps;
     lns.StringGrid1.Cells[2,k] := lx[i].st;
     lns.StringGrid1.Cells[4,k] := lx[i].ln;
     s1 := ',';
     for j := 0 to length(snt[i]) - 1 do
     s1 := s1 + snt[i][j].osn +',';
     lns.stringgrid1.Cells[3,k] := s1;
     inc(k);
    end;
    lns.hw1.Clear;
    lns.Memo2.Clear;
    lns.Memo2.Text:= 'Verbal form from root "' +
    stringgrid2.Cells[0,stringgrid2.Row]+'"; Tense/Mood: '+
    stringgrid2.Cells[7,stringgrid2.Row]+'; ' + #13+#10+
    'Form: '+stringgrid2.Cells[4,stringgrid2.Row] +';' + #13+#10+
    'Person: '+stringgrid2.Cells[5,stringgrid2.Row] +'; Number: '+
    stringgrid2.Cells[6,stringgrid2.Row];
    lns.listbox1.Clear;
    lns.StringGrid1.RowCount:=k;
    if lns.WindowState = wsminimized then
    lns.WindowState:=wsnormal;
    lns.Show;
    lns.BringToFront;
  end;
end;

procedure Tverdir.Button1Click(Sender: TObject);
var f : text;
    i : longint;
begin
    assignfile(f,'rep.txt');
    rewrite(f);
    for i := 1 to stringgrid1.RowCount - 1 do
    if stringgrid1.Cells[2,i] = '10' then
    if pos('Past Passive',stringgrid1.Cells[7,i]) = 1 then
    writeln(f,
    Stringgrid1.Cells[4,i],'; - ',
    Stringgrid1.Cells[7,i],' от ;',
    Stringgrid1.Cells[0,i],';',
    Stringgrid1.Cells[5,i],';',
    Stringgrid1.Cells[6,i],';',
    Stringgrid1.Cells[9,i],';');
//    Stringgrid1.Cells[6,i],';',
//    Stringgrid1.Cells[7,i],';');


    closefile(f);

end;

procedure Tverdir.CheckBox1Change(Sender: TObject);
begin
  if checkbox1.Checked then
  begin
     combobox9.ItemIndex:=1;
     combobox8.ItemIndex:=0;
  end;
end;

procedure Tverdir.ComboBox10Change(Sender: TObject);
begin
  if checkbox1.Checked then
  speedbutton1click(sender);
end;

procedure Tverdir.ComboBox11Change(Sender: TObject);
begin
  case combobox11.ItemIndex of
       0 :begin x1 := 0;x2 := 4; end;
       1 :begin x1 := 0;x2 := 0; end;
       2 :begin x1 := 4;x2 := 4; end;
  end;
  speedbutton1click(sender);
end;

procedure Tverdir.ComboBox12CloseUp(Sender: TObject);
begin
  if combobox12.ItemIndex > 1 then
  if stringgrid2.Row > 0 then
  edit1.Text:=getpf(stringgrid2.Cells[0,stringgrid2.Row]);
end;

procedure Tverdir.ComboBox1Change(Sender: TObject);
begin
  if checkbox1.Checked then speedbutton1click(sender);
end;

procedure Tverdir.ComboBox2Change(Sender: TObject);
begin
   if checkbox1.Checked then speedbutton1click(sender);
end;

procedure Tverdir.ComboBox3Change(Sender: TObject);
begin
   if checkbox1.Checked then speedbutton1click(sender);
end;

procedure Tverdir.ComboBox4Change(Sender: TObject);
begin
 if checkbox1.Checked then speedbutton1click(sender);
end;

procedure Tverdir.ComboBox5Change(Sender: TObject);
begin
 if checkbox1.Checked then speedbutton1click(sender);
end;

procedure Tverdir.ComboBox6Change(Sender: TObject);
begin
 if checkbox1.Checked then speedbutton1click(sender);
end;

procedure Tverdir.ComboBox8Change(Sender: TObject);
begin
 speedbutton1click(sender);
end;

procedure Tverdir.ComboBox9Change(Sender: TObject);
begin
  case combobox9.ItemIndex of
  0 : lim := 10;
  1 : lim := 20;
  2 : lim := 50;
  3 : lim := 100;
  4 : lim := 1000;
  5 : lim := 55032;
  end;
   if checkbox1.Checked then
   speedbutton1click(sender);
end;

procedure Tverdir.Edit1Change(Sender: TObject);
var x : word;
begin
  if edit1.Text <> '' then
  begin
    x := edit1.SelStart;
    edit1.Text:=convertx(edit1.Text);
    edit1.SetFocus;
    edit1.SelStart:=x;
    getpl(Edit1.Text);
    if checkbox1.Checked then speedbutton1click(sender);

  end;
end;

procedure Tverdir.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key in [#13,#10] then speedbutton1click(sender);
end;

procedure Tverdir.FormActivate(Sender: TObject);
begin
  speedbutton4.AutoSize:=false;
  speedbutton4.Color:=clbtnface;
  speedbutton4.Transparent:=false;
  speedbutton4.Height:=edit1.Height;
end;

procedure Tverdir.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  form1.bitbtn6.hide;
  form1.p18;
end;

Function TVerDir.convertX(s : string) : string;
var i : byte;
   xc : word;
   zz : boolean;
begin
   zz := false;
   while pos('дж',s) > 0 do
   begin
      insert('j',s,pos('дж',s));
      delete(s,pos('дж',s),length('дж'));
   end;
   while pos('дЖ',s) > 0 do
   begin
      insert('j',s,pos('дЖ',s));
      delete(s,pos('дЖ',s),length('дЖ'));
   end;

   while pos('ж',s) > 0 do
   begin
      insert('j',s,pos('ж',s));
      delete(s,pos('ж',s),length('ж'));
   end;

   for i := 1 to 72 do
   if pos(d[i].itr3,s) > 0 then
   begin
     zz := true;
     break;
   end;
//   if zz then s := convertrus2(s);

   for xc := 1 to length(s) do
   begin
    i :=  pos('R^i',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ṛ',s,i);
    end;
    i :=  pos('R^I',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ṝ',s,i);
    end;
    i :=  pos('RR',s);
    if i > 0 then
    begin
      delete(s,i,2);
      insert('ṝ',s,i);
    end;
    i :=  pos('ṛṛ',s);
    if i > 0 then
    begin
      delete(s,i,length('ṛṛ'));
      insert('ṝ',s,i);
    end;



    i :=  pos('R',s);
    if i > 0 then
    begin
      delete(s,i,1);
      insert('ṛ',s,i);
    end;


    i :=  pos('L^i',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ḷ',s,i);
    end;
    i :=  pos('L^I',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ḹ',s,i);
    end;

    i :=  pos('lṛ',s);
    if i > 0 then
    begin
      delete(s,i,length('lṛ'));
      insert('ḷ',s,i);
    end;

    i :=  pos('ḷṛ',s);
    if i > 0 then
    begin
      delete(s,i,length('ḷṛ'));
      insert('ḹ',s,i);
    end;

    i :=  pos('lṝ',s);
    if i > 0 then
    begin
      delete(s,i,length('lṝ'));
      insert('ḹ',s,i);
    end;


     i :=  pos('A',s);
     if i > 0 then
     begin
       delete(s,i,1);

       insert('ā', s,i);
     end;
     i :=  pos('aa',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ā',s,i);
     end;
     i :=  pos('U',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ū',s,i);
     end;
     i :=  pos('uu',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ū',s,i);
     end;
     i :=  pos('I',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ī',s,i);
     end;
     i :=  pos('ii',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ī',s,i);
     end;
     i :=  pos('^N',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ṅ',s,i);
     end;
     i :=  pos('~N',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ṅ',s,i);
     end;
     i :=  pos('G',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṅ',s,i);
     end;
     i :=  pos('~n',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ñ',s,i);
     end;
     i :=  pos('J',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ñ',s,i);
     end;
     i :=  pos('^M',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert(d[51].deva,s,i);
     end;
     i :=  pos('N',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṇ',s,i);
     end;
     i :=  pos('T',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṭ',s,i);
     end;
     i :=  pos('D',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ḍ',s,i);
     end;
     i :=  pos('Sh',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ṣ',s,i);
     end;
     i :=  pos('S',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṣ',s,i);
     end;
     i :=  pos('sh',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ś',s,i);
     end;

     i :=  pos('z',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ś',s,i);
     end;

     i :=  pos('x',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('kṣ',s,i);
     end;
     i :=  pos('M',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṁ',s,i);
     end;
     i :=  pos('H',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ḥ',s,i);
     end;
end;
    ConvertX := s;
End;
function tverdir.getpl(s : string) : word;
var i : word; s1,s2 : string; c : word;
begin
    combobox12.Items.Clear;
    c := 0; s1 := '';
    combobox12.Items.Add('No Prefix');
    combobox12.Items.Add('Any Prefix');
    if s <> '' then
    for i := 0 to form6.StringGrid1.RowCount - 1 do
    if s = form6.StringGrid1.Cells[0,i] then
    begin s2 := form6.StringGrid1.Cells[3,i];
    if pos(','+s2+',',s1) = 0 then
    begin
       s1 := s1 + ','+s2+',';
       inc(c);
       combobox12.Items.Add(s2);
    end;

    end;
    combobox12.ItemIndex:=0;
    combobox12.Hint:='Total prefixes: '+inttostr(c);
    getpl := c;
end;
function tverdir.getpf(s : string) : string;
var i : word; s1 : string;
begin s1 := '';
    if combobox12.ItemIndex > 1 then
    begin
      for i := 1 to form6.stringGrid1.RowCount - 1 do
       if (form6.stringGrid1.cells[0,i] = s) and
          (form6.stringGrid1.cells[3,i] = combobox12.TEXt) then
      begin
         s1 := form6.stringGrid1.cells[1,i];
         break;
      end;
    end;
    getpf := s1;
end;

end.

