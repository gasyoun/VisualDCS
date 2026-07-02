unit krr;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Grids, StdCtrls, Menus;

type

  { Tkr }

  Tkr = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    ListBox1: TListBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Separator1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure StringGrid1ButtonClick(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  private

  public
    procedure pm(a : dword);
    procedure GeTFx(lx : string; fc,vf,c,n,g : longint);
    procedure GetK;
    function GetVFx(s,s1,s2 : string) : string;
  end;

var
  kr: Tkr;

implementation
uses poisk,tx1,wrf;
{$R *.lfm}
var c : dword = 1;
    GI: dword =1;

{ Tkr }

procedure Tkr.StringGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if form1.StringGrid1.Row > 0 then
    if form1.StringGrid1.Cells[3,form1.StringGrid1.Row] <> '' then
    begin
      Stringgrid1.RowCount:= stringgrid1.RowCount+1;
      StringGrid1.Cells[1,stringgrid1.RowCount-1] := form1.StringGrid1.Cells[1,form1.StringGrid1.Row];
      StringGrid1.Cells[0,stringgrid1.RowCount-1] := form1.StringGrid1.Cells[3,form1.StringGrid1.Row];
      stringgrid1.Row:=stringgrid1.RowCount-1;
      stringgrid1buttonclick(sender,1,stringgrid1.RowCount-1);
      kr.SetFocus;

    end;

end;

procedure Tkr.Button2Click(Sender: TObject);
begin
  close;
end;

procedure Tkr.Button1Click(Sender: TObject);
begin
  progressbar1.Show;
  progressbar2.Show;
  progressbar1.Position:=0;
  progressbar2.Position:=0;
  C := 1;
  getFX('',0,0,0,0,0);
  if stringgrid3.RowCount = 160000 then wr.StringGrid1.RowCount:=1;

  progressbar1.Hide;
  progressbar2.Hide;
end;

procedure Tkr.ListBox1Click(Sender: TObject);
begin
  menuitem1click(sender);
end;

procedure Tkr.MenuItem1Click(Sender: TObject);
var i : word;
begin
  for i := 0 to popupmenu1.Items.Count-1 do
  if (popupmenu1.Items[i] = sender) and (i <> 0) then
  begin
    stringgrid1.Cells[1,stringgrid1.Row] :=
    popupmenu1.Items[i].Caption;
    stringgrid1.Cells[7,stringgrid1.Row] :=
    listbox1.Items[i-1];
    break;
  end
  else stringgrid1.Cells[7,stringgrid1.Row] := '';

end;

procedure Tkr.MenuItem2Click(Sender: TObject);
var i,j : dword;
begin
    j := stringgrid1.Row;
    if j >= 1 then
    for i := 1 to stringgrid1.RowCount - 1 do
    begin
      stringgrid1.Cells[2,i] := stringgrid1.Cells[2,j];
      stringgrid1.Cells[3,i] := stringgrid1.Cells[3,j];
      stringgrid1.Cells[4,i] := stringgrid1.Cells[4,j];
      stringgrid1.Cells[5,i] := stringgrid1.Cells[5,j];
      stringgrid1.Cells[6,i] := stringgrid1.Cells[6,j];
    end;
end;

procedure Tkr.MenuItem4Click(Sender: TObject);
begin
  if stringgrid1.Row > 0 then
  stringgrid1.DeleteRow(stringgrid1.Row);
end;

procedure Tkr.MenuItem5Click(Sender: TObject);
begin
  stringgrid1.Clear;
  stringgrid1.RowCount:=1;
end;

procedure Tkr.StringGrid1ButtonClick(Sender: TObject; aCol, aRow: Integer);
begin
 if acol = 1 then
 begin
   pm(arow);
 end;
end;

procedure Tkr.StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = form1.StringGrid1;
end;
procedure tkr.pm(a : dword);
var s,s1 : string;
    x : Tmenuitem;
begin
    s := stringgrid1.Cells[0,a];
    popupmenu1.items.Clear;
    listbox1.Clear;
    x := tmenuitem.Create(nil);
    x.Caption:='All';
    popupmenu1.Items.Add(x);
    while s <> ''  do
    begin
      x := tmenuitem.Create(nil);
      s1 := copy(s,1,pos(' ',s) - 1);
      listbox1.Items.Add(s1);
      x.Caption:=o[strtoint(s1)].stem + ' '+o[strtoint(s1)].gr+'.';
      x.Name:='s'+s1;
      x.OnClick:=listbox1.OnClick;
      popupmenu1.Items.Add(x);
      delete(s,1,pos(' ',s));
//      x.Free;
    end;
    popupmenu1.PopUp;
end;
procedure tkr.getfX(lx : string; fc,vf,c,n,g : longint);
var i,j : dword;

begin
   stringgrid2.Clear;
   stringgrid2.RowCount:=1;
   vf := 0;fc:= 0;c:= 0;n:= 0;g:= 0;
   stringgrid3.Clear;
   stringgrid3.RowCount:=160000;
   for i :=1 to stringgrid1.RowCount - 1 do
   begin  GI := i;
     progressbar1.Position:=round(i/(stringgrid1.RowCount - 1)*100);
     for j := 0 to length(VFA) -1 do
     if stringgrid1.Cells[2,i] = VFA[j] then vf := j;


     for j := 0 to length(GDA) -1 do
     if stringgrid1.Cells[4,i] = GDA[j] then g := j;

     for j := 0 to length(CSA) -1  do
     if stringgrid1.Cells[6,i] = CSA[j] then c := j;

     for j := 0 to length(NRA) -1 do
     if stringgrid1.Cells[5,i] = NRA[j] then n := j;

     for j := 0 to length(FCA) -1 do
     if stringgrid1.Cells[3,i] = FCA[j] then fc := j;

     if stringgrid1.Cells[7,i] = '' then lx := stringgrid1.Cells[0,i] else lx := stringgrid1.Cells[7,i]+' ';;

     form1.GetExam(lx,0,0,c,n,g);

     GetK;


   end;
   if stringgrid3.RowCount > 1 then
   wr.StringGrid1.RowCount:=stringgrid3.RowCount
   else wr.stringgrid1.RowCount:=1;
   if stringgrid3.RowCount > 1 then
   for j := 1 to stringgrid3.RowCount - 1 do
   begin
     wr.StringGrid1.Rows[j]:= stringgrid3.Rows[j];
   end;
   kr.FormStyle:=fsnormal;;
   wr.Show;
   wr.BringToFront;
end;
procedure tkr.GetK;
var x,i,j : dword;

begin
 if stringgrid2.RowCount = 1 then
  begin
    x :=1;
    stringgrid2.RowCount:=wr.StringGrid1.RowCount;
    if stringgrid2.RowCount > 1 then
    for i := 1 to wr.StringGrid1.RowCount-1 do
    if getvfx(stringgrid1.Cells[2,Gi],wr.StringGrid1.Cells[4,i],wr.StringGrid1.Cells[5,i]) <> '' then
    begin
      stringgrid2.Rows[x] := wr.StringGrid1.Rows[i];
      inc(x);
    end;
    stringgrid2.RowCount:=x;
  end
  else
  if wr.StringGrid1.RowCount > 1 then
  begin

    for i := 1 to stringgrid2.RowCount-1 do
    begin
    progressbar2.Position:=round(i/(stringgrid2.RowCount - 1)*100);
    for j := 1 to wr.StringGrid1.RowCount - 1 do
    if stringgrid2.cells[1,i] = wr.StringGrid1.Cells[1,j] then
    if ((stringgrid2.Cells[5,i] = '0') and
       (stringgrid2.Cells[4,i] = '0')) or
       (getvfx(stringgrid1.Cells[2,Gi],wr.stringgrid1.Cells[4,j],wr.stringgrid1.Cells[5,j]) <> '') then
     begin

        stringgrid3.Rows[c] :=
        wr.StringGrid1.Rows[j];
        inc(c);
     end;

    end;
    stringgrid3.RowCount:=c;
  end;



end;
function Tkr.GetVFx(s,s1,s2 : string) : string;
var q,w,e,r : string;
begin
 q := '';w := '';e := '';r := '';
 if s1 <> '0' then
  begin
    q := dcs1.ListBox6.Items[strtoint(s1)];
    delete(q,1,pos(',',q));
    delete(q,1,pos(',',q));
    delete(q,1,pos(',',q));
    w := copy(q,1,pos(',',q)-1);
    delete(q,1,pos(',',q));
  end;
 if s2 <> '0' then
  begin
    e := dcs1.ListBox7.Items[strtoint(s2)];
    delete(e,1,pos(',',e));
    delete(e,1,pos(',',e));
    delete(e,1,pos(',',e));
    delete(e,1,pos(',',e));
    r := copy(e,1,pos(',',e)-1);
    delete(e,1,pos(',',e));
  end;
  if (s = wr.GetTense(w)) or (s = 'All') or (s = '') or
     (s = wr.GetTense(r)) then
     getVFX := '!' else GetVfx := '';



end;

end.

