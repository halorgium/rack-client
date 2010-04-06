require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client::CookieJar do
  let(:client) do
    Rack::Client.new("http://localhost:#{server.port}") do
      use Rack::Client::CookieJar
      run Rack::Client::Handler::NetHTTP
    end
  end

  context 'Synchronous API' do
    it 'serves the cookie in future responses' do
      response = client.get("http://localhost:#{server.port}/cookied")
      response['Set-Cookie'].should_not be_nil
      response['rack-client-cookiejar.cookies'].should_not be_nil

      response = client.get("http://localhost:#{server.port}/cookied")
      response['Set-Cookie'].should be_nil
      response['rack-client-cookiejar.cookies'].should_not be_nil
    end
  end

  context 'Asynchronous API' do
    it 'serves the cookie in future responses' do
      client.get("http://localhost:#{server.port}/cookied") do |response|
        response['Set-Cookie'].should_not be_nil
        response['rack-client-cookiejar.cookies'].should_not be_nil

        client.get("http://localhost:#{server.port}/cookied") do |response|
          response['Set-Cookie'].should be_nil
          response['rack-client-cookiejar.cookies'].should_not be_nil
        end
      end
    end
  end
end

