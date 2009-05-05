require File.dirname(__FILE__) + '/helper'

context "RackClient with middleware" do
  specify "returns an empty body" do
    client = RackClient.configure
    response = client.get("http://localhost:9292/empty")
    response.status.should.equal 200
    response.headers["Content-Type"].should.equal "text/html"
    response.headers["Content-Length"].should.equal "0"
    response.body.should.equal ""
  end

  specify "returns a 302" do
    client = RackClient.configure
    response = client.get("http://localhost:9292/redirect")
    response.status.should.equal 302
    response["Location"].should.equal "/after-redirect"
  end
end
