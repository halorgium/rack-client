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

  unless RUBY_VERSION == '1.9.2'
    gem 'ruby-debug'
    gem 'mongrel'
    gem 'cgi_multipart_eof_fix'
  else
    gem 'ruby-debug19'
    gem 'em-synchrony'
  end
end
