object Form1: TForm1
  Left = 510
  Top = 207
  Width = 914
  Height = 765
  Caption = #1058#1077#1089#1090'-'#1089#1086#1082#1077#1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 161
    Width = 898
    Height = 449
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 610
    Width = 898
    Height = 119
    Align = alBottom
    TabOrder = 1
    object Label3: TLabel
      Left = 335
      Top = 69
      Width = 40
      Height = 13
      Caption = #1089#1086#1082#1077#1090#8470
    end
    object RadioGroup1: TRadioGroup
      Left = 18
      Top = -1
      Width = 871
      Height = 63
      ItemIndex = 0
      Items.Strings = (
        #1058#1077#1082#1089#1090
        'Hex')
      TabOrder = 2
    end
    object Edit1: TEdit
      Left = 82
      Top = 11
      Width = 741
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 82
      Top = 35
      Width = 741
      Height = 21
      TabOrder = 1
    end
    object CheckBox1: TCheckBox
      Left = 10
      Top = 70
      Width = 131
      Height = 17
      Caption = #1055#1086#1074#1090#1086#1088' '#1087#1086#1089#1083#1077' '#1086#1090#1074#1077#1090#1072
      TabOrder = 3
    end
    object Button1: TButton
      Left = 230
      Top = 63
      Width = 95
      Height = 25
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100'    ->'
      TabOrder = 4
      OnClick = Button1Click
    end
    object Edit3: TEdit
      Left = 377
      Top = 66
      Width = 46
      Height = 21
      TabOrder = 5
      Text = '0'
    end
    object Button6: TButton
      Left = 435
      Top = 63
      Width = 81
      Height = 25
      Caption = '<-  Close'
      TabOrder = 6
      OnClick = Button6Click
    end
    object CheckBox2: TCheckBox
      Left = 10
      Top = 90
      Width = 151
      Height = 17
      Caption = #1055#1086#1074#1090#1086#1088' '#1088#1072#1079' '#1074'               '#1089#1077#1082'.'
      TabOrder = 7
      OnClick = CheckBox2Click
    end
    object Edit4: TEdit
      Left = 738
      Top = 85
      Width = 149
      Height = 21
      TabOrder = 8
    end
    object Button8: TButton
      Left = 570
      Top = 83
      Width = 167
      Height = 25
      Caption = #1055#1086#1076#1089#1095#1077#1090' '#1087#1086#1089#1083#1077#1076#1086#1074#1072#1090#1077#1083#1100#1085#1086#1089#1090#1077#1081
      TabOrder = 9
      OnClick = Button8Click
    end
    object Edit5: TEdit
      Left = 101
      Top = 89
      Width = 29
      Height = 21
      TabOrder = 10
      Text = '3'
    end
    object Button9: TButton
      Left = 827
      Top = 12
      Width = 38
      Height = 22
      Caption = '->Hex'
      TabOrder = 11
      OnClick = Button9Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 898
    Height = 161
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 42
      Top = 36
      Width = 10
      Height = 13
      Caption = 'IP'
    end
    object Label2: TLabel
      Left = 40
      Top = 68
      Width = 19
      Height = 13
      Caption = 'Port'
    end
    object Label4: TLabel
      Left = 546
      Top = 4
      Width = 179
      Height = 13
      Caption = #1060#1080#1083#1100#1090#1088#1099' '#1089#1077#1088#1074#1077#1088#1072' ('#1089#1090#1088#1086#1082#1080' '#1087#1086' '#1048#1051#1048')'
    end
    object Button3: TButton
      Left = 405
      Top = 101
      Width = 75
      Height = 25
      Caption = 'Client'
      TabOrder = 0
      OnClick = Button3Click
    end
    object MaskEdit1: TEdit
      Left = 80
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '127.0.0.1'
    end
    object MaskEdit2: TEdit
      Left = 80
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object Button2: TButton
      Left = 405
      Top = 53
      Width = 75
      Height = 25
      Caption = 'Server'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button7: TButton
      Left = 136
      Top = 141
      Width = 75
      Height = 17
      Caption = 'save'
      TabOrder = 4
      OnClick = Button7Click
    end
    object RadioGroup2: TRadioGroup
      Left = 774
      Top = 12
      Width = 113
      Height = 63
      Caption = 'ServerType'
      ItemIndex = 0
      Items.Strings = (
        'stNonBlocking'
        'stThreadBlocking')
      TabOrder = 5
      Visible = False
      OnClick = RadioGroup2Click
    end
    object Button4: TButton
      Left = 235
      Top = 70
      Width = 75
      Height = 25
      Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100
      TabOrder = 6
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 220
      Top = 141
      Width = 33
      Height = 17
      Caption = 'X'
      TabOrder = 7
      OnClick = Button5Click
    end
    object cbUDP: TCheckBox
      Left = 421
      Top = 13
      Width = 53
      Height = 17
      Caption = 'UDP'
      TabOrder = 8
      Visible = False
    end
    object buttSNTP: TButton
      Left = 50
      Top = 102
      Width = 67
      Height = 21
      Caption = 'SNTP'
      TabOrder = 9
      Visible = False
      OnClick = buttSNTPClick
    end
    object cbICMP: TCheckBox
      Left = 243
      Top = 13
      Width = 53
      Height = 17
      Caption = 'ICMP'
      TabOrder = 10
      Visible = False
    end
    object RadioGroup3: TRadioGroup
      Left = 774
      Top = 76
      Width = 113
      Height = 63
      Caption = 'Component'
      ItemIndex = 0
      Items.Strings = (
        'TServerSocket'
        'TIdTCPServer')
      TabOrder = 11
      Visible = False
    end
    object CheckBox3: TCheckBox
      Left = 17
      Top = 142
      Width = 40
      Height = 17
      Caption = 'hex'
      TabOrder = 12
      OnClick = CheckBox3Click
    end
    object Memo2: TMemo
      Left = 544
      Top = 18
      Width = 215
      Height = 125
      TabOrder = 13
    end
    object CheckBox4: TCheckBox
      Left = 545
      Top = 143
      Width = 220
      Height = 17
      Caption = #1074#1099#1082#1083#1102#1095#1080#1090#1100' '#1074#1099#1074#1086#1076' '#1089#1087#1080#1089#1082#1072' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081
      Checked = True
      State = cbChecked
      TabOrder = 14
    end
    object CheckBox5: TCheckBox
      Left = 65
      Top = 142
      Width = 45
      Height = 17
      Caption = 'oem'
      Checked = True
      State = cbChecked
      TabOrder = 15
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = Timer1Timer
    Left = 798
    Top = 212
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    Left = 366
    Top = 85
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    ThreadCacheSize = 0
    OnClientConnect = ServerSocket1ClientConnect
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientError = ServerSocket1ClientError
    Left = 364
    Top = 37
  end
  object IdUDPServer1: TIdUDPServer
    OnStatus = IdUDPServer1Status
    Bindings = <>
    DefaultPort = 0
    OnUDPRead = IdUDPServer1UDPRead
    Left = 488
    Top = 38
  end
  object IdUDPClient1: TIdUDPClient
    OnStatus = IdUDPClient1Status
    Port = 0
    Left = 488
    Top = 84
  end
  object IdSNTP1: TIdSNTP
    OnStatus = IdSNTP1Status
    BroadcastEnabled = True
    Port = 123
    ReceiveTimeout = 5000
    Left = 6
    Top = 68
  end
  object IdIcmpClient1: TIdIcmpClient
    OnStatus = IdIcmpClient1Status
    ReceiveTimeout = 10000
    OnReply = IdIcmpClient1Reply
    Left = 8
  end
  object IdTCPServer1: TIdTCPServer
    OnStatus = IdTCPServer1Status
    Bindings = <>
    DefaultPort = 23002
    OnConnect = IdTCPServer1Connect
    OnExecute = IdTCPServer1Execute
    OnDisconnect = IdTCPServer1Disconnect
    TerminateWaitTime = 1000
    Left = 326
    Top = 36
  end
  object IdTCPClient1: TIdTCPClient
    Port = 0
    Left = 330
    Top = 84
  end
  object ADOStoredProc1: TADOStoredProc
    Parameters = <>
    Left = 284
    Top = 106
  end
end
