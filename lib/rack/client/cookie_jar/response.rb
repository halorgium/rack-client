module Rack
  module Client
    module CookieJar
      class Response < Client::Response
        def cookies
          return [] unless set_cookie
          Cookie.parse(set_cookie.last)
        end

        def set_cookie
          @set_cookie ||= headers.detect {|(k,v)| k =~ /Set-Cookie/i }
        end
      end
    end
  end
end
