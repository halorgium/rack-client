require 'net/http'

module Rack
  module Client
    module Handler
      class NetHTTP
        def self.call(env)
          request = Rack::Request.new(env)

          klass = case request.request_method
                  when 'GET'  then Net::HTTP::Get
                  end

          perform(klass, request)
        end

        def self.perform(klass, request)
          http = Net::HTTP.new(request.host, request.port)

          http.request(klass.new(request.path, headers(request.env))) do |response|
            return parse(response)
          end
        end

        def self.headers(env)
          env.inject({}) do |h,(k,v)|
            k =~ /^HTTP_(.*)$/ ?  h.update($1 => v) : h
          end
        end

        def self.parse(response)
          Rack::Response.new(response.body || [], response.code.to_i)
        end
      end
    end
  end
end
