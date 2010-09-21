require 'spec_helper'

describe Rack::Client::Handler::NetHTTP do
  def rackup(builder)
    builder.run Rack::Client::Handler::NetHTTP.new
  end

  context "Asynchronous" do
    include AsyncApi

    it_should_behave_like "Handler API"
    it_should_behave_like "Streamed Response API"
  end

  context "Synchronous" do
    include SyncApi

    it_should_behave_like "Handler API"
  end

end
