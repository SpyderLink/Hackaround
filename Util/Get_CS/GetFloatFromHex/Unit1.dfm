object Form1: TForm1
  Left = 458
  Top = 270
  Width = 942
  Height = 578
  Caption = #1055#1086#1083#1091#1095#1077#1085#1080#1077' '#1095#1080#1089#1083#1072' FLOAT '#1087#1086' '#1077#1075#1086' Hex-'#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1102' (4321)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 63
    Top = 10
    Width = 73
    Height = 13
    Caption = 'Higth -> Low'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 312
    Top = 202
    Width = 73
    Height = 13
    Caption = 'Low -> Higth'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 28
    Top = 340
    Width = 659
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 28
    Top = 363
    Width = 265
    Height = 19
    Caption = 'CRC16=X^16 + X^15 + X^2 + 1('#1089#1091#1087#1077#1088#1092#1083#1086#1091', modbus)'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 297
    Top = 363
    Width = 121
    Height = 21
    Color = clScrollBar
    ReadOnly = True
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 33
    Top = 26
    Width = 143
    Height = 21
    MaxLength = 32
    TabOrder = 0
  end
  object Button2: TButton
    Left = 183
    Top = 31
    Width = 99
    Height = 19
    Caption = '==>> Float'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Edit4: TEdit
    Left = 285
    Top = 16
    Width = 192
    Height = 21
    Color = clScrollBar
    ReadOnly = True
    TabOrder = 5
  end
  object Edit5: TEdit
    Left = 33
    Top = 124
    Width = 143
    Height = 21
    TabOrder = 6
  end
  object Edit6: TEdit
    Left = 285
    Top = 124
    Width = 192
    Height = 21
    Color = clScrollBar
    ReadOnly = True
    TabOrder = 7
  end
  object Button3: TButton
    Left = 183
    Top = 134
    Width = 99
    Height = 19
    Caption = 'Float -> Hex'
    TabOrder = 8
    OnClick = Button3Click
  end
  object Edit7: TEdit
    Left = 271
    Top = 218
    Width = 143
    Height = 21
    MaxLength = 8
    TabOrder = 9
  end
  object Button4: TButton
    Left = 422
    Top = 204
    Width = 85
    Height = 19
    Caption = 'int32 ==>> DEC'
    TabOrder = 10
    OnClick = Button4Click
  end
  object Edit8: TEdit
    Left = 545
    Top = 216
    Width = 173
    Height = 21
    Color = clMenu
    TabOrder = 11
  end
  object Button5: TButton
    Left = 723
    Top = 216
    Width = 171
    Height = 19
    Caption = #1087#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1074' TDateTime'
    TabOrder = 12
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 24
    Top = 218
    Width = 239
    Height = 19
    Caption = #1090#1077#1082'.'#1074#1088#1077#1084#1103' TDateTime.Now() ==>> Hex'
    TabOrder = 13
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 183
    Top = 9
    Width = 99
    Height = 19
    Caption = 'BCD =>> dec'
    TabOrder = 14
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 183
    Top = 112
    Width = 99
    Height = 19
    Caption = 'Double -> Hex'
    TabOrder = 15
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 183
    Top = 53
    Width = 99
    Height = 19
    Caption = '==>> Double'
    TabOrder = 16
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 421
    Top = 229
    Width = 114
    Height = 19
    Caption = 'int32(time_t) ==>> DT'
    TabOrder = 17
    OnClick = Button10Click
  end
  object Edit9: TEdit
    Left = 28
    Top = 400
    Width = 659
    Height = 21
    TabOrder = 18
  end
  object Button11: TButton
    Left = 29
    Top = 423
    Width = 265
    Height = 19
    Caption = 'x^16+x^12+x^51 ('#1057#1055#1043'761'#1084#1072#1075'.)'
    TabOrder = 19
    OnClick = Button11Click
  end
  object Edit10: TEdit
    Left = 297
    Top = 423
    Width = 121
    Height = 21
    Color = clScrollBar
    ReadOnly = True
    TabOrder = 20
  end
  object Button12: TButton
    Left = 516
    Top = 422
    Width = 311
    Height = 19
    Caption = 'DLE-'#1089#1090#1072#1092#1092#1080#1085#1075' ('#1076#1086#1073#1072#1074#1083#1077#1085#1080#1077' 10h '#1087#1077#1088#1077#1076' '#1091#1087#1088#1072#1074#1083'.'#1082#1086#1076#1072#1084#1080')'
    TabOrder = 21
    OnClick = Button12Click
  end
end
