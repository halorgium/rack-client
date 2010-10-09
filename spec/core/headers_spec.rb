require 'spec_helper'

describe Rack::Client::Headers do
  context ".from" do
    it 'rejects headers which do not do not start with HTTP_, excluding CONTENT_TYPE and CONTENT_LENGTH' do
      headers = Rack::Client::Headers.from('rack.foo' => 'bar',
                                           'HTTP_X_RACK_FOO' => 'bar',
                                           'CONTENT_TYPE' => 'text/plain',
                                           'CONTENT_LENGTH' => 100)
      headers['rack.foo'].should be_nil
      headers['HTTP_X_RACK_FOO'].should == 'bar'
      headers['CONTENT_TYPE'].should == 'text/plain'
      headers['CONTENT_LENGTH'].should == 100
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
      headers.keys.detect {|header| header =~ /^HTTP_/ }.should be_nil
    end

    it 'Titleizes the header name' do
      headers = Rack::Client::Headers.new('HTTP_X_RACK_FOO' => 'bar').to_http
      headers['X-Rack-Foo'].should == 'bar'
    end
  end

  context "#to_env" do
    it 'rackifies http header names, except CONTENT_TYPE and CONTENT_LENGTH' do
      headers = Rack::Client::Headers.new('rack.foo' => 'bar',
                                          'X-Rack-Foo' => 'bar',
                                          'CONTENT_TYPE' => 'text/plain',
                                          'CONTENT_LENGTH' => 100).to_env

      headers['HTTP_X_RACK_FOO'].should == 'bar'
      headers['CONTENT_TYPE'].should == 'text/plain'
      headers['CONTENT_LENGTH'].should == 100
    end
  end
end
