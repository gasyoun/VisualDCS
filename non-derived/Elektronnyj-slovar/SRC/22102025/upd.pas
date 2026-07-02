unit upd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, FileCtrl, ExtCtrls,
  StdCtrls, IdFTP, MPlayerCtrl, RichMemo;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    IdFTP1: TIdFTP;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdFTP1AfterClientLogin(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
var s,d : string;
begin
  idftp1.Connect;
  idftp1.ChangeDir('Sanskrit');
  s := 'dic32.lpi';
  d := 'h:\3.0\sys\update\dic32.lpi';
  idftp1.SiteToSiteDownload(idftp1,s,d);
  s := idftp1.DirectoryListing.DirectoryName;
  showmessage(s);
end;

procedure TForm1.IdFTP1AfterClientLogin(Sender: TObject);
begin

end;

end.

