module TyphoeusHelper

  module Async
    def build_subject
      @hydra = hydra = Typhoeus::Hydra.new

      Rack::Client.new(@base_url) do |builder|
        builder.run Rack::Client::Handler::Typhoeus.new(hydra)
      end
    end

    def finish
      @hydra.run
    end
  end

  module Sync
    def build_subject
      Rack::Client.new(@base_url) do |builder|
        builder.run Rack::Client::Handler::Typhoeus.new
      end
    end
  end
end
