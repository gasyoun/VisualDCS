unit wrf;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, Menus, ComCtrls,shellapi;

type

  { TWR }

  TWR = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    Separator3: TMenuItem;
    MenuItem12: TMenuItem;
    Panel2: TPanel;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    Function GetGF(i : longint) : string;
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
  private

  public
     function GetCase(s : string) : String;
     Function GetGender(s : string) : string;
     Function GetTense(s : string)  : string;
     function GetNum(s : String) : String;
     function GetNp1 (x : string) : string;
     function GetNp2 (x : string) : string;
    procedure csr(s : string; var s1,s2,s3 : string);
  end;

var
  WR: TWR;
  GFS : string;
  const CSA : Array[0..8] of string = ('Any','Nom.','Voc.','Acc.','Ins.','Dat.','Abl.','Gen.','Loc.');
        GDA : Array[0..3] of string = ('Any','m.','f.','n.');
        FCA : Array[0..3] of string = ('Any person','1st.','2d.','3d.');
        NRA : Array[0..3] of string = ('Any','Sg.','Du.','Pl.');
        VFA : Array[0..42] of string = (
                'All Forms',
                'Present Ind.',
                'Pres. Potential',
                'Pres. Imp.',
                'Imperfect ind',
                'Future Ind.',
                'Future Cond.',
                'Future. Ind. Peri.',
                'Aorist Ind. Root.',
                'Aorist Ind. Them.',
                'Aorist Ind. Red.',
                'Aorist Ind. S.',
                'Aorist Ind. Is.',
                'Aorist Ind. Sa.',
                'Aorist Prec.',
                'Perfect Ind.',
                'Perfect Ind. Peri.',
                '17',
                '18',
                'Past Passive Participle',
                'Past Active Participle',
                'Future passive particle',
                'Infinitive',
                'Absolutive',
                'Present Passive',
                'Pres. Sub.',
                'Pres. Imperative Passive',
                'Imperfect Ind. Passive ',
                'Aorist Ind. Passive',
                'Pres. Opt Passive',
                'Aorist Jus.',
                '31',
                'Aorist Jus./Sub./Opt/Perf_Opt',
                'Aorist Imp.',
                '34',
                'Aorist Ind. Sis.',
                'Perfect Sub',
                'Perfect Jus.',
                'Perfect Opt.',
                'Perfect Imp',
                'Present Jus.',
                'Plp. ind.',
                'Aorist Sub.');
implementation
uses tx1,poisk,repo1,vf2,krr;
{$R *.lfm}

{ TWR }

procedure TWR.StringGrid1Click(Sender: TObject);
var i,j : longint;
    s : string;
begin
if stringgrid1.Col = 14 then
begin
  if stringgrid1.Cells[14,stringgrid1.Row] = '' then
     stringgrid1.Cells[14,stringgrid1.Row] := form1.SpeedButton21.Caption else
     stringgrid1.Cells[14,stringgrid1.Row] := '';
     formactivate(sender);
end
else
begin
    memo1.Clear;
    i := strtoint(stringgrid1.Cells[1,stringgrid1.Row]);
    s := lx[i].ln;

    memo1.Lines.Add(s);

    s := '';
    for j := 0 to length(snt[i]) - 1 do
    s := s + dcs1.getosn(snt[i,j].osn) + ' ';
    Edit1.Text := s;
    label2.Caption  :='Grammar form: '+(stringgrid1.Cells[11,stringgrid1.Row]);
end;
end;


procedure TWR.Button2Click(Sender: TObject);
begin
  if savedialog1.Execute then
  begin
    stringgrid1.SaveToCSVFile(savedialog1.FileName,#9,true,true);
    if form1.checkbox7.checked then
    shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
  end;
end;

procedure TWR.Button3Click(Sender: TObject);
var f : text; s : string;i: dword;
begin
    if stringgrid1.RowCount > 1 then
    if savedialog1.Execute then
    begin
      assignfile(f,savedialog1.FileName);rewrite(f);
      writeln(f,stringgrid1.columns[12].Title.Caption,#9,
                stringgrid1.columns[10].Title.Caption,#9,
                stringgrid1.columns[13].Title.Caption);
      for i := 1 to stringgrid1.RowCount - 1 do
      if stringgrid1.Cells[14,i] <> '' then
      begin
        writeln(f,stringgrid1.Cells[12,i],#9,
                  stringgrid1.Cells[10,i],#9,
                  stringgrid1.Cells[13,i]);
      end;
      closefile(f);
      showmessage('The Data saved to: '+ savedialog1.FileName);
    end;
end;

procedure TWR.FormActivate(Sender: TObject);
var s,s1 : string; i,j,k : dword;
begin
  j := 0;k := 0;
  statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount - 1);
  if stringgrid1.RowCount > 1 then
  begin
   for i := 1 to stringgrid1.RowCount - 1 do
   begin
     if stringgrid1.Cells[14,i] <> '' then inc(k);
     s1 := stringgrid1.Cells[12,i];delete(s1,1,1); s1 := '"' +copy(s1,1,pos('"',s1));
     if pos(s1,s) = 0 then
     begin
       s := s + s1;inc(j);
     end;
   end;
   statusbar1.Panels[3].Text:=inttostr(j);
  end
  else
  statusbar1.Panels[3].Text:='0';
  statusbar1.Panels[5].Text:=inttostr(k);
end;

procedure TWR.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  form1.BitBtn5.Hide;
  if kr.visible then kr.formstyle := fsstayontop;
end;

procedure TWR.Button1Click(Sender: TObject);
var s1,s2,s3,s : string;
    i,j,k : dword;
    z : boolean;
begin
  if stringgrid1.Row > 0 then
  begin
     z := false;
     s := stringgrid1.Cells[12,stringgrid1.Row];
     delete(s,1,1);
     s1 := copy(s,1,pos('"',s)); s1 := '"' +s1;
     delete(s,1,pos('"',s)+1);
     while pos(' ',s) = 1 do delete(s,1,1);
     s2 := copy(s,1,pos('#',s)-1)+':';
     delete(s,1,pos('#',s));
     s3 := s;

//     showmessage(s1+#13+#10+s2+#13+#10+s3);
     if dcs1.WindowState = wsminimized then dcs1.WindowState:=wsnormal;
     dcs1.Show;
     dcs1.BringToFront;
     for i := 0 to dcs1.ComboBox1.Items.Count-1 do
     if s1 = dcs1.combobox1.items[i] then
     begin
       dcs1.ComboBox1.ItemIndex:=i;
       dcs1.ComboBox1Change(nil);
       z := true;
       break;
     end;

     if z = false then begin
     showmessage('Error with searh for '+s1);
     exit;
     end;
     z := false;
     for j := 0 to dcs1.ComboBox2.Items.Count - 1 do
     if pos(s2,dcs1.ComboBox2.Items[j]) = 1 then
     begin
       dcs1.ComboBox2.Itemindex := j;
       dcs1.ComboBox2Change(sender);
       z := true;
       break;
     end;
     if z = false then
     begin
       showmessage('Error with searh for chapter:'+s2);
       exit;
    end;
     z := false;
     if  dcs1.ListBox1.Items.Count > 0 then
     for k := 0 to dcs1.ListBox1.Items.Count - 1 do
     if s3 = dcs1.ListBox1.Items[k] then
     begin
       dcs1.ListBox1.ItemIndex:=k;
       dcs1.ListBox1Click(sender);
       z := true;
        break;
     end;
       if z = false then showmessage('Error with Searching stanza: '+s3);

     dcs1.Show;
  end;
end;


procedure TWR.FormCreate(Sender: TObject);
begin
stringgrid1.SelectedColor:=form1.StringGrid1.SelectedColor;
end;

procedure TWR.FormShow(Sender: TObject);
begin
   form1.BitBtn5.Caption:=caption;
   form1.BitBtn5.Show;
end;

procedure TWR.FormWindowStateChange(Sender: TObject);
begin
  if windowstate = wsminimized then
  begin
    form1.BitBtn5.Caption:=caption;
    form1.BitBtn5.Show;
    if kr.visible then kr.formstyle := fsstayontop;
  end;
end;

procedure TWR.MenuItem10Click(Sender: TObject);
begin
  tz.Show;
  tz.PageControl1.ActivePageIndex:=1;
end;

procedure TWR.MenuItem12Click(Sender: TObject);
begin
  vforms.show;
  ids := GFS;
  if vforms.ComboBox4.items.Count > 0 then
  vforms.combobox4.itemindex:= vforms.ComboBox4.items.Count - 1;
end;

procedure TWR.MenuItem1Click(Sender: TObject);
var i,j,k : dword;s,s1,s2,s3 : string;
begin  j := 0;
  if statusbar1.Panels[5].Text <> '' then
  j := strtoint(statusbar1.Panels[5].Text);
  if j > 0 then
  if stringgrid1.RowCount > 1 then
  if tz.Stringgrid2.RowCount + j < repolim then
  begin
     k := tz.stringGrid2.RowCount;
     tz.Stringgrid2.RowCount := k + j;
     for i := 1 to stringgrid1.RowCount - 1 do
     if stringgrid1.cells[14,i] <> '' then
     begin
        s := stringgrid1.Cells[12,i];
        csr(s,s1,s2,s3);
        tz.stringgrid2.cells[0,k] := datetimetostr(date)+ ' ' + timetostr(time);
        tz.stringgrid2.cells[1,k] := s1;
        tz.stringgrid2.cells[2,k] := s2;
        tz.stringgrid2.cells[3,k] := s3;
        tz.stringgrid2.cells[4,k] := stringgrid1.Cells[10,i];
        tz.stringgrid2.cells[5,k] := '';
        tz.stringgrid2.cells[6,k] := '';
        inc(k);
     end;
     form1.infx('Repository','Total records added: '+ inttostr(j));
  end
  else
  form1.infx('Repository','Not enough free place in the repository');

end;

procedure TWR.MenuItem2Click(Sender: TObject);
var i : dword;
begin
   if stringgrid1.RowCount > 1 then
   for i := 1 to stringgrid1.RowCount-1 do
   begin
     stringgrid1.Cells[14,i] := form1.SpeedButton21.Caption;
   end;
   formactivate(sender);
end;

procedure TWR.MenuItem3Click(Sender: TObject);
var i : dword;
begin
   if stringgrid1.RowCount > 1 then
   for i := 1 to stringgrid1.RowCount-1 do
   begin
     stringgrid1.Cells[14,i] := '';
   end;
   formactivate(sender);
end;

procedure TWR.MenuItem4Click(Sender: TObject);
var i : dword;
begin
   if stringgrid1.RowCount > 1 then
   for i := 1 to stringgrid1.RowCount-1 do
   begin
     if i < stringgrid1.RowCount then
     while  ((i < stringgrid1.RowCount) and (stringgrid1.Cells[14,i] <> '')) do
            if i < stringgrid1.RowCount then
            stringgrid1.DeleteRow(i)
            else break;
     begin

     end;
   end;
   formactivate(sender);
end;

procedure TWR.MenuItem5Click(Sender: TObject);
var s  : string;
var t : trect;
    i,j : word;
begin
   j := 0;
   s := stringgrid1.Cells[12,stringgrid1.Row];
   delete(s,1,1); s := '"'+copy(s,1,pos('"',s));
   for i := 1 to stringgrid1.RowCount- 1 do
   if pos(s,stringgrid1.Cells[12,i]) = 1 then
   begin
      stringgrid1.Cells[14,i] := form1.SpeedButton21.Caption;
   end;
   formactivate(sender);
end;

procedure TWR.MenuItem6Click(Sender: TObject);
var i : dword;
begin
   if stringgrid1.RowCount > 1 then
   for i := 1 to stringgrid1.RowCount-1 do
   begin
     if stringgrid1.Cells[14,i] <> '' then
     stringgrid1.Cells[14,i] := '' else
     stringgrid1.Cells[14,i] := form1.SpeedButton21.Caption;
   end;
   formactivate(sender);

end;

procedure TWR.MenuItem7Click(Sender: TObject);
begin
   if stringgrid1.Row > 0 then stringgrid1.DeleteRow(stringgrid1.Row);
   formactivate(sender);
end;

procedure TWR.MenuItem8Click(Sender: TObject);
var s  : string;
var t : trect;
    i,j : word;
begin
   j := 0;
   s := stringgrid1.Cells[12,stringgrid1.Row];
   delete(s,1,1); s := '"'+copy(s,1,pos('"',s));
   for i := 1 to stringgrid1.RowCount- 1 do
   if pos(s,stringgrid1.Cells[12,i]) = 1 then
   begin
      stringgrid1.Cells[14,i] := '';
   end;
   formactivate(sender);
end;

procedure TWR.MenuItem9Click(Sender: TObject);
var s,s1,s2,s3 : string;i,k : dword;
begin
   if stringgrid1.Row > 0 then
   begin
     s := stringgrid1.Cells[12,stringgrid1.Row];
     csr(s,s1,s2,s3);
        if tz.Stringgrid2.RowCount + 1 < repolim then
        begin
           k := tz.stringGrid2.RowCount;
           tz.Stringgrid2.RowCount := k + 1;
           i := stringgrid1.Row;
           if i > 0 then
           begin
              tz.stringgrid2.cells[0,k] := datetimetostr(date)+ ' ' + timetostr(time);
              tz.stringgrid2.cells[1,k] := s1;
              tz.stringgrid2.cells[2,k] := s2;
              tz.stringgrid2.cells[3,k] := s3;
              tz.stringgrid2.cells[4,k] := stringgrid1.Cells[10,i];
              tz.stringgrid2.cells[5,k] := '';
              tz.stringgrid2.cells[6,k] := '';
           end;
           form1.infx('Repository','Total records added: 1');
        end
        else
        form1.infx('Repository','Not enough free place in the repository');

   end;

end;


Function TWr.GetGF(i : longint) : string;
var s,s1,s2,s3,s4,s5 : string;
    j,k : longint;
begin
    s := '';s1 := '';s4 :=''; s5 := '';
    if (stringgrid1.Cells[4,i] <> '0') then
    begin
      s1 := dcs1.listbox6.items[strtoint(Stringgrid1.Cells[4,i])];
      delete(s1,1,pos(',',s1));
      delete(s1,1,pos(',',s1));
      s2 := copy(s1,1,pos(',',s1) - 1);
      delete(s1,1,pos(',',s1));
      s3 := copy(s1,1,pos(',',s1) - 1);
      delete(s1,1,pos(',',s1));

      s4 := copy(s1,1,pos(',',s1) - 1);
      if s4 <> '' then
      j := strtoint(s4)
      else j :=0;
      s5 := inttostr(j mod 3);
      if s5 = '0' then s5 := '3';
      if j in [1..3] then s4 := 'Sg.';
      if j in [4..6] then s4 := 'Du.';
      if j in [7..9] then s4 := 'Pl';
      s := 'Verbal Form Finite: Form: ' + s2 +'; ' +
           'Tense:' + GetTense(s3) +'; Person: '+s4 +'; Number: '+ s5 + #13+#10;

    end;
    s2:='';     s3:='';     s4:='';     s5:='';
    if (stringgrid1.Cells[5,i] <> '0') then
    begin
      s1 := dcs1.listbox7.items[strtoint(Stringgrid1.Cells[5,i])];
      delete(s1,1,pos(',',s1));
      delete(s1,1,pos(',',s1));
      s2 := copy(s1,1,pos(',',s1) - 1);
      delete(s1,1,pos(',',s1));
      s3 := copy(s1,1,pos(',',s1) - 1);
      delete(s1,1,pos(',',s1));
      s4 := copy(s1,1,pos(',',s1) - 1);
      delete(s1,1,pos(',',s1));
      s5 := s1;
      s := s + 'Verbal Form Infinite: Form: ' + s2 +'; Stem:' + s3 +
           'Tense:' + GetTense(s4) +'; Noun Category: '+s5 +#13+#10;
    end;
    if stringgrid1.Cells[7,i] <> '0' then
    begin

      s := s + 'Case:'+ GetCase(Stringgrid1.Cells[6,i])+'; Number: '+
      GetNum(Stringgrid1.Cells[7,i])+'; Gender:'+
      GetGender(Stringgrid1.Cells[8,i]);
    end;
    GetGF := s;
end;

procedure TWR.StringGrid1DblClick(Sender: TObject);
begin
  Button1click(sender);
end;

procedure TWR.StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
begin
//  formactivate(sender);
end;

function Twr.GetCase(s : string) : String;
begin
    case s of
      '1' : GetCase := ' Nom. ';
      '2' : GetCase := ' Voc. ';
      '3' : GetCase := ' Acc. ';
      '4' : GetCase := ' Ins. ';
      '5' : GetCase := ' Dat. ';
      '6' : GetCase := ' Abl. ';
      '7' : GetCase := ' Gen. ';
      '8' : GetCase := ' Loc. ';


    else GetCase := '';

    end;
end;

Function Twr.GetGender(s : string) : string;
begin
   case s of
     '1' : GetGender := ' m. ';
     '2' : GetGender := ' f. ';
     '3' : GetGender := ' n. ';
   else   GetGender := '';

   end;
end;

Function Twr.GetTense(s : string)  : string;
begin
   case s of
{
        '1' : GetTense := ' Present Active ';
     '2':GetTense := ' Potential Active ';
     '3':GetTense := ' Imperative Active ';
     '4':GetTense := ' Imperfect Active ';
     '5':GetTense := ' Future Active ';
     '6':GetTense := ' Conditional Active ';
     '7':GetTense := ' PPF. Future Active ';
     '8':GetTense := ' Imperfect Active ';
     '9':GetTense := ' imprefect Medium ';
     '10':GetTense := ' Aorist Active ';
     '11':GetTense := ' Aorist Medium  ';
     '12':GetTense := ' Aorist Active ';
     '13':GetTense := ' Aorist Medium ';

     '14':GetTense := ' Benedictive Medium ';
     '15':GetTense := ' Perfect Active ';
     '17':GetTense := ' Subjunctive ? ';
     '16':GetTense := ' Non augment Imperfect ? ';

     '18':GetTense := '18';


     '19':GetTense := ' Past Passive Participle ';
     '20':GetTense := ' Past Active Participle ';
     '21':GetTense := ' Future passive particle ';
     '22':GetTense := ' Infinitive ';
     '23':GetTense := ' Absolutive ';
     '24':GetTense := ' Present Passive ';
     '25':GetTense := ' Imperative Passive';
     '26':GetTense := ' Imperative Passive ';
     '27':GetTense := ' Imperfect Passive ';
     '28':GetTense := ' Present Active Participle? ';
     '29': GetTense := ' Optative Passive ';
     '30':GetTense := ' Injunctive Act ';
     '31':GetTense := '31';
     '32':GetTense := '32';
     '33':GetTense := '33';
     '34':GetTense := '34';

     '35': GetTense := ' Present Active Participle? ';
     '36':GetTense := '36';
     '37':GetTense := '36';


     '38':GetTense := ' Subjunctive ? ';
     '39':GetTense := ' Subjunctive ? ';

     '40':GetTense := ' Present Active Participle ';
     '42':GetTense := ' Subjunctive ? ';
     '41':GetTense := ' Subjunctive ? ';
 }      '0' : GetTense :='All Forms';
        '1' : GetTense :='Present Ind.';
        '2':GetTense := 'Pres. Potential';
        '3':GetTense := 'Pres. Imp.';
        '4':GetTense := 'Imperfect ind';
        '5':GetTense := 'Future Ind.';
        '6':GetTense := 'Future Cond.';
        '7':GetTense := 'Future. Ind. Peri.';
        '8':GetTense := 'Aorist Ind. Root.';
        '9':GetTense := 'Aorist Ind. Them.';
        '10':GetTense := 'Aorist Ind. Red.';
        '11':GetTense := 'Aorist Ind. S.';
        '12':GetTense := 'Aorist Ind. Is.';
        '13':GetTense := 'Aorist Ind. Sa.';

        '14':GetTense := 'Aorist Prec.';
        '15':GetTense := 'Perfect Ind.';
        '17':GetTense := '17';
        '16':GetTense := 'Perfect Ind. Peri.';

        '18':GetTense := '18';


        '19':GetTense := 'Past Passive Participle';
        '20':GetTense := 'Past Active Participle';
        '21':GetTense := 'Future passive particle';
        '22':GetTense := 'Infinitive';
        '23':GetTense := 'Absolutive';
        '24':GetTense := 'Present Passive';
        '25':GetTense := 'Pres. Sub.';
        '26':GetTense := 'Pres. Imperative Passive';
        '27':GetTense := 'Imperfect Ind. Passive ';
        '28':GetTense := 'Aorist Ind. Passive';
        '29': GetTense := 'Pres. Opt Passive';
        '30':GetTense := 'Aorist Jus.';
        '31':GetTense := '31';
        '32':GetTense := ' Aorist Jus./Sub./Opt/Perf_Opt';
        '33':GetTense := ' Aorist Imp.';
        '34':GetTense := '34?';

        '35': GetTense := 'Aorist Ind. Sis.';
        '36':GetTense := 'Perfect Sub';
        '37':GetTense := ' Perfect Jus.';


        '38':GetTense := ' Perfect Opt.';
        '39':GetTense := ' Perfect Imp';

        '40':GetTense := ' Present Jus.';
        '42':GetTense := ' Aorist Sub.';
        '41':GetTense := ' Plp. ind.';


   else GetTense := s;

   end;

end;
function TWr.GetNum(s : String) : String;
begin
   case s of
       '1' :GetNum := 'Sg.';
       '2' :GetNum := 'Du.';
       '3' :GetNum := 'Pl.';
       else GetNum := s;
   end;
end;
function TWr.GetNp1 (x : string) : string;
begin
case x of
     '1' : GetNp1 := 'First';
     '2' : GetNp1 := 'Second';
     '3' : GetNp1 := 'third';
     '4' : GetNp1 := 'First';
     '5' : GetNp1 := 'Second';
     '6' : GetNp1 := 'third';
     '7' : GetNp1 := 'First';
     '8' : GetNp1 := 'Second';
     '9' : GetNp1 := 'third';
   else
    GetNp1 := x;
end;
end;
function TWr.GetNp2 (x : string) : string;
begin
case x of
     '1' : GetNp2 := 'Sg.';
     '2' : GetNp2 := 'Sg.';
     '3' : GetNp2 := 'Sg.';
     '4' : GetNp2 := 'Du.';
     '5' : GetNp2 := 'Du.';
     '6' : GetNp2 := 'Du.';
     '7' : GetNp2 := 'Pl.';
     '8' : GetNp2 := 'Pl.';
     '9' : GetNp2 := 'Pl.';
   else
    GetNp2 := x;

   end;

end;
procedure TWr.csr(s : string; var s1,s2,s3 : string);
begin
   delete(s,1,1);
   s1 := copy(s,1,pos('"',s)); s1 := '"' +s1;
   delete(s,1,pos('"',s)+1);
   while pos(' ',s) = 1 do delete(s,1,1);
   s2 := copy(s,1,pos('#',s)-1)+':';
   delete(s,1,pos('#',s));
   s3 := s;
end;

end.

