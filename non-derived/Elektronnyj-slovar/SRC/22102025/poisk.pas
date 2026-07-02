unit poisk;
{$mode objfpc}{$H+}
interface
uses

  windows, variants, messages, Classes, SysUtils, FileUtil, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Grids, EditBtn, ComCtrls, Buttons,
  Menus, ComboEx, ExtDlgs, CheckLst, PopupNotifier, HtmlView,Types;

type wprec = Array[1..50] of record
            l : dword;
            t : dword;
            w : dword;
            h : dword;
            sw : byte;
            ct : word;
          end;
  { TForm1 }
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    Books: TSpeedButton;
    Bt10: TButton;
    Button123: TButton;
    Button400: TButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox26: TCheckBox;
    CheckBox27: TCheckBox;
    CheckBox28: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    Edit1: TEdit;

    Edit3: TEdit;
    ExTXT1: TSpeedButton;
    hw1: THtmlViewer;
    Image12: TImage;
    Label14: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    ListBox2: TListBox;
    Memo1: TMemo;
    Memo2: TMemo;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    ComboBox2: TComboBox;
    Combobox3: TComboBoxEx;
    ComboBox6: TComboBox;
    Edit2: TEdit;
    Image10: TImage;
    Image11: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label1: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label7: TLabel;
    ListBox1: TListBox;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem126: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    Menuitem2: TButton;
    GTT: TMenuItem;
    hw1C: TMenuItem;
    hw1SA: TMenuItem;
    GGL1: TMenuItem;
    ExTXT: TSpeedButton;
    Panel13: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    Panel60: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Sdown: TSpeedButton;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    Shape29: TShape;
    Shape30: TShape;
    Shape31: TShape;
    Shape32: TShape;
    Shape33: TShape;
    Shape34: TShape;
    Shape35: TShape;
    Shape36: TShape;
    Shape37: TShape;
    Shape9: TShape;
    SPXR1: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    SpeedButton32: TSpeedButton;
    SpeedButton33: TSpeedButton;
    SpeedButton34: TSpeedButton;
    SpeedButton35: TSpeedButton;
    SpeedButton36: TSpeedButton;
    SpeedButton37: TSpeedButton;
    SpeedButton38: TSpeedButton;
    SpeedButton39: TSpeedButton;
    SpeedButton40: TSpeedButton;
    SpeedButton41: TSpeedButton;
    SpeedButton42: TSpeedButton;
    SpeedButton43: TSpeedButton;
    SpeedButton44: TSpeedButton;
    spp1: TSpeedButton;
    spp2: TSpeedButton;
    SPXR2: TSpeedButton;
    SPXR3: TSpeedButton;
    SPXR4: TSpeedButton;
    SPXR5: TSpeedButton;
    SPXR6: TSpeedButton;
    YTr1: TMenuItem;
    NCC: TSpeedButton;
    NCC1: TSpeedButton;
    ORes: TSpeedButton;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel12: TPanel;
    Panel14: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    Panel42: TPanel;
    Panel44: TPanel;
    Panel45: TPanel;
    Panel5: TPanel;
    Panel58: TPanel;
    Panel59: TPanel;
    Panel6: TPanel;
    PopupMenu8: TPopupMenu;
    ProgressBar1: TProgressBar;
    Separator3: TMenuItem;
    MenuItem21: TMenuItem;
    PopupMenu4: TPopupMenu;
    Separator2: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem58: TMenuItem;
    AdjN: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem60: TMenuItem;
    MenuItem63: TMenuItem;
    NounM: TMenuItem;
    MenuItem69: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem70: TMenuItem;
    MenuItem73: TMenuItem;
    MenuItem74: TMenuItem;
    MenuItem75: TMenuItem;
    MenuItem76: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel39: TPanel;
    Panel43: TPanel;
    Panel46: TPanel;
    Panel48: TPanel;
    Panel49: TPanel;
    Panel50: TPanel;
    Panel51: TPanel;
    Panel52: TPanel;
    Panel53: TPanel;
    Panel54: TPanel;
    Panel55: TPanel;
    Panel56: TPanel;
    Panel57: TPanel;
    PopupMenu6: TPopupMenu;
    PopupMenu7: TPopupMenu;
    Separator8: TMenuItem;
    MenuItem65: TMenuItem;
    MenuItem72: TMenuItem;
    PN1: TPopupNotifier;
    MenuItem156: TMenuItem;
    Separator1: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem61: TMenuItem;
    MenuItem62: TMenuItem;
    MenuItem66: TMenuItem;
    MenuItem67: TMenuItem;
    MenuItem68: TMenuItem;
    N3: TMenuItem;
    N2: TMenuItem;
    N1: TMenuItem;
    MenuItem71: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel2: TPanel;
    Panel9: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    PopupMenu5: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SBClear: TSpeedButton;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    SoftW: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton15: TSpeedButton;
    krl: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton29: TSpeedButton;
    SpeedButton45: TSpeedButton;
    SpeedButton51: TSpeedButton;
    SpeedButton55: TSpeedButton;
    SpeedButton59: TSpeedButton;
    SpeedButton60: TSpeedButton;
    SpeedButton61: TSpeedButton;
    SpeedButton62: TSpeedButton;
    SpeedButton63: TSpeedButton;
    SpeedButton64: TSpeedButton;
    SpeedButton65: TSpeedButton;
    SpeedButton9: TSpeedButton;
    spp3: TSpeedButton;
    spp4: TSpeedButton;
    spp5: TSpeedButton;
    spp6: TSpeedButton;
    Spr1: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton48: TSpeedButton;
    SpeedButton49: TSpeedButton;
    SpeedButton50: TSpeedButton;
    SpeedButton52: TSpeedButton;
    SpeedButton53: TSpeedButton;
    SpeedButton54: TSpeedButton;
    SpeedButton56: TSpeedButton;
    SpeedButton57: TSpeedButton;
    SpeedButton58: TSpeedButton;
    StatusBarx2: TStatusBar;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    Timer1: TTimer;

     procedure AdjNClick(Sender: TObject);
     procedure BitBtn1Click(Sender: TObject);
     procedure BitBtn2Click(Sender: TObject);
     procedure BitBtn3Click(Sender: TObject);
     procedure BitBtn4Click(Sender: TObject);
     procedure BitBtn5Click(Sender: TObject);
     procedure BitBtn6Click(Sender: TObject);
     procedure BitBtn7Click(Sender: TObject);
     procedure BitBtn8Click(Sender: TObject);
     procedure BitBtn9Click(Sender: TObject);
     procedure BooksClick(Sender: TObject);
     procedure BooksMouseEnter(Sender: TObject);
     procedure BooksMouseLeave(Sender: TObject);
     procedure Bt10Click(Sender: TObject);
     procedure BTTClick(Sender: TObject);
     procedure Button10Click(Sender: TObject);


    procedure Button123Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button400Click(Sender: TObject);

    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure CheckBox10Change(Sender: TObject);
    procedure CheckBox11Change(Sender: TObject);
    procedure CheckBox12Change(Sender: TObject);
    procedure CheckBox13Change(Sender: TObject);
    procedure CheckBox14Change(Sender: TObject);
    procedure CheckBox15Change(Sender: TObject);
    procedure CheckBox16Change(Sender: TObject);
    procedure CheckBox17Change(Sender: TObject);
    procedure CheckBox18Change(Sender: TObject);
    procedure CheckBox19Change(Sender: TObject);

    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox20Change(Sender: TObject);
    procedure CheckBox21Change(Sender: TObject);
    procedure CheckBox22Change(Sender: TObject);
    procedure CheckBox23Change(Sender: TObject);
    procedure CheckBox24Change(Sender: TObject);
    procedure CheckBox25Change(Sender: TObject);
    procedure CheckBox26Change(Sender: TObject);
    procedure CheckBox27Change(Sender: TObject);
    procedure CheckBox28Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure CheckBox8Change(Sender: TObject);
    procedure CheckBox9Change(Sender: TObject);

    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure Combobox6Click(Sender: TObject);
    procedure Combobox6CloseUp(Sender: TObject);
    procedure Combobox6DblClick(Sender: TObject);
    procedure Combobox6Select(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit2Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit2MouseEnter(Sender: TObject);
    procedure Edit2MouseLeave(Sender: TObject);
    procedure ExTXT1Click(Sender: TObject);
    procedure ExTXT1MouseEnter(Sender: TObject);
    procedure ExTXT1MouseLeave(Sender: TObject);
    procedure ExTXTClick(Sender: TObject);
    procedure ExTXTMouseEnter(Sender: TObject);
    procedure ExTXTMouseLeave(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GGL1Click(Sender: TObject);
    procedure GTTClick(Sender: TObject);
    procedure hw1CClick(Sender: TObject);
    procedure hw1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure hw1SAClick(Sender: TObject);

    procedure Image10Click(Sender: TObject);
    procedure Image10MouseEnter(Sender: TObject);
    procedure Image10MouseLeave(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure Image11MouseEnter(Sender: TObject);
    procedure Image11MouseLeave(Sender: TObject);
    procedure Image1Click(Sender: TObject);

    procedure Image1MouseLeave(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure Image2MouseLeave(Sender: TObject);
    procedure Image3Click(Sender: TObject);

    procedure Image3MouseLeave(Sender: TObject);
    procedure Image4Click(Sender: TObject);

    procedure Image4MouseLeave(Sender: TObject);
    procedure Image5Click(Sender: TObject);

    procedure Image5MouseLeave(Sender: TObject);
    procedure Image6Click(Sender: TObject);

    procedure Image6MouseLeave(Sender: TObject);
    procedure Image7Click(Sender: TObject);

    procedure Image7MouseLeave(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image8MouseLeave(Sender: TObject);
    procedure Image9Click(Sender: TObject);

    procedure Image9MouseLeave(Sender: TObject);
    procedure krlClick(Sender: TObject);
    procedure krlMouseEnter(Sender: TObject);
    procedure krlMouseLeave(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure Label14Click(Sender: TObject);
    procedure Label15Click(Sender: TObject);
    procedure Label17Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);


    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);






    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure Memo1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure MenuItem100Click(Sender: TObject);
    procedure MenuItem101Click(Sender: TObject);
    procedure MenuItem102Click(Sender: TObject);
    procedure MenuItem103Click(Sender: TObject);
    procedure MenuItem104Click(Sender: TObject);
    procedure MenuItem105Click(Sender: TObject);
    procedure MenuItem106Click(Sender: TObject);
    procedure MenuItem108Click(Sender: TObject);
    procedure MenuItem109Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem110Click(Sender: TObject);
    procedure MenuItem111Click(Sender: TObject);
    procedure MenuItem112Click(Sender: TObject);
    procedure MenuItem113Click(Sender: TObject);
    procedure MenuItem114Click(Sender: TObject);
    procedure MenuItem115Click(Sender: TObject);
    procedure MenuItem116Click(Sender: TObject);
    procedure MenuItem117Click(Sender: TObject);
    procedure MenuItem118Click(Sender: TObject);
    procedure MenuItem119Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem120Click(Sender: TObject);
    procedure MenuItem121Click(Sender: TObject);
    procedure MenuItem122Click(Sender: TObject);
    procedure MenuItem123Click(Sender: TObject);
    procedure MenuItem124Click(Sender: TObject);
    procedure MenuItem125Click(Sender: TObject);
    procedure MenuItem126Click(Sender: TObject);
    procedure MenuItem127Click(Sender: TObject);
    procedure MenuItem128Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem130Click(Sender: TObject);
    procedure MenuItem131Click(Sender: TObject);
    procedure MenuItem132Click(Sender: TObject);
    procedure MenuItem133Click(Sender: TObject);
    procedure MenuItem134Click(Sender: TObject);
    procedure MenuItem135Click(Sender: TObject);
    procedure MenuItem136Click(Sender: TObject);
    procedure MenuItem137Click(Sender: TObject);
    procedure MenuItem138Click(Sender: TObject);
    procedure MenuItem139Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem140Click(Sender: TObject);
    procedure MenuItem143Click(Sender: TObject);
    procedure MenuItem144Click(Sender: TObject);
    procedure MenuItem145Click(Sender: TObject);
    procedure MenuItem147Click(Sender: TObject);
    procedure MenuItem148Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem155Click(Sender: TObject);
    procedure MenuItem156Click(Sender: TObject);
    procedure MenuItem157Click(Sender: TObject);
    procedure MenuItem158Click(Sender: TObject);
    procedure MenuItem159Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem160Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem170Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem201Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem31Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem38Click(Sender: TObject);
    procedure MenuItem39Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem40Click(Sender: TObject);
    procedure MenuItem41Click(Sender: TObject);
    procedure MenuItem43Click(Sender: TObject);
    procedure MenuItem45Click(Sender: TObject);
    procedure MenuItem46Click(Sender: TObject);
    procedure MenuItem48Click(Sender: TObject);
    procedure MenuItem49Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem50Click(Sender: TObject);
    procedure MenuItem52Click(Sender: TObject);
    procedure MenuItem53Click(Sender: TObject);
    procedure MenuItem54Click(Sender: TObject);
    procedure MenuItem55Click(Sender: TObject);
    procedure MenuItem56Click(Sender: TObject);
    procedure MenuItem58Click(Sender: TObject);
    procedure MenuItem59Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem60Click(Sender: TObject);
    procedure MenuItem61Click(Sender: TObject);
    procedure MenuItem62Click(Sender: TObject);
    procedure MenuItem63Click(Sender: TObject);
    procedure MenuItem64Click(Sender: TObject);
    procedure MenuItem65Click(Sender: TObject);
    procedure MenuItem66Click(Sender: TObject);
    procedure MenuItem67Click(Sender: TObject);
    procedure MenuItem68Click(Sender: TObject);
    procedure MenuItem691Click(Sender: TObject);
    procedure MenuItem69Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem70Click(Sender: TObject);
    procedure MenuItem71Click(Sender: TObject);
    procedure MenuItem72Click(Sender: TObject);
    procedure MenuItem73Click(Sender: TObject);
    procedure MenuItem74Click(Sender: TObject);
    procedure MenuItem75Click(Sender: TObject);
    procedure MenuItem76Click(Sender: TObject);
    procedure MenuItem77Click(Sender: TObject);
    procedure MenuItem78Click(Sender: TObject);
    procedure MenuItem79Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem80Click(Sender: TObject);
    procedure MenuItem81Click(Sender: TObject);
    procedure MenuItem82Click(Sender: TObject);
    procedure MenuItem84Click(Sender: TObject);
    procedure MenuItem85Click(Sender: TObject);
    procedure MenuItem87Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem90Click(Sender: TObject);
    procedure MenuItem91Click(Sender: TObject);
    procedure MenuItem93Click(Sender: TObject);
    procedure MenuItem96Click(Sender: TObject);
    procedure MenuItem98Click(Sender: TObject);
    procedure MenuItem99Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure NCC1Click(Sender: TObject);
    procedure NCC1MouseEnter(Sender: TObject);
    procedure NCC1MouseLeave(Sender: TObject);
    procedure NCCClick(Sender: TObject);
    procedure NCCMouseEnter(Sender: TObject);
    procedure NCCMouseLeave(Sender: TObject);
    procedure NounMClick(Sender: TObject);
    procedure OResClick(Sender: TObject);
    procedure OResMouseEnter(Sender: TObject);
    procedure OResMouseLeave(Sender: TObject);
    procedure Panel18Click(Sender: TObject);
    procedure Panel23Click(Sender: TObject);
    procedure Panel2MouseEnter(Sender: TObject);
    procedure Panel30Click(Sender: TObject);
    procedure Panel31Click(Sender: TObject);
    procedure Panel45Click(Sender: TObject);
    procedure Panel46Click(Sender: TObject);
    procedure Panel48Click(Sender: TObject);
    procedure Panel48MouseEnter(Sender: TObject);
    procedure Panel48MouseLeave(Sender: TObject);
    procedure Panel49MouseEnter(Sender: TObject);
    procedure Panel49MouseLeave(Sender: TObject);
    procedure Panel50MouseEnter(Sender: TObject);
    procedure Panel50MouseLeave(Sender: TObject);
    procedure Panel51MouseEnter(Sender: TObject);
    procedure Panel51MouseLeave(Sender: TObject);
    procedure Panel52MouseEnter(Sender: TObject);
    procedure Panel52MouseLeave(Sender: TObject);
    procedure Panel53MouseEnter(Sender: TObject);
    procedure Panel53MouseLeave(Sender: TObject);
    procedure Panel54MouseEnter(Sender: TObject);
    procedure Panel54MouseLeave(Sender: TObject);
    procedure Panel55MouseEnter(Sender: TObject);
    procedure Panel55MouseLeave(Sender: TObject);
    procedure Panel56Click(Sender: TObject);
    procedure Panel57MouseEnter(Sender: TObject);
    procedure Panel57MouseLeave(Sender: TObject);
    procedure Panel5DockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure Panel9Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PN1Close(Sender: TObject; var CloseAction: TCloseAction
      );
    procedure SBClearClick(Sender: TObject);
    procedure SBClearMouseEnter(Sender: TObject);
    procedure SBClearMouseLeave(Sender: TObject);
    procedure SdownClick(Sender: TObject);
    procedure SoftWClick(Sender: TObject);
    procedure SoftWMouseEnter(Sender: TObject);
    procedure SoftWMouseLeave(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton11MouseEnter(Sender: TObject);
    procedure SpeedButton11MouseLeave(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton12MouseEnter(Sender: TObject);
    procedure SpeedButton12MouseLeave(Sender: TObject);

    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton13MouseEnter(Sender: TObject);
    procedure SpeedButton13MouseLeave(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton14MouseEnter(Sender: TObject);
    procedure SpeedButton14MouseLeave(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure SpeedButton15MouseEnter(Sender: TObject);
    procedure SpeedButton15MouseLeave(Sender: TObject);


    procedure SpeedButton16Click(Sender: TObject);
    procedure SpeedButton16MouseEnter(Sender: TObject);
    procedure SpeedButton16MouseLeave(Sender: TObject);

    procedure SpeedButton18Click(Sender: TObject);
    procedure SpeedButton18MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton18MouseEnter(Sender: TObject);
    procedure SpeedButton18MouseLeave(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure SpeedButton19MouseEnter(Sender: TObject);
    procedure SpeedButton19MouseLeave(Sender: TObject);

    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure SpeedButton20MouseEnter(Sender: TObject);
    procedure SpeedButton20MouseLeave(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure SpeedButton21MouseEnter(Sender: TObject);
    procedure SpeedButton21MouseLeave(Sender: TObject);
    procedure SpeedButton22Click(Sender: TObject);
    procedure SpeedButton22MouseEnter(Sender: TObject);
    procedure SpeedButton22MouseLeave(Sender: TObject);
    procedure SpeedButton23Click(Sender: TObject);
    procedure SpeedButton23MouseEnter(Sender: TObject);
    procedure SpeedButton23MouseLeave(Sender: TObject);
    procedure SpeedButton24Click(Sender: TObject);
    procedure SpeedButton24MouseEnter(Sender: TObject);
    procedure SpeedButton24MouseLeave(Sender: TObject);
    procedure SpeedButton25Click(Sender: TObject);
    procedure SpeedButton26Click(Sender: TObject);
    procedure SpeedButton26MouseEnter(Sender: TObject);
    procedure SpeedButton26MouseLeave(Sender: TObject);
    procedure SpeedButton27Click(Sender: TObject);
    procedure SpeedButton27MouseEnter(Sender: TObject);
    procedure SpeedButton27MouseLeave(Sender: TObject);
    procedure SpeedButton28Click(Sender: TObject);
    procedure SpeedButton28MouseEnter(Sender: TObject);
    procedure SpeedButton28MouseLeave(Sender: TObject);
    procedure SpeedButton29Click(Sender: TObject);
    procedure SpeedButton29MouseEnter(Sender: TObject);
    procedure SpeedButton29MouseLeave(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton2MouseEnter(Sender: TObject);
    procedure SpeedButton2MouseLeave(Sender: TObject);
    procedure SpeedButton30Click(Sender: TObject);
    procedure SpeedButton30MouseEnter(Sender: TObject);
    procedure SpeedButton30MouseLeave(Sender: TObject);
    procedure SpeedButton31Click(Sender: TObject);
    procedure SpeedButton31MouseEnter(Sender: TObject);
    procedure SpeedButton31MouseLeave(Sender: TObject);
    procedure SpeedButton32Click(Sender: TObject);
    procedure SpeedButton32MouseEnter(Sender: TObject);
    procedure SpeedButton32MouseLeave(Sender: TObject);
    procedure SpeedButton33Click(Sender: TObject);
    procedure SpeedButton33MouseEnter(Sender: TObject);
    procedure SpeedButton33MouseLeave(Sender: TObject);
    procedure SpeedButton34Click(Sender: TObject);
    procedure SpeedButton34MouseEnter(Sender: TObject);
    procedure SpeedButton34MouseLeave(Sender: TObject);
    procedure SpeedButton35Click(Sender: TObject);
    procedure SpeedButton35MouseEnter(Sender: TObject);
    procedure SpeedButton35MouseLeave(Sender: TObject);
    procedure SpeedButton36Click(Sender: TObject);
    procedure SpeedButton36MouseEnter(Sender: TObject);
    procedure SpeedButton36MouseLeave(Sender: TObject);
    procedure SpeedButton37Click(Sender: TObject);
    procedure SpeedButton37MouseEnter(Sender: TObject);
    procedure SpeedButton37MouseLeave(Sender: TObject);
    procedure SpeedButton38Click(Sender: TObject);
    procedure SpeedButton38MouseEnter(Sender: TObject);
    procedure SpeedButton38MouseLeave(Sender: TObject);
    procedure SpeedButton39Click(Sender: TObject);
    procedure SpeedButton39MouseEnter(Sender: TObject);
    procedure SpeedButton39MouseLeave(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton3MouseEnter(Sender: TObject);
    procedure SpeedButton3MouseLeave(Sender: TObject);
    procedure SpeedButton40Click(Sender: TObject);
    procedure SpeedButton40MouseEnter(Sender: TObject);
    procedure SpeedButton40MouseLeave(Sender: TObject);
    procedure SpeedButton41Click(Sender: TObject);
    procedure SpeedButton41MouseEnter(Sender: TObject);
    procedure SpeedButton41MouseLeave(Sender: TObject);
    procedure SpeedButton42Click(Sender: TObject);
    procedure SpeedButton42MouseEnter(Sender: TObject);
    procedure SpeedButton42MouseLeave(Sender: TObject);
    procedure SpeedButton43Click(Sender: TObject);
    procedure SpeedButton43MouseEnter(Sender: TObject);
    procedure SpeedButton43MouseLeave(Sender: TObject);
    procedure SpeedButton44Click(Sender: TObject);
    procedure SpeedButton44MouseEnter(Sender: TObject);
    procedure SpeedButton44MouseLeave(Sender: TObject);
    procedure SpeedButton45Click(Sender: TObject);
    procedure SpeedButton45MouseEnter(Sender: TObject);
    procedure SpeedButton45MouseLeave(Sender: TObject);
    procedure SpeedButton46Click(Sender: TObject);
    procedure SpeedButton47Click(Sender: TObject);
    procedure SpeedButton47MouseEnter(Sender: TObject);
    procedure SpeedButton47MouseLeave(Sender: TObject);
    procedure SpeedButton48Click(Sender: TObject);
    procedure SpeedButton48MouseEnter(Sender: TObject);
    procedure SpeedButton48MouseLeave(Sender: TObject);
    procedure SpeedButton49Click(Sender: TObject);
    procedure SpeedButton49MouseEnter(Sender: TObject);
    procedure SpeedButton49MouseLeave(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton4MouseEnter(Sender: TObject);
    procedure SpeedButton4MouseLeave(Sender: TObject);
    procedure SpeedButton50Click(Sender: TObject);
    procedure SpeedButton50MouseEnter(Sender: TObject);
    procedure SpeedButton50MouseLeave(Sender: TObject);
    procedure SpeedButton51Click(Sender: TObject);
    procedure SpeedButton51MouseEnter(Sender: TObject);
    procedure SpeedButton51MouseLeave(Sender: TObject);
    procedure SpeedButton52Click(Sender: TObject);
    procedure SpeedButton52MouseEnter(Sender: TObject);
    procedure SpeedButton52MouseLeave(Sender: TObject);
    procedure SpeedButton53Click(Sender: TObject);
    procedure SpeedButton53MouseEnter(Sender: TObject);
    procedure SpeedButton53MouseLeave(Sender: TObject);
    procedure SpeedButton54Click(Sender: TObject);
    procedure SpeedButton54MouseEnter(Sender: TObject);
    procedure SpeedButton54MouseLeave(Sender: TObject);
    procedure SpeedButton55Click(Sender: TObject);
    procedure SpeedButton55MouseEnter(Sender: TObject);
    procedure SpeedButton55MouseLeave(Sender: TObject);
    procedure SpeedButton56Click(Sender: TObject);
    procedure SpeedButton56MouseEnter(Sender: TObject);
    procedure SpeedButton56MouseLeave(Sender: TObject);
    procedure SpeedButton57Click(Sender: TObject);
    procedure SpeedButton57MouseEnter(Sender: TObject);
    procedure SpeedButton57MouseLeave(Sender: TObject);
    procedure SpeedButton58Click(Sender: TObject);
    procedure SpeedButton58MouseEnter(Sender: TObject);
    procedure SpeedButton58MouseLeave(Sender: TObject);
    procedure SpeedButton59Click(Sender: TObject);
    procedure SpeedButton59MouseEnter(Sender: TObject);
    procedure SpeedButton59MouseLeave(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton5MouseEnter(Sender: TObject);
    procedure SpeedButton5MouseLeave(Sender: TObject);
    procedure SpeedButton60Click(Sender: TObject);
    procedure SpeedButton61Click(Sender: TObject);
    procedure SpeedButton61MouseEnter(Sender: TObject);
    procedure SpeedButton61MouseLeave(Sender: TObject);
    procedure SpeedButton62Click(Sender: TObject);
    procedure SpeedButton62MouseEnter(Sender: TObject);
    procedure SpeedButton62MouseLeave(Sender: TObject);
    procedure SpeedButton63Click(Sender: TObject);
    procedure SpeedButton63MouseEnter(Sender: TObject);
    procedure SpeedButton63MouseLeave(Sender: TObject);
    procedure SpeedButton64Click(Sender: TObject);
    procedure SpeedButton64MouseEnter(Sender: TObject);
    procedure SpeedButton64MouseLeave(Sender: TObject);
    procedure SpeedButton65Click(Sender: TObject);
    procedure SpeedButton65MouseEnter(Sender: TObject);
    procedure SpeedButton65MouseLeave(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton6MouseEnter(Sender: TObject);
    procedure SpeedButton6MouseLeave(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton7MouseEnter(Sender: TObject);
    procedure SpeedButton7MouseLeave(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton8MouseEnter(Sender: TObject);
    procedure SpeedButton8MouseLeave(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton9MouseEnter(Sender: TObject);
    procedure SpeedButton9MouseLeave(Sender: TObject);
    procedure spp1Click(Sender: TObject);
    procedure spp2Click(Sender: TObject);
    procedure spp3Click(Sender: TObject);
    procedure spp4Click(Sender: TObject);
    procedure spp5Click(Sender: TObject);
    procedure spp6Click(Sender: TObject);
    procedure Spr1Click(Sender: TObject);
    procedure Spr1MouseEnter(Sender: TObject);
    procedure Spr1MouseLeave(Sender: TObject);
    procedure SPXR1Click(Sender: TObject);

    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1HeaderClick(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid1SetCheckboxState(Sender: TObject; ACol, ARow: Integer;
      const Value: TCheckboxState);
    procedure StringGrid2Click(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
    procedure StringGrid3Click(Sender: TObject);
    procedure StringGrid3DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar2Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure WltransClick(Sender: TObject);
    procedure YTr1Click(Sender: TObject);
  private
  public
     procedure SelCnt;
     procedure FDL(s : string;sx : dword);
     function convertres(s : string) : string;
     function findd(s : string) : string;
     function convertx(s : string) : String;
     function GetletId(s : string) : byte;
     function Geytrd1(id : longint)   : dword;
     procedure getindexes(index : string);
     function isword(s1,s2 : string) : boolean;
     procedure GetN(n : string; regis : boolean);
     function  convertd(s : string) : string;
     function converti(s : string) : string;
     function askapte(s : string) : string;
     function GetGf1(s : string) : string;
     function askpwb(s : string) : string;
     Function GetF2(s : string) : string;
     function printdl1 : string;
     function printdl2 : string;
     procedure Geytrd2(b,e  :  longint);
     procedure sgw;
     procedure FillDlist(sx : longint);
     procedure GetExam(i : string; vf,vfi,c1,nx,g1 : longint);
     Function GetVerbal(v : longint) : string;
     Procedure Ldd;
     procedure GetSinta(s : string; x : boolean);
     procedure chklb14;
     procedure sdic(d : byte);
     function ChkWord(i : dword;s : string;d1,d2,d3,d4,d5,d6 : boolean) : boolean;
     function Getconv(s : string) : string;
     procedure infx(s1,s2 : string);
     procedure chp(x : byte);
     procedure p18;
     function GetLxID(s : string) : string;
     function SelLm(k,p : string) : dword;
     Function CDname(s : string) : string;
  end;
type
  tabX = record
         l       : Tlabel;
         id      : word;
         stayT   : boolean;
         mx      : boolean;
         pl      : word;
         pt      : word;
         wdh     : word;
  end;

type spos = record
          p1 : array of dword;
          p2 : dword;
       end;
type
  StatRec = record
            CName : string[32];
            c     : dword;
  end;
  strec1 = Record
            pw : string[32];
            A  : Array[1..32] of statRec;
            x  : dword;
            l  : byte;
     end;

  infc = record
    Gfc : dword;
    gfs : byte;
    fgn : string[64];
    Mfc : dword;
    mfs : byte;
    mfn : string[64];
    Gc : dword;
    Mc : dword;
    Dc1 : Array[1..21] of boolean;
    AO  : boolean;
    DCS : boolean;
    dind: byte;
    FormColor : dword;
    GridSelColor : dword;
    SpBtNColor   : dword;
    FFontColor   : dword;
    FFontname    : string[64];
    FFSize :     byte;

    end;
type
  sid1 = record
       deva    : string;
       lipi    : string;
       beg     : longint;
       ed      : longint;
       Sd      : string;
       itr     : string[3];
       itr2    : string[3];
       itr3    : string;
       itr4v   : string;
       itrhk   : string;
       slp1    : char;
       lng     : real;
       snd     : string;
       gf      : string;
       beg2    : array[1..50] of dword;
       end2    : array[1..50] of dword;
   end;
  idxdb = array[1..771293] of dword;
  idw = array[1..2,1..272157] of dword;
  Eidxdb = array[1..69991] of dword;
  Eidw = array[1..2,1..32343] of dword;
  GGD  = set of byte;

  imglst = record
         im : Timage;
         ih : String;
  end;
  dcrec = record
         DSign : char;
         DName : string;
         DDesc : String;
         DLink : string;
         en    : boolean;
         wd    : string;
         ID    : longint;
         df    : Word;
         sn    : string;
  end;
  DL1  = Array[1..18] of DCRec;
  el = record
         l : char;
         b : longint;
         e : longint;

  end;

var
  MutexHandle : THandle;
  tbb : array of tabx; tb : tabx;
  DAR : Array[1..17] of byte;
  sps : spos;
  ifc : infc; ifF : file of infc;
  dbidx : idxdb;
  wlidx : idw;
  Edbidx : Eidxdb;
  Ewlidx : Eidw;
  GDicID : set of byte = [0];
  FG     : file of GGD;
  XGD    : array[1..272157] of GGD;
//  xgd2   : array[1..272157] of GGD;



//  iml,iml1 : array[1..45] of imglst;
  CDir : string = '';
  Ldir : string = '';
  HDIR : string = '';
  HisID: longint = 0;
  SDIR : string;
  setimg : boolean = true;

  sym : array[1..75] of Tlabel;
  ww : boolean = true;
  Form1: TForm1;
  a1 , a2 : string;
  RFS : word = 12;
  idx : longint;
  d,da : array[1..72] of sid1;
  Dlist : dl1;
  DDL   : Array of DL1;
  Ell   : Array[1..26] of EL;
  Fi    : Longint = 0;
  fip   : longint = 0;
  sif   : string = '';
  fc : byte = 0;
  VerbalEx : boolean = true;
const sbl : set of char = [' ','.',',','(','[','{','"','''','!','?','#','%','&',
                           ')',']','}',':','^',';','$','*','+','=','-','0'..'9',
                           '/','\','_','`','~'];
 sbl2 : set of char = [' ',',','(','[','{','"','''','!','?','#','%','&',
                           ')',']','}',':',';','$','*','+','=','-','0'..'9',
                           '/','\','_','`'];

{$R *.lfm}
var
FSTAT : file of Strec1;
VVV : string = '';
VStat : Strec1;
implementation
uses  lazutf8, regex,TCompare,
  depo1,tema1,reult1,keybrd, repo1,help1,gram,ver1,dcon, stAns,
  ssv,sh1,adepo, pdepo, ngh,ent1,h1,ht1,tt1,depo2,grmx,sfo,gfr,krr,trwin,
  gdepo,ds1,tx1,tcf,wrf,vf2,TsN,rusk,unt,vd1,omf,parals,Thank,lns1,info1,
  kn,frs,wtc,th2,tinfo,rts,df,syn,lex2,eDepo,lpak,params,clipbrd,sintagma1,acat;
const pcolor : dword = $F0F0F0;
var
  s : string;  NCCX : boolean = false;

{ TForm1 }
procedure TForm1.Button1Click(Sender: TObject);
var  id1 : byte;
begin
   if edit2.Text = '' then
   if combobox3.ItemIndex = 0 then geytrd1(0);
   if edit2.Text <> '' then
   begin
     Edit2.Text := convertx(edit2.Text);
     Edit2.SelStart:=length(edit2.Text);
     if combobox2.ItemIndex in [1,2] then id1 := 52 else
       id1:= getletid(edit2.Text);
     if combobox3.ItemIndex <> 1 then
     idx := Geytrd1(id1)
     else
     begin
       edit2.Text:=lowercase(edit2.Text);
       geytrd2(ell[ord(edit2.Text[1]) - 96].b,ell[ord(edit2.Text[1]) - 96].e);
     end;

     StatusBarx2.panels[1].Text:= lp.StringGrid1.Cells[x229,232] + ' '+ inttostr(Stringgrid1.RowCount-1);
     Edit2.SelStart:=length(edit2.Text);

   end;
   edit2.SetFocus;
//   if stringgrid1.RowCount > 1 then
//      stringgrid1click(sender);
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
end;

procedure TForm1.Bt10Click(Sender: TObject);
var i : byte; s : string;
begin
    for i := 0 to popupmenu6.Items.Count - 1 do
    if sender = popupmenu6.Items[i] then
    begin
      if i = popupmenu6.Items.Count - 1 then
      s := stringgrid1.Cells[3,stringgrid1.Row]
      else s := listbox1.Items[i] + ' ';
      GFS := s;
      GetExam(s,0,0,0,0,0);
      if wr.WindowState=wsminimized then wr.WindowState:=wsnormal;
      wr.Show;
      wr.BringToFront;
      wr.Caption:= lp.StringGrid1.Cells[x229,462] + ' "'+
      stringgrid1.Cells[1,stringgrid1.Row] +'"';
      break;
    end;
end;

procedure TForm1.BTTClick(Sender: TObject);
begin

end;

procedure TForm1.AdjNClick(Sender: TObject);
begin
    GetN('adj.',false);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
   resform.WindowState:=wsnormal;
   resform.Show;
   resform.BringToFront;
   form1.SendToBack;

end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  rdr.Show;
  rdr.BringToFront;
  form1.SendToBack;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  lns.windowState := wsnormal;
  lns.Show;
  lns.BringToFront;
  form1.SendToBack;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
  dcs1.WindowState:=wsnormal;
  dcs1.Show;
  dcs1.BringToFront;
  form1.SendToBack;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  wr.WindowState:=wsnormal;
  wr.Show;
  wr.BringToFront;
  form1.SendToBack;
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
begin
  verdir.WindowState:=wsnormal;
  verdir.Show;
  verdir.BringToFront;
end;

procedure TForm1.BitBtn7Click(Sender: TObject);
begin
  fr.WindowState:=wsnormal;
  fr.show;
  fr.BringToFront;
end;

procedure TForm1.BitBtn8Click(Sender: TObject);
begin

  if sta.WindowState = wsminimized then
  sta.windowstate := wsnormal;
  sta.show;
  sta.BringToFront;
end;

procedure TForm1.BitBtn9Click(Sender: TObject);
begin
  tr.Show;
  tr.BringToFront;
end;

procedure TForm1.BooksClick(Sender: TObject);
begin
  form9.catalog(3);
  form9.Show;
end;

procedure TForm1.BooksMouseEnter(Sender: TObject);
begin
  books.Transparent:=false;
end;

procedure TForm1.BooksMouseLeave(Sender: TObject);
begin
  books.Transparent:=true;
end;




procedure TForm1.Button123Click(Sender: TObject);
var f,f1 : system.Text;
    s,s1,s2 : string;
    i,j,k : longint;
begin
   s2 := '';
    depo.ListBox3.Items.LoadFromFile('sys\id1.sdm');
    system.Assign(f,'grm.txt');
    rewrite(f);
    for i := 0 to stringgrid1.RowCount - 1 do
    if stringgrid1.Cells[3,i] <> '' then
    begin
      listbox1.Clear; s2 := '';
      s := stringgrid1.Cells[3,i];
      while s <> '' do
      begin
       s2 := copy(s,1,pos(' ',s)-1); delete(s,1,pos(' ',s));
       s2 := o[strtoint(s2)].stem;
       if (pos('P',s2) > 0) or (pos('Ā',s2) > 0) then
       begin
         if s2[1] in ['1'..'9'] then
         s2 := 'Verb.cl.'+s2;

       end;
       write(f,s2,'.');
      end;
      writeln(f,'');
    end
    else
    begin
     s2 := '';
    if depo.stringgrid1.cells[1,i] <> '' then
    begin

//       getindexes(i);
       s := '';
       if listbox1.Count > 0 then
       for j := 0 to listbox1.Count - 1 do
       begin
        s1 := listbox1.Items[j];
        if (s1 <> '') and (s1 <> ' ')
        and (strtoint(s1) < depo.Memo1.Lines.Count)
         then
        s := s + ' '+depo.Memo1.Lines.Strings[strtoint(s1) - 1];
       end;
       s2 := '';

        k := pos(' m.',s);
        if k > 0 then s2 := s2+ 'm.';
        k := pos(' f.',s);
        if k > 0 then s2  := s2 + 'f.';

        k := pos(' n.',s);
        if k > 0 then s2  := s2 + 'n.';

        k := pos(' mf.',s);
        if k > 0 then s2  := s2 + 'm.f.';

        k := pos(' mfn.',s);
        if k > 0 then s2  := s2 + 'm.f.n.';

        k := pos(' adv.',lowercase(s));
        if k > 0 then s2  := s2 + 'adv.';

        k := pos(' adj.',lowercase(s));
        if k > 0 then s2  := s2 + 'adj.';

        k := pos(' pron.',s);
        if k > 0 then s2  := s2 + 'pron.';

        k := pos(' ind.',s);
        if k > 0 then s2  := s2 + 'ind.';

        k := pos(' nr.',s);
        if k > 0 then s2  := s2 + 'nr.';


      end;

     if pos(' cl.',lowercase(s)) > 0 then
        s2 := s2 + 'Verb.'+copy(s,pos(' cl.',s),6);

        if (pos(' p.p.',s) > 0) or
        (pos(' pp. ',s) > 0) or
        (pos(' Par. ',s) > 0) or
        (pos(' Atm. ',s) > 0) or
        (pos(' Ātm. ',s) > 0) or
        (pos(' Ā. ',s) > 0) then
        s2 := s2 + 'Verb..';


        if  (pos(' 1 P. ',s) > 0) then s2 := s2 + 'Verb.cl.1.P.';


        if (pos(' 2 P. ',s) > 0) then s2 := s2 + 'Verb.cl.2.P.';


        if (pos(' 3 P. ',s) > 0) then s2 := s2 + 'Verb.cl.3.P.';


        if (pos(' 4 P. ',s) > 0) then s2 := s2 + 'Verb.cl.4.P.';;


        if (pos(' 5 P. ',s) > 0) then s2 := s2 + 'Verb.cl.5.P.';;


        if (pos(' 6 P. ',s) > 0) then s2 := s2 + 'Verb.cl.6.P.';;


        if (pos(' 7 P. ',s) > 0) then s2 := s2 + 'Verb.cl.7.P.';;


        if (pos(' 8 P. ',s) > 0) then s2 := s2 + 'Verb.cl.8.P.';;


        if (pos(' 9 P. ',s) > 0) then s2 := s2 + 'Verb.cl.9.P.';;


        if (pos(' 10 P. ',s) > 0) then s2 :=s2 +  'Verb.cl.10.P.';;



        if (pos(' 1 A. ',s) > 0) then s2 :=s2 +  'Verb.cl.1.A.';;


        if (pos(' 2 A. ',s) > 0) then s2 :=s2 +  'Verb.cl.2.A.';;


        if (pos(' 3 A. ',s) > 0) then s2 :=s2 +  'Verb.cl.3.A.';;


        if (pos(' 4 A. ',s) > 0) then s2 :=s2 +  'Verb.cl.4.A.';;


        if (pos(' 5 A. ',s) > 0) then s2 :=s2 +  'Verb.cl.5.A.';;


        if (pos(' 6 A. ',s) > 0) then s2 := s2 + 'Verb.cl.6.A.';;


        if (pos(' 7 A. ',s) > 0) then s2 :=s2 +  'Verb.cl.7.A.';;


        if (pos(' 8 A. ',s) > 0) then s2 :=s2 +  'Verb.cl.8.A.';;


        if (pos(' 9 A. ',s) > 0) then s2 :=s2 +  'Verb.cl.9.A.';;


        if (pos(' 10 A. ',s) > 0) then s2 := s2 + 'Verb.cl.10.A.';;

        if (pos('partic',lowercase(s)) > 0) then s2 := s2 + 'Partic.';

        if s2 = '' then
        if s <> '' then
        begin
          delete(s,1,1);
          s := copy(s,1,pos(' ',s));
          delete(s,1,1);
          s := s + ' ';

          if pos('a ',s) > 0 then s2 := 'm.';
          if pos('aḥ ',s) > 0 then s2 := 'm.';
          if pos('i ',s) > 0 then s2 := 'n.';
          if pos('iḥ ',s) > 0 then s2 := 'm.';
          if pos('o ',s) > 0 then s2 := 'm.';
          if pos('u ',s) > 0 then s2 := 'm.';
          if pos('uḥ ',s) > 0 then s2 := 'm.';
          if pos('r ',s) > 0 then s2 := 'm.';
          if pos('k ',s) > 0 then s2 := 'f.';
          if pos('n ',s) > 0 then s2 := 'm.';
          if pos('t ',s) > 0 then s2 := 'm.';
          if pos('ī ',s) > 0 then s2 := 'f.';
          if pos('ā ',s) > 0 then s2 := 'f.';
          if pos('m ',s) > 0 then s2 := 'Partic.';
         end;
        if s2 = '' then
        s2 := 'Noun';


        writeln(f,s2);
        s2 := '';
    end;
    system.Close(f);


end;

procedure TForm1.Button12Click(Sender: TObject);
begin


end;

procedure TForm1.Button13Click(Sender: TObject);
begin

end;

procedure TForm1.Button14Click(Sender: TObject);
begin
end;

procedure TForm1.Button2Click(Sender: TObject);
var i,j : longint;
    kk : string;
    k2 : string;
    k3 : string;
    ix : longint;
    f4 : text;
begin


   {  system.assign(f4,'index.tm');
  rewrite(f4);

  memo1.Hide;
  depo.Memox.Clear;
  for j := 0 to 10 do//depo.ListBox5.Items.Count - 1 do
  begin
     kk := depo.ListBox5.Items[j] + ' ';
     if length(kk) > 2 then
     begin
     for i := 1 to depo.ListBox3.Items.Count - 1 do
     begin
        k2 := depo.ListBox3.Items[i];
        repeat
           k3 := copy(k2,1,pos(' ',k2) - 1);
           if k3 <> '' then
           begin
             ix := strtoint(k3) - 2;
             if pos(depo.ListBox5.Items[j],depo.lowercase(Memo1.Lines.strings[ix])) > 0 then
             kk := kk +  inttostr(i)+ ' ';
           end;
           delete(k2,1,pos(' ',k2));

        until k3 = '';

     end;
     writeln(f4,kk);
     end;
  end;
  system.close(f4);

}
end;

procedure TForm1.Button400Click(Sender: TObject);
var i,j : longint;
    s : string;
    A : array of string;
    f : system.Text;
    o1 : array of boolean;

begin
   application.Minimize;
   system.Assign(f,'ExId.txt');
   rewrite(f);
   setlength(A,depo.stringgrid1.RowCount);
   setlength(o1,length(o)+1);
   for i := 0 to length(a) - 1 do a[i] := '';
   for i := 0 to length(o1) - 1 do o1[i] := false;


   for i := 1 to depo.stringgrid1.RowCount - 1 do
   begin
     s := depo.stringgrid1.cells[1,i];
     for j := 1 to length(o) do
     if  o[j].stem <> '' then
     if s = dcs1.getosn(inttostr(j)) then
     begin
       a[i] := a[i] + inttostr(j) + ' ';
       application.title:=  inttostr(i);
       o[j].stem := '';
     end;
   end;
   for i := 0 to length(a) - 1 do
   writeln(f,a[i]);
   closefile(f);
   showmessage('done');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
if fileexists(cdir+'\sys\fonts.sdm') then
begin

end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
;



end;

procedure TForm1.Button8Click(Sender: TObject);
begin

end;

procedure TForm1.CheckBox10Change(Sender: TObject);
begin
  if stringgrid1.RowCount > 1 then stringgrid1.Col:=1;
  dset.CheckListBox1.Checked[5] := checkbox10.Checked;
  dset.Button110Click(sender);
  chklb14;

end;

procedure TForm1.CheckBox11Change(Sender: TObject);
begin
  if stringgrid1.RowCount > 1 then stringgrid1.Col:=1;
  dset.CheckListBox1.Checked[6] := checkbox11.Checked;
  dset.Button110Click(sender);
  chklb14;
end;

procedure TForm1.CheckBox12Change(Sender: TObject);
begin
  if stringgrid1.RowCount > 1 then stringgrid1.Col:=1;
   dset.CheckListBox1.Checked[9] := checkbox12.Checked;
   dset.Button110Click(sender);
   chklb14;

end;

procedure TForm1.CheckBox13Change(Sender: TObject);
begin
  if stringgrid1.RowCount > 1 then stringgrid1.Col:=1;
  dset.CheckListBox1.Checked[1] := checkbox13.Checked;
  dset.Button110Click(sender);
  chklb14;

end;

procedure TForm1.CheckBox14Change(Sender: TObject);
begin
   if checkbox14.AllowGrayed = false then
   begin
      checkbox8.Checked:=checkbox14.Checked;
      checkbox9.Checked:=checkbox14.Checked;
      checkbox10.Checked:=checkbox14.Checked;
      checkbox11.Checked:=checkbox14.Checked;
      checkbox12.Checked:=checkbox14.Checked;
      checkbox13.Checked:=checkbox14.Checked;
      checkbox18.Checked:=checkbox14.Checked;
   end;
end;

procedure TForm1.CheckBox15Change(Sender: TObject);
begin
dset.CheckListBox1.Checked[10] := checkbox8.Checked;
dset.Button110Click(sender);
chklb14
end;

procedure TForm1.CheckBox16Change(Sender: TObject);
begin
   dset.CheckListBox2.Checked[2] := checkbox16.Checked;
   dset.Button110Click(sender);
   chklb14
end;

procedure TForm1.CheckBox17Change(Sender: TObject);
begin
dset.CheckListBox1.Checked[7] := checkbox17.Checked;
dset.Button110Click(sender);
chklb14;
end;

procedure TForm1.CheckBox18Change(Sender: TObject);
begin
   if stringgrid1.RowCount > 1 then stringgrid1.Col:=1;
   dset.CheckListBox1.Checked[2] := checkbox18.Checked;
   dset.Button110Click(sender);
   chklb14;

end;

procedure TForm1.CheckBox19Change(Sender: TObject);
begin
dset.CheckListBox1.Checked[11] := checkbox19.Checked;
dset.Button110Click(sender);
chklb14
end;



procedure TForm1.CheckBox1Change(Sender: TObject);
begin
   if checkbox1.Checked then
   begin
//     combobox4.ItemIndex:=1;
     if combobox2.ItemIndex in [1,2] then
     combobox2.ItemIndex:=0;
   end;
end;

procedure TForm1.CheckBox20Change(Sender: TObject);
begin
dset.CheckListBox1.Checked[12] := checkbox20.Checked;
dset.Button110Click(sender);
chklb14
end;

procedure TForm1.CheckBox21Change(Sender: TObject);
begin
   if checkbox21.AllowGrayed = false then
   begin
      checkbox15.Checked:=checkbox21.Checked;
      checkbox20.Checked:=checkbox21.Checked;
      checkbox19.Checked:=checkbox21.Checked;
   end;

end;

procedure TForm1.CheckBox22Change(Sender: TObject);
begin
   dset.CheckListBox2.Checked[1] := checkbox22.Checked;
   dset.Button110Click(sender);
   chklb14;
end;

procedure TForm1.CheckBox23Change(Sender: TObject);
begin
   dset.CheckListBox2.Checked[0] := checkbox23.Checked;
   dset.Button110Click(sender);
   chklb14
end;

procedure TForm1.CheckBox24Change(Sender: TObject);
begin
   if checkbox24.AllowGrayed = false then
   begin
      checkbox16.Checked:=checkbox24.Checked;
      checkbox23.Checked:=checkbox24.Checked;
      checkbox22.Checked:=checkbox24.Checked;
   end;

end;

procedure TForm1.CheckBox25Change(Sender: TObject);
begin
dset.CheckListBox1.Checked[3] := checkbox25.Checked;
dset.Button110Click(sender);
chklb14;
end;

procedure TForm1.CheckBox26Change(Sender: TObject);
begin
dset.CheckListBox1.Checked[8] := checkbox26.Checked;
dset.Button110Click(sender);
chklb14;
end;

procedure TForm1.CheckBox27Change(Sender: TObject);
begin
   if checkbox27.AllowGrayed = false then
   begin
      checkbox17.Checked:=checkbox27.Checked;
      checkbox26.Checked:=checkbox27.Checked;
      checkbox25.Checked:=checkbox27.Checked;
   end;




end;

procedure TForm1.CheckBox28Change(Sender: TObject);
begin
   if stringgrid1.RowCount > 1 then stringgrid1.Col:=1;
   dset.CheckListBox1.Checked[13] := checkbox28.Checked;
   dset.Button110Click(sender);
   chklb14;

end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  checkbox1.Checked := not(checkbox2.Checked);
  if checkbox2.Checked then
  infx('Simple Search','Autosearch mode off')
  else
   if combobox2.ItemIndex in [0,3] then
   infx('Simple Search','Autosearch mode on');
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin

end;


procedure TForm1.CheckBox5Change(Sender: TObject);
begin

end;

procedure TForm1.CheckBox6Change(Sender: TObject);
var i,c : dword;
begin
  c := 1;
  stringgrid1.Col:=0;
  geytrd1(0);
  StatusBarx2.Panels[1].Text:= lp.StringGrid1.Cells[x229,232] + ' ' +
  inttostr(stringgrid1.RowCount - 1);

  if checkbox6.Checked then
  infx('DCS ON','You can see just DCS text''''s words') else
  infx('DCS OFF','you can see all dictionaries words');
end;

procedure TForm1.CheckBox8Change(Sender: TObject);
begin
  dset.CheckListBox1.Checked[0] := checkbox8.Checked;
  dset.Button110Click(sender);
  chklb14;
end;

procedure TForm1.CheckBox9Change(Sender: TObject);
begin
  if stringgrid1.RowCount > 1 then stringgrid1.Col:=1;
  dset.CheckListBox1.Checked[4] := checkbox9.Checked;
  dset.Button110Click(sender);
  chklb14;

end;




procedure TForm1.ComboBox2Change(Sender: TObject);
begin
     if combobox2.ItemIndex < 0 then
     combobox2.ItemIndex:=0;
  if combobox2.ItemIndex in [1,2] then
  begin
     checkbox1.Checked:=false;
     infx('AutoSearch Mode OFF','');
  end
  else
  if checkbox2.Checked = false then
  begin
   checkbox1.Checked:=true;
   infx('AutoSearch Mode ON','AutoSearch with input symbols');
  end;
  if edit2.Text <> '' then
  button1click(sender);
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
var i : longint;
begin
   if combobox3.ItemIndex = 1 then
   begin
      vstat.A[20].CName:='EnSanDic';
      inc(vstat.A[20].c);
   end;


if combobox3.ItemIndex <> 1 then
begin
  checkbox2.Show;
//  panel48.Hide;
//  panel48.Align:=alnone;
  panel49.Show;panel50.show;panel51.Show;
  panel50.Left:=788;
  panel49.Left:=853;
//  panel48.show;
//  panel48.Left:=916;
//panel48.Align:=alleft;
   SpeedButton7Click(Sender);
   memo1.Clear;
end
else
begin
 checkbox2.Hide;
 panel8.hide;panel23.hide;panel33.hide;panel26.show;
 combobox6.Hide;//checkbox6.Hide;
 panel49.hide;panel50.hide;panel51.hide;
 for i := 0 to 9 do
 if i in [0,2..8] then
 stringgrid1.Columns[i].Visible:=false;
 stringgrid1.Columns[1].Width:=stringgrid1.Width-32-
 stringgrid1.Columns[9].Width;
 memo1.Clear;
 geytrd2(0,0);
 stringgrid1.Row:=-1;
end;

end;

procedure TForm1.ComboBox4Change(Sender: TObject);
begin
//  if combobox4.ItemIndex > 2 then
  begin
//    checkbox1.Checked:=false;
//    combobox1.ItemIndex:=1;
  end;
end;

procedure TForm1.ComboBox5Change(Sender: TObject);
var i : integer;
    z : boolean;
begin
{
    z := false;
    if ComboBox6.items.Count > 0 then
    for i := 0 to ComboBox6.items.Count - 1 do
    if pos(ComboBox6.text,ComboBox6.Items[i]) = 1 then
    begin
      label9.Caption:=stringgrid3.Cells[1,i];
      label9.Hint:=label9.Caption;
      ComboBox6.Autodropdown := true;
      ComboBox6.AutoComplete:=false;
      z := true;
      break;
    end;
    if z = false then
    begin
       ComboBox6.autodropdown := false ;
       label9.Caption:='';
       ComboBox6.AutoComplete:=true;;
    end; }
end;

procedure TForm1.ComboBox6Change(Sender: TObject);
begin
gdicid := [combobox6.ItemIndex];
  if combobox6.ItemIndex = 0 then
  begin

   if checkbox6.Checked = false then
      checkbox6change(sender) else
   checkbox6.Checked:=false;
  end
  else
  begin

//    gdicid := combobox6.ItemIndex;
    if checkbox6.Checked then
    checkbox6change(sender) else
    checkbox6.Checked:=true;
    infx(combobox6.Text + 'Dictionary ON','You can see just this Period/text''''s words');
  end;
  if checkbox6.Checked then panel48.BevelOuter:=bvraised
  else panel48.BevelOuter:=bvnone;


end;

procedure TForm1.Combobox6Click(Sender: TObject);
begin

end;

procedure TForm1.Combobox6CloseUp(Sender: TObject);
begin
end;

procedure TForm1.Combobox6DblClick(Sender: TObject);
begin

end;

procedure TForm1.Combobox6Select(Sender: TObject);
begin
//  combobox6.Checked[combobox6.ItemIndex]  := not(combobox6.Checked[combobox6.ItemIndex]);
end;

procedure TForm1.Edit1Change(Sender: TObject);
var s : utf8string;
   p,l : dword;
begin l := 0;
setlength(sps.p1,0);

if edit1.Text = '' then
begin
   label3.Caption:='0/0';
   label3.Enabled:=false;
   spp1.Enabled:=false;
   spp2.Enabled:=false;
   setlength(sps.p1,0); sps.p2:=0;
 end
else
begin
  if checkbox3.Checked then
  begin
    edit1.Text:=convertx(edit1.Text);
    edit1.SelStart:=length(edit1.Text);
    edit1.SetFocus;
  end;
     s := hw1.GetTextByIndices(1,50000);
     p := utf8pos(edit1.Text,s); l := 0;

     while p > 0 do
     begin
       inc(l);
       utf8delete(s,1,p-1+utf8length(edit1.Text));
       p := utf8pos(edit1.Text,s);
     end;
     Setlength(sps.p1,l);sps.p2:=1;
      if l > 0 then
      begin
        label3.Caption:='1/'+inttostr(l);
        label3.Enabled:=true;
        spp1.Enabled:=true;
        spp2.Enabled:=true;
        sps.p2:=1;
        hw1.FindEx(edit1.Text,false,false);
      end
      else
      begin
         label3.Caption:='0/0';
         label3.Enabled:=false;
         spp1.Enabled:=false;
         spp2.Enabled:=false;
         setlength(sps.p1,0); sps.p2:=0;
       end;
     end;

end;




procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin

end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if key in [#13,#10] then
  if length(sps.p1) > 0 then
  begin
   sps.p2:=1;
   if spp2.Enabled then
   spp2click(sender);
  end;
{
  if key = #33 then
  if length(sps.p1) > 0 then
  begin
   sps.p2:=length(sps.p1);
   spp1click(sender)
  end;
  if key = #34 then
  if length(sps.p1) > 0 then
  begin
   sps.p2:=1;
   spp2click(sender);
  end;
  if key = #38 then spp2click(sender);
  if key = #40 then spp1click(sender);

}
end;

procedure TForm1.Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

end;


procedure TForm1.Edit2Change(Sender: TObject);
var id1 : longint;
    a,w : word;
begin
if combobox3.ItemIndex <> 1 then
begin
   if edit2.Text = '' then
   begin
     label2.visible := false;
     combobox2.Show;//combobox3.Show;
     geytrd1(0);
     StatusBarx2.Panels[1].Text:= lp.StringGrid1.Cells[x229,232] + ' '+
     inttostr(stringgrid1.RowCount-1);
   end;

   a := edit2.SelStart;
   w := length(edit2.Text);
   Edit2.Text := convertx(edit2.Text);
   if edit2.Text <> '' then
   begin
      label2.Caption:=convertd(edit2.Text);
      label2.Left:=edit2.Left;
      label2.Width:=edit2.Width;
      label2.show;
      label2.Top:=edit2.Top+edit2.Height-1;
      combobox2.hide;
      combobox3.Hide;
      label2.BringToFront;
   end
   else
   begin
      label2.hide;
      combobox2.Show;
//      combobox6.Show;
   end;

   if w = length(edit2.Text) then edit2.SelStart:=a
   else   edit2.SelStart:= a - (w - length(edit2.Text)) + 1;
   edit2.SetFocus;
   if (combobox2.ItemIndex in [0,3]) and (checkbox2.checked = false) then
   if checkbox1.Checked then
   if edit2.Text <> '' then
   begin
     id1:= getletid(edit2.Text);
     idx := Geytrd1(id1);
     StatusBarx2.panels[1].Text := lp.StringGrid1.Cells[x229,232] + ' '+
     inttostr(stringgrid1.RowCount - 1);
     StatusBarx2.Panels[3].Text := StatusBarx2.panels[0].Text;
   end;
   edit2.SetFocus;

end
else
begin
if (edit2.Text <> '') and checkbox1.Checked and (lowercase(edit2.text[1]) in ['a','z']) then
begin
  id1 := ord(lowercase(edit2.Text[1])) - 96;
  Geytrd2(ell[id1].b,ell[id1].e);
end else geytrd2(0,0);
end;
  if edit2.Text = '*2024' then dcs1.SpeedButton8.Visible:=true;
  if edit2.Text = '*2025' then nccx := true;
  stringgrid1.Columns[10].Visible:=false;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if key in [#13,#10] then button1Click(sender);
end;

procedure TForm1.Edit2MouseEnter(Sender: TObject);
begin
  if combobox3.ItemIndex <> 1 then
  if edit2.Text <> '' then
  begin
   label2.show;
   combobox2.Hide;combobox3.Hide;
  end;

end;

procedure TForm1.Edit2MouseLeave(Sender: TObject);
begin
  label2.hide;
  combobox2.Show;//combobox3.Show;
end;

procedure TForm1.ExTXT1Click(Sender: TObject);
begin
shellexecute(0,'open',pchar('sys\T\texts.xlsx'),nil,nil,1);
end;

procedure TForm1.ExTXT1MouseEnter(Sender: TObject);
begin
  EXTXT1.Transparent:=false;
end;

procedure TForm1.ExTXT1MouseLeave(Sender: TObject);
begin
EXTXT1.Transparent:=true;
end;

procedure TForm1.ExTXTClick(Sender: TObject);
begin
  Ct.Show;
  CT.BT2.Enabled := true;
  CT.StringGrid1.LoadFromCSVFile('sys\t\texts.csv',#9,true);
  CT.prep;
  CT.Caption:='Подробный анализ корпуса';
end;

procedure TForm1.ExTXTMouseEnter(Sender: TObject);
begin
  ExTXt.Transparent:=false;
end;

procedure TForm1.ExTXTMouseLeave(Sender: TObject);
begin
   ExTXt.Transparent:=true;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  spr1.Visible:=true;
  spr1.Font.Color:=$3333CC;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var i,j,k,l : dword;
    fpw : file of wPrec;
    x   : Wprec;
begin
if shis.StringGrid1.RowCount > 1 then
begin
 k := 0;
 for i := 1 to shis.StringGrid1.RowCount-1 do
 begin
  if k < strtoint(shis.StringGrid1.Cells[2,i]) then
  begin
   k := strtoint(shis.StringGrid1.Cells[2,i]);
   j := i;
  end;
 end;
 if k > 1 then vstat.pw:=shis.StringGrid1.Cells[1,j];
end;
  tz.Close;
  shis.Close;
  dcs1.Close;
  vstat.l:=form8.ComboBox1.ItemIndex;
  rewrite(fstat);
  write(fstat,vstat);
  closefile(fstat);
  assignfile(fpw,'sys\wps.dig');
  rewrite(fpw);

  x[1].l:=left;x[1].t:=top;x[1].w:=1920;x[1].h:=1000;
  if windowstate = wsmaximized then x[1].sw := 0 else x[1].sw:=  0;

  x[1].ct:=dcs1.ComboBox1.ItemIndex;

  x[2].l:=dcs1.left;x[2].t:=dcs1.top;x[2].w:=dcs1.width;x[2].h:=dcs1.height;
    if dcs1.windowstate  = wsmaximized then  x[2].sw := 0 else  x[2].sw:=  1;
    x[2].ct:=dcs1.ComboBox1.ItemIndex;

  write(fpw,x);
  closefile(fpw);
end;



procedure TForm1.FormCreate(Sender: TObject);
var a,c,cnt1,i,j,k : longint;
    s : string;
    F2 : file of idw;  F1 : file of idxdb;
    F4 : file of Eidw; f3 : file of Eidxdb;
//    MyResStream: TResourceStream;
      fpw : file of wPrec;
      x   : Wprec;

begin
   MutexHandle := CreateMutex(nil, True, 'Saudamani');
   if GetLastError = ERROR_ALREADY_EXISTS then
   begin
     ShowMessage('Приложение уже запущено! Пожалуйста, дождитесь загрузки');
     Application.Terminate;
     halt(0);
   end;

   a := $A0A0A0;

   shape2.Pen.Color:=a;
   shape3.Pen.Color:=a;
   shape4.Pen.Color:=a;
   shape5.Pen.Color:=a;
   shape6.Pen.Color:=a;
   shape7.Pen.Color:=a;
   shape8.Pen.Color:=a;
   a := $999999;
   shape9.Pen.Color:=a;

   shape24.Pen.Color:=a;
   shape25.Pen.Color:=a;
   shape26.Pen.Color:=a;
   shape27.Pen.Color:=a;
   shape28.Pen.Color:=a;
   shape29.Pen.Color:=a;
   shape30.Pen.Color:=a;
   shape31.Pen.Color:=a;
   shape32.Pen.Color:=a;
   shape33.Pen.Color:=a;
   shape34.Pen.Color:=a;
   shape35.Pen.Color:=a;
   shape36.Pen.Color:=a;
   shape37.Pen.Color:=a;


   speedbutton28click(sender);





  assignfile(fstat,'sys\stt.dig');
  if fileexists('sys\stt.dig') then
  begin
   reset(fstat);read(fstat,vstat);
  end;
  inc(vstat.x);
  for i := 1 to length(dar) do dar[i] := i;

   assignfile(FG,'sys\4.0\tidx.dig');reset(fg);
   for i := 1 to length(xgd) do read(fg,xgd[i]);closefile(fg);

   assignfile(f1,'sys\4.0\index.dig');reset(f1); read(f1,dbidx);closefile(f1);
   assignfile(f2,'sys\4.0\index.edg');reset(f2); read(f2,wlidx);closefile(f2);
   assignfile(f3,'sys\4.0\index.dg2');reset(f3); read(f3,Edbidx);closefile(f3);
   assignfile(f4,'sys\4.0\index.ed2');reset(f4); read(f4,Ewlidx);closefile(f4);


   verdir := tverdir.Create(self);
   tema := ttema.Create(self);
   dset := TDset.Create(self);

   tcf.TTS := TTTS.Create(self);
   DCS1 := TDCS1.Create(self);

   application.Title:=form1.Caption;
   monier := true;
   apte1 := true;
   botlink := true;
   mani := true;
c := 0;

//  MyResStream:= TResourceStream.Create(hInstance,'MANGAL' , RT_RCDATA);
//  MyResStream.SaveToFile('Mangal.ttf');
//  MyResStream.SaveToFile('Chandas.ttf');

   depo := tdepo.Create(self);
   dc := tdc.Create(self);
   resform := Tresform.Create(self);
   resform.Hide;;



  d[1].deva := 'a';
  d[1].itr4v:='а';
  d[1].beg:= 1;
  d[1].ed:=24709;
  d[1].lipi:='अ';
  d[1].Sd:='';
  d[1].itr:='a';
  d[1].lng:= 1;
  d[1].snd:='a.wav';
  d[1].itr2:='a';
  d[1].itr3:='а';
  d[1].slp1:='a';
  d[1].itrhk:= 'a';


  d[2].deva := 'ā';
  d[2].itr4v:='а';
  d[2].beg:=  24710;
  d[2].ed:= 30756;
  d[2].lipi:='आ';
  d[2].Sd:='ा';
  d[2].itr:='A';
  d[2].lng:= 2;
  d[2].snd:='a1.wav';
  d[2].itr2:='aa';
  d[2].itr3:='А';
  d[2].slp1:='A';
  d[2].itrhk:= 'A';

  d[3].deva := 'i';
  d[3].itr4v:='и';
  d[3].beg:=  30757;
  d[3].ed:= 26737;
  d[3].lipi:='इ';
  d[3].Sd:='ि';
  d[3].itr:='i';
  d[3].lng:= 1;
  d[3].snd:='i.wav';
  d[3].itr2:='i';
  d[3].itr3:='и';
  d[3].slp1:='i';
  d[3].itrhk:= 'i';

  d[4].deva := 'ī';
  d[4].itr4v:='и';
  d[4].beg:= 26738;
  d[4].ed:= 26999;
  d[4].lipi:='ई';
  d[4].Sd:='ी';
  d[4].itr:='I';
  d[4].lng:= 2;
  d[4].snd:='ii.wav';
  d[4].itr2:='ii';
  d[4].itr3:='И';
  d[4].slp1:='I';
  d[4].itrhk:= 'I';

  d[5].deva := 'u';
  d[5].itr4v:='у';
  d[5].beg := 27000;
  d[5].ed:= 33138;
  d[5].lipi:='उ';
  d[5].Sd:='ु';
  d[5].itr:='u';
  d[5].lng:= 1;
  d[5].snd:='u.wav';
  d[5].itr2:='u';
  d[5].itr3:='у';
  d[5].slp1:='u';
  d[5].itrhk:= 'u';

  d[6].deva := 'ū';
  d[6].itr4v:='у';
  d[6].beg:= 33139;
  d[6].ed:= 33535;
  d[6].lipi:='ऊ';
  d[6].Sd:='ू';
  d[6].itr:='U';
  d[6].lng:= 2;
  d[6].snd:='u2.wav';
  d[6].itr2:='uu';
  d[6].itr3:='У';
  d[6].slp1:='U';
  d[6].itrhk:= 'U';

  d[11].deva := 'e';
  d[11].itr4v:='е';
  d[11].beg:=  34127;
  d[11].ed:= 34976;
  d[11].lipi:='ए';
  d[11].Sd:='े';
  d[11].itr:='e';
  d[11].lng:= 2;
  d[11].snd:='e.wav';
  d[11].itr2:='e';
  d[11].itr3:='е';
  d[11].slp1:='e';
  d[11].itrhk:= 'e';

  d[12].deva := 'o';
  d[12].itr4v:='о';
  d[12].beg:=  34977;
  d[12].ed:= 35178;
  d[12].lipi:='ओ';
  d[12].Sd:='ो';
  d[12].itr:='o';
  d[12].lng:= 2;
  d[12].snd:='o.wav';
  d[12].itr2:='o';
  d[12].itr3:='о';
  d[12].slp1:='o';
  d[12].itrhk:= 'o';

  d[13].deva := 'ai';
  d[13].itr4v:='ай';
  d[13].beg:=  35179;
  d[13].ed:= 35462;
  d[13].lipi:='ऐ';
  d[13].Sd:='ै';
  d[13].itr:='ai';
  d[13].lng:= 2;
  d[13].snd:='ai.wav';
  d[13].itr2:='ai';
  d[13].itr3:='аи';
  d[13].slp1:='E';
  d[13].itrhk:= 'ai';

  d[14].deva := 'au';
  d[14].itr4v:='ау';
  d[14].beg  :=  35463;
  d[14].ed   := 35972;
  d[14].lipi:='औ';
  d[14].Sd:='ौ';
  d[14].itr:='au';
  d[14].lng:= 2;
  d[14].snd:='au.wav';
  d[14].itr2:='au';
  d[14].itr3:='ау';
  d[14].slp1:='O';
  d[14].itrhk:= 'au';

  d[7].deva := 'ṛ';
  d[7].itr4v:='ри';
  d[7].beg  :=  33536;
  d[7].ed   := 34117;
  d[7].lipi:='ऋ';
  d[7].Sd:='ृ';
  d[7].itr:='R^i';
  d[7].lng:= 1;
  d[7].snd:='r1.wav';
  d[7].itr2:='R';
  d[7].itr3:='Р';
  d[7].slp1:='f';
  d[7].itrhk:= 'R';

  d[8].deva := 'ṝ';
  d[8].itr4v:='ри';
  d[8].beg  :=  34118;
  d[8].ed   := 34119;
  d[8].lipi:='ॠ';
  d[8].Sd:='ॄ';
  d[8].itr:='R^I';
  d[8].lng:= 2;
  d[8].snd:='r2.wav';
  d[8].itr2:='RR';
  d[8].itr3:='Ъ';
  d[8].slp1:='F';
  d[8].itrhk:= 'RR';

  d[9].deva := 'ḷ';
  d[9].itr4v:='ли';
  d[9].beg  :=  34120;
  d[9].ed   := 34125;
  d[9].lipi:='ऌ';
  d[9].Sd:='ॢ';
  d[9].itr:='L^i';
  d[9].lng:= 1;
  d[9].snd:='l1.wav';
  d[9].itr2:='LR';
  d[9].itr3:='лР';
  d[9].slp1:='x';
  d[9].itrhk:= 'lR';


  d[10].deva := 'ḹ';
  d[10].itr4v:='ли';
  d[10].beg  :=  34126;
  d[10].ed   := 34126;
  d[10].lipi:='ॡ';
  d[10].Sd:='ॣ';
  d[10].itr:='L^I';
  d[10].lng:= 2;
  d[10].snd:='l2.wav';
  d[10].itr2:='LRR';
  d[10].itr3:='лЪ';
  d[10].slp1:='X';
  d[10].itrhk:= 'lRR';

  d[15].deva := 'k';
  d[15].itr4v:='к';
  d[15].beg  :=  35976;
  d[15].ed   := 50413;
  d[15].lipi:='क';
  d[15].Sd:='';
  d[15].itr:='k';
  d[15].lng:= 0.25;
  d[15].snd:='ka.wav';
  d[15].itr2:='k';
  d[15].itr3:='к';
  d[15].slp1:='k';
  d[15].itrhk:= 'k';

  d[16].deva := 'kh';
  d[16].itr4v:='кх';
  d[16].beg  :=  50414;
  d[16].ed   := 51592;
  d[16].lipi:='ख';
  d[16].itr:='kh';
  d[16].lng:= 0.5;
  d[16].snd:='kha.wav';
  d[16].itr2:='kh';
  d[16].itr3:='кх';
  d[16].slp1:='K';
  d[16].itrhk:= 'kh';

  d[17].deva := 'g';
  d[17].itr4v:='г';
  d[17].beg  :=  51593;
  d[17].ed   := 56817;
  d[17].lipi:='ग';
  d[17].itr:='g';
  d[17].lng:= 0.25;
  d[17].snd:='ga.wav';
  d[17].itr2:='g';
  d[17].itr3:='г';
  d[17].slp1:='g';
  d[17].itrhk:= 'g';

  d[18].deva := 'gh';
  d[18].itr4v:='гх';
  d[18].beg  :=  56818;
  d[18].ed   := 57623;
  d[18].lipi:='घ';
  d[18].itr:='gh';
  d[18].lng:= 0.5;
  d[18].snd:='gha.wav';
  d[18].itr2:='gh';
  d[18].itr3:='гх';
  d[18].slp1:='G';
  d[18].itrhk:= 'gh';

  d[19].deva := 'ṅ';
  d[19].itr4v:='н';
  d[19].beg  := 57624;
  d[19].ed   := 57628;
  d[19].lipi:='ङ';
  d[19].itr:='~N';
  d[19].lng:= 0.25;
  d[19].snd:='nga.wav';
  d[19].itr2:='G';
  d[19].itr3:='Г';
  d[19].slp1:='N';
  d[19].itrhk:= 'G';

  d[25].deva := 'ṭ';
  d[25].itr4v:='т';
  d[25].beg  := 57629;
  d[25].ed   := 57776;
  d[25].lipi:='ट';
  d[25].itr:='T';
  d[25].lng:= 0.25;
  d[25].snd:='ta1.wav';
  d[25].itr2:='T';
  d[25].itr3:='Т';
  d[25].slp1:='w';
  d[25].itrhk:= 'T';


  d[26].deva := 'ṭh';
  d[26].itr4v:='тх';
  d[26].beg  := 57777;
  d[26].ed   := 57797;
  d[26].lipi:='ठ';
  d[26].itr:='Th';
  d[26].lng:= 0.5;
  d[26].snd:='tha1.wav';
  d[26].itr2:='Th';
  d[26].itr3:='Тх';
  d[26].slp1:='W';
  d[26].itrhk:= 'Th';


  d[27].deva := 'ḍ';
  d[27].itr4v:='д';
  d[27].beg  := 57798;
  d[27].ed   := 57963;
  d[27].lipi:='ड';
  d[27].itr:='D';
  d[27].lng:= 0.25;
  d[27].snd:='da1.wav';
  d[27].itr2:='D';
  d[27].itr3:='Д';
  d[27].slp1:='q';
  d[27].itrhk:= 'D';

  d[28].deva := 'ḍh';
  d[28].itr4v:='дх';
  d[28].beg  := 57964;
  d[28].ed   := 58004;
  d[28].lipi:='ढ';
  d[28].itr:='Dh';
  d[28].lng:= 0.5;
  d[28].snd:='dha1.wav';
  d[28].itr2:='Dh';
  d[28].itr3:='Дх';
  d[28].slp1:='Q';
  d[28].itrhk:= 'Dh';


  d[29].deva := 'ṇ';
  d[29].itr4v:='н';
  d[29].beg  := 58005;
  d[29].ed   := 58016;
  d[29].lipi:='ण';
  d[29].itr:='N';
  d[29].lng:= 0.25;
  d[29].snd:='na.wav';
  d[29].itr2:='N';
  d[29].itr3:='Н';
  d[29].slp1:='R';
  d[29].itrhk:= 'N';

  d[20].deva := 'c';
  d[20].itr4v:='ч';
  d[20].beg  := 58017;
  d[20].ed   := 61956;
  d[20].lipi:='च';
  d[20].itr:='c';
  d[20].lng:= 0.25;
  d[20].snd:='ca.wav';
  d[20].itr2:='c';
  d[20].itr3:='ч';
  d[20].slp1:='c';
  d[20].itrhk:= 'c';

  d[21].deva := 'ch';
  d[21].itr4v:='чх';
  d[21].beg  := 61957;
  d[21].ed   := 62537;
  d[21].lipi:='छ';
  d[21].itr:='Ch';
  d[21].lng:= 0.5;
  d[21].snd:='cha.wav';
  d[21].itr2:='ch';
  d[21].itr3:='чх';
  d[21].slp1:='C';
  d[21].itrhk:= 'ch';

  d[22].deva := 'j';
  d[22].itr4v:='дж';
  d[2].beg  := 62538;
  d[22].ed   := 66186;
  d[22].lipi:='ज';
  d[22].itr:='j';
  d[22].lng:= 0.25;
  d[22].snd:='ja.wav';
  d[22].itr2:='j';
  d[22].itr3:='Ж';
  d[22].slp1:='j';
  d[22].itrhk:= 'j';

  d[23].deva := 'jh';
  d[23].itr4v:='джх';
  d[23].beg  := 66187;
  d[23].ed   := 66390;
  d[23].lipi:='झ';
  d[23].itr:='jh';
  d[23].lng:= 0.5;
  d[23].snd:='jha.wav';
  d[23].itr2:='jh';
  d[23].itr3:='Жх';
  d[23].slp1:='J';
  d[23].itrhk:= 'jh';

  d[24].deva := 'ñ';
  d[24].itr4v:='н';
  d[24].beg  := 66391;
  d[24].ed   := 66393;
  d[24].lipi:='ञ';
  d[24].itr:='~n';
  d[24].lng:= 0.25;
  d[24].snd:='~na.wav';
  d[24].itr2:='J';
  d[24].itr3:='Ь';
  d[24].slp1:='Y';
  d[24].itrhk:= 'J';

  d[30].deva := 't';
  d[30].itr4v:='т';
  d[30].beg  := 66394;
  d[30].ed   := 72283;
  d[30].lipi:='त';
  d[30].itr:='t';
  d[30].lng:= 0.25;
  d[30].snd:='ta.wav';
  d[30].itr2:='t';
  d[30].itr3:='т';
  d[30].slp1:='t';
  d[30].itrhk:= 't';

  d[31].deva := 'th';
  d[31].itr4v:='тх';
  d[31].beg  := 72284;
  d[31].ed   := 72313;
  d[31].lipi:='थ';
  d[31].itr:='th';
  d[31].lng:= 0.5;
  d[31].snd:='tha.wav';
  d[31].itr2:='th';
  d[31].itr3:='тх';
  d[31].slp1:='T';
  d[31].itrhk:= 'th';

  d[32].deva := 'd';
  d[32].itr4v:='д';
  d[32].beg  := 72314;
  d[32].ed   := 80441;
  d[32].lipi:='द';
  d[32].itr:='d';
  d[32].lng:= 0.25;
  d[32].snd:='da.wav';
  d[32].itr2:='d';
  d[32].itr3:='д';
  d[32].slp1:='d';
  d[32].itrhk:= 'd';

  d[33].deva := 'dh';
  d[33].itr4v:='дх';
  d[33].beg  := 80442;
  d[33].ed   := 82940;
  d[33].lipi:='ध';
  d[33].itr:='dh';
  d[33].lng:= 0.5;
  d[33].snd:='dha.wav';
  d[33].itr2:='dh';
  d[33].itr3:='дх';
  d[33].slp1:='D';
  d[33].itrhk:= 'dh';

  d[34].deva := 'n';
  d[34].itr4v:='н';
  d[34].beg  := 82941;
  d[34].ed   := 91405;
  d[34].lipi:='न';
  d[34].itr:='n';
  d[34].lng:= 0.25;
  d[34].snd:='n1.wav';
  d[34].itr2:='n';
  d[34].itr3:='н';
  d[34].slp1:='n';
  d[34].itrhk:= 'n';

  d[35].deva := 'p';
  d[35].itr4v:='пх';
  d[35].beg  := 91406;
  d[35].ed   := 113723;
  d[35].lipi:='प';
  d[35].itr:='p';
  d[35].lng:= 0.25;
  d[35].snd:='pa.wav';
  d[35].itr2:='p';
  d[35].itr3:='п';
  d[35].slp1:='p';
  d[35].itrhk:= 'p';

  d[36].deva := 'ph';
  d[36].itr4v:='пх';
  d[36].beg  := 113724;
  d[36].ed   := 114310;
  d[36].lipi:='फ';
  d[36].itr:='ph';
  d[36].lng:= 0.5;
  d[36].snd:='pha.wav';
  d[36].itr2:='ph';
  d[36].itr3:='пх';
  d[36].slp1:='P';
  d[36].itrhk:= 'ph';

  d[37].deva := 'b';
  d[37].itr4v:='б';
  d[37].beg  := 114311;
  d[37].ed   := 118443;
  d[37].lipi:='ब';
  d[37].itr:='b';
  d[37].lng:= 0.25;
  d[37].snd:='ba.wav';
  d[37].itr2:='b';
  d[37].itr3:='б';
  d[37].slp1:='b';
  d[37].itrhk:= 'b';

  d[38].deva := 'bh';
  d[38].itr4v:='бх';
  d[38].beg  := 118444;
  d[38].ed   := 123231;
  d[38].lipi:='भ';
  d[38].itr:='bh';
  d[38].lng:= 0.5;
  d[38].snd:='bha.wav';
  d[38].itr2:='bh';
  d[38].itr3:='бх';
  d[38].slp1:='B';
  d[38].itrhk:= 'bh';

  d[39].deva := 'm';
  d[39].itr4v:='м';
  d[39].beg  := 123232;
  d[39].ed   := 134759;
  d[39].lipi:='म';
  d[39].itr:='m';
  d[39].lng:= 0.25;
  d[39].snd:='ma.wav';
  d[39].itr2:='m';
  d[39].itr3:='м';
  d[39].slp1:='m';
  d[39].itrhk:= 'm';

  d[40].deva := 'y';
  d[40].itr4v:='й';
  d[40].beg  := 134760;
  d[40].ed   := 138155;
  d[40].lipi:='य';
  d[40].itr:='y';
  d[40].lng:= 0.25;
  d[40].snd:='ya.wav';
  d[40].itr2:='y';
  d[40].itr3:='й';
  d[40].slp1:='y';
  d[40].itrhk:= 'y';

  d[41].deva := 'r';
  d[41].itr4v:='р';
  d[41].beg  := 138156;
  d[41].ed   := 143517;
  d[41].lipi:='र';
  d[41].itr:='r';
  d[41].lng:= 0.25;
  d[41].snd:='ra.wav';
  d[41].itr2:='r';
  d[41].itr3:='р';
  d[41].slp1:='r';
  d[41].itrhk:= 'r';

  d[42].deva := 'l';
  d[42].itr4v:='л';
  d[42].beg  := 143518;
  d[42].ed   := 146484;
  d[42].lipi:='ल';
  d[42].itr:='l';
  d[42].lng:= 0.25;
  d[42].snd:='la.wav';
  d[42].itr2:='l';
  d[42].itr3:='л';
  d[42].slp1:='l';
  d[42].itrhk:= 'l';

  d[43].deva := 'v';
  d[43].itr4v:='в';
  d[43].beg  := 146485;
  d[43].ed   := 165477;
  d[43].lipi:='व';
  d[43].itr:='v';
  d[43].lng:= 0.25;
  d[43].snd:='va.wav';
  d[43].itr2:='v';
  d[43].itr3:='в';
  d[43].slp1:='v';
  d[43].itrhk:= 'v';

  d[44].deva := 'ṣ';
  d[44].itr4v:='ш';
  d[44].beg  := 165478;
  d[44].ed   := 166063;
  d[44].lipi:='ष';
  d[44].itr:='S';
  d[44].lng:= 0.25;
  d[44].snd:='sh.wav';
  d[44].itr2:='Sh';
  d[44].itr3:='Ш';
  d[44].slp1:='z';
  d[44].itrhk:= 'z';

  d[45].deva := 'ś';
  d[45].itr4v:='ш';
  d[45].beg  := 166064;
  d[45].ed   := 176545;
  d[45].lipi:='श';
  d[45].itr:='sh';
  d[45].lng:= 0.25;
  d[45].snd:='sha.wav';
  d[45].itr2:='z';
  d[45].itr3:='ш';
  d[45].slp1:='S';
  d[45].itrhk:= 'S';

  d[46].deva := 's';
  d[46].itr4v:='с';
  d[46].beg  := 176546;
  d[46].ed   := 201633;
  d[46].lipi:='स';
  d[46].itr:='s';
  d[46].lng:= 0.25;
  d[46].snd:='sa.wav';
  d[46].itr2:='s';
  d[46].itr3:='с';
  d[46].slp1:='s';
  d[46].itrhk:= 's';

  d[47].deva := 'h';
  d[47].itr4v := 'х';
  d[47].beg  := 201634;
  d[47].ed   := 205626;
  d[47].lipi:='ह';
  d[47].itr:='h';
  d[47].lng:= 0.25;
  d[47].snd:='ha.wav';
  d[47].itr2:='h';
  d[47].itr3:='х';
  d[47].slp1:='h';
  d[47].itrhk:= 'h';

  d[48].deva := 'ṁ';
  d[48].itr4v := 'м';
  d[48].beg  := 0;
  d[48].ed   := 0;
  d[48].lipi:='ं';
  d[48].Sd:='ं';;
  d[48].itr:='M';
  d[48].lng:= 0.25;
  d[48].snd:='';
  d[48].itr3:='М';
  d[48].slp1:='M';
  d[48].itrhk:= 'M';

  d[49].deva := 'ḥ';
  d[49].itr4v := 'х';
  d[49].Sd:='ः';
  d[49].beg  := 0;
  d[49].ed   := 0;
  d[49].lipi:='ः';
  d[49].itr:='H';
  d[49].lng:= 0.25;
  d[49].snd:='';
  d[49].itr3:='Х';
  d[49].slp1:='H';
  d[49].itrhk:= 'H';

  d[50].lipi:='्';
  d[50].deva:='';
  d[50].beg:=0;
  d[50].ed:=0;
  d[50].itr:='';
  d[50].lng:= 0.25;
  d[50].snd:='';
  d[50].slp1:=#0;
  d[50].itrhk:= '';

  d[51].lipi:='ँ';
  d[51].itr4v := 'н';
  d[51].slp1:='M';
  d[51].deva:='m̩';
  d[51].beg:=0;
  d[51].ed:=0;
  d[51].itr:='^M';
  d[51].lng:= 0.25;
  d[51].snd:='';
  d[51].slp1:='M';
  d[51].itrhk:= 'M';

  d[52].lipi:='०';
  d[52].deva:='0';
  d[52].itr:='0';
  d[52].slp1:='0';
  d[52].lng:= 0.25;

  d[53].lipi:='१';
  d[53].deva:='1';
  d[53].itr:='1';
  d[53].slp1:='1';
  d[53].lng:= 0.25;

  d[54].lipi:='२';
  d[54].deva:='2';
  d[54].slp1:='2';
  d[54].itr:='2';
  d[54].lng:= 0.25;

  d[55].lipi:='३';
  d[55].deva:='3';
  d[55].slp1:='3';
  d[55].itr:='3';
  d[55].lng:= 0.25;

  d[56].lipi:='४';
  d[56].deva:='4';
  d[56].itr:='4';
  d[56].slp1:='4';
  d[56].lng:= 0.25;

  d[57].lipi:='५';
  d[57].deva:='5';
  d[57].slp1:='5';
  d[57].itr:='5';
  d[57].lng:= 0.25;

  d[58].lipi:='६';
  d[58].deva:='6';
  d[58].slp1:='6';
  d[58].itr:='6';
  d[58].lng:= 0.25;

  d[59].lipi:='७';
  d[59].deva:='7';
  d[59].slp1:='7';
  d[59].itr:='7';
  d[59].lng:= 0.25;

  d[60].lipi:='८';
  d[60].deva:='8';
  d[60].slp1:='8';
  d[60].itr:='8';
  d[60].lng:= 0.25;

  d[61].lipi:='९';
  d[61].deva:='9';
  d[61].slp1:='9';
  d[61].itr:='9';
  d[61].lng:= 0.25;

  d[62].lipi:='ऽ';
  d[62].deva:='.';
  d[62].itr:='.';
  d[62].lng:= 0.25;

  d[63].lipi:=#32;
  d[63].deva:=#32;
  d[63].itr:=#32;
  d[63].slp1:=#32;
  d[63].lng:= 0.25;

  d[64].lipi:='|';
  d[64].deva:='|';
  d[64].itr:='|';
  d[64].slp1:='|';
  d[64].lng:= 0.25;

  d[65].lipi:='||';
  d[65].deva:='||';
  d[65].itr:='||';
  d[65].itr:='||';
  d[65].slp1:='|';
  d[65].lng:= 0.25;

  d[66].lipi:='ॐ';
  d[66].deva:='O';
  d[66].itr:='OM';
  d[66].slp1:='M';
  d[66].itr3:='ОМ';
  d[66].lng:= 2;

  d[67].lipi:='॑';
  d[67].deva:='';
  d[67].itr:='';
  d[67].lng:= 1;

  d[68].lipi:='॒';
  d[68].deva:='';
  d[68].itr:='';
  d[68].lng:= 1;

  d[69].lipi:='-';//'ꣳ';
  d[69].deva:='-';//'ꣳ';

  d[69].beg:=0;
  d[69].ed:=0;
  d[69].deva:='';
  d[69].itr:='';
  d[69].lng:= 1;

  d[70].lipi:='ळ';
  d[70].deva:='L.';
  d[70].beg:=0;
  d[70].ed:=0;
  d[70].itr:='L.';
  d[70].slp1:='l';
  d[70].lng:=0.25;
  d[70].itr3:='Л';

  d[72].lipi:=')';
  d[72].deva:=')';
  d[72].itr:=')';
  d[72].lng:= 1;

  d[71].lipi:='(';
  d[71].deva:='(';
  d[71].beg:=0;
  d[71].ed:=0;



  d[71].lipi:='';
  d[71].deva:='';
  d[71].beg:=0;
  d[71].ed:=0;

  d[71].itr:='';
  d[71].lng:= 1;

//REINDEX!
  a := 2;
  d[1].beg:=0;
  for a := 1 to 49 do
  begin
   s :='';
   i := 1;
   while i < depo.StringGrid1.RowCount - 1 do
   begin
     if pos(d[a].lipi,depo.StringGrid1.Cells[0,i]) = 1 then
     begin
        d[a].beg:=i;
        while ((pos(d[a].lipi,depo.StringGrid1.Cells[0,i]) = 1) or
              (depo.StringGrid1.Cells[0,i] = '')) do
              begin inc(i);if i = depo.StringGrid1.RowCount-1 then break;end;
        d[a].ed:=i - 1;
     end;
     inc(i)
   end;
//   showmessage(d[a].deva+' '+inttostr(d[a].beg)+' '+inttostr(d[a].ed));
  end;


{  for  i := 1 to depo.stringgrid1.RowCount - 1 do
  if pos(d[a].lipi,depo.stringgrid1.cells[,i]) = 1 then
  begin
     d[a].beg:=  i;
     d[a-1].ed:=i - 1;
     inc(a);
  end;
  d[47].ed:=depo.stringgrid1.RowCount - 1;
}

// EndReindex
//Endglish Dic Init
  dp := tdp.Create(self);
  a := 2;
  ell[1].b:=0;
  for i := 65 to 90 do ell[i - 64].l:=lowercase(chr(i));
  for  i := 1 to dp.ListBox1.Count - 1 do
  if a < 27 then
  if pos(ell[a].l,dp.ListBox1.Items[i]) = 1 then
  begin
     ell[a].b:=  i;
     ell[a-1].e:=i - 1;
     inc(a);

  end;

  ell[26].e:=dp.ListBox1.Count - 1;

//End English dic init

// Reindex alphabet for sorting
   for i := 1 to 10 do da[i] := d[i + 51];
   for i := 11 to 24 do da[i] := d[i-10];
   da[25] := d[66];
   da[26] := d[48];
   da[27] := d[49];
   da[28] := d[51];
   for i := 29 to 61 DO  da[i] := d[i-14];
   for i := 62 to 65 do
   da[i] := d[i];
   for i := 67 to 73 do
   da[i-1] := d[i-1];

// End Reindex alphabet for sorting
//Prepare DLIST
   for i := 1 to length(dlist) do
   dlist[i].en:=true;
   dlist[1].DSign:='#';
   dlist[1].DName:='Monier-Williams, Monier: A Sanskrit-English Dictionary. London : 1899';
   dlist[1].sn:='MW';
   Dlist[1].Dlink:='Total Words: 169589'+#13+#10+'Total Articles: 222389'+#13+#10+
   ' Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 08.09.2017]' + #13+#10+ #13+#10 +
   'LICENSE' + #13+#10 +
   'This file is based on mw_orig_utf8.txt, available at http://sanskrit-lexicon.uni-koeln.de/scans/MWScan/2014/web/webtc/download.html  (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license.  (http://www.sanskrit-lexicon.uni- koeln.de/scans/MWScan/2014/downloads/mwheader.xml) ';
   Speedbutton14.Hint:=dlist[1].DName + #13+#10+dlist[1].DLink;
{_______________________________________}

dlist[2].DSign:='$';
dlist[2].sn:='Apte';
dlist[2].DName:='Apte, Vaman Shivaram: The Practical Sanskrit-English Dictionary. Poona : 1890';
dlist[2].Dlink :=
'Total Words: 31940'+#13+#10+'Total Articles 31940'+
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 08.09.2017]'+#13+#10+#13+#10+
'LICENSE'+
'This file is based on pwg.txt, available at http://www.sanskrit-lexicon.uni-koeln.de/scans/AP90Scan/2014/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/AP90Scan/2014/downloads/ap90header.xml)';
Speedbutton33.Hint:=dlist[2].DName + #13+#10+dlist[2].DLink;
dlist[3].DSign:='^';
dlist[3].sn:='Böhtlingk';
dlist[3].DName:='Böhtlingk und Roth: Großes Petersburger Wörterbuch';
dlist[3].Dlink:=
'Total Words: 125250'+#13+#10+'Total Articles: 125250' +
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 08.09.2017]' +#13+#10+#13+#10+
'LICENSE'+#13+#10+
'This file is based on pwg.txt, available at http://sanskrit-lexicon.uni-koeln.de/scans/PWGScan/2013/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/PWGScan/2013/downloads/pwgheader.xml)';
;
Speedbutton37.Hint:=dlist[3].DName + #13+#10+dlist[3].DLink;

dlist[4].DSign:='+';
dlist[4].sn:='ManiVettam';
dlist[4].DName:='Mani, Vettam: Puranic Encyclopaedia. Delhi 1975';
Dlist[4].Dlink:=
'Total Terms/Articles: 8830' + #13+#10+
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 25.01.2018]' +#13+#10+
'LICENSE'+#13+#10+
'This file is based on pe.txt, available at http://www.sanskrit-lexicon.uni-koeln.de/scans/PEScan/2014/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/PEScan/2014/downloads/peheader.xml)';
Speedbutton42.Hint:=dlist[4].DName + #13+#10+dlist[4].DLink;

dlist[5].DSign:='_';
dlist[5].sn:='Benfey';
dlist[5].DName:='Benfey, Theodor: A Sanskrit-English Dictionary. London : 1866';
dlist[5].Dlink:=
'Total Words/Articles: 26918' + #13+#10+
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 08.09.2017]' +#13+#10+#13+#10+
'LICENSE'+#13+#10+
'This file is based on ben.txt, available at http://www.sanskrit-lexicon.uni-koeln.de/scans/BENScan/2014/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/BENScan/2014/downloads/benheader.xml) ';
Speedbutton19.Hint:=dlist[5].DName + #13+#10+dlist[5].DLink;

dlist[6].DSign:='-';
dlist[6].sn:='Cappeller';
dlist[6].DName:='Cappeller, Carl: A Sanskrit-English Dictionary, based upon the St. Petersburg Lexicons. Strassburg : 1891';
dlist[6].Dlink:=
'Total Words/Articles: 40250' + #13+#10+
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 28.07.2017]' +#13+#10+#13+#10+
'LICENSE' + #13+#10+
'This file is based on cae.txt, available at http://sanskrit-lexicon.uni-koeln.de/scans/CAEScan/2014/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ .Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/CAEScan/2014/downloads/caeheader.xml) ';
Speedbutton30.Hint:=dlist[6].DName + #13+#10+dlist[6].DLink;

dlist[7].DSign:='%';
dlist[7].sn:='McDonell';
dlist[7].DName:='Macdonell, Arthur Anthony: A Sanskrit-English Dictionary. London : 1893';
dlist[7].Dlink:='Total Words/Articles: 20100' + #13+#10+
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 08.09.2017]' +#13+#10+
'LICENSE'+#13+#10+
'This file is based on md.txt, available at http://sanskrit-lexicon.uni-koeln.de/scans/MDScan/2014/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/MDScan/2014/downloads/mdheader.xml) ';
Speedbutton31.Hint:=dlist[7].DName + #13+#10+dlist[7].DLink;

dlist[8].DSign:='|';
dlist[8].sn:='Śabdakalpadruma';
dlist[8].DName:='Rādhākāntadeva: Śabdakalpadruma (5 Vol). Third edition, reprint of the 1886 edition. Varanasi : 1967';
Dlist[8].Dlink:='Total Articles: 42310' +#13+#10+
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 08.09.2017]' + #13+#10+#13+#10+
'LICENSE'#13+#10+
'This file is based on skd.txt, available at http://sanskrit-lexicon.uni-koeln.de/scans/SKDScan/2013/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/SKDScan/2013/downloads/skdheader.xml) ';
Speedbutton36.Hint:=dlist[8].DName + #13+#10+dlist[8].DLink;

dlist[9].DSign:='&';
dlist[9].sn:='Vācaspatyam';
dlist[9].DName:='Bhaṭṭācārya: Vācaspatyam (6 Vol). Chaukhamba Sanskrit Series 94, reprint of the 1873-1884 edition. Varanasi : 1962';
Dlist[9].Dlink:='Total Articles: > 47 000' +#13+#10+
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 08.09.2017]' + #13+#10 +#13+#10 +
'LICENSE'#13+#10 +
'This file is based on vcp.txt, available at http://www.sanskrit-lexicon.uni-koeln.de/scans/VCPScan/2013/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/VCPScan/2013/downloads/vcpheader.xml)';
Speedbutton43.Hint:=dlist[9].DName + #13+#10+dlist[9].DLink;

dlist[11].DSign:='2';
dlist[11].sn:='Borooah (ES)';
dlist[11].DName:='Borooah, Anundoram: English-Sanskrit Dictionary. Guwahati, Assam : 1971 (= Calcutta : 1877)';
dlist[11].Dlink:='Total Words/Articles: 11604' + #13+#10+
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 09.02.2018]' + #13+#10+#13+#10+
'LICENSE'+#13+#10+
'This file is based on bor.txt, available at http://www.sanskrit-lexicon.uni-koeln.de/scans/BORScan/2014/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/BORScan/2014/downloads/borheader.xml) ';
Speedbutton40.Hint:=dlist[11].DName + #13+#10+dlist[11].DLink;

dlist[12].DSign:='3';
dlist[12].sn:='MW (ES)';
dlist[12].DName:='Monier-Williams, Monier: A Dictionary. English and Sanskrit. Delhi : 2005 (= London : 1851)';
dlist[12].Dlink := 'Total Words/Articles: 23092' + #13+#10+
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 08.02.2018]' + #13+#10+ #13+#10+
'LICENSE'+ #13+#10+
'This file is based on mwe.txt, available at http://www.sanskrit-lexicon.uni-koeln.de/scans/MWEScan/2013/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/MWEScan/2013/downloads/mweheader.xml) ';
Speedbutton35.Hint:=dlist[12].DName + #13+#10+dlist[12].DLink;

dlist[10].DSign:='1';
dlist[10].sn:='Apte (ES)';
dlist[10].DName:='Apte, Vaman Shivram: The Student''s English-Sanskrit Dictionary. Delhi : 1964';
dlist[10].Dlink:='Total Words/Articles: 35291' + #13+#10+
'Input by Cologne Digital Sanskrit Lexicon (CDSL) [GRETIL-Version vom 08.09.2017]' + #13+#10;// +
//'LICENSE'+ #13+#10 +
//'This file is based on pwg.txt, available at http://www.sanskrit-lexicon.uni-koeln.de/scans/AP90Scan/2014/web/webtc/download.html (C) Copyright 2014 The Sanskrit Library and Thomas Malten under the following license: All rights reserved other than those granted under the Creative Commons Attribution Non-Commercial Share Alike license available in full at http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode, and summarized at http://creativecommons.org/licenses/by-nc-sa/3.0/ . Permission is granted to build upon this work non-commercially, as long as credit is explicitly acknowledged exactly as described herein and derivative work is distributed under the same license. (http://www.sanskrit-lexicon.uni-koeln.de/scans/AP90Scan/2014/downloads/ap90header.xml) ';
Speedbutton41.Hint:=dlist[10].DName + #13+#10+dlist[10].DLink;

dlist[13].DSign:='w';
dlist[13].sn:='Wilson';
dlist[13].DName:='Н.Н. Wilson: A Dictionary in Sanskrit and English, 2nd ed., Calcutta 1832';
dlist[13].Dlink:='Total Words: 43190' + #13+#10+
'Total Articles: 44910' + #13+#10+
'Electronic version based on file '+#13+#10+
'Н.Н. Wilson, A Dictionary in Sanskrit and English, 2nd ed., Calcutta 1832.pdf'+#13+#10+
'(BAYARISCHESTAATSBIBLIOTHEK '+#13+#10
+ 'münchener digitalisierungszentrum'+#13+#10 +
'https://www.digitale-sammlungen.de/)';
dlist[13].DDesc:='';
Speedbutton32.Hint:=dlist[13].DName + #13+#10+dlist[13].DLink;

Dlist[14].DName:='Электронный словарь к монографии: "В.И. Тихвинский, Ю.М. Густяков, संस्कृतं, Совершенство(Санскрит), интернет-издание, издание 4-е исправленное и дополненное, 02-02-2022"';
dlist[14].sn:='Тихвинский';
Dlist[14].DSign:='T';
Dlist[14].DDesc:='';
Dlist[14].en:=True;
Dlist[14].dlink:='Словарь используется с разрешения автора. Оригинал словаря можно посмотреть здесь:'+#13+#10+
'3419 слов';
Speedbutton34.Hint:=dlist[14].DName + #13+#10+dlist[14].DLink;

Dlist[15].DName:='В.А. Кочергина: Санскритско-Русский учебный словарь.';
dlist[15].SN  :='Кочергина (Std)';
Dlist[15].DSign:='k';
Dlist[15].DDesc:='';
Dlist[15].en:=True;
Dlist[15].dlink:='https://yadi.sk/d/R5CQS-dpxdLb1g?fbclid=IwAR0jRc4CFJpsEFIfC_ra-gWUhPEqH-llEGvNPXCHaHIfzEVEIpSd0sGLrbQ';
Speedbutton38.Hint:=dlist[15].DName + #13+#10+dlist[15].DLink;

Dlist[16].DName:='Лихушина Н.П.: "САНСКРИТСКО-РУССКИЙ УЧЕБНЫЙ СЛОВАРЬ. Около  6000 слов. Составитель Н.П. Лихушина. Версия 10.1 от 30.01.2020"';
Dlist[16].DSign:='L';
dlist[16].sn := 'Лихушина';
Dlist[16].DDesc:='';
Dlist[16].en:=True;
Dlist[16].dlink:='Словарь используется с разрешения автора. Оригинал словаря можно посмотреть здесь:'+#13+#10+
'https://yadi.sk/d/R5CQS-dpxdLb1g?fbclid=IwAR0jRc4CFJpsEFIfC_ra-gWUhPEqH-llEGvNPXCHaHIfzEVEIpSd0sGLrbQ';
Speedbutton39.Hint:=dlist[16].DName + #13+#10+dlist[16].DLink;

Dlist[17].DName:='The Digital Corpus of Sanskrit''s dictionary: Dusseldorf 2021';
Dlist[17].DSign:='=';
dlist[17].sn:='DCS.';
Dlist[17].DDesc:='';
dlist[17].DLink:='http://www.sanskrit-linguistics.org/dcs/' + #13+#10+
'Total Words/Articles:  163295';
Dlist[17].en:=True;
Speedbutton44.Hint:=dlist[17].DName + #13+#10+dlist[17].DLink;

Dlist[18].DName:='The User''s Dictionary';
Dlist[18].DSign:='U';
Dlist[18].DDesc:='';
Dlist[18].en:=True;


dset.checklistbox1.Items.Clear;
dset.checklistbox2.Items.Clear;


for i := 1 to 9 do
begin
  dset.checklistbox1.Items.Add(dlist[i].DName);
  dset.checklistbox1.Checked[i-1] := true;
end;
for i := 13 to length(dlist) do
begin
dset.checklistbox1.Items.Add(dlist[i].DName);
dset.checklistbox1.Checked[i - 4] := true;

end;
for i := 10 to 12 do
begin
  dset.checklistbox2.Items.Add(dlist[i].DName);
  dset.checklistbox2.Checked[i-10] := true;
end;
//End Dlist Prepare

//stringgrid1.SelectedColor:=$323232;
  panel6.Height:=(screen.Height - 200) div 2;
  memo1.Font.Color:=clblack;//form1.Color;
  edit2.Font.Color:=clblack;//form1.Color;
  stringgrid1.Columns[0].Font.Color:=clblack;//form1.Color;
  stringgrid1.Columns[1].Font.Color:=clblack;//form1.Color;
  stringgrid1.Columns[2].Font.Color:=clblack;//form1.Color;
  stringgrid1.Columns[3].Font.Color:=clblack;//form1.Color;
////

//  stringgrid1.RowCount:= depo.stringgrid1.RowCount;
  SpeedButton7Click(Sender);
  cnt1 := 0;
//  combobox3.ItemIndex:=0;
//  combobox3change(sender);
  if x229 <> 0 then
  StatusBarx2.Panels[1].Text:= lp.StringGrid1.Cells[x229,232] + ' '+
  inttostr(stringgrid1.RowCount - 1);


  cdir := getcurrentdir;
  LDIr := CDIR + '\lib\';
  HDIR := CDIR + '\help\';
  SDIR := ldir + 'snd\';

  a := 0;A1 := '';
  sgw;
  for i := 1 to form1.stringgrid1.RowCount - 1 do
  if (stringgrid1.Cells[3,i] <> '') and
       (stringgrid1.Cells[3,i] <> ' ')
    then
    begin
      s := form1.stringgrid1.Cells[3,i];
      while s  <> '' do
      begin
       od[strtoint(copy(s,1,pos(' ',s)-1))] := form1.stringgrid1.Cells[2,i];
       delete(s,1,pos(' ',s));
      end;
    end;
//  shape1.Width:=149;

//  panel6.Height:=(form1.Height - panel2.Height) div 2;
  if fileexists('sys\wps.dig') then
  begin
{$i-}
   assignfile(fpw,'sys\wps.dig'); reset(fpw);
   read(fpw,x);
   if ioresult = 0 then
   begin
//      if x[1].sw = 0 then windowstate := wsmaximized else windowstate := wsnormal;
      left := x[1].l;
      top := x[1].t;
//      width := x[1].w;
//      height := x[1].h;

   dcs1.ComboBox1.ItemIndex:=x[1].ct;
   dcs1.ComboBox1Change(sender);

//      DCS!W
      if x[2].sw = 0 then dcs1.windowstate := wsmaximized else dcs1.windowstate := wsnormal;
      dcs1.left := x[2].l;dcs1.top := x[2].t;
      dcs1.width := x[2].w;dcs1.height := x[2].h;
//      showmessage(inttostr(x[2].l));

   end;
{$i+}
   closefile(fpw);
  end;
  stringgrid1.Columns[10].Visible:=false;
  SpeedButton28Click(Sender);
  StatusBarx2.Panels[3].Text := inttostr(stringgrid1.RowCount-1);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if MutexHandle <> 0 then
    CloseHandle(MutexHandle);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  sgw;
//  if left < 0 then left := 0;
//  if top < 0 then top := 0;
begin

end;

  //  stringgrid1.Width:=form1.Width;
//  stringgrid1.Columns[0].Width:= round(form1.Width/2 - 15);
//  stringgrid1.Columns[1].Width:= round(form1.Width/2 - 15);
chp(1);
end;


procedure TForm1.GGL1Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw1.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.google.com/?sl=auto&tl=ru&text='+s+'&op=translate')
  ,nil,nil,1);

end;

procedure TForm1.GTTClick(Sender: TObject);
begin
//  a;slkfjal;sjkfdl;kjsd
end;

procedure TForm1.hw1CClick(Sender: TObject);
begin
  hw1.CopyToClipboard;
end;

procedure TForm1.hw1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
  );
begin
//  caption := hw1.GetCharAtPos(,
//  hw1.DisplayPosToXy(x,y));
end;

procedure TForm1.hw1SAClick(Sender: TObject);
begin
  hw1.SelectAll;
end;



procedure TForm1.Image10Click(Sender: TObject);
begin
  Speedbutton2click(sender);
end;

procedure TForm1.Image10MouseEnter(Sender: TObject);
begin
  label2.Left:=image10.Left;
  label2.Caption := 'Programme Settings';
end;

procedure TForm1.Image10MouseLeave(Sender: TObject);
begin
  label2.Caption:='';
end;

procedure TForm1.Image11Click(Sender: TObject);
begin
  button1click(sender);
  if combobox2.ItemIndex=1 then
  if (pos('ñc',edit2.Text) > 0) or
     (pos('ñj',edit2.Text) > 0) or
     (pos('cñ',edit2.Text) > 0) or
     (pos('jñ',edit2.Text) > 0) then
     begin
      stringgrid1.SortColRow(true,0);
     end;
end;

procedure TForm1.Image11MouseEnter(Sender: TObject);
begin

end;

procedure TForm1.Image11MouseLeave(Sender: TObject);
begin

end;

procedure TForm1.Image1Click(Sender: TObject);
begin
//  SpeedButton10Click(Sender);
end;



procedure TForm1.Image1MouseLeave(Sender: TObject);
begin
    label2.Caption:='';;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  Speedbutton7click(sender);
  edit2.SetFocus;
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;



procedure TForm1.Image2MouseLeave(Sender: TObject);
begin
  label2.Caption:='';
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
  shellexecute(0,'open','http://www.sanskrit-linguistics.org/dcs/',nil,nil,1);

end;



procedure TForm1.Image3MouseLeave(Sender: TObject);
begin
    label2.Caption:='';
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
  if form7.WindowState = wsminimized then form7.WindowState:=wsnormal;;
  form7.Show;
  form7.BringToFront;
  vstat.A[13].CName:=image4.Hint;
  inc(vstat.A[13].c);
  form7.CheckListBox1.Font := form1.Font;

end;



procedure TForm1.Image4MouseLeave(Sender: TObject);
begin
  label2.Caption:='';
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
    Speedbutton1click(sender);
    vstat.A[12].CName:=image5.Hint;
    inc(vstat.A[12].c);

end;



procedure TForm1.Image5MouseLeave(Sender: TObject);
begin
   label2.Caption:='';
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
   popupmenu7.PopUp;
   vstat.A[9].CName:=image6.Hint;
   inc(vstat.A[9].c);

end;



procedure TForm1.Image6MouseLeave(Sender: TObject);
begin
    label2.Caption:='';
end;

procedure TForm1.Image7Click(Sender: TObject);
begin
    Speedbutton3click(sender);
    vstat.A[11].CName:=image7.Hint;
    inc(vstat.A[11].c);

end;



procedure TForm1.Image7MouseLeave(Sender: TObject);
begin
  label2.Caption:='';
end;

procedure TForm1.Image8Click(Sender: TObject);
begin
  Speedbutton5click(sender);
  vstat.A[10].CName:=image8.Hint;
  inc(vstat.A[10].c);
  if tema.WindowState=wsminimized then
  tema.WindowState:=wsnormal;
  tema.BringToFront;
end;



procedure TForm1.Image8MouseLeave(Sender: TObject);
begin
    label2.Caption:='';
end;

procedure TForm1.Image9Click(Sender: TObject);
begin
  Speedbutton8click(sender);
end;


procedure TForm1.Image9MouseLeave(Sender: TObject);
begin
    label2.Caption:='';
end;

procedure TForm1.krlClick(Sender: TObject);
begin
  checkbox6.Checked:=true;
  speedbutton48click(sender);
  kr.show;
  kr.left := form1.Left + stringgrid1.Columns[0].Width+
             stringgrid1.Columns[1].Width + 50;

  kr.Height:=form1.Height div 2;
  kr.Top:=form1.Top + 96;
end;

procedure TForm1.krlMouseEnter(Sender: TObject);
begin
  krl.Transparent := false;
end;

procedure TForm1.krlMouseLeave(Sender: TObject);
begin
   krl.Transparent := true;
end;

procedure TForm1.Label10Click(Sender: TObject);
begin

end;

procedure TForm1.Label11Click(Sender: TObject);
begin

end;

procedure TForm1.Label12Click(Sender: TObject);
begin

end;

procedure TForm1.Label13Click(Sender: TObject);
begin

end;

procedure TForm1.Label14Click(Sender: TObject);
begin
  checkbox7.Checked:=not(checkbox7.Checked);
end;

procedure TForm1.Label15Click(Sender: TObject);
begin
  shellexecute(0,'open','http://gretil.sub.uni-goettingen.de/','',nil,1)
end;

procedure TForm1.Label17Click(Sender: TObject);
begin

end;

procedure TForm1.Label3Click(Sender: TObject);
begin
  if length(sps.p1) > 0 then
  begin
    label3.Caption:='1/'+inttostr(length(sps.p1));
    sps.p2:=1;
    spp2click(sender);
  end;
end;

procedure TForm1.Label4Click(Sender: TObject);
begin
   checkbox6.Checked:=not(checkbox6.Checked);
end;




procedure TForm1.Label5Click(Sender: TObject);
begin
  tema := TTema.Create(self);
  tema.Show;
end;

procedure TForm1.Label6Click(Sender: TObject);
begin
    shellexecute(0,'open','http://gretil.sub.uni-goettingen.de/gretil.html','',nil,1)
end;

procedure TForm1.Label7Click(Sender: TObject);
begin
   image3click(sender);
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var   T : Trect;
begin
   T.Left:=0;
   t.Right:=1;
   t.Bottom:=stringgrid1.RowCount-1;
   t.Top:=1;
   stringgrid1.Selection := T;
end;

procedure TForm1.ListBox2Click(Sender: TObject);
begin

end;

procedure TForm1.Memo1Change(Sender: TObject);
var c,i : byte;
begin c := 0;

  Fi := 0;
  fip:= 0;
  sif := memo1.Text;
 for i := 1 to length(dlist) do
 if dlist[i].ddesc <> '' then inc(c);
 StatusBarx2.Panels[5].Text:=inttostr(c);
 hw1.LoadFromString(memo1.lines.text);
 hw1.DefFontName :=  memo1.Font.Name;
 hw1.DefFontSize:=memo1.Font.Size;
end;

procedure TForm1.Memo1Click(Sender: TObject);
begin


end;

procedure TForm1.Memo1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var
    iCharIndex, iLineIndex, iCharOffset, i, j: Integer;
    Pt: TPoint;
    s,Result: string;
begin
{    with Tmemo(Sender) do
    begin
      Pt := Point(X, Y);

      // Get Character Index from word under the cursor
      iCharIndex := Perform(Messages.EM_CHARFROMPOS, 0, Integer(@Pt));
      if iCharIndex < 0 then Exit;
      // Get line Index
      iLineIndex  := Perform(EM_EXLINEFROMCHAR, 0, iCharIndex);
      iCharOffset := iCharIndex - Perform(EM_LINEINDEX, iLineIndex, 0);
      if Lines.Count - 1 < iLineIndex then Exit;
      // store the current line in a variable
      s := Lines[iLineIndex];
      // Search the beginning of the word
      i := iCharOffset + 1;

      RESULT := s;
      Edit3.Text := inttostr(iCharindex) + result;
    end;

}
end;

procedure TForm1.MenuItem100Click(Sender: TObject);
begin
  SpeedButton8Click(Sender);
end;

procedure TForm1.MenuItem101Click(Sender: TObject);
begin
  Speedbutton5Click(Sender);
end;


procedure TForm1.MenuItem102Click(Sender: TObject);
begin
     MenuItem8Click(Sender);
end;

procedure TForm1.MenuItem103Click(Sender: TObject);
begin
   MenuItem7Click(Sender);
end;

procedure TForm1.MenuItem104Click(Sender: TObject);
begin
     MenuItem9Click(Sender);
end;

procedure TForm1.MenuItem105Click(Sender: TObject);
begin
   MenuItem24Click(Sender);
end;

procedure TForm1.MenuItem106Click(Sender: TObject);
begin
  MenuItem5Click(Sender);
end;

procedure TForm1.MenuItem108Click(Sender: TObject);
begin
 MenuItem13Click(Sender);
end;

procedure TForm1.MenuItem109Click(Sender: TObject);
begin
  MenuItem14Click(Sender);
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
begin
  GetN('6.',true);
end;

procedure TForm1.MenuItem110Click(Sender: TObject);
begin
   MenuItem15Click(Sender);
end;

procedure TForm1.MenuItem111Click(Sender: TObject);
begin
     MenuItem16Click(Sender);
end;

procedure TForm1.MenuItem112Click(Sender: TObject);
begin
     MenuItem17Click(Sender);
end;

procedure TForm1.MenuItem113Click(Sender: TObject);
begin
     MenuItem18Click(Sender);
end;

procedure TForm1.MenuItem114Click(Sender: TObject);
begin
     MenuItem19Click(Sender);
end;

procedure TForm1.MenuItem115Click(Sender: TObject);
begin
     MenuItem20Click(Sender);
end;

procedure TForm1.MenuItem116Click(Sender: TObject);
begin
     MenuItem21Click(Sender);
end;

procedure TForm1.MenuItem117Click(Sender: TObject);
begin
     MenuItem22Click(Sender);
end;

procedure TForm1.MenuItem118Click(Sender: TObject);
begin
  MenuItem25Click(Sender);
end;

procedure TForm1.MenuItem119Click(Sender: TObject);
begin
   GetN('adv.',true);
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
begin
  speedbutton21click(sender);
end;

procedure TForm1.MenuItem120Click(Sender: TObject);
begin
   MenuItem23Click(sender);
end;

procedure TForm1.MenuItem121Click(Sender: TObject);
begin
   MenuItem26Click(sender);
end;

procedure TForm1.MenuItem122Click(Sender: TObject);
begin
  MenuItem10Click(Sender);
end;

procedure TForm1.MenuItem123Click(Sender: TObject);
begin
  Speedbutton26click(sender);
end;

procedure TForm1.MenuItem124Click(Sender: TObject);
begin
  GetN('Partic.',false);
end;

procedure TForm1.MenuItem125Click(Sender: TObject);
begin
  Speedbutton3click(sender);
end;

procedure TForm1.MenuItem126Click(Sender: TObject);
begin
    SpeedButton45Click(Sender);
end;

procedure TForm1.MenuItem127Click(Sender: TObject);
begin
  ShellExecute(0,'open','https://sanskrit.inria.fr/DICO/grammar.html','',nil,1);
end;

procedure TForm1.MenuItem128Click(Sender: TObject);
begin
    Speedbutton27Click(Sender);
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  GetN('7.',true);
end;




procedure TForm1.MenuItem130Click(Sender: TObject);
var i,j : dword;
    f : text; s : string;
    a : byte; z : boolean;
begin
  if opendialog1.Execute then
  begin
    assignfile(f,opendialog1.FileName+'_.txt');
    rewrite(f);
    progressbar1.Show;
    memo2.WordWrap:=false;
    memo2.Lines.LoadFromFile(opendialog1.FileName);
    progressbar1.Max:=memo2.Lines.Count;
    progressbar1.Step:=progressbar1.Max div 10;;
    for i := 0 to memo2.Lines.Count - 1 do
    if memo2.Lines.Strings[i] <> '' then
    begin
     s := convertx(getconv(memo2.Lines.Strings[i]));
     writeln(f,s);
     a := getletid(s); z := false;
     if a in [1..51] then
     for j := d[a].beg to d[a].ed do
     if depo.StringGrid1.Cells[1,j] = s then
     begin
       z := true;
       break;
     end;
     if z then
     begin
       filldlist(j);
       writeln(f,printdl1);
      end else writeln(f,'Not found');

     progressbar1.Position:=i;

    end;
    memo1.Show;
    progressbar1.Hide;
    closefile(f);
    if checkbox7.Checked then
    shellexecute(0,'Open',pchar(opendialog1.FileName+'_.txt'),'',nil,1)
  end;
end;

procedure TForm1.MenuItem131Click(Sender: TObject);
begin
    Speedbutton29Click(Sender);
end;

procedure TForm1.MenuItem132Click(Sender: TObject);
begin
  MenuItem66Click(Sender);
end;

procedure TForm1.MenuItem133Click(Sender: TObject);
begin
  Shellexecute(0,'open','https://www.uni-goettingen.de/','',nil,1);
end;


procedure TForm1.MenuItem134Click(Sender: TObject);
begin
  speedbutton45click(sender);
end;

procedure TForm1.MenuItem135Click(Sender: TObject);
type
  lex1 = record
         l : string;
         c : word;
  end;

var i,j,k : longint;
    xx : lex1;
    A  : Array[1..222342] of lex1;
    f : text;
    s,s1,s2 : string;
    d1,d2 : integer;
    Filename : string;
    sint : array of lex1;
    s4 : string;
begin
listbox1.Clear;
    if pos('*',edit2.Text) <> 1 then
    begin
       d1 := -800; d2 := -300; s1:='-800';s2 := '-300';
    end
    else
    begin
      s2 := edit2.Text; delete(s2,1,1);
      s1:= copy(s2,1,pos(';',s2)-1);
      delete(s2,1,pos(';',s2));
      d1 := strtoint(s1); d2 := strtoint(s2);
    end;
    Filename := 'Reports\lexix'+s1+'_'+s2+'.txt';
    system.Assign(f,Filename);
    rewrite(f);
    for i := 1 to length(O) do
    begin
      a[i].c:=0;
      if  o[i].stem <> '' then
        a[i].l:=inttostr(i)//dcs1.getosn(inttostr(i))
      else a[i].l := '';
    end;

    for i := 1 to length(lx)  do
    if lx[i].cid <> '' then
    if cp[strtoint(lx[i].cid)].tid <> '' then
    begin

       j := round(strtoint(cp[strtoint(lx[i].cid)].d1) +
            strtoint(cp[strtoint(lx[i].cid)].d2) / 2);
       if (j <= d2) and (j >= d1) then
       begin
       if pos(tx[strtoint(cp[strtoint(lx[i].cid)].tid)].tn,listbox1.Items.Text) = 0 then
       listbox1.Items.Add(tx[strtoint(cp[strtoint(lx[i].cid)].tid)].tn);
//       writeln(f,tx[strtoint(cp[strtoint(lx[i].cid)].tid)].tn);
       end;
    end;
    listbox1.Items.SaveToFile('Reports\lexis'+s1+'_'+s2+'.txt');
for i := 0 to tts.StringGrid4.RowCount - 1 do
if tts.StringGrid4.Cells[3,i] <> '' then
    if pos(tts.StringGrid4.Cells[0,i],listbox1.Items.Text) > 0 then
    begin
        s := tts.StringGrid4.Cells[3,i];
        if s <> '' then
        begin
           while s <> '' do
           begin
             s1 := copy(s,1,pos(',',s) - 1);
             delete(s,1,pos(',',s));
             if s1 <> '' then
             if strtoint(s1) <= length(a) then
             if (dcs1.GetGr(s1) <> 'ind' ) and
                (dcs1.GetGr(s1) <> 'pron') then
                begin
                  inc(A[strtoint(s1)].c);
                  write(f,',',s1);

                end;
           end;
           writeln(f,',');
        end;

    end;
    for k  := 1 to length(A) do
    for j := 1 to length(A) - 1 do
    begin
      if a[j].c < a[j +1].c then
      begin
        xx := a[j]; a[j] := a[j+1]; a[j+1] := xx;
      end;


    end;
    d2 := 0;
    for k := 1 to length(a) do
        if a[k].c = 0 then break else inc(d2,a[k].c);
    writeln(f,'*',k); d1 := 0;
    listbox1.Clear;
    for j  := 1 to k do
    begin
       inc(d1,a[j].c);
       if d1/d2*100 <= 99.95 then
       listbox1.Items.Add(a[j].l);

    end;
    system.Close(f);
    system.Assign(f,'Reports\dcx.txt');
    rewrite(f);
    d1 := 0;
    for j  := 1 to k do
    begin
       inc(d1,a[j].c);
       if d1/d2*100 <= 99.95 then
       writeln(f,dcs1.getosn(a[j].l),';',dcs1.GetGr(a[j].l),';',a[j].c/d2*100:2:5,'%');

    end;
    system.Close(f);

//    listbox1.Items.SaveToFile('Reports\lexkern1.txt');
system.Assign(f,'Reports\sinta1.txt');
rewrite(f);
//    listbox1.Items.loadfromfile('Reports\lexkern1.txt');
    memo1.WordWrap:=false;
    memo1.Lines.LoadFromFile(filename);
    for j := 0 to listbox1.Items.Count - 1 do
    begin
       for i  := 1 to length(a) do begin a[i].l:=inttostr(i);a[i].c:=0; end;
     for i := 0 to memo1.Lines.Count - 1 do
     begin
       s := memo1.Lines.Strings[i];
       s4 := s;
       s1 := ','+listbox1.Items[j] + ',';
       k := pos(s1,s);
       while k  > 0 do
       begin
         s1 := ','+listbox1.Items[j] + ',';
         k := pos(s1,s4);
         delete(s4,k,length(s1) - 1);
         if k > 0 then
         begin
            s2 := copy(s,1,k-1);
            delete(s,1,k+length(s1)-1);
            s := copy(s,1,pos(',',s) - 1);
            s1 := '';
            for k := length(s2) downto 1 do
            if s2[k] <> ',' then s1 := s2[k] + s1 else break;
            if s <> '' then
            if pos(',',s) = 0 then
            inc(a[strtoint(s)].c);
            if s1 <> '' then
            if pos(',',s1) = 0 then
            inc(a[strtoint(s1)].c);

         end;

       end;
     end;

      setlength(sint,0);
      for k := 1 to length(a) do
      if a[k].c > 0 then
      begin
        setlength(sint,length(sint)+1);
        sint[length(sint) - 1] := a[k];
      end;
      for d1 := 0 to length(sint) - 1 do
      for d2 := 0 to length(sint) - 2 do
      if sint[d2].c < sint[d2 +1].c then
      begin
        xx :=  sint[d2]; sint[d2] := sint[d2 +1]; sint[d2+1] := xx;
      end;
      s := '';  d2 := 0;
      for d1 := 0 to length(sint) - 1 do
      begin
         s := s + dcs1.getosn(sint[d1].l) + ';'+inttostr(sint[d1].c)+';';
         inc(d2,sint[d1].c);
      end;
      s := dcs1.getosn(listbox1.Items[j])+';'+inttostr(d2) +';'+
      inttostr(length(sint)) +';' + s;
      writeln(f,s);
      s := '';
    end;
   system.Close(f);

end;

procedure TForm1.MenuItem136Click(Sender: TObject);
begin
  GetN('Int',true);
end;

procedure TForm1.MenuItem137Click(Sender: TObject);
begin
  dcs1.Show;
end;

procedure TForm1.MenuItem138Click(Sender: TObject);
var f : text;
    s : string;
    i,j,k,l,m : longint;
    A,A1 : Array[1..71] of longint;
begin
    system.Assign(f,'Reports\apx_stat.txt');
    rewrite(f);
    stringgrid1.Col:=1;

    for i := 1 to stringgrid1.RowCount - 1 do
    begin
       k := 0; l := 0;

//       getindexes(strtoint(stringgrid1.Cells[2,i]));
       if listbox1.Items.Count > 0 then
       begin
         for j := 0 to listbox1.Items.Count - 1 do
         if strtoint(listbox1.Items[j]) >= 222391 then
         if strtoint(listbox1.Items[j]) <= 254037 then
         begin
           inc(k);
           s := depo.Memo1.Lines.Strings[strtoint(listbox1.Items[j])-1];
           if pos('||',s) = 0 then l := l +1;
           while pos('||',s) > 0 do
           begin
             inc(l);
             delete(s,pos('||',s),2);
           end;
         end;
         s := stringgrid1.Cells[1,i]+';'+inttostr(k)+';'+inttostr(l);
         if k > 0 then
         writeln(f,s);
       end;

    end;
    system.Close(f);

{
    stringgrid2.LoadFromCSVFile('Reports\bbx.csv',';');
    for i := 1 to 71 do begin A[i] := 0; A1[i] := 0;end;
    k := 0;l := 0;
    for j := 1 to stringgrid2.RowCount - 1 do
    begin inc(k,strtoint(stringgrid2.Cells[2,j]));
          inc(l,strtoint(stringgrid2.Cells[2,j]));
          inc(A[strtoint(stringgrid2.Cells[1,j])]);
          inc(A1[strtoint(stringgrid2.Cells[2,j])]);
    end;
    m := 0;
    system.Assign(f,'Reports\MW0.txt');
    rewrite(f);
    for i := 1 to stringgrid2.RowCount - 1 do
    begin
      inc(m, strtoint(stringgrid2.Cells[2,j]));
      if m/k*100 <=80 then
      writeln(f,stringgrid2.Cells[0,i],';',stringgrid2.Cells[1,i],';',stringgrid2.Cells[2,i])
      else break;
    end;
    writeln(f,k,';',l,';',m);
    system.Close (f);

    system.Assign(f,'Reports\MW1.txt');
    rewrite(f);
    for i := 71 downto 1  do
    begin
       writeln(f,i,';',a[i],';',a1[i])
    end;
    writeln(f,k,';',l,';',m);
    system.Close (f);


}
end;

procedure TForm1.MenuItem139Click(Sender: TObject);
begin
  checkbox6.Checked:=true;
//  speedbutton7click(sender);
  TTS.show;
//  tts.Width:= 750;

//  tts.left := screen.Width - tts.Width;
  tts.Height:=form1.Height div 2;
  tts.Top:=form1.Top + 64;
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
begin
    GetN('8.',true);
end;

procedure TForm1.MenuItem140Click(Sender: TObject);
begin
  stringgrid1.Col:=5;
  stringgrid1Dblclick(sender);
end;

procedure TForm1.MenuItem143Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem144Click(Sender: TObject);
begin
  shellexecute(0,'Open','http://www.sanskrit-linguistics.org/dcs/','',nil,1)
end;

procedure TForm1.MenuItem145Click(Sender: TObject);
begin
   GetN('Desid',true);
end;

procedure TForm1.MenuItem147Click(Sender: TObject);
begin
  Shellexecute(0,'open','https://www.digitale-sammlungen.de','',nil,1);
end;

procedure TForm1.MenuItem148Click(Sender: TObject);
var i : longint;
    f : system.text;
    s,s2 : string;
    j : byte;
begin
    if dcs1.SaveDialog1.Execute then
    begin
       system.Assign(f,dcs1.SaveDialog1.FileName);
       rewrite(f);
       for i := 1 to stringgrid1.RowCount - 1 do
       if stringgrid1.Cells[9,i] <> '' then
       begin
         stringgrid1.Col:=5;
         s := stringgrid1.Cells[1,i] + ';';
         if stringgrid1.Cells[5,i] <> '' then
         begin
           GetExam(stringgrid1.Cells[3,i],0,0,0,0,0);
           if wr.StringGrid1.RowCount > 255 then wr.StringGrid1.RowCount:=255;
           for j := 1 to wr.StringGrid1.RowCount - 1 do
           s := s + wr.stringgrid1.Cells[12,j]+';'+wr.stringgrid1.Cells[10,j];
           writeln(f,s);

         end;

       end;
       system.Close(f);
       Showmessage('DONE! The Result FileName is: '+dcs1.SaveDialog1.FileName + 'Separator: ";"');
    end;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin
      GetN('9.',true);
end;



procedure TForm1.MenuItem155Click(Sender: TObject);
type
  ligs = record
         s : string;
         l : byte;
         Tn: string;
         c : longint;
  end;
var
   lg : ligs;
   s : string;
   i,j,k : longint;
   f : text;
   z : boolean = false;
   f2 : text;
begin
   assignfile(f2,'liga_1.txt');
   rewrite(f2);
   assignfile(f,'liga.txt');
   rewrite(f);
   lg.c:=0;
   for i := 0 to tcf.TTS.StringGrid4.RowCount - 1 do
   begin
      lg.l:=0;lg.s:='';lg.Tn := '';
      s := tts.StringGrid4.Cells[4,i];

      for j := 1 to length(s) do
      begin

        for k := 1 to length(d) do
        if pos(d[k].deva,s) = 1 then
        begin
            z := true;
          delete(s,1,length(d[k].deva));
          if (k in [1..14,48..72])
          then
          begin
            if (lg.s <> '') and (lg.l > 1)  then
            begin
               writeln(f,lg.Tn,';',lg.s,';',lg.l);
            end
            else
               if (lg.s <> '') and (lg.l = 1)  then
               writeln(f2,lg.Tn,';',lg.s,';',lg.l);

            lg.s:='';lg.l:=0;
            break;
          end;

          if k in [15..47] then
          begin

             z := true;
             inc(lg.c);
              lg.s:=lg.s + d[k].deva; inc(lg.l);lg.Tn:=tts.StringGrid4.Cells[0,i];
              if (lg.l > 0) and (pos('h',lg.s) <> 1)
              then if (d[k].deva = 'h') and
              (not(lg.s[length(lg.s) - 1] in ['r','l','v','y','m','n'])) then
              begin
                 dec(lg.l);
                 dec(lg.c);
              end;
            break;
          end;




        end;

      end;

   end;

   writeln(f,lg.c);
   closefile(f);
   closefile(f2);
   showmessage('Done');
end;

procedure TForm1.MenuItem156Click(Sender: TObject);
begin
  Verdir.Show;
  verdir.ComboBox8.ItemIndex:=2;
  roots := troots.Create(self);
  roots.Show;
  roots.Edit1.Text:=stringgrid1.Cells[1,stringgrid1.Row];
  if (roots.ListBox1.Items.Count > 0) and
     (roots.ListBox1.Items[0] = roots.Edit1.Text) then
  begin
     roots.ListBox1.ItemIndex:=0;
     roots.SpeedButton1click(sender);
  end
  else
  begin
     verdir.ComboBox8.ItemIndex:=2;
     verdir.Edit1.Text:= roots.Edit1.Text;
  end;
end;

procedure TForm1.MenuItem157Click(Sender: TObject);
begin
  of1.show;
end;

procedure TForm1.MenuItem158Click(Sender: TObject);
var i,j : dword;c,t : byte; s: string;
begin
  for i := 1 to stringgrid1.RowCount - 1 do
  stringgrid1.Cells[7,i] := '';
{   j := 1;
   for i := 1 to length(xgd2) do
   xgd2[i] := [0];
   for i := 1 to length(xgd2) do
   if stringgrid1.Cells[7,i] <> '' then
   begin
     xgd2[i] := xgd[j]; inc(j);
   end;
   reset(FG);
   for i := 1 to length(xgd2) do write(FG,xgd2[i]);
   closefile(FG);

}
  s :='';{'🌰'};j := 0;
      for i := 1 to stringgrid1.RowCount - 1 do
      if (xgd[i] = []) or (xgd[i] = [0]) then stringgrid1.Cells[7,i] := ''
      else
      begin c := 0; t := 0;
        for j := 4 to 255 do
        begin
           if (j in [1..10]) and
           (j in xgd[i]) then inc(c);
           if (j in [11..255])  and (j in xgd[i])then inc(t);
        end;
        if c > 0 then s := '曆' + inttostr(c);
        if t > 0 then s := s + '📃'+inttostr(t);
        stringgrid1.Cells[7,i] := s;
      end;
//      stringgrid1.SaveToCSVFile('sys\hdrC.csv',#9);

{
for i := 1 to stringgrid1.RowCount-1 do
begin
   stringgrid1.Cells[2,i] := inttostr(i);
   s := convertd(stringgrid1.Cells[1,i]);
   while pos(' ',s) > 0 do delete(s,pos(' ',s),1);
   stringgrid1.Cells[0,i] := s;
end;
}
stringgrid1.SaveToCSVFile('sys\hdr.sdm',#9);

end;

procedure TForm1.MenuItem159Click(Sender: TObject);
begin
  MenuItem136Click(Sender);
end;

procedure TForm1.MenuItem15Click(Sender: TObject);
begin
   GetN('10.',true);
end;

procedure TForm1.MenuItem160Click(Sender: TObject);
begin
  MenuItem145Click(Sender);
end;

procedure TForm1.MenuItem16Click(Sender: TObject);
var i,j  : dword;
    s : string;
begin
  s := '';
  if stringgrid1.RowCount > 1 then
  begin
   for j := 0 to stringgrid1.ColCount - 1 do
   if stringgrid1.Columns[j].Visible then
   s := s + stringgrid1.Columns[j].Title.Caption + #9;
   s := s + #13+#10;

  for i := 1 to stringgrid1.RowCount - 1 do
  if stringgrid1.Cells[9,i] <> '' then
  begin
     for j := 0 to stringgrid1.ColCount - 1 do
     if stringgrid1.Columns[j].Visible then
     s := s + stringgrid1.Cells[j,i] + #9;
     s := s + #13+#10;
  end;

  end;
  if s <> '' then
  Clipboard.AsText:=s
  else
  infx('Copy','There is no data for copying');


end;

procedure TForm1.MenuItem170Click(Sender: TObject);
begin
  GetN('adv.',true);
end;

procedure TForm1.MenuItem17Click(Sender: TObject);
var i,j  : dword;
    s : string;
begin
  s := '';
  i := stringgrid1.Col;
  if stringgrid1.RowCount > 1 then
  for j := 1 to stringgrid1.RowCount - 1 do
  if stringgrid1.Cells[i,j] <> '' then
  s := s + stringgrid1.Cells[i,j] + #13+#10;
  if s <> '' then
  Clipboard.AsText:=s
  else
  infx('Copy','There is no data for copying');


end;

procedure TForm1.MenuItem18Click(Sender: TObject);
begin
    shellexecute(handle,'open','https://disk.yandex.ru/d/aa0uNBHxyWYyTQ',nil,nil,1);
end;

procedure TForm1.MenuItem19Click(Sender: TObject);
begin
  if application.MessageBox('Do you want to download the last version?','Download last version',36) = 6 then
    shellexecute(handle,'open','https://drive.google.com/file/d/1Cl-bcbsPowhFAHcErWhwBubv5U2bzl7G/view?usp=sharing',nil,nil,1);
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
var i : longint;
begin
  memo1.Show;
  memo1.Clear;
  for i := 1 to length(dlist) - 1 do
  memo1.Lines.Add(dlist[i].DName + #13+#10+dlist[i].DLink+#13+#10);
  memo1.SelStart:=0;
//  memo1.SetFocus;
end;

procedure TForm1.MenuItem201Click(Sender: TObject);
var a : longint;
    i : longint;
    x : longint;
    c : longint;
begin
   setlength(car,0);
   c := 0;

   begin
     x := 0;   c := 0;
     progressbar1.show;;
     resform.Memo2.Clear;
     resform.hw.Clear;
     resform.checklistBox1.Clear;
     resform.ListBox1.Clear;
     for i := stringgrid1.Selection.Top to stringgrid1.Selection.Bottom do
     begin
        progressbar1.Position:=round(i/stringgrid1.Selection.Bottom*100);
        a := strtoint(stringgrid1.Cells[2,i]);
//        getindexes(a);
        for x := 1 to listbox1.Items.Count - 1 do
        begin
          s := depo.Memo1.Lines.Strings[strtoint(listbox1.Items[x])];
          s := convertres(s);
          resform.checklistbox1.items.Add(copy(s,1,pos(#13,s) - 1));
          resform.ListBox1.Items.Add(listbox1.Items[x]);
          resform.Memo2.Lines.Add(s);
        end;
        inc(c,x)
     end;
     progressbar1.Position:=round(i/stringgrid1.Selection.Bottom*100);
     resform.Show;
     resform.Memo2.selstart := 0;
     resform.Memo2.SetFocus;
     resform.StatusBar1.Panels[1].Text:= lp.StringGrid1.Cells[x229,232] + ' '+
     inttostr(c);;
     progressbar1.hide;
     resform.FormActivate(sender);
   end;
end;

procedure TForm1.MenuItem20Click(Sender: TObject);
var s: string;
begin
//  s := 'https://translate.google.com/?sl=sa&tl=ru&text=';
//  shellexecute(0,'open',pchar(s),stringgrid1.Cells[0,stringgrid1.Row],nil,1);
   GetN('cl.8',true);
end;

procedure TForm1.MenuItem21Click(Sender: TObject);
var i,j,k,l : dword;z : boolean;
    s : string;
begin
   if opendialog1.Execute then
   begin
    memo2.Lines.LoadFromFile(opendialog1.FileName);

     k :=0;
     setlength(ddl,memo2.Lines.Count);

     if memo2.Lines.Count > 0 then
     begin
       inf1.Memo1.Clear;
       progressbar1.Show;
       progressbar1.Max:=100;

     for i := 0 to memo2.Lines.Count - 1 do
     begin z := false;
       l := getletid(memo2.Lines.Strings[i]);
       progressbar1.Position:=round(i/memo2.Lines.Count*100);
       if l in [1..47] then
      for j := d[l].beg to d[l].ed do
       if (memo2.Lines.Strings[i] = depo.StringGrid1.Cells[0,j]) or
          (memo2.Lines.Strings[i] = depo.StringGrid1.Cells[1,j]) then
          begin
          z := true;
             filldlist(j);
             dlist[1].ID:=j; dlist[1].wd:=memo2.Lines.Strings[i] ;
             ddl[k] := dlist;
             inc(k);
             break;
          end;
          if z = false then
          begin
            s := GetGF1(memo2.Lines.Strings[i]);
            if s = '' then
            s := GetF2(memo2.Lines.Strings[i]);
            if s = '' then
            begin
            if pos('ti ',memo2.Lines.Strings[i]+' ') > 0 then
               s := '--'+memo2.Lines.Strings[i]+#13+#10 else
            s := '-'+memo2.Lines.Strings[i]+#13+#10

            end
            else s := '+'+memo2.Lines.Strings[i]+#9+s;
            inf1.Memo1.text := inf1.Memo1.text + s
          end;
     end;
     setlength(ddl,k);;
     speedbutton27click(sender);
     if inf1.Memo1.Text <> '' then
     begin

        inf1.Show;
     end;
   end
     else infx('List translation','The file is empty');
   end;
   progressbar1.Hide;
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
begin
   GetN('cl.10',true);
end;

procedure TForm1.MenuItem23Click(Sender: TObject);
begin
  GetN('ind.',true);
end;

procedure TForm1.MenuItem24Click(Sender: TObject);
begin
   GetN('adj',true);
end;

procedure TForm1.MenuItem25Click(Sender: TObject);
begin
     GetN('pron.',true);
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
begin
   GetN('ind.',true);
end;

procedure TForm1.MenuItem27Click(Sender: TObject);
begin
   MenuItem31Click(Sender);
end;

procedure TForm1.MenuItem28Click(Sender: TObject);
begin
   SpeedButton7Click(Sender);
end;

procedure TForm1.MenuItem29Click(Sender: TObject);
begin
  tz.Show;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
//  form11 := tform11.Create(self);
  form11.Show;

  vstat.A[25].CName:='THX';
  inc(vstat.A[25].c);

end;

procedure TForm1.MenuItem30Click(Sender: TObject);
begin
  if nn.WindowState=wsminimized then
  nn.WindowState:=wsnormal;
  NN.show;
  nn.BringToFront;
  nn.combobox1change(sender);
  nn.combobox2change(sender);
end;

procedure TForm1.MenuItem31Click(Sender: TObject);
begin
  if ver1.vr.WindowState = wsminimized then
     ver1.vr.WindowState:=wsnormal;
  ver1.vr.Show;
  ver1.vr.BringToFront;
end;

procedure TForm1.MenuItem32Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem33Click(Sender: TObject);
begin

end;


procedure TForm1.MenuItem38Click(Sender: TObject);
begin
  symba.MenuItem1Click(Sender);
end;

procedure TForm1.MenuItem39Click(Sender: TObject);
begin
  symba.MenuItem3Click(Sender);
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  frs.FR.Show;
end;


procedure TForm1.MenuItem40Click(Sender: TObject);
begin
  symba.MenuItem2Click(Sender);
end;

procedure TForm1.MenuItem41Click(Sender: TObject);
begin
  symba.MenuItem4Click(Sender);
end;



procedure TForm1.MenuItem43Click(Sender: TObject);
var a : byte;
begin
  rdr.FormCreate(sender);
  rdr.Label4.Caption:='Click "Play" to start reading..';
  rdr.Label5.Caption:='';
  rdr.Label4.Font.Color:=$FF128A;
  rdr.Label5.Font.Color:=$FF128A;







  rdr.Label7.font.Color := 128;
  rdr.Label8.Font.Color := 128;

//  rdr.Label7.Font := rdr.Label4.Font;
//  rdr.Label8.Font := rdr.Label5.Font;





  rdr.AlphaBlendValue:=0;
  rdr.show;
  rdr.Left:=0;
  rdr.Top:=0;
  rdr.Width:=screen.Width;
  rdr.Height:=screen.Height;
  rdr.timer1.enabled := true;
//  rdr.label4click(sender);
end;


procedure TForm1.MenuItem45Click(Sender: TObject);
begin
  dc.Show;
end;

procedure TForm1.MenuItem46Click(Sender: TObject);
begin
  MenuItem43Click(sender);
end;

procedure TForm1.MenuItem48Click(Sender: TObject);
begin
    speedbutton38click(sender);
end;

procedure TForm1.MenuItem49Click(Sender: TObject);
begin
    speedbutton31click(sender);
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
   speedbutton18click(sender);
end;

procedure TForm1.MenuItem50Click(Sender: TObject);
begin
    speedbutton39click(sender);
end;

procedure TForm1.MenuItem52Click(Sender: TObject);
begin
      speedbutton29click(sender);
end;

procedure TForm1.MenuItem53Click(Sender: TObject);
begin
  memo1.SelLength:=length(memo1.Text) - memo1.SelStart - 1;
end;

procedure TForm1.MenuItem54Click(Sender: TObject);
var x : longint;
begin
    x := memo1.SelStart;
    memo1.SelStart:=0;
    memo1.SelLength:=x;
end;

procedure TForm1.MenuItem55Click(Sender: TObject);
begin
     speedbutton33click(sender);
end;

procedure TForm1.MenuItem56Click(Sender: TObject);
begin
   GetN('pron.',true);
end;



procedure TForm1.MenuItem58Click(Sender: TObject);
begin
  if form4.WindowState = wsminimized then
  form4.WindowState:=wsnormal;;
  form4.Show;
  form4.BringToFront;
  form4.StringGrid2.SelectedColor:=stringgrid1.SelectedColor;
  form4.Edit1Change(sender);;
end;

procedure TForm1.MenuItem59Click(Sender: TObject);
begin
  if form3.WindowState=wsminimized then
  form3.WindowState:=wsnormal;;
  form3.Show;
  form3.BringToFront;
  form3.StringGrid1.SelectedColor:=stringgrid1.SelectedColor;
  form3.StringGrid2.SelectedColor:=stringgrid1.SelectedColor;
  if form3.Edit1.Text = '' then form3.Edit1Change(sender);
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
    GetN('1.',true);
end;

procedure TForm1.MenuItem60Click(Sender: TObject);
begin
  GetN('*n',false);
end;

procedure TForm1.MenuItem61Click(Sender: TObject);
var i : dword;
begin
if stringgrid1.RowCount > 1 then
begin
   for i := stringgrid1.Row to stringgrid1.rowcount - 1 do
   stringgrid1.Cells[9,i] := speedbutton21.Caption;
   SelCnt;
 end;
end;

procedure TForm1.MenuItem62Click(Sender: TObject);
var i : dword;
begin
if stringgrid1.RowCount > 1 then
begin
   for i := stringgrid1.Row downto 1 do
   stringgrid1.Cells[9,i] := speedbutton21.Caption;
   SelCnt;
 end;
end;

procedure TForm1.MenuItem63Click(Sender: TObject);
begin
  GetN('f.',true);
end;

procedure TForm1.MenuItem64Click(Sender: TObject);
var i,j : dword; f: text; s,s1 : string; z : boolean; k : byte;
begin  assignfile(f,'sys\syn\sm\soren.csv');reset(f);
       j := 0;Setlength(ddl,10258);
       while not(eof(f)) do
       begin
        readln(f,s);
        s1 := copy(s,1,pos(#9,s)-1);delete(s,1,pos(#9,s));
        i := strtoint(s);
        if i <> 0 then
        filldlist(i)
        else
          for k := 1 to length(dlist) do
          begin dlist[k].DDesc:='';dlist[k].df:=0;end;
        dlist[1].ID:=i;
        dlist[1].wd:=s1;
        ddl[j] := dlist;
        inc(j);


       end;
       speedbutton27click(sender);
       Resform.Caption:='The list of mythological names created by Sorensen';
       closefile(f);
       infx('The Sorenson''''s list','Note: Some words of the list doesn''''t have dictionary''''s entries.');
end;



procedure TForm1.MenuItem65Click(Sender: TObject);
begin
   fr.Show;
   fr.ComboBox1.ItemIndex:=3;
   fr.Edit2.Text := stringgrid1.Cells[1,stringgrid1.row];
   fr.Edit2Change(sender);
   if fr.StringGrid2.RowCount=1 then
   begin
      fr.Edit1.Text:=fr.Edit2.Text;
      fr.SpeedButton1click(sender);
   end;
end;

procedure TForm1.MenuItem66Click(Sender: TObject);
var i : longint;
    j : longint;
begin   j := strtoint(StatusBarx2.Panels[3].text);
if j + tz.StringGrid1.RowCount > repolim then
showmessage(
'Too many words adding to repository. You can add '+
inttostr(repolim - tz.StringGrid1.RowCount)+
' words only.')
else
if stringgrid1.RowCount > 1 then
begin   tz.stringgrid1.RowCount  := tz.stringgrid1.RowCount +j;
        j := tz.stringgrid1.RowCount - j;
  for i := 1 to stringgrid1.RowCount - 1 do
  if stringgrid1.Cells[9,i] = speedbutton21.Caption then
  begin
    tz.StringGrid1.cells[0,j] := stringgrid1.Cells[1,i];
    tz.StringGrid1.cells[1,j] := stringgrid1.Cells[2,i];
    if combobox3.ItemIndex = 0 then
    tz.StringGrid1.cells[4,j] := 'S' else tz.StringGrid1.cells[4,j] := 'E';
    tz.StringGrid1.cells[3,j] :='';tz.StringGrid1.cells[5,j] :='';
    tz.StringGrid1.cells[2,j] :=datetostr(Date)+ ' '+ timetostr(time);
    inc(j);
  end;
  infx('Repository',
  StatusBarx2.panels[3].Text+' Word(s) added. '+#13+#10 +
  'Total words in the repository: '+
  inttostr(tz.StringGrid1.RowCount - 1));
end;
end;
procedure TForm1.MenuItem67Click(Sender: TObject);
begin
   shellexecute(0,'Open',pchar(CDIR+'\html\MW.html'),'',nil,1);
end;

procedure TForm1.MenuItem68Click(Sender: TObject);
var i : byte;
begin
  tt.Show;
  tt.StringGrid1.RowCount:=73;
  for i := 1 to 72 do
  begin
    tt.StringGrid1.Cells[0,i] := d[i].Lipi;
    tt.StringGrid1.Cells[1,i] := d[i].deva;
    tt.StringGrid1.Cells[2,i] := d[i].itr;
    tt.StringGrid1.Cells[3,i] := d[i].itr2;
    tt.StringGrid1.Cells[4,i] := d[i].itr3;
    tt.StringGrid1.Cells[5,i] := d[i].slp1;
    tt.StringGrid1.Cells[6,i] := d[i].itrhk;


  end;
end;


procedure TForm1.MenuItem691Click(Sender: TObject);
type
  nrec = array[1..8] of string;
  gr = array[1..3] of nrec;
  pr = array[1..3] of gr;

var i,j,k,l,m : dword;
    rc,ac,rmc,mc : word;
    rs,ast,rms,ms : string;
    f,Fp : system.text;
    prs,prs1 : pr;
    dd4 : word;
    sss,op2,lxid : string;
    q,mc3,mc6,r1,r2,r3 : longint;
    sNum,TNum : longint;
    Ec,Fc : longint;
    rnd : integer;
    xf14 : dword; xf15:boolean;
    xd : dword;
begin
randomize;
    Ec := 0; Fc := 0;xd:=0;
if dcs1.SaveDialog1.Execute then
begin
application.Minimize;
   system.Assign(f,dcs1.SaveDialog1.FileName);
   system.Assign(fp,dcs1.SaveDialog1.FileName+'.txt');
   memo1.Lines.LoadFromFile('sys\works\pron.txt');
   rewrite(f);
 rewrite(fp);
   for dd4 := 0 to memo1.Lines.Count - 1 do
   begin
      xf15 := false;
      for xf14 := 1 to length(o) do
      if (o[xf14].gr = 'pron') and
         (o[xf14].stem = memo1.Lines.Strings[dd4]) then
      begin xf15 := true;break;end;


   if xf15 then
   begin
       GetExam(inttostr(xf14)+' ',0,0,0,0,0);
       wr.Hide;
       Ec := wr.stringgrid1.RowCount - 1;  inc(xd,ec);
         writeln(fp,memo1.Lines.Strings[dd4],';',EC,';');
         Writeln(fp,'m.;sg.;du.;pl;f.;sg.;du.;pl;n.;sg.;du.;pl;');
         writeln(f,memo1.Lines.Strings[dd4],';',EC,';');
         Writeln(f,'m.;sg.;du.;pl;f.;sg.;du.;pl;n.;sg.;du.;pl;');
          for l := 1 to 3 do
          for j := 1 to 8 do
          for k := 1 to 3 do    prs1[l,k,j] :='';

          for l := 1 to 3 do
          for j := 1 to 8 do
          for k := 1 to 3 do
          begin
            GetExam(inttostr(xf14)+' ',0,0,j,k,l);
            wr.Hide;
            Fc := wr.StringGrid1.RowCount-1;
            if wr.StringGrid1.RowCount > 1 then
              str(fc/Ec*100:3:2,prs1[l,k,j]);
         end;
     end;


   for k := 1 to 8 do
     begin
       write(fp,wr.GetCase(inttostr(k)),';');
       write(f,wr.GetCase(inttostr(k)),';');
       for l := 1 to 3 do
       begin
          for j := 1 to 3 do
          begin
            if prs1[l,j,k] = '' then prs1[l,j,k]   := '0';
            write(fp,prs1[l,j,k],';');
            write(f,Fc/Ec*100:2:2,';');

          end;
          write(fp,';'); writeln(f);
       end;
       writeln(fp,''); writeln(f);
     end;
     caption := inttostr(dd4);
  end;

   writeln(fp,xd);
   system.Close(f);
   system.Close(fp);
   Showmessage('DONE! The Result FileName is: '+dcs1.SaveDialog1.FileName + 'Separator: ";"');

end;
end;

procedure TForm1.MenuItem69Click(Sender: TObject);
begin
  GetN('n.',true);
end;
procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  GetN('2.',true);
end;

procedure TForm1.MenuItem70Click(Sender: TObject);
begin
  GetN('verb.',true);
end;

procedure TForm1.MenuItem71Click(Sender: TObject);
begin
hlp.Show;


end;

procedure TForm1.MenuItem72Click(Sender: TObject);
begin
  vf2.ids:=stringgrid1.Cells[3,stringgrid1.Row];
  vf2.VForms.Caption := 'Grammar forms examples for: "'+stringgrid1.Cells[1,stringgrid1.Row] + '"';
  vforms.Show;
  if vforms.ComboBox4.Items.Count > 0 then
     vforms.ComboBox4.ItemIndex:=
     vforms.ComboBox4.Items.Count - 1;
//     showmessage(vforms.ListBox1.Items.Text);
//  vforms.pagecontrol1.TabIndex:=1;
end;

procedure TForm1.MenuItem73Click(Sender: TObject);
begin

end;


procedure TForm1.MenuItem74Click(Sender: TObject);
begin
  GetN('int.',true);
end;

procedure TForm1.MenuItem75Click(Sender: TObject);
begin
  GetN('desid.',true);
end;

procedure TForm1.MenuItem76Click(Sender: TObject);
begin
   GetN('denom.',true);
end;

procedure TForm1.MenuItem77Click(Sender: TObject);
begin
   Speedbutton21Click(Sender);
end;

procedure TForm1.MenuItem78Click(Sender: TObject);
begin
  MenuItem61Click(Sender);
end;

procedure TForm1.MenuItem79Click(Sender: TObject);
begin
  MenuItem62Click(Sender);
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  GetN('3.',false);
end;

procedure TForm1.MenuItem80Click(Sender: TObject);
begin
  of1.Show;
end;

procedure TForm1.MenuItem81Click(Sender: TObject);
begin
   parals.prl.Show;
end;

procedure TForm1.MenuItem82Click(Sender: TObject);
begin
   kkn := tkkn.Create(self);
   kkn.Show;
   kkn.ComboBox1Change(sender);
   kkn.StringGrid1.SelectedColor:=stringgrid1.SelectedColor;
end;


procedure TForm1.MenuItem84Click(Sender: TObject);
begin
  Speedbutton22Click(Sender);
end;

procedure TForm1.MenuItem85Click(Sender: TObject);
begin
Speedbutton26Click(Sender);
end;

procedure TForm1.MenuItem87Click(Sender: TObject);
begin
   SpeedButton6Click(Sender);
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  GetN('4.',false);
end;

procedure TForm1.MenuItem90Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem91Click(Sender: TObject);
begin
  Dc.Show;
end;

procedure TForm1.MenuItem93Click(Sender: TObject);
begin
  Speedbutton9click(Sender);
end;

procedure TForm1.MenuItem96Click(Sender: TObject);
begin
  parals.prl.Show;
end;

procedure TForm1.MenuItem98Click(Sender: TObject);
var f,f1 : system.TextFile;
    s,s1,s2,s3,s4 : string;
    i,j,k : word;
    T : array[1..400] of string;
    T2: array[1..400] of word;
begin
  checkbox6.Checked:=true;
  system.Assign(f,'Input\1000v.txt');
  system.Assign(f1,'Input\1000vRes.txt');
  reset(f);rewrite(f1);
  while not(eof(f)) do
  begin
    s1 := '';s2 := '';
    for i := 1 to length(T) do begin T[i] := ''; t2[i] := 0; end;
    readln(f,s);
    s3 := s;
    while pos(' ',s) > 0  do delete(s,pos(' ',s),1);
    s := s + ' ';
    if pos('ḥ ',s) > 0 then delete(s,pos('ḥ ',s),length('ḥ '));
    while pos(' ',s)>0 do delete(s,pos(' ',s),1);
    edit2.Text:=s;
    if stringgrid1.RowCount > 1 then
    if stringgrid1.Cells[7,1] = '1' then
    begin
      getexam(stringgrid1.Cells[3,1],0,0,0,0,0);
      if wr.StringGrid1.RowCount > 1 then
      begin

         for i := 1 to wr.stringgrid1.RowCount - 1 do
         for j:= 0 to dcs1.ComboBox1.Items.Count - 1 do
         if pos(dcs1.ComboBox1.Items[j],wr.StringGrid1.Cells[12,i]) = 1   then
         begin
           inc(t2[j]);
//           s2 := rk.Alit(wr.stringgrid1.Cells[12,i]);
//           t[j] := t[j] + s2 +', ';
             t[j] := dcs1.ComboBox1.Items[j];
         end;
      end;
    end;
    s1 := '';
    for i := 1 to length(t2) do
    for j := 1 to length(t2) - 1 do
    if t2[j] < t2[j+1] then
    begin
       k  := t2[j]; t2[j] := t2[j+1];t2[j+1]:=k;
       s4 := t[j]; t[j] := t[j+1];t[j+1] := s4;
    end;

    s1 := '';
    k := 0; i := 0;
    for j := 1 to length(T) do
    if t[j] <> '' then
    begin
       s1 :=  s1 + t[j]+';'+inttostr(t2[j])+';';
       inc(k,t2[j]);inc(i);
    end;
//       s1 := s1 + dcs1.ComboBox1.items[j] +
//       {'('+copy(t[j],1,length(t[j])-2)+')}' [' + inttostr(t2[j])+'], ';
//       s1  := copy(s1,1,length(s1) - 2);
    writeln(f1,s3,';',s,';',i,';',k,';',s1);
  end;
  system.close(f);
  system.close(f1);
  showmessage('Dene');
end;

procedure TForm1.MenuItem99Click(Sender: TObject);
begin
  SpeedButton2Click(Sender);
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
    GetN('5.',false);
end;

procedure TForm1.N2Click(Sender: TObject);
var i : longint;
    j : longint;
begin  j := 1;
if 1 + tz.StringGrid1.RowCount > repolim then
showmessage(
'Too many words adding to repository. You can add '+
inttostr(repolim - tz.StringGrid1.RowCount)+
' words only.')
else
if stringgrid1.RowCount > 1 then
begin   tz.stringgrid1.RowCount  := tz.stringgrid1.RowCount +j;
        j := tz.stringgrid1.RowCount - j;
  i := stringgrid1.Row;
  begin
    tz.StringGrid1.cells[0,j] := stringgrid1.Cells[1,i];
    tz.StringGrid1.cells[1,j] := stringgrid1.Cells[2,i];
    if combobox3.ItemIndex = 0 then
    tz.StringGrid1.cells[4,j] := 'S' else tz.StringGrid1.cells[4,j] := 'E';
    tz.StringGrid1.cells[3,j] :='';tz.StringGrid1.cells[5,j] :='';
    tz.StringGrid1.cells[2,j] :=datetostr(Date)+ ' '+ timetostr(time);
  end;
  infx('Repository',
  '1 Word added. '+#13+#10 +
  'Total words in the repository: '+
  inttostr(tz.StringGrid1.RowCount - 1));
end;


end;

procedure TForm1.NCC1Click(Sender: TObject);
begin
  shellexecute(0,'open','sys\works\ctree.xls',nil,nil,1);
end;

procedure TForm1.NCC1MouseEnter(Sender: TObject);
begin
  ncc1.Transparent:=false;
end;

procedure TForm1.NCC1MouseLeave(Sender: TObject);
begin
  ncc1.Transparent:=true;
end;

procedure TForm1.NCCClick(Sender: TObject);
begin
  if NCCX then
  begin
     if fileexists('n433.exe') then
     winexec('n433.exe'+' r224',1) else
  end
  else
  shellexecute(handle,'open','https://ncc.sanskritdictionary.com/',nil,nil,1);
  vstat.A[24].CName:=NCC.Caption;
  inc(vstat.A[24].c);

end;

procedure TForm1.NCCMouseEnter(Sender: TObject);
begin
  NCC.Transparent:=false;
end;

procedure TForm1.NCCMouseLeave(Sender: TObject);
begin
  NCC.Transparent:=true;
end;

procedure TForm1.NounMClick(Sender: TObject);
begin
  GetN('m.',true);
end;

procedure TForm1.OResClick(Sender: TObject);
begin
  form9.catalog(2);
  form9.Show;
end;

procedure TForm1.OResMouseEnter(Sender: TObject);
begin
  ORes.Transparent:=false;
end;

procedure TForm1.OResMouseLeave(Sender: TObject);
begin
  ORes.Transparent:=true;
end;

procedure TForm1.Panel18Click(Sender: TObject);
begin
end;

procedure TForm1.Panel23Click(Sender: TObject);
begin

end;



procedure TForm1.Panel2MouseEnter(Sender: TObject);
begin
  label2.BringToFront;
end;

procedure TForm1.Panel30Click(Sender: TObject);
begin

end;

procedure TForm1.Panel31Click(Sender: TObject);
begin

end;

procedure TForm1.Panel45Click(Sender: TObject);
begin

end;

procedure TForm1.Panel46Click(Sender: TObject);
begin

end;

procedure TForm1.Panel48Click(Sender: TObject);
begin
  image3click(sender);
end;

procedure TForm1.Panel48MouseEnter(Sender: TObject);
begin
  panel48.Color:=pcolor;
end;

procedure TForm1.Panel48MouseLeave(Sender: TObject);
begin
  panel48.Color:= panel56.Color;
end;

procedure TForm1.Panel49MouseEnter(Sender: TObject);
begin
  panel49.Color:=pcolor;
end;

procedure TForm1.Panel49MouseLeave(Sender: TObject);
begin
  panel49.Color:= panel56.Color;
end;

procedure TForm1.Panel50MouseEnter(Sender: TObject);
begin
  panel50.Color:=pcolor;
end;

procedure TForm1.Panel50MouseLeave(Sender: TObject);
begin
  panel50.Color:= panel56.Color;
end;

procedure TForm1.Panel51MouseEnter(Sender: TObject);
begin
  panel51.Color:=pcolor;
end;

procedure TForm1.Panel51MouseLeave(Sender: TObject);
begin
  panel51.Color:= panel56.Color;
end;

procedure TForm1.Panel52MouseEnter(Sender: TObject);
begin
  panel52.Color:=pcolor;
end;

procedure TForm1.Panel52MouseLeave(Sender: TObject);
begin
  panel52.Color:= panel56.Color;
end;

procedure TForm1.Panel53MouseEnter(Sender: TObject);
begin
  panel53.Color:=pcolor;
end;

procedure TForm1.Panel53MouseLeave(Sender: TObject);
begin
  panel53.Color:= panel56.Color;
end;

procedure TForm1.Panel54MouseEnter(Sender: TObject);
begin
  panel54.Color:=pcolor;
end;

procedure TForm1.Panel54MouseLeave(Sender: TObject);
begin
  panel54.Color:= panel56.Color;
end;

procedure TForm1.Panel55MouseEnter(Sender: TObject);
begin
  panel55.Color:=pcolor;
end;

procedure TForm1.Panel55MouseLeave(Sender: TObject);
begin
  panel55.Color:= panel56.Color;
end;

procedure TForm1.Panel56Click(Sender: TObject);
begin

end;

procedure TForm1.Panel57MouseEnter(Sender: TObject);
begin
  panel57.Color:=pcolor;
end;

procedure TForm1.Panel57MouseLeave(Sender: TObject);
begin
  panel57.Color:= panel56.Color;
end;

procedure TForm1.Panel5DockDrop(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer);
begin

end;

procedure TForm1.Panel9Click(Sender: TObject);
begin

end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  if combobox3.Itemindex = 1  then popupmenu1.Close;
end;

procedure TForm1.PN1Close(Sender: TObject;
  var CloseAction: TCloseAction);
begin

end;

procedure TForm1.SBClearClick(Sender: TObject);
begin
//  Edit2.Clear;
  if combobox3.ItemIndex=0 then
     combobox3.ItemIndex := 1 else
     combobox3.ItemIndex := 0;
     sbclear.Caption:=combobox3.ItemsEx[combobox3.ItemIndex].Caption;
     combobox3change(sender);

end;

procedure TForm1.SBClearMouseEnter(Sender: TObject);
begin
  SBClear.Transparent:=false;
end;

procedure TForm1.SBClearMouseLeave(Sender: TObject);
begin
  SBClear.Transparent:=true;
end;

procedure TForm1.SdownClick(Sender: TObject);
begin
  panel6.Height:=form1.Height - 250;
end;

procedure TForm1.SoftWClick(Sender: TObject);
begin
  form9.catalog(4);
  form9.Show;
end;


procedure TForm1.SoftWMouseEnter(Sender: TObject);
begin
  softw.Transparent:=false;
end;

procedure TForm1.SoftWMouseLeave(Sender: TObject);
begin
  softw.Transparent:=true;
end;

procedure TForm1.SpeedButton10Click(Sender: TObject);
var i,j : longint; s : string;
    l1,l2 : integer;
begin
   if combobox6.ItemIndex > 10 then
   begin
     for i := 0 to DCS1.ComboBox1.Items.Count - 1 do
     if dcs1.ComboBox1.Items[i] = '"'+combobox6.Text+'"' then
     begin
       dcs1.ComboBox1.ItemIndex:=i;
       dcs1.show;
       dcs1.ComboBox1Change(sender);
       break;
     end;
   end
   else
   begin
     case combobox6.ItemIndex of
            1 : begin l1 := -2000; l2 := -300;end;
            2 : begin l1 := -300; l2 := 200;end;
            3 : begin l1 := 200; l2 := 1966;end;
            4 : begin l1 := -2000; l2 := -800;end;
            5 : begin l1 := -800; l2 := -300;end;
            6 : begin l1 := -300; l2 := 200;end;
            7 : begin l1 := 200; l2 := 700;end;
            8 : begin l1 := 700; l2 := 1200;end;
            9 : begin l1 := 1200; l2 := 1700;end;
            10 : begin l1 := 1700; l2 := 2000;end;

     end;
     form2.Show;
     form2.Caption:='Period: '+combobox6.Text;
     form2.ListBox1.Clear;
     for i := 1 to ct.StringGrid1.RowCount - 1 do
     begin
       j := strtoint(ct.StringGrid1.Cells[3,i]);
       if (j >= l1)
 and (j <= l2) then
       form2.ListBox1.Items.Add(ct.StringGrid1.Cells[0,i]);
     end;
      form2.StatusBar1.Panels[1].Text:= lp.StringGrid1.Cells[x229,232] + ' '+
      inttostr(form2.listbox1.Count);
   end;

end;

procedure TForm1.SpeedButton11Click(Sender: TObject);
var i,j,k,l : dword; s,s1 : string;
begin  j := 0;
  if stringgrid1.RowCount > 1  then
  s1 := stringgrid1.Cells[1,stringgrid1.Row];
  if s1 <> '' then
  begin
     setlength(ddl,depo.StringGrid1.RowCount-1);
     progressbar1.Show;
     progressbar1.Min:=0;progressbar1.Max:=100;progressbar1.Step:=10;
     for i := 1 to depo.StringGrid1.RowCount - 1 do
     begin
        progressbar1.Position:=round(i/depo.StringGrid1.RowCount)*100;
        filldlist(i);
        s := dlist[1].DDesc;
        if (pos('"'+s1+'-',s) in  [4..30]) or
           (pos('-'+s1+'"',s) in [4..40]) then
           begin
             dlist[1].ID:=i;dlist[1].wd:= depo.StringGrid1.Cells[1,i];
             ddl[j] := dlist;  inc(j);
           end;
     end;
     progressbar1.Hide;
     setlength(ddl,j);
     if j = 0 then infx('Stem derivation','Could not found  derivated stems') else
     begin
        speedbutton27click(sender);
        resform.Edit1.Text:='The stem derivation for: "'+s1+'" including the composite words';
     end;
  end;
//  popupmenu2.PopUp;
end;

procedure TForm1.SpeedButton11MouseEnter(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton11MouseLeave(Sender: TObject);
begin


end;

procedure TForm1.SpeedButton12Click(Sender: TObject);
begin
  if of1.WindowState=wsminimized then of1.WindowState:=wsnormal;
  of1.Show;
  of1.BringToFront;
end;

procedure TForm1.SpeedButton12MouseEnter(Sender: TObject);
begin
   SpeedButton12.Transparent:=false;
end;

procedure TForm1.SpeedButton12MouseLeave(Sender: TObject);
begin
   SpeedButton12.Transparent:=true;
end;


procedure TForm1.SpeedButton13Click(Sender: TObject);
begin
  MenuItem139Click(Sender);

  vstat.A[21].CName:=speedbutton13.Caption;
  inc(vstat.A[21].c);
  SpeedButton48click(sender);
  if tts.FormStyle <> fsstayontop then
  tts.FormStyle := fsstayontop;
  tts.Left:=form1.left +
  stringgrid1.Columns[0].Width+
  stringgrid1.Columns[1].Width+
  stringgrid1.Columns[4].Width+25;

;
end;

procedure TForm1.SpeedButton13MouseEnter(Sender: TObject);
begin
   SpeedButton13.Transparent:=false;
end;

procedure TForm1.SpeedButton13MouseLeave(Sender: TObject);
begin
   SpeedButton13.Transparent:=true;
end;

procedure TForm1.SpeedButton14Click(Sender: TObject);
begin
  sdic(0);
end;

procedure TForm1.SpeedButton14MouseEnter(Sender: TObject);
begin
  speedbutton14.Transparent:=false;
end;

procedure TForm1.SpeedButton14MouseLeave(Sender: TObject);
begin
  speedbutton14.Transparent:=true;
end;

procedure TForm1.SpeedButton15Click(Sender: TObject);
begin
  if panel26.Visible then checkbox24.Checked:=true
  else
  begin
    checkbox14.Checked:=true;
    checkbox21.Checked:=true;
    checkbox27.Checked:=true;
  end;
  if stringgrid1.RowCount > 1 then
    stringgrid1click(sender);
end;

procedure TForm1.SpeedButton15MouseEnter(Sender: TObject);
begin
  speedbutton15.Transparent:=false;
end;

procedure TForm1.SpeedButton15MouseLeave(Sender: TObject);
begin
 speedbutton15.Transparent:=true;
end;
 procedure TForm1.SpeedButton16Click(Sender: TObject);
begin
  case speedbutton16.Caption of
      '⯅' :   begin
                panel6.Height:=150;
//                SpeedButton16.Caption:='⯆';
              end;
      '⯆' :   begin
                 panel6.Height:=form1.Height - 250;
                 SpeedButton16.Caption:='⯅';
              end;
  end;


end;

procedure TForm1.SpeedButton16MouseEnter(Sender: TObject);
begin
  speedbutton16.Transparent:=false;
end;

procedure TForm1.SpeedButton16MouseLeave(Sender: TObject);
begin
  speedbutton16.Transparent:=true;
end;

procedure TForm1.SpeedButton18Click(Sender: TObject);
var i : dword;
begin
  if stringgrid1.RowCount > 1 then
  for i := 1 to stringgrid1.RowCount - 1 do
  stringgrid1.Cells[9,i] := '';
  StatusBarx2.Panels[3].Text := '0';
end;

procedure TForm1.SpeedButton18MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;



procedure TForm1.SpeedButton18MouseEnter(Sender: TObject);
begin
  speedbutton18.Transparent := false;
end;

procedure TForm1.SpeedButton18MouseLeave(Sender: TObject);
begin
   speedbutton18.Transparent := true;
end;

procedure TForm1.SpeedButton19Click(Sender: TObject);
begin
 sdic(4);
end;

procedure TForm1.SpeedButton19MouseEnter(Sender: TObject);
begin
  speedbutton19.Transparent:=false;
end;

procedure TForm1.SpeedButton19MouseLeave(Sender: TObject);
begin
  speedbutton19.Transparent:=true;
end;


procedure TForm1.SpeedButton1Click(Sender: TObject);
var i,j,k,l : dword; s,s1 : string;
begin  j := 0;
  s1 := '';
  if stringgrid1.Row > 0  then
  s1 := stringgrid1.Cells[1,stringgrid1.Row];
  if s1 <> '' then
  begin
     setlength(ddl,depo.StringGrid1.RowCount-1);
     progressbar1.Show;
     progressbar1.Min:=0;progressbar1.Max:=100;progressbar1.Step:=10;
     for i := 1 to depo.StringGrid1.RowCount - 1 do
     begin
        progressbar1.Position:=round(i/depo.StringGrid1.RowCount)*100;
        filldlist(i);
        s := dlist[1].DDesc;
        if (pos('"'+s1+'-',s) in  [4..30]) or
           (pos('-'+s1+'"',s) in [4..40]) then
           begin
             dlist[1].ID:=i;dlist[1].wd:= depo.StringGrid1.Cells[1,i];
             ddl[j] := dlist;  inc(j);
           end;
     end;
     progressbar1.Hide;
     setlength(ddl,j);
     if j = 0 then
     begin
      infx('Stem derivation','Could not found  derivated stems');
      if checkbox7.Checked then
      shellexecute(0,'open',pchar('sys\xlsdata\share\NAMES\data10.xlsx'),'',nil,1);
     end
     else
     begin
        speedbutton27click(sender);
        resform.Edit1.Text:='The stem derivation for: "'+s1+'" including the composite words';
     end;
  end;
//  popupmenu2.PopUp;

end;

procedure TForm1.SpeedButton20Click(Sender: TObject);
begin
  chp(10);
  popupmenu5.PopUp;
end;

procedure TForm1.SpeedButton20MouseEnter(Sender: TObject);
begin
   SpeedButton20.Transparent:=false;
end;

procedure TForm1.SpeedButton20MouseLeave(Sender: TObject);
begin
   SpeedButton20.Transparent:=true;
end;

procedure TForm1.SpeedButton21Click(Sender: TObject);
var i : dword;
begin
    if stringgrid1.RowCount > 1 then
    for i := 1 to stringgrid1.RowCount - 1 do
    stringgrid1.Cells[9,i] := speedbutton21.Caption;
    StatusBarx2.Panels[3].Text := inttostr(stringgrid1.RowCount - 1);
end;

procedure TForm1.SpeedButton21MouseEnter(Sender: TObject);
begin
   speedbutton21.Transparent := false;
end;

procedure TForm1.SpeedButton21MouseLeave(Sender: TObject);
begin
   speedbutton21.Transparent := true;
end;

procedure TForm1.SpeedButton22Click(Sender: TObject);
var a : dword;
begin
  vstat.A[26].CName:=speedbutton22.Caption;
  inc(vstat.A[26].c);

    a := strtoint(StatusBarx2.Panels[3].Text);
    if a > 0 then  getN('',false)
     else    infx('Translation','Select some words for export');

end;

procedure TForm1.SpeedButton22MouseEnter(Sender: TObject);
begin
  speedbutton22.Transparent:=false;
end;

procedure TForm1.SpeedButton22MouseLeave(Sender: TObject);
begin
  speedbutton22.Transparent:=true;
end;

procedure TForm1.SpeedButton23Click(Sender: TObject);
begin
  if fr.WindowState = wsminimized then bitbtn7click(sender);
  frs.FR.Show;
end;

procedure TForm1.SpeedButton23MouseEnter(Sender: TObject);
begin
   SpeedButton23.Transparent:=false;
end;

procedure TForm1.SpeedButton23MouseLeave(Sender: TObject);
begin
   SpeedButton23.Transparent:=true;
end;

procedure TForm1.SpeedButton24Click(Sender: TObject);
var i : byte;
begin
  if verdir.WindowState=wsminimized then bitbtn6click(sender);
  verdir.Show;
end;

procedure TForm1.SpeedButton24MouseEnter(Sender: TObject);
begin
   speedbutton24.Transparent:=false;
end;

procedure TForm1.SpeedButton24MouseLeave(Sender: TObject);
begin
  speedbutton24.Transparent:=true;
end;

procedure TForm1.SpeedButton25Click(Sender: TObject);
begin
  savedialog1.FileName:=edit3.TextHint+'.txt';
  if savedialog1.Execute then
  memo1.Lines.SaveToFile(savedialog1.FileName);
end;



procedure TForm1.SpeedButton26Click(Sender: TObject);
var s : string;
    i,c,a : dword;
begin
  vstat.A[27].CName:=speedbutton26.Caption;
  inc(vstat.A[27].c);

   a := strtoint(StatusBarx2.Panels[3].Text);
    if a > 0 then
    begin
     s := '';
      a := 0; c := 0;
      s := 'देवनागरी'+#9+'IAST'+#9+'Grammar'+#13+#10;
      for i := 0 to stringgrid1.rowcount - 1 do
      if stringgrid1.Cells[9,i] <> '' then
         s := s + stringgrid1.Cells[0,i] + #9 + stringgrid1.Cells[1,i]+#9+
                    stringgrid1.Cells[4,i]+#13+#10;
      clipboard.AsText:=s;
      infx('Clipboard','The list has been copied to clipboard');


    end
      else
        infx('No data','Please select data');
end;

procedure TForm1.SpeedButton26MouseEnter(Sender: TObject);
begin
  speedbutton26.Transparent:=false;
end;

procedure TForm1.SpeedButton26MouseLeave(Sender: TObject);
begin
  speedbutton26.Transparent:=true;
end;

procedure TForm1.SpeedButton27Click(Sender: TObject);
var x : longint;
begin
  vstat.A[29].CName:=speedbutton27.Caption;
  inc(vstat.A[29].c);

if length(ddl) > 0  then
begin
  if resform.WindowState=wsminimized then
     bitbtn1click(sender);

  resform.checklistBox1.Clear;
  resform.checklistBox2.Clear;

  resform.memo2.Clear;
  resform.hw.Clear;

  for x := 0 to length(ddl) - 1 do
  begin
    resform.checklistBox2.Items.Add(ddl[x,1].wd);
    resform.checklistBox2.Checked[x] := true;
  end;


  setlength(car,resform.checklistBox2.Count);
  for x := 0 to length(car) - 1 do
  begin
    car[x].c2:=true;
    car[x].c1 := [0..255];
  end;
  resform.Caption:='['+ddl[0,1].wd +
  '..'+ddl[length(ddl) - 1,1].wd+']';
   resform.StatusBar1.Panels[1].Text :=
  inttostr(resform.CheckListBox2.Items.Count);
  inttostr(resform.checklistBox2.Count);
  resform.BringToFront;
if resform.checklistBox2.Items.Count > 0 then
begin
  resform.checklistbox2.ItemIndex:=0;
  resform.checklistBox2click(sender);
  Resform.Show;
end;

end;
progressbar1.Hide;
resform.StatusBar1.Panels[1].Text:=inttostr(resform.CheckListBox2.Items.Count);
end;

procedure TForm1.SpeedButton27MouseEnter(Sender: TObject);
begin
  speedbutton27.Transparent:=false;
end;

procedure TForm1.SpeedButton27MouseLeave(Sender: TObject);
begin
  speedbutton27.Transparent:= true;
end;

procedure TForm1.SpeedButton28Click(Sender: TObject);
begin
   panel6.Height:=(form1.Height - panel2.Height) div 2;
end;

procedure TForm1.SpeedButton28MouseEnter(Sender: TObject);
begin
  speedbutton28.Transparent:=false;
end;

procedure TForm1.SpeedButton28MouseLeave(Sender: TObject);
begin
   speedbutton28.Transparent:=true;
end;


procedure TForm1.SpeedButton29Click(Sender: TObject);
var i,j  : dword;
    s : string;
begin
  s := '';
  if stringgrid1.RowCount > 1 then
  begin
   for j := 0 to stringgrid1.ColCount - 1 do
   if stringgrid1.Columns[j].Visible then
   s := s + stringgrid1.columns[j].Title.Caption + #9;
   s := s + #13+#10;
  for i := 1 to stringgrid1.RowCount - 1 do
  begin
     for j := 0 to stringgrid1.ColCount - 1 do
     if stringgrid1.Columns[j].Visible then
     s := s + stringgrid1.Cells[j,i] + #9;
     s := s + #13+#10;
  end;
 end;
  if s <> '' then
  Clipboard.AsText:=s
  else
  infx('Copy','There is no data for copying');
  vstat.A[28].CName:=speedbutton29.Caption;
  inc(vstat.A[28].c);

//   if savedialog1.Execute then
//   begin
//      stringgrid1.SaveToCSVFile(savedialog1.FileName,#9,true,true);
//      if checkbox7.Checked then
//      shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
//   end;


end;

procedure TForm1.SpeedButton29MouseEnter(Sender: TObject);
begin
//  SpeedButton29.Transparent:=false;
end;

procedure TForm1.SpeedButton29MouseLeave(Sender: TObject);
begin
//  SpeedButton29.Transparent:=true;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if shis.StringGrid1.RowCount > 1 then
  if hisid > 1 then
  begin
     dec(hisid);
     shis.stringgrid1.Row:=hisid;
     edit2.Text:=shis.StringGrid1.Cells[1,hisid];
     if checkbox1.Checked = false then
     button1click(sender);
  end
  else
     infx('Search History','Begin of the list')

end;

procedure TForm1.SpeedButton2MouseEnter(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton2MouseLeave(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton30Click(Sender: TObject);
begin
   sdic(5);
end;

procedure TForm1.SpeedButton30MouseEnter(Sender: TObject);
begin
  speedbutton30.Transparent:=false;
end;

procedure TForm1.SpeedButton30MouseLeave(Sender: TObject);
begin
  speedbutton30.Transparent:=true;
end;

procedure TForm1.SpeedButton31Click(Sender: TObject);
begin
  sdic(6);
end;


procedure TForm1.SpeedButton31MouseEnter(Sender: TObject);
begin
  speedbutton31.Transparent:=false;
end;

procedure TForm1.SpeedButton31MouseLeave(Sender: TObject);
begin
  speedbutton31.Transparent:=true;
end;

procedure TForm1.SpeedButton32Click(Sender: TObject);
begin
  sdic(9);
end;

procedure TForm1.SpeedButton32MouseEnter(Sender: TObject);
begin
  speedbutton32.Transparent:=false;
end;

procedure TForm1.SpeedButton32MouseLeave(Sender: TObject);
begin
  speedbutton32.Transparent:=true;
end;

procedure TForm1.SpeedButton33Click(Sender: TObject);
begin
  sdic(1);
end;

procedure TForm1.SpeedButton33MouseEnter(Sender: TObject);
begin
  speedbutton33.Transparent:=false;
end;

procedure TForm1.SpeedButton33MouseLeave(Sender: TObject);
begin
  speedbutton33.Transparent:=true;
end;

procedure TForm1.SpeedButton34Click(Sender: TObject);
begin
  sdic(10);
end;

procedure TForm1.SpeedButton34MouseEnter(Sender: TObject);
begin
  speedbutton34.Transparent:=false;
end;

procedure TForm1.SpeedButton34MouseLeave(Sender: TObject);
begin
  speedbutton34.Transparent:=true;
end;

procedure TForm1.SpeedButton35Click(Sender: TObject);
begin
  sdic(16);
end;

procedure TForm1.SpeedButton35MouseEnter(Sender: TObject);
begin
  speedbutton35.Transparent:=false;
end;

procedure TForm1.SpeedButton35MouseLeave(Sender: TObject);
begin
  speedbutton35.Transparent:=true;
end;

procedure TForm1.SpeedButton36Click(Sender: TObject);
begin
  sdic(7);
end;

procedure TForm1.SpeedButton36MouseEnter(Sender: TObject);
begin
  speedbutton36.Transparent:=false;
end;

procedure TForm1.SpeedButton36MouseLeave(Sender: TObject);
begin
  speedbutton36.Transparent:=true;
end;

procedure TForm1.SpeedButton37Click(Sender: TObject);
begin
   sdic(2);
end;

procedure TForm1.SpeedButton37MouseEnter(Sender: TObject);
begin
  Speedbutton37.Transparent:=false;
end;

procedure TForm1.SpeedButton37MouseLeave(Sender: TObject);
begin
    Speedbutton37.Transparent:=true;
end;

procedure TForm1.SpeedButton38Click(Sender: TObject);
begin
  sdic(11);
end;

procedure TForm1.SpeedButton38MouseEnter(Sender: TObject);
begin
  speedbutton38.Transparent:=false;
end;

procedure TForm1.SpeedButton38MouseLeave(Sender: TObject);
begin
  speedbutton38.Transparent:=true;
end;

procedure TForm1.SpeedButton39Click(Sender: TObject);
begin
  sdic(12);
end;

procedure TForm1.SpeedButton39MouseEnter(Sender: TObject);
begin
  speedbutton39.Transparent:=false;
end;

procedure TForm1.SpeedButton39MouseLeave(Sender: TObject);
begin
  speedbutton39.Transparent:=true;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  sh1.shis.Show;

  shis.StringGrid1selection(sender,0,0);
//  shis.FormCreate(sender);
//  if shis.ListBox2.Items.Count > 0 then
//  shis.ListBox2.ItemIndex:=hisid;
end;

procedure TForm1.SpeedButton3MouseEnter(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton3MouseLeave(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton40Click(Sender: TObject);
begin
  sdic(15);
end;

procedure TForm1.SpeedButton40MouseEnter(Sender: TObject);
begin
  speedbutton40.Transparent:=false;
end;

procedure TForm1.SpeedButton40MouseLeave(Sender: TObject);
begin
  speedbutton40.Transparent:=true;
end;

procedure TForm1.SpeedButton41Click(Sender: TObject);
begin
  sdic(14);
end;

procedure TForm1.SpeedButton41MouseEnter(Sender: TObject);
begin
  speedbutton41.Transparent:=false;
end;

procedure TForm1.SpeedButton41MouseLeave(Sender: TObject);
begin
  speedbutton41.Transparent:=true;
end;

procedure TForm1.SpeedButton42Click(Sender: TObject);
begin
  sdic(3);
end;

procedure TForm1.SpeedButton42MouseEnter(Sender: TObject);
begin
  speedbutton42.Transparent:=false;
end;

procedure TForm1.SpeedButton42MouseLeave(Sender: TObject);
begin
  speedbutton42.Transparent:=true;
end;

procedure TForm1.SpeedButton43Click(Sender: TObject);
begin
  sdic(8);
end;

procedure TForm1.SpeedButton43MouseEnter(Sender: TObject);
begin
  speedbutton43.Transparent:=false;
end;

procedure TForm1.SpeedButton43MouseLeave(Sender: TObject);
begin
  speedbutton43.Transparent:=true;
end;

procedure TForm1.SpeedButton44Click(Sender: TObject);
begin
   sdic(13);
end;

procedure TForm1.SpeedButton44MouseEnter(Sender: TObject);
begin
  speedbutton44.Transparent:=false;
end;

procedure TForm1.SpeedButton44MouseLeave(Sender: TObject);
begin
  speedbutton44.Transparent:=true;
end;

procedure TForm1.SpeedButton45Click(Sender: TObject);
var i,j : dword;
begin  j := 0;
   if stringgrid1.RowCount > 1 then
   for i := 1 to stringgrid1.RowCount-1 do
   if stringgrid1.Cells[9,i] <> '' then
      stringgrid1.Cells[9,i] := ''
      else begin stringgrid1.Cells[9,i] := speedbutton21.Caption;inc(j);end;
    StatusBarx2.Panels[3].Text:=inttostr(j);
end;

procedure TForm1.SpeedButton45MouseEnter(Sender: TObject);
begin
  speedbutton45.Transparent:=false;
end;

procedure TForm1.SpeedButton45MouseLeave(Sender: TObject);
begin
   speedbutton45.Transparent:=true;
end;

procedure TForm1.SpeedButton46Click(Sender: TObject);
var i :  dword; f : text; s : string;
    mC : Tmenuitem;
    cname : string;
begin
  for i := 1 to depo.StringGrid1.RowCount - 1 do
  if depo.StringGrid1.Cells[5,i] <> '' then
  begin
    s := depo.StringGrid1.Cells[5,i];
    while length(s) < 6 do s := ' '+s;
    depo.stringgrid1.Cells[5,i] := s;
  end;
  depo.StringGrid1.SaveToCSVFile('sys\hdr.sdm',#9);
  showmessage('');
  exit;
  assignfile(f,'mmm');rewrite(f);

  for i := 0 to ComponentCount-1 do
  begin
    if components[i] is TMenuitem then
    begin
//      mc.parent := components[i];
        writeln(f,components[i].Name,'#',mc.Caption,'#');
    end;
  end;
  closefile(f);

  showmessage('done');
end;

procedure TForm1.SpeedButton47Click(Sender: TObject);
begin
  form7.show;
  form7.CheckListBox1.Checked[combobox6.ItemIndex] := true;
  form7.CheckListBox1Click(Sender);
end;

procedure TForm1.SpeedButton47MouseEnter(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton47MouseLeave(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton48Click(Sender: TObject);
begin
  chp(1);
//  panel2.Height:=panel9.Height+panel39.Height+3;

  edit2.SetFocus;
  vstat.A[1].CName:=speedbutton48.Caption;
  inc(vstat.A[1].c);
end;

procedure TForm1.SpeedButton48MouseEnter(Sender: TObject);
begin
  speedbutton48.Transparent:= false;;
end;

procedure TForm1.SpeedButton48MouseLeave(Sender: TObject);
begin
  speedbutton48.Transparent:= true;
end;

procedure TForm1.SpeedButton49Click(Sender: TObject);
begin
  chp(6);
  if dc.WindowState=wsminimized then dc.WindowState:=wsnormal;;
  dc.Show;
  dc.BringToFront;
  form1.SendToBack;
  dc.SpeedButton4Click(sender);
  vstat.A[6].CName:=speedbutton49.Caption;
  inc(vstat.A[6].c);

end;

procedure TForm1.SpeedButton49MouseEnter(Sender: TObject);
begin
  SpeedButton49.Transparent:=false;
end;

procedure TForm1.SpeedButton49MouseLeave(Sender: TObject);
begin
  SpeedButton49.Transparent:=true;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
   symba.show;
   symba.Left:=form1.Left;
   symba.Top:=form1.Top + 115;
//   symba.Width:=1100;
//   symba.Height:=form1.Height - 75;
//   symba.GroupBox1.Width:=round(symba.Width/2);
//   symba.GroupBox1.top:=sym[1].height + 24;
//   symba.GroupBox1.Height:=symba.ClientHeight - symba.GroupBox1.Top- 48 - sym[1].Height;
//   symba.GroupBox1.Left:=symba.Width  - symba.GroupBox1.Width;
//   symba.FormCreate(sender);

end;

procedure TForm1.SpeedButton4MouseEnter(Sender: TObject);
begin
  SpeedButton4.Transparent:=false;
end;

procedure TForm1.SpeedButton4MouseLeave(Sender: TObject);
begin
   SpeedButton4.Transparent:=true;
end;

procedure TForm1.SpeedButton50Click(Sender: TObject);
begin
  chp(5);
  if tz.WindowState = wsminimized then tz.WindowState:=wsnormal;
  tz.BringToFront;
  form1.SendToBack;
  tz.Show;
  vstat.A[5].CName:=speedbutton50.Caption;
  inc(vstat.A[5].c);

end;

procedure TForm1.SpeedButton50MouseEnter(Sender: TObject);
begin
  SpeedButton50.Transparent:=false;
end;

procedure TForm1.SpeedButton50MouseLeave(Sender: TObject);
begin
  SpeedButton50.Transparent:=true;
end;

procedure TForm1.SpeedButton51Click(Sender: TObject);
begin
  MenuItem59Click(Sender);
end;

procedure TForm1.SpeedButton51MouseEnter(Sender: TObject);
begin
  speedbutton51.Transparent := false;
end;

procedure TForm1.SpeedButton51MouseLeave(Sender: TObject);
begin
  speedbutton51.Transparent := true;
end;

procedure TForm1.SpeedButton52Click(Sender: TObject);
begin
  chp(4);
  vstat.A[4].CName:=speedbutton52.Caption;
  inc(vstat.A[4].c);

end;

procedure TForm1.SpeedButton52MouseEnter(Sender: TObject);
begin
  SpeedButton52.Transparent:=false;
end;

procedure TForm1.SpeedButton52MouseLeave(Sender: TObject);
begin
  SpeedButton52.Transparent:=true;
end;

procedure TForm1.SpeedButton53Click(Sender: TObject);
begin
  chp(3);
  if kkn.WindowState = wsminimized then kkn.WindowState:=wsnormal;
  kkn.show;
  kkn.BringToFront;
  form1.SendToBack;
  kkn.ComboBox1Change(sender);
  kkn.ComboBox_.ItemIndex:=2;

  vstat.A[3].CName:=speedbutton53.Caption;
  inc(vstat.A[3].c);

end;

procedure TForm1.SpeedButton53MouseEnter(Sender: TObject);
begin
  SpeedButton53.Transparent:=false;
end;

procedure TForm1.SpeedButton53MouseLeave(Sender: TObject);
begin
  SpeedButton53.Transparent:=true
end;

procedure TForm1.SpeedButton54Click(Sender: TObject);
begin
  chp(2);
  vstat.A[2].CName:=speedbutton54.Caption;
  inc(vstat.A[2].c);

end;

procedure TForm1.SpeedButton54MouseEnter(Sender: TObject);
begin
   SpeedButton54.Transparent:=false;
end;

procedure TForm1.SpeedButton54MouseLeave(Sender: TObject);
begin
  SpeedButton54.Transparent:=true;
end;

procedure TForm1.SpeedButton55Click(Sender: TObject);
begin
  if sintagma.WindowState= wsminimized then
  sintagma.WindowState:=wsnormal;
  sintagma.show;
  sintagma.BringToFront;
  sintagma.load1;
end;

procedure TForm1.SpeedButton55MouseEnter(Sender: TObject);
begin
  speedbutton55.Transparent:=false;
end;

procedure TForm1.SpeedButton55MouseLeave(Sender: TObject);
begin
  speedbutton55.Transparent:=true;
end;

procedure TForm1.SpeedButton56Click(Sender: TObject);
begin
    if form9.WindowState=wsminimized then form9.WindowState:=wsnormal;
    form9.show;
    form9.BringToFront;form1.SendToBack;
    form9.catalog(1);
//  chp(8);
   vstat.A[7].CName:=speedbutton56.Caption;
   inc(vstat.A[7].c);

end;

procedure TForm1.SpeedButton56MouseEnter(Sender: TObject);
begin
  SpeedButton56.Transparent:=false;
end;

procedure TForm1.SpeedButton56MouseLeave(Sender: TObject);
begin
  SpeedButton56.Transparent:=true;
end;

procedure TForm1.SpeedButton57Click(Sender: TObject);
begin
  chp(7);
//  vstat.A[6].CName:=speedbutton57.Caption;
//  inc(vstat.A[6].c);

end;

procedure TForm1.SpeedButton57MouseEnter(Sender: TObject);
begin
  speedbutton57.Transparent:=false;
end;

procedure TForm1.SpeedButton57MouseLeave(Sender: TObject);
begin
  speedbutton57.Transparent:=true;
end;

procedure TForm1.SpeedButton58Click(Sender: TObject);
begin
  chp(9);
  vstat.A[8].CName:=speedbutton58.Caption;
  inc(vstat.A[8].c);

end;

procedure TForm1.SpeedButton58MouseEnter(Sender: TObject);
begin
  SpeedButton58.Transparent:=false;
end;

procedure TForm1.SpeedButton58MouseLeave(Sender: TObject);
begin
  SpeedButton58.Transparent:=true;
end;

procedure TForm1.SpeedButton59Click(Sender: TObject);
begin
  MenuItem30Click(Sender);
end;

procedure TForm1.SpeedButton59MouseEnter(Sender: TObject);
begin
  speedbutton59.Transparent:=false;
end;

procedure TForm1.SpeedButton59MouseLeave(Sender: TObject);
begin
  speedbutton59.Transparent:=true;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  tema1.tema.Show;
end;

procedure TForm1.SpeedButton5MouseEnter(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton5MouseLeave(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton60Click(Sender: TObject);
begin
  ng.Show;
end;

procedure TForm1.SpeedButton61Click(Sender: TObject);
begin
  MenuItem31Click(Sender);
end;

procedure TForm1.SpeedButton61MouseEnter(Sender: TObject);
begin
  speedbutton61.Transparent:=false;
end;

procedure TForm1.SpeedButton61MouseLeave(Sender: TObject);
begin
  speedbutton61.Transparent:=true;
end;

procedure TForm1.SpeedButton62Click(Sender: TObject);
begin
  if prl.windowstate=wsminimized then
     prl.windowstate := wsnormal;
  prl.Show;
  prl.BringToFront;
  vstat.A[22].CName:=speedbutton62.Caption;
  inc(vstat.A[22].c);

end;

procedure TForm1.SpeedButton62MouseEnter(Sender: TObject);
begin
  speedbutton62.Transparent:=false;
end;

procedure TForm1.SpeedButton62MouseLeave(Sender: TObject);
begin
  speedbutton62.Transparent:=true;
end;

procedure TForm1.SpeedButton63Click(Sender: TObject);
begin
  MenuItem58Click(Sender);
end;

procedure TForm1.SpeedButton63MouseEnter(Sender: TObject);
begin
   speedbutton63.Transparent:= false;
end;

procedure TForm1.SpeedButton63MouseLeave(Sender: TObject);
begin
  speedbutton63.Transparent:= true;
end;

procedure TForm1.SpeedButton64Click(Sender: TObject);
begin
  if ed.WindowState=wsminimized then
  ed.WindowState:=wsnormal;
  Ed.Show;
  ed.BringToFront;
end;

procedure TForm1.SpeedButton64MouseEnter(Sender: TObject);
begin
    speedbutton64.Transparent:=false;
end;

procedure TForm1.SpeedButton64MouseLeave(Sender: TObject);
begin
  speedbutton64.Transparent:=true;
end;

procedure TForm1.SpeedButton65Click(Sender: TObject);
begin
  MenuItem64Click(Sender);
end;

procedure TForm1.SpeedButton65MouseEnter(Sender: TObject);
begin
  speedbutton65.Transparent:=false;
end;

procedure TForm1.SpeedButton65MouseLeave(Sender: TObject);
begin
  speedbutton65.Transparent:=true;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
  prl.Show;
end;

procedure TForm1.SpeedButton6MouseEnter(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton6MouseLeave(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
  combobox3.ItemIndex:=0;
  panel26.Hide;panel8.Show;panel23.Show;panel33.Show;
  popupmenu1.AutoPopup:=true;;
//  combobox6.ItemIndex:=0;
//  combobox6.Show;

//  checkbox6.Show;

  hisid := -1;
  edit2 .Clear;
  geytrd1(0);

  stringgrid1.Columns[0].Visible:=true;
  stringgrid1.Columns[1].Visible:=true;
  stringgrid1.Columns[2].Visible:=false;
  stringgrid1.Columns[3].Visible:=false;
  stringgrid1.Columns[4].Visible:=true;
  stringgrid1.Columns[5].Visible:=true;
  stringgrid1.Columns[6].Visible:=true;
  stringgrid1.Columns[7].Visible:=true;
  stringgrid1.Columns[8].Visible:=true;
  stringgrid1.Columns[9].Visible:=true;
  if stringgrid1.Row <> 1 then
  stringgrid1.Row:=1;
  stringgrid1.Col:=0;
  sgw;
  memo1.Clear;
  SelCnt;
  stringgrid1.Columns[10].Visible:=false;
end;

procedure TForm1.SpeedButton7MouseEnter(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton7MouseLeave(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
  if shis.StringGrid1.RowCount > 1 then
  if hisid < shis.stringgrid1.rowcount - 1 then
  begin
     inc(hisid);
     shis.stringgrid1.Row:=hisid;
     edit2.Text:=shis.StringGrid1.Cells[1,hisid];
     if checkbox1.Checked= false then
     button1click(sender);
  end
  else
     infx('Search History','End of the list')
end;

procedure TForm1.SpeedButton8MouseEnter(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton8MouseLeave(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton9Click(Sender: TObject);
begin
   if dcs1.WindowState=wsminimized then
   dcs1.WindowState:=wsnormal;
   DCS1.Show;
   dcs1.BringToFront;
   vstat.A[23].CName:=speedbutton9.Caption;
   inc(vstat.A[23].c);

end;

procedure TForm1.SpeedButton9MouseEnter(Sender: TObject);
begin
  SpeedButton9.Transparent:=false;
end;

procedure TForm1.SpeedButton9MouseLeave(Sender: TObject);
begin
  SpeedButton9.Transparent:=true;
end;

procedure TForm1.spp1Click(Sender: TObject);
begin
  hw1.FindEx(edit1.Text,false,false);
  if sps.p2 < length(sps.p1) then inc(sps.p2);
  label3.Caption:=inttostr(sps.p2)+'/'+inttostr(length(sps.p1));
end;

procedure TForm1.spp2Click(Sender: TObject);
begin
  hw1.FindEx(edit1.Text,false,true);
  if sps.p2 > 1 then dec(sps.p2);
  label3.Caption:=inttostr(sps.p2)+'/'+inttostr(length(sps.p1));

end;

procedure TForm1.spp3Click(Sender: TObject);
begin
  if form8.WindowState=wsminimized then form8.WindowState:=wsnormal;
  form8.Show;
  form8.BringToFront;
end;

procedure TForm1.spp4Click(Sender: TObject);
begin
  shellexecute(handle,'open','mailto://iymagic@yandex.ru',nil,nil,1);
end;

procedure TForm1.spp5Click(Sender: TObject);
begin
  shellexecute(handle,'open','https://disk.yandex.ru/d/aa0uNBHxyWYyTQ',nil,nil,1);
end;

procedure TForm1.spp6Click(Sender: TObject);
begin
  Speedbutton4click(sender);
end;

procedure TForm1.Spr1Click(Sender: TObject);
begin
  menuitem2click(sender);
end;

procedure TForm1.Spr1MouseEnter(Sender: TObject);
begin
  spr1.Transparent:=false;
end;

procedure TForm1.Spr1MouseLeave(Sender: TObject);
begin
  spr1.Transparent:=true;
end;

procedure TForm1.SPXR1Click(Sender: TObject);
begin
  showmessage(inttostr(  SelLm('DCS','')));
end;



procedure TForm1.StringGrid1Click(Sender: TObject);
var y,i : longint;
    cm, ca,cp : longint;
    s : string;
    s2 : string;
    count : longint;
    art : string;
    M : string;
    AP: string;
    MV: string;
    PW: string;
    x : longint;
    mm : boolean;
    aa : boolean;
    pp : boolean;
    vv : boolean;
    g : longint;
    cc : longint;
    k4 : string;
    T : Trect;
    XM : TMenuitem;
begin
  if stringgrid1.Row < 1 then exit;
 case stringgrid1.Col of
     4 :begin
        vstat.A[14].CName:='GRM';
        inc(vstat.A[14].c);
        end;
     5 :begin
        vstat.A[15].CName:='Examples';
        inc(vstat.A[15].c);
        end;
     6 :begin
        vstat.A[16].CName:='Syn';
        inc(vstat.A[16].c);
        end;
     7 :begin
        vstat.A[17].CName:='Period';
        inc(vstat.A[17].c);
        end;
     8 :begin
        vstat.A[18].CName:='Sintagmatic';
        inc(vstat.A[18].c);
        end;
     9 :begin
        vstat.A[19].CName:='Mark';
        inc(vstat.A[19].c);
        end;



 end;
for i  := 0 to stringgrid1.ColCount - 1 do
begin
    stringgrid1.Columns[i].Title.Font.Bold := false;
end;
    stringgrid1.Columns[stringgrid1.Col].Title.Font.Bold := true;
if (stringgrid1.Col=9) and (stringgrid1.Row > 0) then
begin
 if stringgrid1.Cells[9,stringgrid1.Row] = '' then
      stringgrid1.Cells[9,stringgrid1.Row] :=   speedbutton21.caption else
    stringgrid1.Cells[9,stringgrid1.Row] := '';
    SelCnt;
end
else
begin
g := 0;
if (stringgrid1.RowCount > 1) and
   (stringgrid1.Cells[1,stringgrid1.Row] <> '') then
if stringgrid1.Col in [0,1] then
begin
    if wc.Visible then wc.Hide;
    for cc := 1 to length(dlist) do
    dlist[cc].DDesc:='';
  count := 0;
  if stringgrid1.RowCount > 1 then
  begin
   i := 1;
   if panel39.Parent= panel2 then
   begin;
   for y := 1 to shis.StringGrid1.RowCount - 1 do
     if stringgrid1.Cells[1,stringgrid1.Row] = shis.StringGrid1.Cells[1,y] then
        begin
          shis.StringGrid1.Cells[2,y] := inttostr(strtoint(shis.StringGrid1.Cells[2,y])+1);
          shis.StringGrid1.RowCount:=shis.StringGrid1.RowCount +1;
          shis.StringGrid1.Rows[shis.StringGrid1.RowCount-1] :=
          shis.StringGrid1.Rows[y];
          shis.StringGrid1.DeleteRow(y);
          hisid := shis.StringGrid1.RowCount - 1;
          i := 0;
          break;
        end;
     if i = 1 then
     begin
        shis.StringGrid1.RowCount:=shis.StringGrid1.RowCount +1;
        i := shis.StringGrid1.RowCount - 1;
        shis.StringGrid1.cells[0,i] := StringGrid1.cells[0,stringgrid1.Row];
        shis.StringGrid1.Cells[4,i] := inttostr(combobox3.ItemIndex);
        shis.StringGrid1.cells[1,i] := StringGrid1.cells[1,stringgrid1.Row];
        shis.StringGrid1.cells[2,i] := '1';

//        shis.StringGrid1.DeleteCol(shis.StringGrid1.RowCount-1);
        hisid := shis.StringGrid1.RowCount - 1;
     end;
     sclk := false;
     for i := 1 to shis.StringGrid1.RowCount - 1 do
     begin
        shis.StringGrid1.Cells[3,i] := inttostr(i);
//        shis.StringGrid1.Row:=shis.StringGrid1.RowCount - 1;
        while length(shis.StringGrid1.Cells[3,i]) < 6 do
        shis.StringGrid1.Cells[3,i] := '0'+shis.StringGrid1.Cells[3,i];
        while length(shis.StringGrid1.Cells[2,i]) < 6 do
        shis.StringGrid1.Cells[2,i] := '0'+shis.StringGrid1.Cells[2,i];


     end;

     end;



  end;
  s:= '';
  s2 := '';
   s:= '';
   s2 := '';

   memo1.Clear;
   filldlist(strtoint(stringgrid1.Cells[2,stringgrid1.Row]));
   memo1.Text := printdl1;
   Memo1Change(Sender);

   dlist[1].wd:= stringgrid1.Cells[1,stringgrid1.Row];
   dlist[1].ID:= strtoint(stringgrid1.Cells[2,stringgrid1.Row]);
   setlength(ddl,0);
   if memo1.Text <> '' then
   begin
     setlength(ddl,1);
     ddl[0] := dlist;
     memo1.SelStart:=0;
//     memo1.SetFocus;
   end
   Else
   begin
       setlength(ddl,0);
       memo1.Text:=
       stringgrid1.Cells[0,stringgrid1.Row] + ' - '+ stringgrid1.Cells[1,stringgrid1.Row] + #13+#10 +
       'This word is absent in this dictionary';
       Memo1Change(Sender);
   end;
   edit3.Text:=stringgrid1.Cells[0,stringgrid1.Row] + ' - '+ stringgrid1.Cells[1,stringgrid1.Row];
end;
;
if (stringgrid1.RowCount > 1) and
   (stringgrid1.Col = 5)
   then
   if  stringgrid1.Cells[5,stringgrid1.Row] <> '' then
   begin
     getindexes(stringgrid1.Cells[3,stringgrid1.Row]);
     if listbox1.Items.Count = 1 then
     stringgrid1dblclick(sender)
     else
     begin
       vforms.ComboBox4.Items.Clear;vforms.ListBox1.Items.Clear;;
       popupmenu6.Items.Clear;
       for i := 0 to listbox1.Items.Count - 1 do
       begin
        xm := tmenuitem.Create(nil);
        xm.Caption:=stringgrid1.Cells[1,stringgrid1.Row]+ ' '+o[strtoint(listbox1.Items[i])].gr;
        vforms.combobox4.items.add(xm.Caption);
        vforms.ListBox1.Items.Add(listbox1.Items[i] + ' ');
        xm.OnClick:=bt10.OnClick;
          popupmenu6.Items.Add(XM);
       end;
       xm := tmenuitem.Create(nil);
       xm.Caption:= 'All Examples';
       vforms.ComboBox4.Items.Add('All Forms');
       xm.OnClick:=bt10.OnClick;
         popupmenu6.Items.Add(XM);
         vforms.listbox1.Items.Add(stringgrid1.Cells[3,stringgrid1.Row]);
         ids := stringgrid1.Cells[3,stringgrid1.Row];
       popupmenu6.PopUp(mouse.CursorPos.X,mouse.CursorPos.Y);
     end;



   end;
if (stringgrid1.RowCount > 1) and
   (stringgrid1.Col = 4) and
   ((stringgrid1.cells[3,stringgrid1.Row] <> '') or
   (pos('*',stringgrid1.Cells[4,stringgrid1.Row]) > 0)) then
   begin
{     s := stringgrid1.Cells[4,stringgrid1.Row];
     if pos('*',s) > 0 then menuitem65.Enabled:=true else menuitem65.Enabled:=false;
     if ((pos('P',s) > 0) or (pos('Ā',s) > 0)
     or (pos('A',s) > 0)) then
     begin
        menuitem156.Enabled:=true;
        menuitem72.Enabled:= false;
     end
     else
     begin
        menuitem156.Enabled:= false;
        menuitem72.Enabled:=true;
     end;
}    if stringgrid1.Cells[3,stringgrid1.Row] <> '' then
     begin
      vforms.ListBox1.Clear;vforms.ComboBox4.clear;;
      getindexes(stringgrid1.Cells[3,stringgrid1.Row]);

     for i := 0 to listbox1.Items.Count - 1 do
     begin
       vforms.listbox1.Items.Add(listbox1.Items[i]+' ');
       vforms.combobox4.Items.Add(stringgrid1.Cells[1,stringgrid1.Row] + ' '+o[strtoint(listbox1.Items[i])].gr);
     end;
        vforms.ComboBox4.Items.Add('All Forms');
        vforms.ListBox1.Items.Add(stringgrid1.Cells[3,stringgrid1.Row]);
     end;
     popupmenu2.PopUp(mouse.CursorPos.X,mouse.CursorPos.y);
   end;
   if (stringgrid1.RowCount > 1) and
      (stringgrid1.cells[8,stringgrid1.Row] <> '') and
      (stringgrid1.col = 8 ) then
      begin
        GetSinta(Stringgrid1.Cells[3,stringgrid1.Row],false);
        if sinta.caption <> '' then
          Sinta.Show;

      end;
   if (stringgrid1.RowCount > 1) and
      (stringgrid1.cells[6,stringgrid1.Row] <> '') and
      (stringgrid1.col = 6 ) then
      begin
         form4.getS2(stringgrid1.Cells[2,stringgrid1.Row]);
      end;

   if (stringgrid1.RowCount > 1) and
      (stringgrid1.cells[7,stringgrid1.Row] <> '') and
      (stringgrid1.col = 7 ) then
      begin
         if wt1.WindowState= wsminimized then
         wt1.WindowState:=wsnormal;;
         wt1.Show;
         wt1.BringToFront;
         wt1.getwt(strtoint(stringgrid1.Cells[2,stringgrid1.Row]));
      end;

end;
stringgrid1.Columns[10].Visible:=false;

end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
var s,s1,s2 : string;
    i : word;
    c : longint;
    j,k : longint;
begin

   c := 1;
   if stringgrid1.Col = 5 then
      if stringgrid1.Cells[5,stringgrid1.Row] <> '' then
      begin
         GetExam(Stringgrid1.cells[3,stringgrid1.Row],0,0,0,0,0);
         if wr.WindowState = wsminimized then
         wr.WindowState:=wsnormal;
         wr.Show;
         wr.BringToFront;
         wr.Caption:= lp.StringGrid1.Cells[x229,462] + ' "'+
         stringgrid1.Cells[1,stringgrid1.Row] +'"';
         if (vvv <> '') and (wr.STRINGGRID1.RowCount > 1) then
         begin

            c := 1;
            while c < wr.StringGrid1.RowCount do
            begin
              if pos('"'+vvv+'"',wr.stringgrid1.cells[12,c]) = 0 then
              begin
                 wr.stringGrid1.DeleteRow(c);
              end
              else inc(c);
            end;
         end;

      end;

end;

procedure TForm1.StringGrid1HeaderClick(Sender: TObject; IsColumn: Boolean;
  Index: Integer);
var s,s2 : string;
begin
  s := '';
  s2:='';
  case index of
      0 : if stringgrid1.Columns[1].Visible then
          begin
            stringgrid1.Columns[1].Visible:=false;
            stringgrid1.Columns[0].Width:=stringgrid1.Width - 30;

          end
          else
            begin
              stringgrid1.Columns[1].Visible:=true;
              stringgrid1.Columns[0].Width:=stringgrid1.Width div 2 - 15;
              stringgrid1.Columns[1].Width:=stringgrid1.Width div 2 - 15;
            end;
      1 :  if stringgrid1.Columns[0].Visible then
          begin
            stringgrid1.Columns[0].Visible:=false;
            stringgrid1.Columns[1].Width:=stringgrid1.Width - 30;
          end
          else
            begin
              stringgrid1.Columns[0].Visible:=true;
              stringgrid1.Columns[1].Width:=stringgrid1.Width div 2 - 15;
              stringgrid1.Columns[0].Width:=stringgrid1.Width div 2 - 15;
            end;

  end;
  if memo1.Text <> '' then
  begin
     if stringgrid1.Columns[0].Visible then s := stringgrid1.Cells[0,stringgrid1.Row];
     if stringgrid1.Columns[1].Visible then s2 := stringgrid1.Cells[1,stringgrid1.Row];
     if (s <> '') and (s2 <> '') then
  end;
end;

function  Tform1.convertres(s : string) : string;
var k : string;
    d : string;
    w : string;
    p1,p2 : longint;
begin
{ p1 := pos('"',s);
 while p1 > 0 do
 begin
    Delete(s,p1,1); insert('<i>',s,p1); p1 := pos('"',s);
    if p1 > 0 then
    begin
       Delete(s,p1,1); insert('</i>',s,p1); p1 := pos('"',s);
    end;
 end;

 p1 := pos('''',s);
 while p1 > 0 do
 begin
    Delete(s,p1,1); insert('<font color = "darkcyan">',s,p1); p1 := pos('''',s);
    if p1 > 0 then
    begin
       Delete(s,p1,1); insert('<font color = "black">',s,p1); p1 := pos('''',s);
    end;
 end;
}
 while pos('<br><br>',s) >  0 do
 delete(s,pos('<br><br>',s),4);
 convertres := s;
end;
function TForm1.findd(s : string) : string;
var a : longint;
   idd : byte;
   s2 : string;
begin

end;
Function convertrus2(s : string) : string;
var a,i, j : longint;
    s3,s1,s2: string;
begin
    while pos('лР',s) > 0 do
    begin
      insert('lR',s,pos('лР',s));
      delete(s,pos('лР',s),length('лР'));
    end;
    while pos('лЪ',s) > 0 do
    begin
      insert('lRR',s,pos('лЪ',s));
      delete(s,pos('лЪ',s),length('лЪ'));
    end;
    while pos('ОМ',s) > 0 do
    begin
      insert('LRR',s,pos('ОМ',s));
      delete(s,pos('ОМ',s),length('ОМ'));
    end;
    for i := 1 to 72 do
    begin
      while pos(d[i].itr3,s) > 0 do
      begin
        insert(d[i].deva,s,pos(d[i].itr3,s));
        delete(s,pos(d[i].itr3,s),length(d[i].itr3));

      end;
    end;
    convertrus2 := s;
end;


Function Tform1.convertx(s : string) : string;
var i : byte;
   xc : word;
   zz : boolean;
begin
   zz := false;
   while pos('дж',s) > 0 do
   begin
      insert('j',s,pos('дж',s));
      delete(s,pos('дж',s),length('дж'));
   end;
   while pos('дЖ',s) > 0 do
   begin
      insert('j',s,pos('дЖ',s));
      delete(s,pos('дЖ',s),length('дЖ'));
   end;

   while pos('ж',s) > 0 do
   begin
      insert('j',s,pos('ж',s));
      delete(s,pos('ж',s),length('ж'));
   end;

   for i := 1 to 72 do
   if pos(d[i].itr3,s) > 0 then
   begin
     zz := true;
     break;
   end;
   if zz then s := convertrus2(s);

   for xc := 1 to length(s) do
   begin
    i :=  pos('R^i',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ṛ',s,i);
    end;
    i :=  pos('R^I',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ṝ',s,i);
    end;
    i :=  pos('RR',s);
    if i > 0 then
    begin
      delete(s,i,2);
      insert('ṝ',s,i);
    end;
    i :=  pos('ṛṛ',s);
    if i > 0 then
    begin
      delete(s,i,length('ṛṛ'));
      insert('ṝ',s,i);
    end;



    i :=  pos('R',s);
    if i > 0 then
    begin
      delete(s,i,1);
      insert('ṛ',s,i);
    end;


    i :=  pos('L^i',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ḷ',s,i);
    end;
    i :=  pos('L^I',s);
    if i > 0 then
    begin
      delete(s,i,3);
      insert('ḹ',s,i);
    end;

    i :=  pos('lṛ',s);
    if i > 0 then
    begin
      delete(s,i,length('lṛ'));
      insert('ḷ',s,i);
    end;

    i :=  pos('ḷṛ',s);
    if i > 0 then
    begin
      delete(s,i,length('ḷṛ'));
      insert('ḹ',s,i);
    end;

    i :=  pos('lṝ',s);
    if i > 0 then
    begin
      delete(s,i,length('lṝ'));
      insert('ḹ',s,i);
    end;


     i :=  pos('A',s);
     if i > 0 then
     begin
       delete(s,i,1);

       insert('ā', s,i);
     end;
     i :=  pos('aa',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ā',s,i);
     end;
     i :=  pos('U',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ū',s,i);
     end;
     i :=  pos('uu',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ū',s,i);
     end;
     i :=  pos('I',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ī',s,i);
     end;
     i :=  pos('ii',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ī',s,i);
     end;
     i :=  pos('^N',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ṅ',s,i);
     end;
     i :=  pos('~N',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ṅ',s,i);
     end;
     i :=  pos('G',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṅ',s,i);
     end;
     i :=  pos('~n',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ñ',s,i);
     end;
     i :=  pos('J',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ñ',s,i);
     end;
     i :=  pos('^M',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert(d[51].deva,s,i);
     end;
     i :=  pos('N',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṇ',s,i);
     end;
     i :=  pos('T',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṭ',s,i);
     end;
     i :=  pos('D',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ḍ',s,i);
     end;
     i :=  pos('Sh',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ṣ',s,i);
     end;
     i :=  pos('S',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṣ',s,i);
     end;
     i :=  pos('sh',s);
     if i > 0 then
     begin
       delete(s,i,2);
       insert('ś',s,i);
     end;

     i :=  pos('z',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ś',s,i);
     end;

     i :=  pos('x',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('kṣ',s,i);
     end;
     i :=  pos('M',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ṁ',s,i);
     end;
     i :=  pos('H',s);
     if i > 0 then
     begin
       delete(s,i,1);
       insert('ḥ',s,i);
     end;
end;
    ConvertX := s;
End;

procedure TForm1.StringGrid1Selection(Sender: TObject; aCol, aRow: Integer);
begin

end;

procedure TForm1.StringGrid1SetCheckboxState(Sender: TObject; ACol,
  ARow: Integer; const Value: TCheckboxState);
begin

end;

procedure TForm1.StringGrid2Click(Sender: TObject);
begin
end;

procedure TForm1.StringGrid2DblClick(Sender: TObject);
begin
end;

procedure TForm1.StringGrid3Click(Sender: TObject);
begin
end;

procedure TForm1.StringGrid3DblClick(Sender: TObject);
begin
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  pn1.Hide;
  timer1.Enabled:=false;
end;


procedure TForm1.TrackBar1Change(Sender: TObject);
begin
//  if sender <> Wltrans then
//  memo1.Font.Size:=trackbar1.Position;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
var i : byte;
begin
{  if sender <> speedbutton24 then
  begin
    stringgrid1.Font.Size:=trackbar2.Position;
    stringgrid1.DefaultRowHeight:=trackbar2.Position + 10;;
    for i := 0 to stringgrid1.Columns.Count - 1 do
    stringgrid1.Columns[i].Font := stringgrid1.Font;
  end;
}
end;

procedure TForm1.TrackBar2Click(Sender: TObject);
begin

end;

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin

end;

procedure TForm1.WltransClick(Sender: TObject);
begin
  MenuItem130Click(Sender);
end;

procedure TForm1.YTr1Click(Sender: TObject);
var s,s2 : string;
    i : dword;
begin  s2 := '';
  hw1.CopyToClipboard;
  s := clipboard.AsText;
  for i := 1 to length(s) do
  s2 := s2 + '%'+inttostr(ord(s[i])-12);
  shellexecute(0,'open',
  pchar('https://translate.yandex.ru/?source_lang=en&target_lang=ru&text='+s)
  ,nil,nil,1);




//https://translate.yandex.ru/?source_lang=en&target_lang=ru&text=hi
end;

function Tform1.getletid(s : string) : byte;
var i : byte;
begin i := 0;
      for i := 1 to 51 do
      if (pos('ai',s) <> 1) and
         (pos('au',s) <> 1) and
         (pos('kh',s) <> 1) and
         (pos('gh',s) <> 1) and
         (pos('th',s) <> 1) and
         (pos('dh',s) <> 1) and
         (pos('ch',s) <> 1) and
         (pos('jh',s) <> 1) and
         (pos('ph',s) <> 1) and
         (pos('bh',s) <> 1) and
         (pos('ṭh',s) <> 1) and
         (pos('ḍh',s) <> 1) then
       begin
       if (pos(d[i].deva,s) =  1) or
              (pos(d[i].lipi,s) =  1)
              then break;
       end
       else
       if not (i in [1..12,15,17,20,22,25,27,30,32,35,37]) then
       begin
         if (pos(d[i].deva,s) =  1) or
                (pos(d[i].lipi,s) =  1)
                then break;
       end;
    getletid := i;
end;
function Tform1.Geytrd1(id : longint)  : dword;
var beg, ed : longint; i : longint;
    lim : longint;
    c : longint;
    d1,d2,d3,d4,d5,d6 : boolean;
    s : string;
begin   c := 0;
  s := edit2.Text;
  s := getconv(s);
if checkbox1.Checked = false then progressbar1.Show;
   lim := depo.StringGrid1.RowCount-1;
if (combobox2.ItemIndex in [1,2]) or (checkbox2.Checked) then
begin
  beg := 1;  ed  := depo.stringgrid1.RowCount - 1;
end
else
begin
   if id <> 0 then
   begin
       beg := d[id].beg;
       ed  := d[id].ed;
   end
   else
    begin
     beg := 1;     ed  := depo.stringgrid1.RowCount - 1;
    end;
end;
    stringgrid1.Clear;
    stringgrid1.Rowcount := lim+1;c := 1;
//    stringgrid1.Row:=-1;
    d1 := true; d2 := d1;d3:=d1;d4:=d1;d5:=d1;d6 :=d1;
    case combobox2.itemindex of
         0 : d1 := false;
         1 : d2 := false;
         2 : d3 := false;
         3 : d4 := false
    end;
    if gdicid <> [0] then d5 := false;
    if checkbox6.Checked then d6 := false;
    if id <> 0 then
    begin

    for i := beg to ed do
    if chkword(i,s,d1,d2,d3,d4,d5,d6) then
    begin
       stringgrid1.Rows[c] := depo.StringGrid1.Rows[i];
       inc(c);
       if c > lim then break;
//       if combobox1.ItemIndex = 0 then break;
    end;
    end
    else
    for i := beg to ed do
    if (chkword(i,s,true,true,true,true,d5,d6) and
       (depo.StringGrid1.Cells[1,i] <> ''))then
    begin
       stringgrid1.Rows[c] := depo.StringGrid1.Rows[i];
       inc(c);
    end;


    stringgrid1.RowCount:=c;
    if c > 1 then
    if edit2.Text <> '' then
    begin
      if stringgrid1.Col=9 then stringgrid1.Col:=1;
      stringgrid1.Col:=1;
//      stringgrid1.Row:=0;
//      stringgrid1.Cells[9,1]:='';
    end;
    progressbar1.Hide;
    StatusBarx2.Panels[3].Text:='0';
    if x229 <> 0 then
   StatusBarx2.Panels[1].Text:= lp.StringGrid1.Cells[x229,232] + ' '+
   inttostr(stringgrid1.RowCount - 1);
//    stringgrid1.Col:=9;
   stringgrid1.Columns[10].Visible:=false;
   Geytrd1 := c-1;
   hw1.clear;
end;
function Tform1.isword(s1,s2 : string) : boolean;
var z : boolean;
    p,p1: longint;
begin
   z := false;
   if ww then
   p := pos(lowercase(s2),lowercase(s1))
   else
     p := pos(s2,s1);
   if p > 0 then
   begin
     p1 := length(s2);
     if (p  > 1) and (p + p1 < length(s1)) then
     begin
      if (s1[p-1] in sbl) and (s1[p+p1] in sbl) then z := true;

   end;
    if (p  = 1) and (p + p1 < length(s1)) then
    begin
     if (s1[p+p1] in sbl) then z := true;

  end;
    if  (p >  1) and(p + p1 - 1 = length(s1)) then
    begin
     if (s1[p-1] in sbl) then z := true;
    end;
    if  (p =  1) and(p + p1 - 1 = length(s1)) then z := true;


   end;

   isword := z;
end;
procedure Tform1.getindexes(index : string);
var s : string;
begin
  listbox1.Clear;
  s := index;
  s := s + ' ';
  while pos('  ',s) > 0 do delete(s,pos('  ',s),1);
  if (s <> '') and (s <> ' ') then
  while s <> '' do
  begin
    if pos(' ',s) > 0 then
    begin
       if s <> ' ' then
       listbox1.Items.Add(copy(s,1,pos(' ',s)- 1));
       delete(s,1,pos(' ',s));
    end
    else
    begin
      if (s <> '') and (s <> ' ')  then listbox1.Items.Add(s);
      s := '';
    end;
  end;
end;
procedure Tform1.GetN(n : string; regis : boolean);
var a,i : dword;
    s : string;
    z : boolean;
begin
   if stringgrid1.RowCount > 1 then
   begin
        setlength(ddl,stringgrid1.RowCount - 1);
        a := 0;  s := '';
        for i := 1 to stringgrid1.RowCount - 1 do
        if stringgrid1.Cells[9,i] <> '' then
        begin
           z := false;
           s := lowercase(stringgrid1.Cells[4,i]);
           if pos('*',n) = 0 then
           begin
             if (pos(n,s) > 0) or (n = '') then z := true;
           end
           else
           begin
             case n of
                  '*n'  : if (pos('m.',s) > 0) or
                             (pos('f.',s) > 0) or
                             (pos('n.',s) > 0) then z := true;
                  '*p'  :  if (pos('mf.',s) > 0) or
                             (pos('mfn.',s) > 0) or
                             (pos('partic.',s) > 0) or
                             (pos('mn.',s) > 0) then z := true;
             end;
           end;
          if z then
          begin
           filldlist(strtoint(stringgrid1.Cells[2,i]));
           dlist[1].ID:=strtoint(stringgrid1.Cells[2,i]);
           dlist[1].wd:= stringgrid1.Cells[1,i];
           ddl[a] := dlist;
           inc(a);

          end;

        end;
        Setlength(ddl,a);
        speedbutton27click(nil);
        resform.Caption:='The Search results';
        resform.StatusBar1.Panels[1].Text:= inttostr(resform.CheckListBox2.Items.Count);

   end;
  infx('Results','Total results found: '+inttostr(a));
end;
function Tform1.convertd(s : string) : string;
var a : word;
    i : word;
    k : string;
    prev : byte;
    p : word;
    F : system.Text;
begin
    A1 := '';
    k := ''; prev := 0;
for i  := 1 to length (s) do
    for a := 1 to length(d) do
    begin
       if pos(d[51].deva,s) = 1 then
       begin
         k := k + d[51].lipi;
         delete(s,1,length(d[51].deva));
         p := 0;
       end;
       if pos(d[66].deva,s) = 1   then
       begin
         k := k + d[66].lipi;
         delete(s,1,length(d[66].deva));
         p := 0;
       end;

        p := pos(d[a].deva,s);

      if p = 1 then
      begin

       if (pos('ai',s) <> 1) and (pos('au',s) <> 1) and
         (pos('kh',s) <> 1) and (pos('gh',s) <> 1)  and
         (pos('th',s) <> 1) and (pos('dh',s) <> 1)  and
         (pos('ph',s) <> 1) and (pos('bh',s) <> 1)  and
         (pos('ch',s) <> 1) and (pos('jh',s) <> 1)  and
         (pos('ṭh',s) <> 1) and (pos('ḍh',s) <> 1)
       then
      begin
          if (prev = 0)  then  k := d[a].lipi;
          if (prev in [15..47,70]) and (a in [15..47,70]) then k := k + d[50].lipi + d[a].lipi;
          if (prev in [15..47,70] ) and (a in [1..14]) then k := k  + d[a].Sd;
          if (prev in [1..14]) and (a in [1..51,70]) then k := k + d[a].lipi;
          if (prev in [1..47,70]) and (a in [52..69]) then k := k + d[a].lipi;
          if (prev in [48..51]) and (a in [1..72]) then k := k + d[a].lipi;
          if (prev in [52..69]) and (a in [1..72]) then k := k + d[a].lipi;
          delete(s,1,length(d[a].deva));
          prev := a;

      end
      else
      if a in [13,14,16,18,21,23,26,28,31,33,36,38] then
      begin

        if (prev = 0)  then  k := d[a].lipi;
        if (prev in [15..47]) and (a in [15..47]) then k := k + d[50].lipi + d[a].lipi;
        if (prev in [15..47] ) and (a in [1..14]) then k := k  + d[a].Sd;
        if (prev in [1..14]) and (a in [1..51]) then k := k + d[a].lipi;
        if (prev in [1..47]) and (a in [52..72]) then k := k + d[a].lipi;
        if (prev in [48..51]) and (a in [1..72]) then k := k + d[a].lipi;
        if (prev in [52..72]) and (a in [1..72]) then k := k + d[a].lipi;
        delete(s,1,length(d[a].deva));
        prev := a;

      end;
    end;
    end;
   if (prev > 14) and (prev < 48)  then k := k + d[50].lipi;
prev := 0;
for i  := 1 to length (s) do
    for a := 1 to length(d) do
    begin
      p := pos(d[a].lipi,s);
      if p <> 1 then
      p := pos(d[a].sd,s);
      if p = 1 then
      begin
        if ((prev < 15) and (a > 14)) or
           ((prev > 14) and (a < 15)) or
           ((prev < 15) and (a < 15)) or
           ((a > 51)) or
           ((prev in [48..69]) and (a > 14))
        then k := k + d[a].deva
        else
        if (prev > 14) and (prev in [15..47,70]) and (a <> 50) and (a > 14) then k := k + 'a' +d[a].deva
        else
         if (prev = 50) and (a > 14) then k := k + d[a].deva;
         delete(s,1,length(d[a].lipi));
        if (s = '') and (a > 14) and (a in [1..47,70]) then k := k + 'a';
         prev := a;
      end;
    end;
    if k = ''then k := s;
    convertd := k;
end;
function Tform1.converti(s : string) : string;
var a, i : word;
    s2 : string;
    x : word;
    z : boolean;
begin  s2 := '';   z := false;
   x := length(s);
   for i :=  1 to x do
   begin
      for a := 1 to 62 do
      if (pos(d[a].deva,s) = 1)
      then
      begin
        s2 := s2 + d[a].itr;
        delete(s,1,length(d[a].deva));
        z := true;
      end;
   if pos(#32,s) = 1 then s2 := s2 + ' ';
   if s <> '' then
   if s[1] in ['1'..'9','0','.',','] then s2 := s2 + s[1];
   if z = false then delete(s,1,1);
   if z then z := false;
  end;
   if s2 = '' then s2 := s;
   converti := s2;
end;
function Tform1.askapte(s : string) : string;
var i : word;
    k : string;
    z : boolean;
begin   z := false;
{        k := '';

    for i := 0 to apte.Memo1.Lines.Count - 1 do
    begin
      k := apte.Memo1.Lines.Strings[i];
      k := copy(k,1,pos(' ',k) - 1);
      if k = s then
      begin
        z := true;
        askapte :=  'Apte, Vaman Shivaram: The Practical Sanskrit-English Dictionary. Poona : 1890' + #13+#10+
        apte.Memo1.Lines.Strings[i];
        break;
      end;
    end;
    if z = false then
}
    askapte := '';
end;
function TForm1.askpwb(s : string) : string;
var b,e : longint;
begin

end;





function Tform1.printdl1 : string;
var i,j : longint;
    s : string;
    df: dword;
begin
//    j := hw1.DefFontSize;
    s := '';  df := 0;
    for i := 1 to length(dlist) do
    if dlist[dar[i]].en then
    begin
       if dlist[dar[i]].DDesc <> '' then
       begin
          s := s + '</font><font color = "black">'+ CDname(dlist[dar[i]].DName)+'<br>' +
               convertres(dlist[dar[i]].DDesc)+'<p>';
          inc(df,dlist[dar[i]].df);
       end;
    end;
    if dlist[1].df > 0 then speedbutton14.Font.Bold:=true else speedbutton14.Font.Bold:=false;
    if dlist[2].df > 0 then speedbutton33.Font.Bold:= true else speedbutton33.Font.Bold:=false;
    if dlist[13].df > 0 then speedbutton32.Font.Bold:= true else speedbutton32.Font.Bold:=false;
    if dlist[7].df > 0 then speedbutton31.Font.Bold:= true else speedbutton31.Font.Bold:=false;
    if dlist[6].df > 0 then speedbutton30.Font.Bold:= true else speedbutton30.Font.Bold:=false;
    if dlist[5].df > 0 then speedbutton19.Font.Bold:= true else speedbutton19.Font.Bold:=false;
    if dlist[3].df > 0 then speedbutton37.Font.Bold:= true else speedbutton37.Font.Bold:=false;
    if dlist[17].df > 0 then speedbutton44.Font.Bold:= true else speedbutton44.Font.Bold:=false;
    if dlist[14].df > 0 then speedbutton34.Font.Bold:= true else speedbutton34.Font.Bold:=false;
    if dlist[16].df > 0 then speedbutton39.Font.Bold:= true else speedbutton39.Font.Bold:=false;
    if dlist[15].df > 0 then speedbutton38.Font.Bold:= true else speedbutton38.Font.Bold:=false;
    if dlist[9].df > 0 then speedbutton43.Font.Bold:= true else speedbutton43.Font.Bold:=false;
    if dlist[8].df > 0 then speedbutton36.Font.Bold:= true else speedbutton36.Font.Bold:=false;
    if dlist[4].df > 0 then speedbutton42.Font.Bold:= true else speedbutton42.Font.Bold:=false;

    if dlist[11].df > 0 then speedbutton40.Font.Bold:= true else speedbutton40.Font.Bold:=false;
    if dlist[12].df > 0 then speedbutton35.Font.Bold:= true else speedbutton35.Font.Bold:=false;
    if dlist[10].df > 0 then speedbutton41.Font.Bold:= true else speedbutton41.Font.Bold:=false;




    printdl1 := s;
end;
function tform1.printdl2 : string;
var i,x : longint;
    k : longint;
    s : string;
begin
    s := '';
    x := 1500000;
    stringgrid2.RowCount:=x;
    x  := 0;
    for k := 0 to length(ddl) -1 do
    for i := 1 to length(ddl[k])  do
    if ddl[k,i].en then
    begin
       if ddl[k,i].DDesc <> '' then
       begin

         stringgrid2.Cells[0,x] := ddl[k,i].DName;

         stringgrid2.Cells[0,x + 1] := convertres(ddl[k,i].DDesc);


         inc(x,2);

       end;

    end;
    stringgrid2.RowCount:=x;
    if x < 20000 then
       s :=  stringgrid2.cols[0].Text
       else
       begin
         infx('Too big data!','You can save the result to a file');
         savedialog1.FileName:=edit3.Text;
         if savedialog1.Execute then
         begin
            stringgrid2.Cols[0].SaveToFile(savedialog1.FileName);
            if form1.CheckBox7.Checked then
            shellexecute(0,'Open',pchar(savedialog1.FileName),'',nil,1);
            s := 'The result has been saved to: '+ savedialog1.FileName;

         end
         else s := 'No Result';
       end;

       printdl2 := s;
end;
procedure TForm1.Geytrd2(b,e  :  longint);
var beg, ed : longint; i : longint;
    lim : longint;
    c : longint;
    se, sl1: string;
    l1,l2 : longint;
begin   c := 0;
if b = 0 then
if e = 0 then
begin
  stringgrid1.RowCount:=dp.ListBox1.Count;
  for i := 1 to dp.ListBox1.Items.Count - 1 do
  begin
     stringgrid1.Cells[1,i] := dp.ListBox1.Items[i];
     stringgrid1.Cells[2,i] := inttostr(i);
     stringgrid1.Cells[0,i] := '';
  end;
  StatusBarx2.Panels[1].Text:= lp.StringGrid1.Cells[x229,232] + ' '+
  inttostr(stringgrid1.RowCount - 1);

  exit;
end;
if checkbox1.Checked = false then progressbar1.Show;
lim := dp.ListBox1.Count;
if combobox2.ItemIndex in [1,2] then
begin
  b := 1;
  e  := dp.ListBox1.Items.Count - 1;
end;
    stringgrid1.Rowcount := lim+1;
    for i := b to e do
    begin
    if combobox2.ItemIndex = 0 then
    begin
      if (pos(edit2.Text,dp.listbox1.Items[i]) = 1) then
    begin
      inc(C);
      if c <= lim then
      begin
         stringgrid1.Cells[0,c] := '';
         stringgrid1.Cells[1,c] := dp.listbox1.Items[i];
         stringgrid1.Cells[2,c] := inttostr(i);
      end
      else break;
    end;
   End;
       if combobox2.ItemIndex = 1 then
       begin
        if (pos(edit2.Text,dp.listbox1.Items[i]) > 1) then
        begin
          inc(C);
          if c <= lim then
          begin
             stringgrid1.Cells[0,c] := '';
             stringgrid1.Cells[1,c] := dp.listbox1.Items[i];
             stringgrid1.Cells[2,c] := inttostr(i);
          end
          else break;
        end;
       end;
       if combobox2.ItemIndex = 3 then
       begin
        if (edit2.Text = dp.listbox1.Items[i]) then
        begin
          inc(C);
          if c <= lim then
          begin
             stringgrid1.Cells[0,c] := '';
             stringgrid1.Cells[1,c] := dp.listbox1.Items[i];
             stringgrid1.Cells[2,c] := inttostr(i);
          end
          else break;
        end;
    end;
   if combobox2.ItemIndex = 2 then
   begin
     if pos(edit2.Text + ' ',dp.ListBox1.Items[i]+' ') > 0   then
     begin
         inc(C);
         if c <= lim then
         begin
            stringgrid1.Cells[0,c] := '';
            stringgrid1.Cells[1,c] := dp.listbox1.Items[i];
            stringgrid1.Cells[2,c] := inttostr(i);
//            if combobox1.ItemIndex = 0 then break;
         end
         else
          break;
      end;
     end;
    End;
    stringgrid1.RowCount:= c+1;
    SelCnt;
    StatusBarx2.Panels[1].Text:= lp.StringGrid1.Cells[x229,232] + ' '+
    inttostr(stringgrid1.RowCount - 1);
    stringgrid1.Columns[10].Visible:=false;
end;
procedure tform1.sgw;
var  i,j : longint;
begin
     i := stringgrid1.Width;
     if combobox3.ItemIndex = 1 then
     begin
        for j := 0 to stringgrid1.ColCount - 1 do
        if j <> 1 then stringgrid1.Columns[j].Visible := false;
        stringgrid1.Columns[1].Width:=i - 32

     end
     else
     begin
         for j := 0 to stringgrid1.ColCount - 1 do
         if not (j in [2,3,10]) then stringgrid1.Columns[j].Visible:=true;
        for j :=  0 to stringgrid1.ColCount - 1 do
        if stringgrid1.Columns[j].Visible then
        stringgrid1.Columns[j].Width:=(i - 32) div 8;
     end;
     SpeedButton28Click(nil);
end;
procedure Tform1.FillDlist(sx : longint);
var x,y  : dword;
    s : string;
begin
for y := 1 to dset.checklistbox1.Items.Count do  dlist[y].en:=dset.checklistbox1.Checked[y - 1];
for y := 9 to 11 do    dlist[y + 1].en:=dset.checklistbox2.Checked[y - 9];

for y := 1 to length(dlist) do
begin dlist[y].DDesc:='';dlist[y].df:=0;end;
for y := 13 to length(dlist) do
dlist[y].en:=dset.checklistbox1.Checked[y - 4];
for y := 1 to length(dlist) do dlist[y].ID:=0;

if combobox3.ItemIndex = 1 then
begin
   for y := Ewlidx[1,sx] to Ewlidx[2,sx] do
   begin
        s := dp.memo1.lines.strings[Edbidx[y]-1];
        FDL(s,sx);
  end;
end
else
for y := wlidx[1,sx] to wlidx[2,sx] do
begin
     s := depo.memo1.lines.strings[dbidx[y]-1];
     FDL(s,sx);
  end;
 end;

 procedure tform1.GetExam(i : string; vf,vfi,c1,nx,g1 : longint);
 var s,s1,s2,s3,s4,s5 : string;
     j,c,k,m : longint;
     v1,v2,c2,nxx,g2 : boolean;
     lxid,stid,p1,p2,v3,v4,c3,nx3,g3 : string;
     kk : longint;
     op, op2 : string;
 begin
 wr.Memo1.Clear;
 lxid := '';
 stid  := '';
 p1 := '';
 p2 := '';
 v3 := '';
 v4 := '';
 c3 := '';
 nx3 := '';
 g3 := '';



      c := 1;
      k := 0;
      if i <> '' then
      begin
        listbox1.Clear;
        s := i;
        while s <> '' do
        begin
          listbox1.Items.Add(copy(s,1,pos(' ',s) - 1));
          delete(s,1,pos(' ',s));
        end;
        wr.StringGrid1.clear;
        wr.StringGrid1.RowCount:=200000;

        for kk := 0 to listbox1.Items.Count - 1 do
        begin
          s := dcs1.ListBox4.Items[strtoint(listbox1.Items[kk])];
          while s <> '' do
          begin
//            wr.StringGrid1.RowCount:=c+1;
            s1 := copy(s,1,pos(' ',s) - 1);
            delete(s,1,pos(' ',s));
            s2 := dcs1.ListBox5.Items[strtoint(s1)];

            lxid := copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));

            stid:= copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));

            p1:= copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));

            p2:= copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));

            v3 := copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));

            v4:= copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));

            op2:= copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));

            op:= copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));




            c3:= copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));

            nx3 := copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));

            g3 := copy(s2,1,pos(',',s2) - 1);
            delete(s2,1,pos(',',s2));

{
            while pos(';',g3) > 0 do  delete(g3,pos(';',g3),1);
            while pos(',',g3) > 0 do  delete(g3,pos(',',g3),1);
            while pos(':',g3) > 0 do  delete(g3,pos(':',g3),1);
            while pos(')',g3) > 0 do  delete(g3,pos(')',g3),1);
}

//            copy(s2,1,pos(',',s2) - 1);
//            delete(s2,1,pos(',',s2));
            v1 := true; v2:= true;c2:= true;nxx:= true;g2:= true;

            if vf <> 0 then if inttostr(vf) <> v3 then v1 := false;
            if vfi <> 0 then if inttostr(vfi) <> v4 then v2 := false;
            if c1 <> 0 then if inttostr(c1) <> c3 then c2 := false;
            if nx <> 0 then if inttostr(nx) <> nx3 then nxx := false;
            if g1 <> 0 then if inttostr(g1) <> g3 then g2 := false;





            if v1 and v2 and c2 and nxx and g2 then
            begin

               wr.StringGrid1.Cells[0,c] := lxid;//copy(s2,1,pos(',',s2) - 1);
               delete(s2,1,pos(',',s2));

               wr.StringGrid1.Cells[1,c] := stid;//copy(s2,1,pos(',',s2) - 1);
               delete(s2,1,pos(',',s2));

               wr.StringGrid1.Cells[2,c] := p1;//copy(s2,1,pos(',',s2) - 1);

               wr.StringGrid1.Cells[3,c] := p2;//copy(s2,1,pos(',',s2) - 1);


               wr.StringGrid1.Cells[4,c] := v3;//copy(s2,1,pos(',',s2) - 1);

               wr.StringGrid1.Cells[5,c] := v4;//copy(s2,1,pos(',',s2) - 1);


               wr.StringGrid1.Cells[6,c] := c3;//copy(s2,1,pos(',',s2) - 1);

               wr.StringGrid1.Cells[7,c] := nx3;//copy(s2,1,pos(',',s2) - 1);

               if g1 <> 0 then
               wr.StringGrid1.Cells[8,c] := inttostr(g1)

               else
               wr.StringGrid1.Cells[8,c] := g3;


               wr.StringGrid1.Cells[9,c] :=op2;

               wr.StringGrid1.Cells[10,c] :=
               lx[strtoint(stid)].ln;

               wr.StringGrid1.Cells[11,c] := wr.GetGF(c);

               j := strtoint(wr.StringGrid1.Cells[1,c]);
               s2 := tx[strtoint(cp[strtoint(lx[j].cid)].tid)].tn + ' ' +
                  cp[strtoint(lx[j].cid)].cn + '#'+ lx[j].st + ' ' + lx[j].pd;

               wr.StringGrid1.Cells[12,c] := s2;


            if length(snt[j]) > 0 then
            for m := 0 to length(snt[j]) - 1 do
            if strtoint(snt[j,m].osn) < dcs1.ListBox8.Items.Count then
            if  strtoint(dcs1.ListBox8.Items[
            strtoint(snt[j,m].osn)]) < 20000 then
            inc(k,
            strtoint(dcs1.ListBox8.Items[
            strtoint(snt[j,m].osn)]));

            wr.StringGrid1.Cells[13,c] := inttostr(k div (m+1));

             inc(c);


//            if c > 10000 then break;
            k := 0;

            end;
          end;
        end;

        wr.Caption:='Word Reference for: "'+stringgrid1.Cells[1,stringgrid1.Row]+'". Total Examples: '+inttostr(c- 1);
      end;
      wr.StringGrid1.RowCount:=c;

end;
 Function Tform1.GetVerbal(v : longint) : string;
 var s,s1,s2 : string;
     i,j,k : longint;
     id : string;
     lxid : string;
     vf   : string;
     vfi  : string;
     ts   : string;
     np   : string;
     an   : string;
 begin
{
 k  := vforms.StringGrid1.RowCount;
 id := '';
 lxid := '';
 vf := '';
 vfi := '';
 ts := '';
 np := '';
 ts := '';
 an := '';

     for i := 0 to dcs1.ListBox6.Items.Count - 1 do
     if dcs1.ListBox6.Items[i] <> '' then
     begin
       s := dcs1.ListBox6.Items[i];




       id := copy(s,1,pos(',',s)-1);
       delete(s,1,pos(',',s));
       lxid := copy(s,1,pos(',',s)-1);

       if v = strtoint(lxid) then
       begin
        delete(s,1,pos(',',s));
        vf := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));
        ts := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));
        np := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));
         inc(k);
         VForms.stringgrid1.RowCount:=k;

         vforms.stringGrid1.cells[0,k-1] := vf;
         vforms.stringGrid1.cells[1,k-1] := wr.getnp1(np);
         vforms.stringGrid1.cells[2,k-1] := wr.getnp2(np);
         vforms.stringGrid1.cells[3,k-1] := wr.GetTense(ts);
         vforms.stringGrid1.cells[4,k-1] := '?';
         vforms.stringGrid1.cells[5,k-1] := id;
         vforms.stringGrid1.cells[6,k-1] := lxid;
       end;
     end;

     k  := vforms.StringGrid2.RowCount;
     id := '';
     lxid := '';
     vf := '';
     vfi := '';
     ts := '';
     np := '';
     ts := '';
     an := '';


     for i := 0 to dcs1.ListBox7.Items.Count - 1 do
     if dcs1.ListBox7.Items[i] <> '' then
     begin
       s := dcs1.ListBox7.Items[i];
       id := copy(s,1,pos(',',s)-1);
       delete(s,1,pos(',',s));
       lxid := copy(s,1,pos(',',s)-1);

       if v = strtoint(lxid) then
       begin
        delete(s,1,pos(',',s));
        vf := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));
        vfi := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));
        ts := copy(s,1,pos(',',s)-1);
        delete(s,1,pos(',',s));
         inc(k);
         VForms.stringgrid2.RowCount:=k;

         vforms.stringGrid2.cells[0,k-1] := vf;
         vforms.stringGrid2.cells[1,k-1] := vfi;
         vforms.stringGrid2.cells[2,k-1] := wr.GetTense(ts);
         vforms.stringGrid2.cells[3,k-1] := id;
         vforms.stringGrid2.cells[4,k-1] := lxid;
//         vforms.stringGrid2.cells[5,k-1] := an;
       end;
     end;
//     vforms.show;
}
     GetVerbal := '';
 end;
 procedure tform1.Ldd;
 begin
   d[1].deva := 'a';
  d[1].itr4v:='а';
  d[1].beg:= 1;
  d[1].ed:=24709;
  d[1].lipi:='अ';
  d[1].Sd:='';
  d[1].itr:='a';
  d[1].lng:= 1;
  d[1].snd:='a.wav';
  d[1].itr2:='a';
  d[1].itr3:='а';

  d[2].deva := 'ā';
  d[2].itr4v:='а';
  d[2].beg:=  24710;
  d[2].ed:= 30756;
  d[2].lipi:='आ';
  d[2].Sd:='ा';
  d[2].itr:='A';
  d[2].lng:= 2;
  d[2].snd:='a1.wav';
  d[2].itr2:='aa';
  d[2].itr3:='А';

  d[3].deva := 'i';
  d[3].itr4v:='и';
  d[3].beg:=  30757;
  d[3].ed:= 26737;
  d[3].lipi:='इ';
  d[3].Sd:='ि';
  d[3].itr:='i';
  d[3].lng:= 1;
  d[3].snd:='i.wav';
  d[3].itr2:='i';
  d[3].itr3:='и';

  d[4].deva := 'ī';
  d[4].itr4v:='и';
  d[4].beg:= 26738;
  d[4].ed:= 26999;
  d[4].lipi:='ई';
  d[4].Sd:='ी';
  d[4].itr:='I';
  d[4].lng:= 2;
  d[4].snd:='ii.wav';
  d[4].itr2:='ii';
  d[4].itr3:='И';

  d[5].deva := 'u';
  d[5].itr4v:='у';
  d[5].beg := 27000;
  d[5].ed:= 33138;
  d[5].lipi:='उ';
  d[5].Sd:='ु';
  d[5].itr:='u';
  d[5].lng:= 1;
  d[5].snd:='u.wav';
  d[5].itr2:='u';
  d[5].itr3:='у';

  d[6].deva := 'ū';
  d[6].itr4v:='у';
  d[6].beg:= 33139;
  d[6].ed:= 33535;
  d[6].lipi:='ऊ';
  d[6].Sd:='ू';
  d[6].itr:='U';
  d[6].lng:= 2;
  d[6].snd:='u2.wav';
  d[6].itr2:='uu';
  d[6].itr3:='У';

  d[11].deva := 'e';
  d[11].itr4v:='е';
  d[11].beg:=  34127;
  d[11].ed:= 34976;
  d[11].lipi:='ए';
  d[11].Sd:='े';
  d[11].itr:='e';
  d[11].lng:= 2;
  d[11].snd:='e.wav';
  d[11].itr2:='e';
  d[11].itr3:='е';

  d[12].deva := 'o';
  d[12].itr4v:='о';
  d[12].beg:=  34977;
  d[12].ed:= 35178;
  d[12].lipi:='ओ';
  d[12].Sd:='ो';
  d[12].itr:='o';
  d[12].lng:= 2;
  d[12].snd:='o.wav';
  d[12].itr2:='o';
  d[12].itr3:='о';

  d[13].deva := 'ai';
  d[13].itr4v:='ай';
  d[13].beg:=  35179;
  d[13].ed:= 35462;
  d[13].lipi:='ऐ';
  d[13].Sd:='ै';
  d[13].itr:='ai';
  d[13].lng:= 2;
  d[13].snd:='ai.wav';
  d[13].itr2:='ai';
  d[13].itr3:='аи';

  d[14].deva := 'au';
  d[14].itr4v:='ау';
  d[14].beg  :=  35463;
  d[14].ed   := 35972;
  d[14].lipi:='औ';
  d[14].Sd:='ौ';
  d[14].itr:='au';
  d[14].lng:= 2;
  d[14].snd:='au.wav';
  d[14].itr2:='au';
  d[14].itr3:='ау';

  d[7].deva := 'ṛ';
  d[7].itr4v:='ри';
  d[7].beg  :=  33536;
  d[7].ed   := 34117;
  d[7].lipi:='ऋ';
  d[7].Sd:='ृ';
  d[7].itr:='R^i';
  d[7].lng:= 1;
  d[7].snd:='r1.wav';
  d[7].itr2:='R';
  d[7].itr3:='Р';

  d[8].deva := 'ṝ';
  d[8].itr4v:='ри';
  d[8].beg  :=  34118;
  d[8].ed   := 34119;
  d[8].lipi:='ॠ';
  d[8].Sd:='ॄ';
  d[8].itr:='R^I';
  d[8].lng:= 2;
  d[8].snd:='r2.wav';
  d[8].itr2:='RR';
  d[8].itr3:='Ъ';

  d[9].deva := 'ḷ';
  d[9].itr4v:='ли';
  d[9].beg  :=  34120;
  d[9].ed   := 34125;
  d[9].lipi:='ऌ';
  d[9].Sd:='ॢ';
  d[9].itr:='L^i';
  d[9].lng:= 1;
  d[9].snd:='l1.wav';
  d[9].itr2:='LR';
  d[9].itr3:='лР';


  d[10].deva := 'ḹ';
  d[10].itr4v:='ли';
  d[10].beg  :=  34126;
  d[10].ed   := 34126;
  d[10].lipi:='ॡ';
  d[10].Sd:='ॣ';
  d[10].itr:='L^I';
  d[10].lng:= 2;
  d[10].snd:='l2.wav';
  d[10].itr2:='LRR';
  d[10].itr3:='лЪ';

  d[15].deva := 'k';
  d[15].itr4v:='к';
  d[15].beg  :=  35976;
  d[15].ed   := 50413;
  d[15].lipi:='क';
  d[15].Sd:='';
  d[15].itr:='k';
  d[15].lng:= 0.25;
  d[15].snd:='ka.wav';
  d[15].itr2:='k';
  d[15].itr3:='к';

  d[16].deva := 'kh';
  d[16].itr4v:='кх';
  d[16].beg  :=  50414;
  d[16].ed   := 51592;
  d[16].lipi:='ख';
  d[16].itr:='kh';
  d[16].lng:= 0.5;
  d[16].snd:='kha.wav';
  d[16].itr2:='kh';
  d[16].itr3:='кх';

  d[17].deva := 'g';
  d[17].itr4v:='г';
  d[17].beg  :=  51593;
  d[17].ed   := 56817;
  d[17].lipi:='ग';
  d[17].itr:='g';
  d[17].lng:= 0.25;
  d[17].snd:='ga.wav';
  d[17].itr2:='g';
  d[17].itr3:='г';

  d[18].deva := 'gh';
  d[18].itr4v:='гх';
  d[18].beg  :=  56818;
  d[18].ed   := 57623;
  d[18].lipi:='घ';
  d[18].itr:='gh';
  d[18].lng:= 0.5;
  d[18].snd:='gha.wav';
  d[18].itr2:='gh';
  d[18].itr3:='гх';

  d[19].deva := 'ṅ';
  d[19].itr4v:='н';
  d[19].beg  := 57624;
  d[19].ed   := 57628;
  d[19].lipi:='ङ';
  d[19].itr:='~N';
  d[19].lng:= 0.25;
  d[19].snd:='nga.wav';
  d[19].itr2:='G';
  d[19].itr3:='Г';

  d[20].deva := 'ṭ';
  d[20].itr4v:='т';
  d[20].beg  := 57629;
  d[20].ed   := 57776;
  d[20].lipi:='ट';
  d[20].itr:='T';
  d[20].lng:= 0.25;
  d[20].snd:='ta1.wav';
  d[20].itr2:='T';
  d[20].itr3:='Т';


  d[21].deva := 'ṭh';
  d[21].itr4v:='тх';
  d[21].beg  := 57777;
  d[21].ed   := 57797;
  d[21].lipi:='ठ';
  d[21].itr:='Th';
  d[21].lng:= 0.5;
  d[21].snd:='tha1.wav';
  d[21].itr2:='Th';
  d[21].itr3:='Тх';


  d[22].deva := 'ḍ';
  d[22].itr4v:='д';
  d[22].beg  := 57798;
  d[22].ed   := 57963;
  d[22].lipi:='ड';
  d[22].itr:='D';
  d[22].lng:= 0.25;
  d[22].snd:='da1.wav';
  d[22].itr2:='D';
  d[22].itr3:='Д';

  d[23].deva := 'ḍh';
  d[23].itr4v:='дх';
  d[23].beg  := 57964;
  d[23].ed   := 58004;
  d[23].lipi:='ढ';
  d[23].itr:='Dh';
  d[23].lng:= 0.5;
  d[23].snd:='dha1.wav';
  d[23].itr2:='Dh';
  d[23].itr3:='Дх';


  d[24].deva := 'ṇ';
  d[24].itr4v:='н';
  d[24].beg  := 58005;
  d[24].ed   := 58016;
  d[24].lipi:='ण';
  d[24].itr:='N';
  d[24].lng:= 0.25;
  d[24].snd:='na.wav';
  d[24].itr2:='N';
  d[24].itr3:='Н';

  d[25].deva := 'c';
  d[25].itr4v:='ч';
  d[25].beg  := 58017;
  d[25].ed   := 61956;
  d[25].lipi:='च';
  d[25].itr:='c';
  d[25].lng:= 0.25;
  d[25].snd:='ca.wav';
  d[25].itr2:='c';
  d[25].itr3:='ч';

  d[26].deva := 'ch';
  d[26].itr4v:='чх';
  d[26].beg  := 61957;
  d[26].ed   := 62537;
  d[26].lipi:='छ';
  d[26].itr:='Ch';
  d[26].lng:= 0.5;
  d[26].snd:='cha.wav';
  d[26].itr2:='ch';
  d[26].itr3:='чх';

  d[27].deva := 'j';
  d[27].itr4v:='дж';
  d[27].beg  := 62538;
  d[27].ed   := 66186;
  d[27].lipi:='ज';
  d[27].itr:='j';
  d[27].lng:= 0.25;
  d[27].snd:='ja.wav';
  d[27].itr2:='j';
  d[27].itr3:='Ж';

  d[28].deva := 'jh';
  d[28].itr4v:='джх';
  d[28].beg  := 66187;
  d[28].ed   := 66390;
  d[28].lipi:='झ';
  d[28].itr:='jh';
  d[28].lng:= 0.5;
  d[28].snd:='jha.wav';
  d[28].itr2:='jh';
  d[28].itr3:='Жх';

  d[29].deva := 'ñ';
  d[29].itr4v:='н';
  d[29].beg  := 66391;
  d[29].ed   := 66393;
  d[29].lipi:='ञ';
  d[29].itr:='~n';
  d[29].lng:= 0.25;
  d[29].snd:='~na.wav';
  d[29].itr2:='J';
  d[29].itr3:='Ь';

  d[30].deva := 't';
  d[30].itr4v:='т';
  d[30].beg  := 66394;
  d[30].ed   := 72283;
  d[30].lipi:='त';
  d[30].itr:='t';
  d[30].lng:= 0.25;
  d[30].snd:='ta.wav';
  d[30].itr2:='t';
  d[30].itr3:='т';

  d[31].deva := 'th';
  d[31].itr4v:='тх';
  d[31].beg  := 72284;
  d[31].ed   := 72313;
  d[31].lipi:='थ';
  d[31].itr:='th';
  d[31].lng:= 0.5;
  d[31].snd:='tha.wav';
  d[31].itr2:='th';
  d[31].itr3:='тх';

  d[32].deva := 'd';
  d[32].itr4v:='д';
  d[32].beg  := 72314;
  d[32].ed   := 80441;
  d[32].lipi:='द';
  d[32].itr:='d';
  d[32].lng:= 0.25;
  d[32].snd:='da.wav';
  d[32].itr2:='d';
  d[32].itr3:='д';

  d[33].deva := 'dh';
  d[33].itr4v:='дх';
  d[33].beg  := 80442;
  d[33].ed   := 82940;
  d[33].lipi:='ध';
  d[33].itr:='dh';
  d[33].lng:= 0.5;
  d[33].snd:='dha.wav';
  d[33].itr2:='dh';
  d[33].itr3:='дх';

  d[34].deva := 'n';
  d[34].itr4v:='н';
  d[34].beg  := 82941;
  d[34].ed   := 91405;
  d[34].lipi:='न';
  d[34].itr:='n';
  d[34].lng:= 0.25;
  d[34].snd:='n1.wav';
  d[34].itr2:='n';
  d[34].itr3:='н';

  d[35].deva := 'p';
  d[35].itr4v:='пх';
  d[35].beg  := 91406;
  d[35].ed   := 113723;
  d[35].lipi:='प';
  d[35].itr:='p';
  d[35].lng:= 0.25;
  d[35].snd:='pa.wav';
  d[35].itr2:='p';
  d[35].itr3:='п';

  d[36].deva := 'ph';
  d[36].itr4v:='пх';
  d[36].beg  := 113724;
  d[36].ed   := 114310;
  d[36].lipi:='फ';
  d[36].itr:='ph';
  d[36].lng:= 0.5;
  d[36].snd:='pha.wav';
  d[36].itr2:='ph';
  d[36].itr3:='пх';

  d[37].deva := 'b';
  d[37].itr4v:='б';
  d[37].beg  := 114311;
  d[37].ed   := 118443;
  d[37].lipi:='ब';
  d[37].itr:='b';
  d[37].lng:= 0.25;
  d[37].snd:='ba.wav';
  d[37].itr2:='b';
  d[37].itr3:='б';

  d[38].deva := 'bh';
  d[38].itr4v:='бх';
  d[38].beg  := 118444;
  d[38].ed   := 123231;
  d[38].lipi:='भ';
  d[38].itr:='bh';
  d[38].lng:= 0.5;
  d[38].snd:='bha.wav';
  d[38].itr2:='bh';
  d[38].itr3:='бх';

  d[39].deva := 'm';
  d[39].itr4v:='м';
  d[39].beg  := 123232;
  d[39].ed   := 134759;
  d[39].lipi:='म';
  d[39].itr:='m';
  d[39].lng:= 0.25;
  d[39].snd:='ma.wav';
  d[39].itr2:='m';
  d[39].itr3:='м';

  d[40].deva := 'y';
  d[40].itr4v:='й';
  d[40].beg  := 134760;
  d[40].ed   := 138155;
  d[40].lipi:='य';
  d[40].itr:='y';
  d[40].lng:= 0.25;
  d[40].snd:='ya.wav';
  d[40].itr2:='y';
  d[40].itr3:='й';

  d[41].deva := 'r';
  d[41].itr4v:='р';
  d[41].beg  := 138156;
  d[41].ed   := 143517;
  d[41].lipi:='र';
  d[41].itr:='r';
  d[41].lng:= 0.25;
  d[41].snd:='ra.wav';
  d[41].itr2:='r';
  d[41].itr3:='р';

  d[42].deva := 'l';
  d[42].itr4v:='л';
  d[42].beg  := 143518;
  d[42].ed   := 146484;
  d[42].lipi:='ल';
  d[42].itr:='l';
  d[42].lng:= 0.25;
  d[42].snd:='la.wav';
  d[42].itr2:='l';
  d[42].itr3:='л';

  d[43].deva := 'v';
  d[43].itr4v:='в';
  d[43].beg  := 146485;
  d[43].ed   := 165477;
  d[43].lipi:='व';
  d[43].itr:='v';
  d[43].lng:= 0.25;
  d[43].snd:='va.wav';
  d[43].itr2:='v';
  d[43].itr3:='в';

  d[44].deva := 'ṣ';
  d[44].itr4v:='ш';
  d[44].beg  := 165478;
  d[44].ed   := 166063;
  d[44].lipi:='ष';
  d[44].itr:='S';
  d[44].lng:= 0.25;
  d[44].snd:='sh.wav';
  d[44].itr2:='Sh';
  d[44].itr3:='Ш';

  d[45].deva := 'ś';
  d[45].itr4v:='ш';
  d[45].beg  := 166064;
  d[45].ed   := 176545;
  d[45].lipi:='श';
  d[45].itr:='sh';
  d[45].lng:= 0.25;
  d[45].snd:='sha.wav';
  d[45].itr2:='z';
  d[45].itr3:='ш';

  d[46].deva := 's';
  d[46].itr4v:='с';
  d[46].beg  := 176546;
  d[46].ed   := 201633;
  d[46].lipi:='स';
  d[46].itr:='s';
  d[46].lng:= 0.25;
  d[46].snd:='sa.wav';
  d[46].itr2:='s';
  d[46].itr3:='с';

  d[47].deva := 'h';
  d[47].itr4v := 'х';
  d[47].beg  := 201634;
  d[47].ed   := 205626;
  d[47].lipi:='ह';
  d[47].itr:='h';
  d[47].lng:= 0.25;
  d[47].snd:='ha.wav';
  d[47].itr2:='h';
  d[47].itr3:='х';

  d[48].deva := 'ṁ';
  d[48].itr4v := 'м';
  d[48].beg  := 0;
  d[48].ed   := 0;
  d[48].lipi:='ं';
  d[48].Sd:='ं';;
  d[48].itr:='M';
  d[48].lng:= 0.25;
  d[48].snd:='';
  d[48].itr3:='М';

  d[49].deva := 'ḥ';
  d[49].itr4v := 'х';
  d[49].Sd:='ः';
  d[49].beg  := 0;
  d[49].ed   := 0;
  d[49].lipi:='ः';
  d[49].itr:='H';
  d[49].lng:= 0.25;
  d[49].snd:='';
  d[49].itr3:='Х';

  d[50].lipi:='्';
  d[50].deva:='';
  d[50].beg:=0;
  d[50].ed:=0;
  d[50].itr:='';
  d[50].lng:= 0.25;
  d[50].snd:='';

  d[51].lipi:='ँ';
  d[51].itr4v := 'н';
  d[51].deva:='m̩';
  d[51].beg:=0;
  d[51].ed:=0;
  d[51].itr:='^M';
  d[51].lng:= 0.25;
  d[51].snd:='';

  d[52].lipi:='०';
  d[52].deva:='0';
  d[52].itr:='0';
  d[52].lng:= 0.25;

  d[53].lipi:='१';
  d[53].deva:='1';
  d[53].itr:='1';
  d[53].lng:= 0.25;

  d[54].lipi:='२';
  d[54].deva:='2';
  d[54].itr:='2';
  d[54].lng:= 0.25;

  d[55].lipi:='३';
  d[55].deva:='3';
  d[55].itr:='3';
  d[55].lng:= 0.25;

  d[56].lipi:='४';
  d[56].deva:='4';
  d[56].itr:='4';
  d[56].lng:= 0.25;

  d[57].lipi:='५';
  d[57].deva:='5';
  d[57].itr:='5';
  d[57].lng:= 0.25;

  d[58].lipi:='६';
  d[58].deva:='6';
  d[58].itr:='6';
  d[58].lng:= 0.25;

  d[59].lipi:='७';
  d[59].deva:='7';
  d[59].itr:='7';
  d[59].lng:= 0.25;

  d[60].lipi:='८';
  d[60].deva:='8';
  d[60].itr:='8';
  d[60].lng:= 0.25;

  d[61].lipi:='९';
  d[61].deva:='9';
  d[61].itr:='9';
  d[61].lng:= 0.25;

  d[62].lipi:='ऽ';
  d[62].deva:='.';
  d[62].itr:='.';
  d[62].lng:= 0.25;

  d[63].lipi:=#32;
  d[63].deva:=#32;
  d[63].itr:=#32;
  d[63].lng:= 0.25;

  d[64].lipi:='|';
  d[64].deva:='|';
  d[64].itr:='|';
  d[64].lng:= 0.25;

  d[65].lipi:='||';
  d[65].deva:='||';
  d[65].itr:='||';
  d[65].itr:='||';
  d[65].lng:= 0.25;

  d[66].lipi:='ॐ';
  d[66].deva:='O';
  d[66].itr:='OM';
  d[66].itr3:='ОМ';
  d[66].lng:= 2;

  d[67].lipi:='॑';
  d[67].deva:='';
  d[67].itr:='';
  d[67].lng:= 1;

  d[68].lipi:='॒';
  d[68].deva:='';
  d[68].itr:='';
  d[68].lng:= 1;

  d[69].lipi:='ꣳ';
  d[69].beg:=0;
  d[69].ed:=0;
  d[69].deva:='';
  d[69].itr:='';
  d[69].lng:= 1;

  d[70].lipi:='ळ';
  d[70].deva:='L.';
  d[70].beg:=0;
  d[70].ed:=0;
  d[70].itr:='L.';
  d[70].lng:=0.25;
  d[70].itr3:='Л';


  d[72].itr:='';
  d[72].lng:= 1;

  d[71].lipi:='';
  d[71].deva:='';
  d[71].beg:=0;
  d[71].ed:=0;



  d[71].lipi:='';
  d[71].deva:='';
  d[71].beg:=0;
  d[71].ed:=0;

  d[71].itr:='';
  d[71].lng:= 1;
 end;
 procedure Tform1.GetSinta(s : string; x : boolean);
 var
     s1,s2 : string;
     i : dword;
     j : dword;
 begin
   if pos(' ',s) > 0 then
   sinta.Caption:=dcs1.getosn(copy(s,1,pos(' ',s)-1))
   else
   sinta.Caption:=dcs1.getosn(s);
   sinta.ComboBox1.Clear;
   sinta.hw.Clear;
   if pos(' ',s) = 0 then s := s + ' ';
   s1 := s;
   sinta.ListBox1.Clear;
   while s1 <> '' do
   begin
      sinta.ComboBox1.Items.Add(o[strtoint(copy(s1,1,pos(' ',s1)-1))].stem +
      ' '+o[strtoint(copy(s1,1,pos(' ',s1)-1))].gr);
      sinta.listbox1.Items.Add(
       copy(s1,1,pos(' ',s1)-1));
      delete(s1,1,pos(' ',s1));
   end;
   if  sinta.ComboBox1.Items.Count > 0 then
   begin
      sinta.ComboBox1.ItemIndex:=0;
//      sinta.Caption:= s;
      sinta.combobox1change(nil);
   end;
   if sinta.Caption = '' then
   infx('Syntagmatic','Could not find combinations');
end;
procedure Tform1.chklb14;
begin
   if checkbox8.Checked and
   checkbox9.Checked and
   checkbox28.Checked and
   checkbox18.Checked and
   checkbox10.Checked and
   checkbox11.Checked and
   checkbox12.Checked and
   checkbox13.Checked then checkbox14.Checked:=true;

   if (checkbox8.Checked  = false and
   checkbox9.Checked = false and
   checkbox28.Checked = false and
   checkbox10.Checked = false and
   checkbox11.Checked = false and
   checkbox18.Checked = false and
   checkbox12.Checked = false and
   checkbox13.Checked) then checkbox14.checked := false;
////21
   if checkbox15.Checked and
   checkbox19.Checked and
   checkbox20.Checked then checkbox21.Checked:=true;
   if (checkbox15.Checked  = false and
   checkbox19.Checked = false and
   checkbox20.Checked = false) then checkbox21.checked := false;
///27
   if checkbox17.Checked and
   checkbox25.Checked and
   checkbox26.Checked then checkbox27.Checked:=true;
   if (checkbox17.Checked  = false and
   checkbox25.Checked = false and
   checkbox26.Checked = false) then checkbox27.checked := false;
///24
   if checkbox16.Checked and
   checkbox23.Checked and
   checkbox22.Checked then checkbox24.Checked:=true;
   if (checkbox16.Checked  = false and
   checkbox23.Checked = false and
   checkbox22.Checked = false) then checkbox24.checked := false;
///27

   if stringgrid1.RowCount > 1 then
   begin
      stringgrid1.Col:=1;
      stringgrid1click(nil);
   end;
end;

procedure tform1.FDL(s : string;sx : dword);
var y,x : dword;
begin
   x := 1; y := 0;

   if y = 0 then y := 1;
   if length(s) > 2 then
    case s[1] of
      '#' :  begin  delete(s,1,1); dlist[1].DDesc := dlist[1].DDesc + s +'<br>'; dlist[1].ID := sx;inc(dlist[1].df,y);  end;
      '$' :  begin  delete(s,1,1);dlist[2].DDesc := dlist[2].DDesc + s + '<br>';  dlist[2].ID := sx;inc(dlist[2].df,y);end;
      '^' :  begin  delete(s,1,1);dlist[3].DDesc := dlist[3].DDesc + s + '<br>';  dlist[3].ID := sx;inc(dlist[3].df,y);end;
      '+' :  begin  delete(s,1,1);dlist[4].DDesc := dlist[4].DDesc + s + '<br>';  dlist[4].ID := sx;inc(dlist[4].df,y);end;
      '_' :  begin  delete(s,1,1);dlist[5].DDesc := dlist[5].DDesc + s + '<br>';  dlist[5].ID := sx;inc(dlist[5].df,y);end;
      '-' :  begin  delete(s,1,1);dlist[6].DDesc := dlist[6].DDesc + s + '<br>';  dlist[6].ID := sx;inc(dlist[6].df,y);end;
      '%' :  begin  delete(s,1,1);dlist[7].DDesc := dlist[7].DDesc + s + '<br>';  dlist[7].ID := sx;inc(dlist[7].df,y);end;
      '|' :  begin  delete(s,1,1);dlist[8].DDesc := dlist[8].DDesc + s + '<br>';  dlist[8].ID := sx;inc(dlist[8].df,y);end;
      '&' :  begin  delete(s,1,1);dlist[9].DDesc := dlist[9].DDesc + s + '<br>';  dlist[9].ID := sx;inc(dlist[9].df,y);end;
      '1' :  begin  delete(s,1,1);dlist[10].DDesc := dlist[10].DDesc + s + '<br>';dlist[10].ID := sx;inc(dlist[10].df,y);  end;
      '2' :  begin  delete(s,1,1);dlist[11].DDesc := dlist[11].DDesc + s + '<br>';dlist[11].ID := sx;inc(dlist[11].df,y);  end;
      '3' :  begin  delete(s,1,1);dlist[12].DDesc := dlist[12].DDesc + s + '<br>'; dlist[12].ID := sx;inc(dlist[12].df,y); end;
      'w' :  begin  delete(s,1,1);dlist[13].DDesc := dlist[13].DDesc + s + '<br>'; dlist[13].ID := sx;inc(dlist[13].df,y); end;
      'T' :  begin  delete(s,1,1);dlist[14].DDesc := dlist[14].DDesc + s + '<br>'; dlist[14].ID := sx;inc(dlist[14].df,y); end;
      'k' :  begin  delete(s,1,1);dlist[15].DDesc := dlist[15].DDesc + s + '<br>'; dlist[15].ID := sx;inc(dlist[15].df,y); end;
      'L' :  begin  delete(s,1,1);dlist[16].DDesc := dlist[16].DDesc + s + '<br>'; dlist[16].ID := sx;inc(dlist[16].df,y); end;
      '=' :  begin  delete(s,1,1);dlist[17].DDesc := dlist[17].DDesc + s + '<br>'; dlist[17].ID := sx;inc(dlist[17].df,y); end;
      'U' :  begin  delete(s,1,1);dlist[18].DDesc := dlist[18].DDesc + s + '<br>'; dlist[18].ID := sx;inc(dlist[18].df,y); end;
     end;
end;
procedure tform1.sdic(d : byte);
var d1: array of boolean;
    i : byte;
begin
if d in [0..13] then
begin
    setlength(d1,dset.CheckListBox1.Items.Count);
    for i := 0 to dset.CheckListBox1.Items.Count - 1 do
    begin
      d1[i] := dset.CheckListBox1.Checked[i];
      dset.CheckListBox1.Checked[i] := false;
    end;
    dset.CheckListBox1.Checked[d] := true;
    dset.Button110Click(nil);
    if stringgrid1.RowCount > 1 then
    begin
       stringgrid1.Col:=1;
       stringgrid1click(nil)
    end;
    for i := 0 to length(d1) -1 do
    dset.CheckListBox1.Checked[i] := d1[i];
end
else
begin
 setlength(d1,dset.CheckListBox2.Items.Count);
 for i := 0 to dset.CheckListBox2.Items.Count - 1 do
 begin
   d1[i] := dset.CheckListBox2.Checked[i];
   dset.CheckListBox2.Checked[i] := false;
 end;
 dset.CheckListBox2.Checked[d-14] := true;
 dset.Button110Click(nil);
 if stringgrid1.RowCount > 1 then
 begin
    stringgrid1.Col:=1;
    stringgrid1click(nil)
 end;
 for i := 0 to length(d1) -1 do
 dset.CheckListBox2.Checked[i] := d1[i];

end;
end;
function Tform1.ChkWord(i : dword;s : string;d1,d2,d3,d4,d5,d6 : boolean) : boolean;
var c : byte;
begin
    if checkbox2.Checked then c := 10 else c := 1;
    if d1 = false then
    if (pos(s,depo.stringgrid1.Cells[c,i]) = 1) then d1 := true;

    if d2 = false then
    if (pos(s,depo.stringgrid1.Cells[c,i]) > 0) then d2 := true;

    if d3 = false then
    if   (pos(s+' ',depo.stringgrid1.Cells[c,i] + ' ') > 0) then d3 := true;

    if d4 = false then
    if (s = depo.stringgrid1.Cells[c,i] ) then d4 := true;

    if d5 = false then
    begin
     if set_ then
     begin  if gdicid * xgd[i]  = gdicid then d5 := true; end
     else
     begin  if gdicid * xgd[i]  <> [] then d5 := true; end;

    end;

    if d6 = false then
    if depo.StringGrid1.Cells[5,i] <> '' then d6 := true;

    if d1 and d2 and d3 and d4 and d5 and d6 then
    ChkWord := true
    else Chkword := false;
end;
procedure tform1.SelCnt;
var i,j : dword;
begin
    j := 0;
    if stringgrid1.RowCount > 1 then
    for i := 1 to stringgrid1.RowCount - 1 do
      if stringgrid1.Cells[9,i] <> '' then inc(j);
    StatusBarx2.Panels[3].Text:=inttostr(j);
end;
function Tform1.Getconv(s : string) : string;
var i : byte;
begin
    for i := 1 to 51 do
    if (pos(d[i].lipi,s) > 0) or
       (pos(d[i].sd,s) > 0) then
       begin
         s := convertd(s);
         while pos(' ',s) > 0 do delete(s,pos(' ',s),1);
         break;
       end;
      getconv := s;
end;
procedure tform1.infx(s1,s2 : string);
begin
  if form8.CheckBox2.Checked then
  begin
     pn1.Title := s1;pn1.Text:=s2;
     pn1.ShowAtPos(form1.Left,form1.Height-75);
    timer1.Enabled:=true;;
  end;
end;
procedure tform1.chp(x : byte);
var k4: dword;
begin
  k4 := 64;
  panel2.AutoSize:=false;

//  panel39.Parent := panel12;
//  panel39.Parent := panel12;
//  panel39.Parent := panel12;
//  panel39.Parent := panel12;


    case x of
      1 : begin
      panel39.Parent := panel12;
      panel17.Parent := panel12;
      panel41.Parent := panel12;
      panel40.Parent := panel12;
      panel45.Parent := panel12;
      panel39.Parent := panel2;panel39.Show;
      shape1.Left:=speedbutton48.Left;
      shape1.Width:=speedbutton48.Width;

//      panel48.width := k4;
//      panel50.width := k4;
//      panel51.width := k4;
      panel52.width := label30.Width + 20;//k4;
      image7.Left:= (panel52.Width - 48) div 2 - 5;
      panel53.width := label31.Width + 20;
      image8.Left:= (panel53.Width - 48) div 2 -5;
      panel51.width := label20.Width + 20;
      image6.Left:= (panel51.Width - 48) div 2 -5;
      panel50.width := label18.Width + 20;
      image5.Left:= (panel50.Width - 48) div 2 -5;
      panel49.width := label16.Width + 20;
      image4.Left:= (panel49.Width - 48) div 2 -5;
      panel48.width := label7.Width + 20;
      image3.Left:= (panel48.Width - 48) div 2 -5;
//      panel53.width := k4;
//      panel54.width := k4;
//      panel55.width := k4;
//      panel49.width := k4;
//      panel57.width := k4;

        label16.width :=k4-8;

        label18.width :=k4-8;
        label20.width :=k4-8;
        label30.width := 50;
        label31.width :=k4-8;
        label32.width :=k4-8;
        label33.width :=k4-8;
        label34.width :=k4-8;
        label7.width :=k4-8;
        image3.width := k4-8;
        image3.width := k4-8;
        image4.width := k4-8;
        image5.width := k4-8;
        image6.width := k4-8;
        image7.width := k4-8;
        image8.width := k4-8;
        image9.width := k4-8;
        image10.width:= k4-8;
        image11.width := k4-8;



//        combobox3.Top:=label7.top;
//        combobox2.Top:=label7.Top;
//        checkbox2.Top:=label7.Top;
//        speedbutton4.Top:=label7.Top;
//        checkbox6.top := label16.top + label16.height + 1;
//        panel46.height := label31.top + label31.height +5;
//        panel39.AutoSize := true;
        panel39.Height:=panel46.Height +
        panel44.Height + 5;
      end;
      2 : begin
      panel39.Parent := panel12;
      panel17.Parent := panel12;
      panel41.Parent := panel12;
      panel40.Parent := panel12;
       panel17.Parent := panel2;
       panel45.Parent := panel12;
       panel17.Show;
       shape1.Left:=speedbutton54.Left;
       shape1.Width:=speedbutton54.Width;
      end;
      3 : begin
//                shape1.Left:=speedbutton53.Left;
//                shape1.Width:=speedbutton53.Width;
      end;
      4 : begin
      panel39.Parent := panel12;
      panel17.Parent := panel12;
      panel41.Parent := panel12;
      panel40.Parent := panel12;
      panel45.Parent := panel12;
       panel41.Parent := panel2; panel41.show;
                shape1.Left:=speedbutton52.Left;
                shape1.Width:=speedbutton52.Width;
      end;
      5 : begin
//       shape1.Left:=speedbutton50.Left;
//       shape1.Width:=speedbutton50.Width;

      end;
      6 : begin

//       shape1.Left:=speedbutton49.Left;
//       shape1.Width:=speedbutton49.Width;
      end;
      7 : begin
      panel39.Parent := panel12;
      panel17.Parent := panel12;
      panel41.Parent := panel12;
      panel40.Parent := panel12;
      panel45.Parent := panel12;
       shape1.Left:=speedbutton57.Left;
       shape1.Width:=speedbutton57.Width;
       panel40.Parent := panel2;
       panel40.Show;

      end;
      8 : begin
//       shape1.Left:=speedbutton56.Left;
//       shape1.Width:=speedbutton56.Width;

      end;
      9 : begin
       shape1.Left:=speedbutton58.Left;
       shape1.Width:=speedbutton58.Width;

       panel39.Parent := panel12;
       panel17.Parent := panel12;
       panel41.Parent := panel12;
       panel40.Parent := panel12;
       panel45.Parent := panel2;
        panel40.Parent := panel12;
        panel45.Show;
        panel2.AutoSize := true;

      end;
      10 : begin
//       shape1.Left:=speedbutton20.Left;
//       shape1.Width:=speedbutton20.Width;

      end;

    end;
    panel2.AutoSize:=true;


end;

procedure tform1.p18;
var s : string; k : byte;
begin
{   k := 18;
   s := bitbtn1.Caption;
   if length(s) > k then s:= copy(s,1,k) + '..';
   bitbtn1.Caption := s;
   s := bitbtn2.Caption;
   if length(s) > k then s:= copy(s,1,k) + '..';
   bitbtn2.Caption := s;

   s := bitbtn3.Caption;
   if length(s) > k then s:= copy(s,1,k) + '..';
   bitbtn3.Caption := s;

   s := bitbtn4.Caption;
   if length(s) > k then s:= copy(s,1,k) + '..';
   bitbtn4.Caption := s;

   s := bitbtn5.Caption;
   if length(s) > k then s:= copy(s,1,k) + '..';
   bitbtn5.Caption := s;

   s := bitbtn6.Caption;
   if length(s) > k then s:= copy(s,1,k) + '..';
   bitbtn6.Caption := s;

   s := bitbtn7.Caption;
   if length(s) > k then s:= copy(s,1,k) + '..';
   bitbtn7.Caption := s;
}

{   if panel18.visible then
   if bitbtn1.Visible or
   bitbtn2.Visible or
   bitbtn3.Visible or
   bitbtn4.Visible or
   bitbtn5.Visible or
   bitbtn6.Visible or
   bitbtn7.Visible
   then
   panel18.visible := true else panel18.visible := false;
}
end;
function TForm1.GetLxID(s : string) : string;
var i : dword; x : string;
begin x := '';
  if s <> '' then
  for  i := d[getletid(s)].beg to d[getletid(s)].ed do
  if s = depo.StringGrid1.Cells[1,i] then
  begin
    x := depo.StringGrid1.Cells[3,i];
    break;
  end;
  GetLxID := x;
end;
function TForm1.GetGf1(s : string) : string;
var i,j : dword;
begin
   verdir.ComboBox8.ItemIndex:=2;
   verdir.Edit1.Text:=s;
   if verdir.StringGrid2.RowCount>1 then
   begin s := '*';
     for i := 1 to verdir.StringGrid2.RowCount - 1 do
     begin
        for j := 0 to verdir.StringGrid2.ColCount - 1 do
        if verdir.StringGrid2.Columns[j].Visible then
        s := s + verdir.StringGrid2.Cells[j,i]+ #9;
        s := s + #13+#10;
     end;
     GetGf1 := s;
   end
   else
   Getgf1 := '';

end;
function Tform1.GetF2(s : string) : string;
begin

end;
function TForm1.SelLm(k,p : string) : dword;
var i,j : dword; s,s1 : string;
begin
 j := 0;
 if stringgrid1.RowCount > 1 then
 for i := 1 to stringgrid1.RowCount - 1 do
 case k of
   'DCS' : if stringgrid1.Cells[5,i] <> '' then begin inc(j);stringgrid1.Cells[9,i] := speedbutton21.Caption;end;

 end;
 SelLm := j;
end;
Function TForm1.CDname(s : string) : string;
var s1 : string;
begin
 s1 := copy(s,1,pos(':',s));
 delete(s,1,pos(':',s));
 s1 := '<b>'+s1+'</b><font color = "gray">' + s + '<font color = "black">';

 cdname := '<br>'+s1+'<br>';


end;

//initialization
//{$I ft.lrs}

end.

