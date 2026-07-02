program adj1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, load1
  { you can add units after this };

begin
  load1;
  cnt;

end.

