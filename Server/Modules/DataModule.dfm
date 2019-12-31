object DataMod: TDataMod
  OldCreateOrder = False
  Height = 111
  Width = 366
  object DatabaseConnection: TFDConnection
    Params.Strings = (
      'Database=MasterCourier'
      'Server=GORDAN-PC\SQLEXPRESS2014'
      'OSAuthent=Yes'
      'DriverID=MSSQL'
      'Password=123')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 144
    Top = 16
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    ODBCDriver = 'SQL Server Native Client 11.0'
    Left = 256
    Top = 16
  end
end
