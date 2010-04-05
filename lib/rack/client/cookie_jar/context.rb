module Rack
  module Client
    module CookieJar
      class Context
        def initialize(app)
          @app = app
        end

        def call(env)
          request   = Request.new(env, heap)
          response  = Response.new(heap, *@app.call(request.env))

          key = Key.new(nil, request.host, request.path)
          cookies = heap.select {|(k,_)| k === key }.map {|a| a.last }

          response['rack-client-cookiejar.cookies'] = cookies.map {|c| c.to_header } * ', '

          response.finish
        end

        def heap
          @heap ||= {}
        end
      end
    end
  end
end
