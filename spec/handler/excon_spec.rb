require File.dirname(__FILE__) + '/../spec_helper'

describe Rack::Client::Handler::Excon do
  let(:client) { Rack::Client.new { run Rack::Client::Handler::Excon.new("http://localhost:#{server.port}") } }

  it_should_behave_like "Synchronous Request API"
  it_should_behave_like "Asynchronous Request API"
end
