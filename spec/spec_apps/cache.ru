require 'sinatra/base'

class Cache < Sinatra::Base
  get '/able' do
    if env['HTTP_IF_NONE_MATCH'] == '123456789abcde'
      status 304
    else
      response['ETag'] = '123456789abcde'
      Time.now.to_f.to_s
    end
  end
end

run Cache
