module Rack
  module Client
    module CookieJar
      class Context
        include Options
        include DualBand

        def initialize(app, options = {})
          @app = app

          initialize_options options
        end

        def sync_call(env)
          request = Request.new(env)
          cookies = lookup(request)
          request.inject(cookies)

          response = Response.new(*@app.call(request.env))
          cookies = Cookie.merge(cookies, response.cookies)
          store cookies

          response['rack-client-cookiejar.cookies'] = cookies.map {|c| c.to_header } * ', ' unless cookies.empty?
          response.finish
        end

        def async_call(env)
          request = Request.new(env)
          cookies = lookup(request)
          request.inject(cookies)

          @app.call(request.env) do |request_parts|
            response  = Response.new(*request_parts)
            cookies   = Cookie.merge(cookies, response.cookies)
            store cookies

            response['rack-client-cookiejar.cookies'] = cookies.map {|c| c.to_header } * ', ' unless cookies.empty?
            yield response.finish
          end
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
