require 'spec_helper'

describe Rack::Client::Parser::JSON do
  sync_handler_contexts(Rack::Client::Parser) do
    it 'parses json and makes it ruby' do
      request { get('/json/json') }
      response { body.should == {"key" => "value"} }
    end
  end
end
