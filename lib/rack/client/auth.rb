module Rack::Client::Auth
  class Basic
    def initialize(app, username, password)
      @app, @username, @password = app, username, password
    end

    def call(env)
      encoded_login = ["#{@username}:#{@password}"].pack("m*")
      env['HTTP_AUTHORIZATION'] = "Basic #{encoded_login}"
      @app.call(env)
    end
  end
end
