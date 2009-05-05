require File.dirname(__FILE__) + '/helper'

context "RackClient with an Auth::Basic middleware" do
  specify "succeeds with authorization" do
    client = RackClient.configure do
      use RackClient::Auth::Basic, "username", "password"
    end
    response = client.get("http://localhost:9292/auth/ping")
    response.status.should.equal 200
    response.headers["Content-Type"].should.equal"text/html"
    response.body.should.equal"pong"
  end

  specify "fails with authorization" do
    client = RackClient.configure do
      use RackClient::Auth::Basic, "username", "fail"
    end
    response = client.get("http://localhost:9292/auth/ping")
    response.status.should.equal 401
    response.body.should.equal ""
  end
end
