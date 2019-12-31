object DataMod: TDataMod
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 296
  Width = 380
  object FDSQLiteDB: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      
        'Database=C:\Users\Public\Documents\Embarcadero\Studio\19.0\Sampl' +
        'es\Data\fddemo.sdb'
      'DriverID=SQLite')
    ResourceOptions.AssignedValues = [rvCmdExecMode]
    ResourceOptions.CmdExecMode = amNonBlocking
    LoginPrompt = False
    Left = 24
    Top = 16
  end
  object FDPhSQLiteDrvLnk: TFDPhysSQLiteDriverLink
    Left = 112
    Top = 16
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 224
    Top = 16
  end
  object FDGUIxAsyncExecuteDialog: TFDGUIxAsyncExecuteDialog
    Provider = 'FMX'
    Left = 224
    Top = 72
  end
  object FDQueryCreate: TFDQuery
    Connection = FDSQLiteDB
    Left = 24
    Top = 232
  end
  object RESTClient: TRESTClient
    Params = <>
    HandleRedirects = True
    Left = 24
    Top = 144
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 88
    Top = 144
  end
  object RESTResponse: TRESTResponse
    Left = 168
    Top = 144
  end
end
