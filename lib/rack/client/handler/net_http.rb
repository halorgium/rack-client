require 'net/http'

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
            return parse(net_response)
          end
        end

        def async_call(env)
          request = Rack::Request.new(env)

          connection_for(request).request(net_request_for(request), body_for(request)) do |net_response|
            yield parse(net_response)
          end
        end

        def connection_for(request)
          connections[[request.host, request.port]] ||= begin
            connection = Net::HTTP.new(request.host, request.port)
            connection.start
            connection
          end
        end

        def net_request_for(request)
          klass = case request.request_method
                  when 'DELETE' then Net::HTTP::Delete
                  when 'GET'    then Net::HTTP::Get
                  when 'HEAD'   then Net::HTTP::Head
                  when 'POST'   then Net::HTTP::Post
                  when 'PUT'    then Net::HTTP::Put
                  end

          klass.new(request.path, headers(request.env))
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
          Rack::Response.new(body, net_response.code.to_i, parse_headers(net_response)).finish
        end

        def headers(env)
          env.inject({}) do |h,(k,v)|
            k =~ /^HTTP_(.*)$/ ?  h.update($1 => v) : h
          end
        end

        def parse_headers(net_response)
          headers = {}
          net_response.each do |(k,v)|
            headers.update(clean_header(k) => v)
          end
          headers
        end

        def clean_header(header)
          header.gsub(/(\w+)/) do |matches|
            matches.sub(/^./) do |char|
              char.upcase
            end
          end
        end

        def connections
          @connections ||= {}
        end
      end
    end
  end
end
