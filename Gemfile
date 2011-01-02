source "http://rubygems.org"

gemspec

group :optional do
  gem 'rack-cache', :require => 'rack/cache'
  gem 'rack-contrib', :require => 'rack/contrib'
end

group :test do
  gem 'rake'
  gem 'sinatra', :require => 'sinatra/base'
  gem 'realweb'
end

if defined?(RUBY_ENGINE)
  case RUBY_ENGINE
  when 'rbx'
    gem 'mongrel'
    group :test do
      gem 'rspec', '>=2.0.0'
    end
  when 'jruby'
    group :test do
      gem 'rspec',      :git => 'git://github.com/rspec/rspec.git'
      gem 'rspec-core', :git => 'git://github.com/rspec/rspec-core.git'
      gem 'rspec-mocks', :git => 'git://github.com/rspec/rspec-mocks.git'
      gem 'rspec-expectations', :git => 'git://github.com/rspec/rspec-expectations.git'
    end
  end
else
  gem 'ruby-debug'
  gem 'mongrel'
  group :test do
    gem 'rspec', '>=2.0.0'
  end
end
