$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rack/client'
require 'pp'

client = Rack::Client.new('http://whoismyrepresentative.com')

pp client.get('/whoismyrep.php?zip=94107').body
pp client.get('/whoismyrep.php', :zip => 94107).body
