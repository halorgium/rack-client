require File.dirname(__FILE__) + '/helper'

context "RackClient" do
  specify "follows redirects" do
    client = RackClient.configure do
      use RackClient::FollowRedirects
    end
    response = client.get("http://localhost:9292/redirect")
    response.status.should.equal 200
    response.body.should.equal "after redirect"
  end
end
