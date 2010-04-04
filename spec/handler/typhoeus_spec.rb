require File.dirname(__FILE__) + '/../spec_helper'

describe Rack::Client::Handler::Excon do

  def client
    Rack::Client::Handler::Typhoeus # manual autoload :(

    hydra = self.hydra
    Rack::Client.new { run Rack::Client::Handler::Typhoeus.new("http://localhost:#{server.port}", hydra) }
  end

  def hydra
    @@hydra ||= Typhoeus::Hydra.new
  end

  def finish
    hydra.run
  end

  it_should_behave_like "Synchronous Request API"
  it_should_behave_like "Asynchronous Request API"
end
