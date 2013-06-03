require 'spec_helper'
require 'rack/client/adapter/faraday'

describe Faraday::Adapter::RackClient do

  let(:url) { URI.join(@base_url, '/faraday') }

  let(:conn) do
    Faraday.new(:url => url) do |faraday|
      faraday.adapter(:rack_client) do |builder|
        builder.use Rack::Lint
        builder.run Rack::Client::Handler::NetHTTP.new
      end
    end
  end

  describe 'GET' do

    it 'retrieves the response body' do
      conn.get('echo').body.should == 'get'
    end

  end
end
