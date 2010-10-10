require 'spec_helper'

shared_examples_for "Follow Redirect Middleware" do
  it 'will follow a single redirect' do
    request   { get('/redirect') }
    response  { body.should == 'Redirected' }
  end
end

describe Rack::Client::FollowRedirects do

  setup_contexts_for(Rack::Client::FollowRedirects) do

    it 'will follow a single redirect' do
      request   { get('/redirect/') }
      response  { body.should == 'Redirected' }
    end

  end
end
