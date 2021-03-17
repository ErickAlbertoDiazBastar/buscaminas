object Pers: TPers
  Left = 982
  Top = 202
  Width = 263
  Height = 197
  Caption = 'Personalizar'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 40
    Width = 23
    Height = 13
    Caption = 'Alto:'
  end
  object Label2: TLabel
    Left = 20
    Top = 70
    Width = 34
    Height = 13
    Caption = 'Ancho:'
  end
  object Label3: TLabel
    Left = 20
    Top = 100
    Width = 31
    Height = 13
    Caption = 'Minas:'
  end
  object Alt: TEdit
    Left = 80
    Top = 40
    Width = 40
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object Anc: TEdit
    Left = 80
    Top = 70
    Width = 40
    Height = 20
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
  end
  object Bom: TEdit
    Left = 80
    Top = 100
    Width = 40
    Height = 20
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
  end
  object Aceptar: TButton
    Left = 140
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Aceptar'
    TabOrder = 3
    OnClick = AceptarClick
  end
  object Cancelar: TButton
    Left = 140
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 4
    OnClick = CancelarClick
  end
end
