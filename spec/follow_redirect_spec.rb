require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client::FollowRedirects do
  let(:client) do
    Rack::Client.new("http://localhost:#{server.port}") do
      use Rack::Client::FollowRedirects
      run Rack::Client::Handler::NetHTTP
    end
  end

  context 'Synchronous API' do
    it "follows redirects" do
      response = client.get("http://localhost:#{server.port}/redirect")
      response.status.should == 200
      response.body.to_s.should == "after redirect"
    end
  end

  context 'Asynchronous API' do
    it "follows redirects" do
      client.get("http://localhost:#{server.port}/redirect") do |response|
        response.status.should == 200
        response.body.to_s.should == "after redirect"
      end
    end
  end
end
