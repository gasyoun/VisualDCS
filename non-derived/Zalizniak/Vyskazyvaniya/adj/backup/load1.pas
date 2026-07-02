unit load1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;
type o1 = record
     osn : string;
     g   : string;
    end;

var O : Array[1..223341] of O1;
    cng : Array[1..8] of dword;
    adj : dword;
    procedure l1;
    procedure cnt;
implementation
procedure l1;
var f,f1 : text; s,s1,s2 : string; i : dword;
begin assignfile(f,'!!8.txt');reset(f);
      for i := 1 to length(O) do
      begin
        readln(f,s);
        if s <> '' then
        begin
          delete(s,1,pos(',',s));
          o[i].osn:=copy(s,1,pos(',',s)-1);
          delete(s,1,pos(',',s));
          o[i].g:=copy(s,1,pos(',',s)-1);
        end;
      end;
      adj := 0;
      for i := 1 to 8 do cng[i] := 0;
      closefile(f);
end;
procedure cnt;
var f : text; s,s1,s2,s3 : string; i,j : dword;
begin assignfile(f,'10.!');reset(f);
      while not(eof(f)) do
      begin
        readln(f,s);
        if s <> '' then
        begin
           s1 := copy(s,1,pos(',',s)-1);
           i := strtoint(s1);
           if i <= length(o) then
           if {(o[i].g <> 'ind') and
              (o[i].g <> 'nr') and
              (o[i].g <> 'adj') and
              (o[i].g <> 'pron') and

              (pos('P',o[i].g) > 0) or
              (pos('Ā',o[i].g) > 0)
              }
              o[i].g = 'pron'

           then
           begin
             for j := 1 to 8 do Delete(s,1,pos(',',s));
             s2 := copy(s,1,pos(',',s)-1);
             j := strtoint(s2);
             if j in [1..8] then
             inc(cng[j]);
//             if j > 0 then
             inc(adj);
           end;

        end;
      end;
      closefile(f);
      assignfile(f,'123'); rewrite(f);
      for i := 1 to 8 do
      write(f,cng[i]/adj*100:3:2,' ');
      writeln(f,adj);
      closefile(f);
end;

end.

