require 'spec_helper'

describe Rack::Client::Headers do
  context ".from" do
    it 'rejects headers which do not do not start with HTTP_, excluding CONTENT_TYPE and CONTENT_LENGTH' do
      headers = Rack::Client::Headers.from('rack.foo' => 'bar',
                                           'HTTP_X_RACK_FOO' => 'bar',
                                           'CONTENT_TYPE' => 'text/plain',
                                           'CONTENT_LENGTH' => 100)
      expect(headers['rack.foo']).to be_nil
      expect(headers['HTTP_X_RACK_FOO']).to eq('bar')
      expect(headers['CONTENT_TYPE']).to eq('text/plain')
      expect(headers['CONTENT_LENGTH']).to eq(100)
    end
  end

  context "#initialize" do
    it 'merges in any arguments' do
      Rack::Client::Headers.new('HTTP_X_RACK_FOO' => 'bar')['HTTP_X_RACK_FOO'] = 'bar'
    end
  end

  context "#to_http" do
    it 'removes the leading "HTTP_" from headers' do
      headers = Rack::Client::Headers.new('HTTP_X_RACK_FOO' => 'bar').to_http
      expect(headers.keys.detect {|header| header =~ /^HTTP_/ }).to be_nil
    end

    it 'Titleizes the header name' do
      headers = Rack::Client::Headers.new('HTTP_X_RACK_FOO' => 'bar').to_http
      expect(headers['X-Rack-Foo']).to eq('bar')
    end
  end

  context "#to_env" do
    it 'rackifies http header names, except CONTENT_TYPE and CONTENT_LENGTH' do
      headers = Rack::Client::Headers.new('rack.foo' => 'bar',
                                          'X-Rack-Foo' => 'bar',
                                          'CONTENT_TYPE' => 'text/plain',
                                          'CONTENT_LENGTH' => 100).to_env

      expect(headers['HTTP_X_RACK_FOO']).to eq('bar')
      expect(headers['CONTENT_TYPE']).to eq('text/plain')
      expect(headers['CONTENT_LENGTH']).to eq(100)
    end
  end
end
