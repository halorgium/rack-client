require 'forwardable'
require 'stringio'
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
      block ||= lambda {|opt| run Rack::Client::Handler::NetHTTP }
      Rack::Client::Simple.new(Rack::Builder.app(&block), *a)
    end
  end
end

require 'rack/client/version'

require 'rack/client/core'

require 'rack/client/handler'

require 'rack/client/adapter'

require 'rack/client/middleware'

require 'rack/client/parser'
