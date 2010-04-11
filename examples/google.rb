$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rack/client'
require 'pp'

client = Rack::Client.new do
  use Rack::Client::FollowRedirects
  run Rack::Client::Handler::NetHTTP
end

# google.com redirects to www.google.com so this is live test for redirection

pp client.get('http://google.com/').status

puts '', '*'*70, ''

# check that ssl is requesting right
pp client.get('https://google.com/').status
