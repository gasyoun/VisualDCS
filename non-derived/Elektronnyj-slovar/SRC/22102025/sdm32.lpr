program sdm32;


uses
  Interfaces, // this includes the LCL widgetset
  Forms, poisk, tema1, keybrd, help1, repo1, gram, gdepo, gfr, ver1, sfo,
  dcon,  EDepo, ssv, sh1, ngh,depo1, ent1, h1, ht1, tt1
  { you can add units after this };






{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tform1, form1);
  Application.CreateForm(Tshis, shis);
  Application.CreateForm(Tsymba, symba);
  Application.CreateForm(TTz, Tz);
  Application.CreateForm(Thlp, hlp);
  Application.CreateForm(TNN, NN);
  Application.CreateForm(Tgd, gd);
  Application.CreateForm(Tgres, gres);
  Application.CreateForm(Tvr, vr);
  Application.CreateForm(Tsf, sf);
  Application.CreateForm(Tdc, dc);
  Application.CreateForm(TED, ED);
  Application.CreateForm(TRDR, RDR);
  Application.CreateForm(Tng, ng);
  Application.CreateForm(TEnt, Ent);
  Application.CreateForm(THl, Hl);
  Application.CreateForm(Tht, ht);
  Application.CreateForm(Ttt, tt);
  Application.Run;
end.


