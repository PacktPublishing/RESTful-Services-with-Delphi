object frmUsers: TfrmUsers
  Left = 0
  Top = 0
  Caption = 'User Management'
  ClientHeight = 334
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 470
    Height = 52
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object navUsers: TDBNavigator
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 460
      Height = 42
      DataSource = DM.dsUSers
      Align = alClient
      TabOrder = 0
    end
  end
  object panUsers: TPanel
    Left = 0
    Top = 52
    Width = 470
    Height = 282
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object gridUsers: TDBGrid
      Left = 2
      Top = 2
      Width = 466
      Height = 278
      Align = alClient
      DataSource = DM.dsUSers
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'UName'
          Title.Caption = 'Name'
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UPassword'
          Title.Caption = 'Password'
          Width = 201
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'URole'
          Title.Caption = 'Role'
          Visible = True
        end>
    end
  end
end
