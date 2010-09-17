require 'spec_helper'

shared_examples_for "Handler API" do

  subject do
    Rack::Client.new { run handler_class.new(@base_url) }
  end

  describe 'GET request' do
    it 'has the correct status code' do
      request   { get('/hello_world') }
      response  { status.should == 200 }
    end
  end
end
