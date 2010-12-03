require 'sinatra/base'

class Get < Sinatra::Base
  get '/hello_world' do
    'Hello World!'
  end

  get '/stream' do
    %w[ this is a stream ]
  end

  get '/params' do
    [params[:one], params[:two]].join(' ')
  end
end

run Get
