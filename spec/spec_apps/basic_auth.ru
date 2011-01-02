require 'sinatra/base'

class BasicAuth < Sinatra::Base

  use Rack::Auth::Basic do |username, password|
    [username, password] == ['foo', 'bar']
  end

  get '/' do
    status 200
  end
end

class UnchallengedBasicAuth < Sinatra::Base
  get '/' do
    case env['HTTP_AUTHORIZATION']
    when 'Basic ' + %w[foo:bar].pack("m*").chomp then status 200
    else status 404
    end
  end
end

map '/unchallenged' do
  run UnchallengedBasicAuth
end

map '/' do
  run BasicAuth.new
end
