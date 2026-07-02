unit parals;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls, ComCtrls;

type

  { Tprl }

  Tprl = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    function  finds(s : string) : string;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure findst(s : string);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid3DblClick(Sender: TObject);
  private

  public

  end;

var
  prl: Tprl;

implementation
uses poisk,tx1,tcf,shellapi;
{$R *.lfm}

{ Tprl }

procedure Tprl.Button1Click(Sender: TObject);
var i : longint;
    s,s2,s3 : string;
    G,P : word;
    F,f1 : text;
begin
  assignfile(f,'pch3.txt');
  assignfile(f1,'pch4.txt');
  rewrite(f);
  rewrite(f1);
  stringgrid2.LoadFromCSVFile('sys\pch1.sdm',#9);


  application.Minimize;
  for i := 0 to stringgrid2.RowCount - 1 do
  begin
    application.Title:=inttostr(i);
    s2 := '';s3 := ''; G := 0; P := 0;
    s := stringgrid2.Cells[1,i];

    s2 := copy(s,1,pos(',',s) - 1);
    delete(s,1,pos(',',s));
    s3 := FindS(s2);
    write(f,i+1,#9,s3);

    while s <> '' do
    begin
      if pos(',',s) = 0 then s := s + ',';
      s2 := copy(s,1,pos(',',s) - 1);
      delete(s,1,pos(',',s));
       if pos('G',s2) > 0 then inc(G) else inc(P);
       s3 := FindS(s2);

       writeln(f1,i+1,#9,s3);





    end;
    writeln(f,#9,G+1,#9,p);
  end;

  closefile(f);
  closefile(f1);
  showmessage('!');
end;

procedure Tprl.Button2Click(Sender: TObject);
begin
  stringgrid1.SaveToCSVFile('sys\!para.txt',#9);
end;

procedure Tprl.Button3Click(Sender: TObject);
var i : word;  F : text;
begin
  if stringgrid1.RowCount > 1 then
  if savedialog1.Execute then
  begin   assignfile(f,savedialog1.filename);rewrite(f);
    stringgrid1click(sender);
    writeln(f,'TextFragment: ',#9,stringgrid1.Cells[1,stringgrid1.Row]);
    writeln(f,'Phrase: ',#9,stringgrid1.Cells[3,stringgrid1.Row]);
    Writeln(f,'PARALLELS:');
    for i := 1 to stringgrid3.RowCount-1 do
    writeln(f,stringgrid3.Cells[1,i],#9,stringgrid3.Cells[3,i]);
    closefile(f);
    if form1.CheckBox7.Checked then
    shellexecute(0,'open',pchar(savedialog1.FileName),'',nil,1);
  end;
end;

procedure Tprl.Button4Click(Sender: TObject);
var i,j : word;  F : text;
begin
  if stringgrid1.RowCount > 1 then
  if savedialog1.Execute then
  begin   assignfile(f,savedialog1.filename);rewrite(f);
    for j := 1 to stringgrid1.RowCount - 1 do
    begin
    stringgrid1click(sender);
    writeln(f,'TextFragment: ',#9,stringgrid1.Cells[1,stringgrid1.Row]);
    writeln(f,'Phrase: ',#9,stringgrid1.Cells[3,stringgrid1.Row]);
    Writeln(f,'PARALLELS:');
    for i := 1 to stringgrid3.RowCount-1 do
    writeln(f,stringgrid3.Cells[1,i],#9,stringgrid3.Cells[3,i]);
    Writeln(f,'');
    end;
    closefile(f);
    if form1.CheckBox7.Checked then
    shellexecute(0,'open',pchar(savedialog1.FileName),'',nil,1);
  end;
end;

procedure Tprl.ComboBox1Change(Sender: TObject);
var i : word; s : string;
begin
  if combobox1.ItemIndex <> 0 then
  begin
    stringgrid1.RowCount:=1;
    for i := 0 to stringgrid4.RowCount - 1 do
    if pos(combobox1.Text,stringgrid4.Cells[1,i]) = 1
    then
    begin
      stringgrid1.RowCount:=stringgrid1.RowCount + 1;
      stringgrid1.Rows[stringgrid1.RowCount-1] := stringgrid4.Rows[i];
    end;
    statusbar1.Panels[3].Text:='1';
  end
  else
  formcreate(sender);
  statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount-1);
end;

function  Tprl.finds(s : string) : string;
var sx,s1,s2,s3,s4,s5,s6,s7 : string;
    i,j,k,l : longint;

begin
  if s <> '' then
  begin
    s1 := copy(s,1,3); while s1[1] = '0' do delete(s1,1,1);
    s2 := copy(s,4,4); while s2[1] = '0' do delete(s2,1,1);
    s3 := copy(s,8,4); while s3[1] = '0' do delete(s3,1,1);
    j := strtoint(s1);

    dcs1.ComboBox1.ItemIndex:=j;
    dcs1.ComboBox1Change(nil);

    for i := 0 to dcs1.combobox2.items.Count - 1 do
    begin
        sx := dcs1.combobox2.Items[i];
        delete(sx,1,pos(':',sx)+1);
       if s2 = sx then
       begin
          dcs1.ComboBox2.ItemIndex:=i;
          dcs1.ComboBox2Change(nil);
          break;
       end;
    end;
    s6 := ','; s7 := '';
    for k := 0 to dcs1.ListBox1.items.Count - 1 do
    begin
        sx := dcs1.ListBox1.Items[k];
        if pos(' ',sx) > 0 then
        sx := copy(sx,1,pos(' ',sx)-1);
        if s3 = sx then
          with dcs1 do
          begin
          dcs1.ListBox1.ItemIndex:=k;
              if length(snt[strtoint(lx1[listbox1.ItemIndex].id)])  > 0 then
              for j  := 0 to length(snt[strtoint(lx1[listbox1.ItemIndex].id)]) - 1 do
              s6 := s6 + snt[strtoint(lx1[listbox1.ItemIndex].id),j].osn + ',';
              listbox1click(nil);
              for l := 0 to memo1.Lines.Count - 1 do
              s7 := s7 + memo1.Lines.Strings[l]+' ';
          break;
        end;
    end;

    s5 := dcs1.ComboBox1.Text + ', ' + dcs1.ComboBox2.Text+','+
    dcs1.listbox1.Items[dcs1.listbox1.ItemIndex];

    if s5 <> '' then
    begin
      if pos('G',s) > 0 then
      FindS := s5+#9+s6+#9+s7+#9+inttostr(j+1)+#9+'G';
      if pos('P',s) > 0 then
         FindS := s5+#9+s6+#9+s7+#9+inttostr(j+1)+#9+'P';
      if (pos('P',s) = 0) and (pos('G',s) = 0) then
      FindS := s5+#9+s6+#9+s7+#9+inttostr(j+1)+#9+'P';
    end
    else
      FindS := '';

  end;

end;

procedure Tprl.FormCreate(Sender: TObject);
var s,s1 : string;
    i,j : word;
    f,f1 : text;
begin
  stringgrid1.SelectedColor:=form1.StringGrid1.SelectedColor;
  stringgrid3.SelectedColor:=form1.StringGrid1.SelectedColor;
  stringgrid1.RowCount:=2072;
  stringgrid2.RowCount:=2687;
    stringgrid1.RowCount:=2072;
    stringgrid2.RowCount:=2687;
    stringgrid2.ColCount:=6;

    assignfile(f,'sys\pch3.txt');
    assignfile(f1,'sys\pch4.txt');

    reset(f);
    i := 1;
    while not(eof(f)) do
    begin
       readln(f,s);
       for j := 0 to 6 do
       begin
          stringgrid1.Cells[j,i] := copy(s,1,pos(#9,s)-1);
          delete(s,1,pos(#9,s));
       end;
       if stringgrid1.Cells[6,i] = '' then stringgrid1.Cells[6,i] := '0';
       if stringgrid1.Cells[7,i] = '' then stringgrid1.Cells[5,i] := '1';
       stringgrid1.Cells[7,i] := s;
       inc(i);
    end;

    reset(f1);;
        i := 0;
        while not(eof(f1)) do
        begin
           readln(f1,s);
           for j := 0 to 4 do
           begin
              stringgrid2.Cells[j,i] := copy(s,1,pos(#9,s)-1);
              delete(s,1,pos(#9,s));
           end;
           stringgrid2.Cells[5,i] := s;
           inc(i);
        end;

    closefile(f);
    closefile(f1);
    stringgrid4.RowCount:=4624;
    stringgrid4.ColCount:=5;
    assignfile(f,'sys\pch5.txt');reset(f);
    reset(f);
    i := 1;
    while not(eof(f)) do
    begin
       readln(f,s);
       for j := 0 to 4 do
       begin
          stringgrid4.Cells[j,i] := copy(s,1,pos(#9,s)-1);
          delete(s,1,pos(#9,s));
       end;
       inc(i);
    end;

    closefile(f);
    combobox1.Clear;
    combobox1.Items.Add('All Parallels');
    for i := 0 to dcs1.ComboBox1.Items.Count - 1 do
    combobox1.Items.Add(dcs1.combobox1.items[i]);
    combobox1.ItemIndex:=0;
    s := '';s1:= '';j := 0;
    for i := 1 to stringgrid1.RowCount-1 do
    begin
      s := stringgrid1.Cells[1,i];delete(s,1,1);s:=copy(s,1,pos('"',s));
      if pos(s,s1) = 0 then begin s1 := s1 + s; inc(j)end;
    end;
    statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount-1);
    statusbar1.Panels[3].Text:=inttostr(j);

end;

procedure Tprl.StringGrid1Click(Sender: TObject);
var i,c : word;  s,s1 : string;
    x : boolean;
begin  x := false; c := 1;  s1 := ''; s := '';
   stringgrid3.Clear;
   stringgrid3.RowCount:=stringgrid4.RowCount;
   for i := 0 to stringgrid4.RowCount - 1 do
   if stringgrid1.Cells[0,stringgrid1.Row] = stringgrid4.Cells[0,i] then
   if stringgrid1.Cells[1,stringgrid1.Row] <> stringgrid4.Cells[1,i] then
   begin
     stringgrid3.Rows[c] := stringgrid4.Rows[i];
     inc(c);
     x := true;
   end;
   stringgrid3.RowCount:=c;
   if c > 0 then
//   stringgrid3.rows[c] := stringgrid1.Rows[stringgrid1.Row];
   statusbar2.Panels[1].Text:=inttostr(stringgrid3.RowCount-1);
   s := ''; c := 0;
   if stringgrid3.RowCount > 1 then
   begin s1 := '';
   for i := 1 to stringgrid3.RowCount- 1 do
   begin
     s := stringgrid3.Cells[1,i];delete(s,1,1); s := '"'+copy(s,1,pos('"',s));
   if pos(s,s1) = 0 then
   begin
     s1:= s1+s; inc(c);
   end;
   end;
end;
   statusbar2.Panels[3].Text:=inttostr(c);

end;
procedure tprl.findst(s : string);
var s1,s2,s3 : string; i,j,k : dword;
begin
   delete(s,1,1);s1:= '"'+copy(s,1,pos('"',s));delete(s,1,pos('"',s));
   while pos(', ',s)=1 do delete(s,1,2);
   s2 := copy(s,1,pos(':',s)); delete(s,1,pos(':',s)+1);
   delete(s,1,pos(',',s));
   s3 := s;
   for i := 0 to dcs1.ComboBox1.Items.Count - 1 do
   if s1=dcs1.ComboBox1.Items[i] then
   begin
      dcs1.ComboBox1.ItemIndex:=i;
      dcs1.combobox1change(nil);
      for j := 0 to dcs1.ComboBox2.Items.Count - 1 do
      if pos(s2,dcs1.ComboBox2.Items[j]) = 1 then
      begin
        dcs1.ComboBox2.ItemIndex:=j;
        dcs1.ComboBox2Change(nil);
        for k := 0 to dcs1.ListBox1.Items.Count - 1 do
        if dcs1.ListBox1.Items[k] = s3 then
        begin
          dcs1.ListBox1.ItemIndex:=k;
          dcs1.ListBox1click(nil);
          break;;
        end;
        break
      end;
      dcs1.Show;
    break;

   end;

end;

procedure Tprl.StringGrid1DblClick(Sender: TObject);
begin
  findst(stringgrid1.Cells[1,stringgrid1.Row]);
end;

procedure Tprl.StringGrid3DblClick(Sender: TObject);
begin
  if stringgrid3.RowCount > 1 then
  findst(stringgrid3.Cells[1,stringgrid3.Row]);
end;

end.

