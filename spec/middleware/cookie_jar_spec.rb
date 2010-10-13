require 'spec_helper'

describe Rack::Client::CookieJar do
  sync_handler_contexts(Rack::Client::CookieJar) do
    it 'includes the cookie in future responses' do
      request { get('/cookie/') }
      response do
        headers['Set-Cookie'].should_not == nil
        headers['rack-client-cookiejar.cookies'].should_not == nil
      end

      request { get('/cookie/') }
      response do
        headers['Set-Cookie'].should == nil
        headers['rack-client-cookiejar.cookies'].should_not == nil
      end
    end
  end
end
