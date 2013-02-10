require 'sinatra/base'

class Cookie < Sinatra::Base
  get '/' do
    if request.cookies.empty?
      response.set_cookie('time', :domain => 'localhost', :path => '/', :value => Time.now.to_f)
      response.set_cookie('time2', :domain => 'localhost', :path => '/cookie/', :value => Time.now.to_f)
    end
  end
end

run Cookie
