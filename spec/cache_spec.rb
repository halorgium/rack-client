require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client::Cache do
  let(:client) do
    Rack::Client.new("http://localhost:#{server.port}") do
      use Rack::Client::Cache
      run Rack::Client::Handler::NetHTTP
    end
  end

  it "successfully retrieves cache hits" do
    response = client.get("http://localhost:#{server.port}/cacheable")
    response.headers['X-Rack-Client-Cache'].should include('store')
    original_body = response.body

    response = client.get("http://localhost:#{server.port}/cacheable")
    response.headers['X-Rack-Client-Cache'].should include('fresh')
    response.body.should == original_body
  end
end
