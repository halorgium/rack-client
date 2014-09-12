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
      expect(conn.get('echo').body).to eq('get')
    end

    it 'send url encoded params' do
      expect(conn.get('echo', :name => 'zack').body).to eq(%(get ?{"name"=>"zack"}))
    end

    it 'retrieves the response headers' do
      response = conn.get('echo')

      expect(response.headers['Content-Type']).to match(%r{text/plain})
      expect(response.headers['content-type']).to match(%r{text/plain})
    end

    it 'handles headers with multiple values' do
      expect(conn.get('multi').headers['set-cookie']).to eq('one, two')
    end

    it 'with body' do
      response = conn.get('echo') do |req|
        req.body = {'bodyrock' => true}
      end

      expect(response.body).to eq(%(get {"bodyrock"=>"true"}))
    end

    it 'sends user agent' do
      response = conn.get('echo_header', {:name => 'user-agent'}, :user_agent => 'Agent Faraday')
      expect(response.body).to eq('Agent Faraday')
    end

  end

  describe 'POST' do

    it 'send url encoded params' do
      expect(conn.post('echo', :name => 'zack').body).to eq(%(post {"name"=>"zack"}))
    end

    it 'send url encoded nested params' do
      response = conn.post('echo', 'name' => {'first' => 'zack'})
      expect(response.body).to eq(%(post {"name"=>{"first"=>"zack"}}))
    end

    it 'retrieves the response headers' do
      expect(conn.post('echo').headers['content-type']).to match(%r{text/plain})
    end

    it 'sends files' do
      response = conn.post('file') do |req|
        req.body = {'uploaded_file' => Faraday::UploadIO.new(__FILE__, 'text/x-ruby')}
      end

      expect(response.body).to eq('file faraday_spec.rb text/x-ruby')
    end

  end

  describe 'PUT' do

    it 'send url encoded params' do
      expect(conn.put('echo', :name => 'zack').body).to eq(%(put {"name"=>"zack"}))
    end

    it 'send url encoded nested params' do
      response = conn.put('echo', 'name' => {'first' => 'zack'})
      expect(response.body).to eq(%(put {"name"=>{"first"=>"zack"}}))
    end

    it 'retrieves the response headers' do
      expect(conn.put('echo').headers['content-type']).to match(%r{text/plain})
    end

  end

  describe 'PATCH' do

    it 'send url encoded params' do
      expect(conn.patch('echo', :name => 'zack').body).to eq(%(patch {"name"=>"zack"}))
    end

  end

  describe 'OPTIONS' do

    specify { expect(conn.run_request(:options, 'echo', nil, {}).body).to eq('options') }

  end

  describe 'HEAD' do

    it 'retrieves no response body' do
      expect(conn.head('echo').body).to eq('')
    end

    it 'retrieves the response headers' do
      expect(conn.head('echo').headers['content-type']).to match(%r{text/plain})
    end

  end

  describe 'DELETE' do

    it 'retrieves the response headers' do
      expect(conn.delete('echo').headers['content-type']).to match(%r{text/plain})
    end

    it 'retrieves the body' do
      expect(conn.delete('echo').body).to eq(%(delete))
    end

  end
end
