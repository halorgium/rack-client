module Rack
  module Client
    class Response < Rack::Response
      def initialize(status, headers = {}, body = [], &block)
        @status = status.to_i
        @header = Utils::HeaderHash.new({"Content-Type" => "text/html"}.
                                        merge(headers))
        @body   = body
        @loaded = false

        @stream = block if block_given?
      end

      def each(&block)
        load_body(&block)

        @body
      end

      def body
        load_body

        @body
      end

      def load_body(&block)
        return @body.each(&block) if @body_loaded
        body = []

        @body.each do |chunk|
          unless chunk.empty?
            body << chunk
            yield chunk if block_given?
          end
        end

        if @stream
          @stream.call(lambda do |chunk|
            unless chunk.empty?
              body << chunk
              yield chunk if block_given?
            end
          end)
        end

        @body, @body_loaded = body, true
      end
    end
  end
end
