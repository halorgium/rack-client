module Rack
  module Client
    module CookieJar
      def self.new(app, &b)
        Context.new(app, &b)
      end
    end
  end
end

require 'rack/client/cookie_jar/options'
require 'rack/client/cookie_jar/cookie'
require 'rack/client/cookie_jar/context'
require 'rack/client/cookie_jar/key'
require 'rack/client/cookie_jar/request'
require 'rack/client/cookie_jar/response'
