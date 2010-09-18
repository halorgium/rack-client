require 'sinatra/base'

class Delete < Sinatra::Base
  delete '/no-content' do
    status 204
    ''
  end
end

run Delete
