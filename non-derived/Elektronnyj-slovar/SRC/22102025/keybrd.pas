unit keybrd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, ExtCtrls, HtmlView, shellapi;

type

  { Tsymba }

  Tsymba = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox1: TGroupBox;
    hw: THtmlViewer;
    MenuItem1: TMenuItem;
    MenuItem103: TMenuItem;
    MenuItem104: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem101: TMenuItem;
    MenuItem102: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MenuItem101Click(Sender: TObject);
    procedure MenuItem102Click(Sender: TObject);
    procedure MenuItem103Click(Sender: TObject);
    procedure MenuItem104Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
  private

  public

  end;

var
  symba: Tsymba;

implementation
uses poisk,sfo,gram,dcon, mmsystem,lgg,clipbrd;
type
  sett = record
    c1 : boolean;
    c2 : boolean;
    c3 : boolean;
  end;

var prev : byte = 0;
{$R *.lfm}

{ Tsymba }

procedure Tsymba.FormCreate(Sender: TObject);
var a : byte;
    f : file of sett;
    st : sett;
begin
  for a := 1 to 51 do
  with form1 do
  begin
     sym[a] := Tlabel.create(self);
     sym[a].Parent := symba;;
     sym[a].Visible:=true;
        sym[a].Caption:= d[a].lipi;
        sym[a].Hint:=d[a].deva;



     sym[a].Transparent:=true;
     sym[a].Alignment:=tacenter;
     sym[a].Layout:=tlcenter;
     sym[a].Color := ClNone;
     sym[a].ParentFont:=true;
     sym[a].ShowHint:=true;
     sym[a].AutoSize:=false;
     sym[a].Height:=60;//round((clientheight - 32) / 12);
     sym[a].Width:=60;//round(width/20);
     sym[a].OnClick:=symba.OnClick;
     sym[a].OnMouseEnter:=symba.OnMouseEnter;
     sym[a].OnMouseLeave:=symba.OnMouseLeave;
     sym[a].OnDblClick:= symba.OnDblClick;
     sym[a].PopupMenu := symba.PopupMenu1;
  end;
  for a := 1 to 14 do
  begin
     sym[a].Left:=a*sym[a].Width - sym[a].Width + 5;
     sym[a].Top:=0;
  end;

  for a := 15 to 19 do
  begin
    sym[a].Left:=(a - 14)*sym[a].Width - sym[a].Width + sym[a].Width*2;
    sym[a].Top:=sym[a].Height;
  end;


  for a := 20 to 24 do
  begin
     sym[a].Left:=(a - 19)*sym[a].Width - sym[a].Width + sym[a].Width*2;
     sym[a].Top:=sym[a].Height*2;
  end;

  for a := 25 to 29 do
  begin
     sym[a].Left:=(a - 24)*sym[a].Width - sym[a].Width + sym[a].Width*2;
     sym[a].Top:=sym[a].Height*3;
  end;
  for a := 30 to 34 do
  begin
     sym[a].Left:=(a - 29)*sym[a].Width - sym[a].Width + sym[a].Width*2;
     sym[a].Top:=sym[a].Height*4;
  end;

  for a := 35 to 39 do
  begin
     sym[a].Left:=(a - 34)*sym[a].Width - sym[a].Width + sym[a].Width*2;
     sym[a].Top:=sym[a].Height*5;
  end;

  for a := 40 to 43 do
  begin
    sym[a].Left:=(a - 39)*sym[a].Width - sym[a].Width + sym[a].Width*2;
    sym[a].Top:=sym[a].Height*6;
  end;

  for a := 44 to 51 do
  begin
    sym[a].Left:=(a - 44)*sym[a].Width - sym[a].Width + sym[a].Width*2;
    sym[a].Top:=sym[a].Height*7;
  end;
  if fileexists('sys\kb.set') then
  begin
    assignfile(f,'sys\kb.set');
    reset(f);
    read(f,st);
    checkbox1.Checked := st.C1;
    checkbox2.Checked := st.C2;
    checkbox3.Checked := st.C3;
    closefile(f);
  end;
end;


procedure Tsymba.FormMouseEnter(Sender: TObject);
var a : byte;
begin
    for a := 1 to 51 do
    begin
       if sender=sym[a] then
       begin
         sym[a].Color := Clsilver;
         sym[a].Transparent:=false;
//         sym[a].Font.Color:=ClWhite;
       end;
    end;
end;

procedure Tsymba.FormMouseLeave(Sender: TObject);
var a : byte;
begin
  for a := 1 to 51 do
      begin
         if sender=sym[a] then
         begin
           sym[a].Color := Clnone;
           sym[a].Font.Color:=Clblack;
           sym[a].Transparent:=true;
         end;
      end;
end;

procedure Tsymba.FormResize(Sender: TObject);
begin
//symba.FormCreate(sender);
//symba.GroupBox1.Width:=round(symba.Width/3);
//symba.GroupBox1.top:=sym[1].height + 24;
//symba.GroupBox1.Height:=symba.ClientHeight - symba.GroupBox1.Top- 24;
//symba.GroupBox1.Left:=symba.Width  - symba.GroupBox1.Width;

end;

procedure Tsymba.MenuItem101Click(Sender: TObject);
begin
  hw.CopyToClipboard;
end;

procedure Tsymba.MenuItem102Click(Sender: TObject);
begin
  hw.SelectAll;
end;

procedure Tsymba.MenuItem103Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.google.com/?sl=auto&tl=ru&text='+s+'&op=translate')
  ,nil,nil,1);


end;

procedure Tsymba.MenuItem104Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.yandex.ru/?source_lang=en&target_lang=ru&text='+s)
  ,nil,nil,1);




//https://translate.yandex.ru/?source_lang=en&target_lang=ru&text=hi


end;

procedure Tsymba.MenuItem1Click(Sender: TObject);
var a : word;
begin
  ginfo := true;
  sf.ComboBox1.Clear;

  for a := 1 to 51 do
  sf.ComboBox1.Items.Add(d[a].lipi);
  sf.ComboBox3.Items := sf.ComboBox1.Items;
  sf.ComboBox2.Items := sf.ComboBox1.Items;
  sf.ComboBox3.ItemIndex:=0;

  for a := 1 to 51 do
  if popupmenu1.PopupComponent = sym[a] then
  begin
      sf.ComboBox1.ItemIndex:= a - 1;
      sf.StringGrid2.cells[0,1] := d[a].itr;
      sf.StringGrid2.cells[1,1] := d[a].deva;
      sf.ComboBox2.ItemIndex:=a - 1 ;
  end
  else
  begin
     sf.ComboBox1.ItemIndex:= 0;
     sf.StringGrid2.cells[0,1] := d[1].itr;
     sf.StringGrid2.cells[1,1] := d[1].deva;
     sf.ComboBox2.ItemIndex:=0 ;
  end;
  sf.ComboBox3.ItemIndex:=0;
  sf.ComboBox1Change(sender);
  sf.show;
end;

procedure Tsymba.MenuItem2Click(Sender: TObject);
var zz    : string;
    i, j  : longint;
    k     : longint;
    d1    : string;

    syl,syl1 : array[1..16,15..47] of string;
begin
zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
      '<font face="Mangal" size = "5">' +
      '<center><b><A NAME = "C1"></A>THE SYLABLES TABLE<br><FONT SIZE = "5">' +
      '<br>TABLE OF CONTENTS<br>' +
      '</b></center><left><br>' +
      '<table width = "100%" rules = "ALL" border = "2">';

      for j := 15 to 47 do
      begin
      for i := 1 to 16 do
      begin
         if i < 15 then
         k := i
         else
           case i of
                15 : k := 48;
                16 : k := 49;

           end;
           if i  > 14 then d1 := d[j].deva + 'a'
           else d1 := d[j].deva;
           d1 := d1  + d[k].deva;
           syl1[i,j] := d1;
           zz := zz +
           '<td width = "6%"><A href = "#'+d1+'">' + d[j].lipi + d[k].Sd + ' '  + d1  + '</A></td>';
           sf.findinfo(d1,d[j].beg,d[j].ed,false,syl[i,j]);
      end;
         zz := zz + '<tr>';
      end;
      zz := zz + '</table><br><center><font size = "5"><b>Delails</b></center><br>' +
                 '<table width = "100%" rules = "ALL" border = "2">' +
                 '<td width = "6%" valign = "top">Syllable</td><td width = "94%" valign = "top">Translation</td><tr>';

      for i := 1  to 16 do
      for j := 15 to 47 do
      zz  := zz + '<td width = "6%" valign = "top"><A NAME = "' + syl1[i,j] + '"></A><A href = "#C1">' + syl1[i,j] + '</A></td>' +
                  '<td width = "94%" valign = "top">' + syl[i,j] + '</td><tr>';

       zz := zz +
      '</body></html>';

      sf.Memo1.Text:=zz;
  if nn.SaveDialog1.Execute then
  begin
     sf.Memo1.Lines.SaveToFile(nn.SaveDialog1.FileName);
        if form1.CheckBox7.Checked then
        shellexecute(0,'Open',pchar(nn.savedialog1.FileName),'',nil,1);
  end;

  sf.Memo1.Clear;
end;

procedure Tsymba.MenuItem3Click(Sender: TObject);
var zz, ss,dd : string;
    a,i,j : longint;
begin
  ginfo := false;
sf.ComboBox1.Clear;

for a := 1 to 51 do
sf.ComboBox1.Items.Add(d[a].lipi);
sf.ComboBox3.Items := sf.ComboBox1.Items;
sf.ComboBox2.Items := sf.ComboBox1.Items;
sf.ComboBox3.ItemIndex:=0;

for a := 1 to 51 do
if popupmenu1.PopupComponent = sym[a] then
begin
    sf.ComboBox1.ItemIndex:= a - 1;
    sf.StringGrid2.cells[0,1] := d[a].itr;
    sf.StringGrid2.cells[1,1] := d[a].deva;
    sf.ComboBox2.ItemIndex:=a - 1 ;
end;
sf.ComboBox3.ItemIndex:=0;
sf.ComboBox1Change(sender);
zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
      '<font face="Mangal" size = "5">' +
      '<center><b><A NAME = "C1"><A>THE DEVANAGARI ALPHABET<br><FONT SIZE = "5">' +
      '<br>TABLE OF CONTENTS<br>' +
      '<font size = "2">' +
      '<A href = "#VV">Voval sounds</A><br>' +
      '<A href = "#CV">Velar consonants</A><br>' +
      '<A href = "#CC">Cerebral consonants</A><br>' +
      '<A href = "#CP">Palatal consonants</A><br>' +
      '<A href = "#CD">Dental consonants</A><br>' +
      '<A href = "#CL">Labial consonants</A><br>' +
      '<A href = "#CN">Non-axial sonants</A><br>' +
      '<A href = "#CHS">Sibilant consonants</A><br>' +
      '<A href = "#CH">Guttural consonant "ha"</A><br>' +
      '<A href = "#SS">The Special signs</A><br>' +


      '<A NAME = "VV"></A>' +
      'Vowel:</b></center><left><br>' +
      '<table width = "100%" rules = "ALL" border = "2">' +
      '<td width = "7%" align = "center"><font size = "3" ><b>Symbol</td>' +
      '<td width = "7%" align = "center"><font size = "3"><b>ITRANS</td>' +
      '<td width = "86%" align = "center"><font size = "3"><b>Translation</td><tr>';

      for a := 1 to 5 do
      begin
         sf.ComboBox1.ItemIndex:=a-1;
         sf.ComboBox1Change(sender);
      zz := zz +
      '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
      '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + '</td>' +
      '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';

      sf.ComboBox1.ItemIndex:=a + 4;
      sf.ComboBox1Change(sender);
   zz := zz +
   '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a+5].lipi + '</td>' +
   '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a+5].deva + '</td>' +
   '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';


      end;

      for a := 11 to 14 do
      begin
         sf.ComboBox1.ItemIndex:=a-1;
         sf.ComboBox1Change(sender);
      zz := zz +
      '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
      '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + '</td>' +
      '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';

      end;

      zz := zz + '</table>' +
      '<A href = "#C1">Return to the table of contents </A>' +

      '<center>' +
      '<br><FONT SIZE = "5">' +
      '<A NAME = "CV"></A>' +
            'Consonants:<br>Velar sounds</b></center><left><br>' +
            '<table width = "100%" rules = "ALL" border = "2">' +
            '<td width = "7%" align = "center"><font size = "3" ><b>Symbol</td>' +
            '<td width = "7%" align = "center"><font size = "3"><b>ITRANS</td>' +
            '<td width = "86%" align = "center"><font size = "3"><b>Translation</td><tr>';

            for a := 15 to 19 do
            begin
               sf.ComboBox1.ItemIndex:=a-1;
               sf.ComboBox1Change(sender);
            zz := zz +
            '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
            '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + 'a</td>' +
            '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';

            end;

            zz := zz + '</table><center>' +        '<font size = "2"><left><A href = "#C1">Return to the table of contents </A>' +
            '<br><FONT SIZE = "5">' +
            '<A NAME = "CC"></A>' +
                  'Consonants:<br>Cerebral sounds</b></center><left><br>' +
                  '<table width = "100%" rules = "ALL" border = "2">' +
                  '<td width = "7%" align = "center"><font size = "3" ><b>Symbol</td>' +
                  '<td width = "7%" align = "center"><font size = "3"><b>ITRANS</td>' +
                  '<td width = "86%" align = "center"><font size = "3"><b>Translation</td><tr>';

                  for a := 20 to 24 do
                  begin
                     sf.ComboBox1.ItemIndex:=a-1;
                     sf.ComboBox1Change(sender);
                  zz := zz +
                  '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
                  '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + 'a</td>' +
                  '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';

                  end;
                  zz := zz + '</table><center>' +          '<font size = "2"><left><A href = "#C1">Return to the table of contents </A>' +
                  '<br><FONT SIZE = "5">' +
                  '<A NAME = "CP"></A>' +
                        'Consonants:<br>Palatal sounds</b></center><left><br>' +
                        '<table width = "100%" rules = "ALL" border = "2">' +
                        '<td width = "7%" align = "center"><font size = "3" ><b>Symbol</td>' +
                        '<td width = "7%" align = "center"><font size = "3"><b>ITRANS</td>' +
                        '<td width = "86%" align = "center"><font size = "3"><b>Translation</td><tr>';

                        for a := 25 to 29 do
                        begin
                           sf.ComboBox1.ItemIndex:=a-1;
                           sf.ComboBox1Change(sender);
                        zz := zz +
                        '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
                        '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + 'a</td>' +
                        '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';

                        end;

                        zz := zz + '</table><center>' +         '<font size = "2"><left><A href = "#C1">Return to the table of contents </A>' +
                        '<br><FONT SIZE = "5">' +
                        '<A NAME = "CD"></A>' +
                              'Consonants:<br>Dental sounds</b></center><left><br>' +
                              '<table width = "100%" rules = "ALL" border = "2">' +
                              '<td width = "7%" align = "center"><font size = "3" ><b>Symbol</td>' +
                              '<td width = "7%" align = "center"><font size = "3"><b>ITRANS</td>' +
                              '<td width = "86%" align = "center"><font size = "3"><b>Translation</td><tr>';

                              for a := 30 to 34 do
                              begin
                                 sf.ComboBox1.ItemIndex:=a-1;
                                 sf.ComboBox1Change(sender);
                              zz := zz +
                              '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
                              '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + 'a</td>' +
                              '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';

                              end;

                              zz := zz + '</table><center>' +       '<font size = "2"><left><A href = "#C1">Return to the table of contents </A>' +
                              '<br><FONT SIZE = "5">' +
                              '<A NAME = "CL"></A>' +
                              'Consonants:<br>Labial sounds</b></center><left><br>' +
                              '<table width = "100%" rules = "ALL" border = "2">' +
                              '<td width = "7%" align = "center"><font size = "3" ><b>Symbol</td>' +
                              '<td width = "7%" align = "center"><font size = "3"><b>ITRANS</td>' +
                              '<td width = "86%" align = "center"><font size = "3"><b>Translation</td><tr>';
                              for a := 35 to 39 do
                              begin
                                sf.ComboBox1.ItemIndex:=a-1;
                                sf.ComboBox1Change(sender);
                                zz := zz +
                                '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
                                '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + 'a</td>' +
                                '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';
                              end;

                              zz := zz + '</table><center>' +       '<font size = "2"><left><A href = "#C1">Return to the table of contents </A>' +
                              '<br><FONT SIZE = "5">' +
                              '<A NAME = "CN"></A>' +
                              'Consonants:<br>Non-axial sonants</b></center><left><br>' +
                              '<table width = "100%" rules = "ALL" border = "2">' +
                              '<td width = "7%" align = "center"><font size = "3" ><b>Symbol</td>' +
                              '<td width = "7%" align = "center"><font size = "3"><b>ITRANS</td>' +
                              '<td width = "86%" align = "center"><font size = "3"><b>Translation</td><tr>';
                              for a := 40 to 43 do
                              begin
                                sf.ComboBox1.ItemIndex:=a-1;
                                sf.ComboBox1Change(sender);
                                zz := zz +
                                '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
                                '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + 'a</td>' +
                                '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';
                              end;

                              zz := zz + '</table><center>' +         '<font size = "2"><left><A href = "#C1">Return to the table of contents </A>' +
                              '<br><FONT SIZE = "5">' +
                              '<A NAME = "CHS"></A>' +
                              'Consonants:<br>Sibilant sound</b></center><left><br>' +
                              '<table width = "100%" rules = "ALL" border = "2">' +
                              '<td width = "7%" align = "center"><font size = "3" ><b>Symbol</td>' +
                              '<td width = "7%" align = "center"><font size = "3"><b>ITRANS</td>' +
                              '<td width = "86%" align = "center"><font size = "3"><b>Translation</td><tr>';
                              for a := 44 to 46 do
                              begin
                                sf.ComboBox1.ItemIndex:=a-1;
                                sf.ComboBox1Change(sender);
                                zz := zz +
                                '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
                                '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + 'a</td>' +
                                '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';
                              end;
                              zz := zz + '</table><center>' +        '<font size = "2"><left><A href = "#C1">Return to the table of contents </A>' +
                              '<br><FONT SIZE = "5">' +
                              '<A NAME = "CH"></A>' +
                              'Consonants:<br>Guttural sounds</b></center><left><br>' +
                              '<table width = "100%" rules = "ALL" border = "2">' +
                              '<td width = "7%" align = "center"><font size = "3" ><b>Symbol</td>' +
                              '<td width = "7%" align = "center"><font size = "3"><b>ITRANS</td>' +
                              '<td width = "86%" align = "center"><font size = "3"><b>Translation</td><tr>';
                              for a := 47 to 47 do
                              begin
                                sf.ComboBox1.ItemIndex:=a-1;
                                sf.ComboBox1Change(sender);
                                zz := zz +
                                '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
                                '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + 'a</td>' +
                                '<td width = "86%" align = "left" valign = "top"><font size = "2">' + sf.Memo1.Text  + '</td><tr>';
                              end;

                              zz := zz + '</table><center>' +        '<font size = "2"><left><A href = "#C1">Return to the table of contents </A>' +
                              '<A NAME = "SS"></A>' +
                              '<br><FONT SIZE = "5">' +
                              'The special signs</b></center><left><br>' +
                              '<table width = "100%" rules = "ALL" border = "2">' +
                              '<td width = "7%" align = "center"><font size = "3" ><b>Symbol</td>' +
                              '<td width = "7%" align = "center"><font size = "3"><b>ITRANS</td>' +
                              '<td width = "86%" align = "center"><font size = "3"><b>Translation</td><tr>';
                              for a := 48 to 51 do
                              begin
                                zz := zz +
                                '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].lipi + '</td>' +
                                '<td width = "7%" align = "center" valign = "top"><font size = "5">' + d[a].deva + '</td>';
                              case a of
                                   49 : begin
                                          ss := 'visarga';
                                          i  := d[43].beg;
                                          j  := d[43].ed;
                                        end;
                                   50 :begin
                                          ss := 'viram';
                                          i  := d[43].beg;
                                          j  := d[43].ed;
                                        end;
                                   48 :begin
                                          ss := 'anusvāra';
                                          i  := d[1].beg;
                                          j  := d[1].ed;
                                        end;
                                   51 :begin
                                          ss := 'anunāsika';
                                          i  := d[1].beg;
                                          j  := d[1].ed;
                                        end;
                                 end;
                                 dd := '';
                                sf.findinfo(ss,i,j,false,dd);
                                zz := zz +
                                '<td width = "86%" align = "left" valign = "top"><font size = "2">' + dd  + '</td><tr>';
                              end;
                             zz := zz +  '</table><font size = "2"><left><A href = "#C1">Return to the table of contents </A></body></html>';
      sf.Memo1.Text:=zz;
      if nn.SaveDialog1.Execute then
      begin
        sf.Memo1.Lines.SaveToFile(nn.SaveDialog1.FileName);
            if form1.CheckBox7.Checked then
            shellexecute(0,'Open',pchar(nn.savedialog1.FileName),'',nil,1);
      end;
      sf.Memo1.Clear;

end;

procedure Tsymba.MenuItem4Click(Sender: TObject);
var zz, d1 : string;
    i,j : longint;
begin
      zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
            '<font face="Mangal" size = "5">' +
            '<center><b>THE LIGATURES TABLE<br><FONT SIZE = "4"><br></center><left>' +
            'NOte! Here are all possible ligatures without taking into account the rules of compatibility. ' +
            '<table width = "100%" rules = "ALL" border = "2">';

      for i := 15 to 47 do
      begin
         zz := zz + '<td width = "6%" align = "center" valign = "top"><font face = "Chandas" size = "4"><b>' + d[i].lipi + ' '+d[i].deva + 'a</td>';
         d1 := '';
         for j := 15 to 47 do
             d1 := D1 + d[i].lipi + d[50].lipi + d[j].lipi + '-' + d[i].deva + d[j].deva + 'a ';
         zz := zz + '<td width = "94%" align = "left" valign = "top"><font face = "Chandas" size = "4"><b>' + d1 + '</td><tr>';
      end;

      sf.Memo1.Text:=zz;
  if nn.SaveDialog1.Execute then
  begin
     sf.Memo1.Lines.SaveToFile(nn.SaveDialog1.FileName);
        if form1.CheckBox7.Checked then
        shellexecute(0,'Open',pchar(nn.savedialog1.FileName),'',nil,1);
  end;

  sf.Memo1.Clear;
end;

procedure Tsymba.MenuItem5Click(Sender: TObject);
begin
  formstyle := fsnormal;
  liga.Show;

end;

procedure Tsymba.MenuItem6Click(Sender: TObject);
begin
  dc.show;
end;

procedure Tsymba.MenuItem7Click(Sender: TObject);
var a : byte;
begin
  for a := 1 to 51 do
  if popupmenu1.PopupComponent = sym[a] then
  begin
   if fileexists(sdir +d[a].snd) then
   begin
     playsound(pchar(sdir+d[a].snd),0,0);
  end
  else
  showmessage('File: "' + sdir+d[a].snd + '" not found..');
  break;
  end;
end;






procedure Tsymba.CheckBox1Change(Sender: TObject);
var a : byte;
begin
  for a := 1 to 51 do
  if symba.checkbox1.Checked then
  begin
    sym[a].Caption:='';
    sym[a].Caption:= d[a].deva;
    sym[a].Hint:=d[a].lipi
  end

  else
    begin
    sym[a].Caption:='';
     sym[a].Caption:= d[a].lipi;
     sym[a].Hint:=d[a].deva;

    end;


end;

procedure Tsymba.CheckBox2Change(Sender: TObject);
begin
  groupbox1.Visible := checkbox2.Checked;
end;

procedure Tsymba.FormClick(Sender: TObject);
var a  : byte;
    s  : string;
    z  : boolean;
begin  z := false;

  if form1.Edit2.Text = '' then prev := 0;
  for a := 1 to 51 do
  if sender = sym[a] then
  begin
     z := true;
     break;
  end;
{
  if z then
  if checkbox1.Checked then
  form1.Edit2.Text:= form1.Edit2.Text + sym[a].Caption
  else
    begin
       if (prev = 0) or
          ((prev < 15) and (a > 14)) then
          form1.Edit2.Text:= form1.Edit2.Text + sym[a].Caption;

          if (prev > 14) and (a < 15) then
          form1.Edit2.Text:= form1.Edit2.Text  + d[a].sd;

          if (prev > 14) and (a > 14) and (a < 48) then
          form1.Edit2.Text:= form1.Edit2.Text +  d[a].lipi;


          if (prev > 0) and (a > 47)  then
          form1.Edit2.Text:= form1.Edit2.Text + d[a].lipi;




    end;
  if z then prev := a;
  if form1.Edit2.Text = '' then prev := 0;;

form1.Edit2.SelStart:=length(form1.Edit2.TextHint);
form1.Edit2.SetFocus;
}
if checkbox2.Checked then
begin
  if a in [1..14] then
  sf.findinfo(d[a].deva,d[a].beg,d[a].ed,true,s)
  else
    if a < 48 then
    sf.findinfo(d[a].deva+'a',d[a].beg,d[a].ed,true,s)
    else
     sf.findinfo('a'+d[a].deva,d[a].beg,d[a].ed,true,s);
  hw.clear;
  hw.DefFontName:=form1.Memo1.Font.Name;
  hw.DefFontSize:=form1.Memo1.Font.Size;
  hw.loadfromstring(s);
end;
if checkbox3.Checked then
if fileexists(sdir +d[a].snd)
then
begin
   playsound(pchar(sdir+d[a].snd),0,0);
end;

end;

procedure Tsymba.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var f : file of sett;st : sett;
begin
  assignfile(f,'sys\kb.set');rewrite(f);
  st.C1 := checkbox1.Checked;
  st.C2 := checkbox2.Checked;
  st.C3 := checkbox3.Checked;
  write(f,st);
  closefile(f);
end;

end.

