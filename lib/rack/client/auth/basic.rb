module Rack
  module Client
    module Auth
      class Basic
        def initialize(app, username, password)
          @app, @username, @password = app, username, password
        end

        def call(env, &b)
          @app.call(env.merge(auth_header), &b)
        end

        def auth_header
          {'HTTP_AUTHORIZATION' => "Basic #{encoded_login}"}
        end

        def encoded_login
          ["#{@username}:#{@password}"].pack("m*")
        end
      end
    end
  end
end
