require 'spec_helper'

describe Rack::Client::Simple do
  describe "HTTP_USER_AGENT" do
    it 'adds the user agent header to requests' do
      app = lambda {|env| [200, {}, [env['HTTP_USER_AGENT']]] }

      client = Rack::Client::Simple.new(app)
      client.get('/hitme').body.should == "rack-client #{Rack::Client::VERSION} (app: Proc)"
    end
  end

  describe "REQUEST_URI" do
    let(:app) { lambda {|env| [200, {}, [env['REQUEST_URI']]]} }

    it 'uses the base uri if the url is relative' do
      client = Rack::Client::Simple.new(app, 'http://example.org/')
      client.get('/foo').body.should == 'http://example.org/foo'
    end

    it 'does not use the base uri if the url is absolute' do
      client = Rack::Client::Simple.new(app, 'http://example.org/')
      client.get('http://example.com/bar').body.should == 'http://example.com/bar'
    end
  end
end
