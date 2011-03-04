module Rack
  module Client
    module Handler
      autoload :NetHTTP,     'rack/client/handler/net_http'
      autoload :Excon,       'rack/client/handler/excon'
      autoload :EmHttp,      'rack/client/handler/em-http'
      autoload :EmSynchrony, 'rack/client/handler/em-synchrony'
      autoload :Typhoeus,    'rack/client/handler/typhoeus'
    end
  end
end
