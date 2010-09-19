require 'sinatra/base'

class Get < Sinatra::Base
  get '/hello_world' do
    'Hello World!'
  end
end

run Get
