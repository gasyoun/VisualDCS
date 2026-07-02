unit sfo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, Menus, HtmlView;

type

  { Tsf }

  Tsf = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    hw: THtmlViewer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    MenuItem101: TMenuItem;
    MenuItem102: TMenuItem;
    MenuItem103: TMenuItem;
    MenuItem104: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    PopupMenu2: TPopupMenu;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure MenuItem101Click(Sender: TObject);
    procedure MenuItem102Click(Sender: TObject);
    procedure MenuItem103Click(Sender: TObject);
  private

  public
     procedure findinfo(s : string;b,e : longint; h : boolean; var d1 : string);
  end;

var
  sf: Tsf;
  ginfo : boolean;

implementation
uses poisk, depo1,mmsystem,clipbrd,shellapi;

{$R *.lfm}

{ Tsf }

procedure Tsf.ComboBox1Change(Sender: TObject);
var ds : string;
begin
hw.DefFontName:=form1.Memo1.Font.Name;
hw.DefFontSize:=form1.Memo1.Font.Size;
if combobox1.ItemIndex <> 49 then
begin
  stringgrid2.Cells[0,1] := d[combobox1.ItemIndex + 1].itr;
  stringgrid2.Cells[1,1] := d[combobox1.ItemIndex + 1].deva;
  stringgrid2.Cells[2,1] := d[combobox1.ItemIndex + 1].itr2;
  stringgrid2.Cells[3,1] := d[combobox1.ItemIndex + 1].slp1;

  if combobox1.ItemIndex in [0..13,47..50] then
  findinfo(form1.convertd(combobox1.Text),d[combobox1.ItemIndex+1].beg,d[combobox1.ItemIndex+1].ed,ginfo,ds)
  else
    if combobox1.ItemIndex in [14..46] then
    findinfo(form1.convertd(combobox1.Text),d[combobox1.ItemIndex+1].beg,d[combobox1.ItemIndex+1].ed,ginfo,ds);
  if combobox1.ItemIndex in [0..13] then label8.Caption:=d[combobox1.ItemIndex+1].deva;
  if combobox1.ItemIndex in [14..46] then label8.Caption:=d[combobox1.ItemIndex+1].deva+'a';
  if combobox1.ItemIndex in [47..48] then label8.Caption:='a'+d[combobox1.ItemIndex+1].deva;
  if combobox1.ItemIndex in [49..72] then label8.Caption:='';
  hw.LoadFromString(ds);
  memo1.Text := ds
end
else
  begin
    stringgrid2.cells[0,1] := '';
    stringgrid2.cells[1,1] := '';
    stringgrid2.cells[2,1] := '';
    stringgrid2.cells[3,1] := '';
    memo1.Text:='';
    label8.Caption:='';
  end;
end;

procedure Tsf.Button1Click(Sender: TObject);
var a : byte;
begin
  a := combobox1.ItemIndex + 1;
  if fileexists(sdir +d[a].snd)
  then
  begin
     playsound(pchar(sdir+d[a].snd),0,0);
  end
  else
  showmessage('File: "' + sdir+d[a].snd + '" not found..');

end;

procedure Tsf.ComboBox2Change(Sender: TObject);
var ds : string;
begin
  label3.Caption:='';
  label4.Caption:='';
  if (combobox2.ItemIndex in [0..13]) and
     (combobox3.ItemIndex in [0..13])
     then
     begin
       label4.Caption:='Syllable not found';

     end
  else
  begin

if combobox2.ItemIndex > 46 then combobox2.ItemIndex:=0;
    if (combobox3.ItemIndex in [47,48]) and
       (combobox2.ItemIndex in [14..46])
       then
    label4.Caption:=d[combobox2.ItemIndex + 1].deva + ' + a' +
             d[combobox3.ItemIndex + 1].deva + ' = ' +
             d[combobox2.ItemIndex + 1].deva +'a'+ d[combobox3.ItemIndex + 1].deva
     else
    label4.Caption:=d[combobox2.ItemIndex + 1].deva + ' + ' +
           d[combobox3.ItemIndex + 1].deva + ' = ' +
           d[combobox2.ItemIndex + 1].deva + d[combobox3.ItemIndex + 1].deva;

        if (combobox2.ItemIndex < 14) and (combobox3.ItemIndex > 13)
           and (combobox3.ItemIndex <> 49)
                 then
        label3.Caption:=combobox2.Text+combobox3.Text;

       if (combobox2.ItemIndex < 14) and (combobox3.ItemIndex < 14) then
       begin
          label3.Caption:='';
          label4.Caption:='';
       end;

       if (combobox2.ItemIndex > 13) and (combobox3.ItemIndex < 14) then
       label3.Caption:= combobox2.Text + d[combobox3.ItemIndex +1].Sd;

       if (combobox2.ItemIndex > 13) and (combobox3.ItemIndex > 14) and
          (combobox3.ItemIndex <> 49)  then
          label3.Caption:=combobox2.Text+d[50].lipi+combobox3.Text;
       ds := label3.Caption;
       if combobox3.ItemIndex in [47,48] then
       if pos(d[50].lipi,ds) > 0 then
       begin
          delete(ds,pos(d[50].lipi,ds),length(d[50].lipi));
          label3.Caption := ds;
       end;

    findinfo(form1.convertd(label3.Caption),d[combobox2.ItemIndex + 1].beg,d[combobox2.ItemIndex + 1].ed,true,ds);
    hw.LoadFromString(ds);
    memo1.Text:=ds;

  end;
end;

procedure Tsf.ComboBox3Change(Sender: TObject);
var ds : string;
begin
  label3.Caption:='';
  label4.Caption:='';
if (combobox2.ItemIndex in [0..13]) and
   (combobox3.ItemIndex in [0..13])
   then
   begin
     label4.Caption:='Syllable not found';

   end
else
begin
  if (combobox3.ItemIndex in [47,48]) and
     (combobox2.ItemIndex in [14..46])
     then
  label4.Caption:=d[combobox2.ItemIndex + 1].deva + ' + a' +
           d[combobox3.ItemIndex + 1].deva + ' = ' +
           d[combobox2.ItemIndex + 1].deva +'a'+ d[combobox3.ItemIndex + 1].deva
   else
  label4.Caption:=d[combobox2.ItemIndex + 1].deva + ' + ' +
         d[combobox3.ItemIndex + 1].deva + ' = ' +
         d[combobox2.ItemIndex + 1].deva + d[combobox3.ItemIndex + 1].deva;

       if (combobox2.ItemIndex < 14) and (combobox3.ItemIndex > 13)
                and (combobox3.ItemIndex <> 49)
                then
       label3.Caption:=combobox2.Text+combobox3.Text;


      if (combobox2.ItemIndex < 14) and (combobox3.ItemIndex < 14) then
      begin
         label3.Caption:='';
         label4.Caption:='';
      end;

      if (combobox2.ItemIndex > 13) and (combobox3.ItemIndex < 14) then
      label3.Caption:= combobox2.Text + d[combobox3.ItemIndex +1].Sd;

      if (combobox2.ItemIndex > 13) and (combobox3.ItemIndex > 14) and
         (combobox3.ItemIndex <> 49)  then
         label3.Caption:=combobox2.Text+d[50].lipi+combobox3.Text;

      if (combobox2.ItemIndex > 13) and
               (combobox3.ItemIndex = 49)  then
               label3.Caption:=combobox2.Text+d[50].lipi;

      if (combobox3.ItemIndex > 13) and (combobox3.ItemIndex < 47) then
      label3.Caption:= label3.Caption + d[50].lipi;
      ds := label3.Caption;
      if combobox3.ItemIndex in [47,48] then
      if pos(d[50].lipi,ds) > 0 then
      begin
         delete(ds,pos(d[50].lipi,ds),length(d[50].lipi));
         label3.Caption := ds;
      end;
      findinfo(form1.convertd(label3.Caption),d[combobox2.ItemIndex + 1].beg,d[combobox2.ItemIndex + 1].ed,true,ds);
      hw.LoadFromString(ds);
      memo1.Text:=ds;
end;
end;

procedure Tsf.Memo1Change(Sender: TObject);
begin

end;

procedure Tsf.MenuItem101Click(Sender: TObject);
begin
  hw.CopyToClipboard;
end;

procedure Tsf.MenuItem102Click(Sender: TObject);
begin
  hw.SelectAll;
end;

procedure Tsf.MenuItem103Click(Sender: TObject);
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

procedure tsf.findinfo(s : string; b,e : longint; h : boolean; var d1 : string);
var a : longint;
    i : word;
begin
   d1 := '';
   for a := b to e do
   if (depo.stringgrid1.Cells[0,a] = s) or (depo.stringgrid1.Cells[1,a] = s) then
   begin
      form1.FillDlist(strtoint(depo.StringGrid1.Cells[2,a]));
      if h then
      d1 := form1.printdl1
      else
        begin
         for i := 1 to length(dlist) do
         begin
           if (dlist[i].DDesc <> '') and (dlist[i].en) then
           d1 := d1+'<b>'+dlist[i].DName + '</b><br>' + dlist[i].DDesc + '<br>';
         end;
{         while pos(#13,d1) > 0 do
         begin
          insert('<p>',d1,pos(#13,d1));
          delete(d1,pos(#13,d1),2);
        end;
}
      break;
   end;

   end;


end;



end.

