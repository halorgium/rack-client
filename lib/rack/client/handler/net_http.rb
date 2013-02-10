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

          net_connection, net_request = net_connection_for(request), net_request_for(request)

          if streaming_body?(request)
            net_response = net_connection.request(net_request)
          else
            net_response = net_connection.request(net_request, body_for(request))
          end

          parse(net_response).finish
        end

        def async_call(env)
          request = Rack::Request.new(env)

          net_connection_for(request).request(net_request_for(request), body_for(request)) do |net_response|
            yield parse_stream(net_response).finish
          end
        end

        def net_connection_for(request)
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

          net_request = klass.new(request.fullpath, Headers.from(request.env).to_http)

          net_request.body_stream = request.body if streaming_body?(request)

          net_request
        end

        def body_for(request)
          case request.body
          when StringIO then request.body.string
          when IO       then request.body.read
          when Array    then request.body.join
          when String   then request.body
          end
        end

        def streaming_body?(request)
          request.request_method == 'POST' &&
            required_streaming_headers?(request) &&
            request.body.is_a?(IO) &&
            !request.body.is_a?(StringIO)
        end

        def required_streaming_headers?(request)
          request.env.keys.include?('HTTP_CONTENT_LENGTH') ||
            request.env['HTTP_TRANSFER_ENCODING'] == 'chunked'
        end

        def parse(net_response)
          body = (net_response.body.nil? || net_response.body.empty?) ? [] : StringIO.new(net_response.body)
          Response.new(net_response.code.to_i, parse_headers(net_response), body)
        end

        def parse_stream(net_response)
          Response.new(net_response.code.to_i, parse_headers(net_response)) {|block| net_response.read_body(&block) }
        end

        def parse_headers(net_response)
          headers = Headers.new

          net_response.to_hash.each do |k,v|
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
