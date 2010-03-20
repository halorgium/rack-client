require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client, "with a standard piece of Rack middleware" do
  it "successfully uses that middleware" do
    client = Rack::Client.new { use Rack::ETag }
    response = client.get("http://localhost:#{@server.port}/no-etag")
    response.status.should == 200
    response.headers["ETag"].should_not be_empty
  end
end
