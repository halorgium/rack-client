require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client, "without middleware" do
  context "at the instance level" do
    it "returns an empty body" do
      response = Rack::Client.resource.get("http://localhost:9292/empty")
      response.status.should == 200
      response.headers["Content-Type"].should == "text/html"
      response.headers["Content-Length"].should == "0"
      response.body.should == ""
    end

    it "returns a 302" do
      response = Rack::Client.resource.get("http://localhost:9292/redirect")
      response.status.should == 302
      response["Location"].should == "/after-redirect"
    end

    it "posts data" do
      response = Rack::Client.resource.post("http://localhost:9292/posted", "some data")
      response.status.should == 201
      response["Created"].should == "awesome"
    end
  end

  context "at the class level" do
    it "returns an empty body" do
      response = Rack::Client.get("http://localhost:9292/empty")
      response.status.should == 200
      response.headers["Content-Type"].should == "text/html"
      response.headers["Content-Length"].should == "0"
      response.body.should == ""
    end

    it "returns a 302" do
      response = Rack::Client.get("http://localhost:9292/redirect")
      response.status.should == 302
      response["Location"].should == "/after-redirect"
    end

    it "posts data" do
      response = Rack::Client.post("http://localhost:9292/posted", "some data")
      response.status.should == 201
      response["Created"].should == "awesome"
    end
  end

  context "at the rack-test level" do
    include Rack::Test::Methods
    def app() Rack::Client.resource end
    
    it "returns an empty body" do
      get "http://localhost:9292/empty"
      last_response.status.should == 200
      last_response.headers["Content-Type"].should == "text/html"
      last_response.headers["Content-Length"].should == "0"
      last_response.body.should == ""
    end

    it "returns a 302" do
      get "http://localhost:9292/redirect"
      last_response.status.should == 302
      last_response["Location"].should == "/after-redirect"
    end

    it "posts data" do
      post "http://localhost:9292/posted", "some data"
      last_response.status.should == 201
      last_response["Created"].should == "awesome"
    end
  end
end
