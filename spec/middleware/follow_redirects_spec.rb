require 'spec_helper'

describe Rack::Client::FollowRedirects do
  handler_contexts(Rack::Client::FollowRedirects) do

    it 'will follow a single redirect' do
      request   { get('/redirect/') }
      response  { body.should == 'Redirected' }
    end

  end
end
