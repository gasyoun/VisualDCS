unit rusk;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids;

type

  { Trk }

  Trk = class(TForm)
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    StringGrid6: TStringGrid;
    StringGrid7: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private

  public
     function AdptN(TxN : word; N : string) : longint;
     Function GetStr(txn : word; st : longint; iast : boolean) : string;
     Function Alit(s : string) : string;
     function GetRim(s : string) : string;
     function Adaptm(z,s : string; x : longint; d,g : string) : boolean;
     Function GetBtl(sn : string; sn1 : longint) : string;
  end;

var
  rk: Trk;
  RKK : boolean = true;
implementation
var sq : string;
{$R *.lfm}

{ Trk }

procedure Trk.FormCreate(Sender: TObject);
var f : system.text;
    s,s1,s2 : string;
    i,j : word;
begin
  stringgrid5.LoadFromCSVFile('sys\rus\RAD.txt','#');
  Stringgrid6.LoadFromCSVFile('sys\rus\brn.csv',#9);
  Stringgrid7.LoadFromCSVFile('sys\rus\bra.csv',#9);

  stringgrid1.LoadFromCSVFile('sys\rus\AV.txt','#');

  stringgrid2.LoadFromCSVFile('sys\rus\RV.txt','#');

  stringgrid3.LoadFromCSVFile('sys\rus\M.txt','#');


//  stringgrid4.LoadFromCSVFile('sys\rus\RM.csv','#');
stringgrid4.RowCount := 11859;
stringgrid4.ColCount := 3;
  system.assign(f,'sys\rus\RM.csv');
  reset(f);
  i := 0;
  while not(eof(f)) do
  begin
    Readln(f,s);
    if s <> '' then
    begin
      s1 := copy(s,1,pos('#',s) - 1);
      delete(s,1,pos('#',s));
      Stringgrid4.cells[0,i] := s1;
      s1 := copy(s,1,pos('#',s) - 1);
      delete(s,1,pos('#',s));
      Stringgrid4.cells[1,i] := s1;
      Stringgrid4.cells[2,i] := s;
      inc(i);



    end;
  end;
end;
function trk.AdptN(TxN : word; N : string) : longint;
var k,g,s : string;
    z : string;
    x : longint;
    f : string;
begin
  f := n;
   k := ''; g:='';s:= '';
   Delete(n,1,pos(', ',n)+1);
   k := copy(n,1,pos(',',n)-1);
   delete(n,1,pos(',',n)+1);
   g := copy(n,1,pos('.',n) - 1);
   delete(n,1,pos('.',n) + 1);
   s := copy(n,1,pos(' ',n) - 1);
   if txn in [1,2] then
   begin
     while length(k) < 2 do k := '0' +k;
     while length(g) < 3 do g := '0' +g;
     while length(s) < 2 do s := '0' +s;
     if txn = 1 then
     z := k+'.'+g+'.'+s+'.'
     else
      z := k+'.'+g+'.'+s;
   end
   else   if txn <> 4 then
   z := k+'.'+g+'.'+s+' ';
   case txn of
   1 : for x := 0 to stringgrid1.RowCount - 1 do
       if z = stringgrid1.Cells[0,x]  then break;
   2 : for x := 0 to stringgrid2.RowCount - 1 do
       if z = stringgrid2.Cells[0,x]  then break;
   3 : for x := 0 to stringgrid3.RowCount - 1 do
           if AdaptM(z,s,x,k,g) then break;
   4 : begin
          f := 'Rām, '+k+', '+g+', '+s;

          for x := 0 to stringgrid5.RowCount - 1 do
          if f = stringgrid5.Cells[0,x] then break;
          if x <>  stringgrid5.RowCount - 1 then
             z := stringgrid5.Cells[1,x] + ' '
          else
           begin z :='!';  x := 50000;
//              Showmessage(f);
           end;

          if (z <> '!') and (z <> '') then
          begin
              for x := 0 to stringgrid4.RowCount - 1 do
               if z = stringgrid4.Cells[0,x]  then break;
          end;
//          if f = 'Rām, 1, 11, 3' then
//          showmessage(stringgrid5.Cells[1,x]);

          end;

   end;
//   showmessage(f +'   '+ z + ' ' + inttostr(x));
   if z <> '!' then
   AdptN := x
   else  AdptN := 0;

end;

Function trk.GetStr(txn : word; st : longint; iast : boolean) : string;
var sdd4 : string;
begin
    case txn of
    1 : if iast then
        begin

        end
         else
         sdd4 := stringgrid1.Cells[2,st];
    2 :if iast then
        begin

        end
         else
         sdd4 := stringgrid2.Cells[2,st];
    3 :if iast then
        begin

        end
             else
             sdd4 := stringgrid3.Cells[2,st];
    4 :if iast then
        begin
          sdd4 := stringgrid4.Cells[1,st]+'<br></font>' +
                  stringgrid4.Cells[2,st]          ;
        end
        else
           sdd4 := stringgrid4.Cells[2,st];


    end;
    GetStr := sdd4;
end;
Function trk.Alit(s : string) : string;
var n,B,c,slk : string;
begin
   Delete(s,1,pos('" ',s)+1);
   n := copy(s,1, pos(' ',s) - 1);
   delete(s,1,pos(' ',s));

   b := copy(s,1,pos(',',s)-1);
   delete(s,1,pos(' ',s));

   c := copy(s,1,pos('.',s) - 1);
   delete(s,1,pos(' ',s));
   slk  := copy(s,1,pos(' ',s) - 1);

   Alit := {'('+n+' '+}GetRim(b)+'. '+c+'. '+slk{+')'};
end;
function trk.GetRim(s : string) : string;
begin
         case s of
              '1' : GetRim := 'I';
              '2' : GetRim := 'II';
              '3' : GetRim := 'III';
              '4' : GetRim := 'IV';
              '5' : GetRim := 'V';
              '6' : GetRim := 'VI';
              '7' : GetRim := 'VII';
              '8' : GetRim := 'VIII';
              '9' : GetRim := 'IX';
              '10' : GetRim := 'X';
              '11' : GetRim := 'XI';
              '12' : GetRim := 'XII';
              '13' : GetRim := 'XIII';
              '14' : GetRim := 'XIV';
              '15' : GetRim := 'XV';
              '16' : GetRim := 'XVI';
              '17' : GetRim := 'XVII';
              '18' : GetRim := 'XVIII';
              '19' : GetRim := 'XIX';
              '20' : GetRim := 'XX';
              '21' : GetRim := 'XXI';
              '22' : GetRim := 'XXXII';
              '23' : GetRim := 'XXIII';
              '24' : GetRim := 'XXIV';
              '25' : GetRim := 'XXV';
              '26' : GetRim := 'XXVI';
              '27' : GetRim := 'XXVII';
              '28' : GetRim := 'XXVIII';
              '29' : GetRim := 'XXIX';
              '30' : GetRim := 'XXX';




         else
           GetRim := '';

         end;
end;
function trk.Adaptm(z,s : string; x : longint; d,g : string) : boolean;
var s1,s2,s3 : string;
    i,j,k : word;
    q : boolean;
begin
    q := false;
    i := 0;j:=0;k:=0;
    sq := stringgrid3.Cells[2,x];
    if s <> '' then j := strtoint(s);
    s1 := stringgrid3.Cells[0,x];
    if s1 = z then q := true
    else
     if pos(d+'.'+g+'.',s1) =1 then
     begin
       if pos('-',s1) > 0 then
       begin
         delete(s1,1,pos('.',s1));
         delete(s1,1,pos('.',s1));
         s2 := copy(s1,1,pos('-',s1)-1);
         delete(s1,1,pos('-',s1));
         s3 := s1;
         while pos(' ',s3) > 0 do delete(s3,pos(' ',s3),1);
         if s2 <> '' then i := strtoint(s2);
         if s3 <> '' then k := strtoint(s3);
         if (i <> 0) and (j <> 0) and (k <> 0) then
         if (j >= i) and (j <= k) then
         begin
            q := true
//            delete(sq,)
         end
         else
          q := false;


       end;
     end;

    AdaptM := q;
end;
function trk.GetBtl(sn : string; sn1 : longint) : string;
var s : string; i : longint;
    s1 : string;
    sgn: string;
begin
   s1 := '';sgn := '';
   for i := length(sn) downto 1 do
    if sn[i] <> ' ' then sn[i] := '#'
    else begin sn[i] := '#';break;end;

   sn := copy(sn,1,pos('#',sn) - 1);
//   showmessage(sn+#13+#10+stringgrid6.Cells[2,1]);
   for i := 0 to stringgrid6.RowCount - 1 do
   if stringgrid6.Cells[2,i] = sn then
   begin
     sgn := sgn + '"'+stringgrid6.Cells[0,i] +'"';
     s1 := s1 + '<span style="background: yellow">'+
     '<b>Böhtlingk: '+ stringgrid6.Cells[0,i] + '</b><br>' +
     '<font color = blue>'+stringgrid6.Cells[1,i]+'<br></font>' +
     'Соответствие: ' + copy(stringgrid6.Cells[3,i],3,2)+'%<br>';

//     break;
   end;
   s := stringgrid4.Cells[0,sn1];;
   for i := 0 to stringgrid7.RowCount - 1 do
   if (stringgrid7.Cells[0,i]+ ' ' = s) and
      (pos('"'+stringgrid7.Cells[3,i]+'"',sgn) = 0) then
      s1 := s1 + '<b>Böhtlingk: '+
      stringgrid7.Cells[3,i]+'<br><font color = "blue"></b>'+stringgrid7.Cells[4,i]+'<br></font>' +
      'Соответствие: ' + copy(stringgrid7.Cells[2,i],3,2) +'%';

   if s1 <> '' then s1 := s1 + '</span></b><br>';
   GetBTl := s1;
end;

end.

