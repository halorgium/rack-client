module Rack
  module Client
    module Cache
      def self.new(backend, options={}, &b)
        Context.new(backend, options, &b)
      end
    end
  end
end

require 'rack/cache/options'
require 'rack/client/cache/options'
require 'rack/client/cache/context'
require 'rack/client/cache/request'
require 'rack/client/cache/response'
