unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPers = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Alt: TEdit;
    Anc: TEdit;
    Bom: TEdit;
    Aceptar: TButton;
    Cancelar: TButton;
    procedure AceptarClick(Sender: TObject);
    procedure CancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Pers: TPers;

implementation

{$R *.dfm}

procedure TPers.AceptarClick(Sender: TObject);
begin
  ModalResult:= 1;
end;

procedure TPers.CancelarClick(Sender: TObject);
begin
  ModalResult:= 2;
end;

end.
