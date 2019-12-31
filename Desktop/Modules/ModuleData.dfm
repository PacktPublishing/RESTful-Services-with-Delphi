object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 271
  Width = 520
  object DBConnection: TFDConnection
    Params.Strings = (
      'Database=MasterCourier'
      'Server=GORDAN-PC\SQLEXPRESS2014'
      'OSAuthent=Yes'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 24
    Top = 16
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 120
    Top = 16
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    Left = 248
    Top = 16
  end
  object qryOrders: TFDQuery
    AfterClose = qryOrdersAfterClose
    AfterScroll = qryOrdersAfterScroll
    Connection = DBConnection
    SQL.Strings = (
      'select * from Package')
    Left = 48
    Top = 160
  end
  object dsOrders: TDataSource
    DataSet = qryOrders
    Left = 48
    Top = 216
  end
  object qryOrderDetails: TFDQuery
    Filtered = True
    Connection = DBConnection
    Left = 136
    Top = 160
  end
  object dsOrderDetails: TDataSource
    DataSet = qryOrderDetails
    Left = 136
    Top = 216
  end
  object tableUsers: TFDTable
    Connection = DBConnection
    UpdateOptions.UpdateTableName = 'dbo.Users'
    TableName = 'dbo.Users'
    Left = 256
    Top = 160
    object tableUsersUName: TWideStringField
      FieldName = 'UName'
      Origin = 'UName'
      Required = True
      FixedChar = True
      Size = 15
    end
    object tableUsersUPassword: TWideStringField
      FieldName = 'UPassword'
      Origin = 'UPassword'
      Required = True
      FixedChar = True
      Size = 15
    end
    object tableUsersURole: TWideStringField
      FieldName = 'URole'
      Origin = 'URole'
      Required = True
      FixedChar = True
    end
    object tableUsersID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
  end
  object dsUsers: TDataSource
    DataSet = tableUsers
    Left = 256
    Top = 216
  end
  object tableProducts: TFDTable
    Connection = DBConnection
    UpdateOptions.UpdateTableName = 'MasterCourier.dbo.Products'
    TableName = 'MasterCourier.dbo.Products'
    Left = 328
    Top = 160
    object tableProductsID: TFDAutoIncField
      DisplayWidth = 10
      FieldName = 'ID'
      Origin = 'ID'
      ReadOnly = True
    end
    object tableProductsPName: TWideStringField
      DisplayWidth = 50
      FieldName = 'PName'
      Origin = 'PName'
      Required = True
      FixedChar = True
      Size = 50
    end
    object tableProductsPPrice: TCurrencyField
      DisplayWidth = 10
      FieldName = 'PPrice'
      Origin = 'PPrice'
    end
    object tableProductsPQuantity: TIntegerField
      DisplayWidth = 12
      FieldName = 'PQuantity'
      Origin = 'PQuantity'
    end
    object tableProductsPDescription: TWideMemoField
      DisplayWidth = 19
      FieldName = 'PDescription'
      Origin = 'PDescription'
      BlobType = ftWideMemo
      DisplayValue = dvFull
    end
  end
  object dsProducts: TDataSource
    DataSet = tableProducts
    Left = 328
    Top = 216
  end
end
