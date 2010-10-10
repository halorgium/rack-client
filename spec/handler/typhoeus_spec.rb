require 'spec_helper'

describe Rack::Client::Handler::Typhoeus do
  typhoeus_async_context do
    it_should_behave_like "Handler API"
  end

  #TyphoeusHelper.sync_context do
    #it_should_behave_like "Handler API"
  #end
end
