require File.dirname(__FILE__) + '/../spec_helper'

describe Rack::Client::Parser::YAML do
  let(:client) do
    Rack::Client.new("http://localhost:#{server.port}") do
      use Rack::Client::Parser
      run Rack::Client::Handler::NetHTTP
    end
  end

  context 'Synchronous API' do
    it "injects the parsed body into the response" do
      response = client.get("http://localhost:#{server.port}/hash.yml")
      response.headers['rack-client.body_collection'].should == [{:foo => :bar}]
    end

    it "injects the dumped body into the request" do
      response = client.post("http://localhost:#{server.port}/echo", {'rack-client.body_collection' => [{:foo => :bar}], 'Content-Type' => 'application/x-yaml'}, {})
      response.headers['rack-client.body_collection'].should == [{:foo => :bar}]
    end
  end
end
