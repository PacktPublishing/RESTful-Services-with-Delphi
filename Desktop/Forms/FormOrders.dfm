object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Orders Manager'
  ClientHeight = 498
  ClientWidth = 1076
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 1076
    Height = 41
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object btnNewOrder: TButton
      AlignWithMargins = True
      Left = 996
      Top = 5
      Width = 75
      Height = 31
      Align = alRight
      Caption = 'New Order'
      TabOrder = 0
      OnClick = btnNewOrderClick
    end
    object btnProducts: TButton
      AlignWithMargins = True
      Left = 826
      Top = 5
      Width = 75
      Height = 31
      Align = alRight
      Caption = 'Products'
      TabOrder = 1
      OnClick = btnProductsClick
      ExplicitLeft = 915
    end
    object btnUsers: TButton
      AlignWithMargins = True
      Left = 664
      Top = 5
      Width = 75
      Height = 31
      Align = alRight
      Caption = 'Users'
      TabOrder = 2
      OnClick = btnUsersClick
      ExplicitLeft = 753
    end
    object btnDBSettings: TButton
      AlignWithMargins = True
      Left = 745
      Top = 5
      Width = 75
      Height = 31
      Align = alRight
      Caption = 'DB Settings'
      TabOrder = 3
      OnClick = btnDBSettingsClick
      ExplicitLeft = 834
    end
    object btnAssignOrder: TButton
      AlignWithMargins = True
      Left = 907
      Top = 5
      Width = 83
      Height = 31
      Align = alRight
      Caption = 'Assign Orders'
      TabOrder = 4
      OnClick = btnAssignOrderClick
      ExplicitLeft = 936
      ExplicitTop = 6
    end
  end
  object panMaster: TPanel
    Left = 0
    Top = 41
    Width = 1076
    Height = 240
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object gridOrders: TDBGrid
      Left = 2
      Top = 41
      Width = 1072
      Height = 197
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
          FieldName = 'DeliveredDT'
          Title.Alignment = taCenter
          Title.Caption = 'Delivered date'
          Width = 181
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
    object panMasterCaption: TPanel
      Left = 2
      Top = 2
      Width = 1072
      Height = 39
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object lblOrders: TLabel
        Left = 32
        Top = 8
        Width = 59
        Height = 19
        Caption = 'Orders :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object panOrderDetails: TPanel
    Left = 0
    Top = 281
    Width = 1076
    Height = 176
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object panDetailsCaption: TPanel
      Left = 2
      Top = 2
      Width = 1072
      Height = 39
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object lblOrderDetails: TLabel
        Left = 32
        Top = 8
        Width = 102
        Height = 19
        Caption = 'Order details :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
    object gridOrderDetails: TDBGrid
      Left = 2
      Top = 41
      Width = 1072
      Height = 133
      Align = alClient
      DataSource = DM.dsOrderDetails
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'PName'
          Title.Alignment = taCenter
          Title.Caption = 'Product'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Quantity'
          Title.Alignment = taCenter
          Visible = True
        end>
    end
  end
  object panBottom: TPanel
    Left = 0
    Top = 457
    Width = 1076
    Height = 41
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object btnExit: TButton
      AlignWithMargins = True
      Left = 996
      Top = 5
      Width = 75
      Height = 31
      Align = alRight
      Caption = 'Exit'
      TabOrder = 0
      OnClick = btnExitClick
    end
  end
end
