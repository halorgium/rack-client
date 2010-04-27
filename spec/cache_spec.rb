require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client::Cache do
  let(:client) do
    Rack::Client.new("http://localhost:#{server.port}") do
      use Rack::Client::Cache
      run Rack::Client::Handler::NetHTTP
    end
  end

  after(:each) do
    Rack::Client::Cache::Storage.instance.clear
  end

  context 'Synchronous API' do
    it "successfully retrieves cache hits" do
      response = client.get("http://localhost:#{server.port}/cacheable")
      response.headers['X-Rack-Client-Cache'].should include('store')
      original_body = response.body

      response = client.get("http://localhost:#{server.port}/cacheable")
      response.headers['X-Rack-Client-Cache'].should include('fresh')
      response.body.should == original_body
    end
  end

  context 'Asynchronous API' do
    it "successfully retrieves cache hits" do
      client.get("http://localhost:#{server.port}/cacheable") do |response|
        response.headers['X-Rack-Client-Cache'].should include('store')
        original_body = response.body

        client.get("http://localhost:#{server.port}/cacheable") do |response|
          response.headers['X-Rack-Client-Cache'].should include('fresh')
          response.body.should == original_body
        end
      end
    end
  end
end
