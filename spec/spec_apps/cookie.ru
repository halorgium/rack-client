require 'sinatra/base'

class Cookie < Sinatra::Base
  get '/' do
    if request.cookies.empty?
      response.set_cookie('time', :domain => 'localhost', :path => '/', :value => 1359507195.0)
      response.set_cookie('time2', :domain => 'localhost', :path => '/cookie/', :value => 1359507195.0)
    end
  end
end

run Cookie
