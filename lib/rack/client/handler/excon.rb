require 'excon'

module Rack
  module Client
    module Handler
      class Excon
        include DualBand

        def async_call(env)
          raise("Asynchronous API is not supported for EmHttp Handler") unless block_given?
        end

        def sync_call(env)
          request = Rack::Request.new(env)

          body = case request.body
                 when StringIO then request.body.string
                 when IO       then request.body.read
                 when Array    then request.body.join
                 when String   then request.body
                 end

          response = parse connection_for(request).request(:method   => request.request_method,
                                                           :path     => request.path,
                                                           :headers  => Headers.from(env).to_http,
                                                           :body     => body)

          response.finish
        end

        def parse(excon_response)
          body = excon_response.body.empty? ? [] : StringIO.new(excon_response.body)
          headers = {}
          excon_response.headers.map do |key,value|
            headers[key] = value.split(", ")
          end
          Response.new(excon_response.status, Headers.new(headers).to_http, body)
        end

        def connection_for(request)
          connection = ::Excon.new(request.url)
        end
      end
    end
  end
end
