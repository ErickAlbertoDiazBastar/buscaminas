unit Unit1;
//Elaborado por Erick Alberto Diaz Bastar
//2020
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, Menus, CustomizeDlg;

type
  TForm1 = class(TForm)
    Imagenes: TImage;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    Juego1: TMenuItem;
    Ayuda1: TMenuItem;
    Nuevo1: TMenuItem;
    Principiante1: TMenuItem;
    Intermedio1: TMenuItem;
    Experto1: TMenuItem;
    Personalizado1: TMenuItem;
    Color1: TMenuItem;
    Sonido1: TMenuItem;
    MejoresTiempos1: TMenuItem;
    Salir1: TMenuItem;
    PMayor: TPanel;
    PMarca: TPanel;
    PMarca1: TPanel;
    PMarca2: TPanel;
    PCampo: TPanel;
    ImaCampo: TImage;
    ImaMarca1: TImage;
    ImaMarca2: TImage;
    ImaCarita: TImage;
    CustomizeDlg1: TCustomizeDlg;
    Marcas1: TMenuItem;
    Acercade1: TMenuItem;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ImaCampoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImaCampoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImaCaritaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImaCaritaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Nuevo1Click(Sender: TObject);
    procedure Principiante1Click(Sender: TObject);
    procedure Intermedio1Click(Sender: TObject);
    procedure Experto1Click(Sender: TObject);
    procedure Personalizado1Click(Sender: TObject);
    procedure Marcas1Click(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure Acercade1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2, AcercaDe;

{$R *.dfm}

const
  No= False;
  Si= True;

  AncCamMin= 9;
  AltCamMin= 9;

  AncCamMax= 30;
  AltCamMax= 24;

  PosXCasEnImag= 0;
  PosXNumEnImag= 20;
  PosXCarEnImag= 38;

  AncCas= 16;
  AltCas= 16;

  AncNum= 13;
  AltNum= 23;

  AncCar= 24;
  AltCar= 24;

  indiVacia= 0;
  indiBandera= 1;
  indiIncognita= 2;

  NumDirs= 8;

type
  Punto= record
    X: Integer;
    Y: Integer;
  end;

  Parcela= record
    HayBomba: Boolean;
    BombasA: Integer;
    EstaTapado: Boolean;
    Indicacion: Integer;
    Imagen: Integer;
  end;

var
  AncCam, AltCam: Integer;

  Bombas: Integer;

  Campo: array[0..AncCamMax-1, 0..AltCamMax-1] of Parcela;

  Dir: array[0..NumDirs-1] of Punto = (
    (X: -1; Y: -1),
    (X: +0; Y: -1),
    (X: +1; Y: -1),
    (X: +1; Y: +0),
    (X: +1; Y: +1),
    (X: +0; Y: +1),
    (X: -1; Y: +1),
    (X: -1; Y: +0)
  );

  CronoAct: Boolean;
  CronoMSeg, CronoSeg: Integer;

  FinJuego: Boolean;

  RatonAbajo: Boolean;

  BotonPresionado: Boolean;

  CarAct: Integer;

  UsarIncognita: Boolean;

procedure Dibujar_(F, D: TCanvas; XF, YF, XD, YD, Anc, Alt: Integer);
var
  Fuente, Destino: TRect;
begin
  Fuente.Left:= XF;
  Fuente.Top:= YF;
  Fuente.Right:= Fuente.Left + Anc;
  Fuente.Bottom:= Fuente.Top + Alt;
  Destino.Left:= XD;
  Destino.Top:= YD;
  Destino.Right:= Destino.Left + Anc;
  Destino.Bottom:= Destino.Top + Alt;
  D.CopyRect(Destino, F, Fuente);
end;
//Dibuja las casillas del tablero.
procedure DibujarCas(X, Y, Cas: Integer);
begin
  Dibujar_(Form1.Imagenes.Canvas, Form1.ImaCampo.Canvas, PosXCasEnImag,
  Cas * AltCas, X, Y, AncCas, AltCas);
end;
//Dibuja los numeros en el tablero
procedure DibujarNum(X, Y, Num: Integer; D: TCanvas);
begin
  Dibujar_(Form1.Imagenes.Canvas, D, PosXNumEnImag, Num * AltNum, X, Y,
  AncNum, AltNum);
end;

procedure DibujarCar(X, Y, Car: Integer);
begin
  Dibujar_(Form1.Imagenes.Canvas, Form1.ImaCarita.Canvas, PosXCarEnImag,
  Car * AltCar, X, Y, AncCar, AltCar);
end;
//Dibuja casillas
procedure DibujarCasCam(X, Y, Cas: Integer);
begin
  DibujarCas(X * AncCas, Y * AltCas, Cas);
  Campo[X, Y].Imagen:= Cas;
end;

procedure DibujarNumCam(X, Y, Num: Integer);
begin
  DibujarCasCam(X, Y, 15 - Num);
end;

procedure DibujarNum3Dig(X, Y, Num: Integer; Destino: TCanvas);
var
  D: Integer;
begin
  if Num >= 0 then begin
    Num:= Num mod 1000;
    D:= Num div 100;
    DibujarNum(X, Y, 11 - D, Destino);
    Num:= Num - D * 100;
  end else begin
    DibujarNum(X, Y, 0, Destino);
    Num:= - Num;
    Num:= Num mod 100;
  end;
  Inc(X, AncNum);
  D:= Num div 10;
  DibujarNum(X, Y, 11 - D, Destino);
  Num:= Num - D * 10;
  Inc(X, AncNum);
  D:= Num;
  DibujarNum(X, Y, 11 - D, Destino);
end;

function XYEsEnCampo(X, Y: Integer): Boolean;
begin
  XYEsEnCampo:=
    (X >= 0) and (X <= AncCam-1) and
    (Y >= 0) and (Y <= AltCam-1)
  ;
end;
//se encarga de configurar el tablero principal del juego dependiendo de la
//dificultad, este a su vez por medio de varios for se encarga de seleccionar
//en que casillas estaran las bombas.
procedure IniciarCampo;
var
  X: Integer;
  Y: Integer;
  XX: Integer;
  YY: Integer;
  I: Integer;
  Posib: Integer;
  Suerte: Integer;
  Cuenta: Integer;
begin
  Randomize;

  for X:= 0 to AncCam-1 do for Y:= 0 to AltCam-1 do begin
    Campo[X, Y].HayBomba:= No;
    Campo[X, Y].BombasA:= 0;
    Campo[X, Y].EstaTapado:= Si;
    Campo[X, Y].Indicacion:= indiVacia;
  end;

  Posib:= AncCam * AltCam;
  //ciclo que se encarga de verificar las bombas e indicar en que posici?n se
  //colocaran las bombas.
  for I:= 1 to Bombas do begin
    Suerte:= Random(Posib);
    X:= 0;
    Y:= 0;
    Cuenta:= -1;
    while Si do begin
      if Y = AltCam then Break;
      if Campo[X, Y].HayBomba = No then begin
        Inc(Cuenta);
        if Cuenta = Suerte then Campo[X, Y].HayBomba:= Si;
      end;
      Inc(X);
      if X = AncCam then begin
        X:= 0;
        Inc(Y);
      end;
    end;
    Dec(Posib);
  end;

  for X:= 0 to AncCam-1 do for Y:= 0 to AltCam-1 do begin
    Cuenta:= 0;
    for I:= 0 to NumDirs-1 do begin
      XX:= X + Dir[I].X;
      YY:= Y + Dir[I].Y;
      if XYEsEnCampo(XX, YY) then
        if Campo[XX, YY].HayBomba then
          Inc(Cuenta);
    end;
    Campo[X, Y].BombasA:= Cuenta;
  end;

end;
//se encarga de dibujar el campo
procedure DibujarCampo;
var
  X: Integer;
  Y: Integer;
begin
  for X:= 0 to AncCam-1 do for Y:= 0 to AltCam-1 do
    DibujarCasCam(X, Y, 0);
end;
 //Se encarga de contar cuantas banderas ha puesto el usuario en el tablero.
function CuentaBanderas: Integer;
var
  X: Integer;
  Y: Integer;
  Cuenta: Integer;
begin
  Cuenta:= 0;
  for X:= 0 to AncCam-1 do
    for Y:= 0 to AltCam-1 do
      if Campo[X, Y].Indicacion = indiBandera then
        Inc(Cuenta);
  CuentaBanderas:= Cuenta;
end;
//Dibuja la bandera en la casilla que haya marcado el jugador con clic derecho
procedure DibujarIndBand;
begin
  DibujarNum3Dig(0, 0, Bombas - CuentaBanderas, Form1.ImaMarca1.Canvas);
end;
//Destapa las casillas seleccionadas por el usuario al momento de dar clic
procedure DestaparXYyAT(X, Y: Integer);
var
  XX: Integer;
  YY: Integer;
  I: Integer;
begin
  Campo[X, Y].EstaTapado:= No;
  DibujarNumCam(X, Y, Campo[X, Y].BombasA);
  for I:= 0 to NumDirs-1 do begin
    XX:= X + Dir[I].X;
    YY:= Y + Dir[I].Y;
    if XYEsEnCampo(XX, YY) then
      if Campo[XX, YY].EstaTapado then
        if Campo[XX, YY].Indicacion <> indiBandera then
          if Campo[XX, YY].BombasA = 0 then
            DestaparXYyAT(XX, YY)
          else begin
            Campo[XX, YY].EstaTapado:= No;
            DibujarNumCam(XX, YY, Campo[XX, YY].BombasA);
          end;
  end;
end;
//Se encarga de realizar la cuenta de las casillas que siguen sin ser
//descubierta.
function CuentaTapados: Integer;
var
  X: Integer;
  Y: Integer;
  Cuenta: Integer;
begin
  Cuenta:= 0;
  for X:= 0 to AncCam-1 do
    for Y:= 0 to AltCam-1 do
      if Campo[X, Y].EstaTapado then
        Inc(Cuenta);
  CuentaTapados:= Cuenta;
end;
//Por medio del contador de banderas, indica cuantas bombas quedan por ser
//descubiertas por el usuario
procedure IndicarRestantes;
var
  X: Integer;
  Y: Integer;
begin
  for X:= 0 to AncCam-1 do
    for Y:= 0 to AltCam-1 do
      if Campo[X, Y].HayBomba then
        if Campo[X, Y].Indicacion <> indiBandera then begin
          Campo[X, Y].Indicacion:= indiBandera;
          DibujarCasCam(X, Y, 1);
        end;
end;

procedure DibujarBoton(Car: Integer);
begin
  DibujarCar(0, 0, Car);
end;
//Dibuja los cronometros en el tablero, sin los numeros
procedure DibujarCrono;
begin
  DibujarNum3Dig(0, 0, CronoSeg, Form1.ImaMarca2.Canvas);
end;
//coloca los numeros en el cronometro
procedure IniciarCrono;
begin
  CronoAct:= No;
  CronoMSeg:= 0;
  CronoSeg:= 0;
end;
//Llama a los demas procedure para poder crear la interfaz principal del juego
procedure IniciarJuego;
begin
  FinJuego:= No;
  IniciarCampo;
  DibujarCampo;
  DibujarIndBand;
  CarAct:= 4;
  DibujarBoton(CarAct);
  IniciarCrono;
  DibujarCrono;
end;
//Timer que se encarga de medir el tiempo que se mostrar? en el cronometro
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if CronoAct then
    if FinJuego = No then begin
      Inc(CronoMSeg, Timer1.Interval);
      if CronoMSeg >= 1000 then begin
        CronoMSeg:= 0;
        Inc(CronoSeg);
        DibujarCrono;
      end;
    end;
end;

const
  AncMar1= 3;
  AncMar2= 6;
  AncMar3= 2;
//Proceso que se encarga de ajustar el ancho y alto del tablero, asi como el
//numero de bombas que habr? en juego.
procedure AjustarAncAltBombasCampo(Anc, Alt, Bom: Integer);
var
  MinB: Integer;
  MaxB: Integer;
begin
  if Anc < AncCamMin then
    AncCam:= AncCamMin
  else
    if Anc > AncCamMax then
      AncCam:= AncCamMax
    else
      AncCam:= Anc;

  if Alt < AltCamMin then
    AltCam:= AltCamMin
  else
    if Alt > AltCamMax then
      AltCam:= AltCamMax
    else
      AltCam:= Alt;

  MinB:= AncCam * AltCam * 10 div 100;
  MaxB:= AncCam * AltCam * 90 div 100;
  if Bom < MinB then
    Bombas:= MinB
  else
    if Bom > MaxB then
      Bombas:= MaxB
    else
      Bombas:= Bom;

  Form1.ClientWidth:=
    (
      Form1.PMayor.BevelWidth +
      Form1.PCampo.BorderWidth +
      Form1.PCampo.BevelWidth
    ) * 2 +
    AncCam * AncCas;

  Form1.PCampo.Height:=
    (
      Form1.PCampo.BorderWidth +
      Form1.PCampo.BevelWidth
    ) * 2 +
    AltCam * AltCas;

  Form1.ClientHeight:=
    Form1.PMayor.BevelWidth * 2 +
    Form1.PMarca.Height +
    (
      Form1.PCampo.BorderWidth +
      Form1.PCampo.BevelWidth
    ) * 2 +
   AltCam * AltCas
  ;

  Form1.ImaCarita.Left:= (Form1.ClientWidth - Form1.ImaCarita.Width) Div 2 -
    Form1.PMarca.Left;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  X: Integer;
  Y: Integer;
begin
  DibujarIndBand;
  for X:= 0 to AncCam-1 do
    for Y:= 0 to AltCam-1 do
      DibujarCasCam(X, Y, Campo[X, Y].Imagen);
  DibujarBoton(CarAct);
  DibujarCrono;
  {}
end;
//el primer proceso que se ejecuta, manda a llamar el proceso de iniciar juego
procedure TForm1.FormCreate(Sender: TObject);
begin
  AjustarAncAltBombasCampo(9, 9, 10);

  IniciarJuego;

  RatonAbajo:= No;

  BotonPresionado:= No;

  UsarIncognita:= True;
end;

procedure TForm1.ImaCampoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    if FinJuego = No then
      DibujarBoton(3);
end;

procedure TForm1.ImaCampoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  XX: Integer;
  YY: Integer;
begin
  DibujarBoton(CarAct);

  if FinJuego then Exit;

  X:= X div AncCas;
  Y:= Y div AltCas;

  if XYEsEnCampo(X, Y) then begin
    case Button of
      mbLeft: begin
        if Campo[X, Y].EstaTapado then begin
          if Campo[X, Y].Indicacion <> indiBandera then begin
            CronoAct:= Si;
            if Campo[X, Y].HayBomba then begin
              for XX:= 0 to AncCam-1 do
                for YY:= 0 to AltCam-1 do
                  if Campo[XX, YY].HayBomba then
                    DibujarCasCam(XX, YY, 5)
                  else
                    if Campo[XX, YY].Indicacion = indiBandera then
                      DibujarCasCam(XX, YY, 4);
              DibujarCasCam(X, Y, 3);
              CarAct:= 2;
              DibujarBoton(CarAct);
              FinJuego:= Si;
            end else
              if Campo[X, Y].BombasA = 0 then begin
                DestaparXYyAT(X, Y);
              end else begin
                Campo[X, Y].EstaTapado:= No;
                DibujarNumCam(X, Y, Campo[X, Y].BombasA);
              end;
              if CuentaTapados = Bombas then begin
                IndicarRestantes;
                DibujarIndBand;
                CarAct:= 1;
                DibujarBoton(CarAct);
                FinJuego:= Si;
              end;
          end;
        end;
      end;
      mbRight: begin
        if Campo[X, Y].EstaTapado then
          case Campo[X, Y].Indicacion of
            indiVacia: begin
              Campo[X, Y].Indicacion:= indiBandera;
              DibujarCasCam(X, Y, 1);
            end;
            indiBandera: begin
              if UsarIncognita then begin
                Campo[X, Y].Indicacion:= indiIncognita;
                DibujarCasCam(X, Y, 2);
              end else begin
                Campo[X, Y].Indicacion:= indiVacia;
                DibujarCasCam(X, Y, 0);
              end;
            end;
            indiIncognita: begin
              Campo[X, Y].Indicacion:= indiVacia;
              DibujarCasCam(X, Y, 0);
            end;
          end;
        DibujarIndBand;
      end;
    end;
  end;
end;

procedure TForm1.ImaCaritaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DibujarBoton(0);
end;

procedure TForm1.ImaCaritaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DibujarBoton(CarAct);
  IniciarJuego;
end;
//Bot?n para iniciar un nuevo juego
procedure TForm1.Nuevo1Click(Sender: TObject);
begin
  Iniciarjuego;
end;
 // configuraci?n de los niveles de dificultad
 //Principiante
procedure TForm1.Principiante1Click(Sender: TObject);
begin
  AjustarAncAltBombasCampo(9, 9, 10);
  IniciarJuego;
end;
//Intermedio
procedure TForm1.Intermedio1Click(Sender: TObject);
begin
  AjustarAncAltBombasCampo(16, 16, 40);
  IniciarJuego;
end;
//Experto
procedure TForm1.Experto1Click(Sender: TObject);
begin
  AjustarAncAltBombasCampo(30, 16, 99);
  IniciarJuego;
end;
//Personalizaci?n del tablero
procedure TForm1.Personalizado1Click(Sender: TObject);
var
  Cad: string;
  Anc: Integer;
  Alt: Integer;
  Bom: Integer;
  E: Integer;
begin
  Str(AltCam, Cad);
  Pers.Alt.Text:= Cad;
  Str(AncCam, Cad);
  Pers.Anc.Text:= Cad;
  Str(Bombas, Cad);
  Pers.Bom.Text:= Cad;
  Pers.ShowModal;
  if Pers.ModalResult = 1 then begin
    Anc:= 0;
    Alt:= 0;
    Bom:= 0;
    Val(Pers.Anc.Text, Anc, E);
    Val(Pers.Alt.Text, Alt, E);
    Val(Pers.Bom.Text, Bom, E);
    AjustarAncAltBombasCampo(Anc, Alt, Bom);
    IniciarJuego;
  end;
end;
//Coloca en las casillas el simbolo de interrogaci?n si est? activo.
procedure TForm1.Marcas1Click(Sender: TObject);
begin
  UsarIncognita:= Form1.Marcas1.Checked;
end;
//Cerrar programa
procedure TForm1.Salir1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Acercade1Click(Sender: TObject);
begin
  FAcercaDe.ShowModal;
end;

end.
