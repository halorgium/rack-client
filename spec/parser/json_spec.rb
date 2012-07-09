require 'spec_helper'

describe Rack::Client::Parser::JSON do
  it "should be returned for application/json" do
    Rack::Client::Parser::Base.lookup("application/json").should == Rack::Client::Parser::JSON
  end
  
  it "should be returned for application/json;charset=utf-8" do
    Rack::Client::Parser::Base.lookup("application/json;charset=utf-8").should == Rack::Client::Parser::JSON
  end
  
  sync_handler_contexts(Rack::Client::Parser) do
    it 'parses json and makes it ruby' do
      request { get('/json/json') }
      response { body.should == {"key" => "value"} }
    end
  end
end
