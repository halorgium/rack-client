module Rack
  module Client
    module Cache
      def self.new(backend, options={}, &b)
        Context.new(backend, options, &b)
      end
    end
  end
end

require 'rack/client/cache/options'
require 'rack/client/cache/cachecontrol'
require 'rack/client/cache/context'
require 'rack/client/cache/entitystore'
require 'rack/client/cache/key'
require 'rack/client/cache/metastore'
require 'rack/client/cache/request'
require 'rack/client/cache/response'
require 'rack/client/cache/storage'
