module EmHttpHelper

  module Async
    def build_subject(*middlewares)
      Rack::Client.new(@base_url) do |builder|
        middlewares.each do |middleware|
          builder.use middleware
        end

        builder.run Rack::Client::Handler::EmHttp.new
      end
    end

    def finish
      EM.stop
    end

    def run_around(group)
      EM.run do
        group.call
      end
    end
  end
end
