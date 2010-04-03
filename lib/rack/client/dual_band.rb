module Rack
  module Client
    module DualBand
      def call(env, &block)
        if block_given?
          async_call(env, &block)
        else
          sync_call(env)
        end
      end
    end
  end
end
