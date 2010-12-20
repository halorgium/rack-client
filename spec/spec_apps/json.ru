require 'sinatra/base'

class Json < Sinatra::Base
  get '/json' do
    content_type :json
    '{"key":"value"}'
  end
end

run Json
