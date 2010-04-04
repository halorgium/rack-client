require File.dirname(__FILE__) + '/../../spec_helper'

describe Rack::Client::Auth::Basic do
  context 'Synchronous API' do
    context 'with digest auth middleware' do
      let(:client) do
        Rack::Client.new("http://localhost:#{server.port}") do
          use Rack::Client::Auth::Digest::MD5, "My Realm", "username", "password"
          run Rack::Client::Handler::NetHTTP
        end
      end

      it "succeeds with authorization" do
        response = client.get("http://localhost:#{server.port}/auth/digest/ping")
        response.status.should == 200
        response.headers["Content-Type"].should == "text/html"
        response.body.to_s.should == "pong"
      end
    end

    context 'without digest auth middleware' do
      let(:client) do
        Rack::Client.new("http://localhost:#{server.port}") do
          run Rack::Client::Handler::NetHTTP
        end
      end

      it "fails with authorization" do
        response = client.get("http://localhost:#{server.port}/auth/digest/ping")
        response.status.should == 401
        response.body.to_s.should == ""
      end
    end
  end

  context 'Asynchronous API' do
    context 'with digest auth middleware' do
      let(:client) do
        Rack::Client.new("http://localhost:#{server.port}") do
          use Rack::Client::Auth::Digest::MD5, "My Realm", "username", "password"
          run Rack::Client::Handler::NetHTTP
        end
      end

      it "succeeds with authorization" do
        response = client.get("http://localhost:#{server.port}/auth/digest/ping") do |response|
          response.status.should == 200
          response.headers["Content-Type"].should == "text/html"
          response.body.to_s.should == "pong"
        end
      end
    end

    context 'without digest auth middleware' do
      let(:client) do
        Rack::Client.new("http://localhost:#{server.port}") do
          run Rack::Client::Handler::NetHTTP
        end
      end

      it "fails with authorization" do
        response = client.get("http://localhost:#{server.port}/auth/digest/ping") do |response|
          response.status.should == 401
          response.body.to_s.should == ""
        end
      end
    end
  end
end
