require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client, "with a FollowRedirects middleware" do
  it "follows redirects" do
    client = Rack::Client.new do
      use Rack::Client::FollowRedirects
    end
    response = client.get("http://localhost:9292/redirect")
    response.status.should == 200
    response.body.should == "after redirect"
  end
end
