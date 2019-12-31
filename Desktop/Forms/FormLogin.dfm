object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Please login'
  ClientHeight = 152
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object panClient: TPanel
    Left = 0
    Top = 0
    Width = 325
    Height = 112
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object lblUser: TLabel
      Left = 40
      Top = 32
      Width = 55
      Height = 13
      Caption = 'Username :'
    end
    object lblPassword: TLabel
      Left = 40
      Top = 72
      Width = 53
      Height = 13
      Caption = 'Password :'
    end
    object edtUserName: TEdit
      Left = 112
      Top = 29
      Width = 177
      Height = 21
      TabOrder = 0
      OnChange = edtAccountPropertiesChange
    end
    object edtPassword: TEdit
      Left = 112
      Top = 69
      Width = 177
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
      OnChange = edtAccountPropertiesChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 112
    Width = 325
    Height = 40
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object btnLogin: TButton
      AlignWithMargins = True
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Login'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = btnLoginClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 168
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
