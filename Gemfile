source "http://rubygems.org"

gemspec

group :optional do
  gem 'rack-cache', :require => 'rack/cache'
  gem 'rack-contrib', :require => 'rack/contrib'
end

group :test do
  gem 'rake'
  gem 'sinatra', :require => 'sinatra/base'
  gem 'rspec',    '>=2.0.0'
  gem 'realweb'
end

if defined?(RUBY_ENGINE)
  case RUBY_ENGINE
  when 'rbx'
    gem 'mongrel'
  end

else
  gem 'ruby-debug'
  gem 'mongrel'
end
