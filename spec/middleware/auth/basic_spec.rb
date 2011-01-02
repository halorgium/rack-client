require 'spec_helper'

describe Rack::Client::Auth::Basic do
  handler_contexts([Rack::Client::Auth::Basic, 'foo', 'bar']) do
    it 'can authenticate requests' do
      request  { get('/basic_auth/') }
      response { status.should == 200 }
    end
  end

  handler_contexts([Rack::Client::Auth::Basic, 'foo', 'bar', true]) do
    it 'can force authentication for servers that do not challenge' do
      request  { get('/basic_auth/unchallenged/') }
      response { status.should == 200 }
    end
  end
end
