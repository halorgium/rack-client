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

    it 'sends user agent' do
      response = conn.get('echo_header', {:name => 'user-agent'}, :user_agent => 'Agent Faraday')
      response.body.should == 'Agent Faraday'
    end

  end

  describe 'POST' do

    it 'send url encoded params' do
      conn.post('echo', :name => 'zack').body.should == %(post {"name"=>"zack"})
    end

    it 'send url encoded nested params' do
      response = conn.post('echo', 'name' => {'first' => 'zack'})
      response.body.should == %(post {"name"=>{"first"=>"zack"}})
    end

    it 'retrieves the response headers' do
      conn.post('echo').headers['content-type'].should =~ %r{text/plain}
    end

    it 'sends files' do
      response = conn.post('file') do |req|
        req.body = {'uploaded_file' => Faraday::UploadIO.new(__FILE__, 'text/x-ruby')}
      end

      response.body.should == 'file faraday_spec.rb text/x-ruby'
    end

  end

  describe 'PUT' do

    it 'send url encoded params' do
      conn.put('echo', :name => 'zack').body.should == %(put {"name"=>"zack"})
    end

    it 'send url encoded nested params' do
      response = conn.put('echo', 'name' => {'first' => 'zack'})
      response.body.should == %(put {"name"=>{"first"=>"zack"}})
    end

    it 'retrieves the response headers' do
      conn.put('echo').headers['content-type'].should =~ %r{text/plain}
    end

  end

  describe 'PATCH' do

    it 'send url encoded params' do
      conn.patch('echo', :name => 'zack').body.should == %(patch {"name"=>"zack"})
    end

  end

  describe 'OPTIONS' do

    specify { conn.run_request(:options, 'echo', nil, {}).body.should == 'options' }

  end

  describe 'HEAD' do

    it 'retrieves no response body' do
      conn.head('echo').body.should == ''
    end

    it 'retrieves the response headers' do
      conn.head('echo').headers['content-type'].should =~ %r{text/plain}
    end

  end
end
