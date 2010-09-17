require 'spec_helper'

describe Rack::Client::Handler::EmHttp do
  include AsyncApi

  def handler_app
    Rack::Client::Handler::EmHttp.new(@base_url)
  end

  def finish
    EM.stop
  end

  around do |group|
    EM.run do
      group.call
    end
  end

  it_should_behave_like "Handler API"
end
