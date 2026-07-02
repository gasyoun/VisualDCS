unit ent1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  ComCtrls, ExtCtrls, CheckLst;

type

  { TEnt }

  TEnt = class(TForm)
    Button1: TButton;
    CheckListBox1: TCheckListBox;
    GroupBox1: TGroupBox;
    ListBox1: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure EditButton1ButtonClick(Sender: TObject);
    procedure EditButton1Change(Sender: TObject);
  private

  public
     procedure getsyn(a : longint);
     procedure getidx2(a : longint);
  end;

var
  Ent: TEnt;

implementation
uses poisk,depo1,depo2;
{$R *.lfm}

{ TEnt }
var a : word = 0;
procedure TEnt.EditButton1ButtonClick(Sender: TObject);
begin

end;

procedure TEnt.Button1Click(Sender: TObject);
var i : longint;
    s,s2 : string;
begin
   memo1.Clear;
   if listbox1.Count > 0 then
   begin
     for i := 0 to checklistbox1.Count - 1 do
     begin
        s := dp.Memo1.Lines.Strings[strtoint(listbox1.Items[i]) - 1];
        if (s <> '') and (checklistbox1.Checked[i]) then
        begin
          case s[1] of
          '1' : s2 := dlist[10].DName;
          '2' : s2 := dlist[10].DName;
          '3' : s2 := dlist[10].DName;
          end;
          delete(s,1,1);
          while pos('||',s) > 0 do
          begin
           insert(#13+#10,s,pos('||',s));
           delete (s,pos('||',s),2);
          end;
         if pos(',',s) < pos(' ',s) then delete(s,pos(',',s),1);
         memo1.Lines.Add(s2);
         memo1.Lines.Add(s);
     end;

     end;
   end;
   if memo1.Text <> '' then begin memo1.SelStart:=0; memo1.SetFocus; end;
end;

procedure TEnt.EditButton1Change(Sender: TObject);
begin
  EditButton1ButtonClick(Sender);
end;
procedure tent.getsyn(a : longint);
var i : longint;
    s,s2 : string;
    d : longint;
begin
   memo2.Clear;
   memo1.Clear;
   checklistbox1.Clear;
   getidx2(a);
   if listbox1.Count > 0 then
   begin
     for i := 0 to listbox1.Count - 1 do
     begin
        s := dp.Memo1.Lines.Strings[strtoint(listbox1.Items[i]) - 1];
        if s <> '' then
        begin
          case s[1] of
          '1' : s2 := dlist[10].DName;
          '2' : s2 := dlist[10].DName;
          '3' : s2 := dlist[10].DName;
          end;
          delete(s,1,1);
          while pos('||',s) > 0 do
          begin
           insert(#13+#10,s,pos('||',s));
           delete (s,pos('||',s),2);
          end;
         if pos(',',s) < pos(' ',s) then delete(s,pos(',',s),1);
         memo1.Lines.Add(s2);
         memo1.Lines.Add(s);

         checklistbox1.Items.Add(copy(s,1,pos(' ',s) - 1));
         checklistbox1.Checked[i] := true;
     end;

     end;
   end;

   if checklistbox1.items.Count > 0 then
      memo2.Text:= checklistbox1.Items.Text;
    statusbar1.Panels[1].Text:=inttostr(checklistbox1.Count);
    if memo1.Text <> '' then begin memo1.SelStart:=0; memo1.SetFocus; end;
    if memo2.Text <> '' then begin memo2.SelStart:=0; end;

end;
procedure tent.getidx2(a : longint);
var s : string;
    s2 : string;
begin
{   s := depo.ListBox5.Items[a];
   listbox1.Clear;
   while s <> '' do
   begin
      s2 := copy(s,1,pos(' ',s));
      delete(s,1,pos(' ',s));
      while pos(' ',s2) <> 0 do delete(s2,pos(' ',s2),1);
      if s2 <> '' then listbox1.items.Add(s2);
      s2 := '';
   end;
}
end;


end.

