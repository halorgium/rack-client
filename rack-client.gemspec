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

  s.add_dependency('rack', '>=1.0.0')

  s.add_development_dependency('excon')
  s.add_development_dependency('em-http-request')
  s.add_development_dependency('faraday', '>= 0.9.0.rc1')
  s.add_development_dependency('json', '~> 1.8.1')
  s.add_development_dependency('realweb')
  s.add_development_dependency('rspec', '~> 2.99.0')
  s.add_development_dependency('sinatra', '~> 1.4.5')
  s.add_development_dependency('typhoeus')


  if RUBY_VERSION >= '1.9'
    s.add_development_dependency('em-synchrony', '~> 1.0.3')
  elsif RUBY_VERSION < '1.9'
    s.add_development_dependency('mongrel', '~> 1.1.5')
    s.add_development_dependency('ruby-debug', '~> 0.10.4')
    s.add_development_dependency('cgi_multipart_eof_fix', '~> 2.5.0')
  end
end
