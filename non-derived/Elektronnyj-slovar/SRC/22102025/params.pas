unit params;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Grids, Buttons;

type

  { TForm8 }

  TForm8 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    ColorButton1: TColorButton;
    ColorButton2: TColorButton;
    ColorButton3: TColorButton;
    ComboBox1: TComboBox;
    FontDialog1: TFontDialog;
    GroupBox1: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox12Change(Sender: TObject);
    procedure CheckBox13Change(Sender: TObject);
    procedure CheckBox14Change(Sender: TObject);
    procedure CheckBox15Change(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure CheckBox7Change(Sender: TObject);
    procedure CheckBox8Change(Sender: TObject);
    procedure CheckBox9Change(Sender: TObject);
    procedure ColorButton1Click(Sender: TObject);
    procedure ColorButton1ColorChanged(Sender: TObject);
    procedure ColorButton2ColorChanged(Sender: TObject);
    procedure ColorButton3Click(Sender: TObject);
    procedure ColorButton3ColorChanged(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private

  public

  end;
  paramfile1 = file of boolean;
  TFF = record
    name : string[64];
    i,b,u: boolean;
    size : byte;
    color : dword;
  end;
type rdrp = record
     path : string[255];
     scrc : dword;
     lid  : word;
     end;
var
  Form8: TForm8;
  rpic : rdrp;
  RdF : file of rdrp;
  FFT : file of TFF;
  xFF : array[1..6] of TFF;
   pF1 : paramfile1;
   GFF : tfont;
implementation
uses poisk,ssv,tx1,dcon,lpak;
{$R *.lfm}

{ TForm8 }

procedure TForm8.StringGrid1Click(Sender: TObject);
var i : byte;
begin
  if stringgrid1.Row > 0 then
  begin
    i  := stringgrid1.Row;
    if stringgrid1.Cells[1,i] = '' then stringgrid1.Cells[1,i] := '1'
    else
    begin
    if stringgrid1.Cells[1,i] = '0' then stringgrid1.Cells[1,i] := '1' else
    stringgrid1.Cells[1,i] := '0';
    end;
  end;
end;

procedure TForm8.StringGrid1DblClick(Sender: TObject);
var i : byte;
begin
  i := stringgrid1.Row;
  if i < length(dlist) - 1 then
  begin
     stringgrid1.cols[0].Exchange(i,i+1);
     stringgrid1.cols[1].Exchange(i,i+1);
     stringgrid1.cols[2].Exchange(i,i+1);
     stringgrid1.cols[3].Exchange(i,i+1);

  end;
end;

procedure TForm8.FormCreate(Sender: TObject);
var i,j : byte;x:boolean;
begin
  assignfile(rdf,'sys\rpic.sdm');
  if fileexists('sys\rpic.sdm') then
  begin
    reset(rdf);
    read(rdf,rpic);
    closefile(rdf);

    if fileexists(rpic.path) then
    rdr.image1.Picture.loadfromfile(rpic.path);
    rdr.Color:=rpic.scrc;
  end;
  if fileexists('sys\dcprior.sdm') then
  stringgrid1.LoadFromCSVFile('sys\dcprior.sdm',#9)
  else
  for i := 1 to length(dlist) - 1 do
  begin
   stringgrid1.Cells[1,i] := '1';
   if i < 10 then
   stringgrid1.Cells[0,i] := '0'+inttostr(i)
   else stringgrid1.Cells[0,i] := inttostr(i);
   stringgrid1.Cells[3,i] := dlist[i].DName;
  end;
  assignfile(pf1,'sys\pfb.sdm');
  assignfile(FFT,'sys\fonts.sdm');
  if fileexists('sys\pfb.sdm') then
  begin
    reset(pf1);
    for i := 1 to 15 do
    begin
       read(pf1,x);
       case i of
       1 : checkbox1.Checked:=x;
       2 : checkbox2.Checked:=x;
       3 : checkbox3.Checked:=x;
       4 : checkbox4.Checked:=x;
       5 : checkbox5.Checked:=x;
       6 : checkbox6.Checked:=x;
       7 : checkbox7.Checked:=x;
       8 : checkbox8.Checked:=x;
       9 : checkbox9.Checked:=x;
       10 : checkbox10.Checked:=x;
       11 : checkbox11.Checked:=x;
       12 : checkbox12.Checked:=x;
       13 : checkbox13.Checked:=x;
       14 : checkbox14.Checked:=x;
       15 : checkbox15.Checked:=x;
       end;
    end;
  end;
  GFF := Tfont.Create;
  if fileexists('sys\fonts.sdm') then
  begin
   reset(fft);
   for i := 1 to length(xff) do
   begin
      read(fft,xff[i]);
      GFF.Name :=xff[i].name;
      gff.Size:=xff[i].size;
      gff.Color:=xff[i].color;
      gff.Underline := xff[i].u;
      gff.Bold := xff[i].b;
      gff.Italic := xff[i].i;
      case i of
      1 : begin
            form1.StringGrid1.Font := gff;
            for j := 0 to form1.StringGrid1.ColCount-1 do
            form1.StringGrid1.Columns[j].Font := gff;
            form1.StringGrid1.DefaultRowHeight:=gff.Size + 16;
          end;
      2 : form1.memo1.Font := gff;
      6 : dcs1.memo1.Font := gff;
      4 : begin rdr.Label4.Font := gff; colorbutton2.ButtonColor:=gff.Color; end;
      5 : begin rdr.label7.Font := gff;  colorbutton1.ButtonColor:=gff.Color; end;
      3 : begin dc.Memo1.Font := gff; dc.Memo2.Font := gff; end;

      end;
   end;
    closefile(FFT);
  end;
  combobox1.Clear;
  for i := 3 to lp.StringGrid1.ColCount-1 do
  if lp.StringGrid1.Columns[i].Title.Caption <> '' then
  combobox1.items.Add(lp.StringGrid1.Columns[i].Title.Caption);
  if combobox1.Items.Count > 0 then
  if rpic.lid in [0,combobox1.Items.Count -1] then
  begin

     combobox1.ItemIndex:=rpic.lid;
     combobox1change(sender);
    end;

  button3click(sender);

  end;

procedure TForm8.FormDeactivate(Sender: TObject);
begin
  if form8.Visible then form8.SetFocus;
end;


procedure TForm8.SpeedButton1Click(Sender: TObject);
begin
  rpic.path:='';
  rdr.Image1.Picture.Clear;
  Showmessage('Background picture deleted');
end;

procedure TForm8.SpeedButton2Click(Sender: TObject);
begin
  lp.show;
end;

procedure TForm8.Button3Click(Sender: TObject);
var i,j : byte;
begin
    rewrite(rdf);
    write(rdf,rpic);
    closefile(rdf);
    for i := 1 to length(dar) do
    begin
       j := strtoint(stringgrid1.Cells[1,i]);
       dar[i] := strtoint(stringgrid1.Cells[0,i]);
       case j of
        1 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox8.Checked:=true else
          form1.CheckBox8.Checked:= false;
        2 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox13.Checked:=true else
          form1.CheckBox13.Checked:= false;
        3 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox18.Checked:=true else
          form1.CheckBox18.Checked:= false;
        4 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox25.Checked:=true else
          form1.CheckBox25.Checked:= false;
        5 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox9.Checked:=true else
          form1.CheckBox9.Checked:= false;
        6 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox10.Checked:=true else
          form1.CheckBox10.Checked:= false;
        7 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox11.Checked:=true else
          form1.CheckBox11.Checked:= false;
        8 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox17.Checked:=true else
          form1.CheckBox17.Checked:= false;
        9 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox26.Checked:=true else
          form1.CheckBox26.Checked:= false;
       10 : if stringgrid1.Cells[1,j] = '1' then
            form1.CheckBox23.Checked:=true else
            form1.CheckBox23.Checked:= false;
       11 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox22.Checked:=true else
          form1.CheckBox22.Checked:= false;
      12 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox16.Checked:=true else
          form1.CheckBox16.Checked:= false;
      13 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox12.Checked:=true else
          form1.CheckBox12.Checked:= false;
      14 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox15.Checked:=true else
          form1.CheckBox15.Checked:= false;
      15 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox20.Checked:=true else
          form1.CheckBox20.Checked:= false;
      16 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox19.Checked:=true else
          form1.CheckBox19.Checked:= false;
      17 : if stringgrid1.Cells[1,j] = '1' then
          form1.CheckBox28.Checked:=true else
          form1.CheckBox28.Checked:= false;

       end;
    end;
    stringgrid1.SaveToCSVFile('sys\dcprior.sdm',#9);
    rewrite(pf1);
    for i := 1 to 15 do
    case i of
         1  : write(pf1,checkbox1.checked);
         2  : write(pf1,checkbox2.checked);
         3  : write(pf1,checkbox3.checked);
         4  : write(pf1,checkbox4.checked);
         5  : write(pf1,checkbox5.checked);
         6  : write(pf1,checkbox6.checked);
         7  : write(pf1,checkbox7.checked);
         8  : write(pf1,checkbox8.checked);
         9  : write(pf1,checkbox9.checked);
         10  : write(pf1,checkbox10.checked);
         11  : write(pf1,checkbox11.checked);
         12  : write(pf1,checkbox12.checked);
         13  : write(pf1,checkbox13.checked);
         14  : write(pf1,checkbox14.checked);
         15  : write(pf1,checkbox15.checked);

    end;
      closefile(pf1);
      rewrite(FFT);
      for i := 1 to length(xff) do
      begin
         case i of
              1 : gff := form1.StringGrid1.Font;
              2 : gff := form1.Memo1.Font;
              3 : gff := dc.Memo1.Font;
              4 : begin gff := rdr.label4.Font; colorbutton2.ButtonColor:=gff.Color;end;
              5 : begin gff := rdr.label7.Font; colorbutton1.ButtonColor:=gff.Color;end;
              6 : gff := dcs1.memo1.Font;
         end;
         xff[i].b:=gff.Bold;
         xff[i].i := gff.Italic;
         xff[i].u := gff.Underline;
         xff[i].color:=gff.Color;
         xff[i].Size := gff.Size;
         xff[i].name:= gff.Name;
         write(FFt,xff[i]);
      end;
      closefile(fft);
    close;
end;

procedure TForm8.Button4Click(Sender: TObject);
var i : word;
begin
  for i := 1 to length(txpos) do
  begin
   txpos[i].cp:=0;
   txpos[i].ln:=0;
   txpos[i].stm:=false;
   txpos[i].vrs:=0;
  end;
end;

procedure TForm8.Button5Click(Sender: TObject);
begin

end;

procedure TForm8.Button6Click(Sender: TObject);
begin
  if application.messagebox('The settings will be reset. to apply the changes, run the program again.','Set default settings',52) = 6 then
  begin
    if fileexists('sys\dcprior.sdm') then deletefile('sys\dcprior.sdm');
    if fileexists('sys\fonts.sdm') then deletefile('sys\fonts.sdm');
    if fileexists('sys\pfb.sdm') then deletefile('sys\pfb.sdm');
    button4click(sender);
    button7click(sender);
    if fileexists('sys\rpic.sdm') then deletefile('sys\rpic.sdm');
    dcs1.close;
    halt(0);

  end;
end;

procedure TForm8.Button7Click(Sender: TObject);
begin
  dcs1.SpeedButton11Click(sender);
end;

procedure TForm8.Button10Click(Sender: TObject);
begin
  fontdialog1.Font := dc.Memo1.Font;
  if fontdialog1.Execute then dc.Memo1.Font := fontdialog1.Font;
end;

procedure TForm8.Button11Click(Sender: TObject);
begin
   fontdialog1.Font := dc.Memo2.Font;
   if fontdialog1.Execute then dc.Memo2.Font := fontdialog1.Font;
end;

procedure TForm8.Button12Click(Sender: TObject);
begin
  fontdialog1.font := dcs1.Memo1.Font;
  if fontdialog1.Execute then
  dcs1.Memo1.Font := fontdialog1.Font;
end;

procedure TForm8.Button1Click(Sender: TObject);
var i : byte;
begin
  fontdialog1.Font:= form1.StringGrid1.Font;
  if fontdialog1.Execute then
  begin
     form1.StringGrid1.Font := fontdialog1.Font;
     form1.StringGrid1.DefaultRowHeight:= fontdialog1.font.Size + 12;
     for i := 0 to form1.StringGrid1.ColCount- 1 do
     form1.StringGrid1.Columns[i].Font := form1.stringgrid1.Font;
  end;
end;

procedure TForm8.Button2Click(Sender: TObject);
begin
  fontdialog1.font := form1.MEMO1.font;
  if fontdialog1.Execute then
  form1.Memo1.Font := fontdialog1.Font;
end;

procedure TForm8.Button8Click(Sender: TObject);
begin
  if fontdialog1.Execute then
  begin
    rdr.Label7.Font:=fontdialog1.Font;
    rdr.Label4.Font:=fontdialog1.Font;
    rdr.label7.Font.Color:=colorbutton1.ButtonColor;
    rdr.label4.Font.Color:=colorbutton2.ButtonColor;
//    rdr.Label7.Caption:='777777777777';
    rdr.label5.Hide
    ;
  end;
end;

procedure TForm8.Button9Click(Sender: TObject);
begin
  if fileexists(rpic.path) then
  rdr.OpenPictureDialog1.FileName:=rpic.path;
  if rdr.OpenPictureDialog1.Execute then
  begin
    rdr.Image1.Picture.LoadFromfile(rdr.openpicturedialog1.Filename);
    rpic.path:=rdr.openpicturedialog1.FileName;;
  end;
end;

procedure TForm8.CheckBox12Change(Sender: TObject);
begin
  dc.checkbox1.Checked := checkbox12.Checked;
end;

procedure TForm8.CheckBox13Change(Sender: TObject);
begin
  dc.memo1.WordWrap:=checkbox13.Checked;
  dc.Memo2.WordWrap:=checkbox13.Checked;
end;

procedure TForm8.CheckBox14Change(Sender: TObject);
begin
  dc.CheckBox4.Checked:=checkbox14.Checked;
end;

procedure TForm8.CheckBox15Change(Sender: TObject);
begin
  dc.CheckBox3.Checked:=checkbox15.Checked;
end;

procedure TForm8.CheckBox1Change(Sender: TObject);
begin
  form1.ShowHint:=checkbox1.Checked;
end;

procedure TForm8.CheckBox3Change(Sender: TObject);
begin
  form1.checkbox7.checked := checkbox3.Checked;
end;

procedure TForm8.CheckBox5Change(Sender: TObject);
begin
  dcs1.CheckBox2.Checked:= checkbox5.Checked;
end;

procedure TForm8.CheckBox6Change(Sender: TObject);
begin
  dcs1.CheckBox3.Checked:=checkbox6.Checked;
end;

procedure TForm8.CheckBox7Change(Sender: TObject);
begin
  dcs1.CheckBox1.Checked:=checkbox7.Checked;
end;

procedure TForm8.CheckBox8Change(Sender: TObject);
begin
  if checkbox8.Checked then dcs1.RadioGroup1.ItemIndex:=1 else
                            dcs1.RadioGroup1.ItemIndex:=0;
end;

procedure TForm8.CheckBox9Change(Sender: TObject);
begin
  rdr.CHECKBOX2.checked := checkbox9.Checked;
end;

procedure TForm8.ColorButton1Click(Sender: TObject);
begin

end;

procedure TForm8.ColorButton1ColorChanged(Sender: TObject);
begin
  rdr.Label7.Font.Color:= ColorButton1.ButtonColor;
end;

procedure TForm8.ColorButton2ColorChanged(Sender: TObject);
begin
   rdr.Label5.Font.Color:= ColorButton2.ButtonColor;
end;

procedure TForm8.ColorButton3Click(Sender: TObject);
begin

end;

procedure TForm8.ColorButton3ColorChanged(Sender: TObject);
begin
   rdr.Color:= ColorButton3.ButtonColor;
   rpic.path:='';
   rdr.Image1.Picture.Clear;
   rpic.scrc:=ColorButton3.ButtonColor;

end;

procedure TForm8.ComboBox1Change(Sender: TObject);
begin

    x229 := combobox1.ItemIndex + 3;
    lp.Button2Click(sender);
    rpic.lid:=combobox1.ItemIndex;
    if form8.Visible then
    begin
       form1.shape1.Left:=form1.speedbutton57.left;
       form1.shape1.width:=form1.speedbutton57.width;
    end
    else
    begin
//     form1.shape1.Left:=form1.speedbutton48.left;
//     form1.shape1.width:=form1.speedbutton48.width;
    end;
    form1.ComboBox2Change(sender);

end;

end.

