require 'rack'
require 'forwardable'

module Rack
  module Client
    include Forwardable

    class << self
      extend Forwardable
      def_delegators :new, :head, :get, :put, :post, :delete
    end

    VERSION = "0.2.0"

    def self.new(*a, &block)
      block ||= lambda { run Rack::Client::Handler::NetHTTP }
      Rack::Client::Base.new(Rack::Builder.app(&block), *a)
    end
  end
end

require 'rack/client/base'
require 'rack/client/handler'

require 'rack/client/follow_redirects'
require 'rack/client/auth/basic'
require 'rack/client/auth/digest/md5'
