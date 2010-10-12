require 'spec_helper'

describe Rack::ETag do
  sync_handler_contexts(Rack::ETag) do
    it 'will work with Rack::ETag right out of the box' do
      request   { get('/hello_world') }
      response  { headers['ETag'].should == %Q{"#{Digest::MD5.hexdigest(body)}"} }
    end
  end
end
