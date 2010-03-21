require 'net/http'

module Rack
  module Client
    module Handler
      class NetHTTP
        def self.call(env)
          request = Rack::Request.new(env)

          klass = case request.request_method
                  when 'GET'  then Net::HTTP::Get
                  when 'HEAD' then Net::HTTP::Head
                  end

          perform(klass, request)
        end

        def self.perform(klass, request)
          http = Net::HTTP.new(request.host, request.port)

          http.request(klass.new(request.path, headers(request.env))) do |net_response|
            return parse(net_response)
          end
        end

        def self.headers(env)
          env.inject({}) do |h,(k,v)|
            k =~ /^HTTP_(.*)$/ ?  h.update($1 => v) : h
          end
        end

        def self.parse(net_response)
          Rack::Response.new(net_response.body || [], net_response.code.to_i, parse_headers(net_response))
        end

        def self.parse_headers(net_response)
          headers = {}
          net_response.each do |(k,v)|
            headers.update(clean_header(k) => v)
          end
          headers
        end

        def self.clean_header(header)
          header.gsub(/(\w+)/) do |matches|
            matches.sub(/^./) do |char|
              char.upcase
            end
          end
        end
      end
    end
  end
end
