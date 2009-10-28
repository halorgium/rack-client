require 'rack'
require 'rack/test'
require 'forwardable'

module Rack
  class Client < Rack::Builder
    VERSION = "0.1.1"

    include Rack::Test::Methods
    HTTP_METHODS = [:head, :get, :put, :post, :delete]

    class << self
      extend Forwardable
      def_delegators :new, *HTTP_METHODS
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

current_dir = File.expand_path(File.dirname(__FILE__) + '/client')

require current_dir + '/http'
require current_dir + '/auth'
require current_dir + '/follow_redirects'
