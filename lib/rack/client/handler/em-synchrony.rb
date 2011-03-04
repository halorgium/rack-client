require 'em-http'
require 'em-synchrony'

module Rack
  module Client
    module Handler
      class EmSynchrony
        include Rack::Client::DualBand

        class << self
          extend Forwardable
          def_delegator :new, :call
        end

        def sync_call(env)
          request, fiber = Rack::Request.new(env), Fiber.current

          conn = connection(request.url).send(request.request_method.downcase.to_sym, request_options(request))
          conn.callback { fiber.resume(conn) }
          conn.errback  { fiber.resume(conn) }

          parse(Fiber.yield).finish
        end

        def async_call(env)
          raise("Asynchronous API is not supported for EmSynchrony Handler")
        end

        def connection(url)
          EventMachine::HttpRequest.new(url)
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

          headers = Headers.from(request.env).to_http
          options[:head] = headers unless headers.empty?

          options
        end

        def parse(em_http)
          body = em_http.response.empty? ? [] : StringIO.new(em_http.response)
          Response.new(em_http.response_header.status, Headers.new(em_http.response_header).to_http, body)
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
