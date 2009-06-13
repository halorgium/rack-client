require 'sinatra/base'

class ExampleOrg < Sinatra::Base
  get "/empty" do
    ""
  end

  get "/ping" do
    "pong"
  end

  get "/redirect" do
    redirect request.script_name + "/after-redirect"
  end

  get "/after-redirect" do
    "after redirect"
  end

  head "/shelf" do
    response["ETag"] = "828ef3fdfa96f00ad9f27c383fc9ac7f"
    ""
  end

  put "/shelf/:book" do
    response["Location"] = "/shelf/#{params[:book]}"
    ""
  end

  delete "/shelf/:book" do
    status 204
    ""
  end

  post "/posted" do
    if request.body.read == "some data"
      status 201
      response["Created"] = "awesome"
      ""
    else
      raise "Not valid"
    end
  end

  get "/no-etag" do
    ""
  end
end

require 'pp'
class Debug
  def initialize(app)
    @app = app
  end

  def call(env)
    puts "*" * 80
    puts "env is:"
    pp env
    res = @app.call(env)
    puts "response is:"
    pp res
    puts "*" * 80
    res
  end
end

use Rack::CommonLogger
use Debug if ENV["DEBUG"]

map "http://localhost/" do
  map "/auth/" do
    use Rack::Auth::Basic do |username,password|
      username == "username" && password == "password"
    end
    run ExampleOrg
  end

  map "/" do
    run ExampleOrg
  end
end

# vim:filetype=ruby
