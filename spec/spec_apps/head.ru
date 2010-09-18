require 'sinatra/base'

class Head < Sinatra::Base
  head '/etag' do
    response['ETag'] = 'DEADBEEF'
    ''
  end
end

run Head
