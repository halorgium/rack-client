require File.dirname(__FILE__) + '/../spec_helper'

share_examples_for "Asynchronous Request API" do
  context 'DELETE request' do
    it 'can handle a No Content response' do
      client.delete("/shelf/ctm") do |response|
        response.status.should == 204
      end
    end
  end

  context 'GET request' do
    it 'has the proper response for a basic request' do
      client.get("/ping") do |response|
        response.status.should == 200
        response.body.to_s.should == 'pong'
        response["Content-Type"].should == 'text/html'
        response["Content-Length"].to_i.should == 4
      end
    end

    it 'can handle a temporary redirect response' do
      client.get("/redirect") do |response|
        response.status.should == 302
        response["Location"].should == "/after-redirect"
      end
    end

    it 'can return an empty body' do
      client.get("/empty") do |response|
        response.body.should be_empty
      end
    end
  end

  context 'HEAD request' do
    it 'can handle ETag headers' do
      client.head("/shelf") do |response|
        response.status.should == 200
        response["ETag"].should == "828ef3fdfa96f00ad9f27c383fc9ac7f"
      end
    end
  end

  context 'POST request' do
    it 'can send a request body' do
      client.post("/posted", {}, {}, "some data") do |response|
        response.status.should == 201
        response["Created"].should == "awesome"
      end
    end
  end

  context 'PUT request' do
    it 'can send a request body' do
      client.put("/shelf/ctm", {}, {}, "some data") do |response|
        response.status.should == 200
        response["Location"].should == "/shelf/ctm"
      end
    end
  end
end
