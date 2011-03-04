module EmSynchronyHelper
  module Sync
    def build_subject(*middlewares)
      Rack::Client.new(@base_url) do |builder|
        middlewares.each do |middleware|
          builder.use *Array(middleware)
        end

        builder.run Rack::Client::Handler::EmSynchrony.new
      end
    end

    def run_around(group)
      EM.synchrony do
        group.call
        EM.stop
      end
    end
  end
end
