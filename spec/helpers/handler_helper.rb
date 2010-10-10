module HandlerHelper
  SYNC_HANDLERS = [
    Rack::Client::Handler::NetHTTP,
    Rack::Client::Handler::Typhoeus
  ]

  module Ext
    def setup_contexts_for(middleware, &block)
      SYNC_HANDLERS.each do |handler|
        context "#{handler.name} Async" do
          include SyncApi

          subject do
            Rack::Client.new(@base_url) do |builder|
              builder.use middleware
              builder.run handler.new
            end
          end

          instance_eval(&block)
        end
      end
    end
  end

  def self.included(context)
    context.extend Ext
  end
end
