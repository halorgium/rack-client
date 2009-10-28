require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client, "without middleware" do
  context "at the instance level" do
    it "returns an empty body" do
      response = Rack::Client.new.get("http://localhost:9292/empty")
      response.status.should == 200
      response.headers["Content-Type"].should == "text/html"
      response.headers["Content-Length"].should == "0"
      response.body.should == ""
    end

    it "returns a 302" do
      response = Rack::Client.new.get("http://localhost:9292/redirect")
      response.status.should == 302
      response["Location"].should == "http://localhost:9292/after-redirect"
    end

    it "heads data" do
      response = Rack::Client.new.head "http://localhost:9292/shelf"
      response.status.should == 200
      response["ETag"].should == "828ef3fdfa96f00ad9f27c383fc9ac7f"
    end

    it "puts data" do
      response = Rack::Client.new.put "http://localhost:9292/shelf/ctm", "some data"
      response.status.should == 200
      response["Location"].should == "http://localhost:9292/shelf/ctm"
    end

    it "deletes data" do
      response = Rack::Client.new.delete "http://localhost:9292/shelf/ctm"
      response.status.should == 204
    end

    it "posts data" do
      response = Rack::Client.new.post("http://localhost:9292/posted", "some data")
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
      response["Location"].should == "http://localhost:9292/after-redirect"
    end

    it "heads data" do
      response = Rack::Client.head "http://localhost:9292/shelf"
      response.status.should == 200
      response["ETag"].should == "828ef3fdfa96f00ad9f27c383fc9ac7f"
    end

    it "puts data" do
      response = Rack::Client.put "http://localhost:9292/shelf/ctm", "some data"
      response.status.should == 200
      response["Location"].should == "http://localhost:9292/shelf/ctm"
    end

    it "deletes data" do
      response = Rack::Client.delete "http://localhost:9292/shelf/ctm"
      response.status.should == 204
    end

    it "posts data" do
      response = Rack::Client.post("http://localhost:9292/posted", "some data")
      response.status.should == 201
      response["Created"].should == "awesome"
    end
  end

  context "at the rack-test level" do
    include Rack::Test::Methods
    def app() Rack::Client.new end

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
      last_response["Location"].should == "http://localhost:9292/after-redirect"
    end

    it "heads data" do
      head "http://localhost:9292/shelf"
      last_response.status.should == 200
      last_response["ETag"].should == "828ef3fdfa96f00ad9f27c383fc9ac7f"
    end

    it "puts data" do
      put "http://localhost:9292/shelf/ctm", "some data"
      last_response.status.should == 200
      last_response["Location"].should == "http://localhost:9292/shelf/ctm"
    end

    it "deletes data" do
      delete "http://localhost:9292/shelf/ctm"
      last_response.status.should == 204
    end

    it "posts data" do
      post "http://localhost:9292/posted", "some data"
      last_response.status.should == 201
      last_response["Created"].should == "awesome"
    end
  end
end
