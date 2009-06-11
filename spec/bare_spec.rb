require File.dirname(__FILE__) + '/spec_helper'

context "RackClient with middleware" do
  specify "returns an empty body" do
    client = RackClient.configure
    response = client.get("http://localhost:9292/empty")
    response.status.should == 200
    response.headers["Content-Type"].should == "text/html"
    response.headers["Content-Length"].should == "0"
    response.body.should == ""
  end

  specify "returns a 302" do
    client = RackClient.configure
    response = client.get("http://localhost:9292/redirect")
    response.status.should == 302
    response["Location"].should == "/after-redirect"
  end


  specify "posts data" do
    client = RackClient.configure
    response = client.post("http://localhost:9292/posted", "some data")
    response.status.should == 201
    response["Created"].should == "awesome"
  end
end
