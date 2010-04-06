require 'excon'

module Rack
  module Client
    module Handler
      class Excon
        include DualBand

        def initialize(url)
          @uri = URI.parse(url)
        end

        def async_call(env)
          raise("Asynchronous API is not supported for EmHttp Handler") unless block_given?
        end

        def sync_call(env)
          request = Rack::Request.new(env)

          body = case request.body
                 when StringIO then request.body.string
                 when IO       then request.body.read
                 when Array    then request.body.to_s
                 when String   then request.body
                 end

          response = parse connection.request(:method => request.request_method,
                                              :path  => request.path,
                                              :body  => body)

          response.finish
        end

        def parse(excon_response)
          body = excon_response.body.empty? ? [] : StringIO.new(excon_response.body)
          Response.new(excon_response.status, excon_response.headers, body)
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
