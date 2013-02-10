require 'spec_helper'

describe Rack::Client::Handler::EmHttp do
  unless mri_187?
    async_handler_context(Rack::Client::Handler::EmHttp) do
      it_should_behave_like "Handler API"
    end

    if defined?(EM::Synchrony)
      sync_handler_context(Rack::Client::Handler::EmHttp) do
        it_should_behave_like "Handler API"
      end
    end
  end
end
