require "rubygems"
require "rack/client"
require "rack/contrib"

puts "PUT'ing /store/fruit (with strawberry)"
puts
Rack::Client.put "http://localhost:9292/store/fruit", "strawberry"

puts "GET'ing /store/fruit"
response = Rack::Client.get "http://localhost:9292/store/fruit"
puts ">> status: #{response.status}"
puts ">> body: #{response.body.inspect}"
puts ">> etag: #{response.headers["ETag"].inspect}"
puts

puts "GET'ing /store/fruit (with ETag middleware)"
response = Rack::Client.new do
  use Rack::ETag
end.get "http://localhost:9292/store/fruit"
puts ">> status: #{response.status}"
puts ">> body: #{response.body.inspect}"
puts ">> etag: #{response.headers["ETag"].inspect}"
puts

puts "DELETE'ing /store"
Rack::Client.delete("http://localhost:9292/store")
