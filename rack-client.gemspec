dir = File.dirname(__FILE__)
require File.expand_path(File.join(dir, 'lib', 'rack', 'client', 'version'))

Gem::Specification.new do |s|
  s.name        = 'rack-client'
  s.version     = Rack::Client::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = "Tim Carey-Smith"
  s.email       = "tim" + "@" + "spork.in"
  s.homepage    = "http://github.com/halorgium/rack-client"
  s.summary     = "A client wrapper around a Rack app or HTTP"
  s.description = s.summary
  s.files       = %w[History.txt LICENSE README.textile Rakefile] + Dir["lib/**/*.rb"] + Dir["demo/**/*.rb"]

  s.add_dependency 'rack', '>=1.0.0'

  s.add_development_dependency 'excon'
  s.add_development_dependency 'em-http-request'
  s.add_development_dependency 'typhoeus'
  s.add_development_dependency 'json'
end
