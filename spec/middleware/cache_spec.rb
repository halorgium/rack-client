require 'spec_helper'

describe Rack::Client::Cache do
  sync_handler_contexts(Rack::Client::Cache) do
    after do
      Rack::Client::Cache::Storage.instance.clear
    end

    it 'can retrieve a cache hit' do
      original_body = nil

      request { get('/cache/able') }
      response do
        headers['X-Rack-Client-Cache'].should == 'store'
        original_body = body
      end

      request { get('/cache/able') }
      response do
        headers['X-Rack-Client-Cache'].should == 'fresh'
        body.should == original_body
      end
    end
  end
end
