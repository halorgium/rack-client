module NetHTTPHelper

  module Async
    def build_subject
      Rack::Client.new(@base_url) do |builder|
        builder.run Rack::Client::Handler::NetHTTP.new
      end
    end
  end

  module Sync
    def build_subject
      Rack::Client.new(@base_url) do |builder|
        builder.run Rack::Client::Handler::NetHTTP.new
      end
    end
  end
end
