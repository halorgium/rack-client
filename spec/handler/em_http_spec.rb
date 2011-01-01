require 'spec_helper'

unless defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
  describe Rack::Client::Handler::EmHttp do
    async_handler_context(Rack::Client::Handler::EmHttp) do
      it_should_behave_like "Handler API"
    end
  end
end
