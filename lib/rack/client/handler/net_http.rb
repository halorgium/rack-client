require 'net/http'
require 'net/https'

module Rack
  module Client
    module Handler
      class NetHTTP
        include Rack::Client::DualBand

        class << self
          extend Forwardable
          def_delegator :new, :call
        end

        def sync_call(env)
          request = Rack::Request.new(env)

          connection_for(request).request(net_request_for(request), body_for(request)) do |net_response|
            return parse(net_response).finish
          end
        end

        def async_call(env)
          request = Rack::Request.new(env)

          connection_for(request).request(net_request_for(request), body_for(request)) do |net_response|
            yield parse(net_response).finish
          end
        end

        def connection_for(request)
          connection = Net::HTTP.new(request.host, request.port)

          if request.scheme == 'https'
            connection.use_ssl = true
            connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          connection.start
          connection
        end

        def net_request_for(request)
          klass = case request.request_method
                  when 'DELETE' then Net::HTTP::Delete
                  when 'GET'    then Net::HTTP::Get
                  when 'HEAD'   then Net::HTTP::Head
                  when 'POST'   then Net::HTTP::Post
                  when 'PUT'    then Net::HTTP::Put
                  end

          # Make sure that the query string is forwarded
          if klass == Net::HTTP::Get && request.env['QUERY_STRING'] && request.env['QUERY_STRING'] != ''
            path = request.path + "?#{request.env['QUERY_STRING']}" 
          else
            path = request.path
          end
          klass.new(request.path, Headers.from(request.env).to_http)
        end

        def body_for(request)
          case request.body
          when StringIO then request.body.string
          when IO       then request.body.read
          when Array    then request.body.to_s
          when String   then request.body
          end
        end

        def parse(net_response)
          body = (net_response.body.nil? || net_response.body.empty?) ? [] : StringIO.new(net_response.body)
          Response.new(net_response.code.to_i, parse_headers(net_response), body)
        end

        def parse_headers(net_response)
          headers = Headers.new

          net_response.each do |(k,v)|
            headers.update(k => v)
          end

          headers.to_http
        end

        def connections
          @connections ||= {}
        end
      end
    end
  end
end
