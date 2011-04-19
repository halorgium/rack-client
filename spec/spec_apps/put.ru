require 'sinatra/base'

class Put < Sinatra::Base
  put '/sum' do
    a, b = params[:a], params[:b]
    a = a.nil? ? 0 : a.to_i
    b = b.nil? ? 0 : b.to_i

    (a + b).to_s
  end
end

run Put
