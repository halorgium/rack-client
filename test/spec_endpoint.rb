require File.dirname(__FILE__) + '/helper'

require 'sinatra/base'

class MyApp < Sinatra::Base
  get "/awesome" do
    "test"
  end
end

context "RackClient with an Rack app endpoint" do
  specify "returns the body" do
    client = RackClient.configure do
      endpoint MyApp
    end
    response = client.get("http://example.org/awesome")
    response.status.should.equal 200
    response.body.should.equal "test"
  end

  context "with a custom domain" do
    specify "returns the body" do
      client = RackClient.configure do
        endpoint MyApp, "http://google.com/"
      end
      response = client.get("http://google.com/awesome")
      response.status.should.equal 200
      response.body.should.equal "test"
    end

    specify "only functions for that domain" do
      client = RackClient.configure do
        endpoint MyApp, "http://google.com/"
      end
      response = client.get("http://example.org/")
      response.status.should.equal 404
    end
  end
end
