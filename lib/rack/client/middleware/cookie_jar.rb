module Rack
  module Client
    module CookieJar
      def self.new(app, &b)
        Context.new(app, &b)
      end
    end
  end
end

require 'rack/client/middleware/cookie_jar/options'
require 'rack/client/middleware/cookie_jar/cookie'
require 'rack/client/middleware/cookie_jar/cookiestore'
require 'rack/client/middleware/cookie_jar/context'
require 'rack/client/middleware/cookie_jar/request'
require 'rack/client/middleware/cookie_jar/response'
require 'rack/client/middleware/cookie_jar/storage'
