require 'sinatra/base'

class Redirect < Sinatra::Base
  get '/' do
    redirect request.script_name + "/redirected"
  end

  get '/redirected' do
    'Redirected'
  end
end

run Redirect
