require 'spec_helper'

describe Rack::Client::Handler::EmHttp do
  include AsyncApi

  def rackup(builder)
    builder.run Rack::Client::Handler::EmHttp.new
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
