source "http://rubygems.org"

gemspec

group :optional do
  gem 'rack-cache', :require => 'rack/cache'
  gem 'rack-contrib', :require => 'rack/contrib'
end

group :test do
  gem 'rake'
  gem 'sinatra', :require => 'sinatra/base'
  gem 'rspec',      :git => 'git://github.com/rspec/rspec.git'
  gem 'rspec-core', :git => 'git://github.com/rspec/rspec-core.git'
  gem 'rspec-mocks', :git => 'git://github.com/rspec/rspec-mocks.git'
  gem 'rspec-expectations', :git => 'git://github.com/rspec/rspec-expectations.git'
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
