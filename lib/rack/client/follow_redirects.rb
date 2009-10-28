class Rack::Client::FollowRedirects
  include Rack::Test::Methods

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    response = Rack::Response.new(body, status, headers)
    if response.redirect?
      uri = URI.parse(response["Location"])
      new_env = {}
      env.each do |k,v|
        if %w| HTTP_HOST SERVER_NAME SERVER_PORT |.include?(k)
          new_env[k] = v
        end
      end
      new_env["REQUEST_METHOD"] = "GET"
      session = Rack::Test::Session.new(@app)
      env = session.send(:env_for, uri.to_s, new_env)
      call(env)
    else
      [status, headers, body]
    end
  end
end
