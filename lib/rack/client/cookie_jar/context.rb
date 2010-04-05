module Rack
  module Client
    module CookieJar
      class Context
        include Options

        def initialize(app, options = {})
          @app = app

          initialize_options options
        end

        def call(env)
          request = Request.new(env)
          cookies = lookup(request)
          request.inject(cookies)

          response = Response.new(*@app.call(request.env))
          cookies = Cookie.merge(cookies, response.cookies)
          store cookies

          response['rack-client-cookiejar.cookies'] = cookies.map {|c| c.to_header } * ', ' unless cookies.empty?
          response.finish
        end

        def lookup(request)
          cookiestore.match(request.host, request.path)
        end

        def store(cookies)
          cookies.each do |cookie|
            cookiestore.store(cookie)
          end
        end

        def cookiestore
          uri = options['rack-client-cookiejar.cookiestore']
          storage.resolve_cookiestore_uri(uri)
        end
      end
    end
  end
end
