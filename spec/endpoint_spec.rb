require File.dirname(__FILE__) + '/spec_helper'

require 'sinatra/base'

class MyApp < Sinatra::Base
  get "/awesome" do
    "test"
  end
end

describe Rack::Client, "with an Rack app endpoint" do
  let(:client) do
    Rack::Client.new("http://localhost:#{server.port}") do
      run Rack::URLMap.new("http://example.org/" => MyApp)
    end
  end

  describe "with a custom domain" do
    it "returns the body" do
      response = client.get("http://example.org/awesome")
      response.status.should == 200
      response.body.to_s.should == "test"
    end

    it "only functions for that domain" do
      response = client.get("http://example.org/")
      response.status.should == 404
    end
  end
end
