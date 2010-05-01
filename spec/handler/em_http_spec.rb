require File.dirname(__FILE__) + '/../spec_helper'

if ''.respond_to?(:bytesize) || # String#bytesize defined by em-http-request > 0.2.7
   RUBY_VERSION != '1.8.7'      # em-spec is broken on 1.8.7

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
end
