unit omf;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls, Menus,
  ComCtrls;

type

  { Tof1 }

  Tof1 = class(TForm)
    Label4: TLabel;
    ListBox1: TListBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure getC(s : string;var c,n,g : byte);
    procedure Label4Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
  private

  public

  end;

var
  of1: Tof1;

implementation
uses poisk,wrf,vd1,shellapi;
{$R *.lfm}

{ Tof1 }

procedure Tof1.FormCreate(Sender: TObject);
begin
  stringgrid1.LoadFromCSVFile('sys\xlsdata\omoforms\nv.csv',#9);
  while stringgrid1.ColCount > 4 do stringgrid1.DeleteCol(4);
  statusbar1.Panels[1].Text:=inttostr(stringgrid1.RowCount - 1);
end;

procedure Tof1.Button1Click(Sender: TObject);
var f:text;
    i,j,cnt,cnt2,k : word;
    s,s1,s2 : string;
    c,n,g : string;
    cc,nn,gg : byte;
    lS : string;
    cd : real;
const
  cS : string = '/N./A./V./I./D./Ab./G./L./';
  nS : string = '/sg./du./pl./';
  gS : string = '/m./n./f./dei./x./';
begin
  wr.Show;
  verdir.Show;
  verdir.ComboBox8.ItemIndex:=2;

    cnt := 0; cnt2 := 0;
    assignfile(f,'input\omfc.txt');
    rewrite(f);
    for i := 1 to stringgrid1.RowCount - 1 do
    begin
      listbox1.Clear;
      cnt := 0;
      s := stringgrid1.Cells[1,i];
      if pos('от',s) = 0 then
      begin
         s := s + ' от ' + stringgrid1.Cells[0,i];
         stringgrid1.Cells[1,i] := s;

      end;
      if s[length(s)] in ['1'..'9'] then
      delete(s,length(s),1);

      if pos('ḥ ',s+' ') > 0 then
      delete(s,pos('ḥ ',s+' '),length('ḥ '));

      s1 := copy(s,1,pos('от',s)-1);
      delete(s,1,pos('от',s));
      delete(s,1,pos(' ',s));
      form1.edit2.text := s;
      if form1.StringGrid1.RowCount > 1 then
      if form1.stringGrid1.cells[3,1] <> '' then
      while s1 <> '' do
      begin

       while pos(' ',s1) > 0 do
       begin
        ls := '';
        c := copy(s1,1,pos(' ',s1) - 1);
        if pos(c,cS) > 0 then
        begin  listbox1.Items.Add(c);
               delete(s1,1,pos(' ',s1));
        end;
        n    := copy(s1,1,pos(' ',s1) - 1);
        if pos(n,ns) > 0 then
        begin
          for k := 0 to listbox1.Count - 1 do
          listbox1.Items[k] := listbox1.Items[k] +n ;
              delete(s1,1,pos(' ',s1));

        end;
        g :=    copy(s1,1,pos(' ',s1) - 1);
        if pos(g,Gs) > 0 then
        begin
          for k := 0 to listbox1.Count - 1 do
          listbox1.Items[k] := listbox1.Items[k] +g ;
          s1 := '';
          delete(s1,1,pos(' ',s1));
        end;

       end;
       s := (form1.stringGrid1.cells[3,1]);

//        while s <> '' do
        begin
          for j := 0 to listbox1.Count - 1 do
          if listbox1.Items[j] <> '' then;
          begin
           getC(listbox1.Items[j],cc,nn,gg);
           if cc <> 255 then
           begin
              form1.GetExam(s,0,0,cc,nn,gg);
              inc(cnt,wr.StringGrid1.RowCount -1);

           end;
          end;

       end;

      end;

      verdir.Edit1.Text:=form1.Edit2.Text;//stringgrid1.Cells[0,i];
//      verdir.SpeedButton1click(sender);
//      showmessage(verdir.Edit1.Text);
      if verdir.StringGrid2.RowCount > 1 then
      cnt2 := strtoint(verdir.StringGrid2.Cells[8,1])
      else cnt2 := 0;
      cd := cnt + cnt2;
      if cd <> 0 then cd := cnt/cd*100;

      writeln(f,stringgrid1.Cells[0,i],#9,cnt,#9,cnt2,#9,cnt+cnt2,#9,cd:3:2,#9,
      stringgrid1.Cells[1,i],#9,stringgrid1.Cells[2,i]);
    end;
    closefile(f);


end;
procedure tof1.getC(s : string;var c,n,g : byte);
var i,j : word;
    s1 : string;
begin
   if s <> '' then
   begin
   c := 0;n := 0; g := 0;
   s1 := copy(s,1,pos('.',s)-1);
   delete(s,1,pos('.',s));
   case s1 of
   'N' : c := 1;
   'A' : c := 3;
   'V' : c := 2;
   'I' : c := 4;
   'D' : c := 5;
   'Ab': c := 6;
   'G' : c := 7;
   'L' : c := 8;
end;

   s1 := copy(s,1,pos('.',s)-1);
   delete(s,1,pos('.',s));
   case s1 of
   'sg' : n := 1;
   'du' : n := 2;
   'pl' : n := 3;
   else
    n := 0;
   end;
   s1 := copy(s,1,pos('.',s)-1);
   delete(s,1,pos('.',s));

   case s1 of
   'm' : g := 1;
   'f' : g := 2;
   'n' : g := 3;
   end;
   end
   else
   begin
    c := 255;n := 255;g:=255;
   end;

end;

procedure Tof1.Label4Click(Sender: TObject);
begin
  shellexecute(0,'Open','https://sanskrit.inria.fr/DICO/grammar.html','',nil,1);
end;

procedure Tof1.MenuItem1Click(Sender: TObject);
begin
  if savedialog1.Execute then
  begin
     stringgrid1.SaveToCSVFile(savedialog1.FileName,#9);
     if form1.CheckBox7.Checked then
       shellexecute(0,'open',pchar(savedialog1.FileName),'',nil,1);
  end;
end;

procedure Tof1.MenuItem2Click(Sender: TObject);
begin
    shellexecute(0,'open',pchar('sys\xlsdata\omoforms\omoforms.xls'),'',nil,1)
end;

end.

