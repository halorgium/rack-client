module ExconHelper
  module Sync
    def build_subject(*middlewares)
      Rack::Client.new(@base_url) do |builder|
        middlewares.each do |middleware|
          builder.use middleware
        end

        builder.run Rack::Client::Handler::Excon.new
      end
    end
  end
end
