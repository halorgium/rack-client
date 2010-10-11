require 'spec_helper'

describe Rack::Client::Handler::Typhoeus do
  async_handler_context(Rack::Client::Handler::Typhoeus) do
    it_should_behave_like "Handler API"
  end

  sync_handler_context(Rack::Client::Handler::Typhoeus) do
    it_should_behave_like "Handler API"
  end
end
