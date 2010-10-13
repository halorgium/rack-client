require 'spec_helper'

describe Rack::Lint do
  sync_handler_contexts(Rack::Lint) do
    it 'will work with Rack::Lint right out of the box' do
      request   { get('/hello_world') }
      response  { body.should == 'Hello World!' }
    end
  end
end
