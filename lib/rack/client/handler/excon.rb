require 'excon'

module Rack
  module Client
    module Handler
      class Excon
        def initialize(url)
          @url = URI.parse(url)
        end

        def call(env)
          request = Rack::Request.new(env)

          body = case request.body
                 when StringIO then request.body.string
                 when IO       then request.body.read
                 when Array    then request.body.to_s
                 when String   then request.body
                 end

          parse connection.request(:method => request.request_method,
                             :path  => request.path,
                             :body  => body)

        end

        def parse(excon_response)
          body = excon_response.body.empty? ? [] : StringIO.new(excon_response.body)
          Rack::Response.new(body, excon_response.status, excon_response.headers)
        end

        def connection
          connection_table[self] ||= ::Excon.new(@url.to_s)
        end

        def connection_table
          Thread.current[:_rack_client_excon_connections] ||= {}
        end
      end
    end
  end
end
