require 'spec_helper'

describe Rack::Client::Handler::Excon do
  sync_handler_context(Rack::Client::Handler::Excon) do
    it_should_behave_like "Handler API"
  end
end
