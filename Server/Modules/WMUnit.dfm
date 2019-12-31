object WebMod: TWebMod
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end>
  Height = 159
  Width = 281
  object Server: TDSServer
    Left = 96
    Top = 11
  end
  object WebDispatcher: TDSRESTWebDispatcher
    Server = Server
    WebDispatch.PathInfo = 'datasnap*'
    Left = 96
    Top = 75
  end
  object ServerClass: TDSServerClass
    OnGetClass = ServerClassGetClass
    Server = Server
    Left = 200
    Top = 11
  end
end
