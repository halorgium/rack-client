require File.dirname(__FILE__) + '/../spec_helper'

describe Rack::Client::Handler::EmHttp do
  include EM::Spec

  def client
     Rack::Client.new { run Rack::Client::Handler::EmHttp.new("http://localhost:#{server.port}") }
  end

  def finish
    done
  end

  before(:each) { done }
  after(:each) { done }

  it_should_behave_like "Asynchronous Request API"
end
