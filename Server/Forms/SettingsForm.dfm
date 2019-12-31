object FormSettings: TFormSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 293
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object panBottom: TPanel
    Left = 0
    Top = 244
    Width = 324
    Height = 49
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 253
    ExplicitWidth = 314
    DesignSize = (
      324
      49)
    object btnCancel: TButton
      Left = 239
      Top = 13
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 229
    end
    object btnOk: TButton
      Left = 151
      Top = 13
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOkClick
      ExplicitLeft = 141
    end
  end
  object panServer: TPanel
    Left = 0
    Top = 0
    Width = 324
    Height = 75
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 314
    ExplicitHeight = 61
    DesignSize = (
      324
      75)
    object lblServerSettings: TLabel
      Left = 16
      Top = 10
      Width = 81
      Height = 13
      Caption = 'Server Settings :'
    end
    object lblServerPort: TLabel
      Left = 34
      Top = 37
      Width = 62
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Server port :'
      ExplicitLeft = 21
    end
    object edtServerPort: TEdit
      Left = 108
      Top = 34
      Width = 61
      Height = 21
      Anchors = [akTop, akRight]
      NumbersOnly = True
      TabOrder = 0
      ExplicitLeft = 98
    end
    object chkBoxServerAutostart: TCheckBox
      Left = 217
      Top = 36
      Width = 97
      Height = 17
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = 'Server Autostart   '
      TabOrder = 1
      ExplicitLeft = 207
    end
  end
  object panDatabase: TPanel
    Left = 0
    Top = 75
    Width = 324
    Height = 169
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 88
    ExplicitWidth = 314
    DesignSize = (
      324
      169)
    object lblDatabaseSettings: TLabel
      Left = 16
      Top = 6
      Width = 95
      Height = 13
      Caption = 'Database Settings :'
    end
    object lblDatabaseServer: TLabel
      Left = 34
      Top = 28
      Width = 91
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Database Server  :'
      ExplicitLeft = 21
    end
    object lblDatabaseName: TLabel
      Left = 42
      Top = 53
      Width = 83
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Database Name :'
      ExplicitLeft = 32
    end
    object lblUsername: TLabel
      Left = 72
      Top = 110
      Width = 55
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Username :'
      ExplicitLeft = 62
    end
    object lblDBatabasePassword: TLabel
      Left = 72
      Top = 137
      Width = 53
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Password :'
      ExplicitLeft = 62
    end
    object edtDatabaseServer: TEdit
      Left = 132
      Top = 25
      Width = 182
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 0
      ExplicitLeft = 122
    end
    object edtDatabaseName: TEdit
      Left = 132
      Top = 51
      Width = 182
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 122
    end
    object chkBoxOSAuthenticate: TCheckBox
      Left = 34
      Top = 84
      Width = 97
      Height = 17
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = 'OS Authenticate'
      TabOrder = 2
      ExplicitLeft = 24
    end
    object edtDBUsername: TEdit
      Left = 132
      Top = 107
      Width = 182
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 3
      ExplicitLeft = 122
    end
    object edtDBPassword: TEdit
      Left = 132
      Top = 134
      Width = 182
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 4
      ExplicitLeft = 122
    end
  end
end
