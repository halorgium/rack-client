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

  if RUBY_VERSION =~/^1.9/
    gem 'debugger' if RUBY_ENGINE == 'ruby'
    gem 'em-synchrony'
  elsif RUBY_VERSION =~ /^2.0/
    gem 'em-synchrony'
  else
    gem 'ruby-debug'
    gem 'mongrel'
    gem 'cgi_multipart_eof_fix'
  end
end
