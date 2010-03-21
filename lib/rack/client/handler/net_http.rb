require 'net/http'

module Rack
  module Client
    module Handler
      class NetHTTP
        def self.call(env, &block)
          request = Rack::Request.new(env)

          klass = case request.request_method
                  when 'DELETE' then Net::HTTP::Delete
                  when 'GET'    then Net::HTTP::Get
                  when 'HEAD'   then Net::HTTP::Head
                  when 'POST'   then Net::HTTP::Post
                  when 'PUT'    then Net::HTTP::Put
                  end

          perform(klass, request, &block)
        end

        def self.perform(klass, request)
          http = Net::HTTP.new(request.host, request.port)

          body = case request.body
                 when StringIO then request.body.string
                 when IO       then request.body.read
                 when Array    then request.body.to_s
                 when String   then request.body
                 end

          http.request(klass.new(request.path, headers(request.env)), body) do |net_response|
            if block_given?
              yield parse(net_response)
              nil
            else
              return parse(net_response)
            end
          end
        end

        def self.headers(env)
          env.inject({}) do |h,(k,v)|
            k =~ /^HTTP_(.*)$/ ?  h.update($1 => v) : h
          end
        end

        def self.parse(net_response)
          body = (net_response.body.nil? || net_response.body.empty?) ? [] : StringIO.new(net_response.body)
          Rack::Response.new(body, net_response.code.to_i, parse_headers(net_response)).finish
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
