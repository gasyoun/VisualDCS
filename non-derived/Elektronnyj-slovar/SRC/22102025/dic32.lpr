program dic32;
{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}



  Interfaces, // this includes the LCL widgetset
  Forms, Windows,  poisk, tema1, keybrd, help1, repo1, gram, gdepo, gfr, ver1, sfo,
  dcon, ssv, sh1, ngh, depo1, ent1, h1, ht1, tt1, depo2, grmx, unit2xxx, ds1, tcf,
  lns1, wrf, vf2, tcompare, StAns, TsN, rusk, trunit, vd1, omf, parals, lgg,
  frs, wTC, Tinfo, dF, syn, fdic, vpref, lex2, lpak, params, sintagma1,kn,ched1,
  Edepo, acat, Thank, th2, krr, trwin, tachartlazaruspkg;


{$R *.res}






begin
  Application.Scaled:=True;
  Application.Initialize;
  RequireDerivedFormResource:=True;
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

  Application.CreateForm(TRDR, RDR);
  Application.CreateForm(Tng, ng);
  Application.CreateForm(TEnt, Ent);
  Application.CreateForm(THl, Hl);
  Application.CreateForm(Tht, ht);
  Application.CreateForm(Ttt, tt);
  Application.CreateForm(tdc, dc);
  Application.CreateForm(Twc, wc);
  Application.CreateForm(Tkkn, kkn);
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
  Application.CreateForm(Tprl, prl);
  Application.CreateForm(Tliga, liga);
  Application.CreateForm(TFR, FR);
  Application.CreateForm(TWT1, WT1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);

  Application.CreateForm(Tng, ng);
  Application.CreateForm(Tchd, chd);
  Application.CreateForm(Tsintagma, sintagma);
  Application.CreateForm(TEd, Ed);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(Tlp, lp);
  Application.CreateForm(TForm9, Form9);

  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(Tkr, kr);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TTr, Tr);
  Application.Run;

end.

