require 'spec_helper'

describe Rack::Client::FollowRedirects do
  handler_contexts(Rack::Client::FollowRedirects) do

    it 'will follow a single redirect' do
      if handler == Rack::Client::Handler::Excon
        pending "https://github.com/geemus/excon/issues/issue/11"
      end

      request   { get('/redirect/') }
      response  { body.should == 'Redirected' }
    end

  end
end
