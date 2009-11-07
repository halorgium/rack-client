require 'rack'
require 'rack/test'
require 'forwardable'
require 'action_dispatch/middleware/stack'
require 'active_support'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/string/inflections'

module Rack
  class Client
    VERSION = "0.2.2.pre"

    include Rack::Test::Methods
    HTTP_METHODS = [:head, :get, :put, :post, :delete]

    class << self
      extend Forwardable
      def_delegators :new, *HTTP_METHODS
    end

    def initialize(*args, &block)
      @stack = Stack.new(*args)
      @stack.instance_eval(&block) if block_given?
    end
    attr_reader :stack

    def call(env)
      app.call(env)
    end

    def app
      stack.app
    end

    class Stack < ActionDispatch::MiddlewareStack
      def run(endpoint)
        @endpoint = endpoint
      end

      def app
        build(@endpoint || Rack::Client::HTTP)
      end
    end
  end
end

current_dir = File.expand_path(File.dirname(__FILE__) + '/client')

require current_dir + '/http'
require current_dir + '/auth'
require current_dir + '/follow_redirects'
