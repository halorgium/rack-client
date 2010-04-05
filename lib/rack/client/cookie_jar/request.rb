module Rack
  module Client
    module CookieJar
      class Request < Rack::Request
        def initialize(env, heap)
          super(env)
          @heap = heap
        end

        def env
          cookie_headers.merge(super)
        end

        def cookie_headers
          return {} if cookies.empty?
          return 'HTTP_COOKIE' => cookies.map {|c| c.to_header } * ', '
        end

        def cookies
          @heap.inject([]) do |cookies, (key,cookie)|
            case request_key
            when key  then cookies << cookie
            end

            cookies
          end
        end

        def request_key
          @request_key ||= Key.new(nil, host, path)
        end
      end
    end
  end
end
