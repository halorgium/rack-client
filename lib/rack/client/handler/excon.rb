require 'excon'

module Rack
  module Client
    module Handler
      class Excon
        def initialize(url)
          @uri = URI.parse(url)
        end

        def call(env, &block)
          request = Rack::Request.new(env)

          body = case request.body
                 when StringIO then request.body.string
                 when IO       then request.body.read
                 when Array    then request.body.to_s
                 when String   then request.body
                 end

          response = parse(connection.request(:method => request.request_method,
                             :path  => request.path,
                             :body  => body))

          if block_given?
            yield response
            nil
          else
            return response
          end
        end

        def parse(excon_response)
          body = excon_response.body.empty? ? [] : StringIO.new(excon_response.body)
          Rack::Response.new(body, excon_response.status, excon_response.headers)
        end

        def connection
          connection_table[self] ||= ::Excon.new(@uri.to_s)
        end

        def connection_table
          Thread.current[:_rack_client_excon_connections] ||= {}
        end
      end
    end
  end
end
