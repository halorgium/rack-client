module Rack
  module Client
    class Response < Rack::Response
      def initialize(status, headers = {}, body = [], &callback)
        @callback = callback
        super(body, status, headers, &nil)
      end

      def each(&block)
        @body.each(&block)

        stream!(&block)

        @body
      end

      def stream!
        return if @callback.nil?

        @callback.call(lambda do |chunk|
          @body << chunk
          yield chunk if block_given?
        end)

        @callback = nil
      end

      def chunker
        lambda do |chunk|
          @body << chunk
          yield chunk if block_given?
        end
      end

      def body
        stream!
        @body
      end
    end
  end
end
