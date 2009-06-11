require File.dirname(__FILE__) + '/spec_helper'

context "RackClient with a FollowRedirects middleware" do
  specify "follows redirects" do
    client = RackClient.configure do
      use RackClient::FollowRedirects
    end
    response = client.get("http://localhost:9292/redirect")
    response.status.should == 200
    response.body.should == "after redirect"
  end
end
