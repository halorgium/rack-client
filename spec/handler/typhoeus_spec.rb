require 'spec_helper'

describe Rack::Client::Handler::Typhoeus do
  def rackup(builder)
    Rack::Client::Handler::Typhoeus # manual autoload :(

    @hydra = Typhoeus::Hydra.new
    builder.run Rack::Client::Handler::Typhoeus.new(@hydra)
  end

  #context "Asynchronous" do
    #include AsyncApi

    #def finish
      #@hydra.run
    #end

    #it_should_behave_like "Handler API"
  #end

  context "Synchronous" do
    include SyncApi

    it_should_behave_like "Handler API"
  end
end
