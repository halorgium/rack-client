require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client, "with an Auth::Basic middleware" do
  it "succeeds with authorization" do
    client = Rack::Client.new do
      use Rack::Client::Auth::Basic, "username", "password"
    end
    response = client.get("http://localhost:#{@server.port}/auth/ping") #, :username => "username")
    response.status.should == 200
    response.headers["Content-Type"].should == "text/html"
    response.body.should == "pong"
  end

  it "fails with authorization" do
    client = Rack::Client.new do
      use Rack::Client::Auth::Basic, "username", "fail"
    end
    response = client.get("http://localhost:#{@server.port}/auth/ping")
    response.status.should == 401
    response.body.should == ""
  end
end
