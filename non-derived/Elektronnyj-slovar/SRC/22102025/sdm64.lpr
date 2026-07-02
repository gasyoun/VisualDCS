program sdm64;


uses
  Interfaces, // this includes the LCL widgetset
  Forms, poisk, tema1, keybrd, help1, repo1, gram, gdepo, gfr, ver1, sfo, dcon,
  EDepo, ssv, sh1, ngh, depo1, ent1, h1, ht1, tt1, depo2, grmx, Eda1, unit2xxx,
  ds1, tcf, lns1, wrf, vf2, tcompare, StAns, TsN, rusk, trunit,vd1, omf
  { you can add units after this };






{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
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
  Application.CreateForm(tdc, dc);
  Application.CreateForm(Twc, wc);
  Application.CreateForm(TEDA, EDA);
  Application.CreateForm(TTTS, TTS);
  Application.CreateForm(TLns, Lns);
  Application.CreateForm(TWR, WR);
  Application.CreateForm(TVForms, VForms);
  Application.CreateForm(TCT, CT);
  Application.CreateForm(TSTA, STA);
  Application.CreateForm(TSinta, Sinta);
  Application.CreateForm(Trk, rk);
  Application.CreateForm(TTRE, TRE);
  Application.CreateForm(Tverdir, verdir);
  Application.CreateForm(Tof1, of1);
  Application.Run;
end.

