require 'spec_helper'

describe Rack::Client::Simple do
  it 'adds the user agent header to requests' do
    app = lambda {|env| [200, {}, env['HTTP_USER_AGENT']] }

    client = Rack::Client::Simple.new(app)
    client.get('/hitme').body.should == "rack-client #{Rack::Client::VERSION} (app: Proc)"
  end
end
