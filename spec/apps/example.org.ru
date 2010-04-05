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
    if request.body.read == "some data"
      response["Location"] = "/shelf/#{params[:book]}"
      ""
    else
      raise "Not valid"
    end
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

  get '/cacheable' do
    if env['HTTP_IF_NONE_MATCH'] == '123456789abcde'
      status 304
    else
      response['ETag'] = '123456789abcde'
      Time.now.to_f.to_s
    end
  end

  get '/cookied' do
    if request.cookies.empty?
      response.set_cookie('time', :domain => 'localhost', :path => '/', :value => Time.now.to_f)
      response.set_cookie('time2', :domain => 'localhost', :path => '/cookied', :value => Time.now.to_f)
    end
    ''
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
  map "/auth/basic/" do
    use Rack::Auth::Basic do |username,password|
      username == "username" && password == "password"
    end
    run ExampleOrg
  end

  map "/auth/digest/" do
    use DigestServer, 'My Realm' do |username|
      {"username" => "password"}[username]
    end
    run ExampleOrg
  end

  map "/" do
    run ExampleOrg
  end
end

# vim:filetype=ruby
