require File.dirname(__FILE__) + '/spec_helper'


describe Rack::Client, "with a standard piece of Rack middleware" do
  context "Rack::ETag" do
    let(:client) do
      Rack::Client.new("http://localhost:#{server.port}") do
        use Rack::ETag
        run Rack::Client::Handler::NetHTTP
      end
    end

    it "successfully uses that middleware" do
      pending "Rack::ETag fixes streaming bodies (http://github.com/rack/rack/commit/f10713cce876d370ee5f1018928521d4b43e0dce)"

      response = client.get("http://localhost:#{server.port}/no-etag")
      response.status.should == 200
      response.headers["ETag"].should_not be_empty
    end
  end

  context "Rack::ETag (fixed for streaming)" do
    let(:client) do
      Rack::Client.new("http://localhost:#{server.port}") do
        use ETagFixed
        run Rack::Client::Handler::NetHTTP
      end
    end

    it "successfully uses that middleware" do
      response = client.get("http://localhost:#{server.port}/no-etag")
      response.status.should == 200
      response.headers["ETag"].should_not be_empty
    end
  end

  context "Rack::Logger" do
    let(:client) do
      Rack::Client.new("http://localhost:#{server.port}") do
        use Rack::Logger
        use LoggerCheck do |logger|
          logger.class.should == Logger
        end
        run Rack::Client::Handler::NetHTTP
      end
    end

    it "successfully uses that middleware" do
      response = client.get("http://localhost:#{server.port}/no-etag")
      response.status.should == 200
    end
  end
end

