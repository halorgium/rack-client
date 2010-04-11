$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rack/client'
require 'pp'
require 'yaml'
require 'json'

creds = YAML.load_file("#{ENV['HOME']}/.twitter.yml")

client = Rack::Client.new('http://twitter.com') do
  use Rack::Client::Auth::Basic, creds[:username], creds[:password]
  run Rack::Client::Handler::NetHTTP
end

response = client.get('/statuses/public_timeline.json')

response.each do |json|
  JSON.parse(json).each do |item|
    puts item['user']['screen_name']
  end
end
