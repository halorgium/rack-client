require 'forwardable'
require 'uri'
require 'rack'

module Rack
  module Client
    include Forwardable

    class << self
      extend Forwardable
      def_delegators :new, :head, :get, :put, :post, :delete
    end

    def self.new(*a, &block)
      block ||= lambda { run Rack::Client::Handler::NetHTTP }
      Rack::Client::Simple.new(Rack::Builder.app(&block), *a)
    end
  end
end

require 'rack/client/version'

require 'rack/client/handler'
require 'rack/client/dual_band'
require 'rack/client/response'

require 'rack/client/adapter'

require 'rack/client/follow_redirects'
require 'rack/client/auth/abstract/challenge'
require 'rack/client/auth/basic'
require 'rack/client/auth/digest/challenge'
require 'rack/client/auth/digest/params'
require 'rack/client/auth/digest/md5'

require 'rack/client/cache'

require 'rack/client/cookie_jar'
