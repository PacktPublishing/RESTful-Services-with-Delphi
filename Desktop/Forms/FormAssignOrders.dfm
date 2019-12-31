object frmAssignOrders: TfrmAssignOrders
  Left = 0
  Top = 0
  Caption = 'Assign Orders'
  ClientHeight = 386
  ClientWidth = 956
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 956
    Height = 57
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object lblCustomers: TLabel
      Left = 16
      Top = 17
      Width = 284
      Height = 19
      Caption = 'Assing selected package to curier :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object cboxCuriers: TComboBox
      Left = 320
      Top = 19
      Width = 177
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object btnAssign: TButton
      Left = 520
      Top = 17
      Width = 75
      Height = 25
      Caption = 'Assign'
      TabOrder = 1
      OnClick = btnAssignClick
    end
  end
  object panClient: TPanel
    Left = 0
    Top = 57
    Width = 956
    Height = 329
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object gridOrders: TDBGrid
      Left = 2
      Top = 2
      Width = 952
      Height = 325
      Align = alClient
      DataSource = DM.dsOrders
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'CreatinoDate'
          Title.Alignment = taCenter
          Title.Caption = 'Creatino Date'
          Width = 83
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CustName'
          Title.Alignment = taCenter
          Title.Caption = 'Name'
          Width = 86
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CustSurname'
          Title.Alignment = taCenter
          Title.Caption = 'Surname'
          Width = 103
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CustAddress'
          Title.Alignment = taCenter
          Title.Caption = 'Address'
          Width = 211
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CustPhone1'
          Title.Alignment = taCenter
          Title.Caption = 'Phone 1'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CustPhone2'
          Title.Alignment = taCenter
          Title.Caption = 'Phone 2'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TotalPrice'
          Title.Alignment = taCenter
          Title.Caption = 'Price'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Delivered'
          Title.Alignment = taCenter
          Title.Caption = 'Status'
          Visible = True
        end>
    end
  end
end
