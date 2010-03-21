module Rack
  module Client
    module Handler
      autoload :NetHTTP,  'rack/client/handler/net_http'
      autoload :Excon,    'rack/client/handler/excon'
    end
  end
end
