require 'spec_helper'

describe Rack::Client::Simple do

  describe "request headers" do
    let(:app) { lambda {|env| [200, {}, [env['HTTP_X_FOO']]] } }

    it 'will be rackified (e.g. HTTP_*)' do
      client = Rack::Client::Simple.new(app)
      expect(client.get('/', 'X-Foo' => 'bar').body).to eq('bar')
    end
  end

  describe "HTTP_USER_AGENT" do
    let(:app) { lambda {|env| [200, {}, [env['HTTP_USER_AGENT']]] } }

    it 'adds the user agent header to requests' do
      client = Rack::Client::Simple.new(app)
      expect(client.get('/hitme').body).to eq("rack-client #{Rack::Client::VERSION} (app: Proc)")
    end

    it 'can be overridden' do
      client = Rack::Client::Simple.new(app)
      expect(client.get('/foo', 'User-Agent' => 'IE6').body).to eq('IE6')
    end
  end

  describe "HTTP_HOST" do
    let(:app) { lambda {|env| [200, {}, [env['HTTP_HOST']]]} }

    it 'adds the host as the hostname of REQUEST_URI' do
      client = Rack::Client::Simple.new(app, 'http://example.org/')
      expect(client.get('/foo').body).to eq('example.org')
    end

    it 'adds the host and port for explicit ports in the REQUEST_URI' do
      client = Rack::Client::Simple.new(app, 'http://example.org:81/')
      expect(client.get('/foo').body).to eq('example.org:81')
    end

    it 'can be overridden' do
      client = Rack::Client::Simple.new(app, 'http://example.org/')
      expect(client.get('/foo', 'Host' => '127.0.0.1').body).to eq('127.0.0.1')
    end
  end

  describe "REQUEST_URI" do
    let(:app) { lambda {|env| [200, {}, [env['REQUEST_URI']]]} }

    it 'uses the base uri if the url is relative' do
      client = Rack::Client::Simple.new(app, 'http://example.org/')
      expect(client.get('/foo').body).to eq('http://example.org/foo')
    end

    it 'does not use the base uri if the url is absolute' do
      client = Rack::Client::Simple.new(app, 'http://example.org/')
      expect(client.get('http://example.com/bar').body).to eq('http://example.com/bar')
    end

    it 'should accept a URI as the url' do
      client = Rack::Client::Simple.new(app, 'http://example.org/')
      expect(client.get(URI('http://example.com/bar')).body).to eq('http://example.com/bar')
    end
  end

  describe '.use' do
    it 'injects a middleware' do
      middleware = Struct.new(:app) do
        def call(env)
          [200, {}, ['Hello Middleware!']]
        end
      end

      klass = Class.new(Rack::Client::Simple) do
        use middleware
      end

      client = klass.new(lambda {|_| [500, {}, ['FAIL']] })
      expect(client.get('/').body).to eq('Hello Middleware!')
    end
  end
end
