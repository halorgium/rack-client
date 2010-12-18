require 'spec_helper'

describe Rack::Client::Simple do
  describe "HTTP_USER_AGENT" do
    it 'adds the user agent header to requests' do
      app = lambda {|env| [200, {}, [env['HTTP_USER_AGENT']]] }

      client = Rack::Client::Simple.new(app)
      client.get('/hitme').body.should == "rack-client #{Rack::Client::VERSION} (app: Proc)"
    end
  end

  describe "HTTP_HOST" do
    let(:app) { lambda {|env| [200, {}, [env['HTTP_HOST']]]} }

    it 'adds the host as the hostname of REQUEST_URI' do
      client = Rack::Client::Simple.new(app, 'http://example.org/')
      client.get('/foo').body.should == 'example.org'
    end

    it 'adds the host and port for explicit ports in the REQUEST_URI' do
      client = Rack::Client::Simple.new(app, 'http://example.org:81/')
      client.get('/foo').body.should == 'example.org:81'
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
