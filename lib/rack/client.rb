unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__) + "/.."))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/.."))
end

require 'rack'
require 'rack/test'
require 'forwardable'

module Rack
  class Client < Rack::Builder
    include Rack::Test::Methods
    def initialize(*args, &block)
      @ran = false
      super(*args, &block)
    end

    class << self
      extend Forwardable
      def_delegators :new, *Rack::Test::Methods::METHODS
    end

    def run(*args, &block)
      @ran = true
      super(*args, &block)
    end

    def to_app(*args, &block)
      run Rack::Client::HTTP unless @ran
      super(*args, &block)
    end
    alias app to_app
  end
end

$:.unshift File.dirname(__FILE__)

require 'client/http'
require 'client/auth'
require 'client/follow_redirects'
