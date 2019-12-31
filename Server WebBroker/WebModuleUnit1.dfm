object WebModule1: TWebModule1
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'actCheckUser'
      PathInfo = '/rest/CheckUSer'
      OnAction = WebModule1actCheckUserAction
    end
    item
      Name = 'actGetOrders'
      PathInfo = '/rest/GetOrders'
      OnAction = WebModule1actGetOrdersAction
    end>
  Height = 230
  Width = 415
end
