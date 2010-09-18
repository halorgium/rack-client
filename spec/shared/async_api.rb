module AsyncApi
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
  ensure
    finish
  end

  def finish
    #noop
  end
end
