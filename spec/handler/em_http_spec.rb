require 'spec_helper'

describe Rack::Client::Handler::EmHttp do

  def handler_class
    Rack::Client::Handler::EmHttp
  end

  class AsyncProxy < Struct.new(:subject, :callback)
    def method_missing(*a)
      subject.send(*a, &callback)
    end
  end

  def request(&b)
    @_request_block = b
  end

  def response(&b)
    @_response_block = b
    run
  end

  def run
    proxy = AsyncProxy.new(subject, method(:callback))
    proxy.instance_eval(&@_request_block)
  end

  def callback(response)
    response.instance_eval(&@_response_block)
    EM.stop
  end

  subject do
    Rack::Client::Simple.new(handler_class.new(@base_url))
  end

  around do |group|
    EM.run do
      group.call
    end
  end

  context 'GET request' do
    it 'has the correct status code' do
      request   { get('/hello_world') }
      response  { status.should == 200 }
    end

    it 'has the correct headers' do
      request   { get('/hello_world') }
      response  { headers.keys.should == %w[Content-Type Date Content-Length Connection] }
    end

    it 'has the correct body' do
      request   { get('/hello_world') }
      response  { body.should == 'Hello World!' }
    end
  end
end
