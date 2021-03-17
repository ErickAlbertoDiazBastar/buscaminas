program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Pers},
  Unit3 in 'Unit3.pas' {Form3},
  AcercaDe in 'AcercaDe.pas' {FAcercaDe};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPers, Pers);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TFAcercaDe, FAcercaDe);
  Application.Run;
end.
