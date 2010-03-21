require File.dirname(__FILE__) + '/../spec_helper'

share_examples_for "Rack Compliant Adapter" do
  context 'GET request' do
    it 'has the proper response for a basic request' do
      response = client.get("/ping")
      response.status.should == 200
      response.body.to_s.should == 'pong'
    end
  end
end
