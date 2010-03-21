require 'em-http'

module Rack
  module Client
    module Handler
      class EmHttp

        def initialize(url)
          @uri = URI.parse(url)
        end

        def call(env)
          raise("Synchronous API is not supported for EmHttp Handler") unless block_given?

          request = Rack::Request.new(env)

          EM.schedule do
            em_http = connection(request.path).send(request.request_method.downcase, request_options(request))
            em_http.callback do
              yield parse(em_http)
            end

            em_http.errback do
              yield parse(em_http)
            end
          end
        end

        def connection(path)
          @connection ||= EventMachine::HttpRequest.new((@uri + path).to_s)
        end

        def request_options(request)
          options = {}

          if request.body
            options[:body] = case request.body
                             when Array     then request.body.to_s
                             when StringIO  then request.body.string
                             when IO        then request.body.read
                             when String    then request.body
                             end
          end

          options
        end

        def parse(em_http)
          body = em_http.response.empty? ? [] : StringIO.new(em_http.response)
          Rack::Response.new(body, em_http.response_header.status, normalize_headers(em_http))
        end

        def normalize_headers(em_http)
          headers = em_http.response_header

          headers['LOCATION'] = URI.parse(headers['LOCATION']).path if headers.include?('LOCATION')

          headers
        end
      end
    end
  end
end
