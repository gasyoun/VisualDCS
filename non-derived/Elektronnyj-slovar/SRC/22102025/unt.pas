unit Unt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, ComCtrls;

type

  { Tun }

  Tun = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    RadioGroup1: TRadioGroup;
    SaveDialog1: TSaveDialog;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private

  public
     function Convert1(s : string) : string;
     function gets4(i1 : longint) : string;
     function gets17(i1 : longint) : string;
     function getC(s : string) : string;
     function getrim(s : string) : string;
     Function gsn(s : word) : string;
     procedure SortS2;
     procedure SortS3;
     function GetSong(s : string) : string;
     Function GS(i : longint) : string;
     Function GetNC(i : longint; s : string) : longint;
  end;

var
  un: Tun;
  GC : word = 1;
  par, par2 : array[1..244] of word;
  AG,AV : array[1..244] of string;
 sa1, sa2 : array[1..4] of string;
  ifile,ofile : string;
implementation
uses shellapi, poisk,rusk;
{$R *.lfm}

{ Tun }

procedure Tun.Button1Click(Sender: TObject);
var bk,bk1 : byte;
    cp : word;
    pd : byte;
    i,j : longint;
    s1,s2,s3,s4,s5,s6,s17,s29,s30 : string;
    f : system.text;
    x : integer;
    k,m : word;
    g : string;
    pr,pr1 : integer;
    F7,f4 : system.TextFile;
    snum : longint;
    q,w,e : word;
    qq : string;
    x73 : longint;
    MaxU, UC : longint;
    RDI      : byte;
    CP1, cp0 : String;
    gd,avr   : string;
    BTL      : String;
    bl : word;
begin   CP1 := 'глава';cp0 := 'Книга';
  bl := 0;
  gd := ''; avr := '';
  RDI := radiogroup1.ItemIndex;
  case  rdi of
        0 : begin cp1 := 'глава';cp0 := 'Книга'; listbox4.Items.LoadFromFile('sys\rus\list1.txt'); end;
        1 : begin cp1 := 'гимн'; cp0 := 'Канда'; listbox4.Items.LoadFromFile('sys\rus\list2.txt');end;
        2 : begin cp1 := 'гимн'; cp0 := 'Мандала'; listbox4.Items.LoadFromFile('sys\rus\list2.txt');end;
        3 : begin cp1 := 'глава';cp0 := 'Книга'; listbox4.Items.LoadFromFile('sys\rus\list1.txt');end;
        4 : begin cp1 := 'песня';cp0 := 'Книга'; listbox4.Items.LoadFromFile('sys\rus\list1.txt');end;
  end;
  MaxU := 0; UC := 0;
  system.assign(f7,'Reports\paral.txt');
  rewrite(f7);
  for i := 1 to length(par) do
  begin
     par[i] := 0; par2[i] := 0;
  end;
  pr := 0;
  pr1 := 0;
  stringgrid4.LoadFromCSVFile('sys\T\capters.txt','_');

  system.assign(f,Edit2.Text);
  rewrite(f);
  bk := 1; cp := 1;
system.Assign(f4,edit1.Text);
reset(f4);
    stringgrid1.Clear;
    stringgrid1.RowCount:=200000;
    stringgrid1.ColCount:=128;
    i := 0;
    progressbar1.Max:=stringgrid1.RowCount;
    progressbar1.Step:=1000;
while not(eof(f4)) do
begin
    progressbar1.Position := i;;
    j := 0;
    readln(f4,s1);
    if s1 <> '' then
    while ((pos(';',s1) > 0) and (j < stringgrid1.ColCount)) do
    begin
        s2 := copy(s1,1,pos(';',s1)-1);
        delete(s1,1,pos(';',s1));
        while pos(' .',s2) > 0 do
        begin
          insert(' ''',s2,pos(' .',s2));
          delete(s2,pos(' .',s2),2);
        end;
        while pos('"',s2) > 0 do delete(s2,pos('"',s2),1);
        if j < stringgrid1.ColCount then
        stringgrid1.Cells[j,i] := s2;
        inc(j);
        if j >= stringgrid1.ColCount then
          begin
             inc(UC);
//             if MaxU < j then MaxU := j;
          end;


    end;
    inc(i);
end;
    stringgrid1.RowCount:=i;
    progressbar1.Position:=0;
    progressbar2.Max:=i;
    progressbar2.Step:=1000;

i := 0; j := 0; s2 := '';
s1 := '<HTML><body><center><font size = 4><b>'+
Edit3.Text +
'</center></font><p><font size = 3>';
//
    bk := 0;
    s5 := '';
    writeln(f,s1);

    for i := 0 to stringgrid1.RowCount - 1 do
    if stringgrid1.cells[0,i] <> '' then
    begin
       progressbar2.Position:=i;
       s17 := '';s6 := '';
       if stringgrid1.Cells[0,i] <> '' then
       s6 := stringgrid1.Cells[0,i];
       delete(s6,1,pos(', ',s6)+1);
       s4 := '';
       s4 := copy(s6,1,pos(',',s6)-1);
       delete(s6,1,pos(',',s6) + 1);
       s6 := copy(s6,1,pos(':',s6)-1);
       val(s4,bk1,x73);
       if x73 <> 0 then bk1 := 1;
       if bk <> bk1 then
       begin

          writeln(f,'<p><center><h2>',cp0,' ',GSN(Bk1),'<p></h2></center><p>');
          GC := 1;
          bk := bk1;
       end;
       g := convert1(stringgrid1.Cells[0,i]);
       if g <> s5 then
       begin
          writeln(f,'<p><center><h3><b>'+GetSong(s6)+' ',cp1,' </b><font color="$FF8DFF"> ['+getrim(inttostr(bk))+']</font></center></h3><p>');
          inc(gc);
          s5 := g;
       end;
       s4 := '';
       s3 := '';
       k  := 1;   m := 1;
       stringgrid2.Clear;
       stringgrid3.Clear;

       for j := 4 to stringgrid1.ColCount - 1 do
       if j < 1000 then
       begin
       if stringgrid1.Cells[j,i] = 'GOOD' then
       begin
          stringgrid2.RowCount:=k;
          stringgrid2.Cells[0,k-1] :=  stringgrid1.Cells[j-2,i];
          stringgrid2.Cells[1,k-1] :=  stringgrid1.Cells[j-1,i];
          stringgrid2.Cells[3,k-1] := '4';
          inc(k);
       end
       else
       if  stringgrid1.Cells[j,i] = 'PARTLY' then
       if checkbox3.Checked = false then
       begin
          stringgrid3.RowCount:=m;
          stringgrid3.Cells[0,m-1] :=  stringgrid1.Cells[j-2,i];
          stringgrid3.Cells[1,m-1] :=  stringgrid1.Cells[j-1,i];
          stringgrid3.Cells[2,m-1] :=  stringgrid1.Cells[j,i];
          stringgrid3.Cells[3,m-1] :=  stringgrid1.Cells[j+1,i];
          inc(m);
       end;
       end;


       s4 := '';s17 := '';
       gets4(i);
       gets17(i);
       s4 := ''; s17:='';
       qq := '';
       if stringgrid2.RowCount+stringgrid3.RowCount
          in [1..25] then
       for w := 1 to listbox1.Items.Count - 1 do
       if (ag[w] <> '') or (av[w] <> '') then
       begin
          s4 :=  ag[w]; s17 := av[w];
          if qq = '' then qq := 'в ' else qq := qq + ' в ';

          qq := qq +'«'+ listbox2.items[w] + '» (';

                if s4 <> '' then qq := qq + s4;
                if s4 <> '' then
                begin
                   if s17 <> '' then qq := qq + '; ' + s17
                end
                else if s17 <> '' then qq := qq + s17;
                qq := qq + '), ';
                s4 :='';s17 := '';
          end;

       if qq <> '' then
       begin
        delete(qq,length(qq)-1,2);
        qq := qq + '.<p>';
       end;
       for w := 1 to length(ag) do begin ag[w] := '';av[w] := ''; end;


s3 := '';

if qq <> '' then
begin
  s29 := stringgrid1.Cells[0,i];
  s30 := copy(s29,1,pos(', ',s29));
  delete(s29,1,pos(', ',s29)+1);
  s30 := s30 + ' '+copy(s29,1,pos(', ',s29));

  s29 := '"Rāmāyaṇa" '+s30 +' ' + inttostr(gc-1) +'. '+ stringgrid1.Cells[1,i];

//  Showmessage(stringgrid1.Cells[0,i] + '#'+stringgrid1.Cells[1,i] +#13+#10+s29);

Snum := rk.AdptN(Rdi,s29);

BTL := Rk.GetBtl(stringgrid1.Cells[0,i]+ ' ' +stringgrid1.Cells[1,i],snum);
              if (snum <> 0) then
              begin
                 s3 := copy(stringgrid1.Cells[1,i],1,pos(' ',stringgrid1.Cells[1,i]) - 1) + '. '+
                 '<i>'+rk.GetStr(rdi,snum,false) + '</i>' +
                 ' ('+GS(i) +') … — '
              end
              else
              begin
                if snum = 0 then
                s3 := '<font color = "#191970">'+copy(stringgrid1.Cells[1,i],1,pos(' ',stringgrid1.Cells[1,i]) - 1) + '. '+
                               '<i>'+'…'+ '</i>' +
                               ' ('+GS(i) +') … — <font color = "BLACK">'
                               else
                                 s3 := '<font color = "RED">'+copy(stringgrid1.Cells[1,i],1,pos(' ',stringgrid1.Cells[1,i]) - 1) + '. '+
                                                '<i>'+'…'+ '</i>' +
                                                ' ('+GS(i) +') … — <font color = "BLACK">'

              end;

end;

          inc(pr,stringgrid2.RowCount);
          inc(pr1,stringgrid3.RowCount);
if s3 <> '' then
begin
          if gd <> qq then
          s3 := s3 + qq
          else s3 := '';
          gd := qq;
          qq := s3;
          q := 0;  e := 0;
          while pos(',  в ',qq) > 0 do
          if pos(',  в ',qq) > 0 then
          begin
             q := pos(',  в ',qq);
             qq[q] := '\';
             inc(e);
          end;
          if e > 0 then
          begin
            delete(s3,q,2);
            insert(' и ',s3,q);
          end;


          while pos('@',s3) > 0 do
          begin
            insert(';',s3,pos('@',s3));
            delete(s3,pos('@',s3),1);
          end;



       while pos(' |',s3) > 0 do delete(s3,pos(' |',s3),2);
       while pos('|',s3) > 0 do delete(s3,pos('|',s3),1);
       if btl <> '' then
       begin
         s3 := s3 + '<br>'+btl + '<br>';
         inc(bl);
       end;
         writeln(f,'</b>',s3);

end;
       s4 := '';s17 := ''; qq := '';
       Stringgrid2.Clear;Stringgrid3.Clear;
    end;
    writeln(f,'</body></html>');
    system.Close(f);
    Writeln(f7,'Хороших параллелей: ',pr,#9,'Частичных параллелей: ',pr1);
    Writeln(f7,'Текст',#9,'Хороших',#9,'Частичных');
    for i := 1 to listbox2.Items.Count - 1 do
    if par[i] + par2[i] > 0 then
    writeln(f7,'в ',listbox2.Items[i],#9,par[i],#9,par2[i]);
    system.Close(f7);
    progressbar2.Position:=0;
//    showmessage(inttostr(UC)+'     '+inttostr(MaxU));
    Showmessage(inttostr(bl));
    if form1.checkbox7.Checked then
    shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
end;

procedure Tun.Button2Click(Sender: TObject);
begin
  if opendialog1.Execute then edit1.Text :=
  opendialog1.filename;
end;

procedure Tun.Button3Click(Sender: TObject);
begin
  if savedialog1.Execute then
  edit2.Text := savedialog1.FileName;
end;

procedure Tun.Button4Click(Sender: TObject);
var f : text;
    k,i,j : longint;
begin k := 0;
   system.Assign(f,'sys\rus\adpnsr.txt');
   rewrite(f);
   for i := 0 to rk.StringGrid6.RowCount-1 do
   begin write(f,rk.StringGrid6.Cells[0,i],#9);
     for j := 0 to rk.StringGrid5.RowCount - 1 do
     if rk.StringGrid6.Cells[0,i] = rk.StringGrid5.Cells[1,j]
     then begin write(f,rk.stringgrid5.Cells[0,j]); inc(k); break;  end;
     writeln(f,'');
   end;
    writeln(f,k);
    system.Close(f);;

end;

procedure Tun.Edit1Change(Sender: TObject);
begin
  if (fileexists(edit1.Text)) and
  (edit2.Text <> '') then
  button1.enabled := true;
end;

procedure Tun.Edit2Change(Sender: TObject);
begin
  if (fileexists(edit1.Text)) and
  (edit2.Text <> '') then
  button1.enabled := true;
end;

procedure Tun.FormCreate(Sender: TObject);
var i : word;
begin
for i := 1 to 4 do
begin
  sa1[i] := listbox1.Items[i];
  sa2[i] := listbox2.Items[i];
end;
end;

procedure Tun.RadioGroup1Click(Sender: TObject);
begin
    case radiogroup1.ItemIndex of
            1 : begin
                  listbox1.Items[1] := sa1[3];
                  listbox2.Items[1] := sa2[3];
                  listbox1.Items[2] := sa1[4];
                  listbox2.Items[2] := sa2[4];
                  listbox1.Items[3] := sa1[1];
                  listbox2.Items[3] := sa2[1];
                  listbox1.Items[4] := sa1[2];
                  listbox2.Items[4] := sa2[2];
                end;
            2 : begin
              listbox1.Items[1] := sa1[4];
              listbox2.Items[1] := sa2[4];
              listbox1.Items[2] := sa1[3];
              listbox2.Items[2] := sa2[3];
              listbox1.Items[3] := sa1[1];
              listbox2.Items[3] := sa2[1];
              listbox1.Items[4] := sa1[2];
              listbox2.Items[4] := sa2[2];

                end;
            3 : begin
              listbox1.Items[1] := sa1[1];
              listbox2.Items[1] := sa2[1];
              listbox1.Items[2] := sa1[2];
              listbox2.Items[2] := sa2[2];
              listbox1.Items[3] := sa1[3];
              listbox2.Items[3] := sa2[3];
              listbox1.Items[4] := sa1[4];
              listbox2.Items[4] := sa2[4];

                end;
            4 : begin
              listbox1.Items[1] := sa1[2];
              listbox2.Items[1] := sa2[2];
              listbox1.Items[2] := sa1[1];
              listbox2.Items[2] := sa2[1];
              listbox1.Items[3] := sa1[3];
              listbox2.Items[3] := sa2[3];
              listbox1.Items[4] := sa1[4];
              listbox2.Items[4] := sa2[4];

                end;



    end;
end;

function Tun.Convert1(s : string) : string;
var s1,s2,s3 : string;
    i  : word;
begin
 Delete(s,1,pos(':',s) + 1);
 Convert1 := s;
end;
function Tun.gets4(i1 : longint) : string;
var i,j,k : word;
    s : string;
    s1: string;
    xxx : string;
    z : boolean;
begin
    xxx := '';
    s := '';
    if stringgrid2.RowCount > 0 then
    begin
    for i := 1 to length(aG) do aG[i] := '';

    for i := 0 to listbox1.items.Count - 1 do
    for j := 0 to stringgrid2.RowCount-1 do
    if pos(listbox1.items[i],stringgrid2.Cells[0,j]) = 1 then
    begin
       s1 :=  stringgrid2.Cells[0,j];
       delete(s1,1,length(listbox1.items[i]) + 1);
       if (i <> 1) or (Checkbox1.Checked = false) then
       begin
          aG[i] := aG[i] + GetC(s1) + ', ';
          inc(par[i]);
       end
       else
       begin
         s1 := stringgrid2.Cells[0,j];
         if GetNC(i1,s1) < GetNC(0,s1) then
//         Showmessage(inttostr(GetNC(i1,s1)) + ' '+ inttostr(GetNC(0,s1)));
         begin
            aG[i] := aG[i] + GetC(s1) + ', ';
            inc(par[i]);
         end;
       end;
       stringgrid2.Cells[0,j] := '';
//       break;
    end;
    for i := 1 to length(AG) do
    if ag[i] <> '' then
    begin
      delete(ag[i],length(ag[i])-1,2);
      ag[i] := '<font color="blue">см.: ' + ag[i]+'</font>';
    end;
    s := '';

    end;
end;

function Tun.gets17(i1 : longint) : string;
var i,j,k : word;
    s : string;
    s1: string;
    xx3 : string;
begin

    s := '';
    if stringgrid3.RowCount > 0 then
    begin
    for i := 1 to length(aV) do aV[i] := '';
    for i := 0 to listbox1.items.Count - 1 do
    for j := 0 to stringgrid3.RowCount-1 do
    if pos(listbox1.items[i],stringgrid3.Cells[0,j]) = 1 then
    begin

       s1 :=  stringgrid3.Cells[0,j];
       delete(s1,1,length(listbox1.items[i]) + 1);
       xx3 := stringgrid3.Cells[3,j];
       if pos('+',xx3) > 0 then delete(xx3,pos('+',xx3),2);
       if pos('-',xx3) > 0 then
       begin
          insert('вм. ',xx3,pos('-',xx3));
          delete(xx3,pos('-',xx3),1);
       end;
       stringgrid3.Cells[3,j] := xx3;
//       if stringgrid3.Cells[3,j] <> '' then
       s1 := stringgrid3.Cells[0,j];
       if (i <> 1) or (checkbox1.Checked = false) then
       begin
          aV[i] := aV[i] +  GetC(s1)+ ' <font color ="$007AE3"> '+stringgrid3.cells[3,j] +'</font>, ';
          inc(par2[i]);
       end
       else
       if GetNC(i1,s1) < GetNC(0,s1) then
       begin
         aV[i] := aV[i] +  GetC(s1)+ ' <font color ="$007AE3"> '+stringgrid3.cells[3,j] +'</font>, ';
         inc(par2[i]);

       end;
//       break;
         stringgrid3.Cells[0,j] := '';
       end;


    for i := 1 to length(AV) do
    if av[i] <> '' then
    begin
      delete(av[i],length(av[i])-1,2);
      av[i] := '<font color="green">ср.: ' + av[i]+'</font>';
    end;
    s := '';
    end;
end;
function Tun.getC(s : string) : string;
var s1,s2,s3,s4,s7 : string;
    i : word;
begin
    s7 := copy(s,1,pos(', ',s));
    delete(s,1,pos(', ',s)+1);
    s1 := copy(s,1,pos(',',s)-1);
    delete(s,1,pos(',',s));

    s1 := GetRim(s1);
//    delete(s,1,1);
    s2 := copy(s,1,pos(':',s) - 1);
    delete(s,1,pos(':',s)+1);
    delete(s,1,pos(' ',s));

    if pos(' ',s) > 0 then
    s3 := copy(s,1,pos(' ',s) - 1)
    else s3 := s;
//    delete(s,1,pos(' ',s));

      if s1 <> '' then s1 := s1 + '. ';
      if s2 <> '' then s2 := s2 + '. ';
      if s3 <> '' then s3 := s3;

getC := s1+ s2+ s3;//+ s;


end;
function Tun.getrim(s : string) : string;
begin
   case s of
        '1' :  getrim := 'I';
        '2' :  getrim := 'II';
        '3' :  getrim := 'III';
        '4' :  getrim := 'IV';
        '5' :  getrim := 'V';
        '6' :  getrim := 'VI';
        '7' :  getrim := 'VII';
        '8' :  getrim := 'VIII';
        '9' :  getrim := 'IX';
        '10' :  getrim := 'X';
        '11' :  getrim := 'XI';
        '12' :  getrim := 'XII';
        '13' :  getrim := 'XIII';
        '14' :  getrim := 'XIV';
        '15' :  getrim := 'XV';
        '16' :  getrim := 'XVI';
        '17' :  getrim := 'XVII';
        '18' :  getrim := 'XVIII';
        '19' :  getrim := 'XIX';
        '20' :  getrim := 'XX';
        '21' :  getrim := 'XXI';
        '22' :  getrim := 'XXII';
        '23' :  getrim := 'XXIII';
        '24' :  getrim := 'XXIV';
        '25' :  getrim := 'XXV';
        '26' :  getrim := 'XXVI';
        '27' :  getrim := 'XXVII';
        '28' :  getrim := 'XXVIII';
        '29' :  getrim := 'XXIX';
        '30' :  getrim := 'XXX';
        '31' :  getrim := 'XXXI';
   else
      getrim := 'I';

   end;
end;
function Tun.gsn(s : word) : string;
begin
   Case radiogroup1.ItemIndex of
        3 :
   case s of
        1 : gsn := 'первая АДИПАРВА';//'первая. БАЛАКАНДА';// (КНИГА О ДЕТСТВЕ)';
        2 : gsn := 'вторая САБХАПАРВА';//'вторая. АЙОДХЬЯКАНДА';// (КНИГА ОБ АЙОДХЬЕ)';
        3 : gsn := 'третья АРАНЬЯКАПАРВА';//'третья. АРАНЬЯКАНДА';// (КНИГА О ЛЕСЕ)';
        5 : gsn := 'четвертая УДЪЙОГАПАРВА';//'четвертая. КИШКХИНДАКАНДА';// (КНИГА О КИШКХИНДЕ)';
        4 : gsn := 'пятая ВИРАТАПАРВА';//'пятая. СУНДАРАКАНДА';// (КНИГА О ПРЕКРАСНОМ)';
        6 : gsn := 'шестав БХИШМАПАРВА';//'шестая. ЮДДХАКАНДА';// (КНИГА О БИТВЕ ОБЕЗЬЯНЬЕГО ВОЙСКА РАМЫ С ВОЙСКОМ ДЕМОНОВ РАВАНЫ)';
        7 : gsn := 'седьмая ДРОНАПАРВА';//'седьмая. УТТАРАКАНДА';// (ЗАКЛЮЧИТЕЛЬНАЯ КНИГА)';
        8 : gsn := 'восьмая КАРНАПАРВА';
        9 : gsn := 'девятая ШАЛЬЯПАРВА';
        10 : gsn := 'десятая САУПТИКАПАРВА';
        11 : gsn := 'одиннадцатая СТРИПАРВА';
        12 : gsn := 'двенадцатая ШАНТИПАРВА';
        13 : gsn := 'тринадцатая АНУШАСАНАПАРВА';
        14 : gsn := 'четырнадцатая АШВАМЕДХИКАПАРВА';
        15 : gsn := 'пятнадцатая АШРАМАВАСИКАПАРВА';
        16 : gsn := 'шестнадцатая МАУСАЛАПАРВА';
        17 : gsn := 'семнадцатая МАХАПРАСТХАНИКАПАРВА';
        18 : gsn := 'восемнадцатая СВАРГАРОХАНИКАПАРВА';
      end;
        4 :
        case s of
        1 : gsn := 'первая. БАЛАКАНДА';// (КНИГА О ДЕТСТВЕ)';
        2 : gsn := 'вторая. АЙОДХЬЯКАНДА';// (КНИГА ОБ АЙОДХЬЕ)';
        3 : gsn := 'третья. АРАНЬЯКАНДА';// (КНИГА О ЛЕСЕ)';
        5 : gsn := 'четвертая. КИШКХИНДАКАНДА';// (КНИГА О КИШКХИНДЕ)';
        4 : gsn := 'пятая. СУНДАРАКАНДА';// (КНИГА О ПРЕКРАСНОМ)';
        6 : gsn := 'шестая. ЮДДХАКАНДА';// (КНИГА О БИТВЕ ОБЕЗЬЯНЬЕГО ВОЙСКА РАМЫ С ВОЙСКОМ ДЕМОНОВ РАВАНЫ)';
        7 : gsn := 'седьмая. УТТАРАКАНДА';// (ЗАКЛЮЧИТЕЛЬНАЯ КНИГА)';
     end;
        else gsn := getrim(inttostr(s));
      end;
   end;
procedure Tun.SortS2;
var s0,s1,s2,s3 : string;
    i,j : word;
begin
   s0 := '';s1:='';s2:='';s3:='';
   if stringgrid2.RowCount > 1 then
   for i := 0 to stringgrid2.RowCount - 1 do
   for j := 0 to stringgrid2.RowCount - 2 do
   if strtoint(stringgrid2.Cells[3,j]) >
      strtoint(stringgrid2.Cells[3,j+1]) then
      begin
        s0 := stringgrid2.Cells[0,j];  s1 := stringgrid2.Cells[1,j];
        s2 := stringgrid2.Cells[2,j];  s3 := stringgrid2.Cells[3,j];

        stringgrid2.Cells[0,j] := stringgrid2.Cells[0,j+1];
        stringgrid2.Cells[1,j] := stringgrid2.Cells[1,j+1];
        stringgrid2.Cells[2,j] := stringgrid2.Cells[2,j+1];
        stringgrid2.Cells[3,j] := stringgrid2.Cells[3,j+1];

        stringgrid2.Cells[0,j+1] := s0;
        stringgrid2.Cells[1,j+1] := s1;
        stringgrid2.Cells[2,j+1]:= s2;
        stringgrid2.Cells[3,j+1] := s3;
      end;

end;
procedure Tun.SortS3;
var s0,s1,s2,s3 : string;
    i,j : word;
begin
   s0 := '';s1:='';s2:='';s3:='';
   if stringgrid3.RowCount > 1 then
   for i := 0 to stringgrid3.RowCount - 1 do
   for j := 0 to stringgrid3.RowCount - 2 do
   if strtoint(stringgrid3.Cells[3,j]) >
      strtoint(stringgrid3.Cells[3,j+1]) then
      begin
        s0 := stringgrid3.Cells[0,j];  s1 := stringgrid3.Cells[1,j];
        s2 := stringgrid3.Cells[2,j];  s3 := stringgrid3.Cells[3,j];

        stringgrid3.Cells[0,j] := stringgrid3.Cells[0,j+1];
        stringgrid3.Cells[1,j] := stringgrid3.Cells[1,j+1];
        stringgrid3.Cells[2,j] := stringgrid3.Cells[2,j+1];
        stringgrid3.Cells[3,j] := stringgrid3.Cells[3,j+1];

        stringgrid3.Cells[0,j+1] := s0;
        stringgrid3.Cells[1,j+1] := s1;
        stringgrid3.Cells[2,j+1]:= s2;
        stringgrid3.Cells[3,j+1] := s3;
      end;

end;
function Tun.GetSong(s : string) : string;
begin
  if s  <> '' then
  begin
     GetSong := listbox4.Items[strtoint(s)];
  end
  else  GetSong := '';
end;
function Tun.GS(i : longint) : string;
var s,s1,s2,s3 : string;
    j : longint;
begin
 if checkbox2.Checked then
 begin;
    s2 := '';s3 := '';
    s1 := '';
    s := stringgrid1.Cells[0,i];
    s1 := stringgrid1.Cells[1,i];
    s1 := copy(s1,1,pos(' ',s1)-1);
    for j := 0 to i do
    if s =  stringgrid1.Cells[0,j] then
    begin
       s3 := stringgrid1.Cells[1,j];
       s3 := copy(s3,1,pos(' ',s3) - 1);
       if s3 = s1 then
       s2 := s2 +  stringgrid1.Cells[2,j];
    end;
    GS := s2;
end
else
  Gs := stringgrid1.Cells[2,i];
end;
Function TUn.GetNC(i : longint; s : string) : longint;
var j : longint;
    s2: string;
begin  j := 0;
   if i <> 0 then
   begin
     s2 := stringgrid1.Cells[1,i];
     if pos(' ',s2) > 0 then s2 := copy(s2,1,pos(' ',s2)-1);
     if s2 = '' then s2 := '0';
     s := stringgrid1.Cells[0,i] + ' '+s2;
   end;
   Delete(s,1,pos(':',s)+1);
   if s <> '' then
   begin
      if pos(' ',s) = 0 then j := strtoint(s)*500
      else
        begin
          s2 := copy(s,1,pos(' ',s) - 1);
          delete(s,1,pos(' ',s));
          j := strtoint(s2)*500;
          if pos(' ',s) > 0 then delete(s,1,pos(' ',s) - 1);
          if s <> '' then j := j + strtoint(s);
        end;

   end
   else j := 0;
   GetNC := j;
end;

end.

