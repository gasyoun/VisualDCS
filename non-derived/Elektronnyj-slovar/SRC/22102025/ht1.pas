unit ht1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls;

type

  { Tht }

  Tht = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    UpDown1: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    procedure startpage;
    function  make1(b,e,c : longint) : string;
    function getfulinfo(i : longint) : string;
  public

  end;

var
  ht: Tht;

implementation
uses poisk, depo1,shellapi;
{$R *.lfm}

{ Tht }

procedure Tht.Button1Click(Sender: TObject);
begin
  if selectdirectorydialog1.execute then edit3.Text:=
     selectdirectorydialog1.filename;
end;

procedure Tht.Button2Click(Sender: TObject);
var zz : string;
    n1 : string;
    s1 : string;
    s2 : string;
    s  : string;
    i,j: longint;
begin
  startpage;
end;

procedure Tht.FormCreate(Sender: TObject);
begin
 edit3.Text:= pchar(getcurrentdir+'\html\');
end;

procedure Tht.Panel1Click(Sender: TObject);
begin

end;
function tht.make1(b,e,c : longint) : string;
var i,j,k : longint;
    zz : string;
    s,s1,s2 : string;
begin
zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
      '<font face="Mangal" size = "4"><font size = "5">' +
      '<center><b>'+ depo.stringgrid1.Cells[1,b] +
      '</b></font></center><left>';
  zz := zz + '<center><b><font size = "4"><b>'+
             'CONTENS</center></font></b><left><hr>';
  i := b;

  s := '<table width = "100%" rules = "all"><td width = "100%">';
  zz := zz + s;
  j := b;
  while j <= e do
  begin
    if j + c <= e then
    begin
    s1 := '<A name = "'+depo.stringgrid1.Cells[0,j] +' - ' + depo.stringgrid1.Cells[1,j + c] + '"></A>' +
          '<A href = "#1'+depo.stringgrid1.Cells[0,j] +' - ' + depo.stringgrid1.Cells[0,j + c] + '">' + depo.stringgrid1.Cells[0,j] +' - ' + depo.stringgrid1.Cells[0,j + c] +'   </A>';
    zz := zz +  s1;
  end
    else
    begin
     s1 := '<A name = "'+depo.stringgrid1.Cells[0,j] +' - ' + depo.stringgrid1.cells[0,e] + '"></A>' +
          '<A href = "#1'+depo.stringgrid1.cells[0,j] +' - ' + depo.stringgrid1.cells[0,e] + '">' + depo.stringgrid1.cells[0,j] + ' - ' + depo.stringgrid1.cells[0,e] +'   </A>';
    zz := zz +  s1;
    end;
    j := j + c;
  end;
  zz := zz + '</td><tr></table><p><hr>';
  while i <= e do
  begin
    if i + c <= e then
    begin
    zz := zz + '<A name = "1' + depo.stringgrid1.cells[0,i]+' - '+depo.stringgrid1.cells[0,i +c]+'"></A>'+
               '<A href = "#'+  depo.stringgrid1.cells[0,i]+' - '+depo.stringgrid1.cells[0,i +c]+'">' +
               '<center><b><font size = "4"></font></b>'+
               depo.stringgrid1.cells[0,i]+' - '+depo.stringgrid1.cells[0,i +c]+' </A>';

    end
    else
    begin
      zz := zz + '<A name = "1' + depo.stringgrid1.cells[0,i]+' - '+depo.stringgrid1.cells[0,e]+'"></A>'+
      '<A href = "#'+  depo.stringgrid1.cells[0,i]+' - '+depo.stringgrid1.cells[0,e]+'">' +
      '<center><b><font size = "4"></font></b>'+
      depo.stringgrid1.cells[0,i]+' - '+depo.stringgrid1.cells[0,e]+' </A>'

    end;
    zz := zz + '<p><hr><table width = "100%" rules = "all"><td width = "100%">';
    for j := i to i + c do
    if j <= e then
    begin
      zz := zz + '<A name = "1' + depo.stringgrid1.cells[0,j] + '"></A>' +
{}                 '<A href ="#'+depo.stringgrid1.cells[0,j]+'">'+  depo.stringgrid1.cells[0,j] + '  </A>';
    end;
    zz := zz + '</td><tr></table><p><hr>';

    zz := zz + '<table width = "100%" rules = "all">';
    for i := i to i + c do
    if i <= e then
    begin
      s := '<td width = "20%" valign = "top"><A name = "' + depo.stringgrid1.cells[0,i] + '"></A>' +
{}           '<A href = "#1'+depo.stringgrid1.cells[0,i]+'">' + depo.stringgrid1.cells[0,i]+'</A></td>';
      s1 :=getfulinfo(i); //form1.Memo1.Text;
      zz := zz + s + '<td width = "80%" valign ="top">'+s1 +'</td><tr>';
    end;
    zz := zz + '</table><hr>';
  end;
//  memo1.Text:=zz;
//  memo1.Lines.SaveToFile('e:\d1\v2.0\reports\!!.htm');
make1 := zz;
end;

procedure THt.startpage;
var zz : string;
    s1,s2,s3,s : string;
    a,i,j : longint;
begin
 zz := '<html><HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=utf8"></HEAD><body>'+
       '<font face="Mangal" size = "4">' +
       '<center><b>'+
       'Electronic Sanskrit-English and Sanskrit German Dictionary<p></center><left>'+
       '<font size = "3">';
      for a := 0 to memo2.Lines.Count - 1 do
      zz := zz + '<p>'+memo2.Lines.Strings[a];

       zz := zz +
       '</b></center><left>';
   zz := zz + '<center><b><font size = "3">CONTENS</center></font></b><left><hr>' +
              '<table width = "100%">';

   for i := 1 to 10 do
   begin
     s1 :=  '<a name = "1'+inttostr(i) + '"></A>' +
     '<a href = "'+edit1.text+inttostr(i) + '.htm" target = "blank">' + d[i].lipi + '   </A>   ';
     s2 :=   '<td width = "10%" valign = "center"><font size = "5">'+s1+'</td>';
     zz := zz + s2;
   end;
   zz := zz + '<TR>';
   for i := 11 to 14 do
   begin
     s1 :=  '<a name = "1'+inttostr(i) + '"></A>' +
     '<a href = "'+edit1.text+inttostr(i) + '.htm" target = "blank">' + d[i].lipi + '   </A>   ';
     s2 :=   '<td width = "10%" valign = "center"><font size = "5">'+s1+'</td>';
     zz := zz + s2;
   end;
   zz := zz + '<TR>';
   zz := zz + '</table><P><hr>';

zz := zz + '<table width = "100%"><font size = 5>';
for i := 15 to 19 do
begin
  s1 :=  '<a name = "1'+inttostr(i) + '"></A>' +
  '<a href = "'+edit1.text+inttostr(i) + '.htm" target = "blank">' + d[i].lipi + '   </A>   ';
  s2 :=   '<td width = "20%" valign = "center"><font size = "5">'+s1+'</td>';
  zz := zz + s2;
end;
zz := zz + '<TR>';

for i := 20 to 24 do
begin
  s1 :=  '<a name = "1'+inttostr(i) + '"></A>' +
  '<a href = "'+edit1.text+inttostr(i) + '.htm" target = "blank">' + d[i].lipi + '   </A>   ';
  s2 :=   '<td width = "20%" valign = "center"><font size = "5">'+s1+'</td>';
  zz := zz + s2;
end;
zz := zz + '<TR>';

for i := 25 to 29 do
begin
  s1 :=  '<a name = "1'+inttostr(i) + '"></A>' +
  '<a href = "'+edit1.text+inttostr(i) + '.htm" target = "blank">' + d[i].lipi + '   </A>   ';
  s2 :=   '<td width = "20%" valign = "center"><font size = "5">'+s1+'</td>';
  zz := zz + s2;
end;
zz := zz + '<TR>';

for i := 30 to 34 do
begin
  s1 :=  '<a name = "1'+inttostr(i) + '"></A>' +
  '<a href = "'+edit1.text+inttostr(i) + '.htm" target = "blank">' + d[i].lipi + '   </A>   ';
  s2 :=   '<td width = "20%" valign = "center"><font size = "5">'+s1+'</td>';
  zz := zz + s2;
end;
zz := zz + '<TR>';

for i := 35 to 39 do
begin
  s1 :=  '<a name = "1'+inttostr(i) + '"></A>' +
  '<a href = "'+edit1.text+inttostr(i) + '.htm" target = "blank">' + d[i].lipi + '   </A>   ';
  s2 :=   '<td width = "20%" valign = "center"><font size = "5">'+s1+'</td>';
  zz := zz + s2;
end;
zz := zz + '<TR>';

zz := zz + '</table><P><p><hr><table width = "100%">';
for i := 40 to 43 do
begin
  s1 :=  '<a name = "1'+inttostr(i) + '"></A>' +
  '<a href = "'+edit1.text+inttostr(i) + '.htm" target = "blank">' + d[i].lipi + '   </A>   ';
  s2 :=   '<td width = "25%" valign = "center"><font size = "5">'+s1+'</td>';
  zz := zz + s2;
end;
zz := zz + '<TR></table><p><hr><table width = "100%">';

for i := 44 to 47 do
begin
  s1 :=  '<a name = "1'+inttostr(i) + '"></A>' +
  '<a href = "'+edit1.text+inttostr(i) + '.htm" target = "blank">' + d[i].lipi + '   </A>   ';
  s2 :=   '<td width = "25%" valign = "center">'+s1+'</td>';
  zz := zz + s2;
end;

zz := zz + '<TR>';
zz := zz + '</table></bodt></html>';

   memo1.Text := zz;
   memo1.lines.SaveToFile(edit3.Text + '!index.htm');
   form1.progressbar1.show;
   form1.ProgressBar1.Min:=1;
   form1.ProgressBar1.Max:=47;



for i := 1 to 47 do
begin
   form1.ProgressBar1.Position:=i;
   s := make1(d[i].beg,d[i].ed,strtoint(edit2.Text));
   s1 := inttostr(i);
   memo1.Text:=s;
   memo1.Lines.SaveToFile(edit3.Text+s1+'.htm');
//   if fileexists(edit3.Text+s1+'.htm') then showmessage('');
end;
   form1.ProgressBar1.Hide;
   Showmessage('Your HTML dictionary Exported to'+#13+#10+Edit3.Text + #13+#10+'Open !index.htm');
  if form1.CheckBox7.Checked then
  shellexecute(0,'Explore',pchar(edit3.Text),'',nil,1);

 end;
function tht.getfulinfo(i : longint) : string;
var s,s1,s2,s3 : string;
    a,j : longint;
    mw,ap,bt,sm,sa,sb : string;
    d : longint;
begin
sm := '';
sa := '';
sb := '';

    s3 := '';
//    s1 := depo.ListBox3.Items[i];
    while s1 <> '' do
    begin
      s2 := copy(s1,1,pos(' ',s1) - 1);
      delete(s1,1,pos(' ',s1));
      if s2 <> '' then
      a := strtoint(s2)
      else a := 0;
if a > 0 then
      s := depo.Memo1.Lines.Strings[a - 1];
      s := form1.convertres(s);
      memo1.Lines.Text:=s;
      s := '';
      for d := 0 to memo1.Lines.Count - 1 do
      s := s + memo1.Lines.Strings[d]+'<p>';
      if s <> '' then
      case s[1] of
      '#' : sm := '<p>'+sm + '<p>' + s;
      '$' : sa := '<p>'+sa + '<p>' + s;
      '^' : sb := '<p>'+sb + '<p>' + s;
      end;

      delete(sm,pos('#',sm),1);
      delete(sa,pos('$',sa),1);
      delete(sb,pos('^',sb),1);
      if (pos(' ',s1) = 0) and (s1 <> '') then s1 := '';
    end;
  if sm <> '' then sm := mw + sm;
  if sa <> '' then sa := ap + sa;
  if sb <> '' then sb := bt + sb;
  s3 := s3 + sm + '<p>'+ sa + '<p>'+ sb + '<p>';




    getfulinfo := s;
end;

{ zz := zz +  '<table width = "100%" rules = "ALL" border = "2">';
 memo4.Clear;
 if checklistbox2.Items.Count > 0 then
 for   i := 0 to checklistbox2.Count - 1 do
 if checklistbox2.Checked[i] then
 begin
   s := '';
   if menuitem19.Checked then
   begin
      s1 := '<TD Width = "20%" valign="top">' +
      '<A name="'+checklistbox2.Items[i] + '"></A>'+
      '<A href="#1'+checklistbox2.Items[i] + '">'+form1.convertd(checklistbox2.Items[i])  + ' - ' + checklistbox2.Items[i]+'</A></TD>';
   end
   else
   s1 := '<TD Width = "20%" valign="top">' + form1.convertd(checklistbox2.Items[i])  + ' - ' + checklistbox2.Items[i]+'</TD>';
   progressbar1.Position:=i;
   checklistbox2.ItemIndex:=i;
   checklistbox2click(sender);
   for a := 0 to checklistbox1.Items.Count - 1 do
   if checklistbox1.Checked[a] then
   begin
    checklistbox1.ItemIndex:=a;
    checklistbox1click(sender);
    if memo3.Text <> '' then
    begin
       s  := s + checklistbox1.Items[a] + '<p>';
       for q := 0 to memo3.Lines.Count - 1 do
       s := s +  memo3.Lines.Strings[q] + #13+#10;
       s := s + '<p>';
    end;
   end;
   s := s1 + '<TD width = "80%">' + s + '</TD><TR>';
   memo4.Lines.Add(S);

 end;
    memo4.Text:=zz + memo4.Text + '</Table></body></html>';

    memo4.Lines.SaveToFile(savedialog1.FileName);
    if form1.CheckBox7.Checked then
    shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
    progressbar1.Hide;
end;
}
end.

