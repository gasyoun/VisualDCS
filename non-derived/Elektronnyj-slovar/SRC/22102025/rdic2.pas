unit rdic2;
interface
uses
  Classes, SysUtils,windows,dialogs;
const
   threadcount = 10;
   stringlen = 1000;
var
 finished : longint;
threadvar
 thri : ptrint;
{$mode ObjFPC}{$H+}
 function f(p : pointer) : ptrint;
 procedure run1;


implementation
function f(p : pointer) : ptrint;
var
  s : ansistring;
begin
{  Writeln('thread ',longint(p),' started');
  thri:=0;
  while (thri<stringlen) do begin
    s:=s+'1'; { create a delay }
    writeln('thread ',longint(p),' thri ',thri,' Len(S)= ',length(s));
	inc(thri);
  end;
  Writeln('thread ',longint(p),' finished');
  }
  f:=0;
   s := getcurrentdir + '\DATA';
   if setcurrentdir(s) then
   begin
      if fileexists('dic64.exe') and
      fileexists('sys\T\ldx0') then
      winexec('dic64.exe',1);
   end
   else
   begin
     showmessage('No main programfiles found');
     InterLockedIncrement(finished);
     halt(1);
   end;
   InterLockedIncrement(finished);
end;
procedure run1;
var
   i : longint;
   Begin
      finished:=0;
      for i:=1 to 1 do//threadcount do
        BeginThread(@f,pointer(i));

   End;


end.

