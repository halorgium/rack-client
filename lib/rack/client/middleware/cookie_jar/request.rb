module Rack
  module Client
    module CookieJar
      class Request < Rack::Request
        def inject(cookies)
          if raw_cookies = env['HTTP_COOKIE']
            cookies = Cookie.merge(cookies, raw_cookies)
          end

          env['HTTP_COOKIE'] = cookies.map {|c| c.to_header } * ', ' unless cookies.empty?
        end
      end
    end
  end
end
