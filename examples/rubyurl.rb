$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rack/client'
require 'json'
require 'pp'

client = Rack::Client.new('http://rubyurl.com/')
client.post('/api/links.json', :website_url => 'http://istwitterdown.com/').body.each do |json|
  puts JSON.parse(json)['link']['permalink']
end
