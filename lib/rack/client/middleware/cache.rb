module Rack
  module Client
    module Cache
      def self.new(backend, options={}, &b)
        Context.new(backend, options, &b)
      end
    end
  end
end

require 'rack/client/middleware/cache/options'
require 'rack/client/middleware/cache/cachecontrol'
require 'rack/client/middleware/cache/context'
require 'rack/client/middleware/cache/entitystore'
require 'rack/client/middleware/cache/key'
require 'rack/client/middleware/cache/metastore'
require 'rack/client/middleware/cache/request'
require 'rack/client/middleware/cache/response'
require 'rack/client/middleware/cache/storage'
