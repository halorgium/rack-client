require 'spec_helper'
require 'rack/client/adapter/faraday'

describe Faraday::Adapter::RackClient do

  let(:url) { @base_url }

  let(:conn) do
    Faraday.new(:url => url) do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded

      faraday.adapter(:rack_client) do |builder|
        builder.use Rack::Lint
        builder.run LiveServer
      end
    end
  end

  describe 'GET' do

    it 'retrieves the response body' do
      conn.get('echo').body.should == 'get'
    end

    it 'send url encoded params' do
      conn.get('echo', :name => 'zack').body.should == %(get ?{"name"=>"zack"})
    end

    it 'retrieves the response headers' do
      response = conn.get('echo')

      response.headers['Content-Type'].should =~ %r{text/plain}
      response.headers['content-type'].should =~ %r{text/plain}
    end

    it 'handles headers with multiple values' do
      conn.get('multi').headers['set-cookie'].should == 'one, two'
    end

    it 'with body' do
      response = conn.get('echo') do |req|
        req.body = {'bodyrock' => true}
      end

      response.body.should == %(get {"bodyrock"=>"true"})
    end

  end
end
