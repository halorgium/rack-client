module TyphoeusHelper

  module Async
    def build_subject(*middlewares)
      @hydra = hydra = Typhoeus::Hydra.new

      Rack::Client.new(@base_url) do |builder|
        middlewares.each do |middleware|
          builder.use *Array(middleware)
        end

        builder.run Rack::Client::Handler::Typhoeus.new(hydra)
      end
    end

    def finish
      @hydra.run
    end
  end

  module Sync
    def build_subject(*middlewares)
      Rack::Client.new(@base_url) do |builder|
        middlewares.each do |middleware|
          builder.use *Array(middleware)
        end

        builder.run Rack::Client::Handler::Typhoeus.new
      end
    end
  end
end
