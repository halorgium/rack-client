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
    #gem 'em-http-request', '~>0.2.7'
    gem 'eventmachine'
    gem 'typhoeus'
    gem 'json'
  end

  gem 'rake'
  gem 'sinatra', :require => 'sinatra/base'
  gem 'rspec', :require => 'spec'
  gem 'ruby-debug'
  gem 'em-spec', '0.2.1', :require => 'em-spec/rspec'
  gem 'bundler'
  gem 'mongrel'
end
