require File.dirname(__FILE__) + '/../spec_helper'

describe Rack::Client::Handler::NetHTTP do
  let(:client) { Rack::Client.new("http://localhost:#{server.port}") { run Rack::Client::Handler::NetHTTP } }

  it_should_behave_like "Synchronous Request API"
  it_should_behave_like "Asynchronous Request API"
end
