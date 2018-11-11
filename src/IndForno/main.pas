unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, indGnouMeter, AdvLed,
  LedNumber, Sensors, SdpoSerial, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, ValEdit, Grids, StrUtils , types;

type

  { TForm1 }



  TForm1 = class(TForm)
    AdvLed1: TAdvLed;
    asTemp: TAnalogSensor;
    btCarregar: TButton;
    btreleoff2: TButton;
    btreleon2: TButton;
    Button1: TButton;
    btDesconectar: TButton;
    btSalvar: TButton;
    Button3: TButton;
    btCmd: TButton;
    btreleon1: TButton;
    btreleoff1: TButton;
    btAdd: TButton;
    btLimpar: TButton;
    btAtualizar: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    edCmd: TEdit;
    edDescricao: TEdit;
    edTempIn: TEdit;
    edTempOut: TEdit;
    edTempo: TEdit;
    edPorta: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    indGnouMeter1: TindGnouMeter;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    lbVersao: TLabel;
    lbTitulo: TLabel;
    lbRelogio: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbTempoEtapa: TLabel;
    lbRelogio2: TLabel;
    lbTempoRestante: TLabel;
    lbTemp: TLabel;
    lbTemperaturaRampa: TLabel;
    meCmd: TMemo;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    pbtemp: TProgressBar;
    SaveDialog1: TSaveDialog;
    SdpoSerial1: TSdpoSerial;
    GridDados: TStringGrid;
    TabSheet1: TTabSheet;
    tsConsole: TTabSheet;
    tsProgramacao: TTabSheet;
    tbControle: TTabSheet;
    tbSobre: TTabSheet;
    tbConfiguracoes: TTabSheet;
    Timer1: TTimer;
    procedure btAddClick(Sender: TObject);
    procedure btAtualizarClick(Sender: TObject);
    procedure btCarregarClick(Sender: TObject);
    procedure btCmdClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btDesconectarClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btreleon1Click(Sender: TObject);
    procedure btreleoff1Click(Sender: TObject);
    procedure GridDadosDblClick(Sender: TObject);
    procedure GridDadosSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure GridDadosSelection(Sender: TObject; aCol, aRow: Integer);
    procedure Image2Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure SdpoSerial1RxData(Sender: TObject);
    procedure tbControleContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tbSobreContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure tsProgramacaoContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    { private declarations }
    function getTempIdeal(): Extended;
    procedure Desconectar();
    //Verifica o temp In do Registro posicionado
    function GetRegTempIn(Registro : integer): Integer;
  public
    { public declarations }

    flgRegistra : boolean;
    registro : integer;
    LastTempo : TDatetime;   //Tempo de Fim do bloco
    FirstTempo : TDatetime;  //Tempo de Inicio do bloco
    StartTempo : Tdatetime;  //Tempo de Inicio do Programa
    TempoDecorrido : Tdatetime; //Tempo decorrido do inicio do programa
    GridSel : integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btSairClick(Sender: TObject);
begin
  close();
end;

procedure TForm1.btSalvarClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    GridDados.SaveToFile(SaveDialog1.FileName);

  end;
end;

procedure TForm1.btCmdClick(Sender: TObject);
begin
  if (SdpoSerial1.Active) then
  begin
    SdpoSerial1.WriteData(edCmd.text+#13+#10);
  end;

end;

procedure TForm1.btAddClick(Sender: TObject);
begin
  GridDados.RowCount:=GridDados.RowCount+1;
  GridDados.Cells[0,GridDados.RowCount-1] := inttostr(GridDados.RowCount-1);
  GridDados.Cells[1,GridDados.RowCount-1] := edDescricao.text;
  GridDados.Cells[2,GridDados.RowCount-1] := edtempIn.text;
  GridDados.Cells[3,GridDados.RowCount-1] := edtempOut.text;
  GridDados.Cells[4,GridDados.RowCount-1] := edtempo.text;
  GridSel := 0;
end;

procedure TForm1.btAtualizarClick(Sender: TObject);
begin
  if (GridSel <> 0) then
  begin
    GridDados.Cells[1,GridSel] := edDescricao.text;
    GridDados.Cells[2,GridSel] := edtempIn.text;
    GridDados.Cells[3,GridSel] := edtempOut.text;
    GridDados.Cells[4,GridSel] := edtempo.text;
  end;
end;

procedure TForm1.btCarregarClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) then
  begin
    GridDados.LoadFromFile(OpenDialog1.FileName);
    GridSel := 0;
  end;
end;

procedure TForm1.btLimparClick(Sender: TObject);
begin
  GridDados.RowCount:=1;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   info : string;
begin
  sdpoSerial1.Device := edPorta.text;
  sdpoSerial1.Active:= true;
  sleep(1000);
  info := SdpoSerial1.ReadData; //descarta

  timer1.Enabled:= true;
  registro := 1;  //Indica o registro que esta sendo processado
  meCmd.Lines.Clear;
  AdvLed1.Blink:= true;
  GridSel := 0;
  StartTempo := now(); //Inicio do programa , marcacao do tempo
  tempoDecorrido := Now()- StartTempo;  //Tempo Decorrido do Inicio do programa
  FirstTempo := Now();
  //tbcontrole.SetFocus;

end;

procedure TForm1.Desconectar();
begin
  //Primeiro Desliga a resistencia
  SdpoSerial1.WriteData('DESLIGAR1'+#10);
  AdvLed1.Blink:= false;
  AdvLed1.State:= lsOff;
  //Desativa o equipamento
  sdpoSerial1.Active:= false;
  timer1.Enabled:= false;
  AdvLed1.Blink:= false;
  AdvLed1.State:= lsOff;
end;

procedure TForm1.btDesconectarClick(Sender: TObject);
begin
  Desconectar;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  close();
end;

procedure TForm1.btreleon1Click(Sender: TObject);
begin
  if (SdpoSerial1.Active) then
  begin
    SdpoSerial1.WriteData('LIGAR1'+#10);
    AdvLed1.Blink:= false;
    AdvLed1.State:= lsOn;
  end;
end;

procedure TForm1.btreleoff1Click(Sender: TObject);
begin
  if (SdpoSerial1.Active) then
  begin
    SdpoSerial1.WriteData('DESLIGAR1'+#10);
    AdvLed1.Blink:= false;
    AdvLed1.State:= lsOff;
  end;
end;

procedure TForm1.GridDadosDblClick(Sender: TObject);
begin

end;

procedure TForm1.GridDadosSelectEditor(Sender: TObject; aCol, aRow: Integer;
  var Editor: TWinControl);
begin

end;

procedure TForm1.GridDadosSelection(Sender: TObject; aCol, aRow: Integer);
begin
  GridSel := aRow;
  edDescricao.Text:= GridDados.Cells[1,aRow];
  edTempIn.text := GridDados.Cells[2,aRow];
  edTempOut.text := GridDados.Cells[3,aRow];
  edTempo.Text:=GridDados.Cells[4,aRow];
end;

procedure TForm1.Image2Click(Sender: TObject);
begin

end;

procedure TForm1.Label5Click(Sender: TObject);
begin

end;


//Verifica o temp In do Registro posicionado
function TForm1.GetRegTempIn(Registro : integer): Integer;
var
  item : string;
begin
  item := GridDados.Cells[2,Registro];
  result := StrToInt(item);
end;


//Retorna a temperatura ideal no tempo
function TForm1.getTempIdeal(): Extended;
var
   strTemp : String;

begin
  strTemp := GridDados.Cells[3,Registro];
  strTemp := StringReplace(strTemp,'.',',',[]);
  result := strtofloat(strTemp);
end;

procedure TForm1.SdpoSerial1RxData(Sender: TObject);
var
  Buffer : String;
  postext : integer;
  postemp : integer;
  strTemp : string;
  temperatura : Extended;

begin
   Application.ProcessMessages;
   if SdpoSerial1.DataAvailable then
   begin
     Buffer := sdpoSerial1.ReadData;
     meCmd.Lines.Append(Buffer);
     postext := (pos('Internal: ',Buffer));
     Buffer := AnsiMidStr(Buffer,postext+9,length(Buffer));
     lbRelogio.caption :=  FormatDateTime('hh:mm:ss',now() - StartTempo);
     //Verifica se achou
     if (postext <> 0) then
     begin
       postemp := pos(#13+#10, Buffer);
       strTemp := AnsiMidStr(Buffer,0,postemp-1);
       if (strTemp <> '') then
       begin
         strTemp := StringReplace(strTemp,'.',',',[]);
         temperatura :=  StrToFloat(strTemp);
         //temperatura :=  StrToint('10,2');
         pbtemp.Position:= round(temperatura);
         lbTemp.Caption := strTemp;
         asTemp.value := round(temperatura);
         indGnouMeter1.Value:= temperatura;
         if (GridDados.RowCount > Registro) then
         begin
            //Pega a O titulo da Descricao
            lbTitulo.Caption:= GridDados.Cells[1,Registro];
            lbTemperaturaRampa.Caption:= GridDados.Cells[3,Registro];
            lbTempoEtapa.Caption:= GridDados.Cells[4,Registro];
            LastTempo :=  StrToTime(GridDados.Cells[4,Registro])+FirstTempo;
            lbTempoRestante.Caption:=  FormatDateTime('hh:mm:ss',LastTempo-now());
            if(getTempIdeal() > temperatura)  then
            begin
                 if (AdvLed1.State= lsOff) then
                 begin
                   SdpoSerial1.WriteData('LIGAR1'+#10);
                   AdvLed1.Blink:= false;
                   AdvLed1.State:= lsOn;
                 end;
            end
             else
            begin
                if (AdvLed1.State= lsOn) then
                begin
                  SdpoSerial1.WriteData('DESLIGAR1'+#10);
                  AdvLed1.Blink:= false;
                  AdvLed1.State:= lsOff;
                end;
            end;
            if (flgRegistra = true) then
            begin
              //Chart1LineSeries1.AddXY(strtoint(formatdatetime('hhmm','now())), temperatura);
              //Chart1LineSeries2.AddXY(strtoint(formatdatetime('hhmm','now())), getTempIdeal());
              Chart1LineSeries1.AddXY(now(), temperatura);
              Chart1LineSeries2.AddXY(now(), getTempIdeal());

            end;

            //Verifica se o tempo total da fase foi completado
            if (LastTempo < now()) then
            begin
                FirstTempo := now();
                Registro:= Registro +1;
            end;
         end
         else
         begin
             Desconectar();
             //ShowMessage('Programa Finalizado');
         end;
       end;
     end;
   end;
end;

procedure TForm1.tbControleContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.tbSobreContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  flgRegistra := true;

end;

procedure TForm1.tsProgramacaoContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;





end.

