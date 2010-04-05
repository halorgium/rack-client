module Rack
  module Client
    module CookieJar
      class Response < Rack::Response
        def initialize(heap, status, headers, body)
          super(body, status, headers)
          @heap = heap

          save_cookies!
        end

        def save_cookies!
          cookies.each do |cookie|
            @heap[cookie.key] = cookie
          end
        end

        def cookies
          return [] unless cookie_header

          @cookies ||= cookie_header.last.split(', ').map do |part|
              Cookie.from(part)
            end
        end

        def cookie_header
          @cookie_header ||= headers.detect {|h,_| h =~ /^SET-COOKIE$/i }
        end
      end
    end
  end
end
