module Rack
  module Client
    class Response < Rack::Response
      def initialize(status, headers, body)
        super(body, status, headers)
      end
    end
  end
end
