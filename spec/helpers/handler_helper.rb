module HandlerHelper
  module Ext

    def async_handler_map(key)
      {
        Rack::Client::Handler::EmHttp   => EmHttpHelper::Async,
        Rack::Client::Handler::NetHTTP  => NetHTTPHelper::Async,
        Rack::Client::Handler::Typhoeus => TyphoeusHelper::Async,
      }[key]
    end

    def sync_handler_map(key)
      {
        Rack::Client::Handler::NetHTTP  => NetHTTPHelper::Sync,
        Rack::Client::Handler::Typhoeus => TyphoeusHelper::Sync
      }[key]
    end

    def async_handler_context(handler, &block)
      context "Asynchronous" do
        include AsyncHelper
        include async_handler_map(handler)

        subject { build_subject }

        around do |group|
          run_around(group) if respond_to?(:run_around)
        end

        instance_eval(&block)
      end
    end

    def sync_handler_context(handler, &block)
      context "Synchronous" do
        include SyncHelper
        include sync_handler_map(handler)

        subject { build_subject }

        instance_eval(&block)
      end
    end
  end

  def self.included(context)
    context.extend Ext
  end
end
