source "http://rubygems.org"

group :runtime do
  gem 'rack', ">=1.0.0"
end

group :optional do
  gem 'rack-cache', :require => 'rack/cache'
  gem 'rack-contrib', :require => 'rack/contrib'
end

group :test do
  group :examples do
    gem 'excon'
    gem 'em-http-request'
    gem 'eventmachine'
    gem 'typhoeus'
    gem 'json'
  end

  gem 'rake'
  gem 'sinatra', :require => 'sinatra/base'
  gem 'rspec',    '>=2.0.0'
  gem 'ruby-debug'
  gem 'mongrel'
  gem 'cgi_multipart_eof_fix'
  gem 'realweb'
end
