require 'sinatra/base'

class Post < Sinatra::Base
  post '/echo' do
    response = []
    env['rack.input'].each do |chunk|
      response << chunk
    end

    status 200
    response
  end
end

run Post
