unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAChartExtentLink, TAGraph, TAFuncSeries,
  TASeries, TASources, TATools, TATransformations, TALegendPanel,
  TAChartImageList, SdpoSerial, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, ComCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    btForno1Ligar: TButton;
    btForno1Desligar: TButton;
    btForno2Desligar: TButton;
    btForno2Ligar: TButton;
    Button2: TButton;
    Button6: TButton;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    ChartAxisTransformations1: TChartAxisTransformations;
    ChartExtentLink1: TChartExtentLink;
    ChartToolset1: TChartToolset;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    cbSerial: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbFase: TLabel;
    lbFase1: TLabel;
    lbForno1Status1: TLabel;
    lbForno1Temp: TLabel;
    lbForno1Status: TLabel;
    lbForno1Temp1: TLabel;
    ListChartSource1: TListChartSource;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pbForno1: TProgressBar;
    pbForno2: TProgressBar;
    SdpoSerial1: TSdpoSerial;
    Shape1: TShape;
    Shape2: TShape;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    procedure btForno1DesligarClick(Sender: TObject);
    procedure btForno1LigarClick(Sender: TObject);
    procedure btForno2DesligarClick(Sender: TObject);
    procedure btForno2LigarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbSerialChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  Button2Click(self);
end;

procedure TForm1.cbSerialChange(Sender: TObject);
begin
  sdpoSerial1.Close();
  sdpoSerial1.Device  :=cbserial.Items[cbserial.ItemIndex];
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  sdpoSerial1.open();
end;

procedure TForm1.btForno1LigarClick(Sender: TObject);
begin
  SdpoSerial1.WriteData('LIGAR1'+#10);
end;

procedure TForm1.btForno2DesligarClick(Sender: TObject);
begin
   SdpoSerial1.WriteData('DESLIGAR2'+#10);
end;

procedure TForm1.btForno2LigarClick(Sender: TObject);
begin
   SdpoSerial1.WriteData('LIGAR2'+#10);
end;

procedure TForm1.btForno1DesligarClick(Sender: TObject);
begin
  SdpoSerial1.WriteData('DESLIGAR1'+#10);
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  Close();
end;

end.

