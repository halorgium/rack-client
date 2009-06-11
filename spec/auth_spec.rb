require File.dirname(__FILE__) + '/spec_helper'

context "RackClient with an Auth::Basic middleware" do
  specify "succeeds with authorization" do
    client = RackClient.configure do
      use RackClient::Auth::Basic, "username", "password"
    end
    response = client.get("http://localhost:9292/auth/ping")
    response.status.should == 200
    response.headers["Content-Type"].should == "text/html"
    response.body.should == "pong"
  end

  specify "fails with authorization" do
    client = RackClient.configure do
      use RackClient::Auth::Basic, "username", "fail"
    end
    response = client.get("http://localhost:9292/auth/ping")
    response.status.should == 401
    response.body.should == ""
  end
end
