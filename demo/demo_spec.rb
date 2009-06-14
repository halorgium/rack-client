require File.expand_path(File.dirname(__FILE__) + "/demo")
require "rubygems"
require "spec"
require "rack"
require "rack/test"
require "rack/client"

describe Demo, "/store resource" do
  include Rack::Test::Methods
  def app
    # Be sure to run "rackup" on the config.ru in this demo directory
    Rack::Client.new
    # Demo::App.new
  end
  before(:all) { delete "http://localhost:9292/store" }  
  after { delete "http://localhost:9292/store" }

  it "should return a 404 if a resource does not exist" do
    get "http://localhost:9292/store/does-not-exist"
    last_response.status.should == 404
    last_response.body.should be_empty
  end

  it "should be able to store and retrieve invididual items" do
    put "http://localhost:9292/store/fruit", "strawberry"
    put "http://localhost:9292/store/car", "lotus"
    get "http://localhost:9292/store/fruit"
    last_response.status.should == 200
    last_response.body.should == "strawberry"
    get "http://localhost:9292/store/car"
    last_response.status.should == 200    
    last_response.body.should == "lotus"        
  end

  it "should be able to clear the store of all items" do
    put "http://localhost:9292/store/fruit", "strawberry"
    put "http://localhost:9292/store/car", "lotus"
    delete "http://localhost:9292/store"
    get "http://localhost:9292/store/fruit"
    last_response.status.should == 404
    last_response.body.should be_empty
    get "http://localhost:9292/store/car"
    last_response.status.should == 404
    last_response.body.should be_empty
  end

  it "should be able to clear the store of an invididual item" do
    put "http://localhost:9292/store/fruit", "strawberry"
    delete "http://localhost:9292/store/fruit"
    get "http://localhost:9292/store/fruit"
    last_response.status.should == 404
    last_response.body.should be_empty
  end
end
