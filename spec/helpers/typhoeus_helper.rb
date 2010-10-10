module TyphoeusHelper
  extend self

  module Ext
    def typhoeus_async_context(*middlewares, &block)
      context "Asynchronous" do
        include AsyncApi

        define_method(:middlewares) { middlewares }

        def rackup(builder)
          @hydra = Typhoeus::Hydra.new

          middlewares.each do |middleware|
            builder.use middleware
          end

          builder.run Rack::Client::Handler::Typhoeus.new(@hydra)
        end

        def finish
          @hydra.run
        end

        subject do
          Rack::Client.new(@base_url, &method(:rackup))
        end

        instance_eval(&block)
      end
    end
  end

  def self.included(context)
    context.extend Ext
  end

end
