require 'spec_helper'

share_examples_for "Asynchronous Request API" do
  class AsyncProxy < Struct.new(:subject, :callback)
    def method_missing(method, *a)
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
    proxy = AsyncProxy.new(self, method(:callback))
    proxy.instance_eval(&@_response_block)
  end

  def callback(response)
    response.instance_eval(&@_response_block)
  end

  it_should_behave_like "Handler API"
end
