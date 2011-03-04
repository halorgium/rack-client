require 'spec_helper'

describe Rack::Client::Handler::EmSynchrony do
  sync_handler_context(Rack::Client::Handler::EmSynchrony) do
    it_should_behave_like "Handler API"
  end
end
