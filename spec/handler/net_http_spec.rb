require 'spec_helper'

describe Rack::Client::Handler::NetHTTP do
  async_handler_context(Rack::Client::Handler::NetHTTP) do
    it_should_behave_like "Handler API"
  end

  sync_handler_context(Rack::Client::Handler::NetHTTP) do
    it_should_behave_like "Handler API"
  end
end
