object frmProducts: TfrmProducts
  Left = 0
  Top = 0
  Caption = 'Products'
  ClientHeight = 323
  ClientWidth = 675
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 675
    Height = 41
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object DBNavigator1: TDBNavigator
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 665
      Height = 31
      DataSource = DM.dsProducts
      Align = alClient
      TabOrder = 0
    end
  end
  object panProducts: TPanel
    Left = 0
    Top = 41
    Width = 675
    Height = 282
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object gridProducts: TDBGrid
      Left = 2
      Top = 2
      Width = 671
      Height = 278
      Align = alClient
      DataSource = DM.dsProducts
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'PName'
          Title.Caption = 'Name'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PPrice'
          Title.Caption = 'Price'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PQuantity'
          Title.Caption = 'Quantity'
          Width = 93
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PDescription'
          Title.Caption = 'Description'
          Width = 168
          Visible = True
        end>
    end
  end
end
