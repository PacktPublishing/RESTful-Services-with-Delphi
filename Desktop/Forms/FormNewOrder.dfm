object frmNewOrder: TfrmNewOrder
  Left = 0
  Top = 0
  Caption = 'New Order'
  ClientHeight = 385
  ClientWidth = 863
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
  object panBottom: TPanel
    Left = 0
    Top = 345
    Width = 863
    Height = 40
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    ExplicitTop = 112
    ExplicitWidth = 325
    object btnSaveClose: TButton
      AlignWithMargins = True
      Left = 344
      Top = 8
      Width = 99
      Height = 25
      Caption = 'Save and Close'
      TabOrder = 0
      OnClick = btnSaveCloseClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 464
      Top = 8
      Width = 99
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object panCustomerHeader: TPanel
    Left = 0
    Top = 0
    Width = 863
    Height = 97
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object lblCustomers: TLabel
      Left = 16
      Top = 8
      Width = 84
      Height = 19
      Caption = 'Customer:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object lblCustName: TLabel
      Left = 69
      Top = 33
      Width = 34
      Height = 13
      Caption = 'Name :'
    end
    object lblCustSurname: TLabel
      Left = 51
      Top = 65
      Width = 49
      Height = 13
      Caption = 'Surname :'
    end
    object lblCustAddress: TLabel
      Left = 277
      Top = 33
      Width = 46
      Height = 13
      Caption = 'Address :'
    end
    object lblCustPhone1: TLabel
      Left = 621
      Top = 33
      Width = 46
      Height = 13
      Caption = 'Phone 1 :'
    end
    object lblCustPhone2: TLabel
      Left = 621
      Top = 65
      Width = 46
      Height = 13
      Caption = 'Phone 2 :'
    end
    object edtCustName: TEdit
      Left = 109
      Top = 30
      Width = 148
      Height = 21
      TabOrder = 0
    end
    object edtCustSurname: TEdit
      Left = 109
      Top = 62
      Width = 148
      Height = 21
      TabOrder = 1
    end
    object edtCustAddress: TEdit
      Left = 329
      Top = 30
      Width = 272
      Height = 21
      TabOrder = 2
    end
    object edtCustPhone1: TEdit
      Left = 678
      Top = 30
      Width = 148
      Height = 21
      TabOrder = 3
    end
    object edtCustPhone2: TEdit
      Left = 678
      Top = 62
      Width = 148
      Height = 21
      TabOrder = 4
    end
  end
  object panOrderDetails: TPanel
    Left = 0
    Top = 97
    Width = 863
    Height = 248
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    ExplicitTop = 99
    object panProducts: TPanel
      Left = 2
      Top = 2
      Width = 859
      Height = 55
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object lblProducts: TLabel
        Left = 16
        Top = 16
        Width = 82
        Height = 19
        Caption = 'Products :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
      end
      object lblProductQty: TLabel
        Left = 296
        Top = 19
        Width = 49
        Height = 13
        Caption = 'Quantity :'
      end
      object edtProductQty: TEdit
        Left = 351
        Top = 16
        Width = 50
        Height = 21
        NumbersOnly = True
        TabOrder = 0
      end
      object btnAddProduct: TButton
        Left = 420
        Top = 16
        Width = 93
        Height = 19
        Caption = 'Add'
        TabOrder = 1
        OnClick = btnAddProductClick
      end
      object cboxProducts: TComboBox
        Left = 120
        Top = 16
        Width = 161
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 2
      end
      object btnDeleteProduct: TButton
        Left = 731
        Top = 16
        Width = 93
        Height = 19
        Caption = 'Delete'
        TabOrder = 3
        OnClick = btnDeleteProductClick
      end
    end
    object sgProducts: TStringGrid
      Left = 2
      Top = 57
      Width = 859
      Height = 189
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvRaised
      ColCount = 2
      DefaultColWidth = 250
      DrawingStyle = gdsGradient
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
      TabOrder = 1
      ColWidths = (
        557
        292)
    end
  end
end
